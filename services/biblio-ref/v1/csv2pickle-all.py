#!/usr/bin/env python3

import csv
import pickle
import sys

input_file = sys.argv[1]
output_file = "/app/public/v1/all-pps-classes.pickle"

classes_dict = {}

with open(input_file, 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        if len(row) >= 2:
            classes_str = row[0].strip().strip('"')
            classes = [c.strip().lower() for c in classes_str.split(',')]
            doi = row[1].strip().strip('"').lower()
            for classe in classes:
                if classe not in classes_dict:
                    classes_dict[classe] = set()
                classes_dict[classe].add(doi)

with open(output_file, 'wb') as file:
    pickle.dump(classes_dict, file)
