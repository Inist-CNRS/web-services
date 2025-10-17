# WARNING: This file was not generated, but manually written.
# DON'T OVERWRITE IT
# Use it to test:
# npx hurl --test data-computer/tests.hurl


POST {{host}}/v1/rapido-algorithme
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,example-xml-rapido.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists


POST {{host}}/v1/retrieve-json?indent=true
content-type: application/json
[Options]
delay: 30000
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
[[
    {
        "idArticle": "bch_0007-4217_2003_num_127_2_9424",
        "title": "Aséa",
        "sites": [],
        "entite": [
            {
                "name": "ville basse",
                "occurences": [
                    {
                        "page": "bch_0007-4217_2003_num_127_2_T1_0778_0000",
                        "text": " papamarinopoulos ( université de patras ) ont entrepris un projet commun de prospection géophysique dans la **ville basse** d' aséa dans le but de retrouver les sections de l' enceinte recouverte par une couche d' alluvions stériles déposées par l' alphée ."
                    }
                ],
                "notices": [
                    {
                        "notice": "https://www.idref.fr/192337963",
                        "score": "0.730"
                    }
                ]
            },
            {
                "name": "patras",
                "occurences": [
                    {
                        "page": "bch_0007-4217_2003_num_127_2_T1_0778_0000",
                        "text": " papamarinopoulos ( université de **patras** ) ont entrepris un projet commun de prospection géophysique dans la ville basse d' aséa dans le but de retrouver les sections de l' enceinte recouverte par une couche d' alluvions stériles déposées par l' alphée ."
                    },
                    {
                        "page": "bch_0007-4217_2003_num_127_2_T1_0778_0000",
                        "text": " les données recueillies en 2002 ont été traitées au laboratoire de géophysique du département de géologie de l' université de **patras** ."
                    }
                ],
                "notices": [
                    {
                        "notice": "https://www.idref.fr/050189484",
                        "score": "0.744"
                    },
                    {
                        "notice": "https://www.idref.fr/153708638",
                        "score": "0.912"
                    }
                ]
            }
        ]
    }
]]


POST {{host}}/v1/rapido-apprentissage
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,example-xml-rapido.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists


POST {{host}}/v1/retrieve-json?indent=true
content-type: application/json
[Options]
delay: 40000
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
[[
    {
        "idArticle": "bch_0007-4217_2003_num_127_2_9424",
        "title": "Aséa",
        "sites": [],
        "entite": [
            {
                "name": "ASÉA",
                "occurences": [
                    {
                        "page": "bch_0007-4217_2003_num_127_2_T1_0778_0000",
                        "entity_score": "0.415",
                        "text": " **ASÉA** Travaux de l' Institut suédois  ."
                    }
                ],
                "notices": [
                    {
                        "notice": "None(apprentissage)",
                        "score": "None"
                    }
                ]
            },
            {
                "name": "Aséa",
                "occurences": [
                    {
                        "page": "bch_0007-4217_2003_num_127_2_T1_0778_0000",
                        "entity_score": "0.766",
                        "text": " Papamarinopoulos ( université de Patras ) ont entrepris un projet commun de prospection géophysique dans la ville basse d' **Aséa** dans le but de retrouver les sections de l' enceinte recouverte par une couche d' alluvions stériles déposées par l' Alphée  ."
                    },
                    {
                        "page": "Title",
                        "entity_score": "0.487",
                        "text": " **Aséa** ."
                    }
                ],
                "notices": [
                    {
                        "notice": "None(apprentissage)",
                        "score": "None"
                    }
                ]
            },
            {
                "name": "Mégalopolis",
                "occurences": [
                    {
                        "page": "bch_0007-4217_2003_num_127_2_T1_0778_0000",
                        "entity_score": "0.827",
                        "text": " Parmi les découvertes les plus importantes , on signale l' identification probable d' une tour carrée au Sud-Est de la route de **Mégalopolis**  ."
                    },
                    {
                        "page": "bch_0007-4217_2003_num_127_2_T1_0778_0000",
                        "entity_score": "0.609",
                        "text": " Des vestiges appartenant sans doute à la porte principale de **Mégalopolis** ont été localisés juste au Nord de la route moderne , qui passe donc sans doute au-dessus de la route antique reliant **Mégalopolis** à Τ égée  ."
                    },
                    {
                        "page": "bch_0007-4217_2003_num_127_2_T1_0778_0000",
                        "entity_score": "0.935",
                        "text": " Des vestiges appartenant sans doute à la porte principale de **Mégalopolis** ont été localisés juste au Nord de la route moderne , qui passe donc sans doute au-dessus de la route antique reliant **Mégalopolis** à Τ égée  ."
                    }
                ],
                "notices": [
                    {
                        "notice": "None(apprentissage)",
                        "score": "None"
                    }
                ]
            },
            {
                "name": "égée",
                "occurences": [
                    {
                        "page": "bch_0007-4217_2003_num_127_2_T1_0778_0000",
                        "entity_score": "0.652",
                        "text": " Des vestiges appartenant sans doute à la porte principale de Mégalopolis ont été localisés juste au Nord de la route moderne , qui passe donc sans doute au-dessus de la route antique reliant Mégalopolis à Τ **égée**  ."
                    }
                ],
                "notices": [
                    {
                        "notice": "None(apprentissage)",
                        "score": "None"
                    }
                ]
            }
        ]
    }
]]