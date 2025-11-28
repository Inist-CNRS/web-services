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
    if isinstance(doi, str):
        if "id" in data:
            output = {"id": data["id"], "value":{"is_retracted": False}}
        else:
            output = {"value":{"is_retracted": False}}

        if doi in retracted_doi:
            output["value"]["is_retracted"] = True

        json.dump(output, sys.stdout)
        sys.stdout.write("\n")
        
    if isinstance(doi, list):
        if "id" in data:
            output = {"id": data["id"], "value":{"is_retracted": []}}
        else:
            output = {"value":{"is_retracted": []}}

        for elt in doi:
            if elt in retracted_doi:
                output["value"]["is_retracted"].append(True)
            else:
                output["value"]["is_retracted"].append(False)

        json.dump(output, sys.stdout)
        sys.stdout.write("\n")
