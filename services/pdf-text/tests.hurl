POST {{host}}/v1/pdf2txt?indent=true
content-type: application/json
[
	{"id":1,"value":"https://hal.science/hal-01990444v1/file/EGC_2019.pdf"}
]


HTTP 200
[Asserts]
jsonpath "$[0].value" startsWith "LODEX : des données structurées"
jsonpath "$[0].value" matches /^.{6500,7500}$/
