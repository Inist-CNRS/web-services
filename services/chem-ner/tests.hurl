POST {{host}}/v1/chem/tagger?indent=true
content-type: application/json
[
	{ 
		"id":1,
		"value": "This is three chemical name entity: methanol, 2-propanol, or CO2" }
]


HTTP 200
[{
    "id": 1,
    "value": {
        "chemical": [
            "methanol",
            "2-propanol",
            "CO2"
        ],
        "chemical_disambiguisate": [
            "methanol",
            "propan-2-ol"
        ]
    }
}]