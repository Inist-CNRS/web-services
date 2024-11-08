#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
import requests
from sentence_transformers import SentenceTransformer
from sklearn.preprocessing import StandardScaler
from sklearn.metrics.pairwise import cosine_distances
from sklearn.decomposition import PCA
from sklearn.cluster import HDBSCAN

# from prometheus_client import CollectorRegistry, Counter, push_to_gateway
# registry = CollectorRegistry()
# c = Counter('documents', 'Number of documents processed', registry=registry)
# job_name='clustering'


# Get the index of "p" param (given by the user) and assign it to "nb". 20 if not found
nbTopic = sys.argv[sys.argv.index('-p') + 1] if '-p' in sys.argv else 20


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


def teeft(data, n_keywords, language="en"):
    try:
        url = f"https://terms-extraction.services.istex.fr/v1/teeft/{language}?nb={n_keywords}"
        headers = {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            }
        response = requests.post(url, headers=headers, data=json.dumps([data]))
        data = response.json()
        return data[0]["value"]
    except:
        return []


model = SentenceTransformer('./v1/all-MiniLM-L6-v2')
n_keywords = 20


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
pca = PCA(n_components=0.95)
embeddings = pca.fit_transform(center_reduce(texts))
cosine_dist_matrix = cosine_distances(embeddings, embeddings)


# HDBSCAN with scikit-learn
clusterer = HDBSCAN(
    algorithm='auto',
    metric='precomputed',
    min_cluster_size=int(max(5,len_data/20)),
    cluster_selection_epsilon = 0.05,
    min_samples=2,
    cluster_selection_method="eom",
    n_jobs=-1) 


clusterer.fit(cosine_dist_matrix)


# Create datas for teeft
indice_in_cluster=0
keywords = {} #keywords is a dictionary, the key is the cluster and value the input / output of teeft
for i in range(len_data):
    if i not in indice_out_cluster :
        label = int(clusterer.labels_[indice_in_cluster]+1)
        if label != 0:
            if label in keywords:
                keywords[label] += "\n" + str(all_data[i]["value"])
            else:
                keywords[label] = str(all_data[i]["value"])
        indice_in_cluster+=1

# Execute teeft
n_clusters = len(keywords)
for i in range(n_clusters):
    data = {"id": i+1, "value": keywords[i+1]}
    keywords[i+1] = teeft(data, n_keywords)
# Add res for noise cluster
keywords[0] = []


# extract infos and return teeft res
indice_in_cluster=0
for i in range(len_data):
    if i in indice_out_cluster :
        all_data[i]["value"] = {"cluster":0, "weight":"1.0", "keywords": []}
    else:
        label = int(clusterer.labels_[indice_in_cluster]+1)
        all_data[i]["value"]={
            "cluster":label,
            "weight":str(clusterer.probabilities_[indice_in_cluster]),
            "keywords":keywords[label]
            }
        indice_in_cluster +=1 # Here we increment only if the row isn't noise, because they aren't count in "clusterer model"


# Write all corpus in once
for line in all_data:
    sys.stdout.write(json.dumps(line))
    sys.stdout.write("\n")
