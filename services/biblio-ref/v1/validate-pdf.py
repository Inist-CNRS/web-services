#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import bibref.bibref_functions as bf
import bibref.extract_references_grobid as erg
import json
import sys


for line in sys.stdin:
    line0 = json.loads(line)
    pdf_filename = line0["filename"]

    try:
        tei_references = erg.extract_references_tei(pdf_filename)
    except Exception as e:
        tei_references = None

    try:
        os.remove(pdf_filename)
    except Exception:
        pass

    try:
        references = erg.extract_raw_refs(tei_references)
    except Exception as e:
        references = []

    idx = 0
    if len(references) == 0:
        sys.stdout.write(json.dumps({
            "id": idx,
            "value": {"doi": "", "status": "error_data"}
            }))
        sys.stdout.write('\n')
    else:
        for reference in references:
            idx += 1
            res = bf.biblio_ref(reference)
            res['reference'] = reference
            sys.stdout.write(json.dumps({
                "id": idx,
                "value": res
                }))
            sys.stdout.write('\n')
