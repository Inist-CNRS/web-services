#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import json
import sys

# A tools dict key : tool value : tool homogenised
with open("v1/tools-dict.json", "r") as f:
    tools_dict = json.load(f)

# Compile all regex in one for earning time
sorted_terms = sorted(tools_dict.keys(), key=lambda x: -len(x))
escaped_terms = [re.escape(term) for term in sorted_terms]
pattern = re.compile(r'\b(' + '|'.join(escaped_terms) + r')\b', flags=re.IGNORECASE)


for line in sys.stdin:
    data = json.loads(line)
    try:
        text = data["value"]
    except Exception:
        text = ""

    try:
        matches = pattern.findall(text)
    except Exception:
        matches = []

    results = {}
    results_tools_homogenised = []
    results_tools = []
    for match in matches:
        key = match.lower()
        results_tools.append(key)
        canonical = tools_dict.get(key)
        if canonical:
            results_tools_homogenised.append(canonical)
            
    results["tools"] = results_tools
    results["tools_homogenised"] = results_tools_homogenised

    data["value"] = results
    sys.stdout.write(json.dumps(data))
    sys.stdout.write("\n")
