# WARNING: The tests server requires an api key
POST {{host}}/v1/unpaywall/is_oa?indent=true
Content-type: application/json
[Options]
skip: true
```
[
  {  "id":1, "value": "10.1016/j.fuel.2018.07.071" },
  {  "id":2, "value": "10.1007/s10980-018-0699-8" },
  {  "id":3, "value": "10.1159/000490004" },
  {  "id":4, "value": "10.1016/j.memsci.2018.08.024"},
  {  "id":5, "value": "10.1029/2018jd029272"},
  {  "id":6, "value": "10.4000/edc.9014"},
  {  "id":7, "value": "unknown"}
]
```

HTTP 200
[{
    "id": 1,
    "value": false
},
{
    "id": 2,
    "value": false
},
{
    "id": 3,
    "value": false
},
{
    "id": 4,
    "value": false
},
{
    "id": 5,
    "value": true
},
{
    "id": 6,
    "value": true
},
{
    "id": 7,
    "value": "n/a"
}]


# WARNING: The tests server requires an api key
POST {{host}}/v1/unpaywall/expand?indent=true
content-type: application/json
[Options]
skip: true
```
[
  { "id":1,  "value": "10.1016/j.fuel.2018.07.071" },
  { "id":2,  "value": "10.1007/s10980-018-0699-8" },
  { "id":3,  "value": "10.1159/000490004" },
  { "id":4,  "value": "10.1016/j.memsci.2018.08.024"},
  { "id":5,  "value": "10.1029/2018jd029272"},
  { "id":6,  "value": "10.4000/edc.9014"},
  { "id":7,  "value": "unknown"}
]
```

HTTP 200
[{
    "id": 1,
    "value": {
        "doi": "10.1016/j.fuel.2018.07.071",
        "is_oa": false,
        "oa_status": "closed",
        "has_repository_copy": false,
        "host_type": "n/a"
    }
},
{
    "id": 2,
    "value": {
        "doi": "10.1007/s10980-018-0699-8",
        "is_oa": false,
        "oa_status": "closed",
        "has_repository_copy": false,
        "host_type": "n/a"
    }
},
{
    "id": 3,
    "value": {
        "doi": "10.1159/000490004",
        "is_oa": false,
        "oa_status": "closed",
        "has_repository_copy": false,
        "host_type": "n/a"
    }
},
{
    "id": 4,
    "value": {
        "doi": "10.1016/j.memsci.2018.08.024",
        "is_oa": false,
        "oa_status": "closed",
        "has_repository_copy": false,
        "host_type": "n/a"
    }
},
{
    "id": 5,
    "value": {
        "doi": "10.1029/2018jd029272",
        "is_oa": true,
        "oa_status": "hybrid",
        "has_repository_copy": true,
        "host_type": "publisher"
    }
},
{
    "id": 6,
    "value": {
        "doi": "10.4000/edc.9014",
        "is_oa": true,
        "oa_status": "bronze",
        "has_repository_copy": false,
        "host_type": "publisher"
    }
},
{
    "id": 7,
    "value": "n/a"
}]

# WARNING: The tests server requires an api key
POST {{host}}/v1/unpaywall/corhal?indent=true
content-type: application/json
[Options]
skip: true
```
[
  { "id":1, "value": "10.1016/j.fuel.2018.07.071" },
  { "id":2, "value": "10.1007/s10980-018-0699-8" },
  { "id":3, "value": "10.1159/000490004" },
  { "id":4, "value": "10.1016/j.memsci.2018.08.024"},
  { "id":5, "value": "10.1029/2018jd029272"},
  { "id":6, "value": "10.4000/edc.9014"},
  { "id":7, "value": "unknown"}
]
```

HTTP 200
[Asserts]
jsonpath "$" count == 7

jsonpath "$[0].value.is_oa" == false
jsonpath "$[1].value.is_oa" == false
jsonpath "$[2].value.is_oa" == false
jsonpath "$[3].value.is_oa" == false
jsonpath "$[4].value.is_oa" == true
jsonpath "$[5].value.is_oa" == true
jsonpath "$[6].value.is_oa" not exists

jsonpath "$[0].value.oa_status" == "closed"
jsonpath "$[1].value.oa_status" == "closed"
jsonpath "$[2].value.oa_status" == "closed"
jsonpath "$[3].value.oa_status" == "closed"
jsonpath "$[4].value.oa_status" == "hybrid"
jsonpath "$[5].value.oa_status" == "bronze"
jsonpath "$[6].value.oa_status" not exists

jsonpath "$[0].value.oa_locations" count == 0
jsonpath "$[1].value.oa_locations" count == 0
jsonpath "$[2].value.oa_locations" count == 0
jsonpath "$[3].value.oa_locations" count == 0
jsonpath "$[4].value.oa_locations" count >= 7
jsonpath "$[5].value.oa_locations" count == 1
jsonpath "$[6].value.oa_locations" not exists


# WARNING: The tests server requires an api key
POST {{host}}/v1/unpaywall/works/expand?indent=true
content-type: application/json
content-type: application/json
[Options]
skip: true
```
[
  {  "id":1, "value": "10.1016/j.fuel.2018.07.071" },
  {  "id":2, "value": "10.1007/s10980-018-0699-8" },
  {  "id":3, "value": "10.1159/000490004" },
  {  "id":4, "value": "10.1016/j.memsci.2018.08.024"},
  {  "id":5, "value": "10.1029/2018jd029272"},
  {  "id":6, "value": "10.4000/edc.9014"},
  {  "id":7, "value": "unknown"}
]
```

HTTP 200
[Asserts]
jsonpath "$" count == 7
jsonpath "$[0].value.genre" == "journal-article"
jsonpath "$[1].value.genre" == "journal-article"
jsonpath "$[2].value.genre" == "journal-article"
jsonpath "$[3].value.genre" == "journal-article"
jsonpath "$[4].value.genre" == "journal-article"
jsonpath "$[5].value.genre" == "journal-article"
jsonpath "$[6].value.genre" not exists
jsonpath "$[0].value.oa_locations" count == 0
jsonpath "$[1].value.oa_locations" count == 0
jsonpath "$[2].value.oa_locations" count == 0
jsonpath "$[3].value.oa_locations" count == 0
jsonpath "$[4].value.oa_locations" count >= 7
jsonpath "$[5].value.oa_locations" count == 1
jsonpath "$[6].value.oa_locations" not exists


# WARNING: The tests server requires an api key
POST {{host}}/v1/crossref/prefixes/expand?indent=true
content-type: application/json
[Options]
skip: true
```
[
  {  "id":1, "value": "10.3998"},
  {  "id":2, "value": "10.1016" },
  {  "id":3, "value": "10.1007" },
  {  "id":4, "value": "10.1159" },
  {  "id":5, "value": "10.1037"},
  {  "id":6, "value": "unknown"}
]
```

HTTP 200
[{
    "id": 1,
    "value": "University of Michigan Library"
},
{
    "id": 2,
    "value": "Elsevier BV"
},
{
    "id": 3,
    "value": "Springer Science and Business Media LLC"
},
{
    "id": 4,
    "value": "S. Karger AG"
},
{
    "id": 5,
    "value": "American Psychological Association (APA)"
},
{
    "id": 6,
    "value": "n/a"
}]

# WARNING: The tests server requires an api key
POST {{host}}/v1/crossref/works/expand?indent=true
content-type: application/json
[Options]
skip: true
```
[
  { "id":1,  "value": "10.1016/j.fuel.2018.07.071" },
  { "id":2,  "value": "10.1007/s10980-018-0699-8" },
  { "id":3,  "value": "10.1159/000490004" },
  { "id":4,  "value": "10.1016/j.memsci.2018.08.024"},
  { "id":5,  "value": "10.1029/2018jd029272"},
  { "id":6,  "value": "10.4000/edc.9014"},
  { "id":7,  "value": "unknown"}
]
```

HTTP 200
[Asserts]
jsonpath "$" count == 7
jsonpath "$[0].value.reference-count"  >= 64
jsonpath "$[0].value.publisher" == "Elsevier BV"
jsonpath "$[0].value.type" == "journal-article"
jsonpath "$[0].value.author" count == 5
jsonpath "$[1].value.reference-count"  >= 72
jsonpath "$[1].value.publisher" == "Springer Science and Business Media LLC"
jsonpath "$[1].value.type" == "journal-article"
jsonpath "$[1].value.author" count == 9
jsonpath "$[6].value" == "n/a"


POST {{host}}/v1/openalex/works/expand?indent=true
content-type: application/json
[Options]
skip: false
```
[
  { "id":1,  "value": "10.1103/PhysRevLett.19.1264"},
  { "id":2,  "value": "10.1016/j.fuel.2018.07.071" },
  { "id":8,  "value": "unknown"}
]
```

HTTP 200
[Asserts]
jsonpath "$" count == 3
jsonpath "$[0].value.id" == "https://openalex.org/W2070151728"
jsonpath "$[0].value.title" == "A Model of Leptons"
jsonpath "$[0].value.locations" count == 1
jsonpath "$[1].value.created_date" == "2018-08-03"
jsonpath "$[2].id" == 8
jsonpath "$[2].value" == "n/a"

POST {{host}}/v1/istex/works/expand?indent=true
content-type: application/json
[Options]
skip: false
```
[
  { "id":1,   "value": "10.1016/S0047-6374(98)00099-2"},
  { "id":2,   "value": "10.1016/S0167-4943(01)00186-8"},
  { "id":3,   "value": "10.1093/ageing/afm016"},
  { "id":4,   "value": ""}
]
```

HTTP 200
[Asserts]
jsonpath "$" count == 4
jsonpath "$[0].value" == "n/a"
jsonpath "$[1].value" == "n/a"
jsonpath "$[2].value.corpusName" == "oup"
jsonpath "$[2].value.genre[0]" == "research-article"
jsonpath "$[3].value" == "n/a"


# WARNING: The tests server requires an api key
POST {{host}}/v1/wos/fetch?indent=true
content-type: application/json
[Options]
skip: true
```
[
  {
    "query": "0",
    "value": "XX"
  },
  {
    "query" :"I",
    "value": {
      "databaseId": "WOK",
      "usrQuery": "TS=(cadmium)",
      "count": "5",
      "firstRecord": "1"
    }
  },
  {
    "query" :"II",
    "value": {
      "databaseId": "WOK",
      "usrQuery": "TS=(cadmium)",
      "count": "5",
      "firstRecord": "6"
    }
  }
]
```



# POST {{host}}/v1/wos/works/expand?indent=true
# content-type: application/json
# [
#   { "id":1,   "value": "10.1016/S0047-6374(98)00099-2"},
#   { "id":2,   "value": "10.1016/S0167-4943(01)00186-8"},
#   { "id":3,   "value": "10.1093/ageing/afm016"},
#   { "id":4,   "value": ""}
# ]
#
# HTTP 200
# [{
#     "id": 1,
#     "value": "n/a"
# },
# {
#     "id": 2,
#     "value": "n/a"
# },
# {
#     "id": 3,
#     "value": "n/a"
# },
# {
#     "id": 4,
#     "value": "n/a"
# }]

POST {{host}}/v1/hal/works/expand?indent=true
content-type: application/json
[Options]
skip: false
```
[
  { "id":1,   "value": "10.1016/S0047-6374(98)00099-2" },
  { "id":2,   "value": "10.35562/arabesques.1222" },
  { "id":3,   "value": "10.3324/haematol.2016.148908" },
  { "id":4,   "value": "" }
]
```

HTTP 200
[Asserts]
jsonpath "$" count == 4
jsonpath "$[0].value" == "n/a"
jsonpath "$[1].value.teiHeader" exists
jsonpath "$[1].value.text" exists
jsonpath "$[2].value.teiHeader" exists
jsonpath "$[2].value.text" exists
jsonpath "$[3].value" == "n/a"

POST {{host}}/v2/hal/works/expand?indent=true
content-type: application/json
[Options]
skip: false
```
[
  { "id":1,   "value": "10.1016/S0047-6374(98)00099-2" },
  { "id":2,   "value": "10.35562/arabesques.1222" },
  { "id":3,   "value": "10.3324/haematol.2016.148908" },
  { "id":4,   "value": "" },
  { "id":5,   "value": "10.23919/EUSIPCO58844.2023.10290033" }
]
```

HTTP 200
[Asserts]
jsonpath "$" count == 5
jsonpath "$[0].value" == "n/a"
jsonpath "$[1].value.teiHeader" exists
jsonpath "$[1].value.text" exists
jsonpath "$[2].value.teiHeader" exists
jsonpath "$[2].value.text" exists
jsonpath "$[3].value" == "n/a"
jsonpath "$[4].value.teiHeader" exists
jsonpath "$[4].value.text" exists



POST {{host}}/v1/conditor/works/expand?indent=true
content-type: application/json
[Options]
skip: false
```
[
  { "id":1,   "value": "10.1016/S0047-6374(98)00099-2"},
  { "id":2,   "value": "10.35562/arabesques.1222"},
  { "id":3,   "value": "10.3324/haematol.2016.148908"},
  { "id":4,   "value": ""}
]
```

HTTP 200
[Asserts]
jsonpath "$" count == 4
jsonpath "$[0].value" == "n/a"
jsonpath "$[1].value.authors" count >= 2
jsonpath "$[2].value.authors" count >= 21
jsonpath "$[3].value" == "n/a"


# Uncomment to test
# Takes more than 40s
# POST {{host}}/v1/inspirehep/works/expand?indent=true
# content-type: application/json
# [
#   { "id":1,  "value": "10.1103/PhysRevLett.19.1264"},
#   { "id":8,  "value": "unknown"}
# ]

# HTTP 200
# [Asserts]
# jsonpath "$" count == 2
# jsonpath "$[0].value.revision_id" >= 96
# jsonpath "$[1].value" == "n/a"

POST {{host}}/v2/bso/works/expand?indent=true
content-type: application/json
[Options]
skip: false
```
[
  { "id":1,   "value": "10.1103/physrevc.106.024603"},
  { "id":2,   "value": "10.1016/j.msea.2021.142288"},
  { "id":3,   "value": "10.1029/2021gc010308"},
  { "id":4,   "value": ""}
]
```

HTTP 200
[Asserts]
jsonpath "$" count == 4
jsonpath "$[0].value.lang" == "en"
jsonpath "$[1].value.year" == "2022"
jsonpath "$[2].value.genre" == "journal-article"
jsonpath "$[3].value" == "n/a"


