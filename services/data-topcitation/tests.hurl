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
delay: 25000
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
    "id": "https://doi.org/10.1007/bf01303701",
    "value": {
        "count": 6,
        "citing_doi": [
            "https://doi.org/10.1021/ja800073m",
            "https://doi.org/10.1126/science.235.4793.1196",
            "https://doi.org/10.1103/physrevlett.58.908",
            "https://doi.org/10.1103/revmodphys.70.1039",
            "https://doi.org/10.1103/revmodphys.66.1125",
            "https://doi.org/10.1103/physrevb.37.3759"
        ]
    }
},
{
    "id": "https://doi.org/10.1103/physrev.115.2",
    "value": {
        "count": 3,
        "citing_doi": [
            "https://doi.org/10.1126/science.235.4793.1196",
            "https://doi.org/10.1103/revmodphys.70.1039",
            "https://doi.org/10.1103/physrevb.37.3759"
        ]
    }
},
{
    "id": "https://doi.org/10.1126/science.235.4793.1196",
    "value": {
        "count": 3,
        "citing_doi": [
            "https://doi.org/10.1103/revmodphys.70.1039",
            "https://doi.org/10.1103/revmodphys.66.1125",
            "https://doi.org/10.1103/physrevb.37.3759"
        ]
    }
},
{
    "id": "https://doi.org/10.1103/physrevb.40.2254",
    "value": {
        "count": 2,
        "citing_doi": [
            "https://doi.org/10.1021/ja800073m",
            "https://doi.org/10.1103/revmodphys.70.1039"
        ]
    }
},
{
    "id": "https://doi.org/10.1103/physrevb.50.6534",
    "value": {
        "count": 2,
        "citing_doi": [
            "https://doi.org/10.1021/ja800073m",
            "https://doi.org/10.1103/revmodphys.70.1039"
        ]
    }
},
{
    "id": "https://doi.org/10.1038/372532a0",
    "value": {
        "count": 2,
        "citing_doi": [
            "https://doi.org/10.1021/ja800073m",
            "https://doi.org/10.1103/revmodphys.70.1039"
        ]
    }
},
{
    "id": "https://doi.org/10.1126/science.235.4788.567",
    "value": {
        "count": 2,
        "citing_doi": [
            "https://doi.org/10.1126/science.235.4793.1196",
            "https://doi.org/10.1103/physrevlett.58.908"
        ]
    }
},
{
    "id": "https://doi.org/10.1088/0370-1298/62/7/303",
    "value": {
        "count": 2,
        "citing_doi": [
            "https://doi.org/10.1126/science.235.4793.1196",
            "https://doi.org/10.1103/revmodphys.70.1039"
        ]
    }
},
{
    "id": "https://doi.org/10.1103/physrevlett.58.408",
    "value": {
        "count": 2,
        "citing_doi": [
            "https://doi.org/10.1126/science.235.4793.1196",
            "https://doi.org/10.1103/physrevlett.58.908"
        ]
    }
},
{
    "id": "https://doi.org/10.1103/physrevlett.58.405",
    "value": {
        "count": 2,
        "citing_doi": [
            "https://doi.org/10.1126/science.235.4793.1196",
            "https://doi.org/10.1103/physrevlett.58.908"
        ]
    }
}]

############################################################################
# Test v1/topcitation

POST {{host}}/v1/topcitation?nbCitations=3
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
delay: 15000
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
    "id": "https://doi.org/10.1007/bf01303701",
    "value": {
        "count": 6,
        "citing_doi": [
            "https://doi.org/10.1021/ja800073m",
            "https://doi.org/10.1126/science.235.4793.1196",
            "https://doi.org/10.1103/physrevlett.58.908",
            "https://doi.org/10.1103/revmodphys.70.1039",
            "https://doi.org/10.1103/revmodphys.66.1125",
            "https://doi.org/10.1103/physrevb.37.3759"
        ]
    }
},
{
    "id": "https://doi.org/10.1103/physrev.115.2",
    "value": {
        "count": 3,
        "citing_doi": [
            "https://doi.org/10.1126/science.235.4793.1196",
            "https://doi.org/10.1103/revmodphys.70.1039",
            "https://doi.org/10.1103/physrevb.37.3759"
        ]
    }
},
{
    "id": "https://doi.org/10.1126/science.235.4793.1196",
    "value": {
        "count": 3,
        "citing_doi": [
            "https://doi.org/10.1103/revmodphys.70.1039",
            "https://doi.org/10.1103/revmodphys.66.1125",
            "https://doi.org/10.1103/physrevb.37.3759"
        ]
    }
}]

POST {{host}}/v1/retrieve-gexf
content-type: application/json
[Options]
delay: 15000
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
Content-Type: application/xml
[Asserts]
xpath "/*[name()='gexf']" exists
xpath "substring(//*[name()='meta']/@lastmodifieddate,1,2)" == "20"
xpath "string(//*[name()='creator'])" == "NetworkX 3.2.1"
xpath "//*[name()='node']" count >= 8 # 15 in reality, hurl bug ?
xpath "//*[name()='edge']" count >= 12 # 26 in reality
# ```xml
# <gexf xmlns:viz="http://www.gexf.net/1.2draft/viz" xmlns="http://www.gexf.net/1.2draft" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gexf.net/1.2draft http://www.gexf.net/1.2draft/gexf.xsd" version="1.2">
#   <meta lastmodifieddate="2025-04-01">
#     <creator>NetworkX 3.2.1</creator>
#   </meta>
#   <graph defaultedgetype="directed" mode="static" name="">
#     <attributes mode="static" class="node">
#       <attribute id="0" title="count" type="long" />
#       <attribute id="1" title="statut" type="string" />
#     </attributes>
#     <nodes>
#       <node id="https://doi.org/10.1021/ja800073m" label="https://doi.org/10.1021/ja800073m">
#         <viz:color r="0" g="0" b="255" a="0.8" />
#         <viz:size value="69.31471805599453" />
#         <attvalues>
#           <attvalue for="0" value="1" />
#           <attvalue for="1" value="citant" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1007/bf01303701" label="https://doi.org/10.1007/bf01303701">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="194.59101490553132" />
#         <attvalues>
#           <attvalue for="0" value="6" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1126/science.235.4793.1196" label="https://doi.org/10.1126/science.235.4793.1196">
#         <viz:color r="0" g="255" b="0" a="0.8" />
#         <viz:size value="138.62943611198907" />
#         <attvalues>
#           <attvalue for="0" value="3" />
#           <attvalue for="1" value="cit&#233;/citant" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1103/physrevlett.58.908" label="https://doi.org/10.1103/physrevlett.58.908">
#         <viz:color r="0" g="0" b="255" a="0.8" />
#         <viz:size value="69.31471805599453" />
#         <attvalues>
#           <attvalue for="0" value="1" />
#           <attvalue for="1" value="citant" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1103/revmodphys.70.1039" label="https://doi.org/10.1103/revmodphys.70.1039">
#         <viz:color r="0" g="0" b="255" a="0.8" />
#         <viz:size value="69.31471805599453" />
#         <attvalues>
#           <attvalue for="0" value="1" />
#           <attvalue for="1" value="citant" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1103/revmodphys.66.1125" label="https://doi.org/10.1103/revmodphys.66.1125">
#         <viz:color r="0" g="0" b="255" a="0.8" />
#         <viz:size value="69.31471805599453" />
#         <attvalues>
#           <attvalue for="0" value="1" />
#           <attvalue for="1" value="citant" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1103/physrevb.37.3759" label="https://doi.org/10.1103/physrevb.37.3759">
#         <viz:color r="0" g="0" b="255" a="0.8" />
#         <viz:size value="69.31471805599453" />
#         <attvalues>
#           <attvalue for="0" value="1" />
#           <attvalue for="1" value="citant" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1103/physrev.115.2" label="https://doi.org/10.1103/physrev.115.2">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="138.62943611198907" />
#         <attvalues>
#           <attvalue for="0" value="3" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1103/physrevb.40.2254" label="https://doi.org/10.1103/physrevb.40.2254">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="109.86122886681098" />
#         <attvalues>
#           <attvalue for="0" value="2" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1103/physrevb.50.6534" label="https://doi.org/10.1103/physrevb.50.6534">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="109.86122886681098" />
#         <attvalues>
#           <attvalue for="0" value="2" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1038/372532a0" label="https://doi.org/10.1038/372532a0">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="109.86122886681098" />
#         <attvalues>
#           <attvalue for="0" value="2" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1126/science.235.4788.567" label="https://doi.org/10.1126/science.235.4788.567">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="109.86122886681098" />
#         <attvalues>
#           <attvalue for="0" value="2" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1088/0370-1298/62/7/303" label="https://doi.org/10.1088/0370-1298/62/7/303">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="109.86122886681098" />
#         <attvalues>
#           <attvalue for="0" value="2" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1103/physrevlett.58.408" label="https://doi.org/10.1103/physrevlett.58.408">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="109.86122886681098" />
#         <attvalues>
#           <attvalue for="0" value="2" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1103/physrevlett.58.405" label="https://doi.org/10.1103/physrevlett.58.405">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="109.86122886681098" />
#         <attvalues>
#           <attvalue for="0" value="2" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#     </nodes>
#     <edges>
#       <edge source="https://doi.org/10.1021/ja800073m" target="https://doi.org/10.1007/bf01303701" id="0" />
#       <edge source="https://doi.org/10.1021/ja800073m" target="https://doi.org/10.1103/physrevb.40.2254" id="1" />
#       <edge source="https://doi.org/10.1021/ja800073m" target="https://doi.org/10.1103/physrevb.50.6534" id="2" />
#       <edge source="https://doi.org/10.1021/ja800073m" target="https://doi.org/10.1038/372532a0" id="3" />
#       <edge source="https://doi.org/10.1126/science.235.4793.1196" target="https://doi.org/10.1007/bf01303701" id="4" />
#       <edge source="https://doi.org/10.1126/science.235.4793.1196" target="https://doi.org/10.1103/physrev.115.2" id="5" />
#       <edge source="https://doi.org/10.1126/science.235.4793.1196" target="https://doi.org/10.1126/science.235.4788.567" id="6" />
#       <edge source="https://doi.org/10.1126/science.235.4793.1196" target="https://doi.org/10.1088/0370-1298/62/7/303" id="7" />
#       <edge source="https://doi.org/10.1126/science.235.4793.1196" target="https://doi.org/10.1103/physrevlett.58.408" id="8" />
#       <edge source="https://doi.org/10.1126/science.235.4793.1196" target="https://doi.org/10.1103/physrevlett.58.405" id="9" />
#       <edge source="https://doi.org/10.1103/physrevlett.58.908" target="https://doi.org/10.1007/bf01303701" id="10" />
#       <edge source="https://doi.org/10.1103/physrevlett.58.908" target="https://doi.org/10.1126/science.235.4788.567" id="11" />
#       <edge source="https://doi.org/10.1103/physrevlett.58.908" target="https://doi.org/10.1103/physrevlett.58.408" id="12" />
#       <edge source="https://doi.org/10.1103/physrevlett.58.908" target="https://doi.org/10.1103/physrevlett.58.405" id="13" />
#       <edge source="https://doi.org/10.1103/revmodphys.70.1039" target="https://doi.org/10.1007/bf01303701" id="14" />
#       <edge source="https://doi.org/10.1103/revmodphys.70.1039" target="https://doi.org/10.1103/physrev.115.2" id="15" />
#       <edge source="https://doi.org/10.1103/revmodphys.70.1039" target="https://doi.org/10.1126/science.235.4793.1196" id="16" />
#       <edge source="https://doi.org/10.1103/revmodphys.70.1039" target="https://doi.org/10.1103/physrevb.40.2254" id="17" />
#       <edge source="https://doi.org/10.1103/revmodphys.70.1039" target="https://doi.org/10.1103/physrevb.50.6534" id="18" />
#       <edge source="https://doi.org/10.1103/revmodphys.70.1039" target="https://doi.org/10.1038/372532a0" id="19" />
#       <edge source="https://doi.org/10.1103/revmodphys.70.1039" target="https://doi.org/10.1088/0370-1298/62/7/303" id="20" />
#       <edge source="https://doi.org/10.1103/revmodphys.66.1125" target="https://doi.org/10.1007/bf01303701" id="21" />
#       <edge source="https://doi.org/10.1103/revmodphys.66.1125" target="https://doi.org/10.1126/science.235.4793.1196" id="22" />
#       <edge source="https://doi.org/10.1103/physrevb.37.3759" target="https://doi.org/10.1007/bf01303701" id="23" />
#       <edge source="https://doi.org/10.1103/physrevb.37.3759" target="https://doi.org/10.1103/physrev.115.2" id="24" />
#       <edge source="https://doi.org/10.1103/physrevb.37.3759" target="https://doi.org/10.1126/science.235.4793.1196" id="25" />
#     </edges>
#   </graph>
# </gexf>
# ```