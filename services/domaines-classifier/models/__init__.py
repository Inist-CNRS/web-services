from pathlib import Path
import fnmatch
import os
import fasttext
import logging

model_path = os.path.dirname(".")
#format des modeles Fasttewt : bin ou ftz , a modifier au besoin
model_type=".ftz"

logging.basicConfig( level=logging.DEBUG)

# parametres du modele
model_init = {
    "rang": 0,
    "code_pere": "0",
}

# chargement de l ensembles de modele fasttext disponible dans le FS model_path
# OUTPUT = dictionnaire des modeles  format  { "code du modele" = "addresse mdoele" }
def load_all_models():

    indexes = []
    model_path="."

    for root, dirnames, filenames in os.walk(model_path):
        match = {}
        for filename in fnmatch.filter(filenames, "*" + model_type):
            match["code"] = ""
            match["path"] = os.path.join(root.replace('.DAV',''), filename)
            indexes.append(match)

    for i, dic in enumerate(indexes):
        p = dic["path"].split("/")
        dic["code"] = p[-2]

    dic_models={}
    for i,  dic in enumerate(indexes):
        dic_models[dic['code']] = fasttext.load_model(dic['path'])
        # trace
        message=dic['path']
        logging.info('load %s',message)

    return(dic_models)

list_loaded_models = load_all_models()

