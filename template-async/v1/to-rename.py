#!/usr/bin/env python3
import json
import sys

# main
for line in sys.stdin:
    data = json.loads(line)

    # Add a modification of data["value"] here

    sys.stdout.write(json.dumps(data))
    sys.stdout.write("\n")
