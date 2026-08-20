#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
import requests
from sentence_transformers import SentenceTransformer
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
from sklearn.metrics.pairwise import cosine_distances
import random
import umap
import os
import numpy as np
from clust import name_cluster_functions as ncf


os.environ["TOKENIZERS_PARALLELISM"] = "false"
MODEL_PATH = os.path.join(os.path.dirname(__file__), "all-MiniLM-L6-v2")

model = SentenceTransformer(MODEL_PATH)

n_keywords = 20
nb_cluster = int(sys.argv[sys.argv.index("-p") + 1] if "-p" in sys.argv else 0)
if nb_cluster > 30:
    nb_cluster = 30
if nb_cluster < 2 and nb_cluster != 0:
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
    matrix_center_reduce = scaler.transform(matrix)

    return matrix_center_reduce


def find_optimal_k(X, min_k=2, max_k=21):
    """Use a ternary search algorithm to find the number of clusters (k)
    that maximize the silouhette score of the algorithm.

    Args:
        X (list): embeddings of documents to cluster
        min_k (int, optional): Can't have less than 2 clusters. Defaults to 2.
        max_k (int, optional): Cant' have more than 21 clusters. Defaults to 21.
    """

    def evaluate(k):
        if k not in scores:
            kmeans = KMeans(n_clusters=k, random_state=42)
            labels = kmeans.fit_predict(X)
            scores[k] = silhouette_score(X, labels, metric="euclidean")
        return scores[k]

    if max_k < 5:
        return 2

    scores = {}
    best_k = min_k
    best_score = -1
    left, right = min_k, max_k

    while right - left > 2:
        mid1 = left + (right - left) // 3
        mid2 = right - (right - left) // 3

        score1, score2 = evaluate(mid1), evaluate(mid2)

        if score1 > score2:
            right = mid2
            if score1 > best_score:
                best_k, best_score = mid1, score1
        else:
            left = mid1
            if score2 > best_score:
                best_k, best_score = mid2, score2

    if left == 2:
        score1 = evaluate(2)

    best_k = max(scores, key=scores.get)

    return best_k


def teeft(data, n_keywords, language="en"):
    try:
        url = f"https://terms-extraction.services.istex.fr/v1/teeft/{language}?nb={n_keywords}"
        headers = {
            "accept": "application/json",
            "Content-Type": "application/json",
        }
        response = requests.post(url, headers=headers, data=json.dumps([data]))
        data = response.json()
        return data[0]["value"]
    except Exception:
        return []


def filter_keywords(data, threshold):
    """function who filter teeft results

    Args:
        keywords_dict (dict): dict to filter
        threshold (float): threshold

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
        filtered_keywords = [
            keyword
            for keyword in keywords
            if word_count[keyword] / len(data) <= threshold
        ]
        filtered_data[key] = filtered_keywords

    return filtered_data


def truncate_text_for_teeft(text):
    """
    Truncate text for teeft if it is too large.
    I observed that teeft can easily process text of 1 125 000 characters,
    but more can be complicated.
    """
    # Shuffle paragraphs
    paragraphs = text.split("\n\n")
    random.shuffle(paragraphs)
    shuffled_text = "\n\n".join(paragraphs)

    # Truncate if necessary
    if len(shuffled_text) > 1125000:
        # Cut at 1 125 000 and remove potentially incomplete last line
        truncated = shuffled_text[:1125000]
        truncated = truncated.rsplit("\n", 1)[0]
        return truncated
    return shuffled_text


def extract_best_documents(raw_texts, embedding_texts, clusterer, nb_cluster):
    # Extract p best documents
    top_p_documents_per_cluster = {}
    # Nb de document par cluster à récupérer (8 pour 2 et décroît jusqu'à 2 pour 8)
    p = 16//nb_cluster
    for cluster_id in range(nb_cluster):
        top_p_documents_per_cluster[str(cluster_id+1)] = {"best_abstracts": []}
        indices_in_cluster = np.where(clusterer.labels_ == cluster_id)[0]
        texts_in_cluster = [
            texts[id_in_cluster] for id_in_cluster in indices_in_cluster
            ]
        
        barycenter = np.mean(texts_in_cluster, axis=0)
        distances_to_barycenter = cosine_distances(
            texts_in_cluster,
            barycenter.reshape(1, -1)
            )
        
        sorted_indices = list(indices_in_cluster[
            np.argsort(distances_to_barycenter.flatten())
            ])
        sorted_indices.reverse()
        p = min(p, len(sorted_indices))
        for idx in sorted_indices[:p]:
            top_p_documents_per_cluster[str(cluster_id+1)]["best_abstracts"].append(
                raw_texts[idx].replace("<AI-generated>", " ").strip()[:2000]
                )
    return top_p_documents_per_cluster

# # WS
# Embedding
all_data = []
for line in sys.stdin:
    data = json.loads(line)
    all_data.append(data)

ncf.write_in_logs("Données reçues")

len_data = len(all_data)

raw_texts = []
texts = []
indice_out_cluster = []
for i in range(len_data):
    # c.inc()
    # push_to_gateway('jobs-metrics.daf.intra.inist.fr', job=job_name,
    # registry=registry)

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
                raw_texts.append(str(" ; ".join(value)))
                
            elif isinstance(value, str):
                if len(value) < 4:
                    indice_out_cluster.append(i)
                    continue
                texts.append(model.encode(value))
                raw_texts.append(value)
                
            else:
                indice_out_cluster.append(i)

        else:
            indice_out_cluster.append(i)

    except Exception:
        indice_out_cluster.append(i)


texts = np.array(texts)
ncf.write_in_logs("Embeddings calculés")

if len(texts) == 0:
    indice_out_cluster = list(range(len_data))
    reduced_embeddings = np.empty((0, 10))
else:
    try:
        umap_model = umap.UMAP(
            n_neighbors=max(10, min(30, int(len(texts)/20))),
            n_components=10,
            metric="cosine",
            random_state=42,
            min_dist=0.0,
            n_jobs=1
        )
        reduced_embeddings = umap_model.fit_transform(texts)
    except Exception as e:
        ncf.write_in_logs("Error in textClustering while UMAP processing", e)
        reduced_embeddings = center_reduce(texts)

ncf.write_in_logs("Dimension réduite")

if reduced_embeddings.shape[0] < nb_cluster:
    nb_cluster = max(1, reduced_embeddings.shape[0] - 1)
else:
    if nb_cluster == 0:
        nb_cluster = find_optimal_k(reduced_embeddings, max_k=min(21, len(texts)-2))

try:
    clusterer = KMeans(n_clusters=nb_cluster, random_state=42)
    clusterer.fit(reduced_embeddings)
    clustering_done = True
except Exception as e:
    ncf.write_in_logs("Error in textClustering while KMEANS processing", e)
    clustering_done = False



# Create datas for teeft
indice_in_cluster = 0
keywords = (
    {}
)  # keywords is a dictionary, the key is the cluster and value texts from clus

if clustering_done:
    ncf.write_in_logs("Clustering exécuté")
    for i in range(len_data):
        if i not in indice_out_cluster:
            label = str(int(clusterer.labels_[indice_in_cluster] + 1))
            if label != 0:
                if label in keywords:
                    keywords[label] += "\n\n" + str(all_data[i]["value"])
                else:
                    keywords[label] = str(all_data[i]["value"])
            indice_in_cluster += 1

    # Execute teeft
    empty_keywords = True
    n_clusters = len(keywords)
    for i in range(n_clusters):
        label = str(i+1)
        if label in keywords:
            keywords[label] = truncate_text_for_teeft(keywords[label])
            data = {"id": label, "value": keywords[label]}
            teef_res = teeft(data, n_keywords)
            if len(teef_res) > 0:
                empty_keywords = False
            keywords[label] = teef_res
        else:
            continue
    ncf.write_in_logs("Appels à Teeft terminés")

    # Filter dict : delete every keywords who has a to big frequency
    try:
        keywords = filter_keywords(keywords, threshold=0.5)
    except Exception:
        pass
    
    # Add top docs to dictonary
    top_p_doc_per_cluster = extract_best_documents(raw_texts, texts, clusterer, nb_cluster)

    # Name clusters (only if there is keywords)
    if not empty_keywords:
        for idx in top_p_doc_per_cluster.keys():
            top_p_doc_per_cluster[idx]["keywords"]= keywords[idx]
        ncf.write_in_logs(json.dumps(top_p_doc_per_cluster))

        clusters_names = ncf.name_and_resume_cluster(top_p_doc_per_cluster)
        ncf.write_in_logs("Clusters nommés")

    else:
        clusters_names = {str(i+1): {"title": "Unknown", "abstract": "Unknown"} for i in range(n_clusters)}

    # Add res for noise cluster
    keywords["0"] = []
else:
    indice_out_cluster = [i for i in range(len_data)]

# extract infos and return teeft res
indice_in_cluster = 0
for i in range(len_data):
    if i in indice_out_cluster:
        all_data[i]["value"] = {"cluster": "0", "cluster_name":"Unknown", "keywords": []}
    else:
        label = str(int(clusterer.labels_[indice_in_cluster] + 1))
        all_data[i]["value"] = {"cluster": label, "cluster_name":clusters_names[label], "keywords": keywords[label]}
        # increment on cluster indices only bc noise isn't in "clusterer model"
        indice_in_cluster += 1


# Write all corpus in once
for line in all_data:
    sys.stdout.write(json.dumps(line))
    sys.stdout.write("\n")
    
ncf.write_in_logs("Job terminé")
