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
            "acronyme": "ESO",
            "nom_fr": "Observatoire européen austral",
            "nom_en": "European Southern Observatory",
            "domaine_scientifique": "Astronomie et astrophysique",
            "sources": "MESRE",
            "score_similarite": 100,
            "debut": 4,
            "fin": 33,
            "contexte": "The European Southern Observatory (ESO) operates several major astronomical facilities in Chile.\nESO collaborates with the Vera C. Ru"
        },
        {
            "alias_detecte": "Atacama Large Millimeter/submillimeter Array",
            "acronyme": "ESO/ALMA",
            "nom_fr": "Atacama Large Millimeter/Submillimiter Array",
            "nom_en": "",
            "domaine_scientifique": "Astronomie et astrophysique",
            "sources": "MESRE",
            "score_similarite": 97.7,
            "debut": 305,
            "fin": 349,
            "contexte": "y will provide unprecedented data about transient astronomical events.\nResearchers also rely on the Atacama Large Millimeter/submillimeter Array (ALMA) for radio astronomy.\nThe ALMA infrastructure is particularly useful for studying star format"
        },
        {
            "alias_detecte": "European Centre for Medium-Range Weather Forecasts",
            "acronyme": "CEPMMT",
            "nom_fr": "Centre Européen pour les Prévisions Météorologiques à Moyen Terme",
            "nom_en": "European Centre for Medium-Range Weather Forecasts",
            "domaine_scientifique": "Sciences du système Terre et de l'environnement",
            "sources": "MESRE",
            "score_similarite": 100,
            "debut": 469,
            "fin": 519,
            "contexte": "tronomy.\nThe ALMA infrastructure is particularly useful for studying star formation.\nIn Europe, the European Centre for Medium-Range Weather Forecasts (ECMWF) provides essential climate and weather data.\nECMWF datasets are widely used by research ins"
        },
        {
            "alias_detecte": "European Plate Observing System",
            "acronyme": "Résif-Epos",
            "nom_fr": "Réseau sismologique et géodésique français",
            "nom_en": "European Plate Observing System",
            "domaine_scientifique": "Sciences du système Terre et de l'environnement",
            "sources": "MESRE",
            "score_similarite": 100,
            "debut": 648,
            "fin": 679,
            "contexte": "limate and weather data.\nECMWF datasets are widely used by research institutions across France.\nThe European Plate Observing System (EPOS) supports multidisciplinary research on solid Earth sciences."
        }
    ]
}]