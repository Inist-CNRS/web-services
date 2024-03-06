#!/usr/bin/env python3

import re
import sys
import json

def find_dois(text):
    """
    return all dois found in a text (input)
    """
    pattern = r'10\.\d{4,9}[-._;()/:A-Z0-9]+'

    regex = re.compile(pattern, re.IGNORECASE)

    try:
        doi = re.findall(regex, text)
    except:
        doi = []

    return doi


for line in sys.stdin:
    data = json.loads(line)
    text = data["value"]
    
    data["value"] = find_dois(text)
    
    json.dump(data, sys.stdout)
    sys.stdout.write("\n")
