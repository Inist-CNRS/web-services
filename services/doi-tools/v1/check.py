#!/usr/bin/env python3

import re
import sys
import json
from requests_ratelimiter import LimiterSession


mail_adress = "leo.gaillard@cnrs.fr"
session = LimiterSession(per_second=10)

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
    dois = data["value"]
    if isinstance(dois, str):
        dois= dois.split(",")

    result = []
    for doi in dois:
        crossref_status_code = verify_doi(doi) # Verify doi using crossref api
        if crossref_status_code==200:  # If request return code 200
            result.append(doi)
            
    data["value"] = result
    json.dump(data, sys.stdout)
    sys.stdout.write("\n")
