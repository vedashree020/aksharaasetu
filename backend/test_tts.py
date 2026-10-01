import torch
import soundfile as sf

from parler_tts import ParlerTTSForConditionalGeneration
from transformers import AutoTokenizer


MODEL_NAME = "ai4bharat/indic-parler-tts"

TEXT = "मेरा परिवार छोटा और प्यारा है।"

OUTPUT_FILE = "test_tts.wav"


print()
print("========================================")
print("AKSHARAASETU TTS TEST")
print("========================================")

device = "cuda:0" if torch.cuda.is_available() else "cpu"

print("Device:", device)
print("Loading TTS model...")


model = ParlerTTSForConditionalGeneration.from_pretrained(
    MODEL_NAME,
    attn_implementation="eager",
    torch_dtype=torch.float32,
    low_cpu_mem_usage=True,
).to(device)


print("TTS model loaded successfully.")

print()
print("Loading tokenizer...")

tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)

description_tokenizer = AutoTokenizer.from_pretrained(
    model.config.text_encoder._name_or_path
)

print("Tokenizer loaded successfully.")


description = (
    "A clear and natural female voice speaking Hindi. "
    "The speech is slow, clear, and suitable for a primary school classroom."
)


print()
print("Preparing text...")

description_input_ids = description_tokenizer(
    description,
    return_tensors="pt",
).to(device)

prompt_input_ids = tokenizer(
    TEXT,
    return_tensors="pt",
).to(device)


print("Generating audio...")

with torch.inference_mode():

    generation = model.generate(
        input_ids=description_input_ids.input_ids,
        attention_mask=description_input_ids.attention_mask,
        prompt_input_ids=prompt_input_ids.input_ids,
        prompt_attention_mask=prompt_input_ids.attention_mask,
    )


audio = (
    generation
    .cpu()
    .numpy()
    .squeeze()
)


sf.write(
    OUTPUT_FILE,
    audio,
    model.config.sampling_rate,
)


print()
print("========================================")
print("SUCCESS!")
print("========================================")

print("Generated audio:", OUTPUT_FILE)
print("Sampling rate:", model.config.sampling_rate)

print()
print("========================================")