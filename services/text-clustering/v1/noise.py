#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
import requests
from sentence_transformers import SentenceTransformer
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import HDBSCAN
import umap
import os

os.environ["TOKENIZERS_PARALLELISM"] = "false"
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
    if matrix is None or len(matrix) == 0:
        return matrix
    scaler = StandardScaler()
    scaler.fit(matrix)
    matrix_center_reduce = scaler.transform(matrix) 

    return matrix_center_reduce


# # WS
# Embedding
all_data = []
for line in sys.stdin:
    data = json.loads(line)
    all_data.append(data)

len_data = len(all_data)

texts = []
indice_out_cluster = []
for i in range(len_data):
    # c.inc()
    # push_to_gateway('jobs-metrics.daf.intra.inist.fr', job=job_name, registry=registry)

    try:
        line = all_data[i]
        
        if "value" in line:
            value = line["value"]
            
            if isinstance(value, list):
                to_embedded = " ".join(value)
                if len(to_embedded.replace(" ", "")) < 4:
                    indice_out_cluster.append(i)
                    continue
                texts.append(model.encode(to_embedded))
                
            elif isinstance(value, str):
                if len(value) < 4:
                    indice_out_cluster.append(i)
                    continue
                texts.append(model.encode(value))
                
            else:
                indice_out_cluster.append(i)
                
        else:
            indice_out_cluster.append(i)

    except Exception:
        indice_out_cluster.append(i)

# Dimension reduction
umap_model = umap.UMAP(
    n_neighbors=max(10, min(30, int(len_data/20))),
    n_components=2,
    metric='cosine',
    min_dist=0.0,
    random_state=42,
    n_jobs=1)

try:
    reduced_embeddings = umap_model.fit_transform(texts)
except Exception as e:
    sys.stderr.write(f"Error in noiseDetect while UMAP processing : {e}")
    reduced_embeddings = center_reduce(texts)

# HDBSCAN with scikit-learn
clusterer = HDBSCAN(
    algorithm='auto',
    metric='euclidean',
    min_cluster_size=2,
    cluster_selection_epsilon=0,
    min_samples=2,
    cluster_selection_method="eom",
    n_jobs=-1) 

try:
    clusterer.fit(reduced_embeddings)
except Exception as e:
    sys.stderr.write(f"Error in noiseDetect while HDBSCAN processing : {e}")
    indice_out_cluster = [i for i in range(len_data)]


# extract infos
res = []
indice_in_cluster = 0
text_output = ""
for i in range(len_data):
    line = all_data[i]
    if i in indice_out_cluster:
        line["value"] = "no_abstract"
    else:
        if clusterer.labels_[indice_in_cluster] == -1:
            line["value"] = "noise"
        else:
            line["value"] = "relevant"
        # Increment only if the row isn't noise (they aren't count in "clusterer model")
        indice_in_cluster += 1
    sys.stdout.write(json.dumps(line))
    sys.stdout.write("\n")
