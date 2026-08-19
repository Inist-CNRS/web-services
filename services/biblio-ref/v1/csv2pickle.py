#!/usr/bin/env python3

import csv
import pickle
import sys

input_file = sys.argv[1]
output_file = "/app/public/v1/all-pps-classes.pickle"
clayfeet_file = "/app/public/v1/clayfeet.pickle"
retracted_file = "/app/public/v1/annulled.pickle"

detectors_dict = {}
clayfeet_set = set()
retracted_set = set()

with open(input_file, 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        classes_str = row["Detectors"].strip().strip('"')
        classes = [c.strip().lower() for c in classes_str.split(',')]
        doi = row["Doi"].strip().strip('"').lower()
        if "annulled" in classes:
            retracted_set.add(doi)
        if "clayfeet" in classes:
            clayfeet_set.add(doi)
        for classe in classes:
            if doi not in detectors_dict:
                detectors_dict[doi] = []
            detectors_dict[doi].append(classe)

with open(output_file, 'wb') as file:
    pickle.dump(detectors_dict, file)

with open(clayfeet_file, 'wb') as file:
    pickle.dump(clayfeet_set, file)

with open(retracted_file, 'wb') as file:
    pickle.dump(retracted_set, file)
