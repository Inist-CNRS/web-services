# WARNING: This file was not generated, but manually written.
# DO NOT OVERWRITE IT
# Written from examples.http, adapted to the asynchronous pattern:
# /v1/align returns a token, results are polled with retrieve-status.
# Run all tests locally: HURL_VARIABLE_blocked=false npm run test:local loterre-align
# In CI (blocked=true) only the fast error-case entries run.

POST {{host}}/v1/align?source=loterreID:XXXX&target=loterreID:2CX
content-type: application/json
[{}]

HTTP 200
[Captures]
bad_token: jsonpath "$[0].value"
[Asserts]
variable "bad_token" exists

POST {{host}}/v1/retrieve-status
content-type: application/json
[Options]
skip: {{blocked}}
retry: 40
retry-interval: 10s
[
  { "value": "{{bad_token}}" }
]

HTTP 200
[Asserts]
body contains "Error"

POST {{host}}/v1/retrieve-status
content-type: application/json
[
  { "value": "xMkWJX7GU" }
]

HTTP 400

POST {{host}}/v1/align?source=file&target=loterreID:2CX&min_score=0.7&top_k=5
content-type: application/json
[Options]
skip: {{blocked}}
[
  {
    "skos": "<rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#' xmlns:skos='http://www.w3.org/2004/02/skos/core#'><skos:Concept rdf:about='http://ex.org/c1'><skos:prefLabel xml:lang='fr'>mémoire</skos:prefLabel></skos:Concept></rdf:RDF>"
  }
]

HTTP 200
[Captures]
token: jsonpath "$[0].value"
[Asserts]
variable "token" exists

POST {{host}}/v1/retrieve-status
content-type: application/json
[Options]
skip: {{blocked}}
retry: 40
retry-interval: 10s
[
  { "value": "{{token}}" }
]

HTTP 200
[Asserts]
body contains "Process completed"

POST {{host}}/v1/retrieve-rdf
content-type: application/json
[Options]
skip: {{blocked}}
[
  { "value": "{{token}}" }
]

HTTP 200
[Asserts]
body contains "rdf:RDF"
header "Content-Type" contains "rdf+xml"

POST {{host}}/v1/retrieve-report?indent=true
content-type: application/json
[Options]
skip: {{blocked}}
[
  { "value": "{{token}}" }
]

HTTP 200
[Asserts]
body contains "counts"
