import torch
import soundfile as sf
from transformers import AutoModel

MODEL_NAME = "ai4bharat/indic-conformer-600m-multilingual"
AUDIO_FILE = "generated_santali.wav"

print("Loading ASR model...")

model = AutoModel.from_pretrained(
    MODEL_NAME,
    trust_remote_code=True,
)

print("Loading audio...")

audio, sr = sf.read(
    AUDIO_FILE,
    dtype="float32",
)

# Convert audio to torch tensor
wav = torch.from_numpy(audio)

# Convert stereo to mono
if wav.ndim == 1:
    wav = wav.unsqueeze(0)
else:
    wav = wav.mean(dim=1, keepdim=True)

# IndicConformer expects 16 kHz audio
target_sample_rate = 16000

if sr != target_sample_rate:
    print(
        f"Resampling audio: {sr} Hz -> {target_sample_rate} Hz"
    )

    import torchaudio

    resampler = torchaudio.transforms.Resample(
        orig_freq=sr,
        new_freq=target_sample_rate,
    )

    wav = resampler(wav)

print("Running Santali speech recognition...")

transcription = model(
    wav,
    "sat",
    "ctc",
)

print()
print("==============================")
print("Santali transcription:")
print(transcription)
print("==============================")