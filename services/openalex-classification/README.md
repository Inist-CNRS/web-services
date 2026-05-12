# ws-openalex-classification@0.0.0

Classification hiérarchique (domains et fields) OpenAlex. 


### Niveau 1 — Domaine (domains)

Le modèle `model_parent.bin` prédit l'un des domaines suivants :

| Étiquette | Description |
|---|---|
| `physical_sciences` | Sciences physiques |
| `social_sciences` | Sciences sociales |
| `health_sciences` | Sciences de la santé |
| `life_sciences` | Sciences du vivant |

### Niveau 2 — Sous-domaine (fields)

Selon le domaine prédit, un second modèle spécialisé affine la classification :

| Domaine | Modèle utilisé | Fields possibles |
|---|---|---|
| `health_sciences` | `model_healthsciences.bin` | `dentistry`, `health_professions`, `medicine`, `nursing`, `veterinary` |
| `life_sciences` | `model_lifesciences.bin` | `agricultural_and_biological_sciences`, `biochemistry_genetics_and_molecular_biology`, `immunology_and_microbiology`, `neuroscience`, `pharmacology_toxicology_and_pharmaceutics` |
| `physical_sciences` | `model_physicalsciences.bin` | `chemical_engineering`, `chemistry`, `computer_science`, `earth_and_planetary_sciences`, `energy`, `engineering`, `environmental_science`, `materials_science`, `mathematics`, `physics_and_astronomy` |
| `social_sciences` | `model_socialsciences.bin` | `arts_and_humanities`, `business_management_and_accounting`, `decision_sciences`, `economics_econometrics_and_finance`, `psychology` |

---

## Format des données

### Entrée (JSON Lines)

```json
{"id": "doc_001", "value": "The mitochondria is the powerhouse of the cell."}
```

### Sortie (JSON Lines)

```json
{
  "id": "doc_001",
  "value": {
    "domain": "life_sciences",
    "field": "cell_biology"
  }
}
```
