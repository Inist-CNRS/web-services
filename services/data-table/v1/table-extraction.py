#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import sys
from img2table.ocr import TesseractOCR
from img2table.document import PDF

lang = sys.argv[sys.argv.index('-p') + 1] if '-p' in sys.argv else "eng"
format = sys.argv[sys.argv.index('-q') + 1] if '-q' in sys.argv else "index"

tesseract_ocr = TesseractOCR(n_threads=1, lang=lang)

for line in sys.stdin:
    line0 = json.loads(line)
    pdf_filename = line0["value"]["data"]
    pdf = PDF(bytes(pdf_filename))
    extracted_tables = pdf.extract_tables(ocr=tesseract_ocr,
                                        implicit_rows=False,
                                        borderless_tables=True,
                                        min_confidence=50)
    all_datas = []
    for page, tables in extracted_tables.items():
        for idx, table in enumerate(tables):
            all_datas.append({"page":page, "json":table.df.to_dict(orient=format)})
    
    line0["value"] = all_datas
    sys.stdout.write(json.dumps(line0))
    sys.stdout.write('\n')
