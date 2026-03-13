POST {{host}}/v1/hiddentext?indent=true
Content-Type: application/pdf
[Options]
skip: {{blocked}}
file,example.pdf;

HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$[0].value" exists
jsonpath "$[0].value['10']" exists
jsonpath "$[0].value['10'][0]['Texte suspect']" exists
jsonpath "$[0].value['10'][0].Motif" exists
jsonpath "$[0].value['10'][0].Motif[0]" == "Texte hors des limites de la page"
jsonpath "$[0].value['12']" exists
jsonpath "$[0].value['12'][0]['Texte suspect']" exists
jsonpath "$[0].value['12'][0].Motif" exists
jsonpath "$[0].value['12'][0].Motif[0]" == "Texte hors des limites de la page"