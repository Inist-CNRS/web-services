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
    "id": "https://doi.org/10.1093/mnras/stt274",
    "value": {
        "label": "https://doi.org/10.1093/mnras/stt274",
        "viz$color": {
            "r": "0",
            "g": "0",
            "b": "255",
            "a": "0.8"
        },
        "viz$size": {
            "value": "65.05149978319906"
        },
        "targets": [
            {
                "id": "https://doi.org/10.1111/j.1365-2966.2012.21952.x"
            },
            {
                "id": "https://doi.org/10.1111/j.1365-2966.2012.20468.x"
            },
            {
                "id": "https://doi.org/10.1086/157753"
            },
            {
                "id": "https://doi.org/10.1051/0004-6361/200811054"
            },
            {
                "id": "https://doi.org/10.1093/mnras/sts454"
            },
            {
                "id": "https://openalex.org/W3121968724"
            },
            {
                "id": "https://openalex.org/W3125762999"
            }
        ]
    },
    "attributes": {
        "count": "1",
        "statut": "citant"
    }
},
{
    "id": "https://doi.org/10.1111/j.1365-2966.2012.21952.x",
    "value": {
        "label": "https://doi.org/10.1111/j.1365-2966.2012.21952.x",
        "viz$color": {
            "r": "255",
            "g": "0",
            "b": "0",
            "a": "0.8"
        },
        "viz$size": {
            "value": "80.10299956639811"
        }
    },
    "attributes": {
        "count": "3",
        "statut": "cité"
    }
},
{
    "id": "https://doi.org/10.1093/mnras/stt601",
    "value": {
        "label": "https://doi.org/10.1093/mnras/stt601",
        "viz$color": {
            "r": "0",
            "g": "0",
            "b": "255",
            "a": "0.8"
        },
        "viz$size": {
            "value": "65.05149978319906"
        },
        "targets": [
            {
                "id": "https://doi.org/10.1111/j.1365-2966.2012.21952.x"
            },
            {
                "id": "https://doi.org/10.1111/j.1365-2966.2012.20468.x"
            },
            {
                "id": "https://doi.org/10.1051/0004-6361/200811054"
            },
            {
                "id": "https://doi.org/10.1093/mnras/sts454"
            },
            {
                "id": "https://openalex.org/W3121968724"
            },
            {
                "id": "https://openalex.org/W3125762999"
            }
        ]
    },
    "attributes": {
        "count": "1",
        "statut": "citant"
    }
},
{
    "id": "https://doi.org/10.1051/0004-6361/201526952",
    "value": {
        "label": "https://doi.org/10.1051/0004-6361/201526952",
        "viz$color": {
            "r": "0",
            "g": "0",
            "b": "255",
            "a": "0.8"
        },
        "viz$size": {
            "value": "65.05149978319906"
        },
        "targets": [
            {
                "id": "https://doi.org/10.1111/j.1365-2966.2012.21952.x"
            },
            {
                "id": "https://doi.org/10.1111/j.1365-2966.2012.20468.x"
            },
            {
                "id": "https://doi.org/10.1086/157753"
            }
        ]
    },
    "attributes": {
        "count": "1",
        "statut": "citant"
    }
},
{
    "id": "https://doi.org/10.1111/j.1365-2966.2012.20468.x",
    "value": {
        "label": "https://doi.org/10.1111/j.1365-2966.2012.20468.x",
        "viz$color": {
            "r": "255",
            "g": "0",
            "b": "0",
            "a": "0.8"
        },
        "viz$size": {
            "value": "80.10299956639811"
        }
    },
    "attributes": {
        "count": "3",
        "statut": "cité"
    }
},
{
    "id": "https://doi.org/10.1086/157753",
    "value": {
        "label": "https://doi.org/10.1086/157753",
        "viz$color": {
            "r": "255",
            "g": "0",
            "b": "0",
            "a": "0.8"
        },
        "viz$size": {
            "value": "73.85606273598313"
        }
    },
    "attributes": {
        "count": "2",
        "statut": "cité"
    }
},
{
    "id": "https://doi.org/10.1051/0004-6361/200811054",
    "value": {
        "label": "https://doi.org/10.1051/0004-6361/200811054",
        "viz$color": {
            "r": "255",
            "g": "0",
            "b": "0",
            "a": "0.8"
        },
        "viz$size": {
            "value": "73.85606273598313"
        }
    },
    "attributes": {
        "count": "2",
        "statut": "cité"
    }
},
{
    "id": "https://doi.org/10.1093/mnras/sts454",
    "value": {
        "label": "https://doi.org/10.1093/mnras/sts454",
        "viz$color": {
            "r": "255",
            "g": "0",
            "b": "0",
            "a": "0.8"
        },
        "viz$size": {
            "value": "73.85606273598313"
        }
    },
    "attributes": {
        "count": "2",
        "statut": "cité"
    }
},
{
    "id": "https://openalex.org/W3121968724",
    "value": {
        "label": "https://openalex.org/W3121968724",
        "viz$color": {
            "r": "255",
            "g": "0",
            "b": "0",
            "a": "0.8"
        },
        "viz$size": {
            "value": "73.85606273598313"
        }
    },
    "attributes": {
        "count": "2",
        "statut": "cité"
    }
},
{
    "id": "https://openalex.org/W3125762999",
    "value": {
        "label": "https://openalex.org/W3125762999",
        "viz$color": {
            "r": "255",
            "g": "0",
            "b": "0",
            "a": "0.8"
        },
        "viz$size": {
            "value": "73.85606273598313"
        }
    },
    "attributes": {
        "count": "2",
        "statut": "cité"
    }
},
{
    "id": "https://doi.org/10.1093/mnras/stu771",
    "value": {
        "label": "https://doi.org/10.1093/mnras/stu771",
        "viz$color": {
            "r": "0",
            "g": "0",
            "b": "255",
            "a": "0.8"
        },
        "viz$size": {
            "value": "65.05149978319906"
        },
        "targets": [
            {
                "id": "https://doi.org/10.1111/j.1745-3933.2009.00636.x"
            },
            {
                "id": "https://doi.org/10.1086/323457"
            },
            {
                "id": "https://doi.org/10.1086/301213"
            }
        ]
    },
    "attributes": {
        "count": "1",
        "statut": "citant"
    }
},
{
    "id": "https://doi.org/10.1111/j.1745-3933.2009.00636.x",
    "value": {
        "label": "https://doi.org/10.1111/j.1745-3933.2009.00636.x",
        "viz$color": {
            "r": "255",
            "g": "0",
            "b": "0",
            "a": "0.8"
        },
        "viz$size": {
            "value": "65.05149978319906"
        }
    },
    "attributes": {
        "count": "1",
        "statut": "cité"
    }
},
{
    "id": "https://doi.org/10.1086/323457",
    "value": {
        "label": "https://doi.org/10.1086/323457",
        "viz$color": {
            "r": "255",
            "g": "0",
            "b": "0",
            "a": "0.8"
        },
        "viz$size": {
            "value": "65.05149978319906"
        }
    },
    "attributes": {
        "count": "1",
        "statut": "cité"
    }
},
{
    "id": "https://doi.org/10.1086/301213",
    "value": {
        "label": "https://doi.org/10.1086/301213",
        "viz$color": {
            "r": "255",
            "g": "0",
            "b": "0",
            "a": "0.8"
        },
        "viz$size": {
            "value": "65.05149978319906"
        }
    },
    "attributes": {
        "count": "1",
        "statut": "cité"
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
    "id": "https://doi.org/10.1093/mnras/stt274",
    "value": {
        "label": "https://doi.org/10.1093/mnras/stt274",
        "viz$color": {
            "r": "0",
            "g": "0",
            "b": "255",
            "a": "0.8"
        },
        "viz$size": {
            "value": "65.05149978319906"
        },
        "targets": [
            {
                "id": "https://doi.org/10.1111/j.1365-2966.2012.21952.x"
            },
            {
                "id": "https://doi.org/10.1111/j.1365-2966.2012.20468.x"
            },
            {
                "id": "https://doi.org/10.1086/157753"
            }
        ]
    },
    "attributes": {
        "count": "1",
        "statut": "citant"
    }
},
{
    "id": "https://doi.org/10.1111/j.1365-2966.2012.21952.x",
    "value": {
        "label": "https://doi.org/10.1111/j.1365-2966.2012.21952.x",
        "viz$color": {
            "r": "255",
            "g": "0",
            "b": "0",
            "a": "0.8"
        },
        "viz$size": {
            "value": "80.10299956639811"
        }
    },
    "attributes": {
        "count": "3",
        "statut": "cité"
    }
},
{
    "id": "https://doi.org/10.1093/mnras/stt601",
    "value": {
        "label": "https://doi.org/10.1093/mnras/stt601",
        "viz$color": {
            "r": "0",
            "g": "0",
            "b": "255",
            "a": "0.8"
        },
        "viz$size": {
            "value": "65.05149978319906"
        },
        "targets": [
            {
                "id": "https://doi.org/10.1111/j.1365-2966.2012.21952.x"
            },
            {
                "id": "https://doi.org/10.1111/j.1365-2966.2012.20468.x"
            }
        ]
    },
    "attributes": {
        "count": "1",
        "statut": "citant"
    }
},
{
    "id": "https://doi.org/10.1051/0004-6361/201526952",
    "value": {
        "label": "https://doi.org/10.1051/0004-6361/201526952",
        "viz$color": {
            "r": "0",
            "g": "0",
            "b": "255",
            "a": "0.8"
        },
        "viz$size": {
            "value": "65.05149978319906"
        },
        "targets": [
            {
                "id": "https://doi.org/10.1111/j.1365-2966.2012.21952.x"
            },
            {
                "id": "https://doi.org/10.1111/j.1365-2966.2012.20468.x"
            },
            {
                "id": "https://doi.org/10.1086/157753"
            }
        ]
    },
    "attributes": {
        "count": "1",
        "statut": "citant"
    }
},
{
    "id": "https://doi.org/10.1111/j.1365-2966.2012.20468.x",
    "value": {
        "label": "https://doi.org/10.1111/j.1365-2966.2012.20468.x",
        "viz$color": {
            "r": "255",
            "g": "0",
            "b": "0",
            "a": "0.8"
        },
        "viz$size": {
            "value": "80.10299956639811"
        }
    },
    "attributes": {
        "count": "3",
        "statut": "cité"
    }
},
{
    "id": "https://doi.org/10.1086/157753",
    "value": {
        "label": "https://doi.org/10.1086/157753",
        "viz$color": {
            "r": "255",
            "g": "0",
            "b": "0",
            "a": "0.8"
        },
        "viz$size": {
            "value": "73.85606273598313"
        }
    },
    "attributes": {
        "count": "2",
        "statut": "cité"
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
xpath "//*[name()='node']" count >= 6 # 14 in reality, hurl bug ?
xpath "//*[name()='edge']" count >= 8 # 19 in reality
# ```xml
# <gexf xmlns:viz="http://www.gexf.net/1.2draft/viz" xmlns="http://www.gexf.net/1.2draft" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gexf.net/1.2draft http://www.gexf.net/1.2draft/gexf.xsd" version="1.2">
#   <meta lastmodifieddate="2025-11-18">
#     <creator>NetworkX 3.2.1</creator>
#   </meta>
#   <graph defaultedgetype="directed" mode="static" name="">
#     <attributes mode="static" class="node">
#       <attribute id="0" title="count" type="long" />
#       <attribute id="1" title="statut" type="string" />
#     </attributes>
#     <nodes>
#       <node id="https://doi.org/10.1093/mnras/stt274" label="https://doi.org/10.1093/mnras/stt274">
#         <viz:color r="0" g="0" b="255" a="0.8" />
#         <viz:size value="65.05149978319906" />
#         <attvalues>
#           <attvalue for="0" value="1" />
#           <attvalue for="1" value="citant" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1111/j.1365-2966.2012.21952.x" label="https://doi.org/10.1111/j.1365-2966.2012.21952.x">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="80.10299956639811" />
#         <attvalues>
#           <attvalue for="0" value="3" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1093/mnras/stt601" label="https://doi.org/10.1093/mnras/stt601">
#         <viz:color r="0" g="0" b="255" a="0.8" />
#         <viz:size value="65.05149978319906" />
#         <attvalues>
#           <attvalue for="0" value="1" />
#           <attvalue for="1" value="citant" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1051/0004-6361/201526952" label="https://doi.org/10.1051/0004-6361/201526952">
#         <viz:color r="0" g="0" b="255" a="0.8" />
#         <viz:size value="65.05149978319906" />
#         <attvalues>
#           <attvalue for="0" value="1" />
#           <attvalue for="1" value="citant" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1111/j.1365-2966.2012.20468.x" label="https://doi.org/10.1111/j.1365-2966.2012.20468.x">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="80.10299956639811" />
#         <attvalues>
#           <attvalue for="0" value="3" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1086/157753" label="https://doi.org/10.1086/157753">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="73.85606273598313" />
#         <attvalues>
#           <attvalue for="0" value="2" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1051/0004-6361/200811054" label="https://doi.org/10.1051/0004-6361/200811054">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="73.85606273598313" />
#         <attvalues>
#           <attvalue for="0" value="2" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1093/mnras/sts454" label="https://doi.org/10.1093/mnras/sts454">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="73.85606273598313" />
#         <attvalues>
#           <attvalue for="0" value="2" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://openalex.org/W3121968724" label="https://openalex.org/W3121968724">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="73.85606273598313" />
#         <attvalues>
#           <attvalue for="0" value="2" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://openalex.org/W3125762999" label="https://openalex.org/W3125762999">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="73.85606273598313" />
#         <attvalues>
#           <attvalue for="0" value="2" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1093/mnras/stu771" label="https://doi.org/10.1093/mnras/stu771">
#         <viz:color r="0" g="0" b="255" a="0.8" />
#         <viz:size value="65.05149978319906" />
#         <attvalues>
#           <attvalue for="0" value="1" />
#           <attvalue for="1" value="citant" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1111/j.1745-3933.2009.00636.x" label="https://doi.org/10.1111/j.1745-3933.2009.00636.x">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="65.05149978319906" />
#         <attvalues>
#           <attvalue for="0" value="1" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1086/323457" label="https://doi.org/10.1086/323457">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="65.05149978319906" />
#         <attvalues>
#           <attvalue for="0" value="1" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#       <node id="https://doi.org/10.1086/301213" label="https://doi.org/10.1086/301213">
#         <viz:color r="255" g="0" b="0" a="0.8" />
#         <viz:size value="65.05149978319906" />
#         <attvalues>
#           <attvalue for="0" value="1" />
#           <attvalue for="1" value="cit&#233;" />
#         </attvalues>
#       </node>
#     </nodes>
#     <edges>
#       <edge source="https://doi.org/10.1093/mnras/stt274" target="https://doi.org/10.1111/j.1365-2966.2012.21952.x" id="0" />
#       <edge source="https://doi.org/10.1093/mnras/stt274" target="https://doi.org/10.1111/j.1365-2966.2012.20468.x" id="1" />
#       <edge source="https://doi.org/10.1093/mnras/stt274" target="https://doi.org/10.1086/157753" id="2" />
#       <edge source="https://doi.org/10.1093/mnras/stt274" target="https://doi.org/10.1051/0004-6361/200811054" id="3" />
#       <edge source="https://doi.org/10.1093/mnras/stt274" target="https://doi.org/10.1093/mnras/sts454" id="4" />
#       <edge source="https://doi.org/10.1093/mnras/stt274" target="https://openalex.org/W3121968724" id="5" />
#       <edge source="https://doi.org/10.1093/mnras/stt274" target="https://openalex.org/W3125762999" id="6" />
#       <edge source="https://doi.org/10.1093/mnras/stt601" target="https://doi.org/10.1111/j.1365-2966.2012.21952.x" id="7" />
#       <edge source="https://doi.org/10.1093/mnras/stt601" target="https://doi.org/10.1111/j.1365-2966.2012.20468.x" id="8" />
#       <edge source="https://doi.org/10.1093/mnras/stt601" target="https://doi.org/10.1051/0004-6361/200811054" id="9" />
#       <edge source="https://doi.org/10.1093/mnras/stt601" target="https://doi.org/10.1093/mnras/sts454" id="10" />
#       <edge source="https://doi.org/10.1093/mnras/stt601" target="https://openalex.org/W3121968724" id="11" />
#       <edge source="https://doi.org/10.1093/mnras/stt601" target="https://openalex.org/W3125762999" id="12" />
#       <edge source="https://doi.org/10.1051/0004-6361/201526952" target="https://doi.org/10.1111/j.1365-2966.2012.21952.x" id="13" />
#       <edge source="https://doi.org/10.1051/0004-6361/201526952" target="https://doi.org/10.1111/j.1365-2966.2012.20468.x" id="14" />
#       <edge source="https://doi.org/10.1051/0004-6361/201526952" target="https://doi.org/10.1086/157753" id="15" />
#       <edge source="https://doi.org/10.1093/mnras/stu771" target="https://doi.org/10.1111/j.1745-3933.2009.00636.x" id="16" />
#       <edge source="https://doi.org/10.1093/mnras/stu771" target="https://doi.org/10.1086/323457" id="17" />
#       <edge source="https://doi.org/10.1093/mnras/stu771" target="https://doi.org/10.1086/301213" id="18" />
#     </edges>
#   </graph>
# </gexf>
# ```