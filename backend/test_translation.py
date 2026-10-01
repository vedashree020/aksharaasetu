import torch

from transformers import (
    AutoModelForSeq2SeqLM,
    AutoTokenizer,
)

from IndicTransToolkit import IndicProcessor


# ============================================================
# AKSHARAASETU — INDIC TRANS 2 TRANSLATION TEST
# ============================================================

MODEL_PATH = "./models/indictrans2-indic-indic-dist-320M"


# ============================================================
# LOAD TOKENIZER
# ============================================================

print()
print("========================================")
print("AKSHARAASETU TRANSLATION TEST")
print("========================================")

print()
print("Loading tokenizer...")

tokenizer = AutoTokenizer.from_pretrained(
    MODEL_PATH,
    trust_remote_code=True,
)

print("Tokenizer loaded successfully.")


# ============================================================
# LOAD MODEL
# ============================================================

print()
print("Loading IndicTrans2 model...")

model = AutoModelForSeq2SeqLM.from_pretrained(
    MODEL_PATH,
    trust_remote_code=True,
)

model.eval()

print("IndicTrans2 model loaded successfully.")


# ============================================================
# LOAD INDIC PROCESSOR
# ============================================================

print()
print("Loading IndicTransProcessor...")

ip = IndicProcessor(
    inference=True
)

print("IndicTransProcessor loaded successfully.")


# ============================================================
# TEST 1
# HINDI → SANTALI
# ============================================================

print()
print("========================================")
print("TEST 1: HINDI → SANTALI")
print("========================================")

hindi_sentences = [
    "मेरा परिवार छोटा और प्यारा है।"
]

src_lang = "hin_Deva"
tgt_lang = "sat_Olck"


print()
print("Hindi:")
print(hindi_sentences[0])

print()
print("Preprocessing...")

batch = ip.preprocess_batch(
    hindi_sentences,
    src_lang=src_lang,
    tgt_lang=tgt_lang,
    visualize=False,
)

batch = tokenizer(
    batch,
    padding="longest",
    truncation=True,
    max_length=128,
    return_tensors="pt",
)

print("Translating...")


with torch.inference_mode():

    outputs = model.generate(
        **batch,
        num_beams=1,
        num_return_sequences=1,
        max_length=128,
        use_cache=False,
    )


outputs = tokenizer.batch_decode(
    outputs,
    skip_special_tokens=True,
    clean_up_tokenization_spaces=True,
)

outputs = ip.postprocess_batch(
    outputs,
    lang=tgt_lang,
)

santali_translation = outputs[0]


print()
print("Santali:")
print(santali_translation)


# ============================================================
# TEST 2
# SANTALI → HINDI
# ============================================================

print()
print("========================================")
print("TEST 2: SANTALI → HINDI")
print("========================================")

santali_sentences = [
    santali_translation
]

src_lang = "sat_Olck"
tgt_lang = "hin_Deva"


print()
print("Santali:")
print(santali_sentences[0])

print()
print("Preprocessing...")

batch = ip.preprocess_batch(
    santali_sentences,
    src_lang=src_lang,
    tgt_lang=tgt_lang,
    visualize=False,
)

batch = tokenizer(
    batch,
    padding="longest",
    truncation=True,
    max_length=128,
    return_tensors="pt",
)

print("Translating...")


with torch.inference_mode():

    outputs = model.generate(
        **batch,
        num_beams=1,
        num_return_sequences=1,
        max_length=128,
        use_cache=False,
    )


outputs = tokenizer.batch_decode(
    outputs,
    skip_special_tokens=True,
    clean_up_tokenization_spaces=True,
)

outputs = ip.postprocess_batch(
    outputs,
    lang=tgt_lang,
)

hindi_translation = outputs[0]


print()
print("Hindi:")
print(hindi_translation)


# ============================================================
# FINAL RESULT
# ============================================================

print()
print("========================================")
print("TRANSLATION TEST COMPLETE")
print("========================================")

print()
print("Hindi → Santali:")
print(santali_translation)

print()
print("Santali → Hindi:")
print(hindi_translation)

print()
print("========================================")