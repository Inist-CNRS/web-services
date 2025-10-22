Fait appel aux vocabulaires [Loterre](https://loterre.istex.fr/) pour obtenir
des informations dans différents domaines.  

Trois services sont proposés :

1. [`/v1/identify`](#loterre-resolvers/post-v1-identify) : à partir d'un tableau
   de termes, renvoie au moins un identifiant, les verbalisations anglaise et
   française, et éventuellement d'autres informations.  
2. [`/v1/expand`](#loterre-resolvers/post-v1-expand) : à partir d'un tableau de
   termes, renvoie un objet SKOS (au format JSON) du vocabulaire correspondant.  
3. [`/v1/annotate`](#loterre-resolvers/post-v1-annotate) : à partir d'un texte,
   renvoie un tableau de concepts SKOS correspondants (au format JSON).  

> 📝 **Note** : les services sont accessibles via une route
> `/v1/service?loterreID={loterreID}`, où `{loterreID}` est l'identifiant du
> vocabulaire Loterre à utiliser (ex: `9SD` pour le vocabulaire des pays).  

> ⚠️ **Avertissement** : les anciennes routes des services sont toujours
> disponibles, mais sont dépréciées. Il s'agit des routes `/v1/{loterreID}/service`, où
> `{loterreID}` est l'identifiant du vocabulaire Loterre à utiliser (ex: `9SD`
> pour le vocabulaire des pays).  

### Liste des vocabulaires disponibles

- `1WB` : Transferts de chaleur
- `216` : Éducation
- `26L` : Sciences de la terre
- `27X` : Art et Archéologie
- `2XK` : Laboratoires
- `3JP` : Sociologie
- `3WV` : Écotoxicologie
- `4V5` : Histoire et sciences des religions
- `73G` : Philosophie
- `8HQ` : Tableau périodique des éléments
- `8LP` : Traitement automatique des langues
- `905` : Préhistoire
- `9SD` : Pays et subdivisions
- `BLH` : Biodiversité
- `BRMH` : Biotechnologies de la reproduction
- `BVM` : NETSCITY
- `C0X` : Covid-19
- `CUEX` : Cuisson-extrusion
- `D63` : Communes (France)
- `DOM` : Domaines scientifiques
- `EMTD` : Écologie microbienne du tube digestif
- `ERC` : Classification de l'ERC
- `FMC` : Optique
- `G9G` : Taxonomie des poissons
- `GGMGG` : Génétique moléculaire
- `GT` : Géographie
- `IDIA` : Ionisation dans l'industrie agro-alimentaire
- `JVR` : MESH
- `KG7` : Géographie de l'Amérique du Nord
- `KW5` : Ethnologie
- `LTK` : ThesoTM
- `MDL` : Astronomie
- `N9J` : SAGE
- `NHT` : Physique de l'état condensé
- `P21` : Littérature
- `P66` : Mémoire
- `PAN` : Panification au levain naturel
- `PSR` : Mathématiques
- `QX8` : Paléoclimatologie
- `RDR` : Électronique
- `RVQ` : Composés inorganiques
- `SN8` : Traitement du signal
- `th63` : Nomenclature zoologique
- `TSM` : Techniques de séparation par membranes
- `TSO` : Science ouverte
- `TSP` : Santé publique
- `VH8` : Pathologies humaines
- `VPAC` : Politique Agricole Commune
- `W7B` : Transfusion sanguine
- `XD4` : Histoire des sciences et techniques
