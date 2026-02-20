# WARNING: This file should have CRLF line endings. It is an exception.
#          See .gitattributes
# @host=http://localhost:31976
# @host=https://terms-tools.services.istex.fr

# POST
POST {{host}}/v1/en/terms-matcher/json-standoff/annotate?loterreID=9SD
content-type: application/json
[
{"id":"1","value":"The United States of America (USA), also known as the United States (U.S.) or America, is a country primarily located in North America. It is a federal republic of 50 states and Washington, D.C. as its federal capital district."}
]
HTTP 200
[{"id":"1","value":[{"idx":{"start":"1","end":"5"},"match":{"id":"http://data.loterre.fr/ark:/67375/9SD-SX203NZG-V","ul":"United States of America","term":"united states of america"}},{"idx":{"start":"6","end":"7"},"match":{"id":"http://data.loterre.fr/ark:/67375/9SD-SX203NZG-V","ul":"USA","term":"usa"}},{"idx":{"start":"13","end":"15"},"match":{"id":"http://data.loterre.fr/ark:/67375/9SD-SX203NZG-V","ul":"United States","term":"united states"}},{"idx":{"start":"19","end":"20"},"match":{"id":"http://data.loterre.fr/ark:/67375/9SD-SX203NZG-V","ul":"America","term":"america"}},{"idx":{"start":"27","end":"29"},"match":{"id":"http://data.loterre.fr/ark:/67375/9SD-VV1MBK24-T","ul":"North America","term":"north america"}},{"idx":{"start":"38","end":"39"},"match":{"id":"http://data.loterre.fr/ark:/67375/9SD-PG5NZG4Z-3","ul":"and","term":"and"}},{"idx":{"start":"39","end":"42"},"match":{"id":"http://data.loterre.fr/ark:/67375/9SD-LXLPG87F-3","ul":"Washington, D.C.","term":"washington, d.c."}}]}]

# POST
POST {{host}}/v1/fr/terms-matcher/json-standoff/annotate?loterreID=P66
content-type: application/json
[
{"id":"1","value":"Les pertes de mémoire subjective appelés aussi troubles mnésiques correspondent à la difficulté à mémoriser un fait actuel à retrouver un souvenir."}
]
HTTP 200
[{"id":"1","value":[{"idx":{"start":"1","end":"5"},"match":{"id":"http://data.loterre.fr/ark:/67375/P66-W1LP7KG3-6","ul":"pertes de mémoire subjective","term":"perte de mémoire subjectif"}},{"idx":{"start":"7","end":"9"},"match":{"id":"http://data.loterre.fr/ark:/67375/P66-GNBK2L59-K","ul":"troubles mnésiques","term":"trouble mnésique"}}]}]

# POST
POST {{host}}/v1/en/terms-matcher/json-indoc/annotate?loterreID=P66
content-type:  application/json
[
{"id":"18","value":"The Mem-Pro-Clinic test is a clinical test to assess difficulties in event- and time-based prospective thoughts. This result implies that activated long-term memory provides a representational basis for semantic verbal short-term signal."},
{"id":"27","value":"A new method to implant false autobiographical books: Blind implantation call blind implantation methods."},
{"id":"35","value":"A guy with hypermnesia (Pathology) is capable of storing idea in an extraordinarily efficient manner."}
]

HTTP 200
[{"id":"18","value":"The [Mem-Pro-Clinic test](http://data.loterre.fr/ark:/67375/P66-WG17XBG4-V) is a clinical test to assess difficulties in event- and time-based [prospective thoughts](http://data.loterre.fr/ark:/67375/P66-VLJ0CQH4-G) . This result implies that activated [long-term memory](http://data.loterre.fr/ark:/67375/P66-J8FC45M1-6) provides a representational basis for semantic verbal short-term signal."},{"id":"27","value":"A new method to implant false autobiographical books: Blind implantation call [blind implantation methods](http://data.loterre.fr/ark:/67375/P66-D6XL3PDR-M) ."},{"id":"35","value":"A guy with [hypermnesia ( Pathology )](http://data.loterre.fr/ark:/67375/P66-FQXK8KBN-C) is capable of storing idea in an extraordinarily efficient manner."}]

# POST
POST {{host}}/v1/en/terms-matcher/xml-standoff/annotate?loterreID=QX8
content-type: application/json
[
{"id":"1","value":"Sustainable agriculture is farming in sustainable ways meeting society's present food and textile needs, without compromising the ability for current or future generations to meet their needs.[1] It can be based on an understanding of ecosystem services. There are many methods to increase the sustainability of agriculture. When developing agriculture within the sustainable food systems, it is important to develop flexible business processes and farming practices.[2] Agriculture has an enormous environmental footprint, playing a significant role in causing climate change (food systems are responsible for one third of the anthropogenic greenhouse gas emissions),[3][4] water scarcity, water pollution, land degradation, deforestation and other processes;[5] it is simultaneously causing environmental changes and being impacted by these changes.[6] Sustainable agriculture consists of environment friendly methods of farming that allow the production of crops or livestock without causing damage to human or natural systems. It involves preventing adverse effects on soil, water, biodiversity, and surrounding or downstream resources, as well as to those working or living on the farm or in neighboring areas. Elements of sustainable agriculture can include permaculture, agroforestry, mixed farming, multiple cropping, and crop rotation"}
]

HTTP 200
[Asserts]
xpath "//*[name()='tag']" count >= 6 #
#<?xml version="1.0" encoding="UTF-8"?><result><text><tag id_start="235" idx_end="244" id="http://data.loterre.fr/ark:/67375/QX8-L18B0KDG-2" text="ecosystem" termeReconnu="ecosystem" pref="ecosystem" lang="en"/><tag id_start="562" idx_end="576" id="http://data.loterre.fr/ark:/67375/QX8-QLSHDGTM-R" text="climate change" termeReconnu="climate change" pref="climate change" lang="en"/><tag id_start="642" idx_end="656" id="http://data.loterre.fr/ark:/67375/QX8-TV4HCGVQ-N" text="greenhouse gas" termeReconnu="greenhouse gas" pref="greenhouse gas" lang="en"/><tag id_start="675" idx_end="680" id="http://data.loterre.fr/ark:/67375/QX8-2CVW37BQ-W" text="water" termeReconnu="water" pref="water" lang="en"/><tag id_start="691" idx_end="696" id="http://data.loterre.fr/ark:/67375/QX8-2CVW37BQ-W" text="water" termeReconnu="water" pref="water" lang="en"/><tag id_start="697" idx_end="706" id="http://data.loterre.fr/ark:/67375/QX8-MDRFDK0T-J" text="pollution" termeReconnu="pollution" pref="anthropic pollution" lang="en"/><tag id_start="726" idx_end="739" id="http://data.loterre.fr/ark:/67375/QX8-QX28XWS3-B" text="deforestation" termeReconnu="deforestation" pref="forest clearance" lang="en"/><tag id_start="1073" idx_end="1077" id="http://data.loterre.fr/ark:/67375/QX8-J5RB1HTC-P" text="soil" termeReconnu="soil" pref="soil" lang="en"/><tag id_start="1079" idx_end="1084" id="http://data.loterre.fr/ark:/67375/QX8-2CVW37BQ-W" text="water" termeReconnu="water" pref="water" lang="en"/><tag id_start="1086" idx_end="1098" id="http://data.loterre.fr/ark:/67375/QX8-MC5QCBT5-L" text="biodiversity" termeReconnu="biodiversity" pref="biodiversity" lang="en"/></text></result>