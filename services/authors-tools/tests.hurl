POST {{host}}/v1/orcid-disambiguation/orcidDisambiguation?indent=true
content-type: application/json
[
  {"id": 1,"value": [{"firstName": "Rubén","lastName": "Vázquez-Cárdenas","coAuthors": ["Juan pablo Martínez-Pastor"]},
                     {"firstName": "Rubén","lastName": "Vázquez-Cárdenas","coAuthors": ["Juan pablo Martínez-Pastor"]}]},
  {"id": 2,"value": [{"firstName": "Rubén","lastName": "Vázquez-Cárdenas","coAuthors": ["Juan pablo Martínez-Pastor"]}]}
]

HTTP 200
[{
    "id": 1,
    "value": [
        "0000-0002-8416-869X",
        "0000-0002-8416-869X"
    ]
},
{
    "id": 2,
    "value": [
        "0000-0002-8416-869X"
    ]
}]

POST {{host}}/v1/first-name/gender?indent=true
content-type: application/json
[
    {"id": "1", "value": "Valentyne, Dupont"},
    {"id": "2", "value": "Amke"},
    {"id": "3", "value": "Seong-Eun"},
    {"id": "4", "value": "James A."}
]

HTTP 200
[{
    "id": "1",
    "value": "n/a"
},
{
    "id": "2",
    "value": "mixte_feminin"
},
{
    "id": "3",
    "value": "feminin"
},
{
    "id": "4",
    "value": "masculin"
}]

POST {{host}}/v1/corporate/private-public?indent=true
content-type: application/json
[
    {
        "id": "1",
        "value": "Abeeway, F-06903 Sophia Antipolis, France"
    },
    {
        "id": "2",
        "value": "AiryLab SARL, 34 Rue Jean Baptiste Malon, F-04800 Greoux Les Bains, France"
    },
    {
        "id": "3",
        "value": "4G TECHNOL, F-06370 Mouans Sartoux, France"
    },
    {
        "id": "4",
        "value": "Univ Cote dAzur, INRIA, Ansys, Nice, France"
    }
]

HTTP 200
[{
    "id": "1",
    "value": {
        "organisme": "abeeway",
        "statut": "private"
    }
},
{
    "id": "2",
    "value": {
        "organisme": "airylab sarl",
        "statut": "private"
    }
},
{
    "id": "3",
    "value": {
        "organisme": "4g technol",
        "statut": "n/a"
    }
},
{
    "id": "4",
    "value": {
        "organisme": "univ cote dazur",
        "statut": "public"
    }
}]
