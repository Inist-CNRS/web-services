POST {{host}}/v1/tagger?indent=true
content-type: application/json
[
  {
    "id": "1",
    "value": "Python is widely used in data science. Bob R. uses it ; he works for the CNRS"
  },
  {
    "id": "2",
    "value": "Jean Dupont assiste àu festival de Cannes sur la côte d'Azur."
  }
]

HTTP 200
[{
    "id": "1",
    "value": {
        "PER": [
            "Bob R."
        ],
        "LOC": [],
        "ORG": [
            "CNRS"
        ],
        "MISC": [
            "Python"
        ]
    }
},
{
    "id": "2",
    "value": {
        "PER": [
            "Jean Dupont"
        ],
        "LOC": [
            "côte d'Azur"
        ],
        "ORG": [],
        "MISC": [
            "festival de Cannes"
        ]
    }
}]

POST {{host}}/v1/tagger-en?indent=true
content-type: application/json
[
  {
    "id": 1,
    "value": "On September 15th, 2023, the renowned artist Sarah Blake unveiled Whispers of the Wind, at the Metropolitan Museum of Art in New York City. The event attracted people from all over the world, including the famous author Emily Green and several political figures from the United Nations. The museum, located on Fifth Avenue, is known for its extensive collection of European paintings. During the unveiling, a new highway connecting the city to Washington, D.C., was also announced, funded by a grant of $5 million from the federal government. This new project, expected to be completed by 2025, promises to reduce travel time by 30%. Sarah's masterpiece, inspired by the serene landscapes of the Rocky Mountains, is expected to be a major attraction, drawing art enthusiasts and tourists alike."
  },
  {
    "id": 2,
    "value":"In April 2024, a groundbreaking technology summit was held at the Silicon Valley headquarters of FutureTech, attracting tech innovators and CEOs from major companies like OmniCorp and QuantumSoft. The keynote speaker, David Johnson, introduced Electra's latest product, an electric truck named CyberHauler. The summit, which lasted three days, highlighted advances in AI and green energy. Representatives from the European Union were present to discuss new environmental laws aimed at reducing carbon emissions by 20% over the next decade. The summit's discussions, conducted primarily in English, also touched on the upcoming Mars mission scheduled for 2030, which aims to establish the first human colony on the Red Planet. The event concluded with a gala dinner at the Golden Gate Bridge, with a spectacular view of the Pacific Ocean."
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
            "Washington",
            "D.C.",
            "the Rocky Mountains"
        ],
        "ORG": [
            "the Metropolitan Museum of Art",
            "the United Nations"
        ],
        "DATE": [
            "September 15th,",
            "2023",
            "2025"
        ],
        "EVENT": [],
        "FAC": [
            "Fifth Avenue"
        ],
        "LANGUAGE": [],
        "LAW": [],
        "MONEY": [
            "$5 million"
        ],
        "NORP": [
            "European"
        ],
        "PRODUCT": [],
        "QUANTITY": [
            "30%"
        ],
        "WORK_OF_ART": []
    }
},
{
    "id": 2,
    "value": {
        "PER": [
            "David Johnson",
            "CyberHauler"
        ],
        "LOC": [
            "the Silicon Valley",
            "Mars",
            "the Red Planet",
            "the Pacific Ocean"
        ],
        "ORG": [
            "FutureTech",
            "OmniCorp",
            "QuantumSoft",
            "Electra",
            "AI",
            "the European Union"
        ],
        "DATE": [
            "April 2024",
            "three days",
            "the next decade",
            "2030"
        ],
        "EVENT": [],
        "FAC": [
            "the Golden Gate Bridge"
        ],
        "LANGUAGE": [
            "English"
        ],
        "LAW": [],
        "MONEY": [],
        "NORP": [],
        "PRODUCT": [],
        "QUANTITY": [
            "20%"
        ],
        "WORK_OF_ART": []
    }
}]