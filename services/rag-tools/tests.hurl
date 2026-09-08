# ==============================
# Embedding
# ==============================

POST {{host}}/v1/embedding
content-type: application/json
[
	{
		"id": "embed_001",
		"value": "Quelles sont les principales caractéristiques de Jupiter ?"
	}
]

HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$[0].id" == "embed_001"
jsonpath "$[0].value.vector" count > 0


# ==============================
# Embedding API
# ==============================

#POST {{host}}/v1/embedding_api
#content-type: application/json
#[
#	{
#		"id": "embed_001",
#		"value": "Quelles sont les principales caractéristiques de Jupiter ?"
#	}
#]
#
#HTTP 200
#Content-Type: application/json
#[Asserts]
#jsonpath "$[0].id" == "embed_001"
#jsonpath "$[0].value.vector" count > 0


# ==============================
# Reformulate
# ==============================

POST {{host}}/v1/reformulate
content-type: application/json
[
	{
		"id": "reformulate_001",
		"value": {
			"question": "Et Saturne, elle a les mêmes caractéristiques ?",
			"historique": [
				{
					"role": "user",
					"content": "Quelles sont les principales caractéristiques de Jupiter ?"
				},
				{
					"role": "assistant",
					"content": "Jupiter est la plus grande planète du système solaire. C'est une géante gazeuse composée principalement d'hydrogène et d'hélium, connue pour sa Grande Tache Rouge [Document 1]."
				}
			]
		}
	}
]

HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$[0].id" == "reformulate_001"
jsonpath "$[0].value" contains "Saturne"
jsonpath "$[0].value" not contains "Et Saturne, elle a les mêmes caractéristiques ?"


# ==============================
# Rerank
# ==============================

POST {{host}}/v1/rerank
content-type: application/json
[
	{
		"id": "rerank_001",
		"value": {
			"question": "Quels articles portent sur la résistance aux antibiotiques chez Escherichia coli ?",
			"documents": [
				{
					"text": "Mercure est la planète la plus proche du Soleil. Elle effectue une révolution autour du Soleil en environ 88 jours.",
					"metadata": {
						"titre": "Le système solaire interne",
						"date_publication": "2019"
					}
				},
				{
					"text": "Objectives To characterize the naturally occurring expanded-spectrum β-lactamase from an Escherichia coli clinical isolate...",
					"metadata": {
						"titre": "Extension of the hydrolysis spectrum of AmpC β-lactamase of Escherichia coli due to amino acid insertion in the H-10 helix",
						"auteurs": ["Hedi Mammeri", "Laurent Poirel", "Patrice Nordmann"],
						"date_publication": "2007",
						"journal": "Journal of Antimicrobial Chemotherapy",
						"doi": "10.1093/jac/dkm227"
					}
				},
				{
					"text": "Mars est surnommée la planète rouge à cause de l'oxyde de fer présent à sa surface.",
					"metadata": {
						"titre": "Exploration martienne",
						"date_publication": "2021"
					}
				}
			],
			"top_n": 1
		}
	}
]

HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$[0].id" == "rerank_001"
jsonpath "$[0].value.documents" count == 1
jsonpath "$[0].value.documents[0].metadata.doi" == "10.1093/jac/dkm227"


# ==============================
# RAG
# ==============================

POST {{host}}/v1/rag
content-type: application/json
[
	{
		"id": "rag_001",
		"value": {
			"question": "Qui sont les auteurs de l'article sur l'AmpC β-lactamase et dans quelle revue a-t-il été publié ?",
			"documents": [
				{
					"id": "doi:10.1093/jac/dkm227#abstract",
					"text": "Objectives To characterize the naturally occurring expanded-spectrum β-lactamase from an Escherichia coli clinical isolate...",
					"metadata": {
						"titre": "Extension of the hydrolysis spectrum of AmpC β-lactamase of Escherichia coli due to amino acid insertion in the H-10 helix",
						"auteurs": ["Hedi Mammeri", "Laurent Poirel", "Patrice Nordmann"],
						"date_publication": "2007",
						"journal": "Journal of Antimicrobial Chemotherapy",
						"doi": "10.1093/jac/dkm227"
					}
				}
			],
			"historique": []
		}
	}
]

HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$[0].id" == "rag_001"
jsonpath "$[0].value.answer" contains "Mammeri"
jsonpath "$[0].value.answer" contains "Journal of Antimicrobial Chemotherapy"
jsonpath "$[0].value.answer" contains "[doi:10.1093/jac/dkm227#abstract]"
