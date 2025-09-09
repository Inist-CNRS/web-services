# ws-text-summarize@1.1.4

Génère un résumé d'un article scientifique.

Utilise un modèle de langue pour générer le résumé d'un article scientifique à partir du texte intégral. La nature du modèle ne permet pas de garantir la reproductibilité des résultats. Si le texte est trop long, la fin du document n'est pas prise en compte (ce qui affecte peu les performances globales du modèle). La route doit être choisie en fonction de la langue du document.

## Précaution

Ce service utilise `Grobid`. Il faut impérativement renseigner la variable d'environnement `GROBID_API_URL` pour son bon déroulement. L'URL renseignée doit contenir la route (i.e. /api/processFulltextDocument). Elle pourra être mis dans un fichier `.env` dans le répertoire du service (`services/text-summarize`).
De la même manière, nous utilisons DVC pour récupérer les modèles sur un webdav. Pour se faire, nous devons renseigner 3 variables d'environnements dans ce même fichier `.env` : `WEBDAV_URL`, `WEBDAV_LOGIN`, `WEBDAV_PASSWORD`.

## Langues supportées

Ce service se base sur le modèle Bart-large et mBart-large-50. Ces deux modèles sont mis à disposition dans deux routes distinctes : `v1/en` et `v1/multilingual`.

###  Route : `en`

langue supportée :

English (en_XX)

### Route : `multilingual`

langues supportées (en anglais):

Arabic (ar_AR), Czech (cs_CZ), German (de_DE), English (en_XX), Spanish (es_XX), Estonian (et_EE), Finnish (fi_FI), French (fr_XX), Gujarati (gu_IN), Hindi (hi_IN), Italian (it_IT), Japanese (ja_XX), Kazakh (kk_KZ), Korean (ko_KR), Lithuanian (lt_LT), Latvian (lv_LV), Burmese (my_MM), Nepali (ne_NP), Dutch (nl_XX), Romanian (ro_RO), Russian (ru_RU), Sinhala (si_LK), Turkish (tr_TR), Vietnamese (vi_VN), Chinese (zh_CN), Afrikaans (af_ZA), Azerbaijani (az_AZ), Bengali (bn_IN), Persian (fa_IR), Hebrew (he_IL), Croatian (hr_HR), Indonesian (id_ID), Georgian (ka_GE), Khmer (km_KH), Macedonian (mk_MK), Malayalam (ml_IN), Mongolian (mn_MN), Marathi (mr_IN), Polish (pl_PL), Pashto (ps_AF), Portuguese (pt_XX), Swedish (sv_SE), Swahili (sw_KE), Tamil (ta_IN), Telugu (te_IN), Thai (th_TH), Tagalog (tl_XX), Ukrainian (uk_UA), Urdu (ur_PK), Xhosa (xh_ZA), Galician (gl_ES), Slovene (sl_SI)


## Références

[Mike Lewis et Al., BART:Denoising Sequence-to-Sequence Pre-training for Natural Language Generation, Translation, and Comprehension, 2019](https://arxiv.org/abs/1910.13461)
[Yuqing Tang et Al., Multilingual Translation with Extensible Multilingual Pretraining and Finetuning, 2020](https://arxiv.org/abs/2008.00401)
