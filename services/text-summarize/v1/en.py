#!/usr/bin/env python3

from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
import json
import sys
import torch

torch.set_num_threads(4)

tokenizer = AutoTokenizer.from_pretrained("./v1/bart-large-cnn")
model = AutoModelForSeq2SeqLM.from_pretrained("./v1/bart-large-cnn")

# Fonction pour générer un résumé à partir d'un texte
def generate_summary(text):
    input_ids = tokenizer(text, return_tensors="pt", padding=True, truncation=True, max_length=1024).input_ids
    if input_ids.shape[1] < 250:
        return text

    try:
        outputs = model.generate(input_ids)
        summary = tokenizer.decode(outputs[0], skip_special_tokens=True) + " <AI-generated>"
    except Exception as e:
        sys.stderr.write(f"\nError with EN-model: {str(e)}\n")

    return summary


for line in sys.stdin:
    data = json.loads(line)
    if "value" in data:
        text = data["value"]
        if isinstance(data["value"], str):
            data["value"] = generate_summary(text)
        else:
            data["value"] = ""
    else:
        data["value"] = ""

    sys.stdout.write(json.dumps(data))
    sys.stdout.write("\n")
