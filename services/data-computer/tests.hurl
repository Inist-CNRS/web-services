# WARNING: This file was not generated, but manually written.
# DON'T OVERWRITE IT
# Use it to test:
# npx hurl --test data-computer/tests.hurl

POST {{host}}/v1/tree-segment
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,example-json.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists

# There should be a waiting time, representing the time taken to process data.
# Fortunately, as the data is sparse, and the computing time is small,
# the need is small.

# Version 4.1.0 of hurl added a delay option, which value is milliseconds.
# https://hurl.dev/blog/2023/09/24/announcing-hurl-4.1.0.html#add-delay-between-requests

POST {{host}}/v1/retrieve-json
content-type: application/json
[Options]
delay: 2000
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
[{"source":"a","target":"b","weight":3,"origin":["#1","#3","#4"]},{"source":"b","target":"c","weight":2,"origin":["#1","#4"]},{"source":"a","target":"c","weight":2,"origin":["#2","#5"]},{"source":"c","target":"d","weight":3,"origin":["#2","#4","#5"]},{"source":"b","target":"d","weight":1,"origin":["#3"]},{"source":"d","target":"e","weight":1,"origin":["#5"]}]

# stats
POST {{host}}/v1/statistics
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,example-json-minimal.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists

# There should be a waiting time, representing the time taken to process data.
# Fortunately, as the data is sparse, and the computing time is small,
# the need is small.

# Version 4.1.0 of hurl added a delay option, which value is milliseconds.
# https://hurl.dev/blog/2023/09/24/announcing-hurl-4.1.0.html#add-delay-between-requests

POST {{host}}/v1/retrieve-json
content-type: application/json
[Options]
delay: 2000
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
[{"id":"#1","value":{"sample":2,"frequency":0.6666666666666666,"percentage":null,"sum":0,"count":5,"min":0,"max":0,"mean":0,"range":0,"midrange":0,"variance":0,"deviation":0,"population":3,"input":"a"}},{"id":"#2","value":{"sample":2,"frequency":0.6666666666666666,"percentage":null,"sum":0,"count":5,"min":0,"max":0,"mean":0,"range":0,"midrange":0,"variance":0,"deviation":0,"population":3,"input":"b"}},{"id":"#3","value":{"sample":1,"frequency":0.3333333333333333,"percentage":null,"sum":0,"count":5,"min":0,"max":0,"mean":0,"range":0,"midrange":0,"variance":0,"deviation":0,"population":3,"input":"c"}},{"id":"#4","value":{"sample":2,"frequency":0.6666666666666666,"percentage":null,"sum":0,"count":5,"min":0,"max":0,"mean":0,"range":0,"midrange":0,"variance":0,"deviation":0,"population":3,"input":"a"}},{"id":"#5","value":{"sample":2,"frequency":0.6666666666666666,"percentage":null,"sum":0,"count":5,"min":0,"max":0,"mean":0,"range":0,"midrange":0,"variance":0,"deviation":0,"population":3,"input":"b"}}]

#
# group
POST {{host}}/v1/group-by
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,example-json-minimal.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists

# There should be a waiting time, representing the time taken to process data.
# Fortunately, as the data is sparse, and the computing time is small,
# the need is small.

# Version 4.1.0 of hurl added a delay option, which value is milliseconds.
# https://hurl.dev/blog/2023/09/24/announcing-hurl-4.1.0.html#add-delay-between-requests

POST {{host}}/v1/retrieve-json
content-type: application/json
[Options]
delay: 2000
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
[{"source":"a","target":"b","weight":3,"origin":["#1","#3","#4"]},{"source":"b","target":"c","weight":2,"origin":["#1","#4"]},{"source":"a","target":"c","weight":2,"origin":["#2","#5"]},{"source":"c","target":"d","weight":3,"origin":["#2","#4","#5"]},{"source":"b","target":"d","weight":1,"origin":["#3"]},{"source":"d","target":"e","weight":1,"origin":["#5"]}]

#
# TODO: ajouter les deux autres routes (v1GraphSegment, v1Lda)
