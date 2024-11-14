# ws-thesesul-sudoctohal@1.0.0

Transforme des thèses UL en TEI pour import dans HAL

A partir d'identifiants Sudoc, ce service web télécharge les XML et PDF en provenance du Sudoc. Les XML sont transformés dans un format TEI pour import dans Hal.

## Utilisation simple

Pour une demande d'import de thèses d'exercices à partir d'un identifiant Sudoc voici la procédure à suivre :

- Mettre l'ensemble de ces identifiants dans une colonne d'un csv, par exemple `sudoc_id`
- Exécuter ce web service sur ce fichier csv dans IA factory sur la colonne précédemment créée (ici `sudoc_id`)
- Le document réponse est constitué d'un répertoire datas et d'un fichier `logs.csv`.
- Vérifier que le dossier datas contient autant de fichiers que d'identifiants en entrée. Il peut y avoir un léger écart : vérifier que ces fichiers sont bien en erreur dans les logs. Très important : l'erreur "Le PDF n'a pas pu être récupérée" n'est pas bloquante et ne doit donc pas être comptabilisée dans cette vérification.
- Concernant le dossier datas, il est constitué d'un ensemble de fichier `x.zip` ou `x.xml` (où `x` est l'identifiant du Sudoc en entrée). Si le fichier est en `.xml`, c'est qu'il a été impossible de récupérer le PDF et il sera *push* sans (et c'est indiqué dans le fichier de logs)
- (En test encore): Ensuite, on utilise le script bash `v1/push-on-hal.sh` pour push l'ensemble des fichiers de ce dossier. Après avoir vérifié que le script est exécutable, le script peut être simplement utilisé comme suit : `./send_files.sh /chemin/vers/dossier/datas`.
