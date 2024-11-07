#!/usr/bin/env python3

from bibref.bibref_functions import *


# WS
for line in sys.stdin:
    data = json.loads(line)
    ref_biblio = data["value"]
    
    res = biblio_ref(ref_biblio)
    
    data["value"] = res
    json.dump(data, sys.stdout)
    sys.stdout.write("\n")
