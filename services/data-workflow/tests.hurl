# WARNING: This file was not generated, but manually written.
# DON'T OVERWRITE IT
# Use it to test:
# 	npx hurl --test --variable host="http://localhost:31976" tests.hurl
# or (from root of the repo)
#   npm run test:local data-termsuite

# WARNING: The webhook URLs don't last forever.
#          Without activity, they expire after one week!
#          That can be the cause of failing tests, using docker.
#          Thus, there are commented here.

############################################################################
# Test v1/base-line

POST {{host}}/v1/base-line
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
file,./22-txt-en.tar.gz;

HTTP 200
Content-Type: application/json
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

POST {{host}}/v1/retrieve-json
content-type: application/json
Connection: Keep-Alive
Keep-Alive: 300
Accept-Encoding: gzip, deflate
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
Content-Type: application/json
[Asserts]
jsonpath "$" count == 22
jsonpath "$[0].value" startsWith " Paleogene evolution and demise"

# From here, the tests can't succeed on GitHub Actions, please test using
# real-tests.hurl

# ############################################################################
# # Test v1/tag-cloud-en

# POST {{host}}/v1/tag-cloud-en
# content-type: application/x-gzip
# # X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# # X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# file,./22-txt-en.tar.gz;

# HTTP 200
# Content-Type: application/json
# # Capture the computing token
# [Captures]
# computing_token: jsonpath "$[0].value"
# [Asserts]
# variable "computing_token" exists

# # There should be a waiting time, representing the time taken to process data.
# # Fortunately, as the data is sparse, and the computing time is small,
# # the need is small.
# # In normal use cases, a webhook is called when the processing is finished.
# # That query gives the process identifier.
# # Next, you can call the retrieve URL by putting the identifier in the value field.

# # Version 4.1.0 of hurl added a delay option, which value is milliseconds.
# # https://hurl.dev/blog/2023/09/24/announcing-hurl-4.1.0.html#add-delay-between-requests

# POST {{host}}/v1/retrieve-json
# content-type: application/json
# [Options]
# delay: 2000
# ```
# [
# 	{
# 		"value":"{{computing_token}}"
# 	}
# ]
# ```

# HTTP 200
# Content-Type: application/json
# [{"id":"aridification","value":2},{"id":"mafic","value":2},{"id":"climate change","value":3}]
