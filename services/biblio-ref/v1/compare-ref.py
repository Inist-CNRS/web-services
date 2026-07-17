#!/usr/bin/env python3

import json
import sys
import bibref.bibref_functions as bf
from thefuzz import fuzz
import urllib.parse


# WS
for line in sys.stdin:
    data = json.loads(line)
    res = {"id": data["id"]}
    try:
        raw_ref = data["value"]["reference"]
    except Exception:
        res["value"] = "invalid input"
        sys.stdout.write(json.dumps(res))
        sys.stdout.write("\n")
        continue
    
    try:
        doi = data["value"]["doi"]
    except Exception:
        doi = ""
    
    if not doi:
        url = f'https://api.crossref.org/works?query.bibliographic={urllib.parse.quote(raw_ref)}&rows=2'
        try:
            response = bf.session_crossref.get(url, headers=bf.crossref_headers)
            data = response.json()
            items = data["message"]["items"]  # to check
            item_info = bf.get_title_authors_doi_source_date(items[0])
            doi = item_info["doi"]
        except Exception:
            res["value"] = "could not find DOI with raw ref"
            sys.stdout.write(json.dumps(res))
            sys.stdout.write("\n")
            continue


        

    crossref_status_code, _, others_biblio_info = bf.process_crossref_doi(doi, raw_ref)
    
    if crossref_status_code != 200 :
        res["value"] = f"Crossref status code {str(crossref_status_code)}"
        sys.stdout.write(json.dumps(res))
        sys.stdout.write("\n")
        continue
    

    try:
        res["value"] = {
                "from_crossref": {
                    "title": others_biblio_info["title"],
                    "first_author_name": others_biblio_info["first_author_name"],
                    "date": others_biblio_info["date"],
                    "source_long": others_biblio_info["source"]["source-long"],
                    "source_short": others_biblio_info["source"]["source-short"]
                },
                "raw_ref": raw_ref,
                "matches_scores": {
                    "title": bf.compute_partial_ratio(bf.clean_crossref_title(others_biblio_info["title"]), raw_ref),
                    "author": 1 if others_biblio_info["first_author_name"] and bf.uniformize(others_biblio_info["first_author_name"]) in bf.uniformize(raw_ref) else 0,
                    "source_short": bf.compute_partial_ratio(others_biblio_info["source"]["source-short"], raw_ref),
                    "source_long": bf.compute_partial_ratio(others_biblio_info["source"]["source-long"], raw_ref),
                    "date": 1 if others_biblio_info["date"] in raw_ref else 0
                }
            }

        sys.stdout.write(json.dumps(res))
        sys.stdout.write("\n")
    except Exception as e:
        res["value"] = f"Error while writing res : {str(e)}"
        sys.stdout.write(json.dumps(res))
