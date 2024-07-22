#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
from difflib import SequenceMatcher
import numpy as np

# load all datas
all_data = []
for line in sys.stdin:
    data=json.loads(line)
    all_data.append(data)
charged = False
print("ARV : ",sys.argv,file=sys.stderr)
output = int(sys.argv[sys.argv.index('-p') + 1] if '-p' in sys.argv else 0)
print("Output is ",output,file=sys.stderr)
for line in all_data:
    data = line[0]
    currentTitle = data['value']
    currentId = data['id']
    sim = []
    idList = []
    ratioList = []
    for i,line_cmp in enumerate(all_data):
        data_cmp = line_cmp[0]
        id,title = data_cmp["id"],data_cmp["value"]
        if currentId == id:
            continue
        ratio = SequenceMatcher(None, currentTitle, title).ratio()
        idList.append(id)
        ratioList.append(ratio)
        sim.append((id,ratio))
        ratioList,idList = (list(t) for t in zip(*sorted(zip(ratioList, idList),reverse=True)))
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
    sys.stdout.write(json.dumps({"id":data["id"],"value":{"similarity":sim, "score":score}}))
    sys.stdout.write('\n')
