#!/usr/bin/env python
# -*- coding: utf-8 -*-

import torch
from transformers import AutoTokenizer, AutoModelForTokenClassification
import re
import os
import sys
import json
import logging
import unicodedata

# Remove logs from TF
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
logging.getLogger('tensorflow').setLevel(logging.ERROR)

# Normalize 
# Normalisation du texte :
def remove_accents(text):
    text = unicodedata.normalize("NFD", text)
    text = re.sub("[\u0300-\u036f]", "", text)
    return text

def normalizeText(text):
    text = text.lower()
    text = remove_accents(text).replace(" ","")
    return text


## Predicts developped formulas
# Load model
tokenizer = AutoTokenizer.from_pretrained('./v1/chem/models')
model = AutoModelForTokenClassification.from_pretrained('./v1/chem/models', config='./v1/chem/models/config.json')

# predicts text
def predict_formula_ml(input_text):
    #tokenizer 
    tokens = tokenizer(input_text, return_tensors='pt', truncation=True, max_length=512)

    # Predicts
    with torch.no_grad():
        output = model(**tokens)

    predictions = torch.argmax(output.logits, dim=-1)

    #convert the predictions to labels
    predicted_labels = [model.config.id2label[pred.item()] for pred in predictions[0]]
    
    
    def preprocess_model_error(token, label):
        is_subword = token.startswith("##")

        # "##xxx" cannot start an entity
        if is_subword and label.startswith("B-"):
            label = "I-CHEMICAL"

        # "##xxx" cannot be O if previous token was an entity
        if is_subword and label == "O" and prev_label in ["B-CHEMICAL", "I-CHEMICAL"]:
            label = "I-CHEMICAL"

        # If model emits I- after O treat as B-
        if label == "I-CHEMICAL" and prev_label == "O":
            label = "B-CHEMICAL"
            
        return token, label


    chemical_entities = []
    current_entity = []
    prev_label = "O"
    
    # Iterate over both tokens and entity directly
    for token, label in zip(tokenizer.convert_ids_to_tokens(tokens['input_ids'][0]), predicted_labels):
        
        token, label = preprocess_model_error(token, label)

        # Now, process prediction
        if label.startswith("B-"):  # Beginning of an entity
            if current_entity:
                chemical_entities.append(current_entity)
                current_entity = []
            current_entity.append(token)
        elif label.startswith("I-") and current_entity:  # Continuation of an entity
            current_entity.append(token)
        else:
            if current_entity:
                chemical_entities.append(current_entity)
                current_entity = []
                
        prev_label = label

    # If there's an entity left at the end (here was a bug with last version)
    if current_entity:
        chemical_entities.append(current_entity)

    # Convert tokens back to string format
    chemical_entities = [tokenizer.convert_tokens_to_string(entity_tokens) for entity_tokens in chemical_entities]

    return chemical_entities

# if text too long
def split_text(text):
    if len(text)>=512:
        text_split = text.split('.')
    else:
        text_split = [text]
    return text_split

# predicts text after, either it is splitted or not
def predict_formula_ml_list(list):
    output = []
    for elt in list:
        output+= predict_formula_ml(elt)
    return output

# remove bad space in outputs
def curate_list(input_list):
    output_list = []
    for elt in input_list:
        if '#' not in elt:
            output_list.append(
                        elt.replace('- ','-').replace(' -','-').replace('( ','(').replace(' (','(').replace(') ',')').replace(' )',')').replace('[ ','[')
                        .replace(' [','[').replace('] ',']').replace(' ]',']')
                        )
    return output_list


# beginning of the ws  
for line in sys.stdin:
    data = json.loads(line)
    # Use the model to find NER
    value = curate_list(predict_formula_ml_list(split_text(data["value"])))
    # Standardization
    data["value"] = {"chemical":value}
    json.dump(data, sys.stdout, ensure_ascii=False)
    sys.stdout.write("\n")
