POST {{host}}/v1/en/dico_pos/postag?input=terms
content-type: text/csv
```
id	text
http://data.loterre.fr/ark:/67375/P66#xl_en_9278939f	qualities
http://data.loterre.fr/ark:/67375/P66#xl_en_60f6687f	quality
http://data.loterre.fr/ark:/67375/P66#xl_en_696ab94f	material entities
http://data.loterre.fr/ark:/67375/P66#xl_en_c0a4dac9	material entit

```

HTTP 200
[Asserts]
body contains "id"    "token" "postag"        "lemma"
body contains "http://data.loterre.fr/ark:/67375/P66#xl_fr_f50b83a0"  "qualités"      "NOUN"  "qualité"
body contains "http://data.loterre.fr/ark:/67375/P66#xl_fr_34241fc9"  "qualité"       "NOUN"  "qualité"
body contains "http://data.loterre.fr/ark:/67375/P66#xl_fr_b417452d"  "entités matérielles"   "NOUN ADJ"      "entité matériel"
body contains "http://data.loterre.fr/ark:/67375/P66#xl_fr_dc89e46c"  "entité matérielle"     "NOUN ADJ"      "entité matériel"
body contains "http://data.loterre.fr/ark:/67375/P66#xl_fr_b3ab2f06"  "processus"     "NOUN"  "processus"
