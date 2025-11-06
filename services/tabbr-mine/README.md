# ws-tabbr-mine@1.0.1

## Variables d'environnement

En production, il faut renseigner la variable `GROBID_API_URL`.

En développement, il faut en plus donner `WEBDAV_LOGIN`, `WEBDAV_PASSWORD` et
`WEBDAV_URL`. Pour cet environnement, il suffit de les mettre dans un fichier
`.env` sous `services/tabbr-mine`.

## TabbrMine - Service d'extraction d'abréviations torturées

Version : 5-NOV-2025.

### Description

Ce service permet l'extraction et la classifications d'abréviations (i.e. "légitime" ou "torturée") depuis du contenu textuel en anglais. Une abréviation torturée \[2\] correspond à la déformation d'un concept scientifique fortement établi dans une ou plusieurs disciplines (e.g. "convolutional brain organization (CNN)" au lieu de "convolutional neural network (CNN)" en informatique). Il s'agit généralement d'une abréviation qui ne correspond pas à sa définition et qui n'a pas de sens, résultant de l'utilisation d'outils de paraphrasage à des fins de dissimulation de plagiat \[4\]. Ce concept est un extension de la notion d'expression torturée \[1\] (e.g. ["bosom peril" au lieu de "breast cancer"](https://thebulletin.org/2022/01/bosom-peril-is-not-breast-cancer-how-weird-computer-generated-phrases-help-researchers-find-scientific-publishing-fraud/) en médecine).

**Notez qu'il s'agit d'un service expérimental pour lequel les performances necéssitent une amélioration, il se peut que les résultats renvoyés soient erronnés.**

### Méthode

Ce service utilise une expression régulière pour l'extraction des abréviations contenues dans du texte (i.e. du text entre parenthèses, non séparé par des espaces), ainsi qu'un' modèle de langue ré-entrainé sur un corpus d'abréviations préalablement annoté \[3\] pour la classification des abréviations extraites. Nous avons évalué ses performances avec les mesures suivantes :

|                   | Extraction d'abréviations | Classification d'abréviations | Extraction d'abréviations et classification en "torturée" |
| ----------------- | ------------------------- | ----------------------------- | --------------------------------------------------------- |
| Rappel            | 0.90                      | 0.77                          | 0.72                                                      |
| Précision         | 0.90                      | 0.64                          | 0.53                                                      |
| F-mesure binaire  | 0.90                      | 0.70                          | 0.61                                                      |
| F-mesure micro    | 0.82                      | 0.86                          | 0.44                                                      |
| F-mesure macro    | 0.45                      | 0.80                          | 0.30                                                      |
| F-mesure pondérée | 0.81                      | 0.86                          | 0.37                                                      |

### Variantes

Une première version de ce service utilise un moteur de filtrage basé sur des règles syntaxiques \[3\] plutôt que l'utilisation d'un modèle de langue.

### Références

\[1\] [Guillaume Cabanac](https://orcid.org/0000-0003-3060-6241), [Cyril Labbé](https://orcid.org/0000-0003-4855-7038), [Alexander Magazinov](https://orcid.org/0000-0002-9406-013X). 2021. Tortured phrases: A dubious writing style emerging in science. Evidence of critical issues affecting established journals. Prépublication _arXiv_: [doi.org/10.48550/arXiv.2107.06751](doi.org/10.48550/arXiv.2107.06751).

\[2\] [Alexandre Clausse](https://orcid.org/0009-0004-7215-6247), [Guillaume Cabanac](https://orcid.org/0000-0003-3060-6241), [Pascal Cuxac](https://orcid.org/0000-0002-6809-5654), [Cyril Labbé](https://orcid.org/0000-0003-4855-7038). 2023. Mining tortured abbreviations from the scientific literature. 8th World Conference on Research Integrity (WCRI'24), Athènes, Grèce: [hal.science/hal-04311600](hal.science/hal-04311600).

\[3\] [Alexandre Clausse](https://orcid.org/0009-0004-7215-6247), [Guillaume Cabanac](https://orcid.org/0000-0003-3060-6241), [Pascal Cuxac](https://orcid.org/0000-0002-6809-5654), [Cyril Labbé](https://orcid.org/0000-0003-4855-7038). 2024. Mining tortured abbreviations from the scientific literature [Data set]. Zenodo: [doi.org/10.5281/zenodo.14002956](doi.org/10.5281/zenodo.14002956).

\[4\] Cathleen O'Grady. 2024. Software that detects ‘tortured acronyms’ in research papers could help root out misconduct. _Science_: [doi.org/10.1126/science.znqe1aq](doi.org/10.1126/science.znqe1aq).
