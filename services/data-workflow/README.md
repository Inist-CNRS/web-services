# ws-data-workflow@1.2.8

Enchaînement asynchrone de traitements

Les worflows permettent de traiter des fichiers corpus compressés en appelant
des webservices d'enrichissement par document de manière asynchrone.

## Développement

Ce service web est un cas particulier, parce qu'il appelle d'autres services
web.

Cela rend l'exécution des tests plus délicate.

> **Attention**: si pendant le développement, vous constatez que les tests
> échouent, ça peut être à cause des URL de webhook, qui doivent être
> renouvelées au bout de 7 jours d'inactivité.
>
> L'usage des webhook n'étant pas obligatoire, nous avons choisi de ne pas les
> utiliser pour les tests (en comptant sur un délai minimal pour que le
> traitement soit fini).

Les tests destinés à être joués sur GitHub sont dans `tests.hurl`, mais ils sont
limités à la route `v1/base-line`, qui est la seule à ne pas faire appel à un
service web.

Pour réellement tester les autres routes, servez-vous du fichier
`real-tests.hurl` (qui doit être écrit à la main, et qu'on ne peut pas générer,
car ce sont des services asynchrones, dont le fonctionnement est plus complexe).

Script à lancer pour ces tests là, en local:

```bash
$ npm -w services/data-workflow test

> ws-data-workflow@1.2.8 test
> hurl --test --variable host=http://localhost:31976 real-tests.hurl

real-tests.hurl: Running [1/1]
real-tests.hurl: Success (4 request(s) in 3754 ms)
--------------------------------------------------------------------------------
Executed files:  1
Succeeded files: 1 (100.0%)
Failed files:    0 (0.0%)
Duration:        3755 ms

```
