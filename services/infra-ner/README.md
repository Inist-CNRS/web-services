# infra-ner

Web service qui repère des infrastructures de recherche françaises et européennes dans un texte, en français ou en anglais. La liste vient de `data/infrastructures.csv` et `data/aliases.csv`.

## Entrée

Une ligne JSON par document, le texte est dans `value`.

```json
{"id": 1, "value": "The European Southern Observatory (ESO) operates several major astronomical facilities in Chile."}
```

## Sortie

`value` devient une liste, avec un objet par mention trouvée, dans l'ordre du texte.

```json
{
  "alias_detecte": "European Southern Observatory",
  "infrastructure_id": "bba68ea88de6",
  "acronyme": "ESO",
  "nom": "Observatoire européen austral",
  "nom_fr": "Observatoire européen austral",
  "nom_en": "European Southern Observatory",
  "domaine_scientifique": "Astronomie et astrophysique",
  "sources": "MESRE",
  "score_similarite": 100.0,
  "debut": 4,
  "fin": 33,
  "contexte": "The European Southern Observatory (ESO) operates several major..."
}
```

| Champ | Contenu |
|---|---|
| `alias_detecte` | le texte tel qu'il est écrit dans le document |
| `infrastructure_id`, `acronyme`, `nom`, `nom_fr`, `nom_en`, `domaine_scientifique`, `sources` | recopiés du référentiel |
| `score_similarite` | 100 pour un alias exact, entre 92 et 100 pour une variante approximative |
| `debut`, `fin` | positions dans le texte d'origine (`fin` exclue) |
| `contexte` | 100 caractères avant et après la mention |

Si un alias désigne plusieurs infrastructures, on a un objet par infrastructure. En cas d'erreur, `value` vaut `[]`, le message est dans `error` et sur stderr.

## Limites

Le service préfère rater une mention que se tromper.

- Les alias de confiance `moyenne` ou `faible` sont ignorés : `ESO`, `CDS` ou `ILL` seuls ne sont pas détectés, leur nom complet l'est. `FAIR` est ignoré aussi.
- Casse : un alias court (6 lettres ou moins) ou un acronyme d'un seul mot doit être écrit comme dans le référentiel, ou tout en majuscules (`KM3NET` passe pour `KM3NeT`, `cern` non). Un alias avec une seule majuscule (`Apollon`) n'accepte pas `APOLLON`.
- Variantes approximatives (faute de frappe, mot en plus ou en moins) : seulement pour les noms d'au moins 14 caractères et plusieurs mots, avec un score d'au moins 92.
- Quand deux mentions se chevauchent, on garde la plus longue (`ACTRIS-France` plutôt que `ACTRIS`).
- Les pages `Catégorie:` d'OPIDoR sont écartées. Les fiches de redirection pointent vers leur cible (`Résif-Epos` donne `Epos-France`).
- Pour les fiches qui n'existent que dans OPIDoR, `nom` ne contient que le sigle.

Les réglages (seuil, niveaux de confiance, alias ignorés, taille du contexte) sont en haut de `utils.py`.
