# WARNING: This file was not generated, but manually written.
# DON'T OVERWRITE IT
# Use it to test:
# npx hurl --test data-geonames/tests.hurl

POST {{host}}/v1/align
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,example-data-geonames-small.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists


POST {{host}}/v1/retrieve-json?indent=true
content-type: application/json
[Options]
delay:80000
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
[[
    {
        "entity": "Geneva",
        "context": "The international climate conference held in ||Geneva||, Switzerland, brought together delegates from over fifty countries.",
        "alignment": [
            "https://www.geonames.org/6458783"
        ]
    },
    {
        "entity": "Switzerland",
        "context": "The international climate conference held in Geneva, ||Switzerland||, brought together delegates from over fifty countries.",
        "alignment": [
            "https://www.geonames.org/2658434"
        ]
    },
    {
        "entity": "Paris",
        "context": "Interestingly, the lead negotiator had previously worked in ||Paris||, France, where she coordinated environmental policy for the European Union.",
        "alignment": [
            "https://www.geonames.org/2988506",
            "https://www.geonames.org/2988507",
            "https://www.geonames.org/6455259",
            "https://www.geonames.org/2968815"
        ]
    },
    {
        "entity": "Paris",
        "context": "One delegate joked that he had flown from ||Paris||, France, through Dubai, only to meet someone who had driven two hours from Paris, Tennessee to attend.",
        "alignment": [
            "https://www.geonames.org/2988506",
            "https://www.geonames.org/2988507",
            "https://www.geonames.org/6455259",
            "https://www.geonames.org/2968815"
        ]
    },
    {
        "entity": "Paris",
        "context": "Her colleague, however, was based in ||Paris||, Texas, a small town in the United States, far from the diplomatic circles of the French capital.",
        "alignment": [
            "https://www.geonames.org/4717560"
        ]
    },
    {
        "entity": "Paris",
        "context": "One delegate joked that he had flown from Paris, France, through Dubai, only to meet someone who had driven two hours from ||Paris||, Tennessee to attend.",
        "alignment": [
            "https://www.geonames.org/4717560"
        ]
    },
    {
        "entity": "France",
        "context": "Interestingly, the lead negotiator had previously worked in Paris, ||France||, where she coordinated environmental policy for the European Union.",
        "alignment": [
            "https://www.geonames.org/12313681"
        ]
    },
    {
        "entity": "France",
        "context": "One delegate joked that he had flown from Paris, ||France||, through Dubai, only to meet someone who had driven two hours from Paris, Tennessee to attend.",
        "alignment": []
    },
    {
        "entity": "Texas",
        "context": "Her colleague, however, was based in Paris, ||Texas||, a small town in the United States, far from the diplomatic circles of the French capital.",
        "alignment": [
            "https://www.geonames.org/4736286"
        ]
    },
    {
        "entity": "United States",
        "context": "Her colleague, however, was based in Paris, Texas, a small town in the ||United States||, far from the diplomatic circles of the French capital.",
        "alignment": [
            "https://www.geonames.org/6252001"
        ]
    },
    {
        "entity": "Dubai",
        "context": "One delegate joked that he had flown from Paris, France, through ||Dubai||, only to meet someone who had driven two hours from Paris, Tennessee to attend.",
        "alignment": [
            "https://www.geonames.org/292223",
            "https://www.geonames.org/292224"
        ]
    },
    {
        "entity": "Tennessee",
        "context": "One delegate joked that he had flown from Paris, France, through Dubai, only to meet someone who had driven two hours from Paris, ||Tennessee|| to attend.",
        "alignment": [
            "https://www.geonames.org/4662168"
        ]
    }
]]