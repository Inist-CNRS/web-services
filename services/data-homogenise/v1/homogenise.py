#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
from sentence_transformers import SentenceTransformer

similarity_thereshold = int(sys.argv[sys.argv.index('-p') + 1] if '-p' in sys.argv else 70)/100
if similarity_thereshold < 0 :
    similarity_thereshold=0.7
if similarity_thereshold >1:
    similarity_thereshold = 0.7
model = SentenceTransformer('./v1/all-MiniLM-L6-v2')


def homogenise(phrases, similarity_matrix, similarity_thereshold=similarity_thereshold):
    output = []
    already_homogenise = {}
    for i in range(similarity_matrix.shape[0]):
        for j in range(i+1):
            if i == j:
                output.append(phrases[i])
                break
            similarity_value = similarity_matrix[i, j].item()
                
            if similarity_value < similarity_thereshold:
                continue
            else:
                # Sans ce passage : imaginons nous avons 3 documents a b c
                # si b est homogénéisé par a et c par b
                # la sortie serait a a b mais nous on veut a a a
                indice_is_homogen_to = i
                already_homogenise[indice_is_homogen_to] = j
                
                while indice_is_homogen_to in already_homogenise:
                    indice_is_homogen_to = already_homogenise[indice_is_homogen_to]
                
                output.append(phrases[indice_is_homogen_to])
                break
    return output


#WS
all_data = []
for line in sys.stdin:
    data=json.loads(line)
    all_data.append(data)

len_data = len(all_data)
indice_noise = []
texts = []
for i in range(len_data):

    try:
        line = all_data[i]
        
        if "value" in line :
            value = line["value"]
            if type(value)==list:
                texts.append([elt for elt in value if isinstance(elt,str)])
            elif type(value)==str:
                texts.append([value])
            else:
                indice_noise.append(i)
                
        else:
            indice_noise.append(i)

    except:
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

output = homogenise(phrases, similarity_matrix)

len_ligne = len(indices_lignes)
indice_not_noise=0
for i in range(len_data):
    if i in indice_noise :
        all_data[i]["value"] = []
    else:
        all_data[i]["value"] = []
        for j in range(len_ligne):
            if indices_lignes[j] == indice_not_noise:
                all_data[i]["value"].append(output[j])
        indice_not_noise +=1 # Here we increment only if the row isn't noise

# Write all corpus in once
for line in all_data:
    sys.stdout.write(json.dumps(line))
    sys.stdout.write("\n")
