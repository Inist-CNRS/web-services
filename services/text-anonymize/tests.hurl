POST {{host}}/v1/anonymize?indent=true&lang=fr
content-type: application/json
[
  {
    "value": "Sexe: F - Email: camille.lefebvre@example.com - Téléphone: 06.42-887-1953 - Ville: Bordeaux, 33000\nBonjour, je m'appelle Camille Lefebvre et j'habite à Bordeaux."
  }
]


HTTP 200
[{
    "value": "Sexe: [SEX] - Email: [EMAIL] - Téléphone: [TEL] - Ville: [CITY]\nBonjour, je m'appelle [PERSONNE] et j'habite à [LIEU]."
}]

POST {{host}}/v1/anonymize?indent=true&lang=en
content-type: application/json
[
  {
    "value": "Sex: M - Email: john.smith@example.com - Phone: (212) 555-0198 - City: Bristol, SW1A 1AA\nHello, my name is John Smith and I live in Bristol."
  }
]


HTTP 200
[{
    "value": "Sex: [SEX] - Email: [EMAIL] - Phone: [TEL] - City: [CITY]\nHello, my name is [PERSON] and I live in [LOCATION]."
}]