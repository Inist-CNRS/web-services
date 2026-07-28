# Pour des raisons de temps de traitement, les PDF ont été réduits aux seules pages contenant des textes suspects.
# Les premières pages ont toutefois été conservées afin de permettre de remonter jusqu’au PDF d’origine.

# Cas pdfPlumber : Texte hors des limites de la page
POST {{host}}/v1/hiddentext?indent=true
Content-Type: application/pdf
[Options]
skip: {{blocked}}
file,examples/example_outside_page.pdf;

HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$[0].value" exists
jsonpath "$[0].value[0]['Page']" exists
jsonpath "$[0].value[0]['Texte_suspect']" exists
jsonpath "$[0].value[0].Motif" exists
jsonpath "$[0].value[0].Motif[0]" == "Texte hors des limites de la page"

jsonpath "$[0].value[1]['Page']" exists
jsonpath "$[0].value[1]['Texte_suspect']" exists
jsonpath "$[0].value[1].Motif" exists
jsonpath "$[0].value[1].Motif[0]" == "Texte hors des limites de la page"

# Cas pdfPlumber : Texte blanc sur fond blanc et taille du texte minuscule 
POST {{host}}/v1/hiddentext?indent=true
Content-Type: application/pdf
[Options]
skip: {{blocked}}
file,examples/example_white_and_size.pdf;

HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$[0].value" exists
jsonpath "$[0].value[0]['Page']" exists
jsonpath "$[0].value[0]['Texte_suspect']" exists
jsonpath "$[0].value[0].Motif" exists
jsonpath "$[0].value[0].Motif[0]" == "Taille du texte minuscule (0.01pt)"

jsonpath "$[0].value[1]['Page']" exists
jsonpath "$[0].value[1]['Texte_suspect']" exists
jsonpath "$[0].value[1].Motif" exists
jsonpath "$[0].value[1].Motif[0]" == "Texte blanc sur fond blanc"

# Cas pyMuPDF : Texte noir caché sous une image opaque
POST {{host}}/v1/hiddentext?indent=true
Content-Type: application/pdf
[Options]
skip: {{blocked}}
file,examples/example_hidden_image_ia_generated.pdf;

HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$[0].value" exists
jsonpath "$[0].value[0]['Page']" exists
jsonpath "$[0].value[0]['Texte_suspect']" exists
jsonpath "$[0].value[0].Motif" exists
jsonpath "$[0].value[0].Motif[0]" == "Texte noir caché sous une image opaque"

jsonpath "$[0].value[1]['Page']" exists
jsonpath "$[0].value[1]['Texte_suspect']" exists
jsonpath "$[0].value[1].Motif" exists
jsonpath "$[0].value[1].Motif[0]" == "Texte noir caché sous une image opaque"

jsonpath "$[0].value[2]['Page']" exists
jsonpath "$[0].value[2]['Texte_suspect']" exists
jsonpath "$[0].value[2].Motif" exists
jsonpath "$[0].value[2].Motif[0]" == "Texte noir caché sous une image opaque"

# Cas pyMuPDF : Texte noir avec une opacité trop faible
POST {{host}}/v1/hiddentext?indent=true
Content-Type: application/pdf
[Options]
skip: {{blocked}}
file,examples/example_opacity.pdf;

HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$[0].value" exists
jsonpath "$[0].value[0]['Page']" exists
jsonpath "$[0].value[0]['Texte_suspect']" exists
jsonpath "$[0].value[0].Motif" exists
jsonpath "$[0].value[0].Motif[0]" == "Texte noir avec une opacité trop faible"

jsonpath "$[0].value[1]['Page']" exists
jsonpath "$[0].value[1]['Texte_suspect']" exists
jsonpath "$[0].value[1].Motif" exists
jsonpath "$[0].value[1].Motif[0]" == "Texte noir avec une opacité trop faible"

jsonpath "$[0].value[2]['Page']" exists
jsonpath "$[0].value[2]['Texte_suspect']" exists
jsonpath "$[0].value[2].Motif" exists
jsonpath "$[0].value[2].Motif[0]" == "Texte noir avec une opacité trop faible"