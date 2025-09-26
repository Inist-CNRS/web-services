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

POST {{host}}/v1/en/terms-matcher/9SD?format=json-standoff
Content-Type: application/json
[
{"id":"1","value":"The United States of America (USA), also known as the United States (U.S.) or America, is a country primarily located in North America. It is a federal republic of 50 states and Washington, D.C. as its federal capital district."}
]

HTTP 200
[{"id":"1","value":[{"idx":{"start":"4","end":"28"},"match":{"id":"http://data.loterre.fr/ark:/67375/9sd-sx203nzg-v","ul":"united states of america","term":"united states of america","pref":"united states of america"}},{"idx":{"start":"30","end":"33"},"match":{"id":"http://data.loterre.fr/ark:/67375/9sd-sx203nzg-v","ul":"usa","term":"usa","pref":"united states of america"}},{"idx":{"start":"54","end":"67"},"match":{"id":"http://data.loterre.fr/ark:/67375/9sd-sx203nzg-v","ul":"united states","term":"united states","pref":"united states of america"}},{"idx":{"start":"78","end":"85"},"match":{"id":"http://data.loterre.fr/ark:/67375/9sd-sx203nzg-v","ul":"america","term":"america","pref":"united states of america"}},{"idx":{"start":"87","end":"89"},"match":{"id":"http://data.loterre.fr/ark:/67375/9sd-sc6kk28b-5","ul":"is","term":"is","pref":"iceland"}},{"idx":{"start":"118","end":"120"},"match":{"id":"http://data.loterre.fr/ark:/67375/9sd-hz1prmzw-x","ul":"in","term":"in","pref":"india"}},{"idx":{"start":"121","end":"134"},"match":{"id":"http://data.loterre.fr/ark:/67375/9sd-vv1mbk24-t","ul":"north america","term":"north america","pref":"north america"}},{"idx":{"start":"136","end":"138"},"match":{"id":"http://data.loterre.fr/ark:/67375/9sd-d7887r60-w","ul":"it","term":"it","pref":"italy"}},{"idx":{"start":"139","end":"141"},"match":{"id":"http://data.loterre.fr/ark:/67375/9sd-sc6kk28b-5","ul":"is","term":"is","pref":"iceland"}},{"idx":{"start":"174","end":"177"},"match":{"id":"http://data.loterre.fr/ark:/67375/9sd-pg5nzg4z-3","ul":"and","term":"and","pref":"andorra"}},{"idx":{"start":"178","end":"194"},"match":{"id":"http://data.loterre.fr/ark:/67375/9sd-lxlpg87f-3","ul":"washington, d.c.","term":"washington, d.c.","pref":"washington, d.c."}}]}]

POST {{host}}/v1/en/terms-matcher/P66?format=json-indoc
Content-Type: application/json
[
{"id":"18","value":"The Mem-Pro-Clinic test is a clinical test to assess difficulties in event- and time-based prospective thoughts. This result implies that activated long-term memory provides a representational basis for semantic verbal short-term signal."},
{"id":"27","value":"A new method to implant false autobiographical books: Blind implantation call blind implantation methods."},
{"id":"35","value":"A guy with hypermnesia (Pathology) is capable of storing idea in an extraordinarily efficient manner."}
]

HTTP 200
[{"id":"18","value":"the TERM||mem-pro-clinic test||http://data.loterre.fr/ark:/67375/p66-wg17xbg4-v is a clinical test to assess difficulties in event- and time-based TERM||prospective thought||http://data.loterre.fr/ark:/67375/p66-vlj0cqh4-g. this   implies that activated TERM||long-term memory||http://data.loterre.fr/ark:/67375/p66-j8fc45m1-6 provides a representational basis for semantic verbal short-term signal."},{"id":"27","value":"a new method to implant false autobiographical books: blind implantation call TERM||blind implantation method||http://data.loterre.fr/ark:/67375/p66-d6xl3pdr-m."},{"id":"35","value":"a guy with TERM||hypermnesia (pathology)||http://data.loterre.fr/ark:/67375/p66-fqxk8kbn-c is capable of storing idea in an extraordinarily efficient manner."}]


POST {{host}}/v1/en/terms-matcher/P66?format=xml-standoff
Content-Type: text/html; charset=UTF-8
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
{"id":"1","value":"Les pertes de mémoire subjective appelés aussi troubles mnésiques correspondent à la difficulté à mémoriser un fait actuel à retrouver un souvenir."},
{"id":"2","value":"Parfois les effets de stress post-encodage arrivent simmultanement à un stress post-traumatique."},
{"id":"3","value":"Les tests mem-pro-clinic sont de bons tests des lobes frontaux"}
]

HTTP 200
[{"id":"1","value":[{"idx":{"start":"3","end":"29"},"match":{"id":"http://data.loterre.fr/ark:/67375/p66-w1lp7kg3-6","ul":"perte de mémoire subjectif","term":"perte de mémoire subjective","pref":"plainte mnésique"}},{"idx":{"start":"44","end":"60"},"match":{"id":"http://data.loterre.fr/ark:/67375/p66-gnbk2l59-k","ul":"trouble mnésique","term":"trouble mnésique","pref":"trouble de la mémoire"}}]},{"id":"2","value":[{"idx":{"start":"11","end":"40"},"match":{"id":"http://data.loterre.fr/ark:/67375/p66-cl2m18zq-p","ul":"effet de stress post-encodage","term":"effet du stress post-encodage","pref":"effet du stress post-encodage"}},{"idx":{"start":"69","end":"75"},"match":{"id":"http://data.loterre.fr/ark:/67375/p66-jjv6gswp-1","ul":"stress","term":"stress","pref":"stress"}}]},{"id":"3","value":[{"idx":{"start":"47","end":"59"},"match":{"id":"http://data.loterre.fr/ark:/67375/p66-khrwns4w-q","ul":"lobe frontal","term":"lobe frontal","pref":"lobe frontal"}}]}]


POST {{host}}/v1/fr/terms-matcher/QX8?format=xml-standoff
Content-Type: text/html; charset=UTF-8
[{"id":"18","value":"Parfois nommé Algonkien (désuet), il couvre à lui seul près de la moitié du temps d’existence de la planète Terre, entre l’Archéen et le Phanérozoïque. Divisé en trois ères, il est marqué par plusieurs événements précis relativement bien connus des paléontologues et géologues mais dont la datation est approximative. Classiquement, cet éon finit au début du Cambrien, à partir du moment où les premiers fossiles d’animaux connus sous les noms de trilobites apparaissent. Dans la seconde moitié du XXe siècle des fossiles de trilobites ont été découverts dans des roches datant du Précambrien mais la fin du Protérozoïque est restée fixée au début du Cambrien."}]

HTTP 200
# Reponse de type format=xml-standoff ne fonctionne pas avec les test
[Asserts]
#<?xml version="1.0" encoding="UTF-8"?><result><text><tag id_start="15" idx_end="24" id="http://data.loterre.fr/ark:/67375/qx8-b5cthws7-j" text="algonkien" termeReconnu="algonkien" pref="algonkien" lang="en"/><tag id_start="27" idx_end="28" id="http://data.loterre.fr/ark:/67375/qx8-091kdctd-d" text="d" termeReconnu="d" pref="deutérium" lang="en"/><tag id_start="65" idx_end="66" id="http://data.loterre.fr/ark:/67375/qx8-s9qwdzlz-8" text="s" termeReconnu="s" pref="soufre" lang="en"/><tag id_start="89" idx_end="90" id="http://data.loterre.fr/ark:/67375/qx8-091kdctd-d" text="d" termeReconnu="d" pref="deutérium" lang="en"/><tag id_start="134" idx_end="141" id="http://data.loterre.fr/ark:/67375/qx8-5jg3c031-z" text="archéen" termeReconnu="archéen" pref="archéen" lang="en"/><tag id_start="148" idx_end="161" id="http://data.loterre.fr/ark:/67375/qx8-pbstp7gd-6" text="phanérozoïque" termeReconnu="phanérozoïque" pref="phanérozoïque" lang="en"/><tag id_start="304" idx_end="312" id="http://data.loterre.fr/ark:/67375/qx8-jpzf7zdv-2" text="datation" termeReconnu="datation" pref="datation" lang="en"/><tag id_start="365" idx_end="366" id="http://data.loterre.fr/ark:/67375/qx8-091kdctd-d" text="d" termeReconnu="d" pref="deutérium" lang="en"/><tag id_start="374" idx_end="382" id="http://data.loterre.fr/ark:/67375/qx8-zf6tq5x0-3" text="cambrien" termeReconnu="cambrien" pref="cambrien" lang="en"/><tag id_start="418" idx_end="425" id="http://data.loterre.fr/ark:/67375/qx8-625m7dxh-j" text="fossile" termeReconnu="fossile" pref="fossile" lang="en"/><tag id_start="426" idx_end="427" id="http://data.loterre.fr/ark:/67375/qx8-091kdctd-d" text="d" termeReconnu="d" pref="deutérium" lang="en"/><tag id_start="511" idx_end="513" id="http://data.loterre.fr/ark:/67375/qx8-k2wjnmr5-r" text="si" termeReconnu="si" pref="silicium" lang="en"/><tag id_start="521" idx_end="528" id="http://data.loterre.fr/ark:/67375/qx8-625m7dxh-j" text="fossile" termeReconnu="fossile" pref="fossile" lang="en"/><tag id_start="553" idx_end="554" id="http://data.loterre.fr/ark:/67375/qx8-091kdctd-d" text="d" termeReconnu="d" pref="deutérium" lang="en"/><tag id_start="571" idx_end="576" id="http://data.loterre.fr/ark:/67375/qx8-kfdbl3tr-s" text="roche" termeReconnu="roche" pref="roche" lang="en"/><tag id_start="586" idx_end="597" id="http://data.loterre.fr/ark:/67375/qx8-blpf1v6w-v" text="précambrien" termeReconnu="précambrien" pref="précambrien" lang="en"/><tag id_start="613" idx_end="626" id="http://data.loterre.fr/ark:/67375/qx8-6v9lhwz0-k" text="protérozoïque" termeReconnu="protérozoïque" pref="protérozoïque" lang="en"/><tag id_start="648" idx_end="649" id="http://data.loterre.fr/ark:/67375/qx8-091kdctd-d" text="d" termeReconnu="d" pref="deutérium" lang="en"/><tag id_start="657" idx_end="665" id="http://data.loterre.fr/ark:/67375/qx8-zf6tq5x0-3" text="cambrien" termeReconnu="cambrien" pref="cambrien" lang="en"/></text></result>