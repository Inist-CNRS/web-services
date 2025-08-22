# ws-data-rapido@1.1.1

### v1/rapido-algorithme

Web service à destination du projet rapido. Ce web service prend en entrée un tar.gz comportant un dossier data incluant tout les documents xml à traiter. Il renvoit un json comportant les alignements que l'algorithme a pu faire entre le texte et le référentiel idRef.

Applique un algorithme de recherche d'entitées et d'alignement avec idRef. Prévu dans le cadre de la phase 1 du projet Rapido.


Par exemple, en utilisant example-xml-rapido.tar.gz,
On obtiendra :

```json
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
      "notice": "https://www.idref.fr/192337963.rdf",
      "score": "PP(0)"
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
      "notice": "https://www-dev.idref.fr/050189484.rdf",
      "score": "PP(0)"
    }
  ]
}
```

#### Paramètre(s) URL

| nom                 | description                                 |
| ------------------- | ------------------------------------------- |
| indent (true/false) | Indenter le résultat renvoyer immédiatement |

#### Entête(s) HTTP

| nom    | description                                                  |
| ------ | ------------------------------------------------------------ |
| X-Hook | URL à appeler quand le résultat sera disponible (facultatif) |

#### Exemple en ligne de commande

```bash
# Send data for batch processing
cat input.tar.gz |curl --data-binary @-  -H "X-Hook: https://webhook.site/dce2fefa-9a72-4f76-96e5-059405a04f6c" "http://localhost:31976/v1/rapido" > output.json

# When the corpus is processed, get the result
cat output.json |curl --data-binary @- "http://localhost:31976/v1/retrieve" > output.tar.gz
```

### v1/rapido-apprentissage

Web service à destination du projet rapido. Ce web service prend en entrée un tar.gz comportant un dossier data incluant tout les documents xml à traiter. Il renvoit un json comportant les alignements que l'algorithme a pu faire entre le texte et le référentiel idRef.

Détecte des entitées via un modèle d'IA puis applique un algorithme d'alignement avec idRef. Prévu dans le cadre de la phase 2 du projet Rapido.



Par exemple, en utilisant example-xml-rapido.tar.gz,
On obtiendra :

```json
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
            "text": " **ASÉA** Travaux de l' Institut suédois  ."
        }
        ],
        "notice": "None(apprentissage)",
        "score": ""
    },
    {
        "name": "Aséa",
        "occurences": [
        {
            "page": "bch_0007-4217_2003_num_127_2_T1_0778_0000",
            "text": " Papamarinopoulos ( université de Patras ) ont entrepris un projet commun de prospection géophysique dans la ville basse d' **Aséa** dans le but de retrouver les sections de l' enceinte recouverte par une couche d' alluvions stériles déposées par l' Alphée  ."
        },
        {
            "page": "Title",
            "text": " **Aséa** ."
        }
        ],
        "notice": "None(apprentissage)",
        "score": ""
    },
    {
        "name": "Mégalopolis",
        "occurences": [
        {
            "page": "bch_0007-4217_2003_num_127_2_T1_0778_0000",
            "text": " Parmi les découvertes les plus importantes , on signale l' identification probable d' une tour carrée au Sud-Est de la route de **Mégalopolis**  ."
        },
        {
            "page": "bch_0007-4217_2003_num_127_2_T1_0778_0000",
            "text": " Des vestiges appartenant sans doute à la porte principale de **Mégalopolis** ont été localisés juste au Nord de la route moderne , qui passe donc sans doute au-dessus de la route antique reliant **Mégalopolis** à Τ égée  ."
        },
        {
            "page": "bch_0007-4217_2003_num_127_2_T1_0778_0000",
            "text": " Des vestiges appartenant sans doute à la porte principale de **Mégalopolis** ont été localisés juste au Nord de la route moderne , qui passe donc sans doute au-dessus de la route antique reliant **Mégalopolis** à Τ égée  ."
        }
        ],
        "notice": "None(apprentissage)",
        "score": ""
    },
    {
        "name": "égée",
        "occurences": [
        {
            "page": "bch_0007-4217_2003_num_127_2_T1_0778_0000",
            "text": " Des vestiges appartenant sans doute à la porte principale de Mégalopolis ont été localisés juste au Nord de la route moderne , qui passe donc sans doute au-dessus de la route antique reliant Mégalopolis à Τ **égée**  ."
        }
        ],
        "notice": "None(apprentissage)",
        "score": ""
    }
    ]
}
```

#### Paramètre(s) URL

| nom                 | description                                 |
| ------------------- | ------------------------------------------- |
| indent (true/false) | Indenter le résultat renvoyer immédiatement |

#### Entête(s) HTTP

| nom    | description                                                  |
| ------ | ------------------------------------------------------------ |
| X-Hook | URL à appeler quand le résultat sera disponible (facultatif) |

#### Exemple en ligne de commande

```bash
# Send data for batch processing
cat input.tar.gz |curl --data-binary @-  -H "X-Hook: https://webhook.site/dce2fefa-9a72-4f76-96e5-059405a04f6c" "http://localhost:31976/v1/rapido" > output.json

# When the corpus is processed, get the result
cat output.json |curl --data-binary @- "http://localhost:31976/v1/retrieve" > output.tar.gz
```
