#!/usr/bin/env python3

import json
import sys
import pickle

with open("v1/all-pps-classes.pickle", "rb") as file:
    all_classes = pickle.load(file)


def get_classes_for_doi(doi):
    return all_classes.get(doi, [])


for line in sys.stdin:
    data = json.loads(line)
    doi = data["value"]

    if isinstance(doi, str):
        classes = get_classes_for_doi(doi)
        if "id" in data:
            output = {"id": data["id"], "value": {"tags": classes}}
        else:
            output = {"value": {"tags": classes}}

    elif isinstance(doi, list):
        classes_list = [get_classes_for_doi(elt) for elt in doi]
        if "id" in data:
            output = {"id": data["id"], "value": {"tags": classes_list}}
        else:
            output = {"value": {"tags": classes_list}}

    else:
        if "id" in data:
            output = {"id": data["id"], "value": {"tags": []}}
        else:
            output = {"value": {"tags": []}}

    json.dump(output, sys.stdout)
    sys.stdout.write("\n")
