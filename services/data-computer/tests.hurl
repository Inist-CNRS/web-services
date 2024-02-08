# WARNING: This file was not generated, but manually written.
# DON'T OVERWRITE IT
# Use it to test:
# npx hurl --test data-computer/tests.hurl

POST https://data-computer.services.istex.fr/v1/tree-segment
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

POST https://data-computer.services.istex.fr/v1/retrieve
content-type: application/json
[Options]
delay: 1000
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
Content-Type: application/x-tar

# TODO: ajouter les deux autres routes (v1GraphSegment, v1Lda)
