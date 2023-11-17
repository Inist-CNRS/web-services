POST https://base-line.services.istex.fr/v1/no-accent?indent=true
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

POST https://base-line.services.istex.fr/v1/no-accent2?indent=true
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

POST https://base-line.services.istex.fr/v1/echo/json?indent=true
content-type: application/json
[
	{ "value": "à l'école" },
	{ "value": "où" }
]

HTTP 200
[{
    "value": "à l'école"
},
{
    "value": "où"
}]

POST https://base-line.services.istex.fr/v1/echo/csv
content-type: application/csv
a,b
1,2

HTTP 200
a;b
1;2


POST https://base-line.services.istex.fr/v1/echo/raw
content-type: text/plain
```
Ceci est le texte envoyé.
```

HTTP 200
```
Ceci est le texte envoyé.
```



POST https://base-line.services.istex.fr/v1/true/csv
content-type: text/csv
```
a,value
1,2
```

HTTP 200
```
a;value
1;true
```



POST https://base-line.services.istex.fr/v1/true/json
content-type: application/json
[
	{ "value": "à l'école" },
	{ "value": "où" }
]

HTTP 200
[{"value":true},{"value":true}]