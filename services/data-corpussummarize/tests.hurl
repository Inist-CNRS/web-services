# WARNING: This file was not generated, but manually written.
# DON'T OVERWRITE IT
# Use it to test:
# npx hurl --test data-computer/tests.hurl

##################################################################
# v1/abstract
POST {{host}}/v1/abstract
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
[Options]
skip: {{blocked}}
file,example.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists

POST {{host}}/v1/retrieve-json
content-type: application/json
[Options]
delay: 140s
retry: 3
retry-interval: 30s
skip: {{blocked}}
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$" count == 1
jsonpath "$[0].value" exists
jsonpath "$[0].value" startsWith "This corpus provides"
