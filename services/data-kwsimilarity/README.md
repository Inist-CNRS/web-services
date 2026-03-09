# ws-data-kwsimilarity@3.0.0

Extrait les termes sémantiquement proches à un ou plusieurs mots-clés.

Permet d'extraire les termes sémantiquement proches à un ou plusieurs mots-clés dans la requête ayant permis de créer le corpus.

# Pré-requis 
**⚠️ Le Web Service** fonctionne **uniquement** sur des données **`.tar.gz` issues d'Istex**.  
Wrapper utilisé : `query-istex-tar-gz.ini` (data-wrapper)

# Extraction des Mots-Clés : Patterns Acceptés

## Tableau des Patterns

| Cas | Pattern | Exemple | Exemple concret |
|---------|-------------|------------------|------------------|
| **Cas 1** | Pattern 1 | `title:("keyword1" "keyword2" "keyword3")` | `title:("cat" "dog" "chicken")`
| **Cas 2** | Pattern 3 | `title:keyword` | `title:autism`
| **Cas 3** | Pattern 1 | `title:("keyword1 keyword1" "keyword2")` | `title:("sign language" "deafness")`
| **Cas 4** | Pattern 2| `title:"keyword1 keyword1"` | `title:"sign language"`


Pattern 1 : `(?:abstract|title):\(([^)]+)\)`

Pattern 2 : `(?:abstract|title):"([^"]+)`

Pattern 3 : `(?:abstract|title):(\w+)`