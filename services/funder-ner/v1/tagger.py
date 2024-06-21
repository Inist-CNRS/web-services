#!/opt/bitnami/python/bin/python3.7

import json
import logging
import sys
from flair.data import Sentence
from flair.models import SequenceTagger

from normalize import normalize

logging.getLogger("flair").handlers[0].stream = sys.stderr
tagger = SequenceTagger.load('./v1/best-model.pt')
for line in sys.stdin:
    data = json.loads(line)
    lSent = normalize([data["value"]])[0].split()
    sentence = Sentence()
    for token in lSent:
        sentence.add_token(token)
    tagger.predict(sentence)
    data["value"] = str([entity.text for entity in sentence.get_spans('ner')])
    sys.stdout.write(json.dumps(data))
    sys.stdout.write('\n')
