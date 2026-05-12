#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import json
import fasttext

model_domain             = fasttext.load_model("v1/models/model_parent.bin")
model_physical_sciences  = fasttext.load_model("v1/models/model_physicalsciences.bin")
model_social_sciences    = fasttext.load_model("v1/models/model_socialsciences.bin")
model_health_sciences    = fasttext.load_model("v1/models/model_healthsciences.bin")
model_life_sciences      = fasttext.load_model("v1/models/model_lifesciences.bin")

for line in sys.stdin:
    data = json.loads(line)
    text = data["value"]

    # ── Niveau 1 : domain ─────────────────────────────────────
    domain = model_domain.predict(text)[0][0]
    domain_name = domain.replace("__label__", "")

    # ── Niveau 2 : field ──────────────────────────────────────
    if domain_name == "physical_sciences":
        field = model_physical_sciences.predict(text)[0][0]
    elif domain_name == "social_sciences":
        field = model_social_sciences.predict(text)[0][0]
    elif domain_name == "health_sciences":
        field = model_health_sciences.predict(text)[0][0]
    elif domain_name == "life_sciences":
        field = model_life_sciences.predict(text)[0][0]

    field_name = field.replace("__label__", "")

    data["value"] = {
        "domain": domain_name.replace("_", " "),
        "field":  field_name.replace("_", " ")
    }

    sys.stdout.write(json.dumps(data))
    sys.stdout.write("\n")