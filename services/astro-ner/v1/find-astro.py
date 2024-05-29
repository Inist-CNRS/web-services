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
        unidecode("Trou_noirs,_quasars_et_apparentés"): TNQ,
        "Satellite_naturel": SNAT,
        "Objets_artificiels": OA,
        unidecode("Système_solaire"): SSO,
        unidecode("Étoiles_binaires_(et_pulsars)"): EB,
        unidecode("Étoiles"): ET,
        unidecode("Nébuleuse_et_région_apparentés"): NRA,
        "Constellations": CST,
        "Galaxies_et_amas_de_galaxie": GAL,
        unidecode("Astéroïdes"): AST,
        unidecode("Statut_hypothétique"): ST,
        "Asmas_stellaires": AS,
        "Supernovas": SN,
        unidecode("Exoplanètes"): XPL,
        "Sursaut_radio,_source_radio,_autres_sursauts": SR,
    }

    data["value"] = {id: value for id, value in returnDic.items() if value != []}
    sys.stdout.write(json.dumps(data))
    sys.stdout.write("\n")
