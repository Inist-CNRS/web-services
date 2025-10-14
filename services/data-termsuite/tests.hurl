# WARNING: This file was not generated, but manually written.
# DON'T OVERWRITE IT
# Use it to test:
# 	npx hurl --test --variable host="http://localhost:31976" tests.hurl
# or (from root of the repo)
#   npm run test:local data-termsuite

############################################################################
# Test v1/en

POST {{host}}/v1/en?nb=10
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/2caab8b5-fc96-4d7a-bb94-bdda20977830
# X-Webhook-Failure: https://webhook.site/2caab8b5-fc96-4d7a-bb94-bdda20977830
file,./examples/22-txt-en.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists

# There should be a waiting time, representing the time taken to process data.
# Fortunately, as the data is sparse, and the computing time is small,
# the need is small.
# In normal use cases, a webhook is called when the processing is finished.
# That query gives the process identifier.
# Next, you can call the retrieve URL by putting the identifier in the value field.

# Version 4.1.0 of hurl added a delay option, which value is milliseconds.
# https://hurl.dev/blog/2023/09/24/announcing-hurl-4.1.0.html#add-delay-between-requests

POST {{host}}/v1/retrieve-json?indent=true
content-type: application/json
[Options]
delay: 20000
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
Content-Type: application/json
[{
    "key": "n: sediment",
    "spec": 4.61,
    "freq": 10
},
{
    "key": "nn: proto-paratethys sea",
    "spec": 4.56,
    "freq": 9
},
{
    "key": "a: glacial",
    "spec": 4.46,
    "freq": 7
},
{
    "key": "n: mmes",
    "spec": 4.46,
    "freq": 7
},
{
    "key": "a: tropical",
    "spec": 4.46,
    "freq": 7
},
{
    "key": "n: precipitation",
    "spec": 4.46,
    "freq": 7
},
{
    "key": "n: genus",
    "spec": 4.46,
    "freq": 7
},
{
    "key": "n: obliquiloculata",
    "spec": 4.46,
    "freq": 7
},
{
    "key": "n: telescopus",
    "spec": 4.39,
    "freq": 6
},
{
    "key": "nn: clay mineral",
    "spec": 4.39,
    "freq": 6
}]

############################################################################
# Test v1/fr
POST {{host}}/v1/fr?nb=5
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/2caab8b5-fc96-4d7a-bb94-bdda20977830
# X-Webhook-Failure: https://webhook.site/2caab8b5-fc96-4d7a-bb94-bdda20977830
file,./examples/7-txt-fr.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
fr_computing_token: jsonpath "$[0].value"
[Asserts]
variable "fr_computing_token" exists

# There should be a waiting time, representing the time taken to process data.
# Fortunately, as the data is sparse, and the computing time is small,
# the need is small.
# In normal use cases, a webhook is called when the processing is finished.
# That query gives the process identifier.
# Next, you can call the retrieve URL by putting the identifier in the value field.

# Version 4.1.0 of hurl added a delay option, which value is milliseconds.
# https://hurl.dev/blog/2023/09/24/announcing-hurl-4.1.0.html#add-delay-between-requests

POST {{host}}/v1/retrieve-json?indent=true
content-type: application/json
[Options]
delay: 15000
```
[
	{
		"value":"{{fr_computing_token}}"
	}
]
```

HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$" count == 5
jsonpath "$[*].key" includes "a: thermique"
jsonpath "$[*].key" includes "n: fission"
jsonpath "$[*].key" includes "n: biomasse"
jsonpath "$[*].key" includes "na: énergie éolien"
jsonpath "$[*].key" includes "a: électrique"

# Order is not guaranteed
#[{
#    "key": "a: thermique",
#    "freq": 12
#},
#{
#    "key": "n: fission",
#    "freq": 12
#},
#{
#    "key": "n: biomasse",
#    "freq": 10
#},
#{
#    "key": "na: énergie éolien",
#    "freq": 7
#},
#{
#    "key": "a: électrique",
#    "freq": 7
#}]

############################################################################
# Test v1/fr/minimal
POST {{host}}/v1/fr/minimal?nb=5
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/2caab8b5-fc96-4d7a-bb94-bdda20977830
# X-Webhook-Failure: https://webhook.site/2caab8b5-fc96-4d7a-bb94-bdda20977830
file,./examples/7-txt-fr.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
fr_computing_token: jsonpath "$[0].value"
[Asserts]
variable "fr_computing_token" exists

# There should be a waiting time, representing the time taken to process data.
# Fortunately, as the data is sparse, and the computing time is small,
# the need is small.
# In normal use cases, a webhook is called when the processing is finished.
# That query gives the process identifier.
# Next, you can call the retrieve URL by putting the identifier in the value field.

# Version 4.1.0 of hurl added a delay option, which value is milliseconds.
# https://hurl.dev/blog/2023/09/24/announcing-hurl-4.1.0.html#add-delay-between-requests

POST {{host}}/v1/retrieve-json?indent=true
content-type: application/json
[Options]
delay: 15000
```
[
	{
		"value":"{{fr_computing_token}}"
	}
]
```

HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$" count == 5
jsonpath "$[*].id" includes "a: thermique"
jsonpath "$[*].id" includes "n: fission"
jsonpath "$[*].id" includes "n: biomasse"
jsonpath "$[*].id" includes "na: énergie éolien"
jsonpath "$[*].id" includes "a: électrique"


