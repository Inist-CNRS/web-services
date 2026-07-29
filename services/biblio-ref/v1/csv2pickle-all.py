#!/usr/bin/env python3

import csv
import pickle
import sys
import json

input_file = sys.argv[1]
output_file = "/app/public/v1/all-pps-classes.pickle"

detectors_dict = {}

with open(input_file, 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        classes_str = row["Detectors"].strip().strip('"')
        classes = [c.strip().lower() for c in classes_str.split(',')]
        doi = row["Doi"].strip().strip('"').lower()
        for classe in classes:
            if doi not in detectors_dict:
                detectors_dict[doi] = []
            detectors_dict[doi].append(classe)

with open(output_file, 'wb') as file:
    pickle.dump(detectors_dict, file)


with open("v1/testt.json", 'w') as file:
    json.dump(detectors_dict, file)
