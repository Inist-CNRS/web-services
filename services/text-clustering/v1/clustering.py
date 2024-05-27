#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
import umap.umap_ as umap
from sentence_transformers import SentenceTransformer
from sklearn.preprocessing import StandardScaler
from sklearn.metrics.pairwise import cosine_distances
# Two hdbscan aglos : normal and from sklearn
# import hdbscan
from sklearn.cluster import HDBSCAN


def center_reduce(matrix):
    """
    A function to center and reduce a given matrix using StandardScaler.
    
    Parameters:
    matrix (array-like): The input matrix to be centered and reduced.
    
    Returns:
    array-like: The centered and reduced matrix.
    """
    # center and reduce
    scaler = StandardScaler()
    scaler.fit(matrix)
    matrix_center_reduce =scaler.transform(matrix) 

    return matrix_center_reduce

model = SentenceTransformer('./v1/all-MiniLM-L6-v2')


## WS
# Datas
all_data = []
for line in sys.stdin:
    data=json.loads(line)
    all_data.append(data)

len_data = len(all_data)

texts=[]
for i in range(len_data):
    try:
        line = all_data[i]
        
        if "value" in line :
            value = line["value"]
            if type(value)==list:
                texts.append(model.encode(" ".join(value)))
            elif type(value)==str:
                texts.append(model.encode(value))
            else:
                texts.append("")
                
        else:
            texts.append("")

    except:
        texts.append("")


# Reduce DIM from 700+ to 10
embeddings = umap.UMAP(n_neighbors=30,
                       n_components=10,
                       metric='cosine').fit_transform(center_reduce(texts))

embeddings = center_reduce(embeddings)
cosine_dist_matrix = cosine_distances(embeddings, embeddings)


## HDBSCAN with hdbscan library
# clusterer = hdbscan.HDBSCAN(algorithm='best',
#                             prediction_data=True,
#                             approx_min_span_tree=True,
#                             gen_min_span_tree=True,
#                             min_cluster_size=int(max(10,len_data/50)),
#                             cluster_selection_epsilon = 0.02,
#                             min_samples=1,
#                             p=None,
#                             metric='precomputed',
#                             cluster_selection_method='eom')

# HDBSCAN with scikit-learn
clusterer = HDBSCAN(
    algorithm='auto',
    metric='precomputed',
    min_cluster_size=int(max(10,len_data/100)),
    cluster_selection_epsilon = 0.01,
    min_samples=1,
    cluster_selection_method="eom",
    n_jobs=-1) 


clusterer.fit(cosine_dist_matrix)


# extract infos
res = []
indice_in_cluster=0
for i in range(len(all_data)):
        all_data[i]["value"]={"cluster":int(clusterer.labels_[indice_in_cluster]+1), "weight":str(clusterer.probabilities_[indice_in_cluster])}
        indice_in_cluster +=1 # Here we increment only if the row isn't noise, because they aren't count in "clusterer model"


# Write all corpus in once
for line in all_data:
    sys.stdout.write(json.dumps(line))
    sys.stdout.write("\n")
