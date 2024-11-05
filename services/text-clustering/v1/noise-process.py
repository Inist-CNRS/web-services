#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import json

output = []

for line in sys.stdin:
    line=json.loads(line)
    try:
        if line["value"] == "noise":
            output.append(line["id"])
    except:
        continue

sys.stdout.write(json.dumps(output))
sys.stdout.write("\n")
