#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sinr.graph_embeddings as ge
import unicodedata
import numpy as np
import json
import sys
from sklearn.preprocessing import StandardScaler
from sklearn.metrics.pairwise import cosine_distances
import hdbscan

# from prometheus_client import CollectorRegistry, Counter, push_to_gateway
# registry = CollectorRegistry()
# c = Counter('documents', 'Number of documents processed', registry=registry)
# job_name='clustering'

#model
sinr_vec = ge.SINrVectors('v1/sinr_vector_scientific_abstract')
sinr_vec.load()
dim_model = sinr_vec.get_number_of_dimensions()
stopword_list = ["study","abstract","result","prospective","nested"]


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

#normalize text
def uniformize(input_str):
    text =  ''.join(
        c for c in unicodedata.normalize('NFKD', input_str)
        if ( unicodedata.category(c) != 'Mn' and c.isalpha() ) or c == "'" or c == ' '
    )
    return ' '.join(text.lower().split())


def embedding_sentence(sentence, model, dim_model = dim_model):
    len_sentence = 0
    embedding = np.zeros(dim_model)
    for word in sentence.split(" "):
        try:
            embedding += model.get_my_vector(word)
            len_sentence +=1
        except:
            continue

    if len_sentence > 0:
        return embedding/len_sentence, True
    return embedding, False


def custom_flatten(matrix):
    return [item.replace("_", " ") for row in matrix for item in row if (item not in stopword_list and len(item)>2)]


def describe_kbest_dim(model, vec, k, max_words=6, thereshold=0.21):
    best_dims = np.argsort(vec)[-k:]
    descriptors = []
    for dimension in reversed(best_dims):
        descriptors.append(model.get_dimension_stereotypes_idx(dimension,max_words))
        
    res = []
    for descriptor in descriptors:
        res.append([y for x,y in descriptor.get_interpreters() if x>thereshold])
    return custom_flatten(res)


def extract_informations_from_cluster(texts, clusterer, model=sinr_vec):
    """Use describe_kbest_dim to get information on clusterer

    Args:
        texts (list): embeddings sinr
        clusterer (HDBSCAN): the clusterer
    """
    cluster_dict = {}
    for i in range(len(texts)):
        label = int(clusterer.labels_[i])+1
        if label == 0:
            continue
        
        if label not in cluster_dict:
            cluster_dict[label] = []
        cluster_dict[label].append(texts[i])
        
    for label in cluster_dict:
        # compute a mean vector of the cluster to extract information from best dimensions
        information_cluster = np.array(cluster_dict[label]).mean(axis=0)
        
        cluster_dict[label] = describe_kbest_dim(model, information_cluster, 5)

    return cluster_dict
        



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
        
        if "value" in line and isinstance(line["value"],str) :
            value = line["value"]
            embedding, isnt_noise = embedding_sentence(value, sinr_vec)
            if isnt_noise:
                texts.append(embedding)
            else:
                indice_out_cluster.append(i)

                            
        else:
            indice_out_cluster.append(i)

    except Exception as e:
        sys.stderr.write(str(e))
        indice_out_cluster.append(i)

# Without dimension reduction
embeddings = np.array(texts)
embeddings = center_reduce(embeddings)
cosine_dist_matrix = cosine_distances(embeddings, embeddings)


## HDBSCAN with hdbscan library
clusterer = hdbscan.HDBSCAN(algorithm='best',
                            prediction_data=False, # on exec le modèle qu'une fois
                            approx_min_span_tree=False, # Approximation pour le calcul => True augmente la rapidité
                            gen_min_span_tree=False,
                            min_cluster_size=int(max(5, len_data/50)),
                            cluster_selection_epsilon = min(0.05, max(0.001, len_data/1000000)),
                            min_samples= int(min(10, 1 + len_data/1000)),
                            p=None,
                            metric='precomputed',
                            cluster_selection_method='eom',
                            n_jobs=-1)

# HDBSCAN with scikit-learn
# clusterer = HDBSCAN(
#     algorithm='auto',
#     metric='precomputed',
#     min_cluster_size=int(max(5,len_data/100)),
#     cluster_selection_epsilon = 0,
#     min_samples=1,
#     cluster_selection_method="eom",
#     n_jobs=-1)

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
