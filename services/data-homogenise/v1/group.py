#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
from sentence_transformers import SentenceTransformer

similarity_threshold = int(sys.argv[sys.argv.index('-p') + 1] if '-p' in sys.argv else 70)/100
if similarity_threshold < 0:
    similarity_threshold = 0.7
if similarity_threshold > 1:
    similarity_threshold = 0.7
    
model = SentenceTransformer('./v1/all-MiniLM-L6-v2')


def group_by_similarity(phrases, similarity_matrix, similarity_threshold=similarity_threshold):
    output = {}
    already_homogenise = {}
    for i in range(similarity_matrix.shape[0]):
        for j in range(i+1):
            if i == j:
                output[i] = [phrases[i]]
                break
            similarity_value = similarity_matrix[i, j].item()
                
            if similarity_value < similarity_threshold:
                continue
            else:
                # Sans ce passage : imaginons nous avons 3 documents a b c
                # si b est groupé avec a et c avec b
                # les éléments ne seraient pas correctement groupés
                indice_is_homogen_to = i
                already_homogenise[indice_is_homogen_to] = j
                
                while indice_is_homogen_to in already_homogenise:
                    indice_is_homogen_to = already_homogenise[indice_is_homogen_to]
                
                if phrases[i] not in output[indice_is_homogen_to]:
                    output[indice_is_homogen_to].append(phrases[i])
                break
    return output


# WS
all_data = []
for line in sys.stdin:
    data = json.loads(line)
    all_data.append(data)

len_data = len(all_data)
indice_noise = []
texts = []
for i in range(len_data):

    try:
        line = all_data[i]
        
        if "value" in line:
            value = line["value"]
            if isinstance(value, list):
                texts.append([elt for elt in value if isinstance(elt, str)])
            elif isinstance(value, str):
                texts.append([value])
            else:
                indice_noise.append(i)
                
        else:
            indice_noise.append(i)

    except Exception:
        indice_noise.append(i)


# Flatten and keep indice
phrases = []
indices_lignes = []
for i, sous_liste in enumerate(texts):
    for phrase in sous_liste:
        phrases.append(phrase)
        indices_lignes.append(i)

embeddings = model.encode(phrases)
similarity_matrix = model.similarity(embeddings, embeddings)

output = group_by_similarity(phrases, similarity_matrix)

res = []
for idx in output:
    res.append(output[idx])
res.sort(reverse=True, key=len)

sys.stdout.write(json.dumps({"value": res}))
sys.stdout.write("\n")
