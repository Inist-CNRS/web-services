POST https://ark-tools.services.istex.fr/v1/67375/stamp?subpublisher=XXX&indent=true
content-type: application/json
[
	{ "id":"12345","value": true },
	{ "id":"6789","value": true }
]

HTTP 200
[{
    "id": "12345",
    "value": "ark:/67375/XXX-VR4C38XD-3"
},
{
    "id": "6789",
    "value": "ark:/67375/XXX-HNXB328M-4"
}]

POST https://ark-tools.services.istex.fr/v1/67375/stamp?subpublisher=XXX&indent=true
content-type: application/json
[
	{
		"title": "Integer eget dignissim neque, sit amet sagittis nisi. In ornare massa lacus."
	},
	{
		"title": "Curabitur molestie posuere arcu, eget pharetra lacus lobortis in."
	},
	{
		"title": " Nulla in ipsum eu dui rhoncus fringilla. Ut interdum mi metus"
	}
]

HTTP 200
[{
    "title": "Integer eget dignissim neque, sit amet sagittis nisi. In ornare massa lacus.",
    "value": "ark:/67375/XXX-454RCWQ7-Z"
},
{
    "title": "Curabitur molestie posuere arcu, eget pharetra lacus lobortis in.",
    "value": "ark:/67375/XXX-Q9FMW9GQ-X"
},
{
    "title": " Nulla in ipsum eu dui rhoncus fringilla. Ut interdum mi metus",
    "value": "ark:/67375/XXX-RJPSCQ8X-T"
}]