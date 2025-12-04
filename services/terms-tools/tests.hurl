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
#```
#"id"	"token"	"postag"	"lemma"
#"http://data.loterre.fr/ark:/67375/P66#xl_fr_f50b83a0"	"qualités"	"NOUN"	"qualité"
#"http://data.loterre.fr/ark:/67375/P66#xl_fr_34241fc9"	"qualité"	"NOUN"	"qualité"
#"http://data.loterre.fr/ark:/67375/P66#xl_fr_b417452d"	"entités matérielles"	"NOUN ADJ"	"entité matériel"
#"http://data.loterre.fr/ark:/67375/P66#xl_fr_dc89e46c"	"entité matérielle"	"NOUN ADJ"	"entité matériel"
#"http://data.loterre.fr/ark:/67375/P66#xl_fr_b3ab2f06"	"processus"	"NOUN"	"processus"
#```

POST {{host}}/v1/en/terms-matcher/9SD?format=json-standoff
Content-Type: application/json; application/json
[
{"id":"1","value":"The United States of America (USA), also known as the United States (U.S.) or America, is a country primarily located in North America. It is a federal republic of 50 states and Washington, D.C. as its federal capital district."}
]

HTTP 200
[{"id":"1","value":[{"idx":{"start":"1","end":"5"},"match":{"id":"http://data.loterre.fr/ark:/67375/9SD-SX203NZG-V","ul":"United States of America","term":"united states of america"}},{"idx":{"start":"6","end":"7"},"match":{"id":"http://data.loterre.fr/ark:/67375/9SD-SX203NZG-V","ul":"USA","term":"usa"}},{"idx":{"start":"13","end":"15"},"match":{"id":"http://data.loterre.fr/ark:/67375/9SD-SX203NZG-V","ul":"United States","term":"united states"}},{"idx":{"start":"19","end":"20"},"match":{"id":"http://data.loterre.fr/ark:/67375/9SD-SX203NZG-V","ul":"America","term":"america"}},{"idx":{"start":"27","end":"29"},"match":{"id":"http://data.loterre.fr/ark:/67375/9SD-VV1MBK24-T","ul":"North America","term":"north america"}},{"idx":{"start":"38","end":"39"},"match":{"id":"http://data.loterre.fr/ark:/67375/9SD-PG5NZG4Z-3","ul":"and","term":"and"}},{"idx":{"start":"39","end":"42"},"match":{"id":"http://data.loterre.fr/ark:/67375/9SD-LXLPG87F-3","ul":"Washington, D.C.","term":"washington, d.c."}}]}]


POST {{host}}/v1/en/terms-matcher/P66?format=json-indoc
Content-Type: application/json
[
{"id":"18","value":"The Mem-Pro-Clinic test is a clinical test to assess difficulties in event- and time-based prospective thoughts. This result implies that activated long-term memory provides a representational basis for semantic verbal short-term signal."},
{"id":"27","value":"A new method to implant false autobiographical books: Blind implantation call blind implantation methods."},
{"id":"35","value":"A guy with hypermnesia (Pathology) is capable of storing idea in an extraordinarily efficient manner."}
]

HTTP 200
[{"id":"18","value":"the [Mem-Pro-Clinic test](http://data.loterre.fr/ark:/67375/P66-WG17XBG4-V) is a clinical test to assess difficulties in [events](http://data.loterre.fr/ark:/67375/P66-ZVGCX1H2-G)- and time-based [prospective thought](http://data.loterre.fr/ark:/67375/P66-VLJ0CQH4-G). this   implies that activated [long-term memory](http://data.loterre.fr/ark:/67375/P66-J8FC45M1-6) provides a representational basis for semantic verbal short-term signal."},{"id":"27","value":"a new method to implant false autobiographical books: blind implantation call [blind implantation method](http://data.loterre.fr/ark:/67375/P66-D6XL3PDR-M)."},{"id":"35","value":"a guy with [hypermnesia (pathology)](http://data.loterre.fr/ark:/67375/P66-FQXK8KBN-C) is capable of storing idea in an extraordinarily efficient manner."}]


POST {{host}}/v1/en/terms-matcher/P66?format=xml-standoff
Content-Type: application/json
[
{"id":"18","value":"The Mem-Pro-Clinic test is a clinical test to assess difficulties in event- and time-based prospective thoughts. This result implies that activated long-term memory provides a representational basis for semantic verbal short-term signal."},
{"id":"27","value":"A new method to implant false autobiographical books: Blind implantation call blind implantation methods."},
{"id":"35","value":"A guy with hypermnesia (Pathology) is capable of storing idea in an extraordinarily efficient manner."}
]

HTTP 200
# Reponse de type format=xml-standoff ne fonctionne pas avec les test
[Asserts]
xpath "count(///tag)" >= 2.0


POST {{host}}/v1/fr/terms-matcher/P66?format=json-standoff
Content-Type: application/json
[
{"id":"1","value":"Les pertes de mémoire subjective appelés aussi troubles mnésiques correspondent à la difficulté à mémoriser un fait actuel à retrouver un souvenir."}
]
HTTP 200
[{"id":"1","value":[{"idx":{"start":"3","end":"29"},"match":{"id":"http://data.loterre.fr/ark:/67375/P66-W1LP7KG3-6","ul":"perte de mémoire subjectif","term":"perte de mémoire subjective","pref":"plainte mnésique"}},{"idx":{"start":"44","end":"60"},"match":{"id":"http://data.loterre.fr/ark:/67375/P66-GNBK2L59-K","ul":"trouble mnésique","term":"trouble mnésique","pref":"trouble de la mémoire"}}]}]


POST {{host}}/v1/fr/terms-matcher/QX8?format=xml-standoff
Content-Type: application/json
[
{"id":"1","value":"Sustainable agriculture is farming in sustainable ways meeting society's present food and textile needs, without compromising the ability for current or future generations to meet their needs.[1] It can be based on an understanding of ecosystem services. There are many methods to increase the sustainability of agriculture. When developing agriculture within the sustainable food systems, it is important to develop flexible business processes and farming practices.[2] Agriculture has an enormous environmental footprint, playing a significant role in causing climate change (food systems are responsible for one third of the anthropogenic greenhouse gas emissions),[3][4] water scarcity, water pollution, land degradation, deforestation and other processes;[5] it is simultaneously causing environmental changes and being impacted by these changes.[6] Sustainable agriculture consists of environment friendly methods of farming that allow the production of crops or livestock without causing damage to human or natural systems. It involves preventing adverse effects on soil, water, biodiversity, and surrounding or downstream resources, as well as to those working or living on the farm or in neighboring areas. Elements of sustainable agriculture can include permaculture, agroforestry, mixed farming, multiple cropping, and crop rotation"}
]


HTTP 200
# Reponse de type format=xml-standoff ne fonctionne pas avec les test
[Asserts]
#<?xml version="1.0" encoding="UTF-8"?><result><text><tag id_start="15" idx_end="24" id="http://data.loterre.fr/ark:/67375/QX8-B5CTHWS7-J" text="algonkien" termeReconnu="Algonkien" pref="Algonkien" lang="en"/><tag id_start="27" idx_end="28" id="http://data.loterre.fr/ark:/67375/QX8-091KDCTD-D" text="d" termeReconnu="D" pref="deutérium" lang="en"/><tag id_start="65" idx_end="66" id="http://data.loterre.fr/ark:/67375/QX8-S9QWDZLZ-8" text="s" termeReconnu="S" pref="soufre" lang="en"/><tag id_start="89" idx_end="90" id="http://data.loterre.fr/ark:/67375/QX8-091KDCTD-D" text="d" termeReconnu="D" pref="deutérium" lang="en"/><tag id_start="134" idx_end="141" id="http://data.loterre.fr/ark:/67375/QX8-5JG3C031-Z" text="archéen" termeReconnu="Archéen" pref="Archéen" lang="en"/><tag id_start="148" idx_end="161" id="http://data.loterre.fr/ark:/67375/QX8-PBSTP7GD-6" text="phanérozoïque" termeReconnu="Phanérozoïque" pref="Phanérozoïque" lang="en"/><tag id_start="304" idx_end="312" id="http://data.loterre.fr/ark:/67375/QX8-JPZF7ZDV-2" text="datation" termeReconnu="datation" pref="datation" lang="en"/><tag id_start="365" idx_end="366" id="http://data.loterre.fr/ark:/67375/QX8-091KDCTD-D" text="d" termeReconnu="D" pref="deutérium" lang="en"/><tag id_start="374" idx_end="382" id="http://data.loterre.fr/ark:/67375/QX8-ZF6TQ5X0-3" text="cambrien" termeReconnu="Cambrien" pref="Cambrien" lang="en"/><tag id_start="418" idx_end="425" id="http://data.loterre.fr/ark:/67375/QX8-625M7DXH-J" text="fossile" termeReconnu="fossile" pref="fossile" lang="en"/><tag id_start="426" idx_end="427" id="http://data.loterre.fr/ark:/67375/QX8-091KDCTD-D" text="d" termeReconnu="D" pref="deutérium" lang="en"/><tag id_start="511" idx_end="513" id="http://data.loterre.fr/ark:/67375/QX8-K2WJNMR5-R" text="si" termeReconnu="Si" pref="silicium" lang="en"/><tag id_start="521" idx_end="528" id="http://data.loterre.fr/ark:/67375/QX8-625M7DXH-J" text="fossile" termeReconnu="fossile" pref="fossile" lang="en"/><tag id_start="553" idx_end="554" id="http://data.loterre.fr/ark:/67375/QX8-091KDCTD-D" text="d" termeReconnu="D" pref="deutérium" lang="en"/><tag id_start="571" idx_end="576" id="http://data.loterre.fr/ark:/67375/QX8-KFDBL3TR-S" text="roche" termeReconnu="roche" pref="roche" lang="en"/><tag id_start="586" idx_end="597" id="http://data.loterre.fr/ark:/67375/QX8-BLPF1V6W-V" text="précambrien" termeReconnu="Précambrien" pref="Précambrien" lang="en"/><tag id_start="613" idx_end="626" id="http://data.loterre.fr/ark:/67375/QX8-6V9LHWZ0-K" text="protérozoïque" termeReconnu="Protérozoïque" pref="Protérozoïque" lang="en"/><tag id_start="648" idx_end="649" id="http://data.loterre.fr/ark:/67375/QX8-091KDCTD-D" text="d" termeReconnu="D" pref="deutérium" lang="en"/><tag id_start="657" idx_end="665" id="http://data.loterre.fr/ark:/67375/QX8-ZF6TQ5X0-3" text="cambrien" termeReconnu="Cambrien" pref="Cambrien" lang="en"/></text></result>