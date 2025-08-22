# ws-funder-ner@2.0.2

Detection de financeurs

Détecte des financeurs dans un article en anglais et renvoie la liste des financeurs repérés.

## Utilisation

- [v1/tagger](#v1)

### v1

Ce web-service renvoie la liste des financeurs présents dans un texte.
Il prend en entrée du JSON avec deux champs, `id` et `value`, et renvoie un JSON avec la liste des financeurs trouvés
dans le champ `value`.
Il est important de souligner que le programme détecte en fonction du contexte de la phrase, il ne s'agit pas de
détection via une base de financeurs existante.

#### Exemple de v1/first-name/gender

Entrée

```bash
$ cat <<EOF | curl -X POST --data-binary @- "?????????"
[{"id": "1", "value": "This study was funded by the CNRS and INIST."}]
EOF
```

Sortie

```json
[
  {
    "id": 1,
    "value": [
      "CNRS",
      "INIST"
    ]
  }
]
 ```
