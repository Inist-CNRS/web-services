POST {{host}}/v1/tagger?indent=true
content-type: application/json
[
{"value": "Python is widely used in data science. Bob R. uses it ; he works for the CNRS"},
{"value": "Jean Dupont assiste àu festival de Cannes sur la côte d'Azur."}
]


HTTP 200
[{
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