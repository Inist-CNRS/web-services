#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from CQE import CQE
import sys
import json

parser = CQE.CQE(overload=True)

for line in sys.stdin:
    output_data = []
    data = json.loads(line)
    text = data['value']

    sentences = text.split(". ")
    
    for sentence in sentences:
        quantities = parser.parse(sentence)
        for quant in quantities :
            if quant.unit.scientific == True :
                referred_concepts = quant.referred_concepts.get_nouns()
                referred_list = []
                for concept in referred_concepts:
                    for element in concept:
                        referred_list.append(str(element))

                quantity_data = {
                    "quantity": quant.value.get_str_value(),
                    "unit": str(quant.unit),
                    "detailed_unit": quant.unit.unit_surfaces_forms,
                    "related_concept": referred_list
                }
                output_data.append(quantity_data)
    data['value'] = output_data
    sys.stdout.write(json.dumps(data,ensure_ascii=False))
    sys.stdout.write('\n')
