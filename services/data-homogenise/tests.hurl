# WARNING: This file was not generated, but manually written.
# DON'T OVERWRITE IT
# Use it to test:
# npx hurl --test data-computer/tests.hurl

##################################################################
# v1/homogenise
POST {{host}}/v1/homogenise
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
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
delay: 30000
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
jsonpath "$" count == 3
jsonpath "$[0].value[0]" == "Inist-CNRS, UAR76"
jsonpath "$[0].value[1]" == "2 rue Jean Zay, 54500 Vandoeuvre-lès-Nancy (Inist-CNRS)"
jsonpath "$[0].value[2]" == "2 rue Jean Zay, 54500 Vandoeuvre-lès-Nancy (Inist-CNRS)"
