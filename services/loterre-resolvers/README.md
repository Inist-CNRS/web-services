# ws-loterre-resolvers@6.2.7

Résolveurs pour des terminologies Loterre

Fait appel aux vocabulaires Loterre pour obtenir des informations dans différentes domaines.

## download.cfg

- `[exchange]` récupère l'URL du skos  
- `[URLStream]` requête l'URL (et donc récupère du XML)  
- `[XMLParse]` récupère tout ce qui est sous `/rdf:RDF/skos:Concept`  
- `[assign]`  

    1. met dans `indexKeys` un tableau  
       construit à partir d'un tableau `[skos$prefLabel, skos$altLabel, skos$hiddenLabel]` (les différents labels (?))  
       aplatit  
       seulement les balises contenant directement du texte  
       map récupère le texte, et supprime les diacritiques et les caractères spéciaux, et met tout en bas de casse  
       dédoublonne  
    2. met dans `score` le contenu de la balise `owl$deprecated`, et le transforme en `1` si c'est `true` et `2` sinon
`[save]` sauve dans la "base" `location` (positionné par exemple dans `combine.cfg`, et qui vaut alors `/tmp/databases/2XK`)  
    le "fichier"/`domain` `loterre-2XKconcepts`,  
    avec un paramètre `path` qui vaut `rdf$about` (sans doute l'identifiant `uri`)  
    renvoie l'entrée

-`[pop]` récupère le dernier item de l'entrée  
-`[replace]` renvoie `{"state": "download"}`  

Exemples:

`/tmp/databases/39/2XK/db/loterre-2XKindexes/content-v2/sha512/00/00/80577b51604825bcbeae873a9579092c7e311d6055267216f7f2f7977f1ffe2e222006ad831e79617cef0d537e36d7097e52deb86e39c610a619473cd75d`:

```json
{"id":"umr7306","value":"http://data.loterre.fr/ark:/67375/2XK-32422","score":2}
```

`/tmp/databases/39/2XK/db/loterre-2XKconcepts/content-v2/sha512/00/06/4f2be5358196d564f3f63efb9d1d565b02b91ecb732ec35d52eb28d0130d3f6cf79125f23d5ed5ec96a410c5e120df209d493d3bf8f1e344daca94f94d37`:

```json
{
  "rdf$about": "http://data.loterre.fr/ark:/67375/2XK-1500003546",
  "skos$prefLabel": [
    {
      "xml$lang": "fr",
      "$t": "INSTITUT AGRONOMIQUE MEDITERRANEEN DE MONTPELLIER"
    },
    {
      "xml$lang": "en",
      "$t": "Mediterranean Agronomic Institute of Montpellier"
    }
  ],
  "skos$altLabel": [
    {
      "xml$lang": "fr"
    },
    {
      "xml$lang": "fr",
      "$t": "SNC9023"
    }
  ],
  "wdt$P1705": {
    "$t": "INSTITUT AGRONOMIQUE MEDITERRANEEN DE MONTPELLIER"
  },
  "rdf$type": {
    "rdf$resource": "http://xmlns.com/foaf/0.1/Organization"
  },
  "skos$inScheme": {
    "rdf$resource": "http://data.loterre.fr/ark:/67375/2XK"
  },
  "skos$hiddenLabel": {
    "xml$lang": "fr",
    "$t": "SNC 9023"
  },
  "wdt$P4550": {
    "$t": "SNC9023"
  },
  "wdt$P31": {
    "$t": "structure non CNRS"
  },
  "vcard$hasAddress": {
    "rdf$parseType": "Resource",
    "vcard$street-address": {
      "$t": "3191 route de Mende"
    },
    "vcard$postal-code": {
      "$t": "34093"
    },
    "vcard$locality": {
      "$t": "Montpellier"
    },
    "vcard$country-name": {
      "$t": "France"
    }
  },
  "wdt$P580": {
    "$t": "01-01-2007"
  },
  "wdt$P582": {
    "$t": "29-06-2011"
  },
  "skos$historyNote": {
    "xml$lang": "fr",
    "$t": "Structure fermée le 29-06-2011."
  },
  "inist$dr_cnrs_impl": {
    "$t": "13"
  },
  "inist$tutellePrincipale": {
    "$t": "INSTITUT AGRONOMIQUE MEDITERRANEEN DE MONTPELLIER"
  },
  "inist$institutPrincipal": {
    "$t": "Institut écologie et environnement"
  },
  "org$siteAddress": {
    "$t": "3191 route de Mende 34093 Montpellier, France"
  },
  "skos$broader": [
    {
      "rdf$resource": "http://data.loterre.fr/ark:/67375/2XK-8986"
    },
    {
      "rdf$resource": "http://data.loterre.fr/ark:/67375/2XK-28"
    }
  ],
  "indexKeys": [
    "institutagronomiquemediterraneendemontpellier",
    "mediterraneanagronomicinstituteofmontpellier",
    "snc9023"
  ],
  "score": 2
}
```

File: `/tmp/databases/39/2XK/db/loterre-vocabulaires-loaded/content-v2/sha512/b8/d5/1613a7c33554defe9cf3f65dc4e3f7e7e7ef3f6890e9d9bdc776d3d73d85a1b28f0cecf33a50f8d0c2623f1545803fbfd71a6953b07af3945d730ceb95bb`

```json
{"id":"00000000000000000001","value":"gdr3753","loterreID":"2XK","primer":"http://mapping-tables.daf.intra.inist.fr/loterre-structures-recherche.xml"}
```
