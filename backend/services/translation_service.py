import gc
from pathlib import Path

import torch
import soundfile as sf
import torchaudio

from transformers import (
    AutoModel,
    AutoModelForSeq2SeqLM,
    AutoTokenizer,
)

from IndicTransToolkit import IndicProcessor
from schemas.translation import TranslationMode, TranslationRequest


class TranslationService:
    """
    AksharaaSetu AI Translation Service

    Translation:
        IndicTrans2 -> Hindi <-> Santali

    Speech:
        IndicConformer -> Text

    Performance:
        IndicTrans2 is loaded when the backend starts.
        IndicConformer is loaded only when speech is requested.
        IndicConformer is unloaded after speech recognition
        to reduce RAM usage.
    """

    ASR_MODEL = "ai4bharat/indic-conformer-600m-multilingual"

    TRANSLATION_MODEL = (
        "./models/indictrans2-indic-indic-dist-320M"
    )

    LANGUAGE_CODES = {
        "hindi": "hi",
        "hin": "hin_Deva",
        "santali": "sat",
        "sat": "sat",
        "sat_olck": "sat_Olck",
    }

    def __init__(self):
        print()
        print("========================================")
        print("AKSHARAASETU AI SERVICE")
        print("========================================")

        self.device = (
            "cuda"
            if torch.cuda.is_available()
            else "cpu"
        )

        print(f"Device: {self.device}")

        # ====================================================
        # IndicConformer is NOT loaded here.
        # It will be loaded only when speech is requested.
        # ====================================================

        self.asr_model = None
        self.asr_loading = False

        # ====================================================
        # Load IndicTrans2
        # ====================================================

        print()
        print("Loading IndicTrans2...")

        self.translation_tokenizer = (
            AutoTokenizer.from_pretrained(
                self.TRANSLATION_MODEL,
                trust_remote_code=True,
            )
        )

        self.translation_model = (
            AutoModelForSeq2SeqLM.from_pretrained(
                self.TRANSLATION_MODEL,
                trust_remote_code=True,
            )
        )

        self.translation_model.to(self.device)
        self.translation_model.eval()

        self.translation_processor = IndicProcessor(
            inference=True
        )

        print("IndicTrans2 loaded successfully.")

        print()
        print(
            "IndicConformer will load only when speech is used."
        )

        print()
        print("========================================")
        print("AI MODELS READY")
        print("========================================")
        print()

    # ========================================================
    # LAZY LOAD INDICCONFORMER
    # ========================================================

    def _load_asr_model(self):
        """
        Load IndicConformer only when speech recognition
        is actually requested.

        This prevents the large speech model from consuming
        RAM during normal backend startup.
        """

        if self.asr_model is not None:
            return

        if self.asr_loading:
            return

        self.asr_loading = True

        try:
            print()
            print("========================================")
            print("LOADING INDICCONFORMER")
            print("========================================")

            print("Speech model is being loaded...")
            print("This can take some time on CPU.")

            self.asr_model = AutoModel.from_pretrained(
                self.ASR_MODEL,
                trust_remote_code=True,
            )

            self.asr_model.to(self.device)
            self.asr_model.eval()

            print()
            print("IndicConformer loaded successfully.")
            print()

        except Exception:
            self.asr_model = None

            gc.collect()

            if torch.cuda.is_available():
                torch.cuda.empty_cache()

            raise

        finally:
            self.asr_loading = False

    # ========================================================
    # TEXT TRANSLATION
    # ========================================================

    def translate(
        self,
        request: TranslationRequest,
    ) -> dict:

        if request.mode == TranslationMode.speech_to_text:
            return {
                "success": False,
                "mode": request.mode.value,
                "message": (
                    "Use /api/speech-to-speech for audio input."
                ),
                "audio_available": False,
            }

        if request.mode == TranslationMode.speech_to_speech:
            return {
                "success": False,
                "mode": request.mode.value,
                "message": (
                    "Use /api/speech-to-speech for audio input."
                ),
                "audio_available": False,
            }

        if not request.text:
            return {
                "success": False,
                "mode": request.mode.value,
                "message": "Text is required.",
            }

        try:
            translated_text = self.translate_text(
                request.text,
                request.source_language,
                request.target_language,
            )

            return {
                "success": True,
                "mode": request.mode.value,
                "source_language": request.source_language,
                "target_language": request.target_language,
                "source_text": request.text,
                "translated_text": translated_text,
                "editable": True,
                "audio_available": False,
                "translation_provider": "IndicTrans2",
                "message": (
                    "Translation generated successfully."
                ),
            }

        except Exception as e:
            return {
                "success": False,
                "mode": request.mode.value,
                "source_language": request.source_language,
                "target_language": request.target_language,
                "message": str(e),
            }

    # ========================================================
    # INDIC TRANS 2
    # ========================================================

    def translate_text(
        self,
        text: str,
        source_language: str,
        target_language: str,
    ) -> str:

        src_lang = self._get_translation_code(
            source_language
        )

        tgt_lang = self._get_translation_code(
            target_language
        )

        sentences = [text]

        batch = self.translation_processor.preprocess_batch(
            sentences,
            src_lang=src_lang,
            tgt_lang=tgt_lang,
            visualize=False,
        )

        encoded = self.translation_tokenizer(
            batch,
            padding="longest",
            truncation=True,
            max_length=128,
            return_tensors="pt",
        )

        encoded = {
            key: value.to(self.device)
            for key, value in encoded.items()
        }

        with torch.inference_mode():
            outputs = self.translation_model.generate(
                **encoded,
                num_beams=1,
                num_return_sequences=1,
                max_length=128,
                use_cache=True,
            )

        decoded = self.translation_tokenizer.batch_decode(
            outputs,
            skip_special_tokens=True,
            clean_up_tokenization_spaces=True,
        )

        decoded = self.translation_processor.postprocess_batch(
            decoded,
            lang=tgt_lang,
        )

        del encoded
        del outputs

        gc.collect()

        if torch.cuda.is_available():
            torch.cuda.empty_cache()

        return decoded[0]

    # ========================================================
    # SPEECH -> TEXT
    # ========================================================

    def speech_to_text(
        self,
        audio_path: str,
        language: str,
    ) -> str:

        # Load IndicConformer only now.
        self._load_asr_model()

        print()
        print("Loading audio...")

        audio, sample_rate = sf.read(
            audio_path,
            dtype="float32",
        )

        wav = torch.from_numpy(audio)

        if wav.ndim == 1:
            wav = wav.unsqueeze(0)
        else:
            wav = wav.mean(
                dim=1,
                keepdim=True,
            )

        if sample_rate != 16000:

            print(
                f"Resampling {sample_rate} Hz -> 16000 Hz..."
            )

            resampler = torchaudio.transforms.Resample(
                orig_freq=sample_rate,
                new_freq=16000,
            )

            wav = resampler(wav)

            del resampler

        wav = wav.to(self.device)

        asr_language = self._get_asr_language(
            language
        )

        print("Running speech recognition...")

        try:
            with torch.inference_mode():

                text = self.asr_model(
                    wav,
                    asr_language,
                    "ctc",
                )

        finally:
            # ------------------------------------------------
            # IMPORTANT LOW-RAM CLEANUP
            # ------------------------------------------------

            del wav
            del audio

            # Release the large speech model.
            if self.asr_model is not None:
                del self.asr_model
                self.asr_model = None

            gc.collect()

            if torch.cuda.is_available():
                torch.cuda.empty_cache()

            print(
                "IndicConformer unloaded to free RAM."
            )

        return text

    # ========================================================
    # SPEECH -> TRANSLATION
    # ========================================================

    def speech_to_translation(
        self,
        audio_path: str,
        source_language: str,
        target_language: str,
    ) -> dict:

        print()
        print("========================================")
        print("AKSHARAASETU SPEECH PIPELINE")
        print("========================================")

        # ----------------------------------------------------
        # STEP 1
        # Speech -> Text
        # ----------------------------------------------------

        print()
        print("STEP 1: Speech -> Text")

        source_text = self.speech_to_text(
            audio_path,
            source_language,
        )

        print()
        print("Source text:")
        print(source_text)

        # ----------------------------------------------------
        # STEP 2
        # Text -> Translation
        # ----------------------------------------------------

        print()
        print("STEP 2: Text -> Translation")

        translated_text = self.translate_text(
            source_text,
            source_language,
            target_language,
        )

        print()
        print("Translated text:")
        print(translated_text)

        print()
        print("Speech pipeline completed.")

        return {
            "success": True,
            "source_language": source_language,
            "target_language": target_language,
            "source_text": source_text,
            "translated_text": translated_text,
            "audio_url": None,
            "audio_available": False,
            "translation_provider": "IndicTrans2",
            "speech_recognition_provider": (
                "IndicConformer"
            ),
            "message": (
                "Speech recognition and translation "
                "completed successfully. "
                "TTS is not available locally."
            ),
        }

    # ========================================================
    # LANGUAGE HELPERS
    # ========================================================

    def _get_asr_language(
        self,
        language: str,
    ) -> str:

        language = language.lower().strip()

        if language in ("hindi", "hi"):
            return "hi"

        if language in (
            "santali",
            "sat",
            "sat_olck",
        ):
            return "sat"

        raise ValueError(
            f"Unsupported speech language: {language}"
        )

    def _get_translation_code(
        self,
        language: str,
    ) -> str:

        language = language.lower().strip()

        if language in (
            "hindi",
            "hi",
            "hin_deva",
        ):
            return "hin_Deva"

        if language in (
            "santali",
            "sat",
            "sat_olck",
        ):
            return "sat_Olck"

        raise ValueError(
            f"Unsupported translation language: {language}"
        )