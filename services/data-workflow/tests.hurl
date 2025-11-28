# WARNING: This file was not generated, but manually written.
# DON'T OVERWRITE IT
# Use it to test:
# 	HURL_blocked=false npx hurl --test --variable host="http://localhost:31976" tests.hurl
# or (from root of the repo)
#   HURL_blocked=false npm run test:local data-workflow

# WARNING: The webhook URLs don't last forever.
#          Without activity, they expire after one week!
#          That can be the cause of failing tests, using docker.
#          Thus, there are commented here.

############################################################################
# Test v1/tabbr-mine-pdf

POST {{host}}/v1/tabbr-mine-pdf
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
file,./translital.tar.gz;

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

POST {{host}}/v1/retrieve-json?indent=true
content-type: application/json
[Options]
delay: 24000
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
jsonpath "$[0].value" count == 4
jsonpath "$[0].value[0]" exists
jsonpath "$[0].id" exists
jsonpath "$[0].id" isString
jsonpath "$[0].value[0].Abbreviation" exists
jsonpath "$[0].value[0].Prediction" exists
jsonpath "$[0].value[0].Count" exists

############################################################################
# Test v1/tabbr-mine

POST {{host}}/v1/tabbr-mine
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
file,./RAG-txt.tar.gz;

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

POST {{host}}/v1/retrieve-json?indent=true
content-type: application/json
[Options]
delay: 15000
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
jsonpath "$[0].value[0]" exists
jsonpath "$[0].id" exists
jsonpath "$[0].id" == "text"
jsonpath "$[0].value[0].Abbreviation" exists
jsonpath "$[0].value[0].Prediction" exists
jsonpath "$[0].value[0].Count" exists

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

# From here, the tests can't succeed on GitHub Actions, they are blocked

############################################################################
# Test v1/tag-cloud-en

POST {{host}}/v1/tag-cloud-en
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
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
[Options]
delay: 20000
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
jsonpath "$" count >= 3
jsonpath "$[0].id" exists
jsonpath "$[0].id" isString
jsonpath "$[0].value" exists
jsonpath "$[0].value" > 1

# [{"id":"aridification","value":2},{"id":"mafic","value":2},{"id":"climate change","value":3}]




############################################################################
# Test v1/pdf-text

POST {{host}}/v1/pdf-text
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
file,./example-pdf-text.tar.gz;

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
[Options]
delay: 20000
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
jsonpath "$[0].value" startsWith "Détection"



############################################################################
# Test v1/text-summarize-pdf

POST {{host}}/v1/text-summarize-pdf
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
file,./example-pdf-text.tar.gz;

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
[Options]
delay: 20000
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
jsonpath "$[0].value" exists




############################################################################
# Test v1/text-summarize

POST {{host}}/v1/text-summarize
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
file,./example-text.tar.gz;

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
[Options]
delay: 20000
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
jsonpath "$[0].value" startsWith "Détection"




############################################################################
# Test v1/aiabstract-check

POST {{host}}/v1/aiabstract-check
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
file,./example-text.tar.gz;

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
[Options]
delay: 10000
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
jsonpath "$[0].value.isAiGenerated" == false

############################################################################
# Test v1/teeft-en

POST {{host}}/v1/teeft-en
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
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

POST {{host}}/v1/retrieve-json?indent=true
content-type: application/json
[Options]
delay: 2000
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
jsonpath "$" count == 22
jsonpath "$[0].value" exists
jsonpath "$[0].value[0]" exists
jsonpath "$[0].id" exists
jsonpath "$[0].value[0].term" exists
jsonpath "$[0].value[0].frequency" exists
jsonpath "$[0].value[0].specificity" exists

POST {{host}}/v1/retrieve-lines-csv
content-type: application/json
[Options]
skip: {{blocked}}
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
Content-Type: text/csv
[Asserts]
body contains "\"id\",\"term\",\"frequency\",\"specificity\""
body contains "\"WPpTXDTJB.txt\",\"proto-paratethys\",\"9\",\"1\""
body contains "\"WtJ4NNWhq.txt\",\"time scale\",\"1\",\"0.2\""

############################################################################
# Test v1/astro-tag-pdf

POST {{host}}/v1/astro-tag-pdf
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
file,./entity-test.pdf.tar.gz;

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

POST {{host}}/v1/retrieve-json?indent=false
content-type: application/json
[Options]
delay: 10000
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
jsonpath "$[0].value.Planete" includes "Jupiter"
jsonpath "$[0].value.Planete" includes "Saturn"
jsonpath "$[0].value.Planete" count == 2


############################################################################
# Test v1/astro-tag

POST {{host}}/v1/astro-tag
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
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

POST {{host}}/v1/retrieve-json?indent=false
content-type: application/json
[Options]
delay: 70000
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
jsonpath "$[0].value.Satellite_naturel" includes "Tethys"
jsonpath "$[0].value.Satellite_naturel" count == 1
jsonpath "$[6].value.Planete" includes "Earth"
jsonpath "$[6].value.Planete" count == 1

############################################################################
# Test v1/chem-tag-pdf

POST {{host}}/v1/chem-tag-pdf
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
file,./entity-test.pdf.tar.gz;

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
[Options]
delay: 20000
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
jsonpath "$[0].value.chemical" includes "ibuprofen"
jsonpath "$[0].value.chemical" includes "amoxicillin"
jsonpath "$[0].value.chemical" count == 2


############################################################################
# Test v1/chem-tag

POST {{host}}/v1/chem-tag
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
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

POST {{host}}/v1/retrieve-json?indent=false
content-type: application/json
[Options]
delay: 20000
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
jsonpath "$[1].value.chemical" includes "zircon"
jsonpath "$[1].value.chemical" includes "granodiorite"
jsonpath "$[1].value.chemical" includes "Si"
jsonpath "$[1].value.chemical" includes "SiO2"
jsonpath "$[1].value.chemical" count == 15


############################################################################
# Test v1/diseases-tag-pdf

POST {{host}}/v1/diseases-tag-pdf
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
file,./entity-test.pdf.tar.gz;

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

POST {{host}}/v1/retrieve-json?indent=false
content-type: application/json
[Options]
delay: 20000
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
jsonpath "$[0].value.diseases" includes "pain"
jsonpath "$[0].value.diseases" includes "migraine"
jsonpath "$[0].value.diseases" includes "respiratory infection"
jsonpath "$[0].value.diseases" count == 3


############################################################################
# Test v1/diseases-tag

POST {{host}}/v1/diseases-tag
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
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

POST {{host}}/v1/retrieve-json?indent=false
content-type: application/json
[Options]
delay: 20000
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
jsonpath "$[1].value.diseases" includes "magmatism"
jsonpath "$[1].value.diseases" count == 4


############################################################################
# Test v1/bibcheck

POST {{host}}/v1/bibcheck
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
# X-Webhook-Failure: https://webhook.site/684dd427-5484-404a-b5a0-80e5b6726a1c
[Options]
skip: {{blocked}}
file,./bibcheck.tar.gz;

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

POST {{host}}/v1/retrieve-json?indent=false
content-type: application/json
[Options]
delay: 20000
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
jsonpath "$[0].value.status" == "found"
jsonpath "$[1].value.status" == "found"
jsonpath "$[2].value.status" == "found"
jsonpath "$[3].value.status" == "retracted"
jsonpath "$[4].value.status" == "to_be_verified"
