POST {{host}}/v1/no-accent?indent=true
content-type: application/json
[
	{ "value": "à l'école" },
	{ "value": "où" }
]

HTTP 200
[{
    "value": "a l'ecole"
},
{
    "value": "ou"
}]

POST {{host}}/v1/no-accent2?indent=true
content-type: application/json
[
	{ "value": "à l'école" },
	{ "value": "où" }
]

HTTP 200
[{
    "value": "a l'ecole"
},
{
    "value": "ou"
}]
