# WARNING: This file should have CRLF line endings. It is an exception.
#          See .gitattributes
POST {{host}}/v1/en/dico-pos/postag?input=terms
Content-Type: text/tab-separated-values
```
id	value
http://data.loterre.fr/ark:/67375/P66#xl_en_9278939f	qualities
http://data.loterre.fr/ark:/67375/P66#xl_en_60f6687f	quality
http://data.loterre.fr/ark:/67375/P66#xl_en_696ab94f	material entities
http://data.loterre.fr/ark:/67375/P66#xl_en_c0a4dac9	material entity
http://data.loterre.fr/ark:/67375/P66#xl_en_ded9af98	processes
```

HTTP 200
#```
#"id"	"token"	"postag"	"lemma"
#"http://data.loterre.fr/ark:/67375/P66#xl_en_9278939f"	"qualities"	"NNS"	"quality"
#"http://data.loterre.fr/ark:/67375/P66#xl_en_60f6687f"	"quality"	"NN"	"quality"
#"http://data.loterre.fr/ark:/67375/P66#xl_en_696ab94f"	"material entities"	"NN NNS"	"material  entity"
#"http://data.loterre.fr/ark:/67375/P66#xl_en_c0a4dac9"	"material entity"	"NN NN"	"material entity"
#"http://data.loterre.fr/ark:/67375/P66#xl_en_ded9af98"	"processes"	"NNS"	"process"
#```

POST {{host}}/v1/fr/dico-pos/postag?input=terms
Content-Type: text/tab-separated-values
```
id	value
http://data.loterre.fr/ark:/67375/P66#xl_fr_f50b83a0	qualités
http://data.loterre.fr/ark:/67375/P66#xl_fr_34241fc9	qualité
http://data.loterre.fr/ark:/67375/P66#xl_fr_b417452d	entités matérielles
http://data.loterre.fr/ark:/67375/P66#xl_fr_dc89e46c	entité matérielle
http://data.loterre.fr/ark:/67375/P66#xl_fr_b3ab2f06	processus
```

HTTP 200
```
"id"	"token"	"postag"	"lemma"
"http://data.loterre.fr/ark:/67375/P66#xl_fr_f50b83a0"	"qualités"	"NOUN"	"qualité"
"http://data.loterre.fr/ark:/67375/P66#xl_fr_34241fc9"	"qualité"	"NOUN"	"qualité"
"http://data.loterre.fr/ark:/67375/P66#xl_fr_b417452d"	"entités matérielles"	"NOUN ADJ"	"entité matériel"
"http://data.loterre.fr/ark:/67375/P66#xl_fr_dc89e46c"	"entité matérielle"	"NOUN ADJ"	"entité matériel"
"http://data.loterre.fr/ark:/67375/P66#xl_fr_b3ab2f06"	"processus"	"NOUN"	"processus"
```


POST {{host}}/v1/en/terms-matcher/P66
Content-Type: application/json

[
{"id":"1","value":"The Mem-Pro-Clinic test is a clinical test to assess difficulties in event- and time-based prospective thoughts. This result implies that activated long-term memory provides a representational basis for semantic verbal short-term signal."},
{"id":"2","value":"A new method to implant false autobiographical books: Blind implantation call blind implantation methods."},
{"id":"3","value":"A guy with hypermnesia (Pathology) is capable of storing idea in an extraordinarily efficient manner."}
]

HTTP 200

#[Asserts]
#<?xml version="1.0" encoding="UTF-8"?><result><text><tag #id="http://data.loterre.fr/ark:/67375/P66-D6XL3PDR-M" TermeReconnu="blind implantation methods" #lang="en">blind implantation methods</tag></text><text><tag id="http://data.loterre.fr/ark:/67375/P66-WG17XBG4-V" TermeReconnu="Mem-Pro-Clinic test" #lang="en">Mem-Pro-Clinic test</tag><tag id="http://data.loterre.fr/ark:/67375/P66-VLJ0CQH4-G" #TermeReconnu="prospective thoughts" lang="en">prospective thoughts</tag><tag id="http://data.loterre.fr/ark:/67375/P66-J8FC45M1-6" TermeReconnu="long-term memory" #lang="en">long-term memory</tag></text></result>


POST {{host}}/v1/fr/terms-matcher/P66
Content-Type: application/json

[
{"id":"1","value":"courbe d'apprentissage à accélération positive est un type de courbe d'apprentissage indiquant que l'apprentissage débute lentement puis s'accélère."},
{"id":"2","value":"La notion de MLT est un concept utilisé dans les modèles de mémoire et de la mémoire à court terme et à la mémoire de travail."}
]

HTTP 200

#[Asserts]
#<?xml version="1.0" encoding="UTF-8"?><result><text><tag id="http://data.loterre.fr/ark:/67375/P66-TPDKTCB1-N" TermeReconnu="courbe d'apprentissage à accélération positive" lang="en">courbe d'apprentissage à accélération positive</tag><tag id="http://data.loterre.fr/ark:/67375/P66-JCKZ7CC9-5" TermeReconnu="courbe d'apprentissage" lang="en">courbe d'apprentissage</tag><tag id="http://data.loterre.fr/ark:/67375/P66-R9DC7TZN-9" TermeReconnu="apprentissage" lang="en">apprentissage</tag></text><text><tag id="http://data.loterre.fr/ark:/67375/P66-V3V0Z7B2-R" TermeReconnu="concept" lang="en">concept</tag><tag id="http://data.loterre.fr/ark:/67375/P66-XJKPHB5X-M" TermeReconnu="modèles" lang="en">modèles</tag><tag id="http://data.loterre.fr/ark:/67375/P66-P3PC7CZ3-D" TermeReconnu="mémoire" lang="en">mémoire</tag><tag id="http://data.loterre.fr/ark:/67375/P66-QZRTL2B1-9" TermeReconnu="mémoire à court terme" lang="en">mémoire à court terme</tag><tag id="http://data.loterre.fr/ark:/67375/P66-KK6LXTL8-P" TermeReconnu="mémoire de travail" lang="en">mémoire de travail</tag></text></result>