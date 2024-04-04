# ws-affiliations-tools@1.1.2

Structuration et enrichissements d'affiliations

Propose plusieurs services autour des affiliations présentes dans les notices bibliographiques

- `rnsr`: déduit de l'adresse d'une affiliation d'auteur et d'une date de
  publication (l'année suffit) zéro, un ou plusieurs identifiants RNSR
  (correspondant à une ou plusieurs structures de recherche française(s)).

Cet appariement suit des [règles
certaines](https://github.com/Inist-CNRS/ezs/blob/master/packages/conditor/README.md#r%C3%A8gles-certaines).

## Utilisation

- [v1/rnsr/csv](#v1rnsrcsv)
- [v1/rnsr/json](#v1rnsrjson)
- [v1/rnsr/conditor](#v1rnsrconditor)

### v1/rnsr/csv

Prend un fichier CSV, avec des colonnes nommées `Adresse` et `Année`, et renvoie
un CSV avec la colonne supplémentaire `RNSR`.

Les colonnes doivent être séparées par des tabulations, des points-virgules ou
des virgules.

#### Exemple CSV

```bash
cat <<EOF | curl -X POST --data-binary @- "https://affiliations-tools.services.istex.fr/v1/rnsr/csv"
Année,Adresse
2015,CNRS UMR AMAP MONTPELLIER FRA
2015,IRD UMR AMAP MONTPELLIER FRA
2015,"University of Bordeaux, IMS, CNRS UMR5218, Talence, F-33405, France"
2015,"CENBG, CNRS/IN2P3, Chemin du Solarium B. P. 120, Gradignan, F-33175, France"
EOF
```

Sortie :

```csv
Année;Adresse;RNSR
2015;CNRS UMR AMAP MONTPELLIER FRA;200317641S
2015;IRD UMR AMAP MONTPELLIER FRA;200317641S
2015;University of Bordeaux, IMS, CNRS UMR5218, Talence, F-33405, France;200711887V
2015;CENBG, CNRS/IN2P3, Chemin du Solarium B. P. 120, Gradignan, F-33175, France;199512079F
```

### v1/rnsr/json

Prend un fichier JSON, avec des champs nommés `id` (pour l'identifiant) et
`value`, et renvoie un JSON avec le ou les identifiant RNSR
dans le champ `value`.

Le champ `value` contient un objet avec deux propriétés:

1. `year`: l'année de publication
2. `address`: l'adresse de la structure qu'on veut trouver

> *Remarque : Quand aucun identifiant n'est trouvé, un tableau vide est
> renvoyé.*

#### Paramètres de v1/rnsr/json

| nom    | description                                        |
|--------|----------------------------------------------------|
| indent | `true` ou `false`, indente le JSON résultat ou non |

#### Exemple JSON

```bash
cat <<EOF|curl -X POST --data-binary @- "https://affiliations-tools.services.istex.fr/v1/rnsr/json?indent=true"
[
{ "id":1, "value": { "year": "2021", "address": "CNRS UMR AMAP MONTPELLIER FRA" } },
{ "id":2, "value": { "year": "2021", "address": "IRD UMR AMAP MONTPELLIER FRA" } },
{ "id":3, "value": { "year": "2021", "address": "University of Bordeaux, IMS, CNRS UMR5218, Talence, F-33405, France" } },
{ "id":4, "value": { "year": "2021", "address": "CENBG, CNRS/IN2P3, Chemin du Solarium B. P. 120, Gradignan, F-33175, France" } },
{ "id":5, "value": { "year": "2021", "address": "Nulle part" } },
{ "id":6, "value": { "address": "Intemporel" } },
{ "id":7, "value": { "address": "Inist-CNRS, UPS76, 2 rue Jean Zay, Vandoeuvre-lès-Nancy" } }
]
EOF
```

Sortie :

```json
[
    { "id":1, "value": ["200317641S"] },
    { "id":2, "value": ["200317641S"] },
    { "id":3, "value": ["200711887V"] },
    { "id":4, "value": ["199512079F"] },
    { "id":5, "value": [] },
    { "id":6, "value": [] },
    { "id":7, "value": ["198822446E"] }
]
```

### v1/rnsr/info

Prend un fichier JSON, avec des champs nommés `id` (pour l'identifiant) et
`value`, et renvoie un JSON avec le ou les identifiant RNSR
dans le champ `value`.

Le champ `value` contient un objet avec deux propriétés:

1. `year`: l'année de publication
2. `address`: l'adresse de la structure qu'on veut trouver

> *Remarque : Quand aucun identifiant n'est trouvé, un tableau vide est
> renvoyé.*

#### Paramètres de v1/rnsr/info

| nom    | description                                        |
|--------|----------------------------------------------------|
| indent | `true` ou `false`, indente le JSON résultat ou non |

#### Exemple Info

```bash
cat <<EOF|curl -X POST --data-binary @- "https://affiliations-tools.services.istex.fr/v1/rnsr/info?indent=true"
[
{ "id":7, "value": { "address": "Inist-CNRS, UPS76, 2 rue Jean Zay, Vandoeuvre-lès-Nancy" } }
]
EOF
```

Sortie :

```json
[
    { "id":7, "value": [{
        "num_nat_struct": "198822446E",
        "intitule": "Institut de l'information scientifique et technique",
        "sigle": "INIST",
        "ville_postale": "VANDOEUVRE LES NANCY CEDEX",
        "code_postal": "54519",
        "etabAssoc": [{
            "etab": {
              "sigle": "CNRS",
              "libelle": "Centre national de la recherche scientifique",
              "sigleAppauvri": "cnrs",
              "libelleAppauvri": "centre national de la recherche scientifique"
            },
            "label": "UAR",
            "labelAppauvri": "uar",
            "numero": "76"
        }],
        "intituleAppauvri": "institut de l information scientifique et technique",
        "sigleAppauvri": "inist",
        "ville_postale_appauvrie": "vandoeuvre les nancy cedex",
        "annee_creation": "1988",
        "an_fermeture": ""
    }]}
]
```

### v1/rnsr/conditor

Prend une notice Conditor minimale (contenant au moins des auteurs (`authors`) et leurs affiliations (`affiliations`) avec au moins une adresse (`address`)), et tente de trouver le/les identifiant(s) RNSR correspondant.

Ajoute un champ `conditorRnsr` au niveau du champ `address`.

#### Exemple conditor

```bash
cat <<EOF|curl -X POST --data-binary @- "https://affiliations-tools.services.istex.fr/v1/rnsr/conditor"
[
{
     "xPublicationDate": ["2012-01-01"],
     "authors": [{
         "affiliations": [{
             "address": "GDR 2989 Université Versailles Saint-Quentin-en-Yvelines, 63009"
         }]
     }]
}
]
EOF
```

Sortie :

```json
[{
    "xPublicationDate": [
        "2012-01-01"
    ],
    "authors": [
        {
            "affiliations": [
                {
                    "address": "GDR 2989 Université Versailles Saint-Quentin-en-Yvelines, 63009",
                    "conditorRnsr": [
                        "200619958X"
                    ]
                }
            ]
        }
    ]
}]

```

### v1/addresses/parse

#### via curl

```bash
cat <<EOF|curl -N --data-binary @- "https://affiliations-tools.services.istex.fr/v1/addresses/parse?indent=true"
[
{ "value": "Inist-CNRS 2, rue Jean Zay CS 10310 F-54519 Vandœuvre-lès-Nancy France" },
{ "value": "46th St & 1st Ave, New York, NY 10017" }
]
EOF
```
