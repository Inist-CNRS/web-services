#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import sys
import fitz
from flair.models import SequenceTagger
from flair.data import Sentence
from kaggle.api.kaggle_api_extended import KaggleApi
from huggingface_hub import HfApi
from dataset import footnote
from dataset import api
import time
import logging


logging.getLogger("flair").handlers[0].stream = sys.stderr

dataset_path = "v1/dataset/"
with open(dataset_path+'pwc_datasets.json', 'r') as file:
    pwc_datasets = json.load(file)

api_kaggle = KaggleApi()
api_kaggle.authenticate()

api_hugg = HfApi()
classAPI = api.API(api_hugg, api_kaggle, pwc_datasets)

tagger = SequenceTagger.load("v1/model-dataset.pt")

for line in sys.stdin:
    print("1", file=sys.stderr)
    line0 = json.loads(line)
    time.sleep(5)
    print("2", file=sys.stderr)
    #print(line0, file=sys.stderr)
    pdf_filename = line0["value"]["data"]
    print("BEFORE OPEN", file=sys.stderr)
    doc = fitz.open(None, bytes(pdf_filename), "pdf")
    print("AFTER OPEN", file=sys.stderr)
    list_entity = []
    for page in doc:
        page_id = page
        blocks = page.get_text("blocks")
        previous_block_id = 0
        foot_note = footnote.extract_footnote(page.get_text("dict")["blocks"])
        for block in blocks:
            if block[6] == 0:
                sent = block[4]
                sentence = Sentence(sent)
                tagger.predict(sentence)
                for entity in sentence.get_spans('ner'):
                    foot_link = footnote.check_link_w_foot(entity.text, foot_note)
                    classAPI.clean_dataset(entity.text)
                    ppwc_link = classAPI.request_paper_with_code()
                    kaggle_link = classAPI.request_kaggle()
                    hugg_link = classAPI.request_huggingface()
                    list_entity.append({"entity": entity.text, "footnote": foot_link,
                                        "ppwc": ppwc_link, "kaggle": kaggle_link,
                                        "hugg": hugg_link})
                    print({"entity": entity.text, "footnote": foot_link,
                           "ppwc": ppwc_link, "kaggle": kaggle_link,
                           "hugg": hugg_link}, file=sys.stderr)
    print("DONE", file=sys.stderr)
    line0["value"] = list_entity
    sys.stdout.write(json.dumps(line0))
    sys.stdout.write('\n')
    print("PUSHED", file=sys.stderr)
