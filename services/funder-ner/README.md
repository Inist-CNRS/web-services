# ws-funder-ner@1.0.2

Detection de financeurs

Détecte des financeurs dans un article en anglais et renvoie la liste des financeurs repérés.

## Configuration

L'application à utiliser est XXX.

## Utilisation

- [v1/tagger](#v1)

### v1

Ce web-service renvoie la liste des financeurs présent dans un texte.
Il prend en entrée du JSON avec deux champs, `id` et `value`, et renvoie un JSON avec le la liste des financeurs trouvés
dans le champ `value`.
Il est important de souligner que le programme détécte en fonction du contexte de la phrase, il ne s'agit pas de
détéction via une base de financeurs existante.

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
