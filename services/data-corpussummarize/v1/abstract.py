#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
import requests
from sentence_transformers import SentenceTransformer
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score, davies_bouldin_score
from sklearn.metrics.pairwise import cosine_distances
import umap
import random
import os
import numpy as np
from collections import Counter
import time

# Paramètres globaux
os.environ["TOKENIZERS_PARALLELISM"] = "false"
api_key = os.getenv("ILAAS_API_KEY")
model = SentenceTransformer("./v1/all-MiniLM-L6-v2")
n_keywords = 20
# Langue du résultat (par défaut anglais)
lang_output = str(sys.argv[sys.argv.index("-p") + 1] if "-p" in sys.argv else "en")
if lang_output not in ["fr", "en"]:
    lang_output="en"


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


def find_optimal_k(features, max_k):
    silhouette_scores = []
    davies_scores = []

    for k in range(2, max_k + 1):
        kmeans = KMeans(n_clusters=k, random_state=42)
        labels = kmeans.fit_predict(features)

        sil_score = silhouette_score(features, labels, metric="euclidean")
        db_score = davies_bouldin_score(features, labels)

        silhouette_scores.append(sil_score)
        davies_scores.append(db_score)

    # Normalize silouhette and Davies-Bouldin score
    sil_scores_norm = (silhouette_scores - np.min(silhouette_scores)) / (np.max(silhouette_scores) - np.min(silhouette_scores))
    db_scores_norm = (davies_scores - np.min(davies_scores)) / (np.max(davies_scores) - np.min(davies_scores))

    # Compute a combined metric (0.5 and 0.5 to test and adjust after )
    combined_scores = 0.5 * sil_scores_norm - 0.5 * db_scores_norm

    optimal_index = np.argmax(combined_scores)
    optimal_k = optimal_index + 2  # k starts at 2

    return optimal_k


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


def truncate_text_for_teeft(text, max_char = 200000):
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
    if len(shuffled_text) > max_char:
        # Cut at 1 125 000 and remove potentially incomplete last line
        shuffled_text = shuffled_text[:max_char]
        shuffled_text = shuffled_text.rsplit("\n", 1)[0]

    return shuffled_text


def generate_summary_prompt(clusters, language=lang_output):
    context_parts = []
    for cluster_id, cluster_data in clusters.items():
        abstracts = "\n".join([f"- {abstract}" for abstract in cluster_data["best_abstracts"]])
        keywords = ", ".join(cluster_data["keywords"])
        context_parts.append(
            f"Thématique :\n"
            f"Extrait représentatif : {abstracts}\n"
            f"Mots-clés associés : {keywords}\n"
        )
    context = "\n\n".join(context_parts)

    # Prompt final
    if language=="fr":
        with open("v1/prompt/fr.txt", "r", encoding="utf-8") as file:
            prompt = file.read().format(context=context)
    if language=="en":
        with open("v1/prompt/en.txt", "r", encoding="utf-8") as file:
            prompt = file.read().format(context=context)

    return prompt.strip()


def call_llm_prompt(message: str, model_name: str = "gemma-4-31b", timeout: int = 60, retries: int = 3) -> str:
    messages = [{"role": "user", "content":message}]
    base_url = "https://llm.ilaas.fr/v1"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    payload = {
        "model": model_name,
        "messages": messages,
        "stream": False,
        "max_tokens": 10000
    }
    for attempt in range(retries):
        try:
            response = requests.post(
                f"{base_url}/chat/completions",
                headers=headers,
                json=payload,
                timeout=timeout
            )
            if response.ok:
                response_json = response.json()
                if 'choices' in response_json and len(response_json['choices']) > 0:
                    return response_json['choices'][0]['message']['content']
                else:
                    raise ValueError(f"Réponse inattendue de l'API : {response_json}")
            else:
                sys.stderr.write(f"Attempt {attempt + 1}: API returned {response.status_code} - {response.text}\n")
                if attempt < retries - 1:
                    time.sleep(2*(attempt+1))
        except Exception as e:
            sys.stderr.write(f"Attempt {attempt + 1}: Exception - {str(e)}\n")
            if attempt < retries - 1:
                time.sleep(2*(attempt+1))
    return ""
    
def main():
    ## WS
    # Embedding
    all_data = []
    for line in sys.stdin:
        data = json.loads(line)
        all_data.append(data)

    len_data = len(all_data)

    texts = []
    raw_texts = []
    indice_out_cluster = []
    for i in range(len_data):
        # c.inc()
        # push_to_gateway('jobs-metrics.daf.intra.inist.fr', job=job_name, registry=registry)

        try:
            line = all_data[i]

            if "value" in line:
                value = line["value"]
                if isinstance(value, str):
                    texts.append(model.encode(value))
                    raw_texts.append(value)
                else:
                    indice_out_cluster.append(i)

            else:
                indice_out_cluster.append(i)

        except:
            indice_out_cluster.append(i)


    # Dimension reduction
    umap_model = umap.UMAP(
        n_neighbors=max(10, min(30, int(len_data / 20))),
        n_components=10,
        metric="cosine",
        min_dist=0.0,
    )
    reduced_embeddings = umap_model.fit_transform(texts)

    try:
        nb_cluster = find_optimal_k(reduced_embeddings, max_k=8)
    except Exception as e:
        sys.stderr.write(f"Error in find_optimal_k : return 2 clusters. Error : {str(e)}")
        nb_cluster=2
    # Clustering
    clusterer = KMeans(n_clusters=nb_cluster, random_state=42)
    clusterer.fit(reduced_embeddings)


    # Extract p best documents
    top_p_documents_per_cluster = {}
    # Nb de document par cluster à récupérer (8 pour 2 et décroît jusqu'à 2 pour 8)
    p = 16//nb_cluster
    for cluster_id in range(nb_cluster):
        top_p_documents_per_cluster[cluster_id] = {"best_abstracts": []}
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
            top_p_documents_per_cluster[cluster_id]["best_abstracts"].append(
                raw_texts[idx].replace("<AI-generated>", "").strip()[:2000]
                )


    # Create datas for teeft
    keywords = (
        {}
    )  # keywords is a dictionary, the key is the cluster and value the input / output of teeft

    for i in range(len(raw_texts)):
        label = int(clusterer.labels_[i])
        if label >= 0:
            if label in keywords:
                keywords[label] += "\n" + str(all_data[i]["value"])
            else:
                keywords[label] = str(all_data[i]["value"])

    # Execute teeft
    for i in range(nb_cluster):
        data = {"id": i, "value": truncate_text_for_teeft(keywords[i])}
        keywords[i] = teeft(data, n_keywords)

    # Filter dict : delete every keywords who has a to big frequency
    try:
        keywords = filter_keywords(keywords, threshold=0.5)
    except:
        pass

    for cluster_id in range(nb_cluster):
        top_p_documents_per_cluster[cluster_id]["keywords"] = keywords[cluster_id]
    cluster_counts = Counter(clusterer.labels_)
    for cluster_id, count in cluster_counts.items():
        top_p_documents_per_cluster[cluster_id]["size_cluster"] = count/len(raw_texts)
        

    prompt = generate_summary_prompt(top_p_documents_per_cluster)
    corpus_abstract = call_llm_prompt(prompt)

    sys.stdout.write(json.dumps({"value": corpus_abstract}))
    sys.stdout.write("\n")

if __name__ == "__main__":
    main()
