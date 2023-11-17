POST http://localhost:31976/v1/no-accent?indent=true
content-type: application/json
[
	{ "value": "é" },
	{ "value": "à" }
]

HTTP 200
[{
    "value": "e"
},
{
    "value": "a"
}]

POST http://localhost:31976/v1/no-accent2?indent=true
content-type: application/json
[
	{ "value": "é" },
	{ "value": "à" }
]

HTTP 200
[{
    "value": "e"
},
{
    "value": "a"
}]