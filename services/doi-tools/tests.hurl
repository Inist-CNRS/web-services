POST {{host}}/v1/check?indent=true
content-type: application/json
[
	{ 
		"id":1,
		"value": "10.1056/nejmoa1200303,10.1016/b978-0-323-90638-8.00002-3,10.2586/wrong-doi" 
	},
	{ 
		"id":2,
		"value": ["10.1056/nejmoa1200303","10.1016/b978-0-323-90638-8.00002-3","10.2586/wrong-doi"] 
	}
]

HTTP 200
[{
    "id": 1,
    "value": [
        "10.1056/nejmoa1200303",
        "10.1016/b978-0-323-90638-8.00002-3"
    ]
},
{
    "id": 2,
    "value": [
        "10.1056/nejmoa1200303",
        "10.1016/b978-0-323-90638-8.00002-3"
    ]
}]

POST {{host}}/v1/tagger?indent=true
content-type: application/json
[
	{ 
		"id":1,
		"value": "This text contains two DOI : 10.1056\/nejmoa1200303 and 10.1016/b978-0-323-90638-8.00002-3" 
	},
	{ 
		"id":2,
		"value": "Please see https://doi.org/10.1016/b978-0-323-90638-8.00002-3" 
	}
]


HTTP 200
[{
    "id": 1,
    "value": [
        "10.1056/nejmoa1200303",
        "10.1016/b978-0-323-90638-8.00002-3"
    ]
},
{
    "id": 2,
    "value": [
        "10.1016/b978-0-323-90638-8.00002-3"
    ]
}]