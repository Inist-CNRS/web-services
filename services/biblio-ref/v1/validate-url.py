#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import random
import bibref.bibref_functions as bf
import os
from refextract import extract_references_from_file
import json
import sys


    
for line in sys.stdin:
    line0=json.loads(line)
    # get URL of the PDF
    url=line0['value']
    name=str(round(random.random()*100000))+url.split('/')[-1]

    # get PDF + convert it to txt
    pdf_filename = '/tmp/'+name

    try:
        response = bf.session_pdf.get(url)
        response.raise_for_status()  # check if request succeeded

        with open(pdf_filename, 'wb') as pdf_file:
            pdf_file.write(response.content)

        references_structured = extract_references_from_file(pdf_filename)
        
        os.remove(pdf_filename)
    except:
        references_structured = []

    references = []
    for reference in references_structured:
        if "author" in reference:
            try:
                references.append(reference['raw_ref'][0])
            except:
                continue
    
    all_res = []
    for reference in references:
        res = bf.biblio_ref(reference)
        res['reference'] = reference
        res['url_pdf']=url
        all_res.append(res)
        
    line0['value'] = all_res
    sys.stdout.write(json.dumps(line0))
    sys.stdout.write('\n')
