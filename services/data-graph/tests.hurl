# WARNING: This file was not generated, but manually written.
# DON'T OVERWRITE IT
# Use it to test:
# npx hurl --test data-computer/tests.hurl

POST {{host}}/v1/graph
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,test-graph.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists


POST {{host}}/v1/retrieve-img
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
Content-type: image/png
[Asserts]
bytes count >= 26800000
bytes count <= 28800000


POST {{host}}/v1/retrieve-gexf
content-type: application/json
```
[
	{
		"value":"{{computing_token}}"
	}
]
```
HTTP 200
Content-type: application/xml
[Asserts]
body contains "<gexf xmlns:viz=\"http://www.gexf.net/1.2draft/viz\" xmlns=\"http://www.gexf.net/1.2draft\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.gexf.net/1.2draft http://www.gexf.net/1.2draft/gexf.xsd\" version=\"1.2\">"

# Assert graph attributes
body contains "<graph defaultedgetype=\"undirected\" mode=\"static\" name=\"\">"
body contains "<attributes mode=\"static\" class=\"edge\">"
body contains "<attribute id=\"2\" title=\"alpha\" type=\"double\" />"
body contains "<attribute id=\"3\" title=\"zorder\" type=\"long\" />"
body contains "<attribute id=\"4\" title=\"linewidth\" type=\"double\" />"
body contains "<attributes mode=\"static\" class=\"node\">"
body contains "<attribute id=\"0\" title=\"weight\" type=\"double\" />"
body contains "<attribute id=\"1\" title=\"subset\" type=\"long\" />"

# Assert nodes
body contains "<node id=\"nanoparticles\" label=\"nanoparticles\">"
body contains "<node id=\"nps\" label=\"nps\">"
body contains "<node id=\"pixels\" label=\"pixels\">"
body contains "<node id=\"intracellular\" label=\"intracellular\">"
body contains "<node id=\"mg ml\" label=\"mg ml\">"
body contains "<node id=\"pathway\" label=\"pathway\">"
body contains "<node id=\"emissions\" label=\"emissions\">"


POST {{host}}/v1/retrieve-json
content-type: application/json
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

jsonpath "$" count > 0

jsonpath "$[*].id" exists

jsonpath "$[*].value" exists
jsonpath "$[*].value.label" exists

jsonpath "$[*].value['viz$color'].r" exists
jsonpath "$[*].value['viz$color'].g" exists
jsonpath "$[*].value['viz$color'].b" exists
jsonpath "$[*].value['viz$color'].a" exists

jsonpath "$[*].value['viz$size'].value" exists

jsonpath "$[*].value['viz$position'].x" exists
jsonpath "$[*].value['viz$position'].y" exists
jsonpath "$[*].value['viz$position'].z" exists
