#!/usr/bin/env python
# -*- coding: utf-8 -*-

import fasttext

class Prediction(object):
    def __init__(self, modele):
        self.modele = modele

    def do_one_prediction(self, data):

        self.result_prediction = []
        self.result_prediction.append(self.modele.predict(data))

    def get_predictions(self):

        one_predic = {}
        one_predic["code"] = self.get_code()
        one_predic["confidence"] = self.result_prediction[0][1][0]

        return one_predic

    def get_code(self):

        label = "__label__"
        return self.result_prediction[0][0][0][len(label) :]
