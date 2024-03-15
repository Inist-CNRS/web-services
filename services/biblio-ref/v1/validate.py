#!/usr/bin/env python3

from requests_ratelimiter import LimiterSession
import sys
import json
from bibref.bibref_functions import *


# WS
for line in sys.stdin:
    data = json.loads(line)
    ref_biblio = data["value"]

    # check types
    if not isinstance(ref_biblio, str):
        data["value"] = {"doi":"","status": "error_data"}
        json.dump(data, sys.stdout)
        sys.stdout.write("\n")
        continue

    doi = find_doi(ref_biblio)
    ref_biblio = uniformize(ref_biblio) # Warining : in the rest of code, the biblio ref is uniformize (remove some informations)
    # First case : doi is found
    if doi:
        crossref_status_code, others_biblio_info = verify_doi(doi) # Verify doi using crossref api
        
        ## If DOI exists
        if crossref_status_code==200:
            status = "found"
            
            ### Can be retracted
            if doi in retracted_doi:
                status = "retracted"
                
            ### can be hallucinated
            if len(doi)*1.5 < len(ref_biblio): 
                is_not_hallucinated,doi = compare_pubinfo_refbiblio(others_biblio_info,ref_biblio)
                if not is_not_hallucinated: # oh really dude
                    status = "hallucinated"
                
            data["value"] = {"doi":doi,"status": status}
            json.dump(data, sys.stdout)
            sys.stdout.write("\n")
        
        ### If DOI doesn't exist
        elif crossref_status_code==404:
            status,doi = verify_biblio(ref_biblio)
            data["value"] = {"doi":doi, "status": status}
            
            json.dump(data, sys.stdout)
            sys.stdout.write("\n")
        
        ### for others errors
        else:
            data["value"] = {"doi":"","status": "error_service"}
            json.dump(data, sys.stdout)
            sys.stdout.write("\n")

    # second case : no doi is found
    else:
        status,doi = verify_biblio(ref_biblio)
        data["value"] = {"doi":doi, "status": status}
        
        json.dump(data, sys.stdout)
        sys.stdout.write("\n")
