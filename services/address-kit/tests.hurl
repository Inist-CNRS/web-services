POST {{host}}/v1/cnrsunit/cnrsunit?indent=true
content-type: application/json
[
{"id":1, "value":"université sciences et technologies bordeaux 1 institut national de physique nucléaire et de physique des particules du cnrs in2p3 umr5797"},
{"id":2,"value":"uar76 / ups76 centre national de la recherche scientifique cnrs institut de l'information scientifique et technique inist"},
{"id":3,"value":"centre de recherches sur la géologie des matières premières minérales et énergétiques cregu université de lorraine ul umr7359 centre national de la recherche scientifique"},
{"id":4,"value":"umr_d161 institut de recherche pour le développement ird um34 aix marseille université amu umr7330 collège de france cdf institution institut national des sciences de l'univers insu cnrs umr7330 centre national de la recherche scientifique cnrs umr1410 institut national de recherche pour l'agriculture l'alimentation et l'environnement inrae centre européen de recherche et d'enseignement des géosciences de l'environnement cerege europôle méditerranéen de l'arbois"}
]

HTTP 200
[{
    "id": 1,
    "value": {
        "name": "Laboratoire de Physique des 2 infinis - Bordeaux",
        "label": "LP2I - Bordeaux",
        "rnsr": "199512079F",
        "inst": "Institut d'écologie et environnement"
    }
},
{
    "id": 2,
    "value": {
        "name": "Institut de l'information scientifique et technique",
        "label": "INIST",
        "rnsr": "198822446E",
        "inst": "Direction générale déléguée à la science"
    }
},
{
    "id": 3,
    "value": {
        "name": "GeoRessources",
        "label": "GEORESSOURCES",
        "rnsr": "201320575M",
        "inst": "Institut des sciences de l'ingénierie et des systèmes"
    }
},
{
    "id": 4,
    "value": {
        "name": "Centre européen de recherche et d'enseignement de géosciences de l'environnement",
        "label": "CEREGE",
        "rnsr": "201220322S",
        "inst": "Institut des sciences humaines et sociales"
    }
}]

POST {{host}}/v1/affiliationcountry/affilcountry?indent=true
content-type: application/json
[
{"id":1,"value":"université sciences et technologies bordeaux 1 institut national de physique nucléaire et de physique des particules du cnrs in2p3 UMR5797"},
{"id":2,"value":"uar76 / ups76 centre national de la recherche scientifique cnrs institut de l'information scientifique et technique inist"},
{"id":3,"value":"centre de recherches sur la géologie des matières premières minérales et énergétiques cregu université de lorraine ul umr7359 centre national de la recherche scientifique"},
{"id":4,"value":"auf der morgenstelle 8, 72076 tuebingen"},
{"id":5,"value":"z.i. de kermelin,16, rue ampère,  56017 Vannes"},
{"id":6,"value":"campus de santa apolónia, 5300-253 bragança"},
{"id":7,"value":"campus romanus de maron"}  ,
{"id":8,"value":"Inist-CNRS, vandoeuvre les Nancy, France"}
]

HTTP 200
[{
    "id": 1,
    "value": [
        "France",
        "FRA"
    ]
},
{
    "id": 2,
    "value": [
        "France",
        "FRA"
    ]
},
{
    "id": 3,
    "value": [
        "France",
        "FRA"
    ]
},
{
    "id": 4,
    "value": [
        "Germany",
        "DEU"
    ]
},
{
    "id": 5,
    "value": [
        "France",
        "FRA"
    ]
},
{
    "id": 6,
    "value": [
        "Portugal",
        "PRT"
    ]
},
{
    "id": 7,
    "value": [
        "Unknown",
        "N/A"
    ]
},
{
    "id": 8,
    "value": [
        "France",
        "FRA"
    ]
}]