# web-services

Web services at Inist-CNRS

This repository is a work in progress.

It will host the re-implemented web services that are currently at [Inist's
GitBucket](https://gitbucket.inist.fr/tdm/web-services), but using only Docker
images (inspired from
[ezmaster-apps](https://github.com/Inist-CNRS/ezmaster-apps), except that images
won't be as versatile: they won't install npm packages depending on their
`config.json`, nor pip packages depending on their `requirements.txt` at launch,
all installs should be done at image building).

## Contributing

All contributing instructions are in [CONTRIBUTING](CONTRIBUTING.md).

<!-- This section must be the last one, it's automatically rewritten -->
## Services

- [address-kit](./services/address-kit) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-address-kit.svg)](https://hub.docker.com/r/cnrsinist/ws-address-kit/)
- [affiliation-rnsr](./services/affiliation-rnsr) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-affiliation-rnsr.svg)](https://hub.docker.com/r/cnrsinist/ws-affiliation-rnsr/)
- [affiliations-tools](./services/affiliations-tools) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-affiliations-tools.svg)](https://hub.docker.com/r/cnrsinist/ws-affiliations-tools/)
- [ark-tools](./services/ark-tools) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-ark-tools.svg)](https://hub.docker.com/r/cnrsinist/ws-ark-tools/)
- [astro-ner](./services/astro-ner) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-astro-ner.svg)](https://hub.docker.com/r/cnrsinist/ws-astro-ner/)
- [authors-tools](./services/authors-tools) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-authors-tools.svg)](https://hub.docker.com/r/cnrsinist/ws-authors-tools/)
- [base-line-python](./services/base-line-python) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-base-line-python.svg)](https://hub.docker.com/r/cnrsinist/ws-base-line-python/)
- [base-line](./services/base-line) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-base-line.svg)](https://hub.docker.com/r/cnrsinist/ws-base-line/)
- [biblio-ref](./services/biblio-ref) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-biblio-ref.svg)](https://hub.docker.com/r/cnrsinist/ws-biblio-ref/)
- [biblio-tools](./services/biblio-tools) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-biblio-tools.svg)](https://hub.docker.com/r/cnrsinist/ws-biblio-tools/)
- [chem-ner](./services/chem-ner) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-chem-ner.svg)](https://hub.docker.com/r/cnrsinist/ws-chem-ner/)
- [data-computer](./services/data-computer) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-data-computer.svg)](https://hub.docker.com/r/cnrsinist/ws-data-computer/)
- [data-termsuite](./services/data-termsuite) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-data-termsuite.svg)](https://hub.docker.com/r/cnrsinist/ws-data-termsuite/)
- [data-workflow](./services/data-workflow) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-data-workflow.svg)](https://hub.docker.com/r/cnrsinist/ws-data-workflow/)
- [data-wrapper](./services/data-wrapper) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-data-wrapper.svg)](https://hub.docker.com/r/cnrsinist/ws-data-wrapper/)
- [diseases-ner](./services/diseases-ner) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-diseases-ner.svg)](https://hub.docker.com/r/cnrsinist/ws-diseases-ner/)
- [domains-classifier](./services/domains-classifier) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-domains-classifier.svg)](https://hub.docker.com/r/cnrsinist/ws-domains-classifier/)
- [funder-ner](./services/funder-ner) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-funder-ner.svg)](https://hub.docker.com/r/cnrsinist/ws-funder-ner/)
- [hal-classifier](./services/hal-classifier) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-hal-classifier.svg)](https://hub.docker.com/r/cnrsinist/ws-hal-classifier/)
- [irc3-species](./services/irc3-species) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-irc3-species.svg)](https://hub.docker.com/r/cnrsinist/ws-irc3-species/)
- [nlp-tools2](./services/nlp-tools2) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-nlp-tools2.svg)](https://hub.docker.com/r/cnrsinist/ws-nlp-tools2/)
- [pdf-text](./services/pdf-text) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-pdf-text.svg)](https://hub.docker.com/r/cnrsinist/ws-pdf-text/)
- [sciencemetrix-classification](./services/sciencemetrix-classification) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-sciencemetrix-classification.svg)](https://hub.docker.com/r/cnrsinist/ws-sciencemetrix-classification/)
- [terms-extraction](./services/terms-extraction) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-terms-extraction.svg)](https://hub.docker.com/r/cnrsinist/ws-terms-extraction/)
