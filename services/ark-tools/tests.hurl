POST {{host}}/v1/67375/stamp?subpublisher=XXX&indent=true
content-type: application/json
[
	{ "id":"12345","value": true },
	{ "id":"6789","value": true }
]

HTTP 200
[Asserts]
jsonpath "$[0].id" == "12345"
jsonpath "$[0].value" matches /ark:\/67375\/XXX-.{8}-./
jsonpath "$[1].id" == "6789"
jsonpath "$[1].value" matches /ark:\/67375\/XXX-.{8}-./

POST {{host}}/v1/67375/stamp?subpublisher=XXX&indent=true
content-type: application/json
[
	{
		"title": "Integer eget dignissim neque, sit amet sagittis nisi. In ornare massa lacus."
	},
	{
		"title": "Curabitur molestie posuere arcu, eget pharetra lacus lobortis in."
	},
	{
		"title": "Nulla in ipsum eu dui rhoncus fringilla. Ut interdum mi metus"
	}
]

HTTP 200
[Asserts]
jsonpath "$[0].title" == "Integer eget dignissim neque, sit amet sagittis nisi. In ornare massa lacus."
jsonpath "$[0].value" matches /ark:\/67375\/XXX-.{8}-./
jsonpath "$[1].title" == "Curabitur molestie posuere arcu, eget pharetra lacus lobortis in."
jsonpath "$[1].value" matches /ark:\/67375\/XXX-.{8}-./
jsonpath "$[2].title" == "Nulla in ipsum eu dui rhoncus fringilla. Ut interdum mi metus"
jsonpath "$[2].value" matches /ark:\/67375\/XXX-.{8}-./
