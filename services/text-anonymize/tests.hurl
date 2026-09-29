POST {{host}}/v1/anonymize?indent=true
content-type: application/json
[
  {
    "id": 1,
    "value": "Sexe: F - Email: camille.lefebvre@example.com - Téléphone: 06.42-887-1953 - Ville: Bordeaux, 33000"
  }
]


HTTP 200
[{
    "id": 1,
    "value": "Sexe: F - Email: [EMAIL] - Téléphone: [TEL] - Ville: [ORGANIZATION], [POSTCODE]"
}]