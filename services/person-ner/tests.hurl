POST {{host}}/v1/tagger?indent=true
content-type: application/json
[
  {
    "id": "1",
    "value": "En avril 2024, un sommet technologique révolutionnaire s'est tenu dans la Silicon Valley. L'orateur principal, David Johnson, a présenté un camion électrique appelé CyberHauler. Le sommet, qui a duré trois jours, a mis l'accent sur les avancées en matière d'IA et d'énergie verte. Des représentants de l'Union européenne étaient présents pour discuter des nouvelles lois environnementales visant à réduire les émissions de carbone de 20 % au cours de la prochaine décennie. L'événement s'est achevé par un dîner de gala au Golden Gate Bridge, avec une vue spectaculaire sur l'océan Pacifique."
  },
  {
    "id": "2",
    "value": "In April 2024, a groundbreaking technology summit was held at the Silicon Valley. The keynote speaker, David Johnson, introduced an electric truck named CyberHauler. The summit, which lasted three days, highlighted advances in AI and green energy. Representatives from the European Union were present to discuss new environmental laws aimed at reducing carbon emissions by 20% over the next decade. The event concluded with a gala dinner at the Golden Gate Bridge, with a spectacular view of the Pacific Ocean."
  }
]

HTTP 200
[{
    "id": "1",
    "value": {
        "PER": [
            "David Johnson"
        ],
        "LOC": [
            "Silicon Valley",
            "Golden Gate Bridge",
            "océan Pacifique"
        ],
        "ORG": [
            "Union européenne"
        ]
    }
},
{
    "id": "2",
    "value": {
        "PER": [
            "David Johnson"
        ],
        "LOC": [
            "Silicon Valley",
            "Golden Gate Bridge",
            "Pacific Ocean"
        ],
        "ORG": [
            "European Union"
        ]
    }
}]

POST {{host}}/v1/tagger-en?indent=true
content-type: application/json
[
  {
    "id": 1,
    "value": "On September 15th, 2023, the renowned artist Sarah Blake unveiled Whispers of the Wind, at a museum in New York City. The event attracted people from all over the world, including the famous author Emily Green and several political figures from the United Nations. The museum, located on Fifth Avenue, is known for its extensive collection of European paintings. During the unveiling, a new highway connecting the city to Washington, D.C., was also announced, funded by a grant of $5 million from the federal government. This new project, expected to be completed by 2025, promises to reduce travel time by 30%. Sarah's masterpiece, inspired by the serene landscapes of the Rocky Mountains, is expected to be a major attraction, drawing art enthusiasts and tourists alike."
  },
  {
    "id": 2,
    "value":"In April 2024, a groundbreaking technology summit was held at the Silicon Valley. The keynote speaker, David Johnson, introduced an electric truck named CyberHauler. The summit, which lasted three days, highlighted advances in AI and green energy. Representatives from the European Union were present to discuss new environmental laws aimed at reducing carbon emissions by 20% over the next decade. The event concluded with a gala dinner at the Golden Gate Bridge, with a spectacular view of the Pacific Ocean."
  }
]


HTTP 200
[{
    "id": 1,
    "value": {
        "PER": [
            "Sarah Blake",
            "Emily Green",
            "Sarah"
        ],
        "LOC": [
            "New York City",
            "Fifth Avenue",
            "Washington",
            "D.C.",
            "Rocky Mountains"
        ],
        "ORG": [
            "United Nations"
        ]
    }
},
{
    "id": 2,
    "value": {
        "PER": [
            "David Johnson"
        ],
        "LOC": [
            "Silicon Valley",
            "Golden Gate Bridge",
            "Pacific Ocean"
        ],
        "ORG": [
            "European Union"
        ]
    }
}]