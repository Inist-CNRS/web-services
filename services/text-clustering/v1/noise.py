#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
import umap.umap_ as umap
from sentence_transformers import SentenceTransformer
from sklearn.preprocessing import StandardScaler
from sklearn.metrics.pairwise import cosine_distances
from sklearn.cluster import HDBSCAN

# from prometheus_client import CollectorRegistry, Counter, push_to_gateway
# registry = CollectorRegistry()
# c = Counter('documents', 'Number of documents processed', registry=registry)
# job_name='clustering'


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
indice_out_cluster = []
for i in range(len_data):
    # c.inc()
    # push_to_gateway('jobs-metrics.daf.intra.inist.fr', job=job_name, registry=registry)

    try:
        line = all_data[i]
        
        if "value" in line :
            value = line["value"]
            if type(value)==list:
                texts.append(model.encode(" ".join(value)[:512]))
            elif type(value)==str:
                    texts.append(model.encode(value[:512]))
            else:
                indice_out_cluster.append(i)
                
        else:
            indice_out_cluster.append(i)

    except:
        indice_out_cluster.append(i)

# Reduce DIM from 700+ to 10
embeddings = umap.UMAP(n_neighbors=30,
                       n_components=8,
                       metric='cosine',
                       init='random').fit_transform(center_reduce(texts))

embeddings = center_reduce(embeddings)
cosine_dist_matrix = cosine_distances(embeddings, embeddings)


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
output = []
for i in range(len_data):
    if i in indice_out_cluster:
        output.append({"id":all_data[i]["id"], "value": all_data[i]["id"]})
    else:
        if clusterer.labels_[indice_in_cluster] ==-1:
            output.append({"id":all_data[indice_in_cluster]["id"], "value": all_data[indice_in_cluster]["id"]})
        indice_in_cluster +=1 # Here we increment only if the row isn't noise, because they aren't count in "clusterer model"

# Write all corpus in once
if len(output)==0:
    sys.stdout.write(json.dumps({"id":"n/a","value":""}))
    sys.stdout.write("\n")
else :
    for line in output:
        sys.stdout.write(json.dumps(line))
        sys.stdout.write("\n")