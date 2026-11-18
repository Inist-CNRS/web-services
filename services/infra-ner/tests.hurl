POST {{host}}/v1/detect?indent=true
content-type: application/json
[
  {
    "value": "The European Southern Observatory (ESO) operates several major astronomical facilities in Chile.\nESO collaborates with the Vera C. Rubin Observatory on large-scale sky surveys.\nThe vera c. rubin observatory will provide unprecedented data about transient astronomical events.\nResearchers also rely on the Atacama Large Millimeter/submillimeter Array (ALMA) for radio astronomy.\nThe ALMA infrastructure is particularly useful for studying star formation.\nIn Europe, the European Centre for Medium-Range Weather Forecasts (ECMWF) provides essential climate and weather data.\nECMWF datasets are widely used by research institutions across France.\nThe European Plate Observing System (EPOS) supports multidisciplinary research on solid Earth sciences."
  }
]

HTTP 200
[{
    "value": [
        {
            "alias_detecte": "European Southern Observatory",
            "infrastructure_id": "bba68ea88de6",
            "acronyme": "ESO",
            "nom": "Observatoire européen austral",
            "nom_fr": "Observatoire européen austral",
            "nom_en": "European Southern Observatory",
            "domaine_scientifique": "Astronomie et astrophysique",
            "sources": "MESRE | OPIDoR",
            "score_similarite": 100,
            "debut": 4,
            "fin": 33,
            "contexte": "The European Southern Observatory (ESO) operates several major astronomical facilities in Chile.\nESO collaborates with the Vera C. Ru"
        },
        {
            "alias_detecte": "Atacama Large Millimeter/submillimeter Array",
            "infrastructure_id": "2bd1be4609b7",
            "acronyme": "ESO/ALMA",
            "nom": "Atacama Large Millimeter/Submillimiter Array",
            "nom_fr": "Atacama Large Millimeter/Submillimiter Array",
            "nom_en": "",
            "domaine_scientifique": "Astronomie et astrophysique",
            "sources": "MESRE | OPIDoR",
            "score_similarite": 97.7,
            "debut": 305,
            "fin": 349,
            "contexte": "y will provide unprecedented data about transient astronomical events.\nResearchers also rely on the Atacama Large Millimeter/submillimeter Array (ALMA) for radio astronomy.\nThe ALMA infrastructure is particularly useful for studying star format"
        },
        {
            "alias_detecte": "European Centre for Medium-Range Weather Forecasts",
            "infrastructure_id": "8bb1a69d8db4",
            "acronyme": "CEPMMT",
            "nom": "Centre Européen pour les Prévisions Météorologiques à Moyen Terme",
            "nom_fr": "Centre Européen pour les Prévisions Météorologiques à Moyen Terme",
            "nom_en": "European Centre for Medium-Range Weather Forecasts",
            "domaine_scientifique": "Sciences du système Terre et de l'environnement",
            "sources": "MESRE | OPIDoR",
            "score_similarite": 100,
            "debut": 469,
            "fin": 519,
            "contexte": "tronomy.\nThe ALMA infrastructure is particularly useful for studying star formation.\nIn Europe, the European Centre for Medium-Range Weather Forecasts (ECMWF) provides essential climate and weather data.\nECMWF datasets are widely used by research ins"
        },
        {
            "alias_detecte": "European Plate Observing System",
            "infrastructure_id": "573e3602d8e8",
            "acronyme": "Epos-France",
            "nom": "Système Européen d'observation des plaques tectoniques - France",
            "nom_fr": "Système Européen d'observation des plaques tectoniques - France",
            "nom_en": "European Plate Observing System France",
            "domaine_scientifique": "Sciences du système Terre et de l'environnement",
            "sources": "MESRE | OPIDoR",
            "score_similarite": 100,
            "debut": 648,
            "fin": 679,
            "contexte": "limate and weather data.\nECMWF datasets are widely used by research institutions across France.\nThe European Plate Observing System (EPOS) supports multidisciplinary research on solid Earth sciences."
        }
    ]
}]

POST {{host}}/v1/detect?indent=true
content-type: application/json
[
  {
    "value": "Le projet est financé par le CNRS. Il est probable que les données soient publiées et que l'équipe est motivée."
  },
  {
    "value": "Les principes FAIR guident le dépôt des données, et ESO ou ILL seuls ne sont pas retenus."
  },
  {
    "value": "Cette page appartient à la Catégorie:IR et à la Catégorie:Projet."
  }
]

HTTP 200
[{
    "value": []
},
{
    "value": []
},
{
    "value": []
}]

POST {{host}}/v1/detect?indent=true
content-type: application/json
[
  {
    "value": "Mesures faites au cern en 2020."
  },
  {
    "value": "Mesures faites au CERN en 2020."
  },
  {
    "value": "Data from the KM3NET telescope."
  },
  {
    "value": "Data from the KM3NeT telescope."
  },
  {
    "value": "Data from the km3net telescope."
  },
  {
    "value": "Voir APOLLON pour les détails."
  },
  {
    "value": "Voir Apollon pour les détails."
  },
  {
    "value": "Le REGEF est un réseau."
  }
]

HTTP 200
[{
    "value": []
},
{
    "value": [
        {
            "alias_detecte": "CERN",
            "infrastructure_id": "01d0e0ffd3e6",
            "acronyme": "CERN",
            "nom": "Organisation Européenne pour la Recherche Nucléaire",
            "nom_fr": "Organisation Européenne pour la Recherche Nucléaire",
            "nom_en": "European Organization for Nuclear Research",
            "domaine_scientifique": "Physique nucléaire et des hautes énergies",
            "sources": "MESRE | OPIDoR",
            "score_similarite": 100,
            "debut": 18,
            "fin": 22,
            "contexte": "Mesures faites au CERN en 2020."
        }
    ]
},
{
    "value": [
        {
            "alias_detecte": "KM3NET",
            "infrastructure_id": "fd00b130c921",
            "acronyme": "KM3NeT",
            "nom": "Kilometre Cube Neutrino Telescope",
            "nom_fr": "Kilometre Cube Neutrino Telescope",
            "nom_en": "",
            "domaine_scientifique": "Physique nucléaire et des hautes énergies",
            "sources": "MESRE | OPIDoR",
            "score_similarite": 100,
            "debut": 14,
            "fin": 20,
            "contexte": "Data from the KM3NET telescope."
        }
    ]
},
{
    "value": [
        {
            "alias_detecte": "KM3NeT",
            "infrastructure_id": "fd00b130c921",
            "acronyme": "KM3NeT",
            "nom": "Kilometre Cube Neutrino Telescope",
            "nom_fr": "Kilometre Cube Neutrino Telescope",
            "nom_en": "",
            "domaine_scientifique": "Physique nucléaire et des hautes énergies",
            "sources": "MESRE | OPIDoR",
            "score_similarite": 100,
            "debut": 14,
            "fin": 20,
            "contexte": "Data from the KM3NeT telescope."
        }
    ]
},
{
    "value": []
},
{
    "value": []
},
{
    "value": [
        {
            "alias_detecte": "Apollon",
            "infrastructure_id": "2346bd49f348",
            "acronyme": "Apollon",
            "nom": "Infrastructure de Recherche Apollon",
            "nom_fr": "Infrastructure de Recherche Apollon",
            "nom_en": "",
            "domaine_scientifique": "Sciences de la matière et ingénierie",
            "sources": "MESRE | OPIDoR",
            "score_similarite": 100,
            "debut": 5,
            "fin": 12,
            "contexte": "Voir Apollon pour les détails."
        }
    ]
},
{
    "value": [
        {
            "alias_detecte": "REGEF",
            "infrastructure_id": "34ed7e93699a",
            "acronyme": "RéGEF",
            "nom": "Réseau Géochimique et Expérimental Français",
            "nom_fr": "Réseau Géochimique et Expérimental Français",
            "nom_en": "",
            "domaine_scientifique": "Sciences du système Terre et de l'environnement",
            "sources": "MESRE | OPIDoR",
            "score_similarite": 100,
            "debut": 3,
            "fin": 8,
            "contexte": "Le REGEF est un réseau."
        }
    ]
}]