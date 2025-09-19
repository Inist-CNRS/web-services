#!/usr/bin/env python3

import json
import sys
import pickle


# get a list of retracted DOIs
with open("v1/annulled.pickle", "rb") as file:
    retracted_doi = pickle.load(file)


# WS
for line in sys.stdin:
    data = json.loads(line)
    doi = data["value"]
    if "id" in data:
        output = {"id": data["id"], "value":{"is_retracted": False}}
    else:
        output = {"value":{"is_retracted": False}}

    try:
        if doi in retracted_doi:
            output["value"]["is_retracted"] = True
    except Exception:
        pass
    json.dump(output, sys.stdout)
    sys.stdout.write("\n")
