Extraction terminologique d'un corpus via [TermSuite](https://termsuite.github.io/).

Comme ces services s'appliquent à un corpus entier, la réponse finale n'est pas
donnée immédiatement après l'appel.  
Au contraire, un service comme [`/v1/en`](#data-termsuite/post-v1-en) renverra une réponse JSON contenant un champ `value` donnant l'identifiant du traitement en cours.  
Et comme on lui passe aussi l'URL d'un *webhook*, cela lui permet, une fois le
traitement terminé, de signaler qu'on peut dès lors utiliser le service de
récupération (les routes qui commencent par `/v1/retrieve`).  

Exemple: traitement d'un corpus de textes en anglais

### Préparation du corpus

On crée une archive `.tar.gz` de fichiers `.txt`.

Si on a un répertoire `corpus` contenant ces fichiers `.txt`:

```txt
corpus
├── W2BVWkiVT.txt
├── W2CeZqyNR.txt
├── W77S4YQqx.txt
├── W8kkWKySy.txt
├── WcKPMhj3p.txt
├── WG5aHJqba.txt
├── Wh3itHprz.txt
├── WhW6tZ6NH.txt
├── WjS3eZyG4.txt
├── Wk6YCLbzZ.txt
├── WmiHPaEdf.txt
├── WmJYZipzE.txt
├── Wn8KqZXeX.txt
├── WPpTXDTJB.txt
├── WpRjkUwwB.txt
├── WtCWN5q5Y.txt
├── WtJ4NNWhq.txt
├── WTxTnPGxt.txt
├── WwzTseBX6.txt
├── WXer3K9QE.txt
├── Wymfn7YTm.txt
└── WzXkqs4zt.txt
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
  'http://data-termsuite.services.istex.fr/v1/en?indent=true&nb=10' \
  -H 'accept: application/json' \
  -H 'X-Webhook-Success: https://webhook.site/2caab8b5-fc96-4d7a-bb94-bdda20977830' \
  -H 'X-Webhook-Failure: https://webhook.site/2caab8b5-fc96-4d7a-bb94-bdda20977830' \
  -H 'Content-Type: application/x-gzip' \
  --data-binary '@corpus.tar.gz'
```

L'appel précédent renvoie une réponse du type:

```json
[{
    "id": "termsuite-en",
    "value": "qiCVLyh5p"
}]
```

Et le serveur du *webhook* recevra, une fois le traitement terminé, un JSON
contenant un champ `identifier` (la même valeur que `value` dans la réponse au
`curl`), et un champ `state` qui devrait être `ready`.  
Ici c'est `qiCVLyh5p`.

### Récupération du résultat

Enfin, on peut demander la réponse via
[`/v1/retrieve-csv`](#data-termsuite/post-v1-retrieve-csv), en n'oubliant
d'adapter `value`:

```bash
curl -X 'POST' \
  'http://localhost:31976/v1/retrieve-csv' \
  -H 'accept: text/csv' \
  -H 'Content-Type: text/csv' \
  -d '[
  {
    "value": "qiCVLyh5p"
  }
]'
```

qui donnera ce résultat

```csv
"key","freq"
"n: sediment","10"
"nn: proto-paratethys sea","9"
"a: glacial","7"
"n: mmes","7"
"a: tropical","7"
"n: precipitation","7"
"n: genus","7"
"n: obliquiloculata","7"
"n: telescopus","6"
"nn: clay mineral","6"
```
