#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import random
import bibref.bibref_functions as bf
import bibref.extract_references_grobid as erg
import os
import json
import sys


for line in sys.stdin:
    line0 = json.loads(line)
    # get URL of the PDF
    url = line0['value']
    name = str(round(random.random()*100000))+url.split('/')[-1]

    # get PDF + convert it to txt
    pdf_filename = '/tmp/'+name

    try:
        response = bf.session_pdf.get(url)
        response.raise_for_status()  # check if request succeeded

        with open(pdf_filename, 'wb') as pdf_file:
            pdf_file.write(response.content)

        tei_references = erg.extract_references_tei(pdf_filename)
        references = erg.extract_raw_refs(tei_references)

        try:
            os.remove(pdf_filename)
        except Exception:
            pass

    except Exception:
        references = []

    all_res = []
    for reference in references:
        res = bf.biblio_ref(reference)
        res['reference'] = reference
        res['url_pdf'] = url
        all_res.append(res)

    line0['value'] = all_res
    sys.stdout.write(json.dumps(line0))
    sys.stdout.write('\n')
