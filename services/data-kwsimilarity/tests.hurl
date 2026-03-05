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
jsonpath "$[0].autism" exists
jsonpath "$[0].autism.[0].word" exists
jsonpath "$[0].autism.[0].sim" exists
jsonpath "$[0].autism.[0].tfidf" exists
jsonpath "$[0].autism.[0].ponderation" exists


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
jsonpath "$[0].dog" exists
jsonpath "$[0].dog.[0].word" exists
jsonpath "$[0].dog.[0].sim" exists
jsonpath "$[0].dog.[0].tfidf" exists
jsonpath "$[0].dog.[0].ponderation" exists


jsonpath "$[0].cat" exists
jsonpath "$[0].cat.[0].word" exists
jsonpath "$[0].cat.[0].sim" exists
jsonpath "$[0].cat.[0].tfidf" exists
jsonpath "$[0].cat.[0].ponderation" exists


jsonpath "$[0].chicken" exists
jsonpath "$[0].chicken.[0].word" exists


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
jsonpath "$[0].sign_language" exists
jsonpath "$[0].sign_language.[0].word" exists
jsonpath "$[0].sign_language.[0].sim" exists
jsonpath "$[0].sign_language.[0].tfidf" exists
jsonpath "$[0].sign_language.[0].ponderation" exists
