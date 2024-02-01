#!/usr/bin/env python3

import re
from requests_ratelimiter import LimiterSession
import sys
import json
import pandas as pd

mail_adress = "leo.gaillard@cnrs.fr"
session = LimiterSession(per_second=5)

# get a list of retracted DOIs
dumps_pps = pd.read_csv("./v1/annulled.csv", encoding="cp1252")
retracted_doi = dumps_pps["DOI"].tolist()


def find_doi(text):
    """
    return the first doi found in a text (input)
    """
    doi_regex = r"\b10.\d{4,}\/[^\s]+\b"
    doi = re.search(doi_regex, text)
    if doi == None:
        return ""
    try:
        doiStr = doi.group()
        return doiStr
    except:
        return ""


def verify_doi(doi, mail=mail_adress):
    """
    Check with crossref API if DOI is correct.
    Do not use this function without function "find_doi".
    
    Returns HTTP code
    """
    url = f"https://api.crossref.org/works/{doi}/agency?mailto={mail}"

    try:
        response = session.get(url)
        return response.status_code

    except Exception:
        return 503 # if there is an unexpected error from crossref


for line in sys.stdin:
    data = json.loads(line)
    ref_biblio = data["value"]

    # check if "value" is a string
    if not isinstance(ref_biblio, str):
        data["value"] = {"doi":"","status": "error_data"}
        json.dump(data, sys.stdout)
        sys.stdout.write("\n")
        continue

    doi = find_doi(ref_biblio)
    if doi:  # doi is True if and only if a doi is found with the regex doi_regex
        crossref_status_code = verify_doi(doi) # Verify doi using crossref api
        if crossref_status_code==200:  # If request return code 200
            status = "found"
            if doi in retracted_doi:
                status = "retracted"
            data["value"] = {"doi":doi,"status": status}
            json.dump(data, sys.stdout)
            sys.stdout.write("\n")
            
        elif crossref_status_code==404:  # If request return code 404
            data["value"] = {"doi":"","status": "not_found"}
            json.dump(data, sys.stdout)
            sys.stdout.write("\n")
            
        else:
            data["value"] = {"doi":"","status": "error_service"}
            json.dump(data, sys.stdout)
            sys.stdout.write("\n")


    else:
        # C'est dans cette partie que l'on traitera la partie 2 du WS
        # data["value"] = future_function_to_check(ref_biblio)

        data["value"] = {"doi":"","status": "not_found"}
        json.dump(data, sys.stdout)
        sys.stdout.write("\n")
