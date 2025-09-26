#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import fasttext
from nltk.tokenize import sent_tokenize
import sys


model = fasttext.load_model("./v1/fasttext_model.bin")
threshold_methods = int(sys.argv[sys.argv.index('-p') + 1] if '-p' in sys.argv else 80)/100
if threshold_methods < 0:
    threshold_methods = 0
if threshold_methods > 1:
    threshold_methods = 1


def is_method(sentence, model=model, threshold=0.9):
    prediction = model.predict(sentence)[0][0]
    proba = model.predict(sentence)[1][0]

    if proba > threshold:
        if prediction.replace("__label__", "") == "1":
            return sentence

    return None


for line in sys.stdin:
    data = json.loads(line)
    predictions = []
    try:
        sentences = sent_tokenize(data["value"])
    except Exception as e:
        sys.stderr.write(str(e))
        sentences = []

    for sentence in sentences:
        try:
            if len(sentence) < 7 or len(sentence) > 500:
                continue

            prediction = is_method(sentence, threshold=0)
            if prediction:
                predictions.append(str(prediction))
        except Exception:
            sys.stderr.write("a")

            continue
    
    data["value"] = predictions
    
    sys.stdout.write(json.dumps(data))
    sys.stdout.write("\n")
