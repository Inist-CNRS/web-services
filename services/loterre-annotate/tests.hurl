# WARNING: This file should have CRLF line endings. It is an exception.
#          See .gitattributes
# @host=http://localhost:31976
# @host=https://loterre-annotate.services.istex.fr
#
# Chaque test vérifie la STRUCTURE de la réponse (types et présence des champs),
# pas les valeurs exactes — ce qui le rend stable même si le vocabulaire évolue.
#
# [Asserts] hurl :
#   jsonpath "$[0].id" == "1"                    → le champ id est renvoyé inchangé
#   jsonpath "$[0].value" isCollection           → value est un tableau (au moins un match)
#   jsonpath "$[0].value[0].idx.start" isInteger → offset de début du terme (entier)
#   jsonpath "$[0].value[0].idx.end"   isInteger → offset de fin du terme (entier)
#   jsonpath "$[0].value[0].match.id"  isString  → URI du concept Loterre (chaîne)
#   jsonpath "$[0].value[0].match.ul"  isString  → forme préférentielle du concept (chaîne)
#   jsonpath "$[0].value[0].match.term" isString → texte exact trouvé dans le document (chaîne)
#   jsonpath "$" count == N                      → le service retourne exactement N documents
#
# NOTE: format de sortie actuel du service Docker (ancien format nested idx/match).
# Après "make build-local", migrer vers le format plat : start/end/uri/pref/found/score.

# ── 9SD EN ────────────────────────────────────────────────────────────────────
POST {{host}}/v1/en/loterre-annotate/annotate?loterreID=9SD
content-type: application/json
[
{"id":"1","value":"The United States of America (USA), also known as the United States (U.S.) or America, is a country primarily located in North America. It is a federal republic of 50 states and Washington, D.C. as its federal capital district."}
]
HTTP 200
[Asserts]
jsonpath "$[0].id" == "1"
jsonpath "$[0].value" isCollection
jsonpath "$[0].value[0].idx.start" isInteger
jsonpath "$[0].value[0].idx.end" isInteger
jsonpath "$[0].value[0].match.id" isString
jsonpath "$[0].value[0].match.ul" isString
jsonpath "$[0].value[0].match.term" isString

# ── P66 FR ────────────────────────────────────────────────────────────────────
POST {{host}}/v1/fr/loterre-annotate/annotate?loterreID=P66
content-type: application/json
[
{"id":"1","value":"Les pertes de mémoire subjective appelés aussi troubles mnésiques correspondent à la difficulté à mémoriser un fait actuel à retrouver un souvenir."}
]
HTTP 200
[Asserts]
jsonpath "$[0].id" == "1"
jsonpath "$[0].value" isCollection
jsonpath "$[0].value[0].idx.start" isInteger
jsonpath "$[0].value[0].match.id" isString
jsonpath "$[0].value[0].match.ul" isString

# ── P66 EN — plusieurs documents ──────────────────────────────────────────────
POST {{host}}/v1/en/loterre-annotate/annotate?loterreID=P66
content-type: application/json
[
{"id":"18","value":"The Mem-Pro-Clinic test is a clinical test to assess difficulties in event- and time-based prospective thoughts. This result implies that activated long-term memory provides a representational basis for semantic verbal short-term signal."},
{"id":"27","value":"A new method to implant false autobiographical books: Blind implantation call blind implantation methods."},
{"id":"35","value":"A guy with hypermnesia (Pathology) is capable of storing idea in an extraordinarily efficient manner."}
]
HTTP 200
[Asserts]
jsonpath "$" count == 3
jsonpath "$[0].id" == "18"
jsonpath "$[0].value" isCollection
jsonpath "$[1].id" == "27"
jsonpath "$[1].value" isCollection
jsonpath "$[2].id" == "35"
jsonpath "$[2].value" isCollection

# ── QX8 EN ────────────────────────────────────────────────────────────────────
POST {{host}}/v1/en/loterre-annotate/annotate?loterreID=QX8
content-type: application/json
[
{"id":"1","value":"Sustainable agriculture is farming in sustainable ways meeting society's present food and textile needs, without compromising the ability for current or future generations to meet their needs. It can be based on an understanding of ecosystem services. There are many methods to increase the sustainability of agriculture."}
]
HTTP 200
[Asserts]
jsonpath "$[0].id" == "1"
jsonpath "$[0].value" isCollection

# ── 9SD FR ────────────────────────────────────────────────────────────────────
POST {{host}}/v1/fr/loterre-annotate/annotate?loterreID=9SD
content-type: application/json
[
{"id":"1","value":"La géographie mondiale couvre une grande diversité de territoires. L'Afrique australe regroupe plusieurs États aux économies en développement. L'Amérique du Sud est traversée par la cordillère des Andes. La mer Méditerranée baigne plusieurs pays d'Europe du Sud."}
]
HTTP 200
[Asserts]
jsonpath "$[0].id" == "1"
jsonpath "$[0].value" isCollection
jsonpath "$[0].value[0].idx.start" isInteger
jsonpath "$[0].value[0].idx.end" isInteger
jsonpath "$[0].value[0].match.id" isString
jsonpath "$[0].value[0].match.ul" isString
jsonpath "$[0].value[0].match.term" isString

# ── BVM FR ────────────────────────────────────────────────────────────────────
POST {{host}}/v1/fr/loterre-annotate/annotate?loterreID=BVM
content-type: application/json
[
{"id":"1","value":"La France métropolitaine regroupe 101 départements et régions d'outre-mer. La France d'outre-mer comprend des territoires disséminés sur tous les océans. Paris constitue la métropole la plus peuplée de France."}
]
HTTP 200
[Asserts]
jsonpath "$[0].id" == "1"
jsonpath "$[0].value" isCollection
jsonpath "$[0].value[0].match.id" isString

# ── QX8 FR ────────────────────────────────────────────────────────────────────
POST {{host}}/v1/fr/loterre-annotate/annotate?loterreID=QX8
content-type: application/json
[
{"id":"1","value":"Les géosciences étudient l'histoire et la structure interne de la Terre. Les structures géomorphologiques témoignent de millions d'années d'érosion. Les paramètres géographiques déterminent la distribution des biomes."}
]
HTTP 200
[Asserts]
jsonpath "$[0].id" == "1"
jsonpath "$[0].value" isCollection
jsonpath "$[0].value[0].match.id" isString

# ── P66 FR — plusieurs documents ──────────────────────────────────────────────
POST {{host}}/v1/fr/loterre-annotate/annotate?loterreID=P66
content-type: application/json
[
{"id":"10","value":"La mémoire à long terme permet de conserver des informations sur de longues périodes, tandis que la mémoire à court terme assure le maintien temporaire des données en cours de traitement."},
{"id":"11","value":"Les interférences proactives perturbent les souvenirs récemment encodés. La consolidation de la mémoire survient principalement pendant le sommeil."}
]
HTTP 200
[Asserts]
jsonpath "$" count == 2
jsonpath "$[0].id" == "10"
jsonpath "$[0].value" isCollection
jsonpath "$[1].id" == "11"
jsonpath "$[1].value" isCollection
