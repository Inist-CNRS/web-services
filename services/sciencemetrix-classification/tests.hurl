POST {{host}}/v1/classif?indent=true
content-type: application/json
[
	{"id": "1", "value": "Anatomical comparison between compression wood and opposite wood in a branch of korean pine pinus koraiensis compression wood and opposite wood formed in the branch of korean pine pinus koraiensis s et z is described and compared in qualitative and quantitative anatomical aspects" },
	{"id": "2", "value": "This abstract is to short"}
]


HTTP 200
[{
    "id": "1",
    "value": {
        "classif": [
            "Applied Sciences",
            "Agriculture, Fisheries & Forestry",
            "Forestry"
        ]
    }
},
{
    "id": "2",
    "value": {
        "classif": [
            "",
            "",
            ""
        ]
    }
}]