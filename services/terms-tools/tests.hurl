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


POST {{host}}/v1/en/terms-matcher/P66?format=json-indoc
Content-Type: application/json
[
{"id":"1","value":"The Mem-Pro-Clinic test is a clinical test to assess difficulties in event- and time-based prospective thoughts. This result implies that activated long-term memory provides a representational basis for semantic verbal short-term signal."},
{"id":"2","value":"A new method to implant false autobiographical books: Blind implantation call blind implantation methods."},
{"id":"3","value":"A guy with hypermnesia (Pathology) is capable of storing idea in an extraordinarily efficient manner."}
]

HTTP 200
[{"id":"1","value":"The TERM_Mem_-_Pro-Clinic_test is a clinical test to assess difficulties in event- and time-based TERM_prospective_thoughts . This result implies that activated TERM_long_-_term_memory provides a representational basis for semantic verbal short-term signal."},{"id":"2","value":"A new method to implant false autobiographical books: Blind implantation call TERM_blind_implantation_methods ."},{"id":"3","value":"A guy with TERM_hypermnesia_(_Pathology_) is capable of storing idea in an extraordinarily efficient manner."}]


POST {{host}}/v1/en/terms-matcher/P66?format=json-standoff
Content-Type: application/json
[
{"id":"1","value":"The Mem-Pro-Clinic test is a clinical test to assess difficulties in event- and time-based prospective thoughts. This result implies that activated long-term memory provides a representational basis for semantic verbal short-term signal."},
{"id":"2","value":"A new method to implant false autobiographical books: Blind implantation call blind implantation methods."},{"id":"3","value":"A guy with hypermnesia (Pathology) is capable of storing idea in an extraordinarily efficient manner."}
]

HTTP 200
[{"id":"1","value":[{"idx":"1-5","text":"Mem-Pro-Clinic test","lemma":"mem - pro-clinic test","id":"http://data.loterre.fr/ark:/67375/P66-WG17XBG4-V"},{"idx":"19-21","text":"prospective thoughts","lemma":"prospective thought","id":"http://data.loterre.fr/ark:/67375/P66-VLJ0CQH4-G"},{"idx":"27-31","text":"long-term memory","lemma":"long - term memory","id":"http://data.loterre.fr/ark:/67375/P66-J8FC45M1-6"}]},{"id":"2","value":[{"idx":"12-15","text":"blind implantation methods","lemma":"blind implantation method","id":"http://data.loterre.fr/ark:/67375/P66-D6XL3PDR-M"}]},{"id":"3","value":[{"idx":"3-7","text":"hypermnesia (Pathology)","lemma":"hypermnesia ( pathology )","id":"http://data.loterre.fr/ark:/67375/P66-FQXK8KBN-C"}]}]


POST {{host}}/v1/en/terms-matcher/P66?format=xml-standoff
Content-Type: text/html; charset=UTF-8
[
{"id":"1","value":"The Mem-Pro-Clinic test is a clinical test to assess difficulties in event- and time-based prospective thoughts. This result implies that activated long-term memory provides a representational basis for semantic verbal short-term signal."}
]

HTTP 200
# Reponse de type format=xml-standoff ne fonctionne pas avec les test
[Asserts]
xpath "count(///tag)" >= 2.0


POST {{host}}/v1/fr/terms-matcher/P66?format=json-standoff
Content-Type: application/json
[
{"id":"1","value":"courbe d'apprentissage à accélération positive est un type de courbe d'apprentissage indiquant que l'apprentissage débute lentement puis s'accélère."},
{"id":"2","value":"La notion de MLT est un concept utilisé dans les modèles de mémoire et de la mémoire à court terme et à la mémoire de travail."}
]

HTTP 200
[{"id":"1","value":[{"idx":"0-6","text":"courbe d'apprentissage à accélération positive","lemma":"courbe de apprentissage à accélération positif","id":"http://data.loterre.fr/ark:/67375/P66-TPDKTCB1-N"},{"idx":"10-13","text":"courbe d'apprentissage","lemma":"courbe de apprentissage","id":"http://data.loterre.fr/ark:/67375/P66-JCKZ7CC9-5"},{"idx":"16-17","text":"apprentissage","lemma":"apprentissage","id":"http://data.loterre.fr/ark:/67375/P66-R9DC7TZN-9"}]},{"id":"2","value":[{"idx":"6-7","text":"concept","lemma":"concept","id":"http://data.loterre.fr/ark:/67375/P66-V3V0Z7B2-R"},{"idx":"10-11","text":"modèles","lemma":"modèle","id":"http://data.loterre.fr/ark:/67375/P66-XJKPHB5X-M"},{"idx":"12-13","text":"mémoire","lemma":"mémoire","id":"http://data.loterre.fr/ark:/67375/P66-P3PC7CZ3-D"},{"idx":"16-20","text":"mémoire à court terme","lemma":"mémoire à court terme","id":"http://data.loterre.fr/ark:/67375/P66-QZRTL2B1-9"},{"idx":"23-26","text":"mémoire de travail","lemma":"mémoire de travail","id":"http://data.loterre.fr/ark:/67375/P66-KK6LXTL8-P"}]}]


POST {{host}}/v1/fr/terms-matcher/P66?format=xml-standoff
Content-Type: text/html; charset=UTF-8
[
{"id":"1","value":"courbe d'apprentissage à accélération positive est un type de courbe d'apprentissage indiquant que l'apprentissage débute lentement puis s'accélère."}
]

HTTP 200
# Reponse de type format=xml-standoff ne fonctionne pas avec les test
[Asserts]
#<?xml version="1.0" encoding="UTF-8"?><result><text><tag id="http://data.loterre.fr/ark:/67375/P66-TPDKTCB1-N" TermeReconnu="courbe d'apprentissage à accélération positive" lang="en">courbe d'apprentissage à accélération positive</tag><tag id="http://data.loterre.fr/ark:/67375/P66-JCKZ7CC9-5" TermeReconnu="courbe d'apprentissage" lang="en">courbe d'apprentissage</tag><tag id="http://data.loterre.fr/ark:/67375/P66-R9DC7TZN-9" TermeReconnu="apprentissage" lang="en">apprentissage</tag></text><text><tag id="http://data.loterre.fr/ark:/67375/P66-V3V0Z7B2-R" TermeReconnu="concept" lang="en">concept</tag><tag id="http://data.loterre.fr/ark:/67375/P66-XJKPHB5X-M" TermeReconnu="modèles" lang="en">modèles</tag><tag id="http://data.loterre.fr/ark:/67375/P66-P3PC7CZ3-D" TermeReconnu="mémoire" lang="en">mémoire</tag><tag id="http://data.loterre.fr/ark:/67375/P66-QZRTL2B1-9" TermeReconnu="mémoire à court terme" lang="en">mémoire à court terme</tag><tag id="http://data.loterre.fr/ark:/67375/P66-KK6LXTL8-P" TermeReconnu="mémoire de travail" lang="en">mémoire de travail</tag></text></result>
xpath "count(///tag)" >= 2.0