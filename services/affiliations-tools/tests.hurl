POST {{host}}/v1/expand?indent=true
content-type: application/json
[
  { "value": "Baran, N (reprint author), Univ Zagreb, Dept Phys, Bijenieka Cesta 32, Zagreb 10000, Croatia."},
  { "value": "Harikane, Y (reprint author), Univ Tokyo, Inst Cosm Ray Res, 5-1-5 Kashiwanoha, Kashiwa, Chiba 2778582, Japan.; Harikane, Y (reprint author), Univ Tokyo, Grad Sch Sci, Dept Phys, Bunkyo Ku, 7-3-1 Hongo, Tokyo 1130033, Japan."},
  { "value": "Davidzon, I (reprint author), Aix Marseille Univ, LAM, CNRS, UMR 7326, F-13388 Marseille, France.; Davidzon, I (reprint author), INAF Osservatorio Astron Bologna, Via Ranzani 1, I-40127 Bologna, Italy."},
  { "value": "Zolotukhin, I (reprint author), IRAP, CNRS, 9 Ave Colonel Roche,BP 44346, F-31028 Toulouse 4, France.; Zolotukhin, I (reprint author), Moscow MV Lomonosov State Univ, Sternberg Astron Inst, Univ Skij Pr 13, Moscow 119992, Russia."},
  { "value": "Cooke, J (reprint author), Swinburne Univ Technol, Ctr Astrophys & Supercomp, Hawthorn, Vic 3122, Australia."},
  { "value": "van Uitert, E (reprint author), Argelander Inst Astron, Hugel 71, D-53121 Bonn, Germany."},
  { "value": "Harnois-Deraps, J (reprint author), Univ British Columbia, Dept Phys & Astron, Vancouver, BC V6T 1Z1, Canada."},
  { "value": "Ford, J (reprint author), Univ British Columbia, Dept Phys & Astron, 6224 Agr Rd, Vancouver, BC V6T 1Z1, Canada."},
  { "value": "Laigle, C (reprint author), Univ Paris 06, Sorbonne Univ, 98b Bd Arago, F-75014 Paris, France.; Laigle, C (reprint author), CNRS, UMR 7095, IAP, 98b Bd Arago, F-75014 Paris, France."}
]



POST {{host}}/v1/rnsr/json?indent=true
content-type: application/json
[
  { "id":1, "value": { "year": "2021", "address": "CNRS UMR AMAP MONTPELLIER FRA" } },
  { "id":2, "value": { "year": "2021", "address": "IRD UMR AMAP MONTPELLIER FRA" } },
  { "id":3, "value": { "year": "2021", "address": "University of Bordeaux, IMS, CNRS UMR5218, Talence, F-33405, France" } },
  { "id":4, "value": { "year": "2021", "address": "CENBG, CNRS/IN2P3, Chemin du Solarium B. P. 120, Gradignan, F-33175, France" } },
  { "id":5, "value": { "year": "2021", "address": "Nulle part" } },
  { "id":6, "value": { "address": "Intemporel" } },
  { "id":7, "value": { "address": "Inist-CNRS, UPS76, 2 rue Jean Zay, Vandoeuvre-lès-Nancy" } }
]

HTTP 200
[{
    "id": 1,
    "value": [
        "200317641S"
    ]
},
{
    "id": 2,
    "value": [
        "200317641S"
    ]
},
{
    "id": 3,
    "value": [
        "200711887V"
    ]
},
{
    "id": 4,
    "value": []
},
{
    "id": 5,
    "value": []
},
{
    "id": 6,
    "value": []
},
{
    "id": 7,
    "value": [
        "198822446E"
    ]
}]

POST {{host}}/v1/rnsr/info?indent=true
content-type: application/json
[
  { "id":1, "value": { "year": "2021", "address": "CNRS UMR AMAP MONTPELLIER FRA" } },
  { "id":3, "value": { "year": "2021", "address": "University of Bordeaux, IMS, CNRS UMR5218, Talence, F-33405, France" } },
  { "id":4, "value": { "year": "2021", "address": "CENBG, CNRS/IN2P3, Chemin du Solarium B. P. 120, Gradignan, F-33175, France" } },
  { "id":5, "value": { "year": "2021", "address": "Nulle part" } },
  { "id":6, "value": { "address": "Intemporel" } },
  { "id":7, "value": { "address": "Inist-CNRS, UPS76, 2 rue Jean Zay, Vandoeuvre-lès-Nancy" } }
]

HTTP 200
[{
    "id": 1,
    "value": [
        {
            "num_nat_struct": "200317641S",
            "intitule": "botAnique et Modélisation de l'Architecture des Plantes et des végétations",
            "sigle": "AMAP",
            "ville_postale": "MONTPELLIER CEDEX 5",
            "code_postal": "34398",
            "etabAssoc": [
                {
                    "etab": {
                        "sigle": "CNRS",
                        "libelle": "Centre national de la recherche scientifique",
                        "sigleAppauvri": "cnrs",
                        "libelleAppauvri": "centre national de la recherche scientifique"
                    },
                    "label": "UMR",
                    "labelAppauvri": "umr",
                    "numero": "5120"
                },
                {
                    "etab": {
                        "sigle": "IRD",
                        "libelle": "Institut de recherche pour le developpement",
                        "sigleAppauvri": "ird",
                        "libelleAppauvri": "institut de recherche pour le developpement"
                    },
                    "label": "UMR",
                    "labelAppauvri": "umr",
                    "numero": "5120"
                },
                {
                    "etab": {
                        "sigle": "CIRAD",
                        "libelle": "Centre de Cooperation Internationale en Recherche Agronomique pour le Developpement",
                        "sigleAppauvri": "cirad",
                        "libelleAppauvri": "centre de cooperation internationale en recherche agronomique pour le developpement"
                    },
                    "label": "UMR",
                    "labelAppauvri": "umr",
                    "numero": "51"
                },
                {
                    "etab": {
                        "sigle": "MONTPELLIER",
                        "libelle": "Université de Montpellier (EPE)",
                        "sigleAppauvri": "montpellier",
                        "libelleAppauvri": "universite de montpellier (epe)"
                    },
                    "label": "UMR",
                    "labelAppauvri": "umr",
                    "numero": "5120"
                },
                {
                    "etab": {
                        "sigle": "INRAE",
                        "libelle": "Institut national de recherche pour l'agriculture, l'alimentation et l'environnement",
                        "sigleAppauvri": "inrae",
                        "libelleAppauvri": "institut national de recherche pour l agriculture, l alimentation et l environnement"
                    },
                    "label": "UMR",
                    "labelAppauvri": "umr",
                    "numero": "0931"
                }
            ],
            "intituleAppauvri": "botanique et modelisation de l architecture des plantes et des vegetations",
            "sigleAppauvri": "amap",
            "ville_postale_appauvrie": "montpellier cedex 5",
            "annee_creation": "2001",
            "an_fermeture": ""
        }
    ]
},
{
    "id": 3,
    "value": [
        {
            "num_nat_struct": "200711887V",
            "intitule": "LABORATOIRE D'INTEGRATION DU MATERIAU AU SYSTEME",
            "sigle": "IMS",
            "ville_postale": "TALENCE CEDEX",
            "code_postal": "33405",
            "etabAssoc": [
                {
                    "etab": {
                        "sigle": "CNRS",
                        "libelle": "Centre national de la recherche scientifique",
                        "sigleAppauvri": "cnrs",
                        "libelleAppauvri": "centre national de la recherche scientifique"
                    },
                    "label": "UMR",
                    "labelAppauvri": "umr",
                    "numero": "5218"
                },
                {
                    "etab": {
                        "sigle": "BORDEAUX",
                        "libelle": "Université de Bordeaux",
                        "sigleAppauvri": "bordeaux",
                        "libelleAppauvri": "universite de bordeaux"
                    },
                    "label": "UMR",
                    "labelAppauvri": "umr",
                    "numero": "5218"
                },
                {
                    "etab": {
                        "sigle": "Bordeaux INP",
                        "libelle": "Institut Polytechnique Bordeaux",
                        "sigleAppauvri": "bordeaux inp",
                        "libelleAppauvri": "institut polytechnique bordeaux"
                    },
                    "label": "UMR",
                    "labelAppauvri": "umr",
                    "numero": "5218"
                }
            ],
            "intituleAppauvri": "laboratoire d integration du materiau au systeme",
            "sigleAppauvri": "ims",
            "ville_postale_appauvrie": "talence cedex",
            "annee_creation": "2006",
            "an_fermeture": ""
        }
    ]
},
{
    "id": 4,
    "value": []
},
{
    "id": 5,
    "value": []
},
{
    "id": 6,
    "value": []
},
{
    "id": 7,
    "value": [
        {
            "num_nat_struct": "198822446E",
            "intitule": "Institut de l'information scientifique et technique",
            "sigle": "INIST",
            "ville_postale": "VANDOEUVRE LES NANCY CEDEX",
            "code_postal": "54519",
            "etabAssoc": [
                {
                    "etab": {
                        "sigle": "CNRS",
                        "libelle": "Centre national de la recherche scientifique",
                        "sigleAppauvri": "cnrs",
                        "libelleAppauvri": "centre national de la recherche scientifique"
                    },
                    "label": "UAR",
                    "labelAppauvri": "uar",
                    "numero": "76"
                }
            ],
            "intituleAppauvri": "institut de l information scientifique et technique",
            "sigleAppauvri": "inist",
            "ville_postale_appauvrie": "vandoeuvre les nancy cedex",
            "annee_creation": "1988",
            "an_fermeture": ""
        }
    ]
}]

POST {{host}}/v1/rnsr/csv
content-type: text/csv
```
Année,Adresse
2015,CNRS UMR AMAP MONTPELLIER FRA
2015,IRD UMR AMAP MONTPELLIER FRA
2015,"University of Bordeaux, IMS, CNRS UMR5218, Talence, F-33405, France"
2015,"CENBG, CNRS/IN2P3, Chemin du Solarium B. P. 120, Gradignan, F-33175, France"
```

HTTP 200
```
Année;Adresse;RNSR
2015;CNRS UMR AMAP MONTPELLIER FRA;200317641S
2015;IRD UMR AMAP MONTPELLIER FRA;200317641S
2015;University of Bordeaux, IMS, CNRS UMR5218, Talence, F-33405, France;200711887V
2015;CENBG, CNRS/IN2P3, Chemin du Solarium B. P. 120, Gradignan, F-33175, France;
```



POST {{host}}/v1/rnsr/conditor
content-type: application/json
[{
  "xPublicationDate": ["2012-01-01"],
  "authors": [{
    "affiliations": [{
      "address": "GDR 2989 Université Versailles Saint-Quentin-en-Yvelines, 63009"
    }]
  }]
}]

HTTP 200
[{
    "xPublicationDate": [
        "2012-01-01"
    ],
    "authors": [
        {
            "affiliations": [
                {
                    "address": "GDR 2989 Université Versailles Saint-Quentin-en-Yvelines, 63009",
                    "conditorRnsr": [
                        "200619958X"
                    ]
                }
            ]
        }
    ]
}]

POST {{host}}/v1/addresses/parse?indent=true
content-type: application/json
[
  {
    "value": "Barboncino 781 Franklin Ave, Crown Heights, Brooklyn, NY 11238"
  }
]