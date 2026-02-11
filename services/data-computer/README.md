# ws-data-computer@2.19.1

Le service `data-computer` offre plusieurs services **asynchrones** pour des calculs et de transformations de données simples.

*Tous les services proposés acceptent uniquement en entrée des fichiers corpus standards au format tar.gz.*

## Utilisation

- [v1/tree-segment](#v1%2ftree-segment)
- [v1/graph](#v1%2fgraph-segment)
- [v1/lda](#v1%2flda)

### v1/tree-segment

Créer des segments glissant 2 à 2 de tous les éléments d'un tableau et agrège ces segments pour les compter.

Le segment étant glissant, ce traitement sert à créer des segments qui représente un arbre hiérachique.

par exemple avec ces données en entrée:

```json
[
  { "value": ["a", "b", "c"] },
  { "value": ["a", "c", "d"] },
  { "value": ["a", "b", "d"] },
  { "value": ["a", "b", "c", "d"] },
  { "value": ["a", "c", "d", "e"] }
]
```

on obtiendra :

```json
[
  {"source":"a","target":"b","weight":3,"origin":["#1","#3","#4"]},
  {"source":"b","target":"c","weight":2,"origin":["#1","#4"]},
  {"source":"a","target":"c","weight":2,"origin":["#2","#5"]},
  {"source":"c","target":"d","weight":3,"origin":["#2","#4","#5"]},
  {"source":"b","target":"d","weight":1,"origin":["#3"]},
  {"source":"d","target":"e","weight":1,"origin":["#5"]}
]
```

> NOTE: Le service accepte des tableaux de tableaux (cas d'usage lodex/istex)

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
cat input.tar.gz |curl --data-binary @-  -H "X-Hook: https://webhook.site/dce2fefa-9a72-4f76-96e5-059405a04f6c" "http://localhost:31976/v1/tree-segment" > output.json

# When the corpus is processed, get the result
cat output.json |curl --data-binary @- "http://localhost:31976/v1/retrieve" > output.tar.gz

```

### v1/graph-segment

Créer des segments 2 à 2 avex tous les éléments d'un tableau et agrège ces segments pour les compter
Les segments reprsentent toutes la associations possibles, ce traitement sert à créer des segments qui représente un réesau.

par exemple avec ces données en entrée:

```json
[
  { "value": ["a", "b", "c"] },
  { "value": ["a", "c", "d"] },
  { "value": ["a", "b", "d"] },
  { "value": ["a", "b", "c", "d"] },
  { "value": ["a", "c", "d", "e"] }
]
```

on obtiendra :

```json
[
  {"source":"a","target":"b","weight":3,"origin":["#1","#3","#4"]},
  {"source":"a","target":"c","weight":4,"origin":["#1","#2","#4","#5"]},
  {"source":"b","target":"c","weight":2,"origin":["#1","#4"]},
  {"source":"a","target":"d","weight":4,"origin":["#2","#3","#4","#5"]},
  {"source":"c","target":"d","weight":3,"origin":["#2","#4","#5"]},
  {"source":"b","target":"d","weight":2,"origin":["#3","#4"]},
  {"source":"a","target":"e","weight":1,"origin":["#5"]},
  {"source":"c","target":"e","weight":1,"origin":["#5"]},
  {"source":"d","target":"e","weight":1,"origin":["#5"]}
]
```

> NOTE: Le service accepte des tableaux ou des tableaux de tableaux

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
cat input.tar.gz |curl --data-binary @-  -H "X-Hook: https://webhook.site/dce2fefa-9a72-4f76-96e5-059405a04f6c" "http://localhost:31976/v1/graph-segment" > output.json

# When the corpus is processed, get the result
cat output.json |curl --data-binary @- "http://localhost:31976/v1/retrieve" > output.tar.gz
```

### v1/lda

Créer à partir de l'ensemble des documents un ensemble de topics. Chaque topic contient un champ "word", qui est composé une liste de 10 mots qui sont les plus caractéristiques du topic, ainsi que d'un champ "weight" qui correspond au poids associé au sujet dans le document. Le texte doit être en anglais. Les topics non exhaustifs (dont la probabilité est inférieure ou égale à 0.05) ne sont pas retournés.
La liste des topics sont affichés dans le champ "topics" et le topic avec la plus forte probabilité est retourné dans un champ "best_topic"

Par exemple, pour un document pris dans un ensemble de document (l'id "83" est totalement arbitraire)

```json
{
"id":"83",
"value":"The current status and distribution of the red panda Ailurus fulgens in the wild is poorly known. The subspecies fulgens is found in the Himalaya in Nepal, India, Bhutan, northern Myanmar and southwest China, and the subspecies styani occurs further to the east in south-central China. The red panda is an animal of subtropical and temperate forests, with the exception of Meghalaya in India, where it is also found in tropical forests. In the wild, red pandas take a largely vegetarian diet consisting chiefly of bamboo. The extent of occurrence of the red panda in India is about 170,000 sq km, although its area of occupancy within this may only be about 25,000 sq km. An estimate based on the lowest recorded average density and the total area of potential habitat suggests that the global population of red pandas is about 16,000–20,000. Habitat loss and poaching, in that order, are the major threats. In this paper the distribution, status and conservation problems of the red panda, especially in India, are reviewed, and appropriate conservation measures recommended, including the protection of named areas and the extension of some existing protected areas."
}
```

On obtiendra :

```json
{
  "id":"83",
  "value":{
    "topics":{
      "topic_6":{"words":["diet","animal","high","group","level","study","blood","dietary","intake","increase"],"weight":"0.9416929"},
      "topic_13":{"words":["diet","intake","human","b12","food","level","protein","vitamin","increase","acid"],"weight":"0.05131816"}
    },
    "best_topic": {
      "topic_6":{"words":["diet","animal","high","group","level","study","blood","dietary","intake","increase"],"weight":"0.9416929"}
    }
  }
}
```

NOTE : La qualité des résultats dépend du corpus et les topics doivent être analysés par l'utilisateur avant d'être utilisés.

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
cat input.tar.gz |curl --data-binary @-  -H "X-Hook: https://webhook.site/dce2fefa-9a72-4f76-96e5-059405a04f6c" "http://localhost:31976/v1/lda" > output.json

# When the corpus is processed, get the result
cat output.json |curl --data-binary @- "http://localhost:31976/v1/retrieve" > output.tar.gz
```

### v1/corpus-similarity

Compare des petits documents (Titre, phrases, petits *abstracts*) entre eux, et renvoie pour chaque document les documents qui lui sont similaires.  
Il est conseillé d'utiliser cette route avec au moins 6-7 documents dans le corpus.

Il existe un paramètre optionnel `output` pour choisir le type de sortie en fonction de sa valeur:

- 0 (par défaut) : l'algorithme choisit automatiquement les documents les plus similaires à chaque document
- 1 : l'algorithme renvoie pour chaque document tous les documents, classés par ordre de proximité (les plus similaires en premier)
- *n* (avec *n* un entier plus grand que 1) : l'algorithme renvoie pour chaque document les *n* documents les plus proches, classés par ordre de proximité (les plus similaires en premier), ainsi que le score de similarité associé à chaque document.
par exemple en utilisant `example-similarity-json.tar.gz` avec le paramètre output par défaut (0), obtiendra :

> **Attention** : Le champ ID est utilisé comme référence de chaque document.

par exemple en utilisant `example-similarity-json.tar.gz` avec le paramètre output par défaut (0), obtiendra :

```json
[
  {
    "id": "Titre 1",
    "value": {
      "similarity": [
        "Titre 4",
        "Titre 2"
      ],
      "score": [
        0.9411764705882353,
        0.9349112426035503
      ]
    }
  },
  {
    "id": "Titre 2",
    "value": {
      "similarity": [
        "Titre 1"
      ],
      "score": [
        0.9349112426035503
      ]
    }
  },
  {
    "id": "Titre 3",
    "value": {
      "similarity": [
        "Titre 4"
      ],
      "score": [
        0.8888888888888888
      ]
    }
  },
  {
    "id": "Titre 4",
    "value": {
      "similarity": [
        "Titre 1"
      ],
      "score": [
        0.9411764705882353
      ]
    }
  }
]
```

Avec le paramètre output=3, on obtiendra :

```json
[
  {
    "id": "Titre 1",
    "value": {
      "similarity": [
        "Titre 4",
        "Titre 2",
        "Titre 3"
      ],
      "score": [
        0.9411764705882353,
        0.9349112426035503,
        0.8757396449704142
      ]
    }
  },
  {
    "id": "Titre 2",
    "value": {
      "similarity": [
        "Titre 1",
        "Titre 4",
        "Titre 3"
      ],
      "score": [
        0.9349112426035503,
        0.8888888888888888,
        0.8651685393258427
      ]
    }
  },
  {
    "id": "Titre 3",
    "value": {
      "similarity": [
        "Titre 4",
        "Titre 1",
        "Titre 2"
      ],
      "score": [
        0.8888888888888888,
        0.8757396449704142,
        0.8651685393258427
      ]
    }
  },
  {
    "id": "Titre 4",
    "value": {
      "similarity": [
        "Titre 1",
        "Titre 3",
        "Titre 2"
      ],
      "score": [
        0.9411764705882353,
        0.8888888888888888,
        0.8888888888888888
      ]
    }
  }
]
```

#### Paramètre(s) URL

| nom                 | description                                 |
| ------------------- | ------------------------------------------- |
| indent (true/false) | Indenter le résultat renvoyer immédiatement |
| output  (0,1,n)     | Choix de la sortie                          |

#### Entête(s) HTTP

| nom    | description                                                  |
| ------ | ------------------------------------------------------------ |
| X-Hook | URL à appeler quand le résultat sera disponible (facultatif) |

#### Exemple en ligne de commande

```bash
# Send data for batch processing
cat input.tar.gz |curl --data-binary @-  -H "X-Hook: https://webhook.site/dce2fefa-9a72-4f76-96e5-059405a04f6c" "http://localhost:31976/v1/similarity" > output.json

# When the corpus is processed, get the result
cat output.json |curl --data-binary @- "http://localhost:31976/v1/retrieve" > output.tar.gz
