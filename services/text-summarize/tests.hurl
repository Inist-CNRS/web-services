POST {{host}}/v1/multilingual?indent=true
content-type: application/json
[
    {"id": "1", "value": "LODEX est un logiciel open source dédié à la valorisation de données structurées. Il facilite la curation et la sémantisation de données brutes pour les connecter au web de données via les normes et les standards du web sémantique. Il propose, en plus de la création automatique d’identifiants, la génération d’identifiants pérennes normalisés via le système des ark. 1 Introduction Les bibliothèques produisent depuis longtemps dans leurs catalogues des données structurées et contrôlées, qu’elles exposent sur le web. Le web sémantique est présenté comme étant le web pour lequel les ordinateurs interprètent les métadonnées afin de mieux assister l’utilisateur dans sa recherche de l’information (Berners-Lee et al., 2001). L’Inist a lancé une expérimentation visant à publier, selon les normes du web sémantique, des données extraites du fonds Istex (plus de 20 millions de publications scientifiques). Cette expérience a eu comme incidence le développement de l'outil Lodex permettant de mettre en ligne des jeux de données dans le respect des normes et standards du web sémantique. Dans cet article nous présenterons brièvement l’archive puis nous développerons l’outil qui a pour but de publier des données extraites de cette archive et ainsi faciliter l’accès et la diffusion des données acquises et produites. Cette publication est réalisée via un site dédié  et un SPARQL endpoint  contenant un graphe global des données 2 L’archive ISTEX Le projet a pour objectif de permettre à la communauté scientifique française d’accéder à une bibliothèque numérique pluridisciplinaire en texte intégral regroupant l’essentiel des publications scientifiques mondiales. Ce réservoir de publications scientifiques est bien entendu à destination des documentalistes et chercheurs ayant un besoin documentaire. C’est également une ressource unique pour tous les chercheurs gravitant autour des thématiques de la fouille de textes, ... (des données structurées au web sémantique Stéphanie Collignon Parmentier , Nicolas Thouvenin Inist-CNRS, 2, Allée du Parc de Brabois, CS 10310, 54519 Vandœuvre-lès-Nancy prenom.nom@inist.fr)"}
]

HTTP 200
[{
    "id": "1",
    "value": "LODEX est un logiciel open source dédié à la valorisation de données structurées. Il facilite la curation et la sémantisation de données brutes pour les connecter au web de données via les normes et les standards du web sémantique. Il propose, en plus de la création automatique d’identifiants, la génération d’identifiants pérennes normalisés via le système des ark. <AI-generated>"
}]

POST {{host}}/v1/en?indent=true
content-type: application/json
[
    {"id": "1", "value": "Introduction In bibliographic databases, affiliations of authors are of paramount importance. Hence, they permit to the laboratories or institutes to get national and even international visibility, as well as they consequently provide authors with scientific caution. We cannot discuss the issue of affiliations without talking of ''Shanghai ranking'' which aims at evaluating universities. Our purpose here is not to feed up the controversy (Van Raan 2005; ), but to point out that the management of affiliation plays an important role in the calculation of universities ''performance''. reports some problems with author's names and also institutions: ''Authors from the same institution, or even from the same department, may not indicate their institutional affiliations in the same way''. Depending on the country, it is not always clear how to name a laboratory with respect to its supervisory authorities. The affiliation is also important information to disambiguate author names in bibliographic databases. In this context, Wang points out that: ''as the amount of available information increases, problem caused by misspelling, spelling difference, and name or affiliation change also become worse'' ( . A standardization of data in bibliographic databases is thus necessary to carry out informetrics studies, but it is not a trivial task: the practice, whatever it is intentional or not, of omitting institutional affiliations, or giving incomplete or wrong information is not uncommon . Each year, the CNRS (the French National Center of Scientific Research) has to spot its laboratories affiliations among the French ones. Many of them are easy to identify automatically thank to key words extraction but, at the issue of this process, it still remains unidentified affiliations . New methods for disambiguation could help the information analysts to be more efficient when labelling. This paper proposes an approach based on Naive Bayes (NB) learning method and overlapping clustering. It is structured as follows: ''State of the art and discussion'' section summarizes related works and identifies problems. Section 3 describes our approach firstly with supervised learning method and then with semi-supervised method. Next, section 4 reports experiments and results..."}
]


HTTP 200
[{
    "id": "1",
    "value": "In bibliographic databases, affiliations of authors are of paramount importance. They permit to the laboratories or institutes to get national and even international visibility. Depending on the country, it is not always clear how to name a laboratory with respect to its supervisory authorities. New methods for disambiguation could help the information analysts to be more efficient when labelling. <AI-generated>"
}]


POST {{host}}/v1/en-pdf?indent=true
Content-Type: application/pdf
[Options]
skip: {{blocked}}
file,./text-summarize-test.pdf;


HTTP 200
[Asserts]
jsonpath "$[0].id" exists
jsonpath "$[0].value" startsWith "TextMine working group aims to bring together researchers"
