POST {{host}}/v1/tagger?indent=true
content-type: application/json
[
  {
    "id": 1,
    "value": "This study was funded by the CNRS and INIST."
  }
]


HTTP 200
[{
    "id": 1,
    "value": ['CNRS', 'INIST']
}]