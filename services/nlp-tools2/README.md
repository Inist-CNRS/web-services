# ws-nlp-tools2@0.0.0

Outils de NLP

Cette instance propose des outils de traitement de la langue

## Utilisation

- [v1/detect-lang](#v1%2fdetect-lang)
- [v1/lemma](#v1%2flemma)

### v1/detect-lang

Ce service permet de détecter la langue d'un document
Prend en entrée du JSON avec deux champs: `id` et `value`, et renvoie un JSON
avec le code langue dans le champ `value`.

> **Remarque**: quand on ne trouve pas la langue, la valeur est `unknown`

#### Paramètres de v1/detect-lang

| nom    | description                                                            |
|:-------|:-----------------------------------------------------------------------|
| indent | `true` ou `false`, indente le JSON résultat ou non (`true` par défaut) |

#### Exemple

```bash
$ cat <<EOF | curl -X POST --data-binary @- "https://nlp-tools2.services.inist.fr/v1/detect-lang"
[{ "id": 1, "value": "The COVID-19 pandemic, also known as the coronavirus pandemic, is an ongoing global pandemic of coronavirus disease 2019 (COVID-19) caused by severe acute respiratory syndrome coronavirus2 (SARS-CoV-2). It was first identified in December 2019 in Wuhan, China. The World Health Organization declared the outbreak a Public Health Emergency of International Concern on 20 January 2020, and later a pandemic on 11 March 2020. As of 2 April 2021, more than 129 million cases have been confirmed, with more than 2.82 million deaths attributed to COVID-19, making it one of the deadliest pandemics in history."},
 { "id": 2, "value": "Par rapport à la période écoulée, le fait d'avoir appris après coup que des circulaires imposaient de manière retroactive le retrait de jours de congés pour des personnes qui s'étaient mises en ASA pour cause de garde d'enfants m'a semblé particulièrement injuste et m'a mis vraiment en colère. J'aurais eu besoin de soutien à ce niveau là de la part du CNRS, car faire l'école à la maison était un travail à temps plein aussi nécessaire à la nation que mon travail au CNRS.Par rapport au satisfaction, j'ai trouvé que le télétravail me convenait bien."}]
EOF
```

Sortie

```json
[
  {
    "id": 1,
    "value": "en"
  },
  {
    "id": 2,
    "value": "fr"
  }
]
```

### v1/lemma

Ce service permet de lemmatiser des termes en anglais
Prend en entrée du JSON avec deux champs: `id` et `value`, et renvoie un JSON
avec le(s) terme(s) lemmatisé(s) dans le champ `value`.

> **Remarque**: quand on ne peut pas lemmatiser un terme le terme d'origine est renvoyé. Le texte renvoyé est en
> minuscules.

#### Paramètres de v1/lemma

| nom    | description                                                            |
|:-------|:-----------------------------------------------------------------------|
| indent | `true` ou `false`, indente le JSON résultat ou non (`true` par défaut) |

#### Exemple

```bash
$ cat <<EOF | curl -X POST --data-binary @- "https://nlp-tools2.services.inist.fr/v1/lemma"
[{ "id": 1, "value": ["rocks","are","images analysis"]},
 { "id": 2, "value": "Computers"},
 { "id":3,"value": "As of 2 April 2021, more than 129 million cases have been confirmed, with more than 2.82 million deaths attributed to COVID-19, making it one of the deadliest pandemics in history."}]
EOF
```

Sortie

```json
[
  {
    "id": 1,
    "value": [
      "rock",
      "be",
      "image analysis"
    ]
  },
  {
    "id": 2,
    "value": "computer"
  },
  {
    "id": 3,
    "value": "as of 2 April 2021 , more than 129 million case have be confirm , with more than 2.82 million death attribute to COVID-19 , make -PRON- one of the deadly pandemic in history ."
  }
]
```

