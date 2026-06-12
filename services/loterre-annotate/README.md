# Loterre Annotate

**Loterre Annotate** est un service qui permet la reconnaissance de concepts [Loterre](https://loterre.istex.fr/fr/) dans un texte, en français ou en anglais.

## Accès au service

#### URL du service

> https://loterre-annotate.services.istex.fr/v1/CODE_LANGUE/loterre-annotate/annotate?loterreID=CODE_VOC

Avec  **CODE_LANGUE** = la langue du texte;  2 langues disponibles `fr` | `en`

#### Paramètres

**- CODE_VOC** = voir la [liste des codes vocabulaires](#section/Liste-des-vocabulaires)

## Format d'entrée

Un tableau JSON avec un objet par document :

```json
[
    { "id": "1", "value": "texte à annoter" },
    { "id": "2", "value": "autre texte" }
]
```

## Format de sortie

Un rableau JSON de même taille. Pour chaque document :

| Champ | Description |
|:---|:---|
| `id` | Identifiant du document (inchangé) |
| `annotated` | Texte original avec les termes balisés en markdown `**terme**〔[préférentiel](uri)〕` |
| `value` | Liste des termes reconnus |
| `value[].start` / `.end` | Offsets caractères dans le texte original |
| `value[].found` | Texte exact trouvé dans le document |
| `value[].pref` | Forme préférentielle du concept |
| `value[].uri` | URI du concept Loterre |
| `value[].label` | Libellé brut du concept |
| `value[].rule` | Règle de matching : `pattern`, `surface_upper_exact`, `surface_structural`, `lemma_structural`, `lemma_pattern_seq` |
| `value[].score` | Score de confiance [0.0–1.0] — seuil recommandé : 0.80 pour les mono-tokens |

## Exemple

### Requête

```bash
curl -X POST 'https://loterre-annotate.services.istex.fr/v1/en/loterre-annotate/annotate?loterreID=P66' \
  -H 'Content-Type: application/json' \
  --data '[
    {"id": "1", "value": "The Mem-Pro-Clinic test is a clinical test to assess difficulties in event- and time-based prospective thoughts. This result implies that activated long-term memory provides a representational basis for semantic verbal short-term signal."},
    {"id": "2", "value": "A new method to implant false autobiographical books: Blind implantation call blind implantation methods."},
    {"id": "3", "value": "A guy with hypermnesia (Pathology) is capable of storing idea in an extraordinarily efficient manner."}
  ]'
```

### Réponse

```json
[
  {
    "id": "1",
    "annotated": "The **Mem-Pro-Clinic test**〔[Mem-Pro-Clinic test](http://data.loterre.fr/ark:/67375/P66-WG17XBG4-V)〕 is a clinical test to assess difficulties in event- and time-based **prospective thoughts**〔[predictive brain](http://data.loterre.fr/ark:/67375/P66-VLJ0CQH4-G)〕. This result implies that activated **long-term memory**〔[long-term memory](http://data.loterre.fr/ark:/67375/P66-J8FC45M1-6)〕 provides a representational basis for semantic verbal short-term signal.",
    "value": [
      { "start": 4,  "end": 23,  "found": "Mem-Pro-Clinic test",   "pref": "Mem-Pro-Clinic test",  "uri": "http://data.loterre.fr/ark:/67375/P66-WG17XBG4-V", "label": "Mem-Pro-Clinic test",  "rule": "surface_upper_exact", "score": 0.9 },
      { "start": 91, "end": 111, "found": "prospective thoughts",  "pref": "predictive brain",     "uri": "http://data.loterre.fr/ark:/67375/P66-VLJ0CQH4-G", "label": "predictive brain",     "rule": "surface_structural",  "score": 0.82 },
      { "start": 148,"end": 164, "found": "long-term memory",      "pref": "long-term memory",     "uri": "http://data.loterre.fr/ark:/67375/P66-J8FC45M1-6", "label": "long-term memory",     "rule": "surface_upper_exact", "score": 0.9 }
    ]
  },
  {
    "id": "2",
    "annotated": "A new method to implant false autobiographical books: Blind implantation call **blind implantation methods**〔[blind implantation method](http://data.loterre.fr/ark:/67375/P66-D6XL3PDR-M)〕.",
    "value": [
      { "start": 78, "end": 104, "found": "blind implantation methods", "pref": "blind implantation method", "uri": "http://data.loterre.fr/ark:/67375/P66-D6XL3PDR-M", "label": "blind implantation method", "rule": "lemma_pattern_seq", "score": 0.85 }
    ]
  },
  {
    "id": "3",
    "annotated": "A guy with **hypermnesia (Pathology)**〔[hypermnesia (Pathology)](http://data.loterre.fr/ark:/67375/P66-FQXK8KBN-C)〕 is capable of storing idea in an extraordinarily efficient manner.",
    "value": [
      { "start": 11, "end": 34, "found": "hypermnesia (Pathology)", "pref": "hypermnesia (Pathology)", "uri": "http://data.loterre.fr/ark:/67375/P66-FQXK8KBN-C", "label": "hypermnesia (Pathology)", "rule": "surface_upper_exact", "score": 0.9 }
    ]
  }
]
```

## Liste des vocabulaires

| Code | Nom du vocabulaire (01/12/2025) | État |
|:---:|:---|:---|
|1WB|Heat transfers|disponible|
|26L|Earth Sciences|disponible|
|27X|Art and Archaeology|disponible|
|2CX|SantéPsy (thesaurus)|disponible fr|
|2QZ|Fluid mechanics|disponible|
|37T|Chemistry|disponible|
|3JP|Social Sciences|disponible|
|3WV|Ecotoxicology (thesaurus)|disponible|
|4V5|History and Sciences of Religions|disponible|
|73G|Philosophy|disponible|
|8HQ|Periodic table of the elements (thesaurus)|disponible|
|8LP|Vocabulary of natural language processing (POC)|disponible|
|9SD|Countries and subdivisions (thesaurus)|disponible|
|ADM|Administrative Sciences|disponible|
|ASYSEL|Agriculture and breeding systems|disponible|
|B9M|Primatology (thesaurus)|disponible|
|BJW|Electrical engineering - Electro-energetics|disponible|
|BL8|Artificial Nutrition (thesaurus)|disponible|
|BLH|Biodiversity (thesaurus)|disponible|
|BRMH|Reproduction biotechnology|disponible|
|BVM|NETSCITY Toponyms (France)|disponible|
|C0X|Covid-19 (thesaurus)|disponible|
|CHC|Climate change (Thesaurus)|disponible|
|CUEX|Extrusion cooking|disponible|
|D63|French Communes (thesaurus)|disponible|
|DOM|Scientific fields|disponible|
|EMTD|Microbial ecology of the digestive tract|disponible|
|ERC|ERC panel structure|disponible|
|FMC|Optics|disponible|
|G9G|Fish Taxonomy|disponible|
|GGMGG|Glossary of molecular genetics and genetic engineering|disponible|
|IDIA|Ionization in food industry|disponible|
|JVR|Medical Subject Headings (thesaurus)|disponible|
|KG7|Geography of North America|disponible|
|KW5|Ethnology|disponible|
|LTK|ThesoTM thesaurus|disponible|
|MDL|Astronomy (thesaurus)|disponible|
|NHT|Condensed matter physics|disponible|
|P21|Litterature|disponible|
|P66|Cognitive psychology of human memory (CogMemo thesaurus)|disponible|
|PAN|Sourdough breadmaking glossary|disponible fr|
|PLP|Pedology lexicon|disponible|
|PSR|Mathematics (thesaurus)|disponible|
|Q1W|Agri-food vocabulary|disponible|
|QJP|Engineering sciences vocabulary|disponible|
|QX8|Paleoclimatology (thesaurus)|disponible|
|RDR|Electronics - Optoelectronics|disponible|
|RVQ|Inorganic compounds (thesaurus)|disponible|
|SN8|Signal theory and processing|disponible|
|TECSEM|Technology of seeds|disponible|
|TSM|Membrane-based separation techniques|disponible|
|TSO|Open science (thesaurus)|disponible|
|TSP|Public Health (thesaurus)|disponible fr|
|Theremy|Taxonomy & Thesaurus for Health Research Methodology (THEREMY)|disponible en|
|VH8|Human Diseases (thesaurus)|disponible|
|VPAC|Vocabulary of the Common Agricultural Policy|disponible|
|W7B|Blood Transfusion (thesaurus)|disponible|
|X64|Linguistics|disponible|
|XD4|History of Science and Technology|disponible|
|th63|Zoological Nomenclature (thesaurus)|disponible|
|216|Educational sciences|disponible|
|905|Prehistory and Protohistory|disponible|
