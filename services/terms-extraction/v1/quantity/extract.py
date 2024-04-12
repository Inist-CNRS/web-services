#!/usr/bin/env python3
from quantulum3 import parser
import sys
import json

for line in sys.stdin:
    data = json.loads(line)
    text = data['value']

    sentences = text.split(". ")

    entity = []
    quantity = []
    unit = []
    for sentence in sentences:
        quantities = parser.parse(sentence)
        for quant in quantities:
            if quant.unit.name != "dimensionless" :
                entity.append(quant.surface)
                quantity.append(quant.value)
                unit.append(quant.unit.name)

    pairs = zip(entity,quantity,unit)
    result = []
    for pair in pairs :
        result.append(pair)
    data['value'] = result
    sys.stdout.write(json.dumps(data))
    sys.stdout.write('\n')
