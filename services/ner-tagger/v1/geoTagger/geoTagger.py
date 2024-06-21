#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import logging
import sys
from flair.data import Sentence
from flair.models import SequenceTagger

logging.getLogger('flair').handlers[0].stream = sys.stderr

tagger = SequenceTagger.load("flair/ner-english")

for line in sys.stdin:
    data = json.loads(line)
    text = data['value']
    sent = text.split(".")
    sentences = [Sentence(sent[i] + ".") for i in range(len(sent))]
    tagger.predict(sentences)
    geo = []

    for sentence in sentences:
        for entity in sentence.get_spans('ner'):
            if entity.tag == "LOC":
                geo.append(entity.text)
    data['value'] = geo
    sys.stdout.write(json.dumps(data))
    sys.stdout.write('\n')
