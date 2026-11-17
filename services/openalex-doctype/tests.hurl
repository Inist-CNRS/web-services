POST {{host}}/v1/isresearch-id?indent=true
content-type: application/json
[
	{ "value": "w4405561029" },
	{ "value": "w4405561035" },
	{ "value": "w4405561037" },
	{ "value": "not an ID" }
]


HTTP 200
[Asserts]
jsonpath "$[0].value.isResearchDoc" == false
jsonpath "$[1].value.isResearchDoc" == true
jsonpath "$[2].value.isResearchDoc" == "not_processed"
jsonpath "$[3].value.isResearchDoc" == "n/a"
jsonpath "$[0].value.score" < 0.85
jsonpath "$[1].value.score" > 0.85
jsonpath "$[2].value.score" == 1
jsonpath "$[3].value.score" == "n/a"
