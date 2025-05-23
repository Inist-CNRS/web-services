#!/usr/bin/env python3

from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
import json
import sys
import torch
import os
import requests
from lxml import etree

torch.set_num_threads(4)

tokenizer = AutoTokenizer.from_pretrained("./v1/bart-large-cnn")
model = AutoModelForSeq2SeqLM.from_pretrained("./v1/bart-large-cnn")

GROBID_URL = os.getenv("GROBID_API_URL")


def extract_text_grobid(pdf_path):
    with open(pdf_path, 'rb') as pdf_file:
        files = {
            'input': (pdf_path, pdf_file, 'application/pdf')
        }
        data = {
            'consolidateHeader': '1'
        }
        try:
            response = requests.post(GROBID_URL, files=files, data=data)

            if response.status_code == 200:
                xml = response.text
                
                try:
                    # Parse XML
                    root = etree.fromstring(xml.encode('utf-8'))
                    ns = {'tei': 'http://www.tei-c.org/ns/1.0'}

                    # Extract abstract
                    abstract_parts = root.xpath('//tei:abstract//tei:p', namespaces=ns)
                    abstract = '\n'.join([etree.tostring(p, method="text", encoding="unicode").strip() for p in abstract_parts])

                    # Extract full text
                    body_parts = root.xpath('//tei:body//tei:p', namespaces=ns)
                    full_text = '\n'.join([etree.tostring(p, method="text", encoding="unicode").strip() for p in body_parts])

                    result = f"{abstract}\n{full_text}"
                    return result

                except Exception as e:
                    sys.stderr.write(f"\nError parsing TEI XML: {str(e)}\n")
                    return ""
            else:
                sys.stderr.write(
                    f"\nError API GROBID: {str(response.status_code)}\n"
                )
                return ""

        except Exception as e:
            sys.stderr.write(f"\nError with GROBID: {str(e)}\n")
            return ""


# Fonction pour générer un résumé à partir d'un texte
def generate_summary(text):
    input_ids = tokenizer(text, return_tensors="pt", padding=True, truncation=True, max_length=1024).input_ids
    if input_ids.shape[1] < 30:
        return text

    try:
        outputs = model.generate(input_ids)
        summary = tokenizer.decode(outputs[0], skip_special_tokens=True) + " <AI-generated>"
    except Exception as e:
        sys.stderr.write(f"\nError with EN-model: {str(e)}\n")

    return summary


for line in sys.stdin:
    line0 = json.loads(line)
    output = {"id": "", "value": ""}

    if "filename" in line0:
        pdf_filename = line0["filename"]
        output["id"] = pdf_filename
        text = extract_text_grobid(pdf_filename)

        try:
            output["value"] = generate_summary(text)
        except Exception as e:
            sys.stderr.write(str(e))
            output["value"] = ""

    else:
        output["value"] = ""

    sys.stdout.write(json.dumps(output))
    sys.stdout.write("\n")
