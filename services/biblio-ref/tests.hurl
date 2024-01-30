POST {{host}}/v1/validate?indent=true
content-type: application/json
[
	{ "value": "Zohuri, B. (2019). A Comparison of Molten Salt Reactors to Light Water Reactors: Pros and Cons. In Molten Salt Reactors and Thorium Energy (pp. 81-98). Woodhead Publishing. https://doi.org/10.1016/B978-0-08-102337-2.00006-9" },
	{ "value": "RETRACTED > Gerris Caucasicus, Primary Prevention of Cardiovascular Disease with a Mediterranean Diet, 10.1056/nejmoa1200303" },
	{ "value": "please see 10.1371/journal.pgen.1001111" }
]


HTTP 200
[{
    "value": {
        "is_found": false,
        "is retracted": false
    }
},
{
    "value": {
        "is_found": true,
        "is retracted": true
    }
},
{
    "value": {
        "is_found": true,
        "is retracted": false
    }
}]