#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
from difflib import SequenceMatcher
import numpy as np


def get_ratio(data, idAll, titleAll, mapping, similarityMatrix):
    idAll_cpy = idAll.copy()
    titleAll_cpy = titleAll.copy()
    currentId = data['id']
    ratioList = similarityMatrix[mapping[currentId],:].copy().tolist()
    ratioList.pop(mapping[currentId])
    idAll_cpy.pop(mapping[currentId])
    titleAll_cpy.pop(mapping[currentId])
    #Sort both lists according to ratioList
    ratioList, idList, titleList = (list(t) for t in zip(*sorted(zip(ratioList, idAll_cpy, titleAll_cpy),reverse=True)))

    return currentId, ratioList, idList, titleList


def create_similiraty_matrix_and_data(all_data):
    all_data = [all_data[i] for i in range(len(all_data)) if "value" in all_data[i]]
    M = np.zeros((len(all_data), len(all_data)))
    mapping = {}
    idList = []
    titleList = []
    for x, X in enumerate(all_data):
        idList.append(X["id"])
        titleList.append(X["value"])
        mapping[X["id"]] = x
        for y, Y in enumerate(all_data):
            if y < x:
                continue
            ratio = SequenceMatcher(None, X["value"], Y["value"]).ratio()
            M[x,y] = ratio
            M[y,x] = ratio
        print(x+1," row done over ", len(all_data), file=sys.stderr)
    return mapping, M, idList, titleList

# load all datas
all_data = []
for line in sys.stdin:
    data = json.loads(line)
    all_data.append(data)


output = int(sys.argv[sys.argv.index('-p') + 1] if '-p' in sys.argv else 0)

mapping, similarityMatrix, idAll, titleAll = create_similiraty_matrix_and_data(all_data)
seuil = 0.6

for line in all_data:
    if "value" in line:
        id, ratioList, idList, titleList = get_ratio(line, idAll, titleAll, mapping, similarityMatrix)
        if output == 0:
            if ratioList[0] < seuil:
                sim = []
                score = []
                titles = []
            else:
                diff = -np.diff(ratioList)
                mean = np.mean(diff)
                argmx = np.argmax(diff-mean)
                index_seuil = argmx+1
                if ratioList[argmx] < seuil:
                    index_seuil = next((i for i, v in enumerate(ratioList[:argmx+1]) if v < seuil), -1)
                sim = idList[:index_seuil]
                score = ratioList[:index_seuil]
                titles = titleList[:index_seuil]
                    
        elif output == 1:
            sim = idList
            score = ratioList
            titles = titleList
        else:
            sim = idList[:min(len(idList),output)]
            score = ratioList[:min(len(idList),output)]
            titles = titleList[:min(len(idList),output)]
        score = [round(s, 2) for s in score]
        sys.stdout.write(json.dumps({"id":id,"value":{"similarity":sim, "text":titles, "score":score}}))
        sys.stdout.write('\n')
    else:
        sys.stdout.write(json.dumps(line))
        sys.stdout.write('\n')
