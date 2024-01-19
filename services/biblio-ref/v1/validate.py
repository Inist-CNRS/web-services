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
    check with crossref api if doi is correct.
    Do not use this function without function "find_doi"
    """
    url = f"https://api.crossref.org/works/{doi}/agency?mailto={mail}"

    # Return True if DOI exists in crossref api AND if request worked
    try:
        code_response = session.get(url).status_code
        return code_response == 200
    except:
        return False


for line in sys.stdin:
    data = json.loads(line)
    ref_biblio = data["value"]
    is_found = False
    is_retracted = False

    # check if "value" is a string
    if not isinstance(ref_biblio, str):
        data["value"] = {"is_found": is_found, "is retracted": is_retracted}
        json.dump(data, sys.stdout)
        sys.stdout.write("\n")
        continue

    doi = find_doi(ref_biblio)
    if doi:  # doi is True if and only if a doi is found with the regex doi_regex
        if verify_doi(doi):  # If request return code 200
            is_found = True
            if doi in retracted_doi:
                is_retracted = True

        data["value"] = {"is_found": is_found, "is retracted": is_retracted}
        json.dump(data, sys.stdout)
        sys.stdout.write("\n")

    else:
        # C'est dans cette partie que l'on traitera la partie 2 du WS
        # data["value"] = future_function_to_check(ref_biblio)

        data["value"] = {"is_found": is_found, "is retracted": is_retracted}
        json.dump(data, sys.stdout)
        sys.stdout.write("\n")
