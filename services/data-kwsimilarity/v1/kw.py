#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import json
import time
import os
import re
import fasttext

import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer

import tempfile
import atexit

import nltk
from nltk import word_tokenize, pos_tag
from nltk.corpus import stopwords

# --------------------------------------- Explication des patterns ---------------------------------------

# pattern 1 : (?:abstract|title):\(([^)]+)\) (cas 1 et 3)
# Premier cas (monoterme) : title:("keyword1" "keyword2" "keyword3")
# Troisième cas (bigramme et monoterme) : title:("keyword1 keyword2" "keyword3")

# pattern 2 : (?:abstract|title):\"([^\"]+)\" (cas 4 et 5)
# Quatrième cas (bigramme) : title:"keyword1 keyword2"
# Cinquième cas (bigramme) : (title:"keyword1 keyword2" "keyword3") !!!!! On ne le gère pas encore

# pattern 3 : (?:abstract|title):(\w+) (cas 2)
# Deuxième cas (monoterme) : title:keyword

# --------------------------------------- Fin explication des patterns ---------------------------------------

def get_keywords(query: str):

    # Pattern 1 : (cas 1 et 3)
    m1 = re.findall(r'(?:abstract|title):\(([^)]+)\)', query, re.MULTILINE)
    if m1:
        parts = ["".join(x) for x in m1]
        parts = [x.replace('" "', '","').replace('"', '').split(',') for x in parts]
        print(f"Pattern 1 raw matches: {parts}", file=sys.stderr)
        return parts 

    # Pattern 2 : (cas 4 et 5)
    m2 = re.findall(r'(?:abstract|title):"([^"]+)"', query, re.MULTILINE)
    if m2:
        print(f"Pattern 2 raw matches: {m2}", file=sys.stderr)
        return m2

    # Pattern 3 : (cas 2)
    m3 = re.findall(r'(?:abstract|title):(\w+)', query, re.MULTILINE)
    if m3:
        print(f"Pattern 3 raw matches: {m3}", file=sys.stderr)
        return m3

    # Aucun pattern trouvé
    return None, []


def cleaned_keywords(list_keywords):
    cleaned_list = []
    print(f"Cleaning keywords: {list_keywords}", file=sys.stderr)
    
    # Si la liste de mots-clés est une liste de listes (pattern 1 : cas 1 et 3)
    if isinstance(list_keywords, list) and len(list_keywords) > 0 and isinstance(list_keywords[0], list):
        keywords = list_keywords[0]
        print(f"Traitement liste de listes: {keywords}", file=sys.stderr)

    # Cas liste plate (pattern 2 et 3 : cas 2 et 4)
    elif isinstance(list_keywords, list):
        keywords = list_keywords
        print(f"Traitement liste plate: {keywords}", file=sys.stderr)

    else:
        print(f"Unexpected format for keywords: {list_keywords}", file=sys.stderr)
        return cleaned_list  # Retourne liste vide si format invalide
    
    # Traitement commun aux deux cas
    for kw in keywords:
        if " " in kw:
            bigram = kw.strip().lower().replace(" ", "_")
            cleaned_list.append(bigram)
            print(f"bigram: {bigram}", file=sys.stderr)
        else:
            unigram = kw.strip().lower()
            cleaned_list.append(unigram)
            print(f"unigram: {unigram}", file=sys.stderr)

    return cleaned_list


def extract_ngramsPOS_nltk(text):
    tokens = word_tokenize(text.lower())
    pos_tags = pos_tag(tokens) 
    bigrams = []
    for i in range(len(pos_tags)-1):
        t1, t2 = pos_tags[i], pos_tags[i+1]
        word1, tag1 = t1
        word2, tag2 = t2

        # ADJ + NOUN
        if tag1 in {"JJ", "JJR", "JJS"} and tag2 in {"NN", "NNS"}:
            bigrams.append(f"{word1}_{word2}")

        # NOUN + NOUN
        if tag1 in {"NN", "NNS"} and tag2 in {"NN", "NNS"}:
            bigrams.append(f"{word1}_{word2}")

        # Proper Noun + NOUN
        if tag1 in {"NNP", "NNPS"} and tag2 in {"NN", "NNS"}:
            bigrams.append(f"{word1}_{word2}")

    # Unigrammes simples : NOUN et PROPN
    simple_tokens = [word for word, tag in pos_tags if tag in {"NN", "NNS", "NNP", "NNPS"}]

    print(f"Extracted unigrams: {simple_tokens}", file=sys.stderr)
    print(f"Extracted bigrams: {bigrams}", file=sys.stderr)
    return simple_tokens + bigrams

# Chargement unique au module
STOP_WORDS_EN = set(stopwords.words("english"))

with open("./v1/stopwords/eng.json", "r", encoding="utf-8") as f_words:
    CUSTOM_STOPWORDS_EN = set(json.load(f_words))

ALL_STOPWORDS_EN = STOP_WORDS_EN | CUSTOM_STOPWORDS_EN


def clean_tokens(tokens):
    cleaned = []
    for tok in tokens:
        tok = tok.lower()
        parts = tok.split("_")
        if all(p not in ALL_STOPWORDS_EN for p in parts):
            cleaned.append(tok)
    return cleaned

id = f"{int(time.time())}_{os.getpid()}"
temporary_corpus = f"/tmp/corpus_{id}.txt"
temporary_model = f"/tmp/fasttext_model_{id}.bin"

def clean_file():
    if os.path.exists(temporary_corpus):
        os.remove(temporary_corpus)
    if os.path.exists(temporary_model):
        os.remove(temporary_model)
atexit.register(clean_file)

with open(temporary_corpus, "a", encoding="utf-8") as out:
    for line in sys.stdin:
        data = json.loads(line)
        if "query" in data :
            query = data["query"]
            print(f"Processing query: {query}", file=sys.stderr)
            keywords = get_keywords(query)
            cleaned_kw = cleaned_keywords(keywords)

        elif "value" in data :
            text = data["value"]
            text_pos = extract_ngramsPOS_nltk(text)
            text_pos_cleaned = clean_tokens(text_pos)
            # print(text_pos_cleaned, file=sys.stderr)
            out.write(" ".join(text_pos_cleaned) + "\n")

# Entraînement du modèle FastText sur le corpus temporaire
model = fasttext.train_unsupervised(
    input=temporary_corpus,
    model="skipgram",   # skipgram
    dim=300,            # taille des vecteurs
    ws=5,               # taille de la fenêtre
    minCount=5,  # Fréquence minimale d’un mot pour être inclus dans le vocabulaire du modèle
    epoch=10            # nombre d'époques
)
model.save_model(temporary_model)

# Pondération TF_IDF avec scikit-learn
docs = []
with open(temporary_corpus, "r", encoding="utf-8") as f:
    for line in f:
        line = line.strip()
        if line:
            docs.append(line)

# TF-IDF sur ton corpus temporaire
vectorizer = TfidfVectorizer(
    stop_words=None,
    max_df=1.0,
    min_df=1
)

X = vectorizer.fit_transform(docs)
feature_names = vectorizer.get_feature_names_out()
X_dense = X.toarray()

# Calcul des scores TF-IDF max par terme
term_tfidf = {}
for idx, term in enumerate(feature_names):
    tfidf_score_term = X_dense[:, idx]
    max_tfidf_score = np.max(tfidf_score_term)
    term_tfidf[term] = max_tfidf_score

# Paramètres de pondération
seuil_ponderation = 0.05
alpha = 0.8
beta = 0.2

result = {}

for kw in cleaned_kw:
    if kw in model.get_words():
        print(f"Keyword found in model: {kw}", file=sys.stderr)
        neighbors = model.get_nearest_neighbors(kw, k=1000)
        filtered_neighbors = []

        for sim, word in neighbors:
            if word == "</s>":
                continue

            tfidf_score = term_tfidf.get(word, 0.0)
            ponderation = alpha * sim + beta * tfidf_score

            if ponderation >= seuil_ponderation:
                filtered_neighbors.append((ponderation, sim, tfidf_score, word))

        filtered_neighbors.sort(reverse=True)

        result[kw] = []
        for ponderation, sim, tfidf_score, word in filtered_neighbors[:1000]:
            if ponderation >= 0.5:
                result[kw].append({
                    "word": word,
                    "sim": sim,
                    "tfidf": tfidf_score,
                    "ponderation": ponderation
                })
    else :
        print(f"Keyword NOT found in model: {kw}", file=sys.stderr)
        result[kw] = [{"word": f"Mot-clé '{kw}' absent du modèle, occurence < 5 dans le corpus."}]
        pass

sys.stdout.write(json.dumps(result))
sys.stdout.write("\n")
print(f"Temp files: {temporary_corpus}, {temporary_model}", file=sys.stderr)