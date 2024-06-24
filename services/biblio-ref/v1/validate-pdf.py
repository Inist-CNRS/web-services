#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import sys
import json
from refextract import extract_references_from_file
from bibref.bibref_functions import *


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
            references.append(reference['raw_ref'][0])
    
    all_res = []
    for reference in references:
        res = biblio_ref(reference)
        res['reference'] = reference
        all_res.append(res)
        
    output = {"id":pdf_filename, "value":all_res}
    sys.stdout.write(json.dumps(output))
    sys.stdout.write('\n')
