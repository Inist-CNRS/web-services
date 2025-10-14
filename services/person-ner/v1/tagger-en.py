#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
import torch
import pickle
from entitytag.entitytag_functions import *


# Load vocabulary and model
with open("./v1/entity-tag-model/en/word2idx.pkl", "rb") as f:
    word2idx = pickle.load(f)

with open("./v1/entity-tag-model/en/tag2idx.pkl", "rb") as f:
    tag2idx = pickle.load(f)

idx2word = {i: w for w, i in word2idx.items()}
idx2tag = {i: t for t, i in tag2idx.items()}

model = LSTM_NER(vocab_size=len(word2idx), tagset_size=len(tag2idx), embed_dim=200)
model.load_state_dict(torch.load("./v1/entity-tag-model/en/entityTag-sm.pth", map_location=torch.device('cpu')))


# WS
for line in sys.stdin:
    line = json.loads(line)

    try:
        value = line["value"]
    except KeyError:
        value = ""
        doc = []
        
    try:
        if value[:8].lower() == "abstract":
            value = value[9:].strip()
    except:
        pass
    
    try:
        sentences = split_sentences_nltk(value)
        data = []
        max_len = 0
        for sentence in sentences:
            sentence = multilingual_tokenizer(sentence)
            len_sentence = len(sentence)
            if len_sentence > max_len:
                max_len = len_sentence
            data.append(sentence)
        entities = extract_entities(data, model, word2idx, idx2tag, max_len, threshold=0.85)
        
        for ent in entities:
            remove_occurences(entities[ent], "")

    except Exception as e:
        sys.stderr.write(str(e))
        sys.stderr.write("\n")
        entities = {
            "PER": [],
            "LOC": [],
            "ORG": []
            }
        
    line["value"] = entities
    sys.stdout.write(json.dumps(line))
    sys.stdout.write("\n")
