#!/usr/bin/env python3

from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
import json
import sys
import torch
import re
torch.set_num_threads(4)

tokenizer = AutoTokenizer.from_pretrained("./v1/mbart-large-50-finetuned-summarization-V2")
model = AutoModelForSeq2SeqLM.from_pretrained("./v1/mbart-large-50-finetuned-summarization-V2")  


def clean_authors(text):
    try:
        if len(text) < 510:
            return text
        begin, end = text[:500], text[500:]
        pattern = r'''
            (?:
                (?:[A-ZÉÈÊËÀÂÄÎÏÔÖÛÜ]\.\s*|[A-ZÉÈÊËÀÂÄÎÏÔÖÛÜ][a-zéèêëàâäîïôöûüç]+)\s+
                [A-ZÉÈÊËÀÂÄÎÏÔÖÛÜ][a-zéèêëàâäîïôöûüç]+
                \s*
                (?:,|et|and|&)?\s*
            ){2,}
        '''
        regex = re.compile(pattern, re.VERBOSE)
        return regex.sub('', begin) + end
    except Exception:
        return text


def generate_summary(text):
    input_ids = tokenizer(text, return_tensors="pt", padding=True, truncation=True, max_length=1024).input_ids
    if input_ids.shape[1] < 30:
        return text

    try:
        outputs = model.generate(input_ids)
        summary = tokenizer.decode(outputs[0], skip_special_tokens=True) + " <AI-generated>"
    except Exception as e:
        sys.stderr.write(f"\nError with MULTILINGUAL-model: {str(e)}\n")

    return summary


for line in sys.stdin:
    data = json.loads(line)
    if "value" in data:
        text = data["value"]
        if isinstance(data["value"], str):
            data["value"] = generate_summary(clean_authors(text))
        else:
            data["value"] = ""
    else:
        data["value"] = ""

    sys.stdout.write(json.dumps(data))
    sys.stdout.write("\n")
