#!/usr/bin/env python3
import fasttext
import json
import sys
import pickle


# del fasttext's logs
fasttext.FastText.eprint = lambda x: None

# Loading model
model = fasttext.load_model("./v1/model.bin")

with open("./v1/id2label.pickle","rb") as f:
    id2label = pickle.load(f)

def normalizeText(text):
    text = text.lower().replace("\n", " ")
    sentence = []
    for word in text.split():
        sentence.append(word)
    text = " ".join(sentence)
    return text


# WS
for line in sys.stdin:
    data = json.loads(line)
    resume = data["value"]
    resume = normalizeText(resume)
    
    if len(resume) < 100:
        data["value"] = {"domain": ""}
        
    else:    
        prediction = model.predict(resume)
        label = prediction[0][0].replace("__label__","")
        proba = prediction[1][0]
        if proba < 0.4 :
            data["value"] = {"domain": ""}
        else:
            data["value"] = {"domain": id2label[int(label)]}

    sys.stdout.write(json.dumps(data))
    sys.stdout.write("\n")