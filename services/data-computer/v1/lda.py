#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
from gensim import corpora, models
import unicodedata
import re
import spacy


nbTopic = sys.argv[sys.argv.index('-p') + 1] if '-p' in sys.argv else 15

nlp = spacy.load('en_core_web_sm', disable = ['parser','ner'])

#stopwords
with open('./v1/stopwords/en.json','r') as f_in:
    stopwords =json.load(f_in)

#normalize text
def remove_accents(text):
    if text == "" or type(text)!= str:
        return ""
    normalized_text = unicodedata.normalize("NFD", text)
    text_with_no_accent = re.sub("[\u0300-\u036f]", "", normalized_text)
    return text_with_no_accent

def uniformize(text):
    text = remove_accents(text)

    # remove punctuation except " ' "
    text = ''.join(char if char.isalpha() or char == "'" else ' ' for char in text)

    return ' '.join(text.lower().split())

#lemmatize
def lemmatize(text):
    if text == "":
        return text
    doc = nlp(text)
    return " ".join([token.lemma_ for token in doc])

#tokenize
def tokenize(text):
    tokens = [word for word in text.replace("'"," ").split() if word not in stopwords and len(word)>2]
    if len(tokens)==0:
        return []
    return tokens

# Max topic
def max_topic(dico):
    """
    for a dictionary of topics, return a json with a single key "best_topic" and its value is the value of this topic in the dictionary.
    """
    best_topic = {}
    best_proba = 0
    for topic in dico:
        proba = float(dico[topic]["topic_weight"])
        if proba>best_proba:
            best_proba = proba
            best_topic = topic
    return {best_topic:dico[best_topic]}



# WS
# load all datas
all_data = []
for line in sys.stdin:
    data=json.loads(line)
    all_data.append(data)


# following parameters depends of the size of the corpus : num_topics and num_iterations
len_data = len(all_data)
num_iterations= max(200,len_data/100)
if len_data < 200:
    num_iterations = 100

# training LDA
texts = []
index_without_value = []
for i in range(len_data):
    line = all_data[i]
    if "value" in line and type(line["value"])==str:
        tokens = tokenize(lemmatize(uniformize(line["value"])))
        if tokens != []:
            texts.append(tokenize(lemmatize(uniformize(line["value"]))))
        else:
            index_without_value.append(i)
    else:
        index_without_value.append(i)
dictionary = corpora.Dictionary(texts) # Create a tf dictionary, but replace text by an id : [ [(id_token,numb_token),...] , [....] ]. The list represent docs of corpus
dictionary.filter_extremes(no_below=3,no_above=0.5)
corpus = [dictionary.doc2bow(text) for text in texts]

try:
    lda_model = models.LdaModel(corpus, num_topics=nbTopic, id2word=dictionary,iterations=num_iterations,alpha="symmetric", eta = "auto",minimum_probability=0.2)
except:
    index_without_value = [i for i in range(len_data)]


# extract infos
for i in range(len_data):

    #return n/a if docs wasn't in model
    if i in index_without_value:
        line["value"]="n/a"
        sys.stdout.write(json.dumps(line))
        sys.stdout.write("\n")
    else:
        line = all_data[i]
        doc = line["value"]
        doc_bow = dictionary.doc2bow(tokenize(uniformize(line["value"])))
        topics = lda_model[doc_bow]
        topic_info = {}
        for topic_id, topic_weight in topics:
            topic_info[f"topic_{topic_id + 1}"] = {}
            words = []
            words_weights = []
            for word, word_weight in lda_model.show_topic(topic_id):
                words.append(word) 
                words_weights.append(str(word_weight))
            topic_info[f"topic_{topic_id + 1}"]["words"] = words
            topic_info[f"topic_{topic_id + 1}"]["words_weights"] = words_weights
            topic_info[f"topic_{topic_id + 1}"]["topic_weight"] = str(topic_weight)

        line["value"]={}
        line["value"]["topics"]=topic_info
        try:
            line["value"]["best_topic"]=max_topic(topic_info)
        except:
            line["value"]["best_topic"]="n/a"
        sys.stdout.write(json.dumps(line))
        sys.stdout.write("\n")


# #To see topics (to test it with a jsonl file)
# sys.stdout.write(json.dumps(lda_model.print_topics()))

# #Get coherence
# cm = models.coherencemodel.CoherenceModel(model=lda_model, texts=texts, coherence='c_v')
# cm.get_coherence()
# exit()
