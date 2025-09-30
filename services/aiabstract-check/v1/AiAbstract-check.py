#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import logging
import sys
from flair.models import TextClassifier
from flair.data import Sentence

logging.getLogger("flair").handlers[0].stream = sys.stderr

model_path = "./v1/aiAbstract-model.pt"
model = TextClassifier.load(model_path)
model.eval()

for line in sys.stdin:
    data = json.loads(line)
    text = data["value"]
    sentence = Sentence(text)
    model.predict(sentence)
    predicted_label = int(sentence.labels[0].value)
    predicted_score = sentence.labels[0].score
    data["value"] = {"isAiGenerated":bool(predicted_label), "score": '%.3f'  % predicted_score}
    sys.stdout.write(json.dumps(data))
    sys.stdout.write("\n")
