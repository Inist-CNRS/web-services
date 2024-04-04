POST {{host}}/v1/diseases/tagger?indent=true
content-type: application/json
[
	{
		"id":1,
		"value": "They have been used in the prevention and treatment of malaria and autoimmune diseases, including systemic lupus erythematosus and rheumatoid arthritis." 
	}
]


HTTP 200
[{
    "id": 1,
    "value": {
        "diseases": [
            "malaria",
            "autoimmune diseases",
            "systemic lupus erythematosus",
            "rheumatoid arthritis"
        ]
    }
}]