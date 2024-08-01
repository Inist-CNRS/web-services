#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import logging
import re
import sys
from flair.data import Sentence
from flair.models import SequenceTagger

logging.getLogger('flair').handlers[0].stream = sys.stderr


def data_normalization(dic, sentence):
    cpy_sentence = sentence

    cpy_sentence = re.sub(r'\bArt. \w*\b', '', cpy_sentence)
    cpy_sentence = re.sub(r'\.\.\.*', '', cpy_sentence)

    for key in dic:
        cpy_sentence = cpy_sentence.replace(key, dic[key])

    return cpy_sentence


tagger = SequenceTagger.load("./v1/perseeBaipTagger/model.pt")

error_dic = {}
error_dic["\n"] = " "
error_dic["¬ "] = ""
error_dic["l'"] = "l' "
error_dic["d'"] = "d' "
error_dic["1° "] = ""
error_dic["2° "] = ""
error_dic["3° "] = ""
error_dic["Art. "] = ""
error_dic[", A"] = ", a"

uniqueOrg = ["collège", "lycée", "académie", "faculté", "école", "ecole", "établissement", "institut"]
trans = ["nomination", "affectation", "concession", "érection", "suppression", "transformation"]

for line in sys.stdin:
    data = json.loads(line)
    text = data['value']

    locL = []
    orgL = []
    basicOrg = []
    operation = []

    sent = data_normalization(error_dic, text)

    sentS = sent.split(".")
    sentences = [Sentence(sentS[i] + ".") for i in range(len(sentS))]

    tagger.predict(sentences)

    for word in sent.lower().split(" "):
        for transfo in trans:
            if word.startswith(transfo):
                if transfo not in operation:
                    operation.append(transfo)
                break

    for sentence in sentences:
        for entity in sentence.get_spans('ner'):
            if (entity.labels[0].value == "LOC"):
                if entity.text not in locL:
                    locL.append(entity.text)
            if entity.labels[0].value == "ORG":
                org = entity.text.split(" ")
                if len(org[-1]) > 2:
                    for borg in uniqueOrg:
                        if entity.text.lower().startswith(borg):
                            basicOrg.append(borg)
                    if entity.text not in orgL:
                        orgL.append(entity.text)
                    if len(org) > 1:
                        for k in ["à", "de", "l'", "d'", "'", "du", "la"]:
                            if org[-2] == k:
                                if org[-1] not in locL:
                                    locL.append(org[-1])
                                break

    returnDic = {"loc": locL, "org": orgL, "basicOrg": basicOrg, "operation": operation}
    data['value'] = returnDic
    sys.stdout.write(json.dumps(data))
    sys.stdout.write('\n')
