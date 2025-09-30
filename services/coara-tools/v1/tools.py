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
    uniq = []
    data = json.loads(line)
    try:
        text = data["value"]
    except Exception:
        text = ""

    try:
        matches = pattern.findall(text)
    except Exception:
        matches = []

    results = []
    for match in matches:
        tool_to_add = {"tool": "", "tool_homogenised": "", "other_tool_form": "", "definition": ""}
        key = match.lower()
        
        if key in uniq:
            continue
        uniq.append(key)
        
        tool_to_add["tool"] = key
        try:
            tool_to_add["tool_homogenised"] = tools_dict[key]["tool_homogenised"]
        except Exception:
            tool_to_add["tool_homogenised"] = ""
        try:
            tool_to_add["other_tool_form"] = tools_dict[key]["other_tool_form"]
        except Exception:
            tool_to_add["other_tool_form"] = ""
        try:
            tool_to_add["other_tool_form_flatten"] = tools_dict[key]["other_tool_form_flatten"]
        except Exception:
            tool_to_add["other_tool_form_flatten"] = ""
        try:
            tool_to_add["definition"] = tools_dict[key]["definition"]
        except Exception:
            tool_to_add["definition"] = ""
        results.append(tool_to_add)

    data["value"] = results
    sys.stdout.write(json.dumps(data))
    sys.stdout.write("\n")
