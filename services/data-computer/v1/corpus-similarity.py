#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
from difflib import SequenceMatcher
import numpy as np

def get_ratio(data, all_data):
    currentTitle = data['value']
    currentId = data['id']
    idList = []
    ratioList = []

    for _,line_cmp in enumerate(all_data):
        if "value" not in line_cmp:
            continue
        data_cmp = line_cmp
        id,title = data_cmp["id"],data_cmp["value"]
        if currentId == id:
            continue
        ratio = SequenceMatcher(None, currentTitle, title).ratio()
        idList.append(id)
        ratioList.append(ratio)

    #Sort both lists according to ratioList
    ratioList,idList = (list(t) for t in zip(*sorted(zip(ratioList, idList),reverse=True)))

    return currentId, ratioList,idList

# load all datas
all_data = []
for line in sys.stdin:
    data=json.loads(line)
    all_data.append(data)


output = int(sys.argv[sys.argv.index('-p') + 1] if '-p' in sys.argv else 0)

for line in all_data:
    if "value" in line:
        id, ratioList, idList = get_ratio(line, all_data)
        if output == 0:
            if ratioList[0] < 0.6:
                sim = []
                score = []
            else:
                diff = -np.diff(ratioList)
                mean = np.mean(diff)
                argmx = np.argmax(diff-mean)
                sim = idList[:argmx+1]
                score = ratioList[:argmx+1]
        elif output == 1:
            sim = idList
            score = ratioList
        else:
            sim = idList[:min(len(idList),output)]
            score = ratioList[:min(len(idList),output)]
        score = [round(s, 2) for s in score]
        sys.stdout.write(json.dumps({"id":id,"value":{"similarity":sim, "score":score}}))
        sys.stdout.write('\n')
    else:
        sys.stdout.write(json.dumps(line))
        sys.stdout.write('\n')
