#!/usr/bin/env python3

import sys
import json
from rapido import preprocessing as preprocessing
from rapido import alignment as alignment
from rapido import export as export
import pandas as pd
import spacy
from datetime import datetime
from flair.models import SequenceTagger
import pickle
import ast
import logging

path = "v1/rapido/"
tei_path = path + "new-persee-tei.xsl"
annotations_path = path + "annotations.csv"
annotations_pickle_path = path + "annotations.pkl"
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

def pro(dfAnnotations,idText,listPageId,listText,listTitle,lAnnot, app = False, tagger=False):
    dic = {}
    if app:
        aligner = alignment.alignWithText(dfAnnotations,tagger=tagger)
        loc_remain_app = {}
    else:
        aligner = alignment.alignWithText(dfAnnotations)
    for j,text in enumerate(listText):
        if app: 
            dic,loc_remain_app = aligner.isAnnotationInTextApp(text,listPageId[j],dic,idText,lAnnot, loc_remain_app)
        else:
            dic = aligner.isAnnotationInText(text,listPageId[j],dic,idText,lAnnot)
    titleDic = {}
    if app:
        titleDic,title_loc_remain = aligner.isAnnotationInTextApp(listTitle[0],"Title",titleDic,idText,lAnnot,loc_remain_app)
        loc_remain_app.update(title_loc_remain)
    else:
        titleDic = aligner.isAnnotationInText(listTitle[0],"Title",titleDic,idText,lAnnot)
    dic.update(titleDic)
    postAligner = alignment.postProcessing(dfAnnotations,dic)
    postAligner.removeIgnore()
    postAligner.removeDuplicate()
    postAligner.desambiguisation()
    postAligner.confident()
    if app:
        return postAligner.dic,postAligner.rmv, loc_remain_app
    else:
        return postAligner.dic,postAligner.rmv

def rapido(dfAnnotations,dfText,ignoreWords,nlp,lAnnot,app=False):
    if app:
        logging.getLogger("flair").handlers[0].stream = sys.stderr
        tagger = SequenceTagger.load('./v1/rapido-model.pt')
    exporter = export.exportJson(ignoreWords,nlp)
    for index,row in dfText.iterrows():
        idText = row["ID"]
        listPageId = row["listPageId"]
        listText = row["listTextWithoutGreekSplit"]
        listTitle = row["listTitleSplit"]
        if app:
            dic,rmv,loc_remain_app = pro(dfAnnotations,idText,listPageId,listText,listTitle,lAnnot,app=True,tagger=tagger)
        else:
            dic,rmv = pro(dfAnnotations,idText,listPageId,listText,listTitle,lAnnot)
        newListText = []
        for text in listText:
            text = " " + " ".join(text) + " "
            text = text.lower()
            newListText.append(text)
        if app:
            exporter.toJson(dic,rmv,newListText,listPageId, idText, listTitle,loc_remain_app=loc_remain_app)
        else:
            exporter.toJson(dic,rmv,newListText,listPageId, idText, listTitle)
    return exporter.listPersee

# Args
if '-p' in sys.argv:
    arg = int(sys.argv[sys.argv.index('-p') + 1])
    if arg == 0:
        app = False
    else:
        app = True
else:
    app = False

# Pre-loading
dfAnnotations = pd.read_csv(annotations_path)
dfAnnotations["Annotation"] = dfAnnotations["Annotation"].apply(ast.literal_eval)
dfAnnotations["trueAnnotation"] = dfAnnotations["trueAnnotation"].apply(ast.literal_eval)

with open(annotations_pickle_path, "rb") as f:
    lAnnot = pickle.load(f)
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
    jsonResult = rapido(dfAnnotations,df,ignoreWords,nlp,lAnnot,app=app)
    print(id,":Data processed ",datetime.now(),file=sys.stderr)
    sys.stdout.write(json.dumps(jsonResult))
    sys.stdout.write('\n')
    print(id,":Result sent ",datetime.now(),file=sys.stderr)
