POST {{host}}/v1/istex-search?indent=true
content-type: application/json
[
	{
		"value": "Je veux un corpus d'articles scientifiques publiés post 2020 sur la biodiversité dans la méditerranée nord. Les documents seront en anglais"
	},
	{
		"value": "no query"
	}
]


HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$[0].value" contains "title:("
jsonpath "$[0].value" contains "abstract:("
jsonpath "$[0].value" contains "subject.value:("
jsonpath "$[0].value" contains "language.raw:"
jsonpath "$[0].value" matches /^.{100,1100}$/
jsonpath "$[1].value" exists
jsonpath "$[1].value" matches /^.{0,10}$/
