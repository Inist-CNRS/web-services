#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 29 16:57:23 2022

@author: cuxac
"""
import json
import spacy
import sys

nlp = spacy.load('en_core_web_sm', disable=['parser', 'ner'])

for line in sys.stdin:
    data = json.loads(line)
    i = data['value']
    if type(i) == str and (len(i.split(' ')) == 1 and len(i.split('-')) == 1 and len(i.split('/')) == 1):
        i = i.replace("*", " ").strip()
        data["value"] = nlp(i)[0].lemma_
    elif type(i) == list:
        ll = list()
        for j in i:
            j = j.replace('*', ' ').strip()
            if len(j.split()) == 1:
                ll.append(nlp(j)[0].lemma_)
            else:
                ll.append(' '.join([w.lemma_ for w in nlp(j)]))

        data['value'] = ll
    else:
        i = i.replace('*', ' ').strip()
        sent = ' '.join([w.lemma_ for w in nlp(i)])

        data['value'] = sent

    sys.stdout.write(json.dumps(data))
    sys.stdout.write('\n')
