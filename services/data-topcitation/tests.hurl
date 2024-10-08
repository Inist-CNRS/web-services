# WARNING: This file was not generated, but manually written.
# DON'T OVERWRITE IT
# Use it to test:
# 	npx hurl --test --variable host="http://localhost:31976" tests.hurl
# or (from root of the repo)
#   npm run test:local data-termsuite

############################################################################
# Test v1/topcitation

POST {{host}}/v1/topcitation
content-type: application/x-gzip
# X-Webhook-Success: https://webhook.site/2caab8b5-fc96-4d7a-bb94-bdda20977830
# X-Webhook-Failure: https://webhook.site/2caab8b5-fc96-4d7a-bb94-bdda20977830
file,./examples/list-doi.tar.gz;

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
delay: 10000
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
    "id": "n/a",
    "value": [
        {
            "citation": "https://doi.org/10.1007/bf01303701",
            "count": 6,
            "doi": [
                "https://doi.org/10.1021/ja800073m",
                "https://doi.org/10.1126/science.235.4793.1196",
                "https://doi.org/10.1103/physrevlett.58.908",
                "https://doi.org/10.1103/revmodphys.70.1039",
                "https://doi.org/10.1103/revmodphys.66.1125",
                "https://doi.org/10.1103/physrevb.37.3759"
            ]
        },
        {
            "citation": "https://doi.org/10.1103/physrev.115.2",
            "count": 3,
            "doi": [
                "https://doi.org/10.1126/science.235.4793.1196",
                "https://doi.org/10.1103/revmodphys.70.1039",
                "https://doi.org/10.1103/physrevb.37.3759"
            ]
        },
        {
            "citation": "https://doi.org/10.1126/science.235.4793.1196",
            "count": 3,
            "doi": [
                "https://doi.org/10.1103/revmodphys.70.1039",
                "https://doi.org/10.1103/revmodphys.66.1125",
                "https://doi.org/10.1103/physrevb.37.3759"
            ]
        },
        {
            "citation": "https://doi.org/10.1103/physrevb.40.2254",
            "count": 2,
            "doi": [
                "https://doi.org/10.1021/ja800073m",
                "https://doi.org/10.1103/revmodphys.70.1039"
            ]
        },
        {
            "citation": "https://doi.org/10.1103/physrevb.50.6534",
            "count": 2,
            "doi": [
                "https://doi.org/10.1021/ja800073m",
                "https://doi.org/10.1103/revmodphys.70.1039"
            ]
        },
        {
            "citation": "https://doi.org/10.1038/372532a0",
            "count": 2,
            "doi": [
                "https://doi.org/10.1021/ja800073m",
                "https://doi.org/10.1103/revmodphys.70.1039"
            ]
        },
        {
            "citation": "https://doi.org/10.1126/science.235.4788.567",
            "count": 2,
            "doi": [
                "https://doi.org/10.1126/science.235.4793.1196",
                "https://doi.org/10.1103/physrevlett.58.908"
            ]
        },
        {
            "citation": "https://doi.org/10.1088/0370-1298/62/7/303",
            "count": 2,
            "doi": [
                "https://doi.org/10.1126/science.235.4793.1196",
                "https://doi.org/10.1103/revmodphys.70.1039"
            ]
        },
        {
            "citation": "https://doi.org/10.1103/physrevlett.58.408",
            "count": 2,
            "doi": [
                "https://doi.org/10.1126/science.235.4793.1196",
                "https://doi.org/10.1103/physrevlett.58.908"
            ]
        },
        {
            "citation": "https://doi.org/10.1103/physrevlett.58.405",
            "count": 2,
            "doi": [
                "https://doi.org/10.1126/science.235.4793.1196",
                "https://doi.org/10.1103/physrevlett.58.908"
            ]
        }
    ]
}]