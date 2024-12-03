#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
import requests
from sentence_transformers import SentenceTransformer
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
import umap
import os

os.environ["TOKENIZERS_PARALLELISM"] = "false"
model = SentenceTransformer('./v1/all-MiniLM-L6-v2')
n_keywords = 20
nb_cluster = int(sys.argv[sys.argv.index('-p') + 1] if '-p' in sys.argv else 0)
if nb_cluster > 30 :
    nb_cluster = 30
if nb_cluster < 2 and nb_cluster !=0 :
    nb_cluster = 2


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


def find_optimal_k(distance_matrix, max_k):
    silhouette_scores = []
    
    for k in range(2, max_k+1):
        kmeans = KMeans(n_clusters=k, random_state=42)
        kmeans.fit(distance_matrix)
        
        score = silhouette_score(distance_matrix, kmeans.labels_, metric='euclidean')
        silhouette_scores.append(score)
    
    # keep the k who gives the best silouhette score
    optimal_k = silhouette_scores.index(max(silhouette_scores)) + 2
    
    return optimal_k


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


def filter_keywords(data, threshold):
    """function who filter teeft results

    Args:
        keywords_dict (dict): dict to filter
        threshold (float): thereshold

    Returns:
        dict: dict filtered
    """
    word_count = {}
    
    for key, keywords in data.items():
        for keyword in keywords:
            if keyword in word_count:
                word_count[keyword] += 1
            else:
                word_count[keyword] = 1
    
    filtered_data = {}
    
    for key, keywords in data.items():
        filtered_keywords = [keyword for keyword in keywords if word_count[keyword]/len(data) <= threshold]
        filtered_data[key] = filtered_keywords
    
    return filtered_data


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
umap_model = umap.UMAP(n_neighbors=max(10, min(30,int(len_data/20))), n_components=10, metric='cosine', random_state=42, min_dist=0.0)
reduced_embeddings = umap_model.fit_transform(texts)

if nb_cluster == 0:
    nb_cluster = find_optimal_k(reduced_embeddings, max_k=30)

# Clustering
clusterer = KMeans(n_clusters=nb_cluster, random_state=42)
clusterer.fit(reduced_embeddings)


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

# Filter dict : delete every keywords who has a to big frequency
try:
    keywords = filter_keywords(keywords, threshold=0.5)
except:
    pass
# Add res for noise cluster
keywords[0] = []

# extract infos and return teeft res
indice_in_cluster=0
for i in range(len_data):
    if i in indice_out_cluster :
        all_data[i]["value"] = {"cluster":0, "keywords": []}
    else:
        label = int(clusterer.labels_[indice_in_cluster]+1)
        all_data[i]["value"]={
            "cluster":label,
            "keywords":keywords[label]
            }
        indice_in_cluster +=1 # Here we increment only if the row isn't noise, because they aren't count in "clusterer model"


# Write all corpus in once
for line in all_data:
    sys.stdout.write(json.dumps(line))
    sys.stdout.write("\n")
