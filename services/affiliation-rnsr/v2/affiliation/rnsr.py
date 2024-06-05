#!/usr/bin/env python3
import fasttext
import json
import re
import sys
import pickle
import unicodedata
import math


# del fasttext's logs
fasttext.FastText.eprint = lambda x: None


# Charging models :
with open("./v3/affiliation/models/dict-code-unite.pkl","rb") as dico_unite_pkl:
    dico_unite=pickle.load(dico_unite_pkl)

with open("./v3/affiliation/models/dict-proba.pkl","rb") as dico_proba_pkl:
    dico_proba=pickle.load(dico_proba_pkl)

modelDomain = fasttext.load_model("./v3/affiliation/models/model-domains_rnsr.ftz")
modelsDX = []
for i in range(11):
    modelsDX.append(fasttext.load_model("./v3/affiliation/models/model-%s_rnsr.ftz"%(i+1)))


# Normalize 

# Normalisation du texte :
def remove_accents(text):
    text = unicodedata.normalize("NFD", text)
    text = re.sub("[\u0300-\u036f]", "", text)
    return text

def normalizeText(text):
    text = text.lower()
    text = remove_accents(text)
    text = re.sub(r"[^a-zA-Z0-9]", " ",text)
    text = text.replace("universite","univ")
    text = text.replace("university","univ")
    text = text.replace("centre","ctr")
    text = text.replace("center","ctr")
    sentence = []
    for word in text.split():
        if word not in ['france',"franc","fr"]:
            sentence.append(word)
    text = " ".join(sentence)
    return text

# Find a code U. in an affiliation and return the associated RNSR
def findCodeU(text):    
    '''
    Cherche s'il y a un code unité dans l'affiliayion associé à un RNSR.
    '''
    text = text.replace('cnrs ','')
    c=re.findall(r'u[amsrp]{2,3} ?[emsat]? ?[0-9]{1,5}',text)
    codes=list(set(c))

    for code in codes:
        code=code.replace(' ','')
        if code == 'umr1163':
            if 'inserm' in text:
                return ('200724137K',True)
        try:
            rnsr = dico_unite[code]
            return (rnsr,True)
        except KeyError:
            continue

    return ("n/a",False)

# Penalize proba of small classes
def penalizeProba(rnsr,proba):
    try:
        return (1-math.exp(-0.4*dico_proba[rnsr]) )*proba
    except KeyError:
        return 0

# WS
for line in sys.stdin:
    data = json.loads(line)
    affiliation = normalizeText(data["value"])

    # Find code U.
    rnsr, rnsrFinded = findCodeU(affiliation)
    if rnsrFinded :
        data["value"]=rnsr
        sys.stdout.write(json.dumps(data))
        sys.stdout.write("\n")
    
    # Else, use neuronal network
    else:
        #predict domain
        predictionDomain = modelDomain.predict(affiliation)
        domain = predictionDomain[0][0]
        domain = re.sub("__label__","",domain)
        predictionRnsr = "n/a"

        #predict rnsr knowing domain
        for i in range(11):
            testModelDx = "D" + str(i+1).rjust(2,"0")
            if domain == testModelDx :
                predictionRnsr = modelsDX[i].predict(affiliation)
        rnsr, proba = predictionRnsr[0][0].replace("__label__",""),predictionRnsr[1][0]
        proba = penalizeProba(rnsr,proba)

        #threshold = 0.71
        if proba < 0.71 :
            data["value"]="n/a"
        else:
            data["value"]=rnsr

        sys.stdout.write(json.dumps(data))
        sys.stdout.write("\n")