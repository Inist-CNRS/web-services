#!/usr/bin/env python
# -*- coding: utf-8 -*-

from one_prediction import Prediction
import json
import fasttext
from models import list_loaded_models

result_prediction = []
listvide = []

# function recursive de parcours des modeles pour les predictions sur un document
def do_predictions(*param, **model_init):

    # modele racine
    if model_init["rang"] == 0:

        predictor = Prediction(list_loaded_models.get("test_0"))
        result_prediction.clear()

    else:
        predictor = Prediction(list_loaded_models.get(model_init["code_pere"]))

    # execution de la prediction par FastText
    # trace print(param[0][0:50])
    predictor.do_one_prediction(param[0])
    pre = predictor.get_predictions()
    pre["rang"]= (model_init["rang"]+1)
    result_prediction.append(pre)

    # recuperation des resultats
    model_init["code_pere"] = predictor.get_code()
    model_init["rang"] += 1

    if model_init["rang"] == param[1]:
        # on sort et on retourne le resultat
        return(result_prediction)

    else:
        # niveau n + 1
        return do_predictions(param[0], param[1], **model_init)
