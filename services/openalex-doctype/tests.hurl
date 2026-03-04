POST {{host}}/v1/isresearch-id?indent=true
content-type: application/json
[
	{ "value": "w4405561029" },
	{ "value": "w4405561035" },
	{ "value": "w4405561037" },
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
        "score": 0.98
    }
},
{
    "value": {
        "isResearchDoc": "not_processed",
        "score": 1
    }
},
{
    "value": {
        "isResearchDoc": "n/a",
        "score": "n/a"
    }
}]