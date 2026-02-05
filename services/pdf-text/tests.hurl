POST {{host}}/v1/pdf2txt?indent=true
content-type: application/json
[
	{"id":1,"value":"https://hal.science/hal-01990444v1/file/EGC_2019.pdf"}
]


HTTP 200
[Asserts]
jsonpath "$[0].value" startsWith "LODEX : des données structurées"
jsonpath "$[0].value" matches /^.{6500,10100}$/

#########
POST {{host}}/v1/pdf-raw?indent=true
content-type: application/pdf
file,./article.pdf;

HTTP 200
[Asserts]
jsonpath "$[0].value" startsWith "Systèmes d’écriture et qualité des données"

#########
POST {{host}}/v1/grobid
content-type: application/pdf
[Options]
skip: {{blocked}}
file,./article.pdf;

HTTP 200
[Asserts]
xpath "/*[name()='TEI']" exists
xpath "//*[name()='teiHeader']" exists
xpath "//*[name()='titleStmt']/*[name()='title']" exists
