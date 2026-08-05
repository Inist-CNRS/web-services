#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
JSON-line service for image duplication detection.

Reads one JSON request per line from stdin, runs the SIFT/RANSAC pipeline
against every embedded image of the supplied PDF, and writes the result
to /tmp/<pid>/composite.png + /tmp/<pid>/report.html.

Input (one JSON object per line on stdin):
    {
        "value": "<PDF content as bytes or latin-1 string>",
        "PID<pid>": "PID<pid>"      # value of the key starts with "PID"
                                      # and the actual PID is obtained
                                      # via .value[5:] (skips "PID: " or
                                      # "PID<…>" prefix used upstream)
    }

Output (one JSON object per line on stdout):
    {"value": "Ok", "summary": {...}}            # success
    {"value": "Error: <message>", "summary": {}} # failure

Heavy lifting lives in ressources.py. This file only handles the JSON
envelope.
"""

import json
import os
import sys
import traceback

from ressources import process_pdf


# ---------------------------------------------------------------------------
# Stdin → JSON request parser (preserves the original skeleton)
# ---------------------------------------------------------------------------

lines = []
pid = ""

for line in sys.stdin:
    data = json.loads(line)
    isPid = [x for x in list(data.keys()) if x.startswith("PID")]
    if len(isPid) > 0:
        pid = data[isPid[0]][5:]
    lines.append(data["value"])


# ---------------------------------------------------------------------------
# Per-PDF processing
# ---------------------------------------------------------------------------

for line in lines:
    pdf_filename = line

    # Materialise the incoming payload as a bytes object. Upstream
    # pipelines typically pass already-bytes content; if we receive a
    # str we fall back to latin-1 (1:1 byte↔char mapping) so we can
    # round-trip raw PDF bytes that were encoded as a JSON string.
    if isinstance(pdf_filename, (bytes, bytearray, memoryview)):
        pdf_bytes = bytes(pdf_filename)
    else:
        try:
            pdf_bytes = bytes(pdf_filename, "latin-1")
        except TypeError:
            pdf_bytes = pdf_filename

    summary: dict = {}
    try:
        out_dir = os.path.join("/tmp", pid)
        summary = process_pdf(pdf_bytes=pdf_bytes, pid=pid, out_dir=out_dir)
        result = "Ok"
    except Exception as exc:
        sys.stderr.write(f"[imageDup-detect] error for pid={pid}: {exc}\n")
        sys.stderr.write(traceback.format_exc())
        result = f"Error: {exc}"

    sys.stdout.write(json.dumps({"value": result, "summary": summary}))
    sys.stdout.write("\n")
    sys.stdout.flush()