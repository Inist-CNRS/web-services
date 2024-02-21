#!/usr/bin/env python3

import sys
import json
from rapido import preprocessing as preprocessing
from rapido import alignment as alignment
from rapido import export as export
import pandas as pd
import spacy
from datetime import datetime

path = "v1/rapido/"
tei_path = path + "new-persee-tei.xsl"
annotations_path = path + "annotations.csv"
ignore_path = path + "ignore.txt"

from spacy_lefff import LefffLemmatizer, POSTagger
from spacy.language import Language

@Language.factory('french_lemmatizer')
def create_french_lemmatizer(nlp, name):
    return LefffLemmatizer(after_melt=True, default=True)

@Language.factory('melt_tagger')  
def create_melt_tagger(nlp, name):
    return POSTagger()

def prePro(file,tei_path):
    extractor = preprocessing.extractTei(file,tei_path)
    extractor.extract_file()
    df = extractor.df
    remover = preprocessing.removeGreek(0.3)

    listTextWithoutGreek = []
    for listText in df["listText"].tolist():
        listTextWithoutGreek.append(remover.rmvGreek(listText))
    df["listTextWithoutGreek"] = listTextWithoutGreek
    df['listTextWithoutGreekSplit'] = df['listTextWithoutGreek'].apply(preprocessing.dataToTxt)
    df['listTitleSplit'] = df['Title'].apply(preprocessing.dataToTxt)
    return df

def pro(dfAnnotations,idText,listPageId,listText,listTitle):
    dic = {}
    aligner = alignment.alignWithText(dfAnnotations)
    for j,text in enumerate(listText):
        dic = aligner.isAnnotationInText(text,listPageId[j],dic,idText)
    titleDic = {}
    titleDic = aligner.isAnnotationInText(listTitle[0],"Title",titleDic,idText)
    dic.update(titleDic)
    postAligner = alignment.postProcessing(dfAnnotations,dic)
    postAligner.removeIgnore()
    postAligner.removeDuplicate()
    postAligner.desambiguisation()
    postAligner.confident()
    return postAligner.dic,postAligner.rmv

def rapido(dfAnnotations,dfText,ignoreWords,nlp):
    exporter = export.exportJson(ignoreWords,nlp)
    for index,row in dfText.iterrows():
        idText = row["ID"]
        listPageId = row["listPageId"]
        listText = row["listTextWithoutGreekSplit"]
        listTitle = row["listTitleSplit"]
        dic,rmv = pro(dfAnnotations,idText,listPageId,listText,listTitle)
        newListText = []
        for text in listText:
            text = " " + " ".join(text) + " "
            text = text.lower()
            newListText.append(text)
        exporter.toJson(dic,rmv,newListText,listPageId, idText, listTitle)
    return exporter.listPersee

#Pre-loading
dfAnnotations = pd.read_csv(annotations_path)
with open(ignore_path) as f:
    ignoreWords = [k[:-1].lower() for k in f.readlines()]
nlp = spacy.load('fr_core_news_sm')
nlp.add_pipe('melt_tagger', after='parser')
nlp.add_pipe('french_lemmatizer', after='melt_tagger')

for line in sys.stdin:
    data = json.loads(line)
    id = data["id"]
    print(id,":Data received ",datetime.now(),file=sys.stderr)
    df = prePro(data["value"],tei_path)
    jsonResult = rapido(dfAnnotations,df,ignoreWords,nlp)
    print(id,":Data processed ",datetime.now(),file=sys.stderr)
    sys.stdout.write(json.dumps(jsonResult))
    sys.stdout.write('\n')
    print(id,":Result sent ",datetime.now(),file=sys.stderr)
