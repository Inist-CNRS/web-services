# Détecteur de Texte Invisible dans les PDFs

Web service permettant de détecter et d'extraire le texte invisible ou caché dans les fichiers PDF, utile notamment pour identifier des tentatives de manipulation de contenu 

---

## Fonctionnement

Le script analyse chaque caractère d'un PDF et le signale comme suspect s'il répond à l'un des critères suivants :

| Type de détection | Description |
|---|---|
| **Hors page** | Texte positionné en dehors des limites de la page (coordonnées négatives ou dépassant les dimensions) |
| **Taille microscopique** | Taille de police inférieure à 2 pt |
| **Texte blanc sur fond blanc** | Texte en couleur blanche non contenu dans un rectangle coloré — donc invisible sur fond blanc |

---

### Format d'entrée

```json
{"filename": "chemin/vers/fichier.pdf", "id": 1}
```

### Format de sortie

```json
{
  "filename": "chemin/vers/fichier.pdf",
  "id": 1,
  "value": {
    "1": [
      {
        "text": "texte caché ici",
        "reasons": ["Texte blanc sur fond blanc (masqué)"]
      }
    ]
  }
}
```

Le champ `value` est un dictionnaire indexé par numéro de page. Chaque page contient une liste de **spans suspects**, chacun avec le texte détecté et les raisons de sa détection.

Si l'objet d'entrée ne contient pas de clé `filename`, le champ `value` vaut `"No data to process"`.

---

## Paramètres

Les seuils de détection sont fixés :

| Paramètre | Défaut | Description |
|---|---|---|
| `min_font_size` | `2.0` | Taille minimale (en points) en dessous de laquelle un caractère est considéré invisible |
| `color_threshold` | `0.95` | Seuil de luminosité pour la détection des couleurs claires (non utilisé directement dans la logique actuelle) |

---

## Limitations connues

- Le texte coloré sur **fond coloré ou image** n'est pas signalé.
- Les textes blancs de **grande taille** (> 20 pt) sont ignorés, car probablement visibles sur fond sombre.
- Les textes masqués par **superposition d'éléments graphiques** (images, formes opaques) ne sont pas détectés.
- Les PDFs avec des **encodages exotiques** ou des polices non embarquées peuvent produire des caractères mal extraits.

---

## Dépendances

- [`pdfplumber`](https://github.com/jsvine/pdfplumber)
