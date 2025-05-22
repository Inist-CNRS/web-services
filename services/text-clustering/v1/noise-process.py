#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import json

output = []

for line in sys.stdin:
    line = json.loads(line)
    try:
        if line["value"] == "noise":
            output.append({"noise": line["id"]})
    except Exception:
        continue

# Did not success to do it in EZS
# If no document are tag as noise, the stream is "break"
# Can dodge it in python with the next line
if len(output) == 0:
    sys.stdout.write(json.dumps({"noise": ""}))
else:
    for elt in output:
        sys.stdout.write(json.dumps(elt))
        sys.stdout.write("\n")
