#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Thu Aug 12 10:19:31 2021

@author: cuxac
"""

# from scipy.spatial import cKDTree as KDTree
import faiss
import fasttext
import json
import numpy as np
import operator
import pickle
import statistics
import sys
from collections import defaultdict  # ,Counter
from more_itertools import locate
from scipy.special import softmax

model = fasttext.load_model("./v1/en/modelhal0EN2.bin")
D = np.load("./v1/en/HALen_matrixKDT.npy")

dico_nd_pkl = open("./v1/en/dico_nd.pkl", "rb")
dico_nd = pickle.load(dico_nd_pkl)

d = 200
quantizer = faiss.IndexFlatL2(d)
quantizer.add(D)

# verb_class={"spi":"Sciences de l'ingénieur [physics]","shs":"Sciences de l'Homme et Société","sdv":"Sciences du Vivant [q-bio]","sdu":"Planète et Univers [physics]","sde":"Sciences de l'environnement","scco":"Sciences cognitives","phys":"Physique [physics]","nlin":"Science non linéaire [physics]","math":"Mathématiques [math]","info":"Informatique [cs]","chim":"Chimie","stat":"Statistiques","qfin":"Économie et finance quantitative [q-fin]"}

verb_class = {"chim": {"code": "chim", "labelFr": "Chimie", "labelEn": "Chemical Sciences"},
              "info": {"code": "info", "labelFr": "Informatique [cs]", "labelEn": "Computer Science [cs]"},
              "math": {"code": "math", "labelFr": "Mathématiques [math]", "labelEn": "Mathematics [math]"},
              "nlin": {"code": "nlin", "labelFr": "Science non linéaire [physics]",
                       "labelEn": "Nonlinear Sciences [physics]"},
              "phys": {"code": "phys", "labelFr": "Physique [physics]", "labelEn": "Physics [physics]"},
              "qfin": {"code": "qfin", "labelFr": "Économie et finance quantitative [q-fin]",
                       "labelEn": "Quantitative Finance [q-fin]"},
              "scco": {"code": "scco", "labelFr": "Sciences cognitives", "labelEn": "Cognitive science"},
              "sde": {"code": "sde", "labelFr": "Sciences de l'environnement", "labelEn": "Environmental Sciences"},
              "sdu": {"code": "sdu", "labelFr": "Planète et Univers [physics]",
                      "labelEn": "Sciences of the Universe [physics]"},
              "sdv": {"code": "sdv", "labelFr": "Sciences du Vivant [q-bio]", "labelEn": "Life Sciences [q-bio]"},
              "shs": {"code": "shs", "labelFr": "Sciences de l'Homme et Société",
                      "labelEn": "Humanities and Social Sciences"},
              "spi": {"code": "spi", "labelFr": "Sciences de l'ingénieur [physics]",
                      "labelEn": "Engineering Sciences [physics]"},
              "stat": {"code": "stat", "labelFr": "Statistiques [stat]", "labelEn": "Statistics [stat]"}}

# kdtree=KDTree(D)


distlist = []
list_defis = []

n = 0
K = 50

for line in sys.stdin:
    data = json.loads(line)
    text = data['value']

    mv = model.get_sentence_vector(text.strip())
    t = np.asmatrix(mv)

    Dis, Ind = quantizer.search(t, K)
    ppv = Dis[0], Ind[0]  # ppv=Dis et Ind

    # ppv=kdtree.query(mv,k=K,p=2)#,distance_upper_bound=0.05)
    # dmax_k=kdtree.query(mv,k=[K],p=2)[0][0]

    dmax_k = Dis[0][K - 1]
    dN_ppv = ppv[0] / dmax_k
    distlist.append(ppv[0][0] / dmax_k)

    list_defis = list(ppv[1])
    list_defis_label = list(dico_nd[i] for i in list_defis)

    r = zip(list_defis_label, list(ppv[0]))
    dis = defaultdict(list)
    for i in set(r):
        dis[i[0]].append(1 / i[1])
    for k in dis.keys():
        dis[k] = sum(dis[k])
    ddd = np.array(list(dis.values()))
    sm = softmax(ddd)
    lab = list(dis.keys())
    res = zip(lab, sm)
    d4 = dict(res)
    classmax = max(d4.items(), key=operator.itemgetter(1))[0]
    cmax = classmax.split('_')[1].split('.')[0]

    if ppv[0][0] < 100:

        mm = max(list_defis_label, key=list_defis_label.count)

        ind = list(locate(list_defis_label, lambda a: a == mm))
        indd = list(dN_ppv)
        dmax = [indd[i] for i in ind]
        dist_mean = statistics.mean(dmax)
        prob0 = round((len(ind)) / (K + len(set(list_defis_label))), 3)
        prob = d4[classmax]
        if len(ind) < 25:
            dist_mean = str(round(dist_mean, 3)) + ' / ' + str(len(ind))

        data['value'] = verb_class[cmax]  # ,prob
        sys.stdout.write(json.dumps(data))
        sys.stdout.write('\n')

        n += 1
