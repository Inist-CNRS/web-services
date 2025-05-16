# ws-table-extraction@0.0.0

Extract tables from pdf files

Web service to extract tables from pdf files

## Paramètres optionnels

### format
Format de sortie du tableau.
 
Plusieurs choix possibles : (Voir librairie python img2table pour plus d'informations sur les différents formats)
- (Par défaut) 'index' : dict like {index -> {column -> value}} empty : `
- 'dict' : dict like {column -> {index -> value}} empty : ``
- 'list' : dict like {column -> [values]} empty : ``
- 'series' : dict like {column -> Series(values)} empty : ``
- 'split' : dict like empty : {'index' -> [index], 'columns' -> [columns], 'data' -> [values]} **empty** :
- 'records' : list like empty : [{column -> value}, ... , {column -> value}] **empty** :
- 'index' : dict like {index -> {column -> value}} empty : ``

### lang
Langue du document. (Voir tesseractOCR pour plus de langues)

Défaut "eng"
