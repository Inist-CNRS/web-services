# ws-data-image@0.0.0

Detection of duplicated pattern in images

Detection of duplicated pattern in images

Web service qui détecte, **à l'intérieur d'une même image**, des régions identiques
(copier-coller), même après **rotation**, **changement d'échelle** ou **miroir**.
Il accepte un **PDF** (toutes les images embarquées sont analysées) ou directement
une **image**.

## Dépendances

```
pip install opencv-python numpy pillow pymupdf
```

OpenCV doit être en version 4.4 ou plus (SIFT).

### Entrée (une requête JSON par ligne sur stdin)

```json
{"id": "test/test1.pdf", "value": {"data": [37, 80, 68, 70]}, "PIDxxx": "PID: 4242"}
```

- `id` : nom d'origine du document, de la forme `dossier/fichier.ext`. Il sert à nommer les fichiers de sortie.
- `value.data` : les octets du fichier (liste d'entiers 0-255, format d'un Buffer Node.js sérialisé).
  Une liste d'octets ou une chaîne latin-1 sont aussi acceptées.
- Toute clé qui commence par `PID` : le pid est lu à partir du 6e caractère de sa valeur
  (`"PID: 4242"` donne `4242`). Il sert de nom de dossier et est nettoyé (pas de `../`).
  S'il est absent, il vaut `unknown`.

### Sortie (une réponse JSON par ligne sur stdout)

Succès :

```json
{"value": "Ok", "summary": {
  "pid": "4242",
  "id": "test/test1.pdf",
  "out_dir": "/tmp/retrieve/4242",
  "json_path": "/tmp/retrieve/4242/test__test1_pdf.json",
  "report_path": "/tmp/retrieve/4242/test__test1_pdf.html",
  "report_size_mb": 0.79,
  "image_path": "/tmp/retrieve/4242/test__test1_pdf.png",
  "image_height_px": 14794,
  "n_extracted": 12, "n_analysed": 12, "n_skipped": 0, "n_errors": 0,
  "n_suspicious": 1,
  "suspicious": [{
    "image": "page7_img1",
    "groups": [{"inliers": 124, "ncc": 0.906, "confidence": 68.6,
                "angle_deg": 0.0, "scale": 0.997, "mirrored": false,
                "source_box": [441, 2065, 193, 110],
                "copy_box":   [859, 2186, 193, 110]}]
  }],
  "elapsed_s": 45.3
}}
```

- Les boîtes `[x, y, largeur, hauteur]` sont en pixels de l'image **d'origine**.
- `ncc` : corrélation entre la région source déformée et la copie (1 = identiques).
- `inliers` : nombre de paires de points concordantes. `confidence` : score de 0 à 100.
- Une image sans détection n'apparaît pas dans `suspicious`.

### Fichiers produits

Pour **chaque document** reçu, 3 fichiers sont écrits dans `/tmp/retrieve/<pid>/` :

| Fichier | Contenu |
|---|---|
| `<nom>.json` | La réponse JSON, identique à celle envoyée sur stdout (écrite aussi en cas d'erreur) |
| `<nom>.html` | Le rapport autonome (images incluses). Une carte par image ; les images suspectes montrent l'original, l'annotée et le tableau des groupes |
| `<nom>.png` | L'image de sortie : pour un **PDF**, toutes ses images empilées verticalement ; pour une **image**, l'image seule. Les images suspectes y sont **annotées** (duplications dessinées) |

Si le document n'a aucune image exploitable (PDF sans image), le `.png` n'est pas créé (`image_path` vaut `null`).
Si l'analyse échoue, seul le `.json` (avec l'erreur) est écrit.

**Nom des fichiers.** `<nom>` est dérivé de l'`id` : `/` devient `__`, `.` devient `_`, et tout autre
caractère invalide devient `_`. Les lettres accentuées sont conservées. Exemples :

| id | `<nom>` |
|---|---|
| `test_2/test2.png` | `test_2__test2_png` |
| `test_2/test2.jpg` | `test_2__test2_jpg` |
| `test/test1.pdf` | `test__test1_pdf` |
| `autre/test1.pdf` | `autre__test1_pdf` |

Deux ids différents donnent des noms différents (sauf cas pathologiques comme `a_/b` et `a/_b`).
Aucun `/` ni `..` ne subsiste : un id ne peut pas faire écrire hors de `/tmp/retrieve/<pid>/`.
Un id trop long (> 150 caractères) est tronqué et complété d'une empreinte de l'id complet.
Si `id` est absent, le nom est `unknown` (et un document suivant sans `id` l'écrase).
Un id répété écrase aussi les fichiers précédents.

## La méthode, étape par étape

1) **Récupération des images.** En mode PDF, on extrait chaque image raster embarquée
   (une image réutilisée sur plusieurs pages n'est prise qu'une fois). En mode image,
   on décode le fichier (PNG, JPEG, TIFF...) en appliquant l'orientation EXIF.

2) **Pré-filtre.** On ignore, en indiquant la raison dans le rapport, les images trop petites
   (< 150 px), les bandeaux très allongés (rapport > 8) et celles sans zone texturée.

3) **Réduction.** Le plus grand côté est ramené à 2000 px maximum pour borner le temps de calcul.
   Les résultats sont ensuite remis à l'échelle de l'image d'origine.

4) **Masque des zones « photographiques ».** On ne cherche que dans les zones texturées.
   Les fonds blancs, aplats clairs, axes et légendes sont exclus : ils sont la principale source
   de faux positifs. Les aplats sombres sont conservés (fond noir de fluorescence).

5) **Points d'intérêt.** SIFT, avec descripteurs RootSIFT, limité aux 12 000 points les plus forts.
   Le seuil de contraste est bas pour qu'une bande de Western blot, lisse, ait assez de points.

6) **Appariement g2NN.** Chaque point est comparé aux autres points de la même image. Le ratio
   de Lowe classique échoue dès qu'une région existe en plus de deux exemplaires ; g2NN teste les
   ratios successifs et retrouve toutes les copies. Une deuxième passe compare l'image à son reflet
   horizontal pour détecter les copies en **miroir**.

7) **RANSAC séquentiel (similarité).** Les paires de points qui obéissent à la même transformation
   (rotation + échelle + translation, échelle entre 0,5 et 2) forment un groupe. On retire ce groupe,
   puis on recommence jusqu'à épuisement. Un groupe est retenu à partir de 13 paires concordantes.

8) **Vérification pixel.** C'est l'étape qui fiabilise la détection. On déforme la région source
   avec la transformation estimée et on mesure sa corrélation (NCC) avec la région copie, sur une
   version passe-haut de l'image (le détail fin, pas les dégradés lents). Un vrai copier-coller
   a une NCC élevée (seuil : 0,85). On écarte aussi les régions trop petites, qui se chevauchent
   ou qui sortent de l'image, trop uniformes ou presque blanches.

9) **Rejet du texte.** Du texte répété (étiquettes, légendes) peut passer l'étape 8. Deux critères
   le reconnaissent :
   - traits fins sur fond uni (un blot a un fond uni mais des bandes épaisses ; des cellules ont des
     traits fins mais un fond bruité : il faut les deux conditions) ;
   - ligne de glyphes alignés (au moins 4 composants sombres de taille comparable et alignés).

10) **Dédoublonnage.** Une copie A vers B est aussi vue comme B vers A : on ne garde qu'une
    détection. Les coordonnées sont remises à l'échelle de l'image d'origine.

11) **Annotation, image de sortie et rapport.** Les régions détectées sont dessinées (contour, remplissage
    translucide, flèche source vers copie). L'image de sortie `<nom>.png` empile les images annotées
    (originales si rien n'est détecté ; une image seule est écrite en pleine résolution) et le
    rapport HTML est généré. La réponse JSON est ensuite enregistrée dans `<nom>.json`. Les images sont
    encodées en JPEG réduit pour garder le rapport léger (environ 1 Mo pour 12 images).

## Organisation de `utils.py`

1. `Config` : tous les seuils réglables, commentés.
2. Structures de données : `BoundingBox`, `DuplicationGroup`, `ImageResult`.
3. Pré-filtrage et détection du texte : `_eligibility_mask`, `_thin_ink_ratio`,
   `_text_line_components`, `_should_skip`.
4. `DuplicationDetector` : `detect` (étapes 3 à 10), avec `_features`, `_self_pairs`, `_cross_pairs`,
   `_ransac_clusters`, `_verify_and_dedupe`.
5. Annotation et rapport HTML : `annotate_image`, `generate_html_report`.
6. Lecture des entrées et pipeline : `extract_embedded_images`, `load_image`, `analyse_images`,
   `build_composite`, `process_document` (le point d'entrée appelé par le service).
7. Aide du web service : lecture de la requête (`parse_pid`, `to_bytes`) et sauvegarde des
   résultats (`safe_name`, `output_paths`, `save_json`).

## Réglages utiles

Tous dans `Config` (`utils.py`) :

| Paramètre | Défaut | Effet |
|---|---|---|
| `min_ncc` | 0,85 | Plus bas : plus de détections, plus de faux positifs |
| `min_inliers` | 13 | Plus bas : détecte de plus petites régions (bandes de blot), plus de bruit |
| `max_side` | 2000 | Plus haut : plus fin mais plus lent |
| `detect_mirror` | True | `False` : saute la passe miroir (plus rapide) |
| `scale_range` | (0,5 ; 2,0) | Plage de zoom acceptée entre source et copie |

## Performances et résultats mesurés

Environ 4 à 5 s par grande image (2000 px). Sur des falsifications synthétiques :

| Cas | Détectées |
|---|---|
| Copie sur photos de cellules (translation, rotation + zoom, miroir, JPEG, bruit) | 6 sur 6 |
| Copie d'une bande de Western blot (translation, miroir, rotation + JPEG) | 2 sur 3 |
| Images non modifiées | 0 fausse détection |

Sur un PDF de test contenant 12 figures de publication, aucun faux positif. Sur un autre,
la méthode retrouve un doublon de champ de cellules dans un panneau Transwell.

## Limites

- **Un résultat est un signal à examiner, pas une preuve.** Un humain doit regarder l'image annotée.
- Seules les duplications **dans une même image** sont cherchées, pas entre deux images différentes.
- Des **retouches fortes** (rotation + recompression, flou) peuvent faire manquer une copie, surtout
  sur les blots, qui ont peu de points d'intérêt.
- Les panneaux de **fluorescence multi-canaux** (rouge, bleu, fusion) contiennent légitimement le
  même champ : ils peuvent être signalés à tort si les canaux sont très corrélés.
- Le texte blanc sur fond sombre n'est pas reconnu comme du texte.
- Les images **vectorielles** (non raster) d'un PDF ne sont pas extraites.
