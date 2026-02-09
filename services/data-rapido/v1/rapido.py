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
import time

from spacy_lefff import LefffLemmatizer, POSTagger
from spacy.language import Language


@Language.factory('french_lemmatizer')
def create_french_lemmatizer(nlp, name):
    return LefffLemmatizer(after_melt=True, default=True)

@Language.factory('melt_tagger')  
def create_melt_tagger(nlp, name):
    return POSTagger()

def prePro(files,tei_path):
    '''
    Take the tei input datas, clean them, and transform them into an usable dataframe for the next steps.

    All following results are stored on a dataframe to a faster computation later.
    The clean step get usefull data on tei with the xsl stylesheet. 
    We divide each tei by page. We get sentence from each page, and split them into token. Sentence with too much greec are also removed as we focus only on french sentence.

    Parameters
        ----------
            files : list of str
                list of tei file
            tei_path : str
                path of the xsl stylesheet
    '''
    
    extractor = preprocessing.extractTei(files,tei_path)
    extractor.extract_files()
    df = extractor.df
    remover = preprocessing.removeGreek(0.3)

    listTextWithoutGreek = []
    for listText in df["listText"].tolist():
        listTextWithoutGreek.append(remover.rmvGreek(listText))
    df["listTextWithoutGreek"] = listTextWithoutGreek
    df['listTextWithoutGreekSplit'] = df['listTextWithoutGreek'].apply(preprocessing.dataToTxt)
    df['listTitleSplit'] = df['Title'].apply(preprocessing.dataToTxt)
    return df

def pro(dfAnnotations,idText,listPageId,listText,listTitle,lAnnot, dicAnnot, app = False, tagger=False):
    '''
    Take one document, as one line of the input datas dataframe, and apply the phase 1 or phase 2 rapido detection and alignment algorithme , 
    depending on wether the "app" parameter is True or False.
    Then it clean and desambiguate the alignments, and proceed to add a fiability score to each one of them.
    Results datas are stored on a dictionnary.

    Parameters
    ----------
        dfAnnotations : dataframe
            dataframe containing all informations about the notices to align with
        idText : str
            id of the document
        listPageId : list of str
            list of pages id's
        listText : list of str
            list of tokenized text 
        listTitle : list of str
            list containing the title of the document
        lAnnot : list
            list of the notices made up to speed up computation
        dicAnnot : dic
            dic of the notices made up to speed up score computation
        app : bool
            whether or not it's phase 2 (Machine Learning phase) (Default is False)
        tagger : False or flair tagger
            flair tagger (Default is False)
    '''

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
    postAligner.score(dicAnnot)
    if app:
        return postAligner.dic,postAligner.rmv, loc_remain_app
    else:
        return postAligner.dic,postAligner.rmv

def rapido(dfAnnotations,dfText,ignoreWords,nlp,lAnnot, dicAnnot, app=False):
    '''
    Take input documents and apply pro on each one, with extra parameters if app parameter is True, ie it's a phase 2 run.
    Then it sent the resulting dictionnary to the exporter. Return the final Persee json with the rapido result from the exporter.

     Parameters
    ----------
        dfAnnotations : dataframe
            dataframe containing all informations about the notices to align with
        dfText: dataframe
            dataframe contaning all informations to process
        ignoreWords : list of str
            list of word to ignore when encountered during alignment
        nlp : spacy model
            spacy model used in certain cases for pos tagging
        lAnnot : list
            list of the notices made up to speed up computation
        dicAnnot : dic
            dic of the notices made up to speed up score computation
        app : bool
            whether or not it's phase 2 (Machine Learning phase) (Default is False)
        tagger : false or flair tagger
            flair tagger (Default is False)
    '''

    if app:
        logging.getLogger("flair").handlers[0].stream = sys.stderr
        tagger = SequenceTagger.load('./v1/rapido-model.pt')
    exporter = export.exportJson(ignoreWords,nlp)
    for _,row in dfText.iterrows():
        idText = row["ID"]
        listPageId = row["listPageId"]
        listText = row["listTextWithoutGreekSplit"]
        listTitle = row["listTitleSplit"]
        if app:
            dic,rmv,loc_remain_app = pro(dfAnnotations,idText,listPageId,listText,listTitle,lAnnot,dicAnnot, app=True,tagger=tagger)
        else:
            dic,rmv = pro(dfAnnotations,idText,listPageId,listText,listTitle,lAnnot, dicAnnot)
        newListText = []
        for text in listText:
            text = " " + " ".join(text) + " "
            text = text.lower()
            newListText.append(text)
        if app:
            exporter.toJson(dic,rmv,newListText,listPageId, idText, listTitle,loc_remain_app=loc_remain_app, app = True)
        else:
            exporter.toJson(dic,rmv,newListText,listPageId, idText, listTitle)
    return exporter.listPersee

# Args
app = False
perimeter = "grece"
if '-p' in sys.argv:
    arg = int(sys.argv[sys.argv.index('-p') + 1])
    if arg != 0:
        app = True
if '-q' in sys.argv:
    perimeter = sys.argv[sys.argv.index('-q') + 1]
    if perimeter != "grece" and perimeter != "italie":
        perimeter = "grece"

print(time.strftime("%A %d %B %Y %H:%M:%S"), file=sys.stderr)
print("app:", app, "  perimeter:",perimeter, file=sys.stderr)

path = "v1/rapido/"
tei_path = path + "new-persee-tei.xsl"
annotations_path = path + "annotations_"+perimeter+".csv"
annotations_pickle_path = path + "annotations_"+perimeter+".pkl"
ignore_path = path + "ignore.txt"


# Pre-loading
dfAnnotations = pd.read_csv(annotations_path)
dfAnnotations["Annotation"] = dfAnnotations["Annotation"].apply(ast.literal_eval)
dfAnnotations["trueAnnotation"] = dfAnnotations["trueAnnotation"].apply(ast.literal_eval)

with open(annotations_pickle_path, "rb") as f:
    lAnnot = pickle.load(f)
    dicAnnot = pickle.load(f)
with open(ignore_path) as f:
    ignoreWords = [k[:-1].lower() for k in f.readlines()]
nlp = spacy.load('fr_core_news_sm')
nlp.add_pipe('melt_tagger', after='parser')
nlp.add_pipe('french_lemmatizer', after='melt_tagger')


datas = []
for line in sys.stdin:
    data = json.loads(line)
    datas.append(data["value"])

print(id,":Data received ",datetime.now(),file=sys.stderr)
df = prePro(datas,tei_path)
jsonResult = rapido(dfAnnotations,df,ignoreWords,nlp,lAnnot, dicAnnot, app=app)
print(id,":Data processed ",datetime.now(),file=sys.stderr)
sys.stdout.write(json.dumps(jsonResult))
sys.stdout.write('\n')
print(id,":Result sent ",datetime.now(),file=sys.stderr)
