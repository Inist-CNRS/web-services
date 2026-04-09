# WARNING: This file was not generated, but manually written.
# DON'T OVERWRITE IT
# Use it to test:
# npx hurl --test data-geonames/tests.hurl

POST {{host}}/v1/align
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,example-data-geonames-small.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists


POST {{host}}/v1/retrieve-json?indent=true
content-type: application/json
[Options]
delay:60000
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
[Asserts]
jsonpath "$[0].value[0].entity" == "Geneva"
jsonpath "$[0].value[0].alignment" count > 0
jsonpath "$[0].value[0].alignment[0]" contains "geonames.org"
jsonpath "$[0].value[2].entity" == "Paris"
jsonpath "$[0].value[2].alignment" count > 0
jsonpath "$[0].value[2].alignment[0]" contains "geonames.org"