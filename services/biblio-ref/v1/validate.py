#!/usr/bin/env python3

import json
import sys
import bibref.bibref_functions as bf


# WS
for line in sys.stdin:
    data = json.loads(line)
    ref_biblio = data["value"]
    
    res = bf.biblio_ref(ref_biblio)
    
    data["value"] = res
    json.dump(data, sys.stdout)
    sys.stdout.write("\n")
