# ws-data-grobid@0.0.0

Exploite GROBID sur un lot d'URL de PDF

À partir d'une liste d'URL vers des fichiers PDF, applique un traitement GROBID
pour renvoyer des fichiers TEI ou texte.

<!-- Mettez ici les explications techniques destinées aux développeurs / mainteneurs de data-grobid -->
<!-- Par exemple, l'utilisation de DVC, ou de clé d'API. -->

Le fichier en entrée est un `.tar.gz` avec un répertoire (par exemple `corpus`)
contenant un fichier `.txt` par URL.

```txt
corpus
├── 01.txt
├── 02.txt
├── 03.txt
├── 04.txt
├── 05.txt
├── 06.txt
├── 07.txt
├── 08.txt
├── 09.txt
└── 10.txt
```

## Traitement GROBID

Le script `v1/full-text.sh` télécharge les PDF dans `/tmp/upload`, appelle
l'API GROBID en parallèle (`xargs -P`) et stocke les fichiers TEI dans
`/tmp/retrieve/teis` (sous `/tmp/retrieve/` pour que le cronjob de nettoyage
à 4 jours les récupère comme le reste). Chaque item renvoyé est complété du
champ `tei` pointant vers le fichier généré (les items en échec sont renvoyés
tels quels).

| Variable | Défaut | Description |
|----------|--------|-------------|
| `GROBID_API` | `http://vp-istex-grobid.intra.inist.fr:45070/api` | Racine de l'API GROBID |
| `TREATMENT` | `processFulltextDocument` | Endpoint de traitement |
| `PROCESSES` | `4` | Nombre de traitements parallèles |
| `GROBID_TIMEOUT` | `600` | Timeout curl (secondes) par document |

> **Réseau** : le conteneur doit pouvoir résoudre l'hôte GROBID
> (`vp-istex-grobid.intra.inist.fr`). `start:dev` utilise donc `--network host`
> afin d'hériter de la résolution DNS de la machine : le DNS par défaut de
> Docker ne résout pas les zones `intra.inist.fr` hors du LAN INIST (ex. via
> VPN). Sans accès GROBID, tous les items sont renvoyés tels quels, sans champ
> `tei` (voir `docker logs dev` : `curl: (6) Could not resolve host`).
