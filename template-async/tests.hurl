## Principes
#
# Les services web asynchrones nécessitent plusieurs appels pour être testés:
#
# - l'appel du traitement (qui nécessite généralement l'envoi d'un corpus sous
#   forme de .tar.gz)
# - l'appel du résultat (au bout d'un temps suffisant pour que le traitement
#   soit terminé)
#
# À la fin de l'appel du traitement, on récupère l'identifiant du traitement
# dans computing_token.
# C'est la variable qui servira à la route de retrieve pour savoir quel résultat
# retourner.
#
# On peut tester plusieurs routes de retrieve sans avoir besoin de relancer le
# traitement.
#
# Les assertions à écrire sont celles du retrieve, qui vérifie que le résultat a
# bien la forme et/ou les valeurs attendues.
# Voir la documentation de Hurl pour ça:
# https://hurl.dev/docs/asserting-response.html#json-body
#
## Usage
# npm run test:local {service}
# npm run test:remote {service}

##################################################
## treatment
##################################################
POST {{host}}/v1/treatment-route
content-type: application/x-tar
# x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,example.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists


POST {{host}}/v1/retrieve-json?indent=true
content-type: application/json
[Options]
delay:60000
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
[Asserts]
jsonpath "$[0].value[0].entity" == "Geneva"
jsonpath "$[0].value[0].alignment" count > 0
jsonpath "$[0].value[0].alignment[0]" contains "geonames.org"
jsonpath "$[0].value[2].entity" == "Paris"
jsonpath "$[0].value[2].alignment" count > 0
jsonpath "$[0].value[2].alignment[0]" contains "geonames.org"