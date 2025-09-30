#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
import logging
from flair.data import Sentence
from flair.models import SequenceTagger

logging.getLogger("flair").handlers[0].stream = sys.stderr

model_path = 'v1/model-software.pt'
tagger = SequenceTagger.load(model_path)

for line in sys.stdin:
    line = json.loads(line)
    try:
        data = line["value"]

    except Exception:
        data = ""
        
    sentence = Sentence(data)
    tagger.predict(sentence)

    result = {"SOFT": []}

    for entity in sentence.get_spans('ner'):
        result["SOFT"].append(entity.text)

    line["value"] = result
    
    sys.stdout.write(json.dumps(line))
    sys.stdout.write("\n")
