#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
import requests
from sentence_transformers import SentenceTransformer
from sklearn.preprocessing import StandardScaler
from sklearn.metrics.pairwise import cosine_distances
from sklearn.cluster import HDBSCAN
import umap


model = SentenceTransformer('./v1/all-MiniLM-L6-v2')


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


## WS
# Embedding
all_data = []
for line in sys.stdin:
    data=json.loads(line)
    all_data.append(data)

len_data = len(all_data)

texts=[]
indice_out_cluster = []
for i in range(len_data):
    # c.inc()
    # push_to_gateway('jobs-metrics.daf.intra.inist.fr', job=job_name, registry=registry)

    try:
        line = all_data[i]
        
        if "value" in line :
            value = line["value"]
            if type(value)==list:
                texts.append(model.encode(" ".join(value)))
            elif type(value)==str:
                    texts.append(model.encode(value))
            else:
                indice_out_cluster.append(i)
                
        else:
            indice_out_cluster.append(i)

    except:
        indice_out_cluster.append(i)

# Dimension reduction
umap_model = umap.UMAP(n_neighbors=max(10, min(30,int(len_data/20))), n_components=2, metric='cosine', random_state=42, min_dist=0.0)
reduced_embeddings = umap_model.fit_transform(texts)  # embeddings sont tes vecteurs de texte


# HDBSCAN with scikit-learn
clusterer = HDBSCAN(
    algorithm='auto',
    metric='euclidean',
    min_cluster_size=2,
    cluster_selection_epsilon = 0,
    min_samples=2,
    cluster_selection_method="eom",
    n_jobs=-1) 

clusterer.fit(reduced_embeddings)


# extract infos
res = []
indice_in_cluster=0
for i in range(len_data):
    line = all_data[i]
    if i in indice_out_cluster:
        line["value"] = "no_abstract"
    else:
        if clusterer.labels_[indice_in_cluster] ==-1:
            line["value"] ="noise"
        else:
            line["value"] = "relevant"
        indice_in_cluster +=1 # Here we increment only if the row isn't noise, because they aren't count in "clusterer model"

    sys.stdout.write(json.dumps(line))
    sys.stdout.write("\n")
