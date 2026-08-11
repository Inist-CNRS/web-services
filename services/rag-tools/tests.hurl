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
			"question": "Saturne est-elle aussi une géante gazeuse comme Jupiter ?",
			"documents": [
				"Mercure est la planète la plus proche du Soleil. Elle effectue une révolution autour du Soleil en environ 88 jours.",
				"Saturne est célèbre pour son vaste système d'anneaux composé principalement de glace et de poussières.",
				"Saturne est la deuxième plus grande planète du système solaire après Jupiter.",
				"Mars est surnommée la planète rouge à cause de l'oxyde de fer présent à sa surface."
			],
			"top_n": 2
		}
	}
]

HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$[0].id" == "rerank_001"
jsonpath "$[0].value.documents" count == 2
jsonpath "$[0].value.documents[0]" contains "Saturne"


# ==============================
# RAG
# ==============================

POST {{host}}/v1/rag
content-type: application/json
[
	{
		"id": "rag_001",
		"value": {
			"question": "Et Saturne, elle a les mêmes caractéristiques ?",
			"documents": [
				"Saturne est célèbre pour son vaste système d'anneaux composé principalement de glace et de poussières.",
				"Saturne est la deuxième plus grande planète du système solaire après Jupiter."
			],
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
jsonpath "$[0].id" == "rag_001"
jsonpath "$[0].value.answer" contains "[Document"
jsonpath "$[0].value.answer" contains "Saturne"
