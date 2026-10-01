import gc

import torch
import soundfile as sf

from transformers import (
    AutoModel,
    AutoModelForSeq2SeqLM,
    AutoTokenizer,
)

from IndicTransToolkit import IndicProcessor
from parler_tts import ParlerTTSForConditionalGeneration


# ============================================================
# AKSHARAASETU
# HINDI SPEECH -> SANTALI SPEECH
# LOW-MEMORY PIPELINE
# ============================================================

ASR_MODEL = "ai4bharat/indic-conformer-600m-multilingual"

TRANSLATION_MODEL = "./models/indictrans2-indic-indic-dist-320M"

TTS_MODEL = "ai4bharat/indic-parler-tts"

INPUT_AUDIO = "generated_hindi.wav"

OUTPUT_AUDIO = "final_santali.wav"

device = "cuda" if torch.cuda.is_available() else "cpu"


print()
print("========================================")
print("AKSHARAASETU SPEECH PIPELINE")
print("========================================")

print(f"Device: {device}")


# ============================================================
# STEP 1 - LOAD INDICCONFORMER ASR
# ============================================================

print()
print("STEP 1: Loading IndicConformer ASR...")

asr_model = AutoModel.from_pretrained(
    ASR_MODEL,
    trust_remote_code=True,
)

asr_model.eval()

print("ASR loaded successfully.")


# ============================================================
# STEP 2 - LOAD HINDI AUDIO
# ============================================================

print()
print("STEP 2: Loading Hindi audio...")

audio, sample_rate = sf.read(
    INPUT_AUDIO,
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


# ============================================================
# STEP 3 - RESAMPLE TO 16 KHZ
# ============================================================

if sample_rate != 16000:

    print(
        f"Resampling {sample_rate} Hz -> 16000 Hz..."
    )

    import torchaudio

    resampler = torchaudio.transforms.Resample(
        orig_freq=sample_rate,
        new_freq=16000,
    )

    wav = resampler(wav)


# ============================================================
# STEP 4 - HINDI SPEECH -> HINDI TEXT
# ============================================================

print()
print("STEP 3: Hindi Speech -> Hindi Text")

with torch.inference_mode():

    hindi_text = asr_model(
        wav,
        "hi",
        "ctc",
    )

print()
print("Hindi transcription:")
print(hindi_text)


# ============================================================
# IMPORTANT MEMORY CLEANUP
# DELETE ASR BEFORE LOADING INDICTRANS2
# ============================================================

print()
print("Freeing ASR memory before IndicTrans2...")

del asr_model
del wav
del audio

gc.collect()

if torch.cuda.is_available():
    torch.cuda.empty_cache()

print("ASR memory released.")


# ============================================================
# STEP 5 - LOAD INDIC TRANS 2
# ============================================================

print()
print("STEP 4: Loading IndicTrans2...")

translation_tokenizer = AutoTokenizer.from_pretrained(
    TRANSLATION_MODEL,
    trust_remote_code=True,
)

print("Tokenizer loaded.")

translation_model = AutoModelForSeq2SeqLM.from_pretrained(
    TRANSLATION_MODEL,
    trust_remote_code=True,
)

translation_model.eval()

print("IndicTrans2 loaded successfully.")


# ============================================================
# STEP 6 - LOAD INDIC PROCESSOR
# ============================================================

print()
print("STEP 5: Loading IndicTransProcessor...")

ip = IndicProcessor(
    inference=True
)

print("IndicTransProcessor loaded successfully.")


# ============================================================
# STEP 7 - HINDI -> SANTALI
# ============================================================

print()
print("STEP 6: Hindi Text -> Santali Text")

src_lang = "hin_Deva"

tgt_lang = "sat_Olck"

sentences = [
    hindi_text
]


print()
print("Hindi text:")
print(hindi_text)


# ============================================================
# PREPROCESS
# ============================================================

print()
print("Preprocessing Hindi text...")

batch = ip.preprocess_batch(
    sentences,
    src_lang=src_lang,
    tgt_lang=tgt_lang,
    visualize=False,
)


batch = translation_tokenizer(
    batch,
    padding="longest",
    truncation=True,
    max_length=128,
    return_tensors="pt",
)


# ============================================================
# TRANSLATE
# ============================================================

print()
print("Translating...")

with torch.inference_mode():

    outputs = translation_model.generate(
        **batch,
        num_beams=1,
        num_return_sequences=1,
        max_length=128,
        use_cache=False,
    )


# ============================================================
# DECODE
# ============================================================

outputs = translation_tokenizer.batch_decode(
    outputs,
    skip_special_tokens=True,
    clean_up_tokenization_spaces=True,
)


outputs = ip.postprocess_batch(
    outputs,
    lang=tgt_lang,
)


santali_text = outputs[0]


print()
print("Santali translation:")
print(santali_text)


# ============================================================
# FREE TRANSLATION MEMORY
# ============================================================

print()
print("STEP 7: Freeing memory before Parler-TTS...")

del translation_model
del translation_tokenizer
del ip
del batch
del outputs

gc.collect()

if torch.cuda.is_available():
    torch.cuda.empty_cache()

print("Translation memory released.")


# ============================================================
# STEP 8 - LOAD PARLER TTS
# ============================================================

print()
print("STEP 8: Loading Indic Parler-TTS...")

try:

    tts_model = ParlerTTSForConditionalGeneration.from_pretrained(
        TTS_MODEL,
        attn_implementation="eager",
        torch_dtype=torch.float32,
        low_cpu_mem_usage=True,
    ).to(device)

    tts_model.eval()

    print("Parler-TTS loaded successfully.")

except Exception as e:

    print()
    print("TTS MODEL COULD NOT BE LOADED.")
    print()
    print("Reason:")
    print(str(e))

    print()
    print("========================================")
    print("PARTIAL PIPELINE SUCCESS")
    print("========================================")

    print()
    print("Input audio:")
    print(INPUT_AUDIO)

    print()
    print("Hindi transcription:")
    print(hindi_text)

    print()
    print("Santali translation:")
    print(santali_text)

    print()
    print("ASR + TRANSLATION are working.")

    print()
    print("TTS could not run on this machine.")

    print()
    print("========================================")

    raise SystemExit


# ============================================================
# STEP 9 - LOAD TTS TOKENIZER
# ============================================================

print()
print("STEP 9: Loading TTS tokenizer...")

tts_tokenizer = AutoTokenizer.from_pretrained(
    TTS_MODEL
)

print("TTS tokenizer loaded successfully.")


# ============================================================
# STEP 10 - PREPARE SANTALI VOICE
# ============================================================

print()
print("STEP 10: Preparing Santali voice...")

description = (
    "A clear and natural female voice speaking Santali. "
    "The speech should be slow, clear, and suitable "
    "for a primary school classroom."
)


input_ids = tts_tokenizer(
    description,
    return_tensors="pt",
).input_ids.to(device)


prompt_input_ids = tts_tokenizer(
    santali_text,
    return_tensors="pt",
).input_ids.to(device)


# ============================================================
# STEP 11 - GENERATE SANTALI AUDIO
# ============================================================

print()
print("STEP 11: Generating Santali audio...")

with torch.inference_mode():

    generation = tts_model.generate(
        input_ids=input_ids,
        prompt_input_ids=prompt_input_ids,
        do_sample=True,
        temperature=1.0,
    )


# ============================================================
# STEP 12 - SAVE AUDIO
# ============================================================

generated_audio = (
    generation
    .cpu()
    .numpy()
    .squeeze()
)


sf.write(
    OUTPUT_AUDIO,
    generated_audio,
    tts_model.config.sampling_rate,
)


# ============================================================
# FINAL RESULT
# ============================================================

print()
print("========================================")
print("PIPELINE SUCCESS!")
print("========================================")

print()
print("Input audio:")
print(INPUT_AUDIO)

print()
print("Hindi transcription:")
print(hindi_text)

print()
print("Santali translation:")
print(santali_text)

print()
print("Generated Santali audio:")
print(OUTPUT_AUDIO)

print()
print("========================================")
print("COMPLETE FLOW")
print("========================================")

print()
print("Hindi Speech")
print("      |")
print("      v")
print("IndicConformer ASR")
print("      |")
print("      v")
print("Hindi Text")
print("      |")
print("      v")
print("IndicTrans2")
print("      |")
print("      v")
print("Santali Text")
print("      |")
print("      v")
print("Indic Parler-TTS")
print("      |")
print("      v")
print("Santali Audio")

print()
print("========================================")