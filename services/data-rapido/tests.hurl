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


POST {{host}}/v1/rapido-italie
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,example-xml-italie.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists


POST {{host}}/v1/retrieve-json?indent=true
content-type: application/json
[Options]
delay: 60000
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
        "idArticle": "efr_0000-0000_1983_act_67_1_2469",
        "title": "Aspetti della romanizzazione della Sicilia",
        "sites": [
            "italie"
        ],
        "entite": [
            {
                "name": "sabucina",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0349_0000",
                        "entity_score": "0.351",
                        "text": " **sabucina**  ."
                    }
                ],
                "notices": [
                    {
                        "notice": "https://www.idref.fr/235633100",
                        "score": "0.889"
                    }
                ]
            },
            {
                "name": "agrigento",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0354_0000",
                        "entity_score": "0.761",
                        "text": " un fenomeno simile non avviene per l' altra grande colonia greca , **agrigento**  ."
                    },
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0374_0000",
                        "entity_score": "0.459",
                        "text": " **agrigento**  ."
                    }
                ],
                "notices": [
                    {
                        "notice": "https://www.idref.fr/159174635",
                        "score": "0.629"
                    },
                    {
                        "notice": "https://www.idref.fr/147950724",
                        "score": "0.602"
                    },
                    {
                        "notice": "https://www.idref.fr/081878885",
                        "score": "0.581"
                    },
                    {
                        "notice": "https://www.idref.fr/223732117",
                        "score": "0.629"
                    },
                    {
                        "notice": "https://www.idref.fr/027417158",
                        "score": "0.602"
                    }
                ]
            },
            {
                "name": "lecce",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0360_0000",
                        "entity_score": "0.427",
                        "text": " un uso che è presente anche a reggio e a **lecce** , e che si riscontra a pompei e a pietrabbondante75  ."
                    }
                ],
                "notices": [
                    {
                        "notice": "https://www.idref.fr/19733489X",
                        "score": "0.666"
                    },
                    {
                        "notice": "https://www.idref.fr/242218008",
                        "score": "0.666"
                    },
                    {
                        "notice": "https://www.idref.fr/204513073",
                        "score": "0.666"
                    },
                    {
                        "notice": "https://www.idref.fr/034892702",
                        "score": "0.834"
                    },
                    {
                        "notice": "https://www.idref.fr/027528448",
                        "score": "0.834"
                    }
                ]
            },
            {
                "name": "pompei",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0360_0000",
                        "entity_score": "0.479",
                        "text": " un uso che è presente anche a reggio e a lecce , e che si riscontra a **pompei** e a pietrabbondante75  ."
                    }
                ],
                "notices": [
                    {
                        "notice": "https://www.idref.fr/172632951",
                        "score": "0.618"
                    },
                    {
                        "notice": "https://www.idref.fr/229078524",
                        "score": "0.682"
                    },
                    {
                        "notice": "https://www.idref.fr/033851697",
                        "score": "0.618"
                    },
                    {
                        "notice": "https://www.idref.fr/032308957",
                        "score": "0.645"
                    }
                ]
            },
            {
                "name": "eraclea",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0361_0000",
                        "entity_score": "0.484",
                        "text": " compare anche **eraclea** , come caso isolato  : va messo probabilmente in relazione con l' artificiale , e non riuscito tentativo di rivitalizzare questo centro con la deduzione della colonia di rupilio78  ."
                    }
                ],
                "notices": [
                    {
                        "notice": "https://www.idref.fr/030379296",
                        "score": "0.768"
                    }
                ]
            },
            {
                "name": "taormina",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0373_0000",
                        "entity_score": "0.660",
                        "text": "141 ; ad halaesa , muntcipium augusteo , tra ii e iii142 ; a terme , colonia ; soprattutto a catania , colonia , e a **taormina** , colonia143  ."
                    }
                ],
                "notices": [
                    {
                        "notice": "https://www.idref.fr/030715822",
                        "score": "0.707"
                    },
                    {
                        "notice": "https://www.idref.fr/120942275",
                        "score": "0.801"
                    }
                ]
            },
            {
                "name": "tarente",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0376_0000",
                        "entity_score": "0.640",
                        "text": " pierre leveque  : un problème très important , sur lequel d' anciennes communications à **tarente** attiraient déjà l' attention , c'est celui de l' espace dans lequel s'opèrent ces contacts , ces transformations , ces acculturations  ."
                    }
                ],
                "notices": [
                    {
                        "notice": "https://www.idref.fr/028140796",
                        "score": "0.834"
                    },
                    {
                        "notice": "https://www.idref.fr/02744239X",
                        "score": "0.666"
                    },
                    {
                        "notice": "https://www.idref.fr/151930961",
                        "score": "0.723"
                    },
                    {
                        "notice": "https://www.idref.fr/097603724",
                        "score": "0.629"
                    },
                    {
                        "notice": "https://www.idref.fr/152128808",
                        "score": "0.602"
                    }
                ]
            },
            {
                "name": "italie",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0376_0000",
                        "entity_score": "0.518",
                        "text": " l' **italie** avec les grandes îles adjacentes apparaît elle-même comme un ensemble ( au sens mathématique du terme ) très hétérogène avec des peuples , des cités entre lesquels les décalages des niveaux de développement sont considérables  ."
                    }
                ],
                "notices": [
                    {
                        "notice": "https://www.idref.fr/027235408",
                        "score": "1.00"
                    }
                ]
            },
            {
                "name": "brindisi",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0377_0000",
                        "entity_score": "0.828",
                        "text": " celui de ce petit établissement de **brindisi** dans la seconde moitié du 7e , qui va vite se fondre dans la communauté iapyge  ."
                    }
                ],
                "notices": [
                    {
                        "notice": "https://www.idref.fr/033755744",
                        "score": "0.873"
                    },
                    {
                        "notice": "https://www.idref.fr/181403404",
                        "score": "0.668"
                    },
                    {
                        "notice": "https://www.idref.fr/030852277",
                        "score": "0.762"
                    }
                ]
            },
            {
                "name": "Vassallaggi",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0349_0000",
                        "entity_score": "0.535",
                        "text": " **Vassallaggi**  ."
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
                "name": "Gibil Gabib",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0349_0000",
                        "entity_score": "0.916",
                        "text": " **Gibil Gabib**  ."
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
                "name": "Falarion",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0349_0000",
                        "entity_score": "0.870",
                        "text": " Desusino ( **Falarion** ? )  ."
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
                "name": "Heirkte",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0349_0000",
                        "entity_score": "0.343",
                        "text": " Pellegrino ( Heirkte? )  ."
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
                "name": "Azonai",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0349_0000",
                        "entity_score": "0.770",
                        "text": " Rocca Nadore ( Azonai? )  ."
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
                "name": "Adranone",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0349_0000",
                        "entity_score": "0.850",
                        "text": " Adra- none ( Adranone? )  ."
                    },
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0369_0000",
                        "entity_score": "0.591",
                        "text": " **Adranone**  ."
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
                "name": "Mitistrato",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0349_0000",
                        "entity_score": "0.635",
                        "text": " Castellazzo di Marianopoli ( Mitistrato? )  ."
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
                "name": "Alburchia",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0349_0000",
                        "entity_score": "0.452",
                        "text": " **Alburchia**  ."
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
                "name": "Lilibeo",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0352_0000",
                        "entity_score": "0.550",
                        "text": " A **Lilibeo** , come risulta dalle numerose campagne di scavo della di Stefano29 , nel corso del II secolo a ."
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
                "name": "Abaceno",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0358_0000",
                        "entity_score": "0.474",
                        "text": " **Abaceno**  ."
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
                "name": "Camarina",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0358_0000",
                        "entity_score": "0.417",
                        "text": " **Camarina**  ."
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
                "name": "Ibla Palikion",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0358_0000",
                        "entity_score": "0.709",
                        "text": " **Ibla Palikion** )  ."
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
                "name": "Reggio",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0360_0000",
                        "entity_score": "0.470",
                        "text": " Un uso che è presente anche a **Reggio** e a Lecce , e che si riscontra a Pompei e a Pietrabbondante75  ."
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
                "name": "Mirone",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0363_0000",
                        "entity_score": "0.979",
                        "text": " Non mi riferisco ovviamente a quelle attribuite a **Mirone** , Policleto , Silanione etc ."
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
                "name": "Policleto",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0363_0000",
                        "entity_score": "0.984",
                        "text": " Non mi riferisco ovviamente a quelle attribuite a Mirone , **Policleto** , Silanione etc ."
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
                "name": "Silanione",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0363_0000",
                        "entity_score": "0.930",
                        "text": " Non mi riferisco ovviamente a quelle attribuite a Mirone , Policleto , **Silanione** etc ."
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
                "name": "Pelagatti",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0368_0000",
                        "entity_score": "0.984",
                        "text": " **Pelagatti** 124  ."
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
                "name": "Petrusa presso Vassallaggi",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0369_0000",
                        "entity_score": "0.701",
                        "text": " Gadira e **Petrusa presso Vassallaggi**  ."
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
                "name": "Parthenicum",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0369_0000",
                        "entity_score": "0.700",
                        "text": " Partinico ( Parthenicum? )  ."
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
                "name": "Hykkara",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0369_0000",
                        "entity_score": "0.626",
                        "text": " Carini ( Hykkara? )  ."
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
                "name": "Helvia",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0373_0000",
                        "entity_score": "0.541",
                        "text": "C , limitandosi a conservare ο a riadattare strutture precedenti , ha nuovo slancio in età severiana , quando è diventata colonia **Helvia** 144  ."
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
                "name": "Trocali",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0374_0000",
                        "entity_score": "0.441",
                        "text": " **Trocali**  ."
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
                "name": "Étrurie méridionale",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0377_0000",
                        "entity_score": "0.824",
                        "text": " Celui des Étrusques , d' une complexité rare , puisqu'il faut faire intervenir des différenciations sous-régionales entre **Étrurie méridionale** , Étrurie septentrionale , nouvelle Étrurie des bouches du Pô , mais où l' on voit bien que les Grecs qui s'introduisent dans la communauté indigène peuvent appartenir à toutes les couches  : aristoi à la Démarate , mais aussi artisans , marchands , voire esclaves  ."
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
                "name": "Étrurie septentrionale",
                "occurences": [
                    {
                        "page": "efr_0000-0000_1983_act_67_1_T1_0377_0000",
                        "entity_score": "0.971",
                        "text": " Celui des Étrusques , d' une complexité rare , puisqu'il faut faire intervenir des différenciations sous-régionales entre Étrurie méridionale , **Étrurie septentrionale** , nouvelle Étrurie des bouches du Pô , mais où l' on voit bien que les Grecs qui s'introduisent dans la communauté indigène peuvent appartenir à toutes les couches  : aristoi à la Démarate , mais aussi artisans , marchands , voire esclaves  ."
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