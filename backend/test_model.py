from transformers import AutoModelForSeq2SeqLM, AutoTokenizer

MODEL_PATH = "./models/indictrans2-indic-indic-dist-320M"

print("Loading tokenizer...")
tokenizer = AutoTokenizer.from_pretrained(
    MODEL_PATH,
    trust_remote_code=True,
)

print("Loading model...")
model = AutoModelForSeq2SeqLM.from_pretrained(
    MODEL_PATH,
    trust_remote_code=True,
)

print("MODEL LOADED SUCCESSFULLY")