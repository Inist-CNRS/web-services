#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import spacy
import json
import sys

nlp = spacy.load("xx_ent_wiki_sm")

for line in sys.stdin:
    line = json.loads(line)
    res = {"PER":[],"LOC":[],"ORG":[],"MISC":[]}
    try:
        value = line["value"]
    except KeyError:
        value = ""

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
        res[ent.label_].append(ent.text)
        
    line["value"] = res
    
    sys.stdout.write(json.dumps(line))
    sys.stdout.write("\n")
