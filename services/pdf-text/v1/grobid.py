#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import sys
import os
import requests


GROBID_URL = os.getenv("GROBID_API_URL")


def extract_references_tei(pdf_path):
    with open(pdf_path, 'rb') as pdf_file:
        files = {
            'input': (pdf_path, pdf_file, 'application/pdf')
        }
        try:
            response = requests.post(GROBID_URL, files=files)

            if response.status_code == 200:
                tei_xml = response.text
                return tei_xml
            else:
                sys.stderr.write(
                    f"\nError API grobid : {str(response.status_code)}\n"
                    )
                return None

        except Exception as e:
            sys.stderr.write(f"\nError with grobid : {str(e)}\n")
            return None


for line in sys.stdin:
    line0 = json.loads(line)
    try:
        pdf_filename = line0["filename"]
        tei_article = extract_references_tei(pdf_filename)
    except Exception as e:
        pdf_filename = "n/a"
        tei_article = "n/a"
        sys.stderr.write(f"Error processing ref : {str(e)}\n")

    try:
        os.remove(pdf_filename)
    except Exception as e:
        sys.stderr.write(f"Error : can t delete pdf ({str(e)})\n")
        
    sys.stdout.write(json.dumps({"id": pdf_filename, "value": tei_article}))
    sys.stdout.write("\n")
