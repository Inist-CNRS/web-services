# WARNING: This file was not generated, but manually written.
# DON'T OVERWRITE IT
# Use it to test:
# npx hurl --test data-keywordsimilarity/tests.hurl

##################################################################
# v1/kw
POST {{host}}/v1/kw
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,examples/example_autism_small.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists

POST {{host}}/v1/retrieve-json
content-type: application/json
[Options]
delay: 40000
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
jsonpath "$" exists
jsonpath "$[0].keyword" exists
jsonpath "$[0].word" exists
jsonpath "$[0].sim" exists


##################################################################
# v1/kw
POST {{host}}/v1/kw
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,examples/example_pattern_1_monoterme.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists

POST {{host}}/v1/retrieve-json
content-type: application/json
[Options]
delay: 40000
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
jsonpath "$" exists
jsonpath "$[0].keyword" exists
jsonpath "$[0].word" exists
jsonpath "$[0].sim" exists

##################################################################
# v1/kw
POST {{host}}/v1/kw
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,examples/example_pattern_2.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists

POST {{host}}/v1/retrieve-json
content-type: application/json
[Options]
delay: 40000
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
jsonpath "$" exists
jsonpath "$[0].keyword" exists
jsonpath "$[0].word" exists
jsonpath "$[0].sim" exists