#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
from gensim import corpora, models
import unicodedata
import re
import spacy
import numpy as np
from itertools import islice

# Test for stats with prometheus :
from prometheus_client import CollectorRegistry, Counter, push_to_gateway

registry = CollectorRegistry()
c = Counter('documents', 'Number of documents processed', registry=registry)
job_name = 'lda'


# Get the index of "p" param (given by the user) and assign it to "nbTopic". 
# Automatic detemination if not.
try:
    nbTopic = int(sys.argv[sys.argv.index('-p') + 1] if '-p' in sys.argv else 0)
    if nbTopic <= 1:
        nbTopic = 0
    if nbTopic > 18:
        nbTopic = 18
except Exception:
    nb_Topic = 0


nlp = spacy.load(
    "en_core_web_sm",
    disable=["parser", "ner", "textcat"]
)

# stopwords
with open('./v1/stopwords/en.json', 'r') as f_in:
    stopwords = set(json.load(f_in))
for w in stopwords:
    nlp.vocab[w].is_stop = True


# normalize text
def normalize(text):
    if not isinstance(text, str):
        return ""

    text = unicodedata.normalize("NFD", text)
    text = re.sub(r"[\u0300-\u036f]", "", text)
    return text.lower()


def preprocess_spacy(texts, batch_size=2, n_process=-1):
    processed_texts = []
    empty_idx = []

    for i, doc in enumerate(
        nlp.pipe(texts, batch_size=batch_size, n_process=n_process)
    ):
        tokens = [
            tok.lemma_
            for tok in islice(doc, 1000)
            if tok.is_alpha
            and not tok.is_stop
            and len(tok) > 3
        ]

        if tokens:
            processed_texts.append(tokens)
        else:
            empty_idx.append(i)

    return processed_texts, empty_idx


# Max topic
def max_topic(dico):
    """
    for a dictionary of topics, return a json with a single key "best_topic"
    and its value is the value of this topic in the dictionary.
    """
    best_topic = {}
    best_proba = 0
    for topic in dico:
        proba = float(dico[topic]["topic_weight"])
        if proba > best_proba:
            best_proba = proba
            best_topic = topic
    return {best_topic: dico[best_topic]}


def find_optimal_k_lda(
    corpus,
    dictionary,
    processed_docs,
    min_k=2,
    max_k=18,
    step=4,
    passes=10,
    iterations=100,
    runs_per_k=1
):
    scores = {}

    def evaluate_k(k):
        if k in scores:
            return scores[k]

        run_scores = []
        # Here we can simply improve perf by using sampling
        # (by increasing runs_per_k, but it increase computing time)
        for r in range(runs_per_k):
            lda = models.LdaMulticore(
                corpus=corpus,
                id2word=dictionary,
                num_topics=k,
                passes=passes,
                iterations=iterations,
                random_state=42
            )
            coherence = models.CoherenceModel(
                model=lda,
                texts=processed_docs,
                dictionary=dictionary,
                coherence="c_v"
            ).get_coherence()

            run_scores.append(coherence)

        scores[k] = float(np.mean(run_scores))
        return scores[k]

    coarse_ks = list(range(min_k, max_k + 1, step))

    for k in coarse_ks:
        evaluate_k(k)
    best_coarse_k = max(coarse_ks, key=lambda k: scores[k])

    refine_min = max(min_k, best_coarse_k - step//2)
    refine_max = min(max_k, best_coarse_k + step//2)
    for k in range(refine_min, refine_max + 1):
        evaluate_k(k)

    best_k = max(scores, key=scores.get)

    return best_k


# WS
# load all datas
all_data = []
for line in sys.stdin:
    data = json.loads(line)
    all_data.append(data)
    # Increment data for prometheus
    c.inc()

# Send metrics to prometheus
try:
    push_to_gateway('https://jobs-metrics.daf.intra.inist.fr', job=job_name, registry=registry)
except Exception as e:
    sys.stderr.write(str(e) + "\n")

len_data = len(all_data)

# preprocessing of data
raw_texts = []
raw_indices = []
index_without_value = []
for i, line in enumerate(all_data):
    if "value" in line and isinstance(line["value"], str):
        txt = normalize(line["value"])
        if txt:
            raw_texts.append(txt)
            raw_indices.append(i)
        else:
            index_without_value.append(i)
    else:
        index_without_value.append(i)

texts, empty = preprocess_spacy(raw_texts)

index_without_value.extend(raw_indices[i] for i in empty)

no_below = 5 if len(texts) > 1000 else 2
bigram_model = models.Phrases(texts, min_count=no_below, threshold=1)
bigram_texts = [bigram_model[doc] for doc in texts]
dictionary = corpora.Dictionary(bigram_texts)
dictionary.filter_extremes(no_below=no_below, no_above=0.5)
corpus = [dictionary.doc2bow(text) for text in bigram_texts] 
minimum_probability = 0

# Find optimal number of topic
if nbTopic == 0:
    try:
        nbTopic = find_optimal_k_lda(corpus, dictionary, bigram_texts)


    except Exception as e:
        sys.stderr.write("\nError in find_optimal_k funct : " + str(e) + "\n")
        index_without_value = [i for i in range(len_data)]
        nbTopic = 0

if nbTopic < 6:
    minimum_probability = 0.2
elif nbTopic < 11:
    minimum_probability = 0.15
else:
    minimum_probability = 0.1


# Train the LDA model
if nbTopic > 0:
    try:
        lda_model = models.LdaMulticore(
                                corpus=corpus,
                                id2word=dictionary,
                                num_topics=nbTopic,
                                minimum_probability=minimum_probability,
                                passes=20,
                                iterations=200,
                                random_state=42
            )
    except Exception as e:
        sys.stderr.write("\nError while training lda: " + str(e) + "\n"+ str(minimum_probability))
        index_without_value = [i for i in range(len_data)]


i_decal = 0
# extract infos
for i in range(len_data):
    c.inc()
    
    line = all_data[i]
    
    # return n/a if docs wasn't in model
    if i in index_without_value:
        line["value"] = "n/a"
        i_decal += 1
        sys.stdout.write(json.dumps(line))
        sys.stdout.write("\n")
    else:
        topics = lda_model.get_document_topics(
            corpus[i-i_decal],
            minimum_probability=minimum_probability
            )
        topic_info = {}
        for topic_id, topic_weight in topics:
            topic_info[f"topic_{topic_id + 1}"] = {}
            words = []
            words_weights = []
            for word, word_weight in lda_model.show_topic(topic_id):
                words.append(word.replace("_", " ")) 
                words_weights.append(str(word_weight))
            topic_info[f"topic_{topic_id + 1}"]["words"] = words
            topic_info[f"topic_{topic_id + 1}"]["words_weights"] = words_weights
            topic_info[f"topic_{topic_id + 1}"]["topic_weight"] = str(topic_weight)

        line["value"] = {}
        line["value"]["topics"] = topic_info
        try:
            line["value"]["best_topic"] = max_topic(topic_info)
        except Exception as e:
            sys.stderr.write("\n Error with max_topic function : " + str(e) + "\n")
            line["value"]["best_topic"] = "n/a"
        sys.stdout.write(json.dumps(line))
        sys.stdout.write("\n")

try:
    push_to_gateway('https://jobs-metrics.daf.intra.inist.fr', job=job_name, registry=registry)
except Exception as e:
    sys.stderr.write(str(e) + "\n")
