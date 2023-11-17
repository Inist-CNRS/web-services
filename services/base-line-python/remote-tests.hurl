POST https://base-line-python.services.istex.fr/v1/no-accent?indent=true
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

POST https://base-line-python.services.istex.fr/v1/no-accent2?indent=true
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