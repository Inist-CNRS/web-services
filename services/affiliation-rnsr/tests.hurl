# To test locally, use:
# hurl --test --variable host=http://localhost:31976 --jobs 1 services/affiliation-rnsr/tests.hurl
# npm run test:local affiliation-rnsr
#
# To test remotely, use:
# hurl --test --variable host=https://affiliation-rnsr.services.istex.fr --jobs 1 services/affiliation-rnsr/tests.hurl
# npm run test:remote affiliation-rnsr
#
# The service should be launched as a local server. URL: http://localhost:31976
# Just launch:
# npm -w services/affiliation-rnsr run start:dev
# npm run generate:example-tests services/affiliation-rnsr
# npm -w services/affiliation-rnsr run stop:dev

POST {{host}}/v3/affiliation/rnsr?indent=true
content-type: application/json
[
  {
    "id": 1,
    "value": "UAR 76, Inist-CNRS, 2 rue Jean Zay 54500 Vandoeuvre-lès-Nancy"
  },
  {
    "id": 2,
    "value": "Institut Charles Gerhardt, Université de MontpellierInstitut Charles Gerhardt, Université de Montpellier ; UMR 7272 - CNRS, 06100 Nice"
  }
]

HTTP 200
[{
    "id": 1,
    "value": {
        "rnsr": [
            "198822446E"
        ]
    }
},
{
    "id": 2,
    "value": {
        "rnsr": [
            "200711918D",
            "201220250N"
        ]
    }
}]

POST {{host}}/v2/affiliation/rnsr?indent=true
content-type: application/json
[
  {
    "id": 1,
    "value": "UAR 76, Inist-CNRS, 2 rue Jean Zay 54500 Vandoeuvre-lès-Nancy"
  },
  {
    "id": 2,
    "value": "Institut Charles Gerhardt, Université de Montpellier"
  },
  {
    "id": 3,
    "value": "UMR 7272 - CNRS, 06100 Nice"
  }
]


HTTP 200
[{
    "id": 1,
    "value": "198822446E"
},
{
    "id": 2,
    "value": "200711918D"
},
{
    "id": 3,
    "value": "201220250N"
}]