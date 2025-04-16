#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
from refextract import extract_references_from_file
import bibref.bibref_functions as bf
import json
import sys


for line in sys.stdin:
    line0 = json.loads(line)
    pdf_filename = line0["filename"]
    
    try:
        references_structured = extract_references_from_file(pdf_filename)
    except:
        references_structured = []
        
    try:
        os.remove(pdf_filename)
    except:
        pass

    references = []
    for reference in references_structured:
        if "author" in reference:
            try:
                references.append(reference['raw_ref'][0])
            except:
                continue
    
    idx = 0
    if len(references)==0:
        sys.stdout.write(json.dumps({"id":idx, "value":{"doi":"","status": "error_data"}}))
        sys.stdout.write('\n')
    else:
        for reference in references:
            idx += 1
            res = bf.biblio_ref(reference)
            res['reference'] = reference
            sys.stdout.write(json.dumps({"id":idx, "value":res}))
            sys.stdout.write('\n')
