POST {{host}}/v1/isresearch-id?indent=true
content-type: application/json
[
	{ "value": "w4405561029" },
	{ "value": "w4405561030" },
	{ "value": "not an ID" }
]


HTTP 200
[{
    "value": {
        "isResearchDoc": false,
        "score": 0.72
    }
},
{
    "value": {
        "isResearchDoc": true,
        "score": 1
    }
},
{
    "value": {
        "isResearchDoc": null,
        "score": null
    }
}]