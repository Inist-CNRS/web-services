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
import pickle

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


with open("./v1/chem/models/dic-name-iupac-filtered-enrich.pkl",'rb') as f_dic:
    dict_name_iupac = pickle.load(f_dic)

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

    # Get token that contains "CHEMICAL"
    tokens = tokenizer.convert_ids_to_tokens(tokens['input_ids'][0])
    chemical_tokens_list = []
    i=0

    while i < len(predictions[0]):
        # prediction [0][i] depends of i : {0 : "B-CHEMICAL" , 1 : "I-CHEMICAL" , 2: "NOT a chemical NE"}
        k=0
        if predictions[0][i] < 2:
            chemical_tokens_toappend = []
            while predictions[0][i+k] < 2:
                chemical_tokens_toappend.append(tokens[i+k])
                k+=1
            chemical_tokens_list.append(chemical_tokens_toappend)
        i+=k+1
    value = []
    for chemical_tokens in chemical_tokens_list:
        value.append(tokenizer.decode(tokenizer.convert_tokens_to_ids(chemical_tokens)))
    return value

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

#Disambigusate formulas :

#preprocessing : remove duplicates elements
def remove_duplicates(input_list):
    output_list = []
    normalized_list = []
    for elt in input_list:
        if normalizeText(elt) not in normalized_list:
            output_list.append(elt)
            normalized_list.append(normalizeText(elt))
    return output_list

def disambiguisate_formula(input_list):
    output_list = []
    for elt in input_list:
        try:
            output_list.append(dict_name_iupac[normalizeText(elt)])
        except:
            continue
    return output_list



# beginning of the ws  
for line in sys.stdin:
    data = json.loads(line)
    # Use the model to find NER
    value = remove_duplicates(curate_list(predict_formula_ml_list(split_text(data["value"]))))
    # Standardization
    data["value"] = {"chemical":value, "chemical_disambiguisate":remove_duplicates(disambiguisate_formula(value))}
    json.dump(data, sys.stdout, ensure_ascii=False)
    sys.stdout.write("\n")
