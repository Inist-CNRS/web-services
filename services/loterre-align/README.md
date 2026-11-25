# ws-loterre-align@0.0.0

Alignement asynchrone de ressources SKOS avec les vocabulaires Loterre.

Deux modes : aligner une ressource SKOS televersee avec un vocabulaire Loterre, ou aligner deux vocabulaires Loterre entre eux.
Pipeline : correspondances exactes sur les labels normalises, candidats SBERT (similarite cosinus), puis classification par LLM (Mistral 7B, GGUF quantifie, CPU) en skos:exactMatch / skos:closeMatch / skos:broadMatch / skos:narrowMatch / skos:relatedMatch. Ecriture des alignements SKOS en RDF/XML + rapport JSON.

## Donnees et modele

Les vocabulaires Loterre (P66 CogMemo, D63, 2CX SantePsy) et le modele GGUF sont tires par DVC/WebDAV lors du build Docker (voir `data/*.skos.dvc` et `v1/model_split.dvc`). Aucun appel reseau ensuite : le modele SBERT est pre-charge dans l image et HF_HUB_OFFLINE=1.

## Routes

### POST /v1/align

- query `source` et `target` : `file` (ressource televersee, champ `skos` du body JSON) ou `loterreID:CODE` (vocabulaire Loterre embarque)
- query optionnels : `lang` (defaut fr,en), `min_score` (0.7), `top_k` (5), `no_hierarchy` (false), `max_minutes` (0 = sans limite), `indent`
- body : `[{"skos": "<rdf:RDF>...</rdf:RDF>"}]` ou `[{}]`
- en-tetes optionnels : `X-Webhook-Success`, `X-Webhook-Failure`
- retour : jeton + pointeurs `retrieve-rdf`, `retrieve-report`, `retrieve-status`

Codes de sortie du traitement : 0 ok, 2 entree invalide, 3 modele indisponible, 4 taux d erreur LLM trop eleve, 124 timeout (max_minutes), 130 SIGTERM.

### POST /v1/retrieve-status
Body `[{"value": "<jeton>"}]` -> log JSONL du traitement (evenements candidates/classifying/done).

### POST /v1/retrieve-rdf
Body idem -> fichier d alignements RDF/XML (Content-Type application/rdf+xml).

### POST /v1/retrieve-report
Body idem, query `indent=true` en option -> rapport JSON (compteurs par relation, stats LLM, duree).

## Exemples et tests

- `examples.http` : exemples executables directement (extension REST Client / HTTPYac)
- `tests.hurl` : ecrit a la main (pattern asynchrone : capture du jeton puis polling). Tous les tests en local : `HURL_VARIABLE_blocked=false npm run test:local loterre-align`. En CI (`blocked=true`), seuls les cas rapides tournent ; un alignement complet coute ~2 min en CPU.

## Developpement

```bash
npm -w services/loterre-align run build:check
npm -w services/loterre-align run start:dev
HURL_VARIABLE_blocked=false npm run test:local loterre-align
```

L image se construit avec les secrets WebDAV (voir `.env`, non versionne) : `WEBDAV_URL`, `WEBDAV_LOGIN`, `WEBDAV_PASSWORD`.
