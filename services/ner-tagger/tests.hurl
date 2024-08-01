POST {{host}}/v1/geoTagger/geoTagger?indent=true
content-type: application/json
[
  {
    "id": "1",
    "value": "The City of Paris is the centre and seat of government of the region and province of Île-de-France, or Paris Region, with an estimated population of 12,997,058 in 2020, or about 18 percent of the population of France, making it in 2020 the largest metropolitan area in Europe, and 14th largest in the world in 2015."
  },
  {
    "id": "2",
    "value": "The COVID-19 pandemic, also known as the coronavirus pandemic, is an ongoing global pandemic of coronavirus disease 2019 (COVID-19) caused by severe acute respiratory syndrome coronavirus2 (SARS-CoV-2). It was first identified in December 2019 in Wuhan, China. The World Health Organization declared the outbreak a Public Health Emergency of International Concern on 20 January 2020, and later a pandemic on 11 March 2020. As of 2 April 2021, more than 129 million cases have been confirmed, with more than 2.82 million deaths attributed to COVID-19, making it one of the deadliest pandemics in history."
  }
]

HTTP 200
[{
    "id": "1",
    "value": [
        "City of Paris",
        "Île-de-France",
        "Paris Region",
        "France",
        "Europe"
    ]
},
{
    "id": "2",
    "value": [
        "Wuhan",
        "China"
    ]
}]

POST {{host}}/v1/perseeBaipTagger/tagger?indent=true
content-type: application/json
[
  {
    "id": "1",
    "value": "Personnel de l'Ecole normale primaire de Barcelonnette. Personnel du Collège impérial de France et du collège communal de Confolens. Personnel de la Faculté des lettres de Dijon."
  },
  {
    "id": "2",
    "value": "Ecole normale supérieure. — M. Boulangier, agrégé des sciences physiques, professeur de physique au lycée impérial de Bar-le-Duc, ancien élève de l'école normale supérieure, est nommé préparateur de .chimie à ladite école, en remplacement de M. Debray."
  }
]


HTTP 200
[{
    "id": "1",
    "value": {
        "loc": [
            "Barcelonnette",
            "France",
            "Confolens",
            "Dijon"
        ],
        "org": [
            "Ecole normale primaire de Barcelonnette",
            "Collège impérial de France",
            "collège communal de Confolens",
            "Faculté des lettres de Dijon"
        ],
        "basicOrg": [
            "ecole",
            "collège",
            "collège",
            "faculté"
        ],
        "operation": []
    }
},
{
    "id": "2",
    "value": {
        "loc": [
            "Bar-le-Duc"
        ],
        "org": [
            "Ecole normale supérieure",
            "lycée impérial de Bar-le-Duc",
            "école normale supérieure",
            "école"
        ],
        "basicOrg": [
            "ecole",
            "lycée",
            "école",
            "école"
        ],
        "operation": []
    }
}]