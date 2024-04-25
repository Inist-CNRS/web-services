#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import json
from flair.models import SequenceTagger
from flair.data import Sentence
from unidecode import unidecode
import logging

logging.getLogger("flair").handlers[0].stream = sys.stderr

tagger = SequenceTagger.load("./v1/model.pt")

for line in sys.stdin:
    data = json.loads(line)
    text = data["value"]
    PL = []
    TNQ = []
    SNAT = []
    OA = []
    SSO = []
    EB = []
    ET = []
    NRA = []
    CST = []
    GAL = []
    AST = []
    ST = []
    AS = []
    SN = []
    XPL = []
    SR = []
    sent = text.split(".")
    sentences = [Sentence(sent[i] + ".") for i in range(len(sent))]
    tagger.predict(sentences)
    label_lists = {
        "PL": PL,
        "TNQ": TNQ,
        "SNAT": SNAT,
        "OA": OA,
        "SSO": SSO,
        "EB": EB,
        "ET": ET,
        "NRA": NRA,
        "CST": CST,
        "GAL": GAL,
        "AST": AST,
        "ST": ST,
        "AS": AS,
        "SN": SN,
        "XPL": XPL,
        "SR": SR,
    }
    for sentence in sentences:
        for entity in sentence.get_spans("ner"):
            label_value = entity.labels[0].value
            if entity.text not in label_lists.get(label_value, []):
                label_lists[label_value].append(entity.text)

    returnDic = {
        unidecode("Planète"): PL,
        unidecode("Trou noirs, quasars et apparentés"): TNQ,
        "Satellite naturel": SNAT,
        "Objets artificiels": OA,
        unidecode("Système solaire"): SSO,
        unidecode("Étoiles binaires (et pulsars)"): EB,
        unidecode("Étoiles"): ET,
        unidecode("Nébuleuse et région apparentés"): NRA,
        "Constellations": CST,
        "Galaxies et amas de galaxie": GAL,
        unidecode("Astéroïdes"): AST,
        unidecode("Statut hypothétique"): ST,
        "amas stellaires": AS,
        "supernovas": SN,
        unidecode("exoplanètes"): XPL,
        "sursaut radio, source radio, autres sursauts": SR,
    }

    data["value"] = {id: value for id, value in returnDic.items() if value != []}
    sys.stdout.write(json.dumps(data))
    sys.stdout.write("\n")
