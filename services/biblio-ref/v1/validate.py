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
    data["value"]["reference"] = ref_biblio

    # Put the online reference after
    if "reference_found" in data["value"]:
        ref_found = data["value"]["reference_found"]
        del data["value"]["reference_found"]
        data["value"]["reference_found"] = ref_found

    json.dump(data, sys.stdout)
    sys.stdout.write("\n")
