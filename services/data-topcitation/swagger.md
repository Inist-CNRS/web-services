Extraction des 10 références phares d'un corpus.

Comme ces services s'appliquent à un corpus entier, la réponse finale n'est pas
donnée immédiatement après l'appel.  
Au contraire, un service comme [`/v1`](#data-topcitation/v1/topcitation) renverra
une réponse JSON contenant un champ `value` donnant l'identifiant du traitement
en cours.  
Et comme on lui passe aussi l'URL d'un *webhook*, cela lui permet, une fois le
traitement terminé, de signaler qu'on peut dès lors utiliser le service de
récupération (les routes qui commencent par `/v1/retrieve`).  

Exemple: traitement d'un corpus de doi

### Préparation du corpus

On crée une archive `.tar.gz` de fichiers `.json`.

Si on a un répertoire `corpus` contenant ces fichiers `.json`:

```txt
corpus
├── W2BVWkiVT.json
├── W2CeZqyNR.json
├── W77S4YQqx.json
├── W8kkWKySy.json
├── WcKPMhj3p.json
├── WG5aHJqba.json
├── Wh3itHprz.json
├── WhW6tZ6NH.json
├── WjS3eZyG4.json
├── Wk6YCLbzZ.json
├── WmiHPaEdf.json
├── WmJYZipzE.json
├── Wn8KqZXeX.json
├── WPpTXDTJB.json
├── WpRjkUwwB.json
├── WtCWN5q5Y.json
├── WtJ4NNWhq.json
├── WTxTnPGxt.json
├── WwzTseBX6.json
├── WXer3K9QE.json
├── Wymfn7YTm.json
└── WzXkqs4zt.json
```

Chaque fichier `.json` est un objet JSON, sur une seule ligne, contenant deux champs:

1. `id`: un identifiant
2. `value`: le doi à traiter.

Exemple pour `corpus/W2BVWkiVT.json`:

```json
{"id":"0","value":"https://doi.org/10.1021/ja800073m"}
```

La commande Linux suivante crée le fichier `corpus.tar.gz` conforme à ce qui est
attendu par le service web.

```bash
tar czf corpus.tar.gz corpus
```

### Appel du traitement

Ici, il faut donner un [*webhook*](https://fr.wikipedia.org/wiki/Webhook) pour
connaître l'instant où on peut (ou non) récupérer le résultat.

```bash
curl -X 'POST' \
  'http://data-topcitation.services.istex.fr/v1/topcitation' \
  -H 'accept: application/json' \
  -H 'X-Webhook-Success: https://webhook.site/2caab8b5-fc96-4d7a-bb94-bdda20977830' \
  -H 'X-Webhook-Failure: https://webhook.site/2caab8b5-fc96-4d7a-bb94-bdda20977830' \
  -H 'Content-Type: application/x-gzip' \
  --data-binary '@corpus.tar.gz'
```

L'appel précédent renvoie une réponse du type:

```json
[{
    "id": "topcitation",
    "value": "qiCVLyh5p"
}]
```

Et le serveur du *webhook* recevra, une fois le traitement terminé, un JSON
contenant un champ `identifier` (la même valeur que `value` dans la réponse au
`curl`), et un champ `state` qui devrait être `ready`.  
Ici c'est `qiCVLyh5p`.

### Récupération du résultat

Enfin, on peut demander la réponse via
[`/v1/retrieve-json`](#data-topcitation/post-v1-retrieve-json), en n'oubliant
d'adapter `value`:

```bash
curl -X 'POST' \
  'http://localhost:31976/v1/retrieve-csv' \
  -H 'accept: json' \
  -H 'Content-Type: json' \
  -d '[
  {
    "value": "qiCVLyh5p"
  }
]'
```

qui donnera ce résultat

```json
[{
    "id": "n/a",
    "value": [
        {
            "citation": "https://doi.org/10.1007/bf01303701",
            "count": 6,
            "doi": [
                "https://doi.org/10.1021/ja800073m",
                "https://doi.org/10.1126/science.235.4793.1196",
                "https://doi.org/10.1103/physrevlett.58.908",
                "https://doi.org/10.1103/revmodphys.70.1039",
                "https://doi.org/10.1103/revmodphys.66.1125",
                "https://doi.org/10.1103/physrevb.37.3759"
            ]
        },
        {
            "citation": "https://doi.org/10.1103/physrev.115.2",
            "count": 3,
            "doi": [
                "https://doi.org/10.1126/science.235.4793.1196",
                "https://doi.org/10.1103/revmodphys.70.1039",
                "https://doi.org/10.1103/physrevb.37.3759"
            ]
        },
        {
            "citation": "https://doi.org/10.1126/science.235.4793.1196",
            "count": 3,
            "doi": [
                "https://doi.org/10.1103/revmodphys.70.1039",
                "https://doi.org/10.1103/revmodphys.66.1125",
                "https://doi.org/10.1103/physrevb.37.3759"
            ]
        },
        {
            "citation": "https://doi.org/10.1103/physrevb.40.2254",
            "count": 2,
            "doi": [
                "https://doi.org/10.1021/ja800073m",
                "https://doi.org/10.1103/revmodphys.70.1039"
            ]
        },
        {
            "citation": "https://doi.org/10.1103/physrevb.50.6534",
            "count": 2,
            "doi": [
                "https://doi.org/10.1021/ja800073m",
                "https://doi.org/10.1103/revmodphys.70.1039"
            ]
        },
        {
            "citation": "https://doi.org/10.1038/372532a0",
            "count": 2,
            "doi": [
                "https://doi.org/10.1021/ja800073m",
                "https://doi.org/10.1103/revmodphys.70.1039"
            ]
        },
        {
            "citation": "https://doi.org/10.1126/science.235.4788.567",
            "count": 2,
            "doi": [
                "https://doi.org/10.1126/science.235.4793.1196",
                "https://doi.org/10.1103/physrevlett.58.908"
            ]
        },
        {
            "citation": "https://doi.org/10.1088/0370-1298/62/7/303",
            "count": 2,
            "doi": [
                "https://doi.org/10.1126/science.235.4793.1196",
                "https://doi.org/10.1103/revmodphys.70.1039"
            ]
        },
        {
            "citation": "https://doi.org/10.1103/physrevlett.58.408",
            "count": 2,
            "doi": [
                "https://doi.org/10.1126/science.235.4793.1196",
                "https://doi.org/10.1103/physrevlett.58.908"
            ]
        },
        {
            "citation": "https://doi.org/10.1103/physrevlett.58.405",
            "count": 2,
            "doi": [
                "https://doi.org/10.1126/science.235.4793.1196",
                "https://doi.org/10.1103/physrevlett.58.908"
            ]
        }
    ]
}]
```
