# ws-data-workflow@1.11.1

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

Pour réellement tester les autres routes, utilisez la variable `HURL_blocked`, et mettez-la à `false`, pour signaler que vous lancez les tests depuis une adresse IP autorisée à accéder aux services ISTEX:

```bash
HURL_blocked=false npm run test:local data-workflow
```
