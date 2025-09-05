#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
import os
import logging
from flair.data import Sentence
from flair.models import SequenceTagger
from requests_ratelimiter import LimiterSession

logging.getLogger("flair").handlers[0].stream = sys.stderr
session = LimiterSession(per_minute=60)

API_KEY = os.getenv("LIBRARIES_IO_API_KEY")


def use_libraried_io(software):
    """
    use the libraried.io api to check software licence.
    Args:
        software (str): The software name to check.

    Returns:
        dict: information to return for the software
    """

    url = f"https://libraries.io/api/search?q={software}&api_key={API_KEY}"

    res = {
        "name": software,
        "status": "found",
        "code_url": "",
        "license": ""
    }

    try:
        response = session.get(url)
        status_code = response.status_code
    except Exception as e:
        sys.stderr.write("Error when using libraries.io api : "+str(e) + "\n")
        res["status"] = "not_found"
        return res

    if status_code != 200:
        if status_code != 404:
            sys.stderr.write(
                "Not a 200 or 404 status code : code "+str(status_code) + "\n"
                )

        res["status"] = "not_found"
        return res

    try:
        message = response.json()[0]
        res["license"] = "" if message["licenses"] is None else message["licenses"]
        res["code_url"] = "" if message["code_of_conduct_url"] is None else message["code_of_conduct_url"]
        
        if res["license"] == "":
            res["license"] = "" if message["normalized_licenses"][0] is None else message["normalized_licenses"][0]
        return res

    except Exception as e:
        sys.stderr.write(
            "Error while processing libraries.io response : " + str(e) + "\n"
            )
        res["status"] = "not_found"

        return res


model_path = 'v1/model-software.pt'
tagger = SequenceTagger.load(model_path)

for line in sys.stdin:
    line = json.loads(line)
    try:
        data = line["value"]

    except Exception:
        data = ""

    sentence = Sentence(data)
    tagger.predict(sentence)

    result = {"SOFT": []}

    for entity in sentence.get_spans('ner'):
        result["SOFT"].append(use_libraried_io(entity.text))

    line["value"] = result

    sys.stdout.write(json.dumps(line))
    sys.stdout.write("\n")
