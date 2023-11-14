#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
from unidecode import unidecode

for line in sys.stdin:
    data = json.loads(line)
    data["value"] = unidecode(data["value"])
    sys.stdout.write(json.dumps(data))
    sys.stdout.write("\n")
