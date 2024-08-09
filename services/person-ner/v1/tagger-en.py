#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import spacy
import json
import sys

nlp = spacy.load("en_core_web_sm")

for line in sys.stdin:
    line = json.loads(line)
    
    res = {
    "PER": [],
    "LOC": [],
    "ORG": [],
    "DATE": [],
    "EVENT": [],
    "FAC": [],
    "LANGUAGE": [],
    "LAW": [],
    "MONEY": [],
    "NORP": [],
    "PRODUCT": [],
    "QUANTITY": [],
    "WORK_OF_ART": []
    }


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
        doc = nlp(value)
        doc = doc.ents
    except Exception:
        doc = []
    
    for ent in doc:
        label = ent.label_.replace("PERSON","PER").replace("GPE","LOC").replace("PERCENT","QUANTITY")
        if label in res :
            res[label].append(ent.text)
        
    line["value"] = res
    
    sys.stdout.write(json.dumps(line))
    sys.stdout.write("\n")

## Liste de toutes les entités nommées et de leur signification avant modification :
# PERSON:      People, including fictional.
# NORP:        Nationalities or religious or political groups.
# FAC:         Buildings, airports, highways, bridges, etc.
# ORG:         Companies, agencies, institutions, etc.
# GPE:         Countries, cities, states.                       ===> merged with LOC
# LOC:         Non-GPE locations, mountain ranges, bodies of water.
# PRODUCT:     Objects, vehicles, foods, etc. (Not services.)
# EVENT:       Named hurricanes, battles, wars, sports events, etc.
# WORK_OF_ART: Titles of books, songs, etc.
# LAW:         Named documents made into laws.
# LANGUAGE:    Any named language.
# DATE:        Absolute or relative dates or periods.
# TIME:        Times smaller than a day.                        ===> deleted
# PERCENT:     Percentage, including ”%“.                       ===> merged with QUANTITY
# MONEY:       Monetary values, including unit.
# QUANTITY:    Measurements, as of weight or distance.
# ORDINAL:     “first”, “second”, etc.                          ===> deleted
# CARDINAL:    Numerals that do not fall under another type.    ===> deleted
