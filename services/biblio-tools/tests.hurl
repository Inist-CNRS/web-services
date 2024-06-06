POST {{host}}/v1/unpaywall/is_oa?indent=true
content-type: application/json
[
  {  "id":1, "value": "10.1016/j.fuel.2018.07.071" },
  {  "id":2, "value": "10.1007/s10980-018-0699-8" },
  {  "id":3, "value": "10.1159/000490004" },
  {  "id":4, "value": "10.1016/j.memsci.2018.08.024"},
  {  "id":5, "value": "10.1029/2018jd029272"},
  {  "id":6, "value": "10.4000/edc.9014"},
  {  "id":7, "value": "unknown"}
]

HTTP 200
[{
    "id": 1,
    "value": false
},
{
    "id": 2,
    "value": false
},
{
    "id": 3,
    "value": false
},
{
    "id": 4,
    "value": false
},
{
    "id": 5,
    "value": true
},
{
    "id": 6,
    "value": true
},
{
    "id": 7,
    "value": "n/a"
}]

POST {{host}}/v1/unpaywall/expand?indent=true
content-type: application/json
[
  { "id":1,  "value": "10.1016/j.fuel.2018.07.071" },
  { "id":2,  "value": "10.1007/s10980-018-0699-8" },
  { "id":3,  "value": "10.1159/000490004" },
  { "id":4,  "value": "10.1016/j.memsci.2018.08.024"},
  { "id":5,  "value": "10.1029/2018jd029272"},
  { "id":6,  "value": "10.4000/edc.9014"},
  { "id":7,  "value": "unknown"}
]

HTTP 200
[{
    "id": 1,
    "value": {
        "doi": "10.1016/j.fuel.2018.07.071",
        "is_oa": false,
        "oa_status": "closed",
        "has_repository_copy": false,
        "host_type": "n/a"
    }
},
{
    "id": 2,
    "value": {
        "doi": "10.1007/s10980-018-0699-8",
        "is_oa": false,
        "oa_status": "closed",
        "has_repository_copy": false,
        "host_type": "n/a"
    }
},
{
    "id": 3,
    "value": {
        "doi": "10.1159/000490004",
        "is_oa": false,
        "oa_status": "closed",
        "has_repository_copy": false,
        "host_type": "n/a"
    }
},
{
    "id": 4,
    "value": {
        "doi": "10.1016/j.memsci.2018.08.024",
        "is_oa": false,
        "oa_status": "closed",
        "has_repository_copy": false,
        "host_type": "n/a"
    }
},
{
    "id": 5,
    "value": {
        "doi": "10.1029/2018jd029272",
        "is_oa": true,
        "oa_status": "hybrid",
        "has_repository_copy": true,
        "host_type": "publisher"
    }
},
{
    "id": 6,
    "value": {
        "doi": "10.4000/edc.9014",
        "is_oa": true,
        "oa_status": "bronze",
        "has_repository_copy": false,
        "host_type": "publisher"
    }
},
{
    "id": 7,
    "value": "n/a"
}]

POST {{host}}/v1/unpaywall/corhal?indent=true
content-type: application/json
[
  { "id":1, "value": "10.1016/j.fuel.2018.07.071" },
  { "id":2, "value": "10.1007/s10980-018-0699-8" },
  { "id":3, "value": "10.1159/000490004" },
  { "id":4, "value": "10.1016/j.memsci.2018.08.024"},
  { "id":5, "value": "10.1029/2018jd029272"},
  { "id":6, "value": "10.4000/edc.9014"},
  { "id":7, "value": "unknown"}
]

HTTP 200
[{
    "id": 1,
    "value": {
        "doi": "10.1016/j.fuel.2018.07.071",
        "is_oa": false,
        "oa_status": "closed",
        "has_repository_copy": false,
        "oa_locations": []
    }
},
{
    "id": 2,
    "value": {
        "doi": "10.1007/s10980-018-0699-8",
        "is_oa": false,
        "oa_status": "closed",
        "has_repository_copy": false,
        "oa_locations": []
    }
},
{
    "id": 3,
    "value": {
        "doi": "10.1159/000490004",
        "is_oa": false,
        "oa_status": "closed",
        "has_repository_copy": false,
        "oa_locations": []
    }
},
{
    "id": 4,
    "value": {
        "doi": "10.1016/j.memsci.2018.08.024",
        "is_oa": false,
        "oa_status": "closed",
        "has_repository_copy": false,
        "oa_locations": []
    }
},
{
    "id": 5,
    "value": {
        "doi": "10.1029/2018jd029272",
        "is_oa": true,
        "oa_status": "hybrid",
        "has_repository_copy": true,
        "oa_locations": [
            {
                "host_type": "publisher",
                "is_best": true,
                "license": "cc-by-nc-nd",
                "url": "https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/10.1029/2018JD029272",
                "url_for_landing_page": "https://doi.org/10.1029/2018jd029272",
                "url_for_pdf": "https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/10.1029/2018JD029272",
                "version": "publishedVersion"
            },
            {
                "host_type": "repository",
                "is_best": false,
                "license": "cc-by-nc-nd",
                "url": "https://europepmc.org/articles/pmc6472622?pdf=render",
                "url_for_landing_page": "https://europepmc.org/articles/pmc6472622",
                "url_for_pdf": "https://europepmc.org/articles/pmc6472622?pdf=render",
                "version": "publishedVersion"
            },
            {
                "host_type": "repository",
                "is_best": false,
                "license": null,
                "url": "https://hal-insu.archives-ouvertes.fr/insu-01957355/file/Albrechtsen_et_al-2019-Journal_of_Geophysical_Research__Atmospheres.pdf",
                "url_for_landing_page": "https://hal-insu.archives-ouvertes.fr/insu-01957355/file/Albrechtsen_et_al-2019-Journal_of_Geophysical_Research__Atmospheres.pdf",
                "url_for_pdf": "https://hal-insu.archives-ouvertes.fr/insu-01957355/file/Albrechtsen_et_al-2019-Journal_of_Geophysical_Research__Atmospheres.pdf",
                "version": "publishedVersion"
            },
            {
                "host_type": "repository",
                "is_best": false,
                "license": null,
                "url": "https://hal-insu.archives-ouvertes.fr/insu-01957355/document",
                "url_for_landing_page": "https://hal-insu.archives-ouvertes.fr/insu-01957355/document",
                "url_for_pdf": "https://hal-insu.archives-ouvertes.fr/insu-01957355/document",
                "version": "publishedVersion"
            },
            {
                "host_type": "repository",
                "is_best": false,
                "license": null,
                "url": "https://insu.hal.science/insu-01957355/document",
                "url_for_landing_page": "https://hal-insu.archives-ouvertes.fr/insu-01957355",
                "url_for_pdf": "https://insu.hal.science/insu-01957355/document",
                "version": "publishedVersion"
            },
            {
                "host_type": "repository",
                "is_best": false,
                "license": null,
                "url": "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6472622",
                "url_for_landing_page": "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6472622",
                "url_for_pdf": null,
                "version": "publishedVersion"
            }
        ]
    }
},
{
    "id": 6,
    "value": {
        "doi": "10.4000/edc.9014",
        "is_oa": true,
        "oa_status": "bronze",
        "has_repository_copy": false,
        "oa_locations": [
            {
                "host_type": "publisher",
                "is_best": true,
                "license": null,
                "url": "https://journals.openedition.org/edc/pdf/9014",
                "url_for_landing_page": "https://doi.org/10.4000/edc.9014",
                "url_for_pdf": "https://journals.openedition.org/edc/pdf/9014",
                "version": "publishedVersion"
            }
        ]
    }
},
{
    "id": 7,
    "value": "n/a"
}]

POST {{host}}/v1/unpaywall/works/expand?indent=true
content-type: application/json
[
  {  "id":1, "value": "10.1016/j.fuel.2018.07.071" },
  {  "id":2, "value": "10.1007/s10980-018-0699-8" },
  {  "id":3, "value": "10.1159/000490004" },
  {  "id":4, "value": "10.1016/j.memsci.2018.08.024"},
  {  "id":5, "value": "10.1029/2018jd029272"},
  {  "id":6, "value": "10.4000/edc.9014"},
  {  "id":7, "value": "unknown"}
]

HTTP 200
[{
    "id": 1,
    "value": {
        "doi": "10.1016/j.fuel.2018.07.071",
        "data_standard": 2,
        "genre": "journal-article",
        "is_paratext": false,
        "is_oa": false,
        "journal_is_in_doaj": false,
        "journal_is_oa": false,
        "journal_issns": "0016-2361",
        "journal_issn_l": "0016-2361",
        "journal_name": "Fuel",
        "oa_status": "closed",
        "has_repository_copy": false,
        "published_date": "2018-12-01",
        "publisher": "Elsevier BV",
        "title": "Development of a Ni-CaO-mayenite combined sorbent-catalyst material for multicycle sorption enhanced steam methane reforming",
        "updated": "2021-01-14T02:41:25.682220",
        "year": "2018",
        "oa_locations": [],
        "first_oa_location": null
    }
},
{
    "id": 2,
    "value": {
        "doi": "10.1007/s10980-018-0699-8",
        "data_standard": 2,
        "genre": "journal-article",
        "is_paratext": false,
        "is_oa": false,
        "journal_is_in_doaj": false,
        "journal_is_oa": false,
        "journal_issns": "0921-2973,1572-9761",
        "journal_issn_l": "0921-2973",
        "journal_name": "Landscape Ecology",
        "oa_status": "closed",
        "has_repository_copy": false,
        "published_date": "2018-08-18",
        "publisher": "Springer Science and Business Media LLC",
        "title": "Issues and challenges in landscape models for agriculture: from the representation of agroecosystems to the design of management strategies",
        "updated": "2023-07-30T01:05:38.913258",
        "year": "2018",
        "oa_locations": [],
        "first_oa_location": null
    }
},
{
    "id": 3,
    "value": {
        "doi": "10.1159/000490004",
        "data_standard": 2,
        "genre": "journal-article",
        "is_paratext": false,
        "is_oa": false,
        "journal_is_in_doaj": false,
        "journal_is_oa": false,
        "journal_issns": "1018-2438,1423-0097",
        "journal_issn_l": "1018-2438",
        "journal_name": "International Archives of Allergy and Immunology",
        "oa_status": "closed",
        "has_repository_copy": false,
        "published_date": "2018-01-01",
        "publisher": "S. Karger AG",
        "title": "Do &lt;b&gt;&lt;i&gt;Plantago lanceolata&lt;/i&gt;&lt;/b&gt; Skin Prick Test-Positive Patients Display IgE to Genuine Plantain Pollen Allergens? Investigation of Pollen Allergic Patients from the North-East of France",
        "updated": "2023-06-07T19:24:20.457224",
        "year": "2018",
        "oa_locations": [],
        "first_oa_location": null
    }
},
{
    "id": 4,
    "value": {
        "doi": "10.1016/j.memsci.2018.08.024",
        "data_standard": 2,
        "genre": "journal-article",
        "is_paratext": false,
        "is_oa": false,
        "journal_is_in_doaj": false,
        "journal_is_oa": false,
        "journal_issns": "0376-7388",
        "journal_issn_l": "0376-7388",
        "journal_name": "Journal of Membrane Science",
        "oa_status": "closed",
        "has_repository_copy": false,
        "published_date": "2018-11-01",
        "publisher": "Elsevier BV",
        "title": "Optimization of multistage membrane gas separation processes. Example of application to CO2 capture from blast furnace gas",
        "updated": "2023-10-02T05:58:05.244015",
        "year": "2018",
        "oa_locations": [],
        "first_oa_location": null
    }
},
{
    "id": 5,
    "value": {
        "doi": "10.1029/2018jd029272",
        "data_standard": 2,
        "genre": "journal-article",
        "is_paratext": false,
        "is_oa": true,
        "journal_is_in_doaj": false,
        "journal_is_oa": false,
        "journal_issns": "2169-897X,2169-8996",
        "journal_issn_l": "2169-897X",
        "journal_name": "Journal of Geophysical Research: Atmospheres",
        "oa_status": "hybrid",
        "has_repository_copy": true,
        "published_date": "2019-01-11",
        "publisher": "American Geophysical Union (AGU)",
        "title": "Observationally Weak TGFs in the RHESSI Data",
        "updated": "2023-09-30T04:49:09.551312",
        "year": "2019",
        "oa_locations": [
            {
                "host_type": "publisher",
                "is_best": true,
                "license": "cc-by-nc-nd",
                "url": "https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/10.1029/2018JD029272",
                "url_for_landing_page": "https://doi.org/10.1029/2018jd029272",
                "url_for_pdf": "https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/10.1029/2018JD029272"
            },
            {
                "host_type": "repository",
                "is_best": false,
                "license": "cc-by-nc-nd",
                "url": "https://europepmc.org/articles/pmc6472622?pdf=render",
                "url_for_landing_page": "https://europepmc.org/articles/pmc6472622",
                "url_for_pdf": "https://europepmc.org/articles/pmc6472622?pdf=render"
            },
            {
                "host_type": "repository",
                "is_best": false,
                "license": null,
                "url": "https://hal-insu.archives-ouvertes.fr/insu-01957355/file/Albrechtsen_et_al-2019-Journal_of_Geophysical_Research__Atmospheres.pdf",
                "url_for_landing_page": "https://hal-insu.archives-ouvertes.fr/insu-01957355/file/Albrechtsen_et_al-2019-Journal_of_Geophysical_Research__Atmospheres.pdf",
                "url_for_pdf": "https://hal-insu.archives-ouvertes.fr/insu-01957355/file/Albrechtsen_et_al-2019-Journal_of_Geophysical_Research__Atmospheres.pdf"
            },
            {
                "host_type": "repository",
                "is_best": false,
                "license": null,
                "url": "https://hal-insu.archives-ouvertes.fr/insu-01957355/document",
                "url_for_landing_page": "https://hal-insu.archives-ouvertes.fr/insu-01957355/document",
                "url_for_pdf": "https://hal-insu.archives-ouvertes.fr/insu-01957355/document"
            },
            {
                "host_type": "repository",
                "is_best": false,
                "license": null,
                "url": "https://insu.hal.science/insu-01957355/document",
                "url_for_landing_page": "https://hal-insu.archives-ouvertes.fr/insu-01957355",
                "url_for_pdf": "https://insu.hal.science/insu-01957355/document"
            },
            {
                "host_type": "repository",
                "is_best": false,
                "license": null,
                "url": "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6472622",
                "url_for_landing_page": "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6472622",
                "url_for_pdf": null
            }
        ],
        "first_oa_location": {
            "host_type": "publisher",
            "is_best": true,
            "license": "cc-by-nc-nd",
            "pmh_id": null,
            "updated": "2023-09-30T04:49:04.016472",
            "url": "https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/10.1029/2018JD029272",
            "url_for_landing_page": "https://doi.org/10.1029/2018jd029272",
            "url_for_pdf": "https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/10.1029/2018JD029272",
            "version": "publishedVersion"
        }
    }
},
{
    "id": 6,
    "value": {
        "doi": "10.4000/edc.9014",
        "data_standard": 2,
        "genre": "journal-article",
        "is_paratext": false,
        "is_oa": true,
        "journal_is_in_doaj": false,
        "journal_is_oa": false,
        "journal_issns": "1270-6841,2101-0366",
        "journal_issn_l": "1270-6841",
        "journal_name": "Études de communication",
        "oa_status": "bronze",
        "has_repository_copy": false,
        "published_date": "2019-06-01",
        "publisher": "OpenEdition",
        "title": "Da Sylva Lyne, Cuxac Pascal : Analyse et exploitation des bibliothèques numériques",
        "updated": "2021-11-01T12:30:00.077333",
        "year": "2019",
        "oa_locations": [
            {
                "host_type": "publisher",
                "is_best": true,
                "license": null,
                "url": "https://journals.openedition.org/edc/pdf/9014",
                "url_for_landing_page": "https://doi.org/10.4000/edc.9014",
                "url_for_pdf": "https://journals.openedition.org/edc/pdf/9014"
            }
        ],
        "first_oa_location": {
            "host_type": "publisher",
            "is_best": true,
            "license": null,
            "pmh_id": null,
            "updated": "2020-09-25T06:33:41.668781",
            "url": "https://journals.openedition.org/edc/pdf/9014",
            "url_for_landing_page": "https://doi.org/10.4000/edc.9014",
            "url_for_pdf": "https://journals.openedition.org/edc/pdf/9014",
            "version": "publishedVersion"
        }
    }
},
{
    "id": 7,
    "value": "n/a"
}]

POST {{host}}/v1/crossref/prefixes/expand?indent=true
content-type: application/json
[
  {  "id":1, "value": "10.3998"},
  {  "id":2, "value": "10.1016" },
  {  "id":3, "value": "10.1007" },
  {  "id":4, "value": "10.1159" },
  {  "id":5, "value": "10.1037"},
  {  "id":6, "value": "unknown"}
]

HTTP 200
[{
    "id": 1,
    "value": "University of Michigan Library"
},
{
    "id": 2,
    "value": "Elsevier BV"
},
{
    "id": 3,
    "value": "Springer Science and Business Media LLC"
},
{
    "id": 4,
    "value": "S. Karger AG"
},
{
    "id": 5,
    "value": "American Psychological Association (APA)"
},
{
    "id": 6,
    "value": "n/a"
}]

POST {{host}}/v1/crossref/works/expand?indent=true
content-type: application/json
[
  { "id":1,  "value": "10.1016/j.fuel.2018.07.071" },
  { "id":2,  "value": "10.1007/s10980-018-0699-8" },
  { "id":3,  "value": "10.1159/000490004" },
  { "id":4,  "value": "10.1016/j.memsci.2018.08.024"},
  { "id":5,  "value": "10.1029/2018jd029272"},
  { "id":6,  "value": "10.4000/edc.9014"},
  { "id":7,  "value": "unknown"}
]

HTTP 200
[{
    "id": 1,
    "value": {
        "indexed/date-parts": [
            [
                2023,
                9,
                28
            ]
        ],
        "indexed/date-time": "2023-09-28T21:12:47Z",
        "indexed/timestamp": 1695935567132,
        "reference-count": 64,
        "publisher": "Elsevier BV",
        "license": [
            {
                "start": {
                    "date-parts": [
                        [
                            2018,
                            12,
                            1
                        ]
                    ],
                    "date-time": "2018-12-01T00:00:00Z",
                    "timestamp": 1543622400000
                },
                "content-version": "tdm",
                "delay-in-days": 0,
                "URL": "https://www.elsevier.com/tdm/userlicense/1.0/"
            }
        ],
        "content-domain/domain": [
            "elsevier.com",
            "sciencedirect.com"
        ],
        "content-domain/crossmark-restriction": true,
        "short-container-title": [
            "Fuel"
        ],
        "published-print/date-parts": [
            [
                2018,
                12
            ]
        ],
        "DOI": "10.1016/j.fuel.2018.07.071",
        "type": "journal-article",
        "created/date-parts": [
            [
                2018,
                7,
                23
            ]
        ],
        "created/date-time": "2018-07-23T09:47:22Z",
        "created/timestamp": 1532339242000,
        "page": "687-699",
        "update-policy": "http://dx.doi.org/10.1016/elsevier_cm_policy",
        "source": "Crossref",
        "is-referenced-by-count": 49,
        "title": [
            "Development of a Ni-CaO-mayenite combined sorbent-catalyst material for multicycle sorption enhanced steam methane reforming"
        ],
        "prefix": "10.1016",
        "volume": "234",
        "author": [
            {
                "given": "A.",
                "family": "Di Giuliano",
                "sequence": "first",
                "affiliation": []
            },
            {
                "given": "F.",
                "family": "Giancaterino",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "given": "C.",
                "family": "Courson",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "given": "P.U.",
                "family": "Foscolo",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "given": "K.",
                "family": "Gallucci",
                "sequence": "additional",
                "affiliation": []
            }
        ],
        "member": "78",
        "container-title": [
            "Fuel"
        ],
        "language": "en",
        "link": [
            {
                "URL": "https://api.elsevier.com/content/article/PII:S0016236118312705?httpAccept=text/xml",
                "content-type": "text/xml",
                "content-version": "vor",
                "intended-application": "text-mining"
            },
            {
                "URL": "https://api.elsevier.com/content/article/PII:S0016236118312705?httpAccept=text/plain",
                "content-type": "text/plain",
                "content-version": "vor",
                "intended-application": "text-mining"
            }
        ],
        "deposited/date-parts": [
            [
                2020,
                11,
                24
            ]
        ],
        "deposited/date-time": "2020-11-24T03:51:05Z",
        "deposited/timestamp": 1606189865000,
        "score": 0,
        "resource/primary/URL": "https://linkinghub.elsevier.com/retrieve/pii/S0016236118312705",
        "issued/date-parts": [
            [
                2018,
                12
            ]
        ],
        "references-count": 64,
        "alternative-id": [
            "S0016236118312705"
        ],
        "URL": "http://dx.doi.org/10.1016/j.fuel.2018.07.071",
        "ISSN": [
            "0016-2361"
        ],
        "issn-type": [
            {
                "value": "0016-2361",
                "type": "print"
            }
        ],
        "subject": [
            "Organic Chemistry",
            "Energy Engineering and Power Technology",
            "Fuel Technology",
            "General Chemical Engineering"
        ],
        "published/date-parts": [
            [
                2018,
                12
            ]
        ],
        "assertion": [
            {
                "value": "Elsevier",
                "name": "publisher",
                "label": "This article is maintained by"
            },
            {
                "value": "Development of a Ni-CaO-mayenite combined sorbent-catalyst material for multicycle sorption enhanced steam methane reforming",
                "name": "articletitle",
                "label": "Article Title"
            },
            {
                "value": "Fuel",
                "name": "journaltitle",
                "label": "Journal Title"
            },
            {
                "value": "https://doi.org/10.1016/j.fuel.2018.07.071",
                "name": "articlelink",
                "label": "CrossRef DOI link to publisher maintained version"
            },
            {
                "value": "article",
                "name": "content_type",
                "label": "Content Type"
            },
            {
                "value": "© 2018 Elsevier Ltd. All rights reserved.",
                "name": "copyright",
                "label": "Copyright"
            }
        ]
    }
},
{
    "id": 2,
    "value": {
        "indexed/date-parts": [
            [
                2023,
                7,
                22
            ]
        ],
        "indexed/date-time": "2023-07-22T02:53:47Z",
        "indexed/timestamp": 1689994427749,
        "reference-count": 72,
        "publisher": "Springer Science and Business Media LLC",
        "issue": "10",
        "license": [
            {
                "start": {
                    "date-parts": [
                        [
                            2018,
                            8,
                            18
                        ]
                    ],
                    "date-time": "2018-08-18T00:00:00Z",
                    "timestamp": 1534550400000
                },
                "content-version": "tdm",
                "delay-in-days": 0,
                "URL": "http://www.springer.com/tdm"
            }
        ],
        "funder": [
            {
                "DOI": "10.13039/501100006488",
                "name": "Institut National de la Recherche Agronomique",
                "doi-asserted-by": "publisher"
            }
        ],
        "content-domain/domain": [
            "link.springer.com"
        ],
        "content-domain/crossmark-restriction": false,
        "short-container-title": [
            "Landscape Ecol"
        ],
        "published-print/date-parts": [
            [
                2018,
                10
            ]
        ],
        "DOI": "10.1007/s10980-018-0699-8",
        "type": "journal-article",
        "created/date-parts": [
            [
                2018,
                8,
                18
            ]
        ],
        "created/date-time": "2018-08-18T15:16:23Z",
        "created/timestamp": 1534605383000,
        "page": "1679-1690",
        "update-policy": "http://dx.doi.org/10.1007/springer_crossmark_policy",
        "source": "Crossref",
        "is-referenced-by-count": 11,
        "title": [
            "Issues and challenges in landscape models for agriculture: from the representation of agroecosystems to the design of management strategies"
        ],
        "prefix": "10.1007",
        "volume": "33",
        "author": [
            {
                "ORCID": "http://orcid.org/0000-0003-3051-5091",
                "authenticated-orcid": false,
                "given": "Sylvain",
                "family": "Poggi",
                "sequence": "first",
                "affiliation": []
            },
            {
                "given": "Julien",
                "family": "Papaïx",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "given": "Claire",
                "family": "Lavigne",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "given": "Frédérique",
                "family": "Angevin",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "given": "Florence",
                "family": "Le Ber",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "given": "Nicolas",
                "family": "Parisey",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "given": "Benoît",
                "family": "Ricci",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "given": "Fabrice",
                "family": "Vinatier",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "given": "Julie",
                "family": "Wohlfahrt",
                "sequence": "additional",
                "affiliation": []
            }
        ],
        "member": "297",
        "published-online/date-parts": [
            [
                2018,
                8,
                18
            ]
        ],
        "container-title": [
            "Landscape Ecology"
        ],
        "language": "en",
        "link": [
            {
                "URL": "http://link.springer.com/article/10.1007/s10980-018-0699-8/fulltext.html",
                "content-type": "text/html",
                "content-version": "vor",
                "intended-application": "text-mining"
            },
            {
                "URL": "http://link.springer.com/content/pdf/10.1007/s10980-018-0699-8.pdf",
                "content-type": "application/pdf",
                "content-version": "vor",
                "intended-application": "text-mining"
            },
            {
                "URL": "http://link.springer.com/content/pdf/10.1007/s10980-018-0699-8.pdf",
                "content-type": "application/pdf",
                "content-version": "vor",
                "intended-application": "similarity-checking"
            }
        ],
        "deposited/date-parts": [
            [
                2019,
                9,
                24
            ]
        ],
        "deposited/date-time": "2019-09-24T05:44:53Z",
        "deposited/timestamp": 1569303893000,
        "score": 0,
        "resource/primary/URL": "http://link.springer.com/10.1007/s10980-018-0699-8",
        "issued/date-parts": [
            [
                2018,
                8,
                18
            ]
        ],
        "references-count": 72,
        "journal-issue/issue": "10",
        "journal-issue/published-print/date-parts": [
            [
                2018,
                10
            ]
        ],
        "alternative-id": [
            "699"
        ],
        "URL": "http://dx.doi.org/10.1007/s10980-018-0699-8",
        "ISSN": [
            "0921-2973",
            "1572-9761"
        ],
        "issn-type": [
            {
                "value": "0921-2973",
                "type": "print"
            },
            {
                "value": "1572-9761",
                "type": "electronic"
            }
        ],
        "subject": [
            "Nature and Landscape Conservation",
            "Ecology",
            "Geography, Planning and Development"
        ],
        "published/date-parts": [
            [
                2018,
                8,
                18
            ]
        ],
        "assertion": [
            {
                "value": "10 November 2017",
                "order": 1,
                "name": "received",
                "label": "Received",
                "group": {
                    "name": "ArticleHistory",
                    "label": "Article History"
                }
            },
            {
                "value": "9 August 2018",
                "order": 2,
                "name": "accepted",
                "label": "Accepted",
                "group": {
                    "name": "ArticleHistory",
                    "label": "Article History"
                }
            },
            {
                "value": "18 August 2018",
                "order": 3,
                "name": "first_online",
                "label": "First Online",
                "group": {
                    "name": "ArticleHistory",
                    "label": "Article History"
                }
            }
        ]
    }
},
{
    "id": 3,
    "value": {
        "indexed/date-parts": [
            [
                2023,
                8,
                21
            ]
        ],
        "indexed/date-time": "2023-08-21T21:02:30Z",
        "indexed/timestamp": 1692651750345,
        "reference-count": 0,
        "publisher": "S. Karger AG",
        "issue": "2",
        "license": [
            {
                "start": {
                    "date-parts": [
                        [
                            2018,
                            1,
                            1
                        ]
                    ],
                    "date-time": "2018-01-01T00:00:00Z",
                    "timestamp": 1514764800000
                },
                "content-version": "vor",
                "delay-in-days": 0,
                "URL": "https://www.karger.com/Services/SiteLicenses"
            },
            {
                "start": {
                    "date-parts": [
                        [
                            2018,
                            1,
                            1
                        ]
                    ],
                    "date-time": "2018-01-01T00:00:00Z",
                    "timestamp": 1514764800000
                },
                "content-version": "tdm",
                "delay-in-days": 0,
                "URL": "https://www.karger.com/Services/SiteLicenses"
            }
        ],
        "content-domain/domain": [],
        "content-domain/crossmark-restriction": false,
        "short-container-title": [
            "Int Arch Allergy Immunol"
        ],
        "published-print/date-parts": [
            [
                2018
            ]
        ],
        "abstract": "<jats:p>&lt;b&gt;&lt;i&gt;Background:&lt;/i&gt;&lt;/b&gt; English plantain (&lt;i&gt;Plantago lanceolata&lt;/i&gt;) is an important weed pollen allergen source triggering allergic symptoms during summer. To elucidate genuine versus cross-reactive sensitization, we investigated IgE reactivity patterns and inhibition capacities of plantain-sensitized patients. &lt;b&gt;&lt;i&gt;Methods:&lt;/i&gt;&lt;/b&gt; Sera of 35 rhinoconjunctivitis patients from the north-east of France with positive skin prick tests (SPT) to &lt;i&gt;Plantago lanceolata&lt;/i&gt; pollen were tested with clinically relevant allergen sources using ELISA, ImmunoCAP, and immunoblot inhibition. &lt;b&gt;&lt;i&gt;Results:&lt;/i&gt;&lt;/b&gt; The patients were multisensitized with additional reactivity to grass (94.3%), ash (74.3%), birch (71.4%), and mugwort (55.2%) pollen in SPT. Sensitization prevalence to allergen molecules was 34.3% (Pla l 1), 94.3% (Phl p 1/5), 60.0% (Ole e 1), 65.7% (Bet v 1), 37.1% (profilin), and 40.0% (CCD). In immunoblot, IgE reactivity to plantain pollen was inhibited with relevant pollen extracts and purified rPla l 1. Two sera did not reveal any IgE cross-reactivity, while reactivity to plantain was efficiently inhibited by grass pollen in the sera of 10 patients. The sera from 17 different patients could be inhibited by grass, birch, or ash pollen to varying degrees. Thus, only 37.1% of our patients demonstrated true plantain pollen sensitization, while 62.9% were solely positive due to IgE cross-reactive molecules from other clinically relevant pollen. &lt;b&gt;&lt;i&gt;Conclusions:&lt;/i&gt;&lt;/b&gt; Plantain pollen-sensitized patients are multi-reactors demonstrating varying and complex IgE-reactivity profiles. In vivo and in vitro tests using extracts are typically blurred due to the presence of homologous allergens or CCD in grass, birch, or ash pollen. So far, Pla l 1 represents the only indicative marker allergen for the diagnosis of genuine plantain pollen sensitization.</jats:p>",
        "DOI": "10.1159/000490004",
        "type": "journal-article",
        "created/date-parts": [
            [
                2018,
                6,
                22
            ]
        ],
        "created/date-time": "2018-06-22T21:01:19Z",
        "created/timestamp": 1529701279000,
        "page": "97-106",
        "source": "Crossref",
        "is-referenced-by-count": 4,
        "title": [
            "Do &lt;b&gt;&lt;i&gt;Plantago lanceolata&lt;/i&gt;&lt;/b&gt; Skin Prick Test-Positive Patients Display IgE to Genuine Plantain Pollen Allergens? Investigation of Pollen Allergic Patients from the North-East of France"
        ],
        "prefix": "10.1159",
        "volume": "177",
        "author": [
            {
                "given": "Teresa",
                "family": "Stemeseder",
                "sequence": "first",
                "affiliation": []
            },
            {
                "given": "Carine",
                "family": "Metz-Favre",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "given": "Frederic",
                "family": "de Blay",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "given": "Gabrielle",
                "family": "Pauli",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "given": "Gabriele",
                "family": "Gadermaier",
                "sequence": "additional",
                "affiliation": []
            }
        ],
        "member": "127",
        "published-online/date-parts": [
            [
                2018,
                6,
                22
            ]
        ],
        "container-title": [
            "International Archives of Allergy and Immunology"
        ],
        "language": "en",
        "link": [
            {
                "URL": "https://www.karger.com/Article/Pdf/490004",
                "content-type": "application/pdf",
                "content-version": "vor",
                "intended-application": "text-mining"
            },
            {
                "URL": "https://www.karger.com/Article/Pdf/490004",
                "content-type": "unspecified",
                "content-version": "vor",
                "intended-application": "similarity-checking"
            }
        ],
        "deposited/date-parts": [
            [
                2022,
                6,
                21
            ]
        ],
        "deposited/date-time": "2022-06-21T09:54:09Z",
        "deposited/timestamp": 1655805249000,
        "score": 0,
        "resource/primary/URL": "https://www.karger.com/Article/FullText/490004",
        "issued/date-parts": [
            [
                2018
            ]
        ],
        "references-count": 0,
        "journal-issue/issue": "2",
        "journal-issue/published-online/date-parts": [
            [
                2018,
                9,
                19
            ]
        ],
        "journal-issue/published-print/date-parts": [
            [
                2018,
                9,
                27
            ]
        ],
        "URL": "http://dx.doi.org/10.1159/000490004",
        "archive": [
            "Portico"
        ],
        "relation/is-supplemented-by": [
            {
                "id-type": "doi",
                "id": "10.6084/m9.figshare.6652790",
                "asserted-by": "subject"
            }
        ],
        "ISSN": [
            "1018-2438",
            "1423-0097"
        ],
        "issn-type": [
            {
                "value": "1018-2438",
                "type": "print"
            },
            {
                "value": "1423-0097",
                "type": "electronic"
            }
        ],
        "subject": [
            "Immunology",
            "General Medicine",
            "Immunology and Allergy"
        ],
        "published/date-parts": [
            [
                2018
            ]
        ]
    }
},
{
    "id": 4,
    "value": {
        "indexed/date-parts": [
            [
                2023,
                9,
                14
            ]
        ],
        "indexed/date-time": "2023-09-14T19:43:30Z",
        "indexed/timestamp": 1694720610787,
        "reference-count": 35,
        "publisher": "Elsevier BV",
        "license": [
            {
                "start": {
                    "date-parts": [
                        [
                            2018,
                            11,
                            1
                        ]
                    ],
                    "date-time": "2018-11-01T00:00:00Z",
                    "timestamp": 1541030400000
                },
                "content-version": "tdm",
                "delay-in-days": 0,
                "URL": "https://www.elsevier.com/tdm/userlicense/1.0/"
            }
        ],
        "content-domain/domain": [
            "elsevier.com",
            "sciencedirect.com"
        ],
        "content-domain/crossmark-restriction": true,
        "short-container-title": [
            "Journal of Membrane Science"
        ],
        "published-print/date-parts": [
            [
                2018,
                11
            ]
        ],
        "DOI": "10.1016/j.memsci.2018.08.024",
        "type": "journal-article",
        "created/date-parts": [
            [
                2018,
                8,
                30
            ]
        ],
        "created/date-time": "2018-08-30T18:57:31Z",
        "created/timestamp": 1535655451000,
        "page": "346-366",
        "update-policy": "http://dx.doi.org/10.1016/elsevier_cm_policy",
        "source": "Crossref",
        "is-referenced-by-count": 50,
        "title": [
            "Optimization of multistage membrane gas separation processes. Example of application to CO2 capture from blast furnace gas"
        ],
        "prefix": "10.1016",
        "volume": "566",
        "author": [
            {
                "given": "Álvaro A.",
                "family": "Ramírez-Santos",
                "sequence": "first",
                "affiliation": []
            },
            {
                "given": "M.",
                "family": "Bozorg",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "ORCID": "http://orcid.org/0000-0003-4843-8709",
                "authenticated-orcid": false,
                "given": "B.",
                "family": "Addis",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "ORCID": "http://orcid.org/0000-0002-3357-9608",
                "authenticated-orcid": false,
                "given": "V.",
                "family": "Piccialli",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "given": "C.",
                "family": "Castel",
                "sequence": "additional",
                "affiliation": []
            },
            {
                "ORCID": "http://orcid.org/0000-0003-4400-1921",
                "authenticated-orcid": false,
                "given": "E.",
                "family": "Favre",
                "sequence": "additional",
                "affiliation": []
            }
        ],
        "member": "78",
        "container-title": [
            "Journal of Membrane Science"
        ],
        "language": "en",
        "link": [
            {
                "URL": "https://api.elsevier.com/content/article/PII:S0376738818317824?httpAccept=text/xml",
                "content-type": "text/xml",
                "content-version": "vor",
                "intended-application": "text-mining"
            },
            {
                "URL": "https://api.elsevier.com/content/article/PII:S0376738818317824?httpAccept=text/plain",
                "content-type": "text/plain",
                "content-version": "vor",
                "intended-application": "text-mining"
            }
        ],
        "deposited/date-parts": [
            [
                2020,
                4,
                20
            ]
        ],
        "deposited/date-time": "2020-04-20T21:56:32Z",
        "deposited/timestamp": 1587419792000,
        "score": 0,
        "resource/primary/URL": "https://linkinghub.elsevier.com/retrieve/pii/S0376738818317824",
        "issued/date-parts": [
            [
                2018,
                11
            ]
        ],
        "references-count": 35,
        "alternative-id": [
            "S0376738818317824"
        ],
        "URL": "http://dx.doi.org/10.1016/j.memsci.2018.08.024",
        "ISSN": [
            "0376-7388"
        ],
        "issn-type": [
            {
                "value": "0376-7388",
                "type": "print"
            }
        ],
        "subject": [
            "Filtration and Separation",
            "Physical and Theoretical Chemistry",
            "General Materials Science",
            "Biochemistry"
        ],
        "published/date-parts": [
            [
                2018,
                11
            ]
        ],
        "assertion": [
            {
                "value": "Elsevier",
                "name": "publisher",
                "label": "This article is maintained by"
            },
            {
                "value": "Optimization of multistage membrane gas separation processes. Example of application to CO2 capture from blast furnace gas",
                "name": "articletitle",
                "label": "Article Title"
            },
            {
                "value": "Journal of Membrane Science",
                "name": "journaltitle",
                "label": "Journal Title"
            },
            {
                "value": "https://doi.org/10.1016/j.memsci.2018.08.024",
                "name": "articlelink",
                "label": "CrossRef DOI link to publisher maintained version"
            },
            {
                "value": "article",
                "name": "content_type",
                "label": "Content Type"
            },
            {
                "value": "© 2018 Elsevier B.V. All rights reserved.",
                "name": "copyright",
                "label": "Copyright"
            }
        ]
    }
},
{
    "id": 5,
    "value": {
        "indexed/date-parts": [
            [
                2023,
                9,
                16
            ]
        ],
        "indexed/date-time": "2023-09-16T07:07:13Z",
        "indexed/timestamp": 1694848033009,
        "reference-count": 43,
        "publisher": "American Geophysical Union (AGU)",
        "issue": "1",
        "license": [
            {
                "start": {
                    "date-parts": [
                        [
                            2019,
                            1,
                            11
                        ]
                    ],
                    "date-time": "2019-01-11T00:00:00Z",
                    "timestamp": 1547164800000
                },
                "content-version": "vor",
                "delay-in-days": 0,
                "URL": "http://creativecommons.org/licenses/by-nc-nd/4.0/"
            }
        ],
        "funder": [
            {
                "DOI": "10.13039/100011102",
                "name": "Seventh Framework Programme",
                "doi-asserted-by": "publisher",
                "award": [
                    "320839"
                ]
            },
            {
                "DOI": "10.13039/501100005416",
                "name": "Norges Forskningsråd",
                "doi-asserted-by": "publisher",
                "award": [
                    "208028/F50"
                ]
            }
        ],
        "content-domain/domain": [
            "agupubs.onlinelibrary.wiley.com"
        ],
        "content-domain/crossmark-restriction": true,
        "short-container-title": [
            "JGR Atmospheres"
        ],
        "published-print/date-parts": [
            [
                2019,
                1,
                16
            ]
        ],
        "abstract": "<jats:title>Abstract</jats:title><jats:p>Terrestrial gamma ray flashes (TGFs) are sub‐millisecond bursts of high energetic gamma radiation associated with intracloud flashes in thunderstorms. In this paper we use the simultaneity of lightning detections by World Wide Lightning Location Network to find TGFs in the Reuven Ramaty High Energy Solar Spectroscopic Imager (RHESSI) data that are too faint to be identified by standard search algorithms. A similar approach has been used in an earlier paper, but here we expand the data set to include all years of RHESSI + World Wide Lightning Location Network data and show that there is a population of observationally weak TGFs all the way down to 0.22 of the RHESSI detection threshold (three counts in the detector). One should note that the majority of these are “normal” TGFs that are produced further away from the subsatellite point (and experience a 1/<jats:italic>r</jats:italic><jats:sup>2</jats:sup> effect) or produced at higher latitudes with a lower tropoause and thus experience increased atmospheric attenuation. This supports the idea that the TGF production rate is higher than currently reported. We also show that compared to lightning flashes, TGFs are more partial to ocean and coastal regions than over land.</jats:p>",
        "DOI": "10.1029/2018jd029272",
        "type": "journal-article",
        "created/date-parts": [
            [
                2018,
                11,
                29
            ]
        ],
        "created/date-time": "2018-11-29T21:55:12Z",
        "created/timestamp": 1543528512000,
        "page": "287-298",
        "update-policy": "http://dx.doi.org/10.1002/crossmark_policy",
        "source": "Crossref",
        "is-referenced-by-count": 10,
        "title": [
            "Observationally Weak TGFs in the RHESSI Data"
        ],
        "prefix": "10.1029",
        "volume": "124",
        "author": [
            {
                "ORCID": "http://orcid.org/0000-0002-9212-1904",
                "authenticated-orcid": false,
                "given": "K. H.",
                "family": "Albrechtsen",
                "sequence": "first",
                "affiliation": [
                    {
                        "name": "Birkeland Centre for Space Science, Department of Physics and Technology University of Bergen  Bergen Norway"
                    }
                ]
            },
            {
                "ORCID": "http://orcid.org/0000-0002-2572-7033",
                "authenticated-orcid": false,
                "given": "N.",
                "family": "Østgaard",
                "sequence": "additional",
                "affiliation": [
                    {
                        "name": "Birkeland Centre for Space Science, Department of Physics and Technology University of Bergen  Bergen Norway"
                    }
                ]
            },
            {
                "ORCID": "http://orcid.org/0000-0003-4375-4518",
                "authenticated-orcid": false,
                "given": "N.",
                "family": "Berge",
                "sequence": "additional",
                "affiliation": [
                    {
                        "name": "LPC2E, CNRS University of Orleans  Orleans France"
                    }
                ]
            },
            {
                "ORCID": "http://orcid.org/0000-0003-4877-7815",
                "authenticated-orcid": false,
                "given": "T.",
                "family": "Gjesteland",
                "sequence": "additional",
                "affiliation": [
                    {
                        "name": "Department of Engineering Science University of Agder  Grimstad Norway"
                    }
                ]
            }
        ],
        "member": "13",
        "published-online/date-parts": [
            [
                2019,
                1,
                11
            ]
        ],
        "container-title": [
            "Journal of Geophysical Research: Atmospheres"
        ],
        "language": "en",
        "link": [
            {
                "URL": "https://api.wiley.com/onlinelibrary/tdm/v1/articles/10.1029%2F2018JD029272",
                "content-type": "application/pdf",
                "content-version": "vor",
                "intended-application": "text-mining"
            },
            {
                "URL": "https://agupubs.onlinelibrary.wiley.com/doi/pdf/10.1029/2018JD029272",
                "content-type": "unspecified",
                "content-version": "vor",
                "intended-application": "similarity-checking"
            }
        ],
        "deposited/date-parts": [
            [
                2023,
                9,
                9
            ]
        ],
        "deposited/date-time": "2023-09-09T23:55:14Z",
        "deposited/timestamp": 1694303714000,
        "score": 0,
        "resource/primary/URL": "https://agupubs.onlinelibrary.wiley.com/doi/10.1029/2018JD029272",
        "issued/date-parts": [
            [
                2019,
                1,
                11
            ]
        ],
        "references-count": 43,
        "journal-issue/issue": "1",
        "journal-issue/published-print/date-parts": [
            [
                2019,
                1,
                16
            ]
        ],
        "alternative-id": [
            "10.1029/2018JD029272"
        ],
        "URL": "http://dx.doi.org/10.1029/2018jd029272",
        "archive": [
            "Portico"
        ],
        "ISSN": [
            "2169-897X",
            "2169-8996"
        ],
        "issn-type": [
            {
                "value": "2169-897X",
                "type": "print"
            },
            {
                "value": "2169-8996",
                "type": "electronic"
            }
        ],
        "subject": [
            "Space and Planetary Science",
            "Earth and Planetary Sciences (miscellaneous)",
            "Atmospheric Science",
            "Geophysics"
        ],
        "published/date-parts": [
            [
                2019,
                1,
                11
            ]
        ],
        "assertion": [
            {
                "value": "2018-06-29",
                "order": 0,
                "name": "received",
                "label": "Received",
                "group": {
                    "name": "publication_history",
                    "label": "Publication History"
                }
            },
            {
                "value": "2018-11-22",
                "order": 1,
                "name": "accepted",
                "label": "Accepted",
                "group": {
                    "name": "publication_history",
                    "label": "Publication History"
                }
            },
            {
                "value": "2019-01-11",
                "order": 2,
                "name": "published",
                "label": "Published",
                "group": {
                    "name": "publication_history",
                    "label": "Publication History"
                }
            }
        ]
    }
},
{
    "id": 6,
    "value": {
        "indexed/date-parts": [
            [
                2022,
                4,
                2
            ]
        ],
        "indexed/date-time": "2022-04-02T12:41:14Z",
        "indexed/timestamp": 1648903274712,
        "reference-count": 0,
        "publisher": "OpenEdition",
        "issue": "52",
        "content-domain/domain": [],
        "content-domain/crossmark-restriction": false,
        "short-container-title": [
            "edc"
        ],
        "published-print/date-parts": [
            [
                2019,
                6,
                1
            ]
        ],
        "DOI": "10.4000/edc.9014",
        "type": "journal-article",
        "created/date-parts": [
            [
                2020,
                9,
                20
            ]
        ],
        "created/date-time": "2020-09-20T16:13:17Z",
        "created/timestamp": 1600618397000,
        "page": "211-216",
        "source": "Crossref",
        "is-referenced-by-count": 0,
        "title": [
            "Da Sylva Lyne, Cuxac Pascal : Analyse et exploitation des bibliothèques numériques"
        ],
        "prefix": "10.4000",
        "author": [
            {
                "given": "Florence",
                "family": "Thiault",
                "sequence": "first",
                "affiliation": []
            }
        ],
        "member": "2399",
        "container-title": [
            "Études de communication"
        ],
        "deposited/date-parts": [
            [
                2021,
                1,
                7
            ]
        ],
        "deposited/date-time": "2021-01-07T07:59:45Z",
        "deposited/timestamp": 1610006385000,
        "score": 0,
        "resource/primary/URL": "http://journals.openedition.org/edc/9014",
        "issued/date-parts": [
            [
                2019,
                6,
                1
            ]
        ],
        "references-count": 0,
        "journal-issue/issue": "52",
        "journal-issue/published-online/date-parts": [
            [
                2019,
                12,
                11
            ]
        ],
        "journal-issue/published-print/date-parts": [
            [
                2019,
                6,
                1
            ]
        ],
        "URL": "http://dx.doi.org/10.4000/edc.9014",
        "ISSN": [
            "1270-6841",
            "2101-0366"
        ],
        "issn-type": [
            {
                "value": "1270-6841",
                "type": "print"
            },
            {
                "value": "2101-0366",
                "type": "electronic"
            }
        ],
        "subject": [
            "General Medicine"
        ],
        "published/date-parts": [
            [
                2019,
                6,
                1
            ]
        ]
    }
},
{
    "id": 7,
    "value": "n/a"
}]

POST {{host}}/v1/inspirehep/works/expand?indent=true
content-type: application/json
[
  { "id":1,  "value": "10.1103/PhysRevLett.19.1264"},
  { "id":2,  "value": "10.1016/j.fuel.2018.07.071" },
  { "id":3,  "value": "10.1007/s10980-018-0699-8" },
  { "id":4,  "value": "10.1159/000490004" },
  { "id":5,  "value": "10.1016/j.memsci.2018.08.024"},
  { "id":6,  "value": "10.1029/2018jd029272"},
  { "id":7,  "value": "10.4000/edc.9014"},
  { "id":8,  "value": "unknown"}
]

HTTP 200
[{
    "id": 1,
    "value": {
        "updated": "2023-03-09T15:45:47.191006+00:00",
        "metadata/publication_info": [
            {
                "year": 1967,
                "page_end": "1266",
                "page_start": "1264",
                "journal_title": "Phys.Rev.Lett.",
                "journal_record": {
                    "$ref": "https://inspirehep.net/api/journals/1214495"
                },
                "journal_volume": "19"
            },
            {
                "pubinfo_freetext": "Also in *Lichtenberg, D. B. (ed.), Rosen, S. P. (ed.): Developments In The Quark Theory Of Hadrons, Vol. 1*, 157-159"
            },
            {
                "pubinfo_freetext": "In *Lai, C. H. (ed.): Gauge Theory Of Weak and Electromagnetic Interactions*, 185-187"
            },
            {
                "pubinfo_freetext": "In *Rosner, J. L. (ed.): New Particles*, 26-28"
            }
        ],
        "metadata/citation_count_without_self_citations": 14104,
        "metadata/citation_count": 14132,
        "metadata/core": true,
        "metadata/dois": [
            {
                "value": "10.1103/PhysRevLett.19.1264"
            }
        ],
        "metadata/urls": [
            {
                "value": "http://cerncourier.com/cws/article/cern/70138",
                "description": "CERN Courier article"
            }
        ],
        "metadata/titles": [
            {
                "title": "A Model of Leptons"
            }
        ],
        "metadata/$schema": "https://inspirehep.net/schemas/records/hep.json",
        "metadata/authors": [
            {
                "ids": [
                    {
                        "value": "INSPIRE-00135339",
                        "schema": "INSPIRE ID"
                    }
                ],
                "uuid": "5863d7d5-7db1-4d1c-af0c-6408b3584b3e",
                "record/$ref": "https://inspirehep.net/api/authors/983868",
                "full_name": "Weinberg, Steven",
                "affiliations": [
                    {
                        "value": "MIT, LNS",
                        "record": {
                            "$ref": "https://inspirehep.net/api/institutions/903016"
                        }
                    }
                ],
                "signature_block": "WANBARGs",
                "curated_relation": true
            }
        ],
        "metadata/curated": true,
        "metadata/texkeys": [
            "Weinberg:1967tq"
        ],
        "metadata/citeable": true,
        "metadata/keywords": [
            {
                "value": "LEPTON: MODEL",
                "schema": "INSPIRE"
            },
            {
                "value": "GAUGE FIELD THEORY",
                "schema": "INSPIRE"
            },
            {
                "value": "SPONTANEOUS SYMMETRY BREAKING",
                "schema": "INSPIRE"
            },
            {
                "value": "FIELD THEORY: GOLDSTONE THEOREM",
                "schema": "INSPIRE"
            },
            {
                "value": "ELECTROWEAK INTERACTION",
                "schema": "INSPIRE"
            },
            {
                "value": "RENORMALIZATION",
                "schema": "INSPIRE"
            },
            {
                "value": "gauge boson: mass",
                "schema": "INSPIRE"
            }
        ],
        "metadata/refereed": true,
        "metadata/document_type": [
            "article"
        ],
        "metadata/preprint_date": "1967-11",
        "metadata/control_number": 51188,
        "metadata/legacy_version": "20180204042908.0",
        "metadata/number_of_pages": 3,
        "metadata/inspire_categories": [
            {
                "term": "Theory-HEP",
                "source": "curator"
            }
        ],
        "metadata/legacy_creation_date": "1981-01-01",
        "metadata/external_system_identifiers": [
            {
                "value": "4497676",
                "schema": "OSTI"
            },
            {
                "value": "1967PhRvL..19.1264W",
                "schema": "ADS"
            },
            {
                "value": "SPIRES-153990",
                "schema": "SPIRES"
            }
        ],
        "revision_id": 96,
        "uuid": "f0318082-80cc-46bc-bb9a-ed8108097a46",
        "id": "10.1103/physrevlett.19.1264",
        "links/bibtex": "https://inspirehep.net/api/doi/10.1103/physrevlett.19.1264?format=bibtex",
        "links/latex-eu": "https://inspirehep.net/api/doi/10.1103/physrevlett.19.1264?format=latex-eu",
        "links/latex-us": "https://inspirehep.net/api/doi/10.1103/physrevlett.19.1264?format=latex-us",
        "links/json": "https://inspirehep.net/api/doi/10.1103/physrevlett.19.1264?format=json",
        "links/cv": "https://inspirehep.net/api/doi/10.1103/physrevlett.19.1264?format=cv",
        "created": "1981-01-01T00:00:00+00:00"
    }
},
{
    "id": 2,
    "value": "n/a"
},
{
    "id": 3,
    "value": "n/a"
},
{
    "id": 4,
    "value": "n/a"
},
{
    "id": 5,
    "value": "n/a"
},
{
    "id": 6,
    "value": "n/a"
},
{
    "id": 7,
    "value": "n/a"
},
{
    "id": 8,
    "value": "n/a"
}]

POST {{host}}/v1/openalex/works/expand?indent=true
content-type: application/json
[
  { "id":1,  "value": "10.1103/PhysRevLett.19.1264"},
  { "id":2,  "value": "10.1016/j.fuel.2018.07.071" },
  { "id":3,  "value": "10.1007/s10980-018-0699-8" },
  { "id":4,  "value": "10.1159/000490004" },
  { "id":5,  "value": "10.1016/j.memsci.2018.08.024"},
  { "id":6,  "value": "10.1029/2018jd029272"},
  { "id":7,  "value": "10.4000/edc.9014"},
  { "id":8,  "value": "unknown"}
]

HTTP 200
[{
    "id": 1,
    "value": {
        "id": "https://openalex.org/W2070151728",
        "doi": "https://doi.org/10.1103/physrevlett.19.1264",
        "title": "A Model of Leptons",
        "display_name": "A Model of Leptons",
        "publication_year": 1967,
        "publication_date": "1967-11-20",
        "ids/openalex": "https://openalex.org/W2070151728",
        "ids/doi": "https://doi.org/10.1103/physrevlett.19.1264",
        "ids/mag": "2070151728",
        "language": "en",
        "primary_location/is_oa": true,
        "primary_location/landing_page_url": "https://doi.org/10.1103/physrevlett.19.1264",
        "primary_location/pdf_url": "http://link.aps.org/pdf/10.1103/PhysRevLett.19.1264",
        "primary_location/source/id": "https://openalex.org/S24807848",
        "primary_location/source/display_name": "Physical Review Letters",
        "primary_location/source/issn_l": "0031-9007",
        "primary_location/source/issn": [
            "1079-7114",
            "0031-9007",
            "1092-0145"
        ],
        "primary_location/source/is_oa": false,
        "primary_location/source/is_in_doaj": false,
        "primary_location/source/host_organization": "https://openalex.org/P4310320261",
        "primary_location/source/host_organization_name": "American Physical Society",
        "primary_location/source/host_organization_lineage": [
            "https://openalex.org/P4310320261"
        ],
        "primary_location/source/host_organization_lineage_names": [
            "American Physical Society"
        ],
        "primary_location/source/type": "journal",
        "primary_location/license": null,
        "primary_location/version": "publishedVersion",
        "primary_location/is_accepted": true,
        "primary_location/is_published": true,
        "type": "article",
        "type_crossref": "journal-article",
        "open_access/is_oa": true,
        "open_access/oa_status": "closed",
        "open_access/oa_url": "http://link.aps.org/pdf/10.1103/PhysRevLett.19.1264",
        "open_access/any_repository_has_fulltext": false,
        "authorships": [
            {
                "author_position": "first",
                "author/id": "https://openalex.org/A5043632498",
                "author/display_name": "Steven Weinberg",
                "author/orcid": null,
                "institutions": [
                    {
                        "id": "https://openalex.org/I63966007",
                        "display_name": "Massachusetts Institute of Technology",
                        "ror": "https://ror.org/042nb2s44",
                        "country_code": "US",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I63966007"
                        ]
                    }
                ],
                "countries": [
                    "US"
                ],
                "is_corresponding": true,
                "raw_author_name": "Steven Weinberg",
                "raw_affiliation_string": "Laboratory for Nuclear Science and Physics Department, Massachusetts Institute of Technology, Cambridge, Massachusetts",
                "raw_affiliation_strings": [
                    "Laboratory for Nuclear Science and Physics Department, Massachusetts Institute of Technology, Cambridge, Massachusetts"
                ]
            }
        ],
        "countries_distinct_count": 1,
        "institutions_distinct_count": 1,
        "corresponding_author_ids": [
            "https://openalex.org/A5043632498"
        ],
        "corresponding_institution_ids": [
            "https://openalex.org/I63966007"
        ],
        "apc_list/value": 3750,
        "apc_list/currency": "USD",
        "apc_list/value_usd": 3750,
        "apc_list/provenance": "doaj",
        "apc_paid/value": 3750,
        "apc_paid/currency": "USD",
        "apc_paid/value_usd": 3750,
        "apc_paid/provenance": "doaj",
        "has_fulltext": true,
        "fulltext_origin": "pdf",
        "cited_by_count": 6607,
        "biblio/volume": "19",
        "biblio/issue": "21",
        "biblio/first_page": "1264",
        "biblio/last_page": "1266",
        "is_retracted": false,
        "is_paratext": false,
        "concepts": [
            {
                "id": "https://openalex.org/C179203047",
                "wikidata": "https://www.wikidata.org/wiki/Q82586",
                "display_name": "Lepton",
                "level": 3,
                "score": 0.70983773
            },
            {
                "id": "https://openalex.org/C109214941",
                "wikidata": "https://www.wikidata.org/wiki/Q18334",
                "display_name": "Particle physics",
                "level": 1,
                "score": 0.47792703
            },
            {
                "id": "https://openalex.org/C121332964",
                "wikidata": "https://www.wikidata.org/wiki/Q413",
                "display_name": "Physics",
                "level": 0,
                "score": 0.46379787
            },
            {
                "id": "https://openalex.org/C185544564",
                "wikidata": "https://www.wikidata.org/wiki/Q81197",
                "display_name": "Nuclear physics",
                "level": 1,
                "score": 0.31365007
            },
            {
                "id": "https://openalex.org/C147120987",
                "wikidata": "https://www.wikidata.org/wiki/Q2225",
                "display_name": "Electron",
                "level": 2,
                "score": 0.14286286
            }
        ],
        "mesh": [],
        "locations_count": 1,
        "locations": [
            {
                "is_oa": true,
                "landing_page_url": "https://doi.org/10.1103/physrevlett.19.1264",
                "pdf_url": "http://link.aps.org/pdf/10.1103/PhysRevLett.19.1264",
                "source": {
                    "id": "https://openalex.org/S24807848",
                    "display_name": "Physical Review Letters",
                    "issn_l": "0031-9007",
                    "issn": [
                        "1079-7114",
                        "0031-9007",
                        "1092-0145"
                    ],
                    "is_oa": false,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/P4310320261",
                    "host_organization_name": "American Physical Society",
                    "host_organization_lineage": [
                        "https://openalex.org/P4310320261"
                    ],
                    "host_organization_lineage_names": [
                        "American Physical Society"
                    ],
                    "type": "journal"
                },
                "license": null,
                "version": "publishedVersion",
                "is_accepted": true,
                "is_published": true
            }
        ],
        "best_oa_location/is_oa": true,
        "best_oa_location/landing_page_url": "https://doi.org/10.1103/physrevlett.19.1264",
        "best_oa_location/pdf_url": "http://link.aps.org/pdf/10.1103/PhysRevLett.19.1264",
        "best_oa_location/source/id": "https://openalex.org/S24807848",
        "best_oa_location/source/display_name": "Physical Review Letters",
        "best_oa_location/source/issn_l": "0031-9007",
        "best_oa_location/source/issn": [
            "1079-7114",
            "0031-9007",
            "1092-0145"
        ],
        "best_oa_location/source/is_oa": false,
        "best_oa_location/source/is_in_doaj": false,
        "best_oa_location/source/host_organization": "https://openalex.org/P4310320261",
        "best_oa_location/source/host_organization_name": "American Physical Society",
        "best_oa_location/source/host_organization_lineage": [
            "https://openalex.org/P4310320261"
        ],
        "best_oa_location/source/host_organization_lineage_names": [
            "American Physical Society"
        ],
        "best_oa_location/source/type": "journal",
        "best_oa_location/license": null,
        "best_oa_location/version": "publishedVersion",
        "best_oa_location/is_accepted": true,
        "best_oa_location/is_published": true,
        "sustainable_development_goals": [
            {
                "id": "https://metadata.un.org/sdg/13",
                "display_name": "Climate action",
                "score": 0.36
            }
        ],
        "grants": [],
        "referenced_works_count": 16,
        "ngrams_url": "https://api.openalex.org/works/W2070151728/ngrams",
        "cited_by_api_url": "https://api.openalex.org/works?filter=cites:W2070151728",
        "counts_by_year": [
            {
                "year": 2023,
                "cited_by_count": 86
            },
            {
                "year": 2022,
                "cited_by_count": 106
            },
            {
                "year": 2021,
                "cited_by_count": 151
            },
            {
                "year": 2020,
                "cited_by_count": 160
            },
            {
                "year": 2019,
                "cited_by_count": 160
            },
            {
                "year": 2018,
                "cited_by_count": 114
            },
            {
                "year": 2017,
                "cited_by_count": 108
            },
            {
                "year": 2016,
                "cited_by_count": 131
            },
            {
                "year": 2015,
                "cited_by_count": 182
            },
            {
                "year": 2014,
                "cited_by_count": 175
            },
            {
                "year": 2013,
                "cited_by_count": 195
            },
            {
                "year": 2012,
                "cited_by_count": 164
            }
        ],
        "updated_date": "2023-10-02T08:41:15.197685",
        "created_date": "2016-06-24"
    }
},
{
    "id": 2,
    "value": {
        "id": "https://openalex.org/W2883201608",
        "doi": "https://doi.org/10.1016/j.fuel.2018.07.071",
        "title": "Development of a Ni-CaO-mayenite combined sorbent-catalyst material for multicycle sorption enhanced steam methane reforming",
        "display_name": "Development of a Ni-CaO-mayenite combined sorbent-catalyst material for multicycle sorption enhanced steam methane reforming",
        "publication_year": 2018,
        "publication_date": "2018-12-01",
        "ids/openalex": "https://openalex.org/W2883201608",
        "ids/doi": "https://doi.org/10.1016/j.fuel.2018.07.071",
        "ids/mag": "2883201608",
        "language": "en",
        "primary_location/is_oa": false,
        "primary_location/landing_page_url": "https://doi.org/10.1016/j.fuel.2018.07.071",
        "primary_location/pdf_url": null,
        "primary_location/source/id": "https://openalex.org/S164770093",
        "primary_location/source/display_name": "Fuel",
        "primary_location/source/issn_l": "0016-2361",
        "primary_location/source/issn": [
            "0016-2361",
            "1873-7153"
        ],
        "primary_location/source/is_oa": false,
        "primary_location/source/is_in_doaj": false,
        "primary_location/source/host_organization": "https://openalex.org/P4310320990",
        "primary_location/source/host_organization_name": "Elsevier BV",
        "primary_location/source/host_organization_lineage": [
            "https://openalex.org/P4310320990"
        ],
        "primary_location/source/host_organization_lineage_names": [
            "Elsevier BV"
        ],
        "primary_location/source/type": "journal",
        "primary_location/license": null,
        "primary_location/version": null,
        "primary_location/is_accepted": false,
        "primary_location/is_published": false,
        "type": "article",
        "type_crossref": "journal-article",
        "open_access/is_oa": false,
        "open_access/oa_status": "closed",
        "open_access/oa_url": null,
        "open_access/any_repository_has_fulltext": false,
        "authorships": [
            {
                "author_position": "first",
                "author/id": "https://openalex.org/A5089766287",
                "author/display_name": "Andrea Di Giuliano",
                "author/orcid": "https://orcid.org/0000-0003-1152-9164",
                "institutions": [
                    {
                        "id": "https://openalex.org/I26415053",
                        "display_name": "University of L'Aquila",
                        "ror": "https://ror.org/01j9p1r26",
                        "country_code": "IT",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I26415053"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I68947357",
                        "display_name": "University of Strasbourg",
                        "ror": "https://ror.org/00pg6eq24",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I68947357"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I4210128300",
                        "display_name": "Institut de Chimie",
                        "ror": "https://ror.org/02cte4b68",
                        "country_code": "FR",
                        "type": "facility",
                        "lineage": [
                            "https://openalex.org/I1294671590",
                            "https://openalex.org/I4210128300"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I1294671590",
                        "display_name": "French National Centre for Scientific Research",
                        "ror": "https://ror.org/02feahw73",
                        "country_code": "FR",
                        "type": "government",
                        "lineage": [
                            "https://openalex.org/I1294671590"
                        ]
                    }
                ],
                "countries": [
                    "FR",
                    "IT"
                ],
                "is_corresponding": false,
                "raw_author_name": "A. Di Giuliano",
                "raw_affiliation_string": "University of L’Aquila, Department of Industrial and Information Engineering and Economics, 18 via G. Gronchi, 67100 L’Aquila, Italy; University of Strasbourg, Institut de Chimie et Procédés pour l’Énergie, l’Environnement et la Santé, UMR CNRS 7515, ECPM, 25 rue Becquerel, 67087 Strasbourg Cedex 2, France",
                "raw_affiliation_strings": [
                    "University of L’Aquila, Department of Industrial and Information Engineering and Economics, 18 via G. Gronchi, 67100 L’Aquila, Italy",
                    "University of Strasbourg, Institut de Chimie et Procédés pour l’Énergie, l’Environnement et la Santé, UMR CNRS 7515, ECPM, 25 rue Becquerel, 67087 Strasbourg Cedex 2, France"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5009569761",
                "author/display_name": "Fabrizio Giancaterino",
                "author/orcid": null,
                "institutions": [
                    {
                        "id": "https://openalex.org/I26415053",
                        "display_name": "University of L'Aquila",
                        "ror": "https://ror.org/01j9p1r26",
                        "country_code": "IT",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I26415053"
                        ]
                    }
                ],
                "countries": [
                    "IT"
                ],
                "is_corresponding": false,
                "raw_author_name": "F. Giancaterino",
                "raw_affiliation_string": "University of L’Aquila, Department of Industrial and Information Engineering and Economics, 18 via G. Gronchi, 67100 L’Aquila, Italy",
                "raw_affiliation_strings": [
                    "University of L’Aquila, Department of Industrial and Information Engineering and Economics, 18 via G. Gronchi, 67100 L’Aquila, Italy"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5045226902",
                "author/display_name": "Claire Courson",
                "author/orcid": "https://orcid.org/0000-0001-6811-8484",
                "institutions": [
                    {
                        "id": "https://openalex.org/I68947357",
                        "display_name": "University of Strasbourg",
                        "ror": "https://ror.org/00pg6eq24",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I68947357"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I4210128300",
                        "display_name": "Institut de Chimie",
                        "ror": "https://ror.org/02cte4b68",
                        "country_code": "FR",
                        "type": "facility",
                        "lineage": [
                            "https://openalex.org/I1294671590",
                            "https://openalex.org/I4210128300"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I1294671590",
                        "display_name": "French National Centre for Scientific Research",
                        "ror": "https://ror.org/02feahw73",
                        "country_code": "FR",
                        "type": "government",
                        "lineage": [
                            "https://openalex.org/I1294671590"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "C. Courson",
                "raw_affiliation_string": "University of Strasbourg, Institut de Chimie et Procédés pour l’Énergie, l’Environnement et la Santé, UMR CNRS 7515, ECPM, 25 rue Becquerel, 67087 Strasbourg Cedex 2, France",
                "raw_affiliation_strings": [
                    "University of Strasbourg, Institut de Chimie et Procédés pour l’Énergie, l’Environnement et la Santé, UMR CNRS 7515, ECPM, 25 rue Becquerel, 67087 Strasbourg Cedex 2, France"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5034886304",
                "author/display_name": "P.U. Foscolo",
                "author/orcid": null,
                "institutions": [
                    {
                        "id": "https://openalex.org/I26415053",
                        "display_name": "University of L'Aquila",
                        "ror": "https://ror.org/01j9p1r26",
                        "country_code": "IT",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I26415053"
                        ]
                    }
                ],
                "countries": [
                    "IT"
                ],
                "is_corresponding": false,
                "raw_author_name": "P.U. Foscolo",
                "raw_affiliation_string": "University of L’Aquila, Department of Industrial and Information Engineering and Economics, 18 via G. Gronchi, 67100 L’Aquila, Italy",
                "raw_affiliation_strings": [
                    "University of L’Aquila, Department of Industrial and Information Engineering and Economics, 18 via G. Gronchi, 67100 L’Aquila, Italy"
                ]
            },
            {
                "author_position": "last",
                "author/id": "https://openalex.org/A5048870728",
                "author/display_name": "Katia Gallucci",
                "author/orcid": "https://orcid.org/0000-0003-1050-2744",
                "institutions": [
                    {
                        "id": "https://openalex.org/I26415053",
                        "display_name": "University of L'Aquila",
                        "ror": "https://ror.org/01j9p1r26",
                        "country_code": "IT",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I26415053"
                        ]
                    }
                ],
                "countries": [
                    "IT"
                ],
                "is_corresponding": true,
                "raw_author_name": "K. Gallucci",
                "raw_affiliation_string": "University of L’Aquila, Department of Industrial and Information Engineering and Economics, 18 via G. Gronchi, 67100 L’Aquila, Italy",
                "raw_affiliation_strings": [
                    "University of L’Aquila, Department of Industrial and Information Engineering and Economics, 18 via G. Gronchi, 67100 L’Aquila, Italy"
                ]
            }
        ],
        "countries_distinct_count": 2,
        "institutions_distinct_count": 4,
        "corresponding_author_ids": [
            "https://openalex.org/A5048870728"
        ],
        "corresponding_institution_ids": [
            "https://openalex.org/I26415053"
        ],
        "apc_list/value": 4080,
        "apc_list/currency": "USD",
        "apc_list/value_usd": 4080,
        "apc_list/provenance": "doaj",
        "apc_paid/value": 4080,
        "apc_paid/currency": "USD",
        "apc_paid/value_usd": 4080,
        "apc_paid/provenance": "doaj",
        "has_fulltext": true,
        "fulltext_origin": "ngrams",
        "cited_by_count": 49,
        "biblio/volume": "234",
        "biblio/issue": null,
        "biblio/first_page": "687",
        "biblio/last_page": "699",
        "is_retracted": false,
        "is_paratext": false,
        "concepts": [
            {
                "id": "https://openalex.org/C2777899863",
                "wikidata": "https://www.wikidata.org/wiki/Q4428995",
                "display_name": "Sorbent",
                "level": 3,
                "score": 0.922823
            },
            {
                "id": "https://openalex.org/C58445606",
                "wikidata": "https://www.wikidata.org/wiki/Q898533",
                "display_name": "Sorption",
                "level": 3,
                "score": 0.89990085
            },
            {
                "id": "https://openalex.org/C43535742",
                "wikidata": "https://www.wikidata.org/wiki/Q556466",
                "display_name": "Steam reforming",
                "level": 4,
                "score": 0.6724825
            },
            {
                "id": "https://openalex.org/C516920438",
                "wikidata": "https://www.wikidata.org/wiki/Q37129",
                "display_name": "Methane",
                "level": 2,
                "score": 0.6466962
            },
            {
                "id": "https://openalex.org/C161790260",
                "wikidata": "https://www.wikidata.org/wiki/Q82264",
                "display_name": "Catalysis",
                "level": 2,
                "score": 0.6121238
            },
            {
                "id": "https://openalex.org/C147831808",
                "wikidata": "https://www.wikidata.org/wiki/Q1431442",
                "display_name": "Microreactor",
                "level": 3,
                "score": 0.5793686
            },
            {
                "id": "https://openalex.org/C42360764",
                "wikidata": "https://www.wikidata.org/wiki/Q83588",
                "display_name": "Chemical engineering",
                "level": 1,
                "score": 0.55706304
            },
            {
                "id": "https://openalex.org/C192562407",
                "wikidata": "https://www.wikidata.org/wiki/Q228736",
                "display_name": "Materials science",
                "level": 0,
                "score": 0.47155333
            },
            {
                "id": "https://openalex.org/C172331833",
                "wikidata": "https://www.wikidata.org/wiki/Q751029",
                "display_name": "Packed bed",
                "level": 2,
                "score": 0.41315666
            },
            {
                "id": "https://openalex.org/C185592680",
                "wikidata": "https://www.wikidata.org/wiki/Q2329",
                "display_name": "Chemistry",
                "level": 0,
                "score": 0.39531904
            },
            {
                "id": "https://openalex.org/C13965031",
                "wikidata": "https://www.wikidata.org/wiki/Q243545",
                "display_name": "Nuclear chemistry",
                "level": 1,
                "score": 0.32571888
            },
            {
                "id": "https://openalex.org/C202189072",
                "wikidata": "https://www.wikidata.org/wiki/Q1929999",
                "display_name": "Hydrogen production",
                "level": 3,
                "score": 0.21548101
            },
            {
                "id": "https://openalex.org/C150394285",
                "wikidata": "https://www.wikidata.org/wiki/Q180254",
                "display_name": "Adsorption",
                "level": 2,
                "score": 0.18251845
            },
            {
                "id": "https://openalex.org/C43617362",
                "wikidata": "https://www.wikidata.org/wiki/Q170050",
                "display_name": "Chromatography",
                "level": 1,
                "score": 0.17325091
            },
            {
                "id": "https://openalex.org/C178790620",
                "wikidata": "https://www.wikidata.org/wiki/Q11351",
                "display_name": "Organic chemistry",
                "level": 1,
                "score": 0.11035752
            },
            {
                "id": "https://openalex.org/C127413603",
                "wikidata": "https://www.wikidata.org/wiki/Q11023",
                "display_name": "Engineering",
                "level": 0,
                "score": 0
            }
        ],
        "mesh": [],
        "locations_count": 1,
        "locations": [
            {
                "is_oa": false,
                "landing_page_url": "https://doi.org/10.1016/j.fuel.2018.07.071",
                "pdf_url": null,
                "source": {
                    "id": "https://openalex.org/S164770093",
                    "display_name": "Fuel",
                    "issn_l": "0016-2361",
                    "issn": [
                        "0016-2361",
                        "1873-7153"
                    ],
                    "is_oa": false,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/P4310320990",
                    "host_organization_name": "Elsevier BV",
                    "host_organization_lineage": [
                        "https://openalex.org/P4310320990"
                    ],
                    "host_organization_lineage_names": [
                        "Elsevier BV"
                    ],
                    "type": "journal"
                },
                "license": null,
                "version": null,
                "is_accepted": false,
                "is_published": false
            }
        ],
        "best_oa_location": null,
        "sustainable_development_goals": [
            {
                "id": "https://metadata.un.org/sdg/6",
                "display_name": "Clean water and sanitation",
                "score": 0.44
            },
            {
                "id": "https://metadata.un.org/sdg/12",
                "display_name": "Responsible consumption and production",
                "score": 0.15
            },
            {
                "id": "https://metadata.un.org/sdg/7",
                "display_name": "Affordable and clean energy",
                "score": 0.14
            }
        ],
        "grants": [],
        "referenced_works_count": 50,
        "ngrams_url": "https://api.openalex.org/works/W2883201608/ngrams",
        "cited_by_api_url": "https://api.openalex.org/works?filter=cites:W2883201608",
        "counts_by_year": [
            {
                "year": 2023,
                "cited_by_count": 5
            },
            {
                "year": 2022,
                "cited_by_count": 12
            },
            {
                "year": 2021,
                "cited_by_count": 13
            },
            {
                "year": 2020,
                "cited_by_count": 8
            },
            {
                "year": 2019,
                "cited_by_count": 10
            },
            {
                "year": 2018,
                "cited_by_count": 1
            }
        ],
        "updated_date": "2023-10-01T20:39:10.137494",
        "created_date": "2018-08-03"
    }
},
{
    "id": 3,
    "value": {
        "id": "https://openalex.org/W2886411410",
        "doi": "https://doi.org/10.1007/s10980-018-0699-8",
        "title": "Issues and challenges in landscape models for agriculture: from the representation of agroecosystems to the design of management strategies",
        "display_name": "Issues and challenges in landscape models for agriculture: from the representation of agroecosystems to the design of management strategies",
        "publication_year": 2018,
        "publication_date": "2018-08-18",
        "ids/openalex": "https://openalex.org/W2886411410",
        "ids/doi": "https://doi.org/10.1007/s10980-018-0699-8",
        "ids/mag": "2886411410",
        "language": "en",
        "primary_location/is_oa": false,
        "primary_location/landing_page_url": "https://doi.org/10.1007/s10980-018-0699-8",
        "primary_location/pdf_url": null,
        "primary_location/source/id": "https://openalex.org/S104292366",
        "primary_location/source/display_name": "Landscape Ecology",
        "primary_location/source/issn_l": "0921-2973",
        "primary_location/source/issn": [
            "0921-2973",
            "1572-9761"
        ],
        "primary_location/source/is_oa": false,
        "primary_location/source/is_in_doaj": false,
        "primary_location/source/host_organization": "https://openalex.org/P4310319900",
        "primary_location/source/host_organization_name": "Springer Science+Business Media",
        "primary_location/source/host_organization_lineage": [
            "https://openalex.org/P4310319965",
            "https://openalex.org/P4310319900"
        ],
        "primary_location/source/host_organization_lineage_names": [
            "Springer Nature",
            "Springer Science+Business Media"
        ],
        "primary_location/source/type": "journal",
        "primary_location/license": null,
        "primary_location/version": null,
        "primary_location/is_accepted": false,
        "primary_location/is_published": false,
        "type": "article",
        "type_crossref": "journal-article",
        "open_access/is_oa": false,
        "open_access/oa_status": "closed",
        "open_access/oa_url": null,
        "open_access/any_repository_has_fulltext": false,
        "authorships": [
            {
                "author_position": "first",
                "author/id": "https://openalex.org/A5075536028",
                "author/display_name": "Sylvain Poggi",
                "author/orcid": "https://orcid.org/0000-0003-3051-5091",
                "institutions": [
                    {
                        "id": "https://openalex.org/I2800285241",
                        "display_name": "Institut Agro Rennes-Angers",
                        "ror": "https://ror.org/01s3fs709",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I2800285241"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I4210141755",
                        "display_name": "Institute for Genetics, Environment and Plant Protection",
                        "ror": "https://ror.org/038kxsm48",
                        "country_code": "FR",
                        "type": "facility",
                        "lineage": [
                            "https://openalex.org/I2800285241",
                            "https://openalex.org/I3123023596",
                            "https://openalex.org/I4210088668",
                            "https://openalex.org/I4210141755",
                            "https://openalex.org/I56067802"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": true,
                "raw_author_name": "Sylvain Poggi",
                "raw_affiliation_string": "IGEPP, INRA, AgroCampus Ouest, Le Rheu, France",
                "raw_affiliation_strings": [
                    "IGEPP, INRA, AgroCampus Ouest, Le Rheu, France"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5023715213",
                "author/display_name": "Julien Papaïx",
                "author/orcid": "https://orcid.org/0000-0003-2273-5334",
                "institutions": [
                    {
                        "id": "https://openalex.org/I4210121908",
                        "display_name": "Biostatistique et Processus Spatiaux",
                        "ror": "https://ror.org/02d898a89",
                        "country_code": "FR",
                        "type": "facility",
                        "lineage": [
                            "https://openalex.org/I4210121908",
                            "https://openalex.org/I4210136791"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "Julien Papaïx",
                "raw_affiliation_string": "BioSP, INRA, Avignon, France",
                "raw_affiliation_strings": [
                    "BioSP, INRA, Avignon, France"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5004754687",
                "author/display_name": "Claire Lavigne",
                "author/orcid": "https://orcid.org/0000-0003-2869-5177",
                "institutions": [
                    {
                        "id": "https://openalex.org/I4210086462",
                        "display_name": "Plants and Cropping Systems in Horticulture",
                        "ror": "https://ror.org/0024c1w94",
                        "country_code": "FR",
                        "type": "facility",
                        "lineage": [
                            "https://openalex.org/I4210086462",
                            "https://openalex.org/I4210099460"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "Claire Lavigne",
                "raw_affiliation_string": "PSH, INRA, Avignon, France",
                "raw_affiliation_strings": [
                    "PSH, INRA, Avignon, France"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5029189362",
                "author/display_name": "Frédérique Angevin",
                "author/orcid": null,
                "institutions": [],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "Frédérique Angevin",
                "raw_affiliation_string": "Eco-Innov, INRA, Thiverval-Grignon, France",
                "raw_affiliation_strings": [
                    "Eco-Innov, INRA, Thiverval-Grignon, France"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5041047826",
                "author/display_name": "Florence Le Ber",
                "author/orcid": "https://orcid.org/0000-0002-2415-7606",
                "institutions": [
                    {
                        "id": "https://openalex.org/I68947357",
                        "display_name": "University of Strasbourg",
                        "ror": "https://ror.org/00pg6eq24",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I68947357"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I4210120727",
                        "display_name": "National School for Water and Environmental Engineering",
                        "ror": "https://ror.org/02jhjzd11",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I4210120727"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I1294671590",
                        "display_name": "French National Centre for Scientific Research",
                        "ror": "https://ror.org/02feahw73",
                        "country_code": "FR",
                        "type": "government",
                        "lineage": [
                            "https://openalex.org/I1294671590"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "Florence Le Ber",
                "raw_affiliation_string": "ICube, Université de Strasbourg, CNRS, ENGEES, Illkirch-Graffenstaden, France",
                "raw_affiliation_strings": [
                    "ICube, Université de Strasbourg, CNRS, ENGEES, Illkirch-Graffenstaden, France"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5032353230",
                "author/display_name": "Nicolas Parisey",
                "author/orcid": "https://orcid.org/0000-0003-2439-3809",
                "institutions": [
                    {
                        "id": "https://openalex.org/I2800285241",
                        "display_name": "Institut Agro Rennes-Angers",
                        "ror": "https://ror.org/01s3fs709",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I2800285241"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I4210141755",
                        "display_name": "Institute for Genetics, Environment and Plant Protection",
                        "ror": "https://ror.org/038kxsm48",
                        "country_code": "FR",
                        "type": "facility",
                        "lineage": [
                            "https://openalex.org/I2800285241",
                            "https://openalex.org/I3123023596",
                            "https://openalex.org/I4210088668",
                            "https://openalex.org/I4210141755",
                            "https://openalex.org/I56067802"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "Nicolas Parisey",
                "raw_affiliation_string": "IGEPP, INRA, AgroCampus Ouest, Le Rheu, France",
                "raw_affiliation_strings": [
                    "IGEPP, INRA, AgroCampus Ouest, Le Rheu, France"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5028358691",
                "author/display_name": "Benoît Ricci",
                "author/orcid": "https://orcid.org/0000-0002-8661-4200",
                "institutions": [
                    {
                        "id": "https://openalex.org/I4210135996",
                        "display_name": "L'Institut Agro Dijon",
                        "ror": "https://ror.org/03zek0r74",
                        "country_code": "FR",
                        "type": "other",
                        "lineage": [
                            "https://openalex.org/I4210135996"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I4210100404",
                        "display_name": "Agroecology",
                        "ror": "https://ror.org/00mkad321",
                        "country_code": "FR",
                        "type": "facility",
                        "lineage": [
                            "https://openalex.org/I177064439",
                            "https://openalex.org/I4210088668",
                            "https://openalex.org/I4210100404",
                            "https://openalex.org/I4210110412",
                            "https://openalex.org/I4210116240",
                            "https://openalex.org/I4210135996"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I4210118524",
                        "display_name": "Université Bourgogne Franche-Comté",
                        "ror": "https://ror.org/02dn7x778",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I4210118524"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "Benoît Ricci",
                "raw_affiliation_string": "Agroécologie, AgroSup Dijon, INRA, Université Bourgogne Franche-Comté, Dijon, France",
                "raw_affiliation_strings": [
                    "Agroécologie, AgroSup Dijon, INRA, Université Bourgogne Franche-Comté, Dijon, France"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5014481612",
                "author/display_name": "Fabrice Vinatier",
                "author/orcid": "https://orcid.org/0000-0003-3693-4422",
                "institutions": [
                    {
                        "id": "https://openalex.org/I4210136436",
                        "display_name": "Institut Agro Montpelier",
                        "ror": "https://ror.org/03rnk6m14",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I2802056588",
                            "https://openalex.org/I4210136436"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I19894307",
                        "display_name": "University of Montpellier",
                        "ror": "https://ror.org/051escj72",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I19894307",
                            "https://openalex.org/I2802056588"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I4210166444",
                        "display_name": "Institut de Recherche pour le Développement",
                        "ror": "https://ror.org/05q3vnk25",
                        "country_code": "FR",
                        "type": "government",
                        "lineage": [
                            "https://openalex.org/I2802056588",
                            "https://openalex.org/I4210090127",
                            "https://openalex.org/I4210131494",
                            "https://openalex.org/I4210166444"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "Fabrice Vinatier",
                "raw_affiliation_string": "LISAH, Université Montpellier, INRA, IRD, Montpellier SupAgro, Montpellier, France",
                "raw_affiliation_strings": [
                    "LISAH, Université Montpellier, INRA, IRD, Montpellier SupAgro, Montpellier, France"
                ]
            },
            {
                "author_position": "last",
                "author/id": "https://openalex.org/A5057052784",
                "author/display_name": "Julie Wohlfahrt",
                "author/orcid": null,
                "institutions": [],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "Julie Wohlfahrt",
                "raw_affiliation_string": "SAD ASTER, INRA, Mirecourt, France",
                "raw_affiliation_strings": [
                    "SAD ASTER, INRA, Mirecourt, France"
                ]
            }
        ],
        "countries_distinct_count": 1,
        "institutions_distinct_count": 13,
        "corresponding_author_ids": [
            "https://openalex.org/A5075536028"
        ],
        "corresponding_institution_ids": [
            "https://openalex.org/I2800285241",
            "https://openalex.org/I4210141755"
        ],
        "apc_list/value": 3390,
        "apc_list/currency": "EUR",
        "apc_list/value_usd": 4390,
        "apc_list/provenance": "doaj",
        "apc_paid/value": 3390,
        "apc_paid/currency": "EUR",
        "apc_paid/value_usd": 4390,
        "apc_paid/provenance": "doaj",
        "has_fulltext": true,
        "fulltext_origin": "ngrams",
        "cited_by_count": 12,
        "biblio/volume": "33",
        "biblio/issue": "10",
        "biblio/first_page": "1679",
        "biblio/last_page": "1690",
        "is_retracted": false,
        "is_paratext": false,
        "concepts": [
            {
                "id": "https://openalex.org/C87690585",
                "wikidata": "https://www.wikidata.org/wiki/Q738011",
                "display_name": "Landscape ecology",
                "level": 3,
                "score": 0.5094951
            },
            {
                "id": "https://openalex.org/C98045186",
                "wikidata": "https://www.wikidata.org/wiki/Q205663",
                "display_name": "Process (computing)",
                "level": 2,
                "score": 0.4927564
            },
            {
                "id": "https://openalex.org/C118518473",
                "wikidata": "https://www.wikidata.org/wiki/Q11451",
                "display_name": "Agriculture",
                "level": 2,
                "score": 0.4682701
            },
            {
                "id": "https://openalex.org/C41008148",
                "wikidata": "https://www.wikidata.org/wiki/Q21198",
                "display_name": "Computer science",
                "level": 0,
                "score": 0.46327636
            },
            {
                "id": "https://openalex.org/C539667460",
                "wikidata": "https://www.wikidata.org/wiki/Q2414942",
                "display_name": "Management science",
                "level": 1,
                "score": 0.46176213
            },
            {
                "id": "https://openalex.org/C107826830",
                "wikidata": "https://www.wikidata.org/wiki/Q929380",
                "display_name": "Environmental resource management",
                "level": 1,
                "score": 0.44067094
            },
            {
                "id": "https://openalex.org/C552854447",
                "wikidata": "https://www.wikidata.org/wiki/Q131201",
                "display_name": "Sustainable development",
                "level": 2,
                "score": 0.41372767
            },
            {
                "id": "https://openalex.org/C91375879",
                "wikidata": "https://www.wikidata.org/wiki/Q15473274",
                "display_name": "Environmental planning",
                "level": 1,
                "score": 0.32700077
            },
            {
                "id": "https://openalex.org/C18903297",
                "wikidata": "https://www.wikidata.org/wiki/Q7150",
                "display_name": "Ecology",
                "level": 1,
                "score": 0.19881931
            },
            {
                "id": "https://openalex.org/C205649164",
                "wikidata": "https://www.wikidata.org/wiki/Q1071",
                "display_name": "Geography",
                "level": 0,
                "score": 0.19412258
            },
            {
                "id": "https://openalex.org/C127413603",
                "wikidata": "https://www.wikidata.org/wiki/Q11023",
                "display_name": "Engineering",
                "level": 0,
                "score": 0.1466091
            },
            {
                "id": "https://openalex.org/C162324750",
                "wikidata": "https://www.wikidata.org/wiki/Q8134",
                "display_name": "Economics",
                "level": 0,
                "score": 0.086551696
            },
            {
                "id": "https://openalex.org/C185933670",
                "wikidata": "https://www.wikidata.org/wiki/Q52105",
                "display_name": "Habitat",
                "level": 2,
                "score": 0
            },
            {
                "id": "https://openalex.org/C86803240",
                "wikidata": "https://www.wikidata.org/wiki/Q420",
                "display_name": "Biology",
                "level": 0,
                "score": 0
            },
            {
                "id": "https://openalex.org/C111919701",
                "wikidata": "https://www.wikidata.org/wiki/Q9135",
                "display_name": "Operating system",
                "level": 1,
                "score": 0
            }
        ],
        "mesh": [],
        "locations_count": 2,
        "locations": [
            {
                "is_oa": false,
                "landing_page_url": "https://doi.org/10.1007/s10980-018-0699-8",
                "pdf_url": null,
                "source": {
                    "id": "https://openalex.org/S104292366",
                    "display_name": "Landscape Ecology",
                    "issn_l": "0921-2973",
                    "issn": [
                        "0921-2973",
                        "1572-9761"
                    ],
                    "is_oa": false,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/P4310319900",
                    "host_organization_name": "Springer Science+Business Media",
                    "host_organization_lineage": [
                        "https://openalex.org/P4310319965",
                        "https://openalex.org/P4310319900"
                    ],
                    "host_organization_lineage_names": [
                        "Springer Nature",
                        "Springer Science+Business Media"
                    ],
                    "type": "journal"
                },
                "license": null,
                "version": null,
                "is_accepted": false,
                "is_published": false
            },
            {
                "is_oa": false,
                "landing_page_url": "https://hal.inrae.fr/hal-02567492",
                "pdf_url": null,
                "source": {
                    "id": "https://openalex.org/S4306402512",
                    "display_name": "HAL (Le Centre pour la Communication Scientifique Directe)",
                    "issn_l": null,
                    "issn": null,
                    "is_oa": true,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/I1294671590",
                    "host_organization_name": "French National Centre for Scientific Research",
                    "host_organization_lineage": [
                        "https://openalex.org/I1294671590"
                    ],
                    "host_organization_lineage_names": [
                        "French National Centre for Scientific Research"
                    ],
                    "type": "repository"
                },
                "license": null,
                "version": null,
                "is_accepted": false,
                "is_published": false
            }
        ],
        "best_oa_location": null,
        "sustainable_development_goals": [
            {
                "id": "https://metadata.un.org/sdg/2",
                "display_name": "Zero hunger",
                "score": 0.83
            }
        ],
        "grants": [
            {
                "funder": "https://openalex.org/F4320323910",
                "funder_display_name": "Institut National de la Recherche Agronomique",
                "award_id": null
            }
        ],
        "referenced_works_count": 65,
        "ngrams_url": "https://api.openalex.org/works/W2886411410/ngrams",
        "cited_by_api_url": "https://api.openalex.org/works?filter=cites:W2886411410",
        "counts_by_year": [
            {
                "year": 2023,
                "cited_by_count": 4
            },
            {
                "year": 2022,
                "cited_by_count": 2
            },
            {
                "year": 2021,
                "cited_by_count": 2
            },
            {
                "year": 2020,
                "cited_by_count": 3
            },
            {
                "year": 2019,
                "cited_by_count": 1
            }
        ],
        "updated_date": "2023-09-30T00:28:42.510197",
        "created_date": "2018-08-22"
    }
},
{
    "id": 4,
    "value": {
        "id": "https://openalex.org/W2808951402",
        "doi": "https://doi.org/10.1159/000490004",
        "title": "Do &lt;b&gt;&lt;i&gt;Plantago lanceolata&lt;/i&gt;&lt;/b&gt; Skin Prick Test-Positive Patients Display IgE to Genuine Plantain Pollen Allergens? Investigation of Pollen Allergic Patients from the North-East of France",
        "display_name": "Do &lt;b&gt;&lt;i&gt;Plantago lanceolata&lt;/i&gt;&lt;/b&gt; Skin Prick Test-Positive Patients Display IgE to Genuine Plantain Pollen Allergens? Investigation of Pollen Allergic Patients from the North-East of France",
        "publication_year": 2018,
        "publication_date": "2018-01-01",
        "ids/openalex": "https://openalex.org/W2808951402",
        "ids/doi": "https://doi.org/10.1159/000490004",
        "ids/mag": "2808951402",
        "ids/pmid": "https://pubmed.ncbi.nlm.nih.gov/29936506",
        "language": "en",
        "primary_location/is_oa": false,
        "primary_location/landing_page_url": "https://doi.org/10.1159/000490004",
        "primary_location/pdf_url": null,
        "primary_location/source/id": "https://openalex.org/S205866209",
        "primary_location/source/display_name": "International Archives of Allergy and Immunology",
        "primary_location/source/issn_l": "1018-2438",
        "primary_location/source/issn": [
            "1423-0097",
            "1018-2438"
        ],
        "primary_location/source/is_oa": false,
        "primary_location/source/is_in_doaj": false,
        "primary_location/source/host_organization": "https://openalex.org/P4310317820",
        "primary_location/source/host_organization_name": "Karger Publishers",
        "primary_location/source/host_organization_lineage": [
            "https://openalex.org/P4310317820"
        ],
        "primary_location/source/host_organization_lineage_names": [
            "Karger Publishers"
        ],
        "primary_location/source/type": "journal",
        "primary_location/license": null,
        "primary_location/version": null,
        "primary_location/is_accepted": false,
        "primary_location/is_published": false,
        "type": "article",
        "type_crossref": "journal-article",
        "open_access/is_oa": false,
        "open_access/oa_status": "closed",
        "open_access/oa_url": null,
        "open_access/any_repository_has_fulltext": false,
        "authorships": [
            {
                "author_position": "first",
                "author/id": "https://openalex.org/A5072465727",
                "author/display_name": "Teresa Stemeseder",
                "author/orcid": null,
                "institutions": [
                    {
                        "id": "https://openalex.org/I182212641",
                        "display_name": "University of Salzburg",
                        "ror": "https://ror.org/05gs8cd61",
                        "country_code": "AT",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I182212641"
                        ]
                    }
                ],
                "countries": [
                    "AT"
                ],
                "is_corresponding": false,
                "raw_author_name": "Teresa Stemeseder",
                "raw_affiliation_string": "Department of Biosciences, University of Salzburg, Salzburg, Austria",
                "raw_affiliation_strings": [
                    "Department of Biosciences, University of Salzburg, Salzburg, Austria"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5012338157",
                "author/display_name": "C. Metz-Favre",
                "author/orcid": "https://orcid.org/0000-0003-3446-9563",
                "institutions": [
                    {
                        "id": "https://openalex.org/I68947357",
                        "display_name": "University of Strasbourg",
                        "ror": "https://ror.org/00pg6eq24",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I68947357"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "Carine Metz-Favre",
                "raw_affiliation_string": "Allergy Division, Chest Diseases Department, Strasbourg University Hospital, Federation of Translational Medicine, EA 3072, University of Strasbourg, Strasbourg, France",
                "raw_affiliation_strings": [
                    "Allergy Division, Chest Diseases Department, Strasbourg University Hospital, Federation of Translational Medicine, EA 3072, University of Strasbourg, Strasbourg, France"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5086638886",
                "author/display_name": "F. De Blay",
                "author/orcid": "https://orcid.org/0000-0001-5678-2214",
                "institutions": [
                    {
                        "id": "https://openalex.org/I68947357",
                        "display_name": "University of Strasbourg",
                        "ror": "https://ror.org/00pg6eq24",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I68947357"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "Frederic de Blay",
                "raw_affiliation_string": "Allergy Division, Chest Diseases Department, Strasbourg University Hospital, Federation of Translational Medicine, EA 3072, University of Strasbourg, Strasbourg, France",
                "raw_affiliation_strings": [
                    "Allergy Division, Chest Diseases Department, Strasbourg University Hospital, Federation of Translational Medicine, EA 3072, University of Strasbourg, Strasbourg, France"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5054661531",
                "author/display_name": "G. Pauli",
                "author/orcid": null,
                "institutions": [
                    {
                        "id": "https://openalex.org/I68947357",
                        "display_name": "University of Strasbourg",
                        "ror": "https://ror.org/00pg6eq24",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I68947357"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "Gabrielle Pauli",
                "raw_affiliation_string": "Medical University of Strasbourg, Strasbourg, France",
                "raw_affiliation_strings": [
                    "Medical University of Strasbourg, Strasbourg, France"
                ]
            },
            {
                "author_position": "last",
                "author/id": "https://openalex.org/A5031429649",
                "author/display_name": "Gabriele Gadermaier",
                "author/orcid": "https://orcid.org/0000-0002-4886-417X",
                "institutions": [
                    {
                        "id": "https://openalex.org/I182212641",
                        "display_name": "University of Salzburg",
                        "ror": "https://ror.org/05gs8cd61",
                        "country_code": "AT",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I182212641"
                        ]
                    }
                ],
                "countries": [
                    "AT"
                ],
                "is_corresponding": false,
                "raw_author_name": "Gabriele Gadermaier",
                "raw_affiliation_string": "Department of Biosciences, University of Salzburg, Salzburg, Austria",
                "raw_affiliation_strings": [
                    "Department of Biosciences, University of Salzburg, Salzburg, Austria"
                ]
            }
        ],
        "countries_distinct_count": 2,
        "institutions_distinct_count": 2,
        "corresponding_author_ids": [],
        "corresponding_institution_ids": [],
        "apc_list": null,
        "apc_paid": null,
        "has_fulltext": true,
        "fulltext_origin": "ngrams",
        "cited_by_count": 5,
        "biblio/volume": "177",
        "biblio/issue": "2",
        "biblio/first_page": "97",
        "biblio/last_page": "106",
        "is_retracted": false,
        "is_paratext": false,
        "concepts": [
            {
                "id": "https://openalex.org/C2780618852",
                "wikidata": "https://www.wikidata.org/wiki/Q79932",
                "display_name": "Pollen",
                "level": 2,
                "score": 0.8281547
            },
            {
                "id": "https://openalex.org/C2776757896",
                "wikidata": "https://www.wikidata.org/wiki/Q164686",
                "display_name": "Plantago",
                "level": 2,
                "score": 0.8043492
            },
            {
                "id": "https://openalex.org/C141105273",
                "wikidata": "https://www.wikidata.org/wiki/Q79455",
                "display_name": "Immunoglobulin E",
                "level": 3,
                "score": 0.78106606
            },
            {
                "id": "https://openalex.org/C2776217527",
                "wikidata": "https://www.wikidata.org/wiki/Q944828",
                "display_name": "Sensitization",
                "level": 2,
                "score": 0.7037863
            },
            {
                "id": "https://openalex.org/C2780510475",
                "wikidata": "https://www.wikidata.org/wiki/Q186752",
                "display_name": "Allergen",
                "level": 3,
                "score": 0.69904697
            },
            {
                "id": "https://openalex.org/C2776378881",
                "wikidata": "https://www.wikidata.org/wiki/Q1748235",
                "display_name": "Plantaginaceae",
                "level": 2,
                "score": 0.6867641
            },
            {
                "id": "https://openalex.org/C203014093",
                "wikidata": "https://www.wikidata.org/wiki/Q101929",
                "display_name": "Immunology",
                "level": 1,
                "score": 0.6268896
            },
            {
                "id": "https://openalex.org/C207480886",
                "wikidata": "https://www.wikidata.org/wiki/Q42982",
                "display_name": "Allergy",
                "level": 2,
                "score": 0.55329716
            },
            {
                "id": "https://openalex.org/C2779142602",
                "wikidata": "https://www.wikidata.org/wiki/Q1760689",
                "display_name": "Cross-reactivity",
                "level": 4,
                "score": 0.4495144
            },
            {
                "id": "https://openalex.org/C2776949755",
                "wikidata": "https://www.wikidata.org/wiki/Q158502",
                "display_name": "Phleum",
                "level": 2,
                "score": 0.43096036
            },
            {
                "id": "https://openalex.org/C86803240",
                "wikidata": "https://www.wikidata.org/wiki/Q420",
                "display_name": "Biology",
                "level": 0,
                "score": 0.40428442
            },
            {
                "id": "https://openalex.org/C185592680",
                "wikidata": "https://www.wikidata.org/wiki/Q2329",
                "display_name": "Chemistry",
                "level": 0,
                "score": 0.3397917
            },
            {
                "id": "https://openalex.org/C59822182",
                "wikidata": "https://www.wikidata.org/wiki/Q441",
                "display_name": "Botany",
                "level": 1,
                "score": 0.29480088
            },
            {
                "id": "https://openalex.org/C147483822",
                "wikidata": "https://www.wikidata.org/wiki/Q103537",
                "display_name": "Antigen",
                "level": 2,
                "score": 0.2209732
            },
            {
                "id": "https://openalex.org/C159654299",
                "wikidata": "https://www.wikidata.org/wiki/Q79460",
                "display_name": "Antibody",
                "level": 2,
                "score": 0.098707795
            },
            {
                "id": "https://openalex.org/C3020064264",
                "wikidata": "https://www.wikidata.org/wiki/Q1760689",
                "display_name": "Cross reactions",
                "level": 3,
                "score": 0.057759285
            }
        ],
        "mesh": [
            {
                "descriptor_ui": "D000485",
                "descriptor_name": "Allergens",
                "qualifier_ui": "Q000097",
                "qualifier_name": "blood",
                "is_major_topic": true
            },
            {
                "descriptor_ui": "D007073",
                "descriptor_name": "Immunoglobulin E",
                "qualifier_ui": "Q000097",
                "qualifier_name": "blood",
                "is_major_topic": true
            },
            {
                "descriptor_ui": "D010943",
                "descriptor_name": "Plantago",
                "qualifier_ui": "Q000276",
                "qualifier_name": "immunology",
                "is_major_topic": true
            },
            {
                "descriptor_ui": "D006255",
                "descriptor_name": "Rhinitis, Allergic, Seasonal",
                "qualifier_ui": "Q000097",
                "qualifier_name": "blood",
                "is_major_topic": true
            },
            {
                "descriptor_ui": "D006255",
                "descriptor_name": "Rhinitis, Allergic, Seasonal",
                "qualifier_ui": "Q000175",
                "qualifier_name": "diagnosis",
                "is_major_topic": true
            },
            {
                "descriptor_ui": "D012882",
                "descriptor_name": "Skin Tests",
                "qualifier_ui": "",
                "qualifier_name": null,
                "is_major_topic": true
            },
            {
                "descriptor_ui": "D000485",
                "descriptor_name": "Allergens",
                "qualifier_ui": "",
                "qualifier_name": null,
                "is_major_topic": false
            },
            {
                "descriptor_ui": "D000485",
                "descriptor_name": "Allergens",
                "qualifier_ui": "Q000276",
                "qualifier_name": "immunology",
                "is_major_topic": false
            },
            {
                "descriptor_ui": "D004797",
                "descriptor_name": "Enzyme-Linked Immunosorbent Assay",
                "qualifier_ui": "",
                "qualifier_name": null,
                "is_major_topic": false
            },
            {
                "descriptor_ui": "D005602",
                "descriptor_name": "France",
                "qualifier_ui": "",
                "qualifier_name": null,
                "is_major_topic": false
            },
            {
                "descriptor_ui": "D006801",
                "descriptor_name": "Humans",
                "qualifier_ui": "",
                "qualifier_name": null,
                "is_major_topic": false
            },
            {
                "descriptor_ui": "D015151",
                "descriptor_name": "Immunoblotting",
                "qualifier_ui": "",
                "qualifier_name": null,
                "is_major_topic": false
            },
            {
                "descriptor_ui": "D007073",
                "descriptor_name": "Immunoglobulin E",
                "qualifier_ui": "",
                "qualifier_name": null,
                "is_major_topic": false
            },
            {
                "descriptor_ui": "D007073",
                "descriptor_name": "Immunoglobulin E",
                "qualifier_ui": "Q000276",
                "qualifier_name": "immunology",
                "is_major_topic": false
            },
            {
                "descriptor_ui": "D010943",
                "descriptor_name": "Plantago",
                "qualifier_ui": "",
                "qualifier_name": null,
                "is_major_topic": false
            },
            {
                "descriptor_ui": "D006255",
                "descriptor_name": "Rhinitis, Allergic, Seasonal",
                "qualifier_ui": "",
                "qualifier_name": null,
                "is_major_topic": false
            },
            {
                "descriptor_ui": "D006255",
                "descriptor_name": "Rhinitis, Allergic, Seasonal",
                "qualifier_ui": "Q000276",
                "qualifier_name": "immunology",
                "is_major_topic": false
            }
        ],
        "locations_count": 2,
        "locations": [
            {
                "is_oa": false,
                "landing_page_url": "https://doi.org/10.1159/000490004",
                "pdf_url": null,
                "source": {
                    "id": "https://openalex.org/S205866209",
                    "display_name": "International Archives of Allergy and Immunology",
                    "issn_l": "1018-2438",
                    "issn": [
                        "1423-0097",
                        "1018-2438"
                    ],
                    "is_oa": false,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/P4310317820",
                    "host_organization_name": "Karger Publishers",
                    "host_organization_lineage": [
                        "https://openalex.org/P4310317820"
                    ],
                    "host_organization_lineage_names": [
                        "Karger Publishers"
                    ],
                    "type": "journal"
                },
                "license": null,
                "version": null,
                "is_accepted": false,
                "is_published": false
            },
            {
                "is_oa": false,
                "landing_page_url": "https://pubmed.ncbi.nlm.nih.gov/29936506",
                "pdf_url": null,
                "source": {
                    "id": "https://openalex.org/S4306525036",
                    "display_name": "PubMed",
                    "issn_l": null,
                    "issn": null,
                    "is_oa": false,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/I1299303238",
                    "host_organization_name": "National Institutes of Health",
                    "host_organization_lineage": [
                        "https://openalex.org/I1299303238"
                    ],
                    "host_organization_lineage_names": [
                        "National Institutes of Health"
                    ],
                    "type": "repository"
                },
                "license": null,
                "version": null,
                "is_accepted": false,
                "is_published": false
            }
        ],
        "best_oa_location": null,
        "sustainable_development_goals": [
            {
                "id": "https://metadata.un.org/sdg/15",
                "display_name": "Life in Land",
                "score": 0.16
            },
            {
                "id": "https://metadata.un.org/sdg/12",
                "display_name": "Responsible consumption and production",
                "score": 0.13
            },
            {
                "id": "https://metadata.un.org/sdg/3",
                "display_name": "Good health and well-being",
                "score": 0.11
            }
        ],
        "grants": [],
        "referenced_works_count": 0,
        "ngrams_url": "https://api.openalex.org/works/W2808951402/ngrams",
        "cited_by_api_url": "https://api.openalex.org/works?filter=cites:W2808951402",
        "counts_by_year": [
            {
                "year": 2023,
                "cited_by_count": 3
            },
            {
                "year": 2020,
                "cited_by_count": 1
            },
            {
                "year": 2019,
                "cited_by_count": 1
            }
        ],
        "updated_date": "2023-09-29T20:08:47.741831",
        "created_date": "2018-06-29"
    }
},
{
    "id": 5,
    "value": {
        "id": "https://openalex.org/W2889534700",
        "doi": "https://doi.org/10.1016/j.memsci.2018.08.024",
        "title": "Optimization of multistage membrane gas separation processes. Example of application to CO2 capture from blast furnace gas",
        "display_name": "Optimization of multistage membrane gas separation processes. Example of application to CO2 capture from blast furnace gas",
        "publication_year": 2018,
        "publication_date": "2018-11-01",
        "ids/openalex": "https://openalex.org/W2889534700",
        "ids/doi": "https://doi.org/10.1016/j.memsci.2018.08.024",
        "ids/mag": "2889534700",
        "language": "en",
        "primary_location/is_oa": false,
        "primary_location/landing_page_url": "https://doi.org/10.1016/j.memsci.2018.08.024",
        "primary_location/pdf_url": null,
        "primary_location/source/id": "https://openalex.org/S119469986",
        "primary_location/source/display_name": "Journal of Membrane Science",
        "primary_location/source/issn_l": "0376-7388",
        "primary_location/source/issn": [
            "1873-3123",
            "0376-7388"
        ],
        "primary_location/source/is_oa": false,
        "primary_location/source/is_in_doaj": false,
        "primary_location/source/host_organization": "https://openalex.org/P4310320990",
        "primary_location/source/host_organization_name": "Elsevier BV",
        "primary_location/source/host_organization_lineage": [
            "https://openalex.org/P4310320990"
        ],
        "primary_location/source/host_organization_lineage_names": [
            "Elsevier BV"
        ],
        "primary_location/source/type": "journal",
        "primary_location/license": null,
        "primary_location/version": null,
        "primary_location/is_accepted": false,
        "primary_location/is_published": false,
        "type": "article",
        "type_crossref": "journal-article",
        "open_access/is_oa": false,
        "open_access/oa_status": "closed",
        "open_access/oa_url": null,
        "open_access/any_repository_has_fulltext": false,
        "authorships": [
            {
                "author_position": "first",
                "author/id": "https://openalex.org/A5015749276",
                "author/display_name": "Álvaro A. Ramírez‐Santos",
                "author/orcid": null,
                "institutions": [
                    {
                        "id": "https://openalex.org/I90183372",
                        "display_name": "Université de Lorraine",
                        "ror": "https://ror.org/04vfs2w97",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I90183372"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I1294671590",
                        "display_name": "French National Centre for Scientific Research",
                        "ror": "https://ror.org/02feahw73",
                        "country_code": "FR",
                        "type": "government",
                        "lineage": [
                            "https://openalex.org/I1294671590"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "Álvaro Ramírez-Santos",
                "raw_affiliation_string": "Université de Lorraine, CNRS, LRGP, F-54000 Nancy, France",
                "raw_affiliation_strings": [
                    "Université de Lorraine, CNRS, LRGP, F-54000 Nancy, France"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5091387615",
                "author/display_name": "Marjan Bozorg",
                "author/orcid": null,
                "institutions": [
                    {
                        "id": "https://openalex.org/I90183372",
                        "display_name": "Université de Lorraine",
                        "ror": "https://ror.org/04vfs2w97",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I90183372"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I4210121838",
                        "display_name": "Lorraine Research Laboratory in Computer Science and its Applications",
                        "ror": "https://ror.org/02vnf0c38",
                        "country_code": "FR",
                        "type": "facility",
                        "lineage": [
                            "https://openalex.org/I1326498283",
                            "https://openalex.org/I153577553",
                            "https://openalex.org/I4210121838",
                            "https://openalex.org/I4210159245",
                            "https://openalex.org/I90183372"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I1294671590",
                        "display_name": "French National Centre for Scientific Research",
                        "ror": "https://ror.org/02feahw73",
                        "country_code": "FR",
                        "type": "government",
                        "lineage": [
                            "https://openalex.org/I1294671590"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I116067653",
                        "display_name": "University of Rome Tor Vergata",
                        "ror": "https://ror.org/02p77k626",
                        "country_code": "IT",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I116067653"
                        ]
                    }
                ],
                "countries": [
                    "FR",
                    "IT"
                ],
                "is_corresponding": false,
                "raw_author_name": "M. Bozorg",
                "raw_affiliation_string": "Dipartimento di Ingegneria Civile e Ingegneria Informatica, Universitá degli Studi di Roma Tor Vergata, viale del Politecnico 1, 00133 Rome, Italy; Université de Lorraine, CNRS, LORIA, F-54000 Nancy, France",
                "raw_affiliation_strings": [
                    "Dipartimento di Ingegneria Civile e Ingegneria Informatica, Universitá degli Studi di Roma Tor Vergata, viale del Politecnico 1, 00133 Rome, Italy",
                    "Université de Lorraine, CNRS, LORIA, F-54000 Nancy, France"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5020228953",
                "author/display_name": "Bernardetta Addis",
                "author/orcid": "https://orcid.org/0000-0003-4843-8709",
                "institutions": [
                    {
                        "id": "https://openalex.org/I90183372",
                        "display_name": "Université de Lorraine",
                        "ror": "https://ror.org/04vfs2w97",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I90183372"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I4210121838",
                        "display_name": "Lorraine Research Laboratory in Computer Science and its Applications",
                        "ror": "https://ror.org/02vnf0c38",
                        "country_code": "FR",
                        "type": "facility",
                        "lineage": [
                            "https://openalex.org/I1326498283",
                            "https://openalex.org/I153577553",
                            "https://openalex.org/I4210121838",
                            "https://openalex.org/I4210159245",
                            "https://openalex.org/I90183372"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I1294671590",
                        "display_name": "French National Centre for Scientific Research",
                        "ror": "https://ror.org/02feahw73",
                        "country_code": "FR",
                        "type": "government",
                        "lineage": [
                            "https://openalex.org/I1294671590"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "Bernardetta Addis",
                "raw_affiliation_string": "Université de Lorraine, CNRS, LORIA, F-54000 Nancy, France",
                "raw_affiliation_strings": [
                    "Université de Lorraine, CNRS, LORIA, F-54000 Nancy, France"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5068357817",
                "author/display_name": "Veronica Piccialli",
                "author/orcid": "https://orcid.org/0000-0002-3357-9608",
                "institutions": [
                    {
                        "id": "https://openalex.org/I116067653",
                        "display_name": "University of Rome Tor Vergata",
                        "ror": "https://ror.org/02p77k626",
                        "country_code": "IT",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I116067653"
                        ]
                    }
                ],
                "countries": [
                    "IT"
                ],
                "is_corresponding": false,
                "raw_author_name": "V. Piccialli",
                "raw_affiliation_string": "Dipartimento di Ingegneria Civile e Ingegneria Informatica, Universitá degli Studi di Roma Tor Vergata, viale del Politecnico 1, 00133 Rome, Italy",
                "raw_affiliation_strings": [
                    "Dipartimento di Ingegneria Civile e Ingegneria Informatica, Universitá degli Studi di Roma Tor Vergata, viale del Politecnico 1, 00133 Rome, Italy"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5061472778",
                "author/display_name": "Christophe Castel",
                "author/orcid": null,
                "institutions": [
                    {
                        "id": "https://openalex.org/I90183372",
                        "display_name": "Université de Lorraine",
                        "ror": "https://ror.org/04vfs2w97",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I90183372"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I1294671590",
                        "display_name": "French National Centre for Scientific Research",
                        "ror": "https://ror.org/02feahw73",
                        "country_code": "FR",
                        "type": "government",
                        "lineage": [
                            "https://openalex.org/I1294671590"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "C. Castel",
                "raw_affiliation_string": "Université de Lorraine, CNRS, LRGP, F-54000 Nancy, France",
                "raw_affiliation_strings": [
                    "Université de Lorraine, CNRS, LRGP, F-54000 Nancy, France"
                ]
            },
            {
                "author_position": "last",
                "author/id": "https://openalex.org/A5007951485",
                "author/display_name": "Éric Favre",
                "author/orcid": null,
                "institutions": [
                    {
                        "id": "https://openalex.org/I90183372",
                        "display_name": "Université de Lorraine",
                        "ror": "https://ror.org/04vfs2w97",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I90183372"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I1294671590",
                        "display_name": "French National Centre for Scientific Research",
                        "ror": "https://ror.org/02feahw73",
                        "country_code": "FR",
                        "type": "government",
                        "lineage": [
                            "https://openalex.org/I1294671590"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": true,
                "raw_author_name": "E. Favre",
                "raw_affiliation_string": "Université de Lorraine, CNRS, LRGP, F-54000 Nancy, France",
                "raw_affiliation_strings": [
                    "Université de Lorraine, CNRS, LRGP, F-54000 Nancy, France"
                ]
            }
        ],
        "countries_distinct_count": 2,
        "institutions_distinct_count": 4,
        "corresponding_author_ids": [
            "https://openalex.org/A5007951485"
        ],
        "corresponding_institution_ids": [
            "https://openalex.org/I90183372",
            "https://openalex.org/I1294671590"
        ],
        "apc_list/value": 4750,
        "apc_list/currency": "USD",
        "apc_list/value_usd": 4750,
        "apc_list/provenance": "doaj",
        "apc_paid/value": 4750,
        "apc_paid/currency": "USD",
        "apc_paid/value_usd": 4750,
        "apc_paid/provenance": "doaj",
        "has_fulltext": false,
        "cited_by_count": 51,
        "biblio/volume": "566",
        "biblio/issue": null,
        "biblio/first_page": "346",
        "biblio/last_page": "366",
        "is_retracted": false,
        "is_paratext": false,
        "concepts": [
            {
                "id": "https://openalex.org/C175783084",
                "wikidata": "https://www.wikidata.org/wiki/Q205470",
                "display_name": "Blast furnace gas",
                "level": 3,
                "score": 0.6917398
            },
            {
                "id": "https://openalex.org/C2780269488",
                "wikidata": "https://www.wikidata.org/wiki/Q181485",
                "display_name": "Blast furnace",
                "level": 2,
                "score": 0.67138934
            },
            {
                "id": "https://openalex.org/C41625074",
                "wikidata": "https://www.wikidata.org/wiki/Q176088",
                "display_name": "Membrane",
                "level": 2,
                "score": 0.61837924
            },
            {
                "id": "https://openalex.org/C18411161",
                "wikidata": "https://www.wikidata.org/wiki/Q17050218",
                "display_name": "Gas separation",
                "level": 3,
                "score": 0.59952545
            },
            {
                "id": "https://openalex.org/C2776061190",
                "wikidata": "https://www.wikidata.org/wiki/Q7451805",
                "display_name": "Separation (statistics)",
                "level": 2,
                "score": 0.49158677
            },
            {
                "id": "https://openalex.org/C94005225",
                "wikidata": "https://www.wikidata.org/wiki/Q1751537",
                "display_name": "Membrane technology",
                "level": 3,
                "score": 0.4225661
            },
            {
                "id": "https://openalex.org/C21880701",
                "wikidata": "https://www.wikidata.org/wiki/Q2144042",
                "display_name": "Process engineering",
                "level": 1,
                "score": 0.406998
            },
            {
                "id": "https://openalex.org/C185592680",
                "wikidata": "https://www.wikidata.org/wiki/Q2329",
                "display_name": "Chemistry",
                "level": 0,
                "score": 0.3900322
            },
            {
                "id": "https://openalex.org/C43617362",
                "wikidata": "https://www.wikidata.org/wiki/Q170050",
                "display_name": "Chromatography",
                "level": 1,
                "score": 0.37323445
            },
            {
                "id": "https://openalex.org/C39432304",
                "wikidata": "https://www.wikidata.org/wiki/Q188847",
                "display_name": "Environmental science",
                "level": 0,
                "score": 0.35703823
            },
            {
                "id": "https://openalex.org/C192562407",
                "wikidata": "https://www.wikidata.org/wiki/Q228736",
                "display_name": "Materials science",
                "level": 0,
                "score": 0.34894735
            },
            {
                "id": "https://openalex.org/C548081761",
                "wikidata": "https://www.wikidata.org/wiki/Q180388",
                "display_name": "Waste management",
                "level": 1,
                "score": 0.33515766
            },
            {
                "id": "https://openalex.org/C127413603",
                "wikidata": "https://www.wikidata.org/wiki/Q11023",
                "display_name": "Engineering",
                "level": 0,
                "score": 0.22293285
            },
            {
                "id": "https://openalex.org/C41008148",
                "wikidata": "https://www.wikidata.org/wiki/Q21198",
                "display_name": "Computer science",
                "level": 0,
                "score": 0.21141413
            },
            {
                "id": "https://openalex.org/C178790620",
                "wikidata": "https://www.wikidata.org/wiki/Q11351",
                "display_name": "Organic chemistry",
                "level": 1,
                "score": 0.08569649
            },
            {
                "id": "https://openalex.org/C55493867",
                "wikidata": "https://www.wikidata.org/wiki/Q7094",
                "display_name": "Biochemistry",
                "level": 1,
                "score": 0
            },
            {
                "id": "https://openalex.org/C119857082",
                "wikidata": "https://www.wikidata.org/wiki/Q2539",
                "display_name": "Machine learning",
                "level": 1,
                "score": 0
            }
        ],
        "mesh": [],
        "locations_count": 4,
        "locations": [
            {
                "is_oa": false,
                "landing_page_url": "https://doi.org/10.1016/j.memsci.2018.08.024",
                "pdf_url": null,
                "source": {
                    "id": "https://openalex.org/S119469986",
                    "display_name": "Journal of Membrane Science",
                    "issn_l": "0376-7388",
                    "issn": [
                        "1873-3123",
                        "0376-7388"
                    ],
                    "is_oa": false,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/P4310320990",
                    "host_organization_name": "Elsevier BV",
                    "host_organization_lineage": [
                        "https://openalex.org/P4310320990"
                    ],
                    "host_organization_lineage_names": [
                        "Elsevier BV"
                    ],
                    "type": "journal"
                },
                "license": null,
                "version": null,
                "is_accepted": false,
                "is_published": false
            },
            {
                "is_oa": false,
                "landing_page_url": "https://hal.univ-lorraine.fr/hal-01921375",
                "pdf_url": null,
                "source": {
                    "id": "https://openalex.org/S4306402512",
                    "display_name": "HAL (Le Centre pour la Communication Scientifique Directe)",
                    "issn_l": null,
                    "issn": null,
                    "is_oa": true,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/I1294671590",
                    "host_organization_name": "French National Centre for Scientific Research",
                    "host_organization_lineage": [
                        "https://openalex.org/I1294671590"
                    ],
                    "host_organization_lineage_names": [
                        "French National Centre for Scientific Research"
                    ],
                    "type": "repository"
                },
                "license": null,
                "version": null,
                "is_accepted": false,
                "is_published": false
            },
            {
                "is_oa": false,
                "landing_page_url": "https://hal.univ-lorraine.fr/hal-02939885",
                "pdf_url": null,
                "source": {
                    "id": "https://openalex.org/S4306402512",
                    "display_name": "HAL (Le Centre pour la Communication Scientifique Directe)",
                    "issn_l": null,
                    "issn": null,
                    "is_oa": true,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/I1294671590",
                    "host_organization_name": "French National Centre for Scientific Research",
                    "host_organization_lineage": [
                        "https://openalex.org/I1294671590"
                    ],
                    "host_organization_lineage_names": [
                        "French National Centre for Scientific Research"
                    ],
                    "type": "repository"
                },
                "license": null,
                "version": null,
                "is_accepted": false,
                "is_published": false
            },
            {
                "is_oa": false,
                "landing_page_url": "https://hal.univ-lorraine.fr/hal-02939670",
                "pdf_url": null,
                "source": {
                    "id": "https://openalex.org/S4306402512",
                    "display_name": "HAL (Le Centre pour la Communication Scientifique Directe)",
                    "issn_l": null,
                    "issn": null,
                    "is_oa": true,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/I1294671590",
                    "host_organization_name": "French National Centre for Scientific Research",
                    "host_organization_lineage": [
                        "https://openalex.org/I1294671590"
                    ],
                    "host_organization_lineage_names": [
                        "French National Centre for Scientific Research"
                    ],
                    "type": "repository"
                },
                "license": null,
                "version": null,
                "is_accepted": false,
                "is_published": false
            }
        ],
        "best_oa_location": null,
        "sustainable_development_goals": [
            {
                "id": "https://metadata.un.org/sdg/12",
                "display_name": "Responsible consumption and production",
                "score": 0.24
            },
            {
                "id": "https://metadata.un.org/sdg/6",
                "display_name": "Clean water and sanitation",
                "score": 0.22
            },
            {
                "id": "https://metadata.un.org/sdg/7",
                "display_name": "Affordable and clean energy",
                "score": 0.15
            },
            {
                "id": "https://metadata.un.org/sdg/9",
                "display_name": "Industry, innovation and infrastructure",
                "score": 0.13
            }
        ],
        "grants": [],
        "referenced_works_count": 25,
        "ngrams_url": "https://api.openalex.org/works/W2889534700/ngrams",
        "cited_by_api_url": "https://api.openalex.org/works?filter=cites:W2889534700",
        "counts_by_year": [
            {
                "year": 2023,
                "cited_by_count": 11
            },
            {
                "year": 2022,
                "cited_by_count": 12
            },
            {
                "year": 2021,
                "cited_by_count": 12
            },
            {
                "year": 2020,
                "cited_by_count": 9
            },
            {
                "year": 2019,
                "cited_by_count": 7
            },
            {
                "year": 2018,
                "cited_by_count": 1
            }
        ],
        "updated_date": "2023-10-02T05:58:23.358193",
        "created_date": "2018-09-07"
    }
},
{
    "id": 6,
    "value": {
        "id": "https://openalex.org/W2902001243",
        "doi": "https://doi.org/10.1029/2018jd029272",
        "title": "Observationally Weak TGFs in the RHESSI Data",
        "display_name": "Observationally Weak TGFs in the RHESSI Data",
        "publication_year": 2019,
        "publication_date": "2019-01-11",
        "ids/openalex": "https://openalex.org/W2902001243",
        "ids/doi": "https://doi.org/10.1029/2018jd029272",
        "ids/mag": "2902001243",
        "ids/pmid": "https://pubmed.ncbi.nlm.nih.gov/31007988",
        "ids/pmcid": "https://www.ncbi.nlm.nih.gov/pmc/articles/6472622",
        "language": "en",
        "primary_location/is_oa": true,
        "primary_location/landing_page_url": "https://doi.org/10.1029/2018jd029272",
        "primary_location/pdf_url": "https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/10.1029/2018JD029272",
        "primary_location/source/id": "https://openalex.org/S4210205282",
        "primary_location/source/display_name": "Journal Of Geophysical Research: Atmospheres",
        "primary_location/source/issn_l": "2169-897X",
        "primary_location/source/issn": [
            "2169-8996",
            "2169-897X"
        ],
        "primary_location/source/is_oa": false,
        "primary_location/source/is_in_doaj": false,
        "primary_location/source/host_organization": "https://openalex.org/P4310320503",
        "primary_location/source/host_organization_name": "Wiley-Blackwell",
        "primary_location/source/host_organization_lineage": [
            "https://openalex.org/P4310320503",
            "https://openalex.org/P4310320595"
        ],
        "primary_location/source/host_organization_lineage_names": [
            "Wiley-Blackwell",
            "Wiley"
        ],
        "primary_location/source/type": "journal",
        "primary_location/license": "cc-by-nc-nd",
        "primary_location/version": "publishedVersion",
        "primary_location/is_accepted": true,
        "primary_location/is_published": true,
        "type": "article",
        "type_crossref": "journal-article",
        "open_access/is_oa": true,
        "open_access/oa_status": "hybrid",
        "open_access/oa_url": "https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/10.1029/2018JD029272",
        "open_access/any_repository_has_fulltext": true,
        "authorships": [
            {
                "author_position": "first",
                "author/id": "https://openalex.org/A5090991308",
                "author/display_name": "Kjetil Albrechtsen",
                "author/orcid": null,
                "institutions": [
                    {
                        "id": "https://openalex.org/I4432739",
                        "display_name": "University of Bergen",
                        "ror": "https://ror.org/03zga2b32",
                        "country_code": "NO",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I4432739"
                        ]
                    }
                ],
                "countries": [
                    "NO"
                ],
                "is_corresponding": true,
                "raw_author_name": "K. H. Albrechtsen",
                "raw_affiliation_string": "Birkeland Centre for Space Science, Department of Physics and Technology, University of Bergen, Bergen, Norway",
                "raw_affiliation_strings": [
                    "Birkeland Centre for Space Science, Department of Physics and Technology, University of Bergen, Bergen, Norway"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5030095538",
                "author/display_name": "Nikolai Østgaard",
                "author/orcid": "https://orcid.org/0000-0002-2572-7033",
                "institutions": [
                    {
                        "id": "https://openalex.org/I4432739",
                        "display_name": "University of Bergen",
                        "ror": "https://ror.org/03zga2b32",
                        "country_code": "NO",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I4432739"
                        ]
                    }
                ],
                "countries": [
                    "NO"
                ],
                "is_corresponding": false,
                "raw_author_name": "N. Østgaard",
                "raw_affiliation_string": "Birkeland Centre for Space Science, Department of Physics and Technology, University of Bergen, Bergen, Norway",
                "raw_affiliation_strings": [
                    "Birkeland Centre for Space Science, Department of Physics and Technology, University of Bergen, Bergen, Norway"
                ]
            },
            {
                "author_position": "middle",
                "author/id": "https://openalex.org/A5043770238",
                "author/display_name": "N. Berge",
                "author/orcid": "https://orcid.org/0000-0003-4375-4518",
                "institutions": [
                    {
                        "id": "https://openalex.org/I12449238",
                        "display_name": "University of Orléans",
                        "ror": "https://ror.org/014zrew76",
                        "country_code": "FR",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I12449238"
                        ]
                    },
                    {
                        "id": "https://openalex.org/I1294671590",
                        "display_name": "French National Centre for Scientific Research",
                        "ror": "https://ror.org/02feahw73",
                        "country_code": "FR",
                        "type": "government",
                        "lineage": [
                            "https://openalex.org/I1294671590"
                        ]
                    }
                ],
                "countries": [
                    "FR"
                ],
                "is_corresponding": false,
                "raw_author_name": "N. Berge",
                "raw_affiliation_string": "LPC2E, CNRS, University of Orleans, Orleans, France",
                "raw_affiliation_strings": [
                    "LPC2E, CNRS, University of Orleans, Orleans, France"
                ]
            },
            {
                "author_position": "last",
                "author/id": "https://openalex.org/A5018256373",
                "author/display_name": "Thomas Gjesteland",
                "author/orcid": null,
                "institutions": [
                    {
                        "id": "https://openalex.org/I200650556",
                        "display_name": "University of Agder",
                        "ror": "https://ror.org/03x297z98",
                        "country_code": "NO",
                        "type": "education",
                        "lineage": [
                            "https://openalex.org/I200650556"
                        ]
                    }
                ],
                "countries": [
                    "NO"
                ],
                "is_corresponding": false,
                "raw_author_name": "T. Gjesteland",
                "raw_affiliation_string": "Department of Engineering Science; University of Agder; Grimstad Norway",
                "raw_affiliation_strings": [
                    "Department of Engineering Science; University of Agder; Grimstad Norway"
                ]
            }
        ],
        "countries_distinct_count": 2,
        "institutions_distinct_count": 4,
        "corresponding_author_ids": [
            "https://openalex.org/A5090991308"
        ],
        "corresponding_institution_ids": [
            "https://openalex.org/I4432739"
        ],
        "apc_list/value": 3700,
        "apc_list/currency": "USD",
        "apc_list/value_usd": 3700,
        "apc_list/provenance": "doaj",
        "apc_paid/value": 3700,
        "apc_paid/currency": "USD",
        "apc_paid/value_usd": 3700,
        "apc_paid/provenance": "doaj",
        "has_fulltext": true,
        "fulltext_origin": "ngrams",
        "cited_by_count": 10,
        "biblio/volume": "124",
        "biblio/issue": "1",
        "biblio/first_page": "287",
        "biblio/last_page": "298",
        "is_retracted": false,
        "is_paratext": false,
        "concepts": [
            {
                "id": "https://openalex.org/C69398868",
                "wikidata": "https://www.wikidata.org/wiki/Q129052",
                "display_name": "Lightning (connector)",
                "level": 3,
                "score": 0.6711861
            },
            {
                "id": "https://openalex.org/C121332964",
                "wikidata": "https://www.wikidata.org/wiki/Q413",
                "display_name": "Physics",
                "level": 0,
                "score": 0.6579335
            },
            {
                "id": "https://openalex.org/C44870925",
                "wikidata": "https://www.wikidata.org/wiki/Q37547",
                "display_name": "Astrophysics",
                "level": 1,
                "score": 0.5264374
            },
            {
                "id": "https://openalex.org/C80316258",
                "wikidata": "https://www.wikidata.org/wiki/Q2857578",
                "display_name": "Thunderstorm",
                "level": 2,
                "score": 0.5108723
            },
            {
                "id": "https://openalex.org/C122523270",
                "wikidata": "https://www.wikidata.org/wiki/Q34027",
                "display_name": "Latitude",
                "level": 2,
                "score": 0.5048614
            },
            {
                "id": "https://openalex.org/C7910260",
                "wikidata": "https://www.wikidata.org/wiki/Q11523",
                "display_name": "Gamma ray",
                "level": 2,
                "score": 0.46159953
            },
            {
                "id": "https://openalex.org/C62649853",
                "wikidata": "https://www.wikidata.org/wiki/Q199687",
                "display_name": "Remote sensing",
                "level": 1,
                "score": 0.37732825
            },
            {
                "id": "https://openalex.org/C163258240",
                "wikidata": "https://www.wikidata.org/wiki/Q25342",
                "display_name": "Power (physics)",
                "level": 2,
                "score": 0.21475959
            },
            {
                "id": "https://openalex.org/C1276947",
                "wikidata": "https://www.wikidata.org/wiki/Q333",
                "display_name": "Astronomy",
                "level": 1,
                "score": 0.1877881
            },
            {
                "id": "https://openalex.org/C153294291",
                "wikidata": "https://www.wikidata.org/wiki/Q25261",
                "display_name": "Meteorology",
                "level": 1,
                "score": 0.1877782
            },
            {
                "id": "https://openalex.org/C205649164",
                "wikidata": "https://www.wikidata.org/wiki/Q1071",
                "display_name": "Geography",
                "level": 0,
                "score": 0.10515764
            },
            {
                "id": "https://openalex.org/C62520636",
                "wikidata": "https://www.wikidata.org/wiki/Q944",
                "display_name": "Quantum mechanics",
                "level": 1,
                "score": 0
            }
        ],
        "mesh": [],
        "locations_count": 7,
        "locations": [
            {
                "is_oa": true,
                "landing_page_url": "https://doi.org/10.1029/2018jd029272",
                "pdf_url": "https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/10.1029/2018JD029272",
                "source": {
                    "id": "https://openalex.org/S4210205282",
                    "display_name": "Journal Of Geophysical Research: Atmospheres",
                    "issn_l": "2169-897X",
                    "issn": [
                        "2169-8996",
                        "2169-897X"
                    ],
                    "is_oa": false,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/P4310320503",
                    "host_organization_name": "Wiley-Blackwell",
                    "host_organization_lineage": [
                        "https://openalex.org/P4310320503",
                        "https://openalex.org/P4310320595"
                    ],
                    "host_organization_lineage_names": [
                        "Wiley-Blackwell",
                        "Wiley"
                    ],
                    "type": "journal"
                },
                "license": "cc-by-nc-nd",
                "version": "publishedVersion",
                "is_accepted": true,
                "is_published": true
            },
            {
                "is_oa": true,
                "landing_page_url": "https://europepmc.org/articles/pmc6472622",
                "pdf_url": "https://europepmc.org/articles/pmc6472622?pdf=render",
                "source": {
                    "id": "https://openalex.org/S4306400806",
                    "display_name": "Europe PMC (PubMed Central)",
                    "issn_l": null,
                    "issn": null,
                    "is_oa": true,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/I1303153112",
                    "host_organization_name": "European Bioinformatics Institute",
                    "host_organization_lineage": [
                        "https://openalex.org/I1303153112"
                    ],
                    "host_organization_lineage_names": [
                        "European Bioinformatics Institute"
                    ],
                    "type": "repository"
                },
                "license": "cc-by-nc-nd",
                "version": "publishedVersion",
                "is_accepted": true,
                "is_published": true
            },
            {
                "is_oa": true,
                "landing_page_url": "https://hal-insu.archives-ouvertes.fr/insu-01957355",
                "pdf_url": "https://insu.hal.science/insu-01957355/document",
                "source": {
                    "id": "https://openalex.org/S4306402512",
                    "display_name": "HAL (Le Centre pour la Communication Scientifique Directe)",
                    "issn_l": null,
                    "issn": null,
                    "is_oa": true,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/I1294671590",
                    "host_organization_name": "French National Centre for Scientific Research",
                    "host_organization_lineage": [
                        "https://openalex.org/I1294671590"
                    ],
                    "host_organization_lineage_names": [
                        "French National Centre for Scientific Research"
                    ],
                    "type": "repository"
                },
                "license": null,
                "version": "publishedVersion",
                "is_accepted": true,
                "is_published": true
            },
            {
                "is_oa": true,
                "landing_page_url": "https://hal-insu.archives-ouvertes.fr/insu-01957355/document",
                "pdf_url": "https://hal-insu.archives-ouvertes.fr/insu-01957355/document",
                "source": {
                    "id": "https://openalex.org/S4306402512",
                    "display_name": "HAL (Le Centre pour la Communication Scientifique Directe)",
                    "issn_l": null,
                    "issn": null,
                    "is_oa": true,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/I1294671590",
                    "host_organization_name": "French National Centre for Scientific Research",
                    "host_organization_lineage": [
                        "https://openalex.org/I1294671590"
                    ],
                    "host_organization_lineage_names": [
                        "French National Centre for Scientific Research"
                    ],
                    "type": "repository"
                },
                "license": null,
                "version": "publishedVersion",
                "is_accepted": true,
                "is_published": true
            },
            {
                "is_oa": true,
                "landing_page_url": "https://hal-insu.archives-ouvertes.fr/insu-01957355/file/Albrechtsen_et_al-2019-Journal_of_Geophysical_Research__Atmospheres.pdf",
                "pdf_url": "https://hal-insu.archives-ouvertes.fr/insu-01957355/file/Albrechtsen_et_al-2019-Journal_of_Geophysical_Research__Atmospheres.pdf",
                "source": {
                    "id": "https://openalex.org/S4306402512",
                    "display_name": "HAL (Le Centre pour la Communication Scientifique Directe)",
                    "issn_l": null,
                    "issn": null,
                    "is_oa": true,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/I1294671590",
                    "host_organization_name": "French National Centre for Scientific Research",
                    "host_organization_lineage": [
                        "https://openalex.org/I1294671590"
                    ],
                    "host_organization_lineage_names": [
                        "French National Centre for Scientific Research"
                    ],
                    "type": "repository"
                },
                "license": null,
                "version": "publishedVersion",
                "is_accepted": true,
                "is_published": true
            },
            {
                "is_oa": true,
                "landing_page_url": "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6472622",
                "pdf_url": null,
                "source": {
                    "id": "https://openalex.org/S2764455111",
                    "display_name": "PubMed Central",
                    "issn_l": null,
                    "issn": null,
                    "is_oa": true,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/I1299303238",
                    "host_organization_name": "National Institutes of Health",
                    "host_organization_lineage": [
                        "https://openalex.org/I1299303238"
                    ],
                    "host_organization_lineage_names": [
                        "National Institutes of Health"
                    ],
                    "type": "repository"
                },
                "license": null,
                "version": "publishedVersion",
                "is_accepted": true,
                "is_published": true
            },
            {
                "is_oa": false,
                "landing_page_url": "https://pubmed.ncbi.nlm.nih.gov/31007988",
                "pdf_url": null,
                "source": {
                    "id": "https://openalex.org/S4306525036",
                    "display_name": "PubMed",
                    "issn_l": null,
                    "issn": null,
                    "is_oa": false,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/I1299303238",
                    "host_organization_name": "National Institutes of Health",
                    "host_organization_lineage": [
                        "https://openalex.org/I1299303238"
                    ],
                    "host_organization_lineage_names": [
                        "National Institutes of Health"
                    ],
                    "type": "repository"
                },
                "license": null,
                "version": null,
                "is_accepted": false,
                "is_published": false
            }
        ],
        "best_oa_location/is_oa": true,
        "best_oa_location/landing_page_url": "https://doi.org/10.1029/2018jd029272",
        "best_oa_location/pdf_url": "https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/10.1029/2018JD029272",
        "best_oa_location/source/id": "https://openalex.org/S4210205282",
        "best_oa_location/source/display_name": "Journal Of Geophysical Research: Atmospheres",
        "best_oa_location/source/issn_l": "2169-897X",
        "best_oa_location/source/issn": [
            "2169-8996",
            "2169-897X"
        ],
        "best_oa_location/source/is_oa": false,
        "best_oa_location/source/is_in_doaj": false,
        "best_oa_location/source/host_organization": "https://openalex.org/P4310320503",
        "best_oa_location/source/host_organization_name": "Wiley-Blackwell",
        "best_oa_location/source/host_organization_lineage": [
            "https://openalex.org/P4310320503",
            "https://openalex.org/P4310320595"
        ],
        "best_oa_location/source/host_organization_lineage_names": [
            "Wiley-Blackwell",
            "Wiley"
        ],
        "best_oa_location/source/type": "journal",
        "best_oa_location/license": "cc-by-nc-nd",
        "best_oa_location/version": "publishedVersion",
        "best_oa_location/is_accepted": true,
        "best_oa_location/is_published": true,
        "sustainable_development_goals": [
            {
                "id": "https://metadata.un.org/sdg/14",
                "display_name": "Life below water",
                "score": 0.65
            }
        ],
        "grants": [
            {
                "funder": "https://openalex.org/F4320323299",
                "funder_display_name": "Norges Forskningsråd",
                "award_id": "208028/F50"
            },
            {
                "funder": "https://openalex.org/F4320333065",
                "funder_display_name": "Seventh Framework Programme",
                "award_id": "320839"
            }
        ],
        "referenced_works_count": 42,
        "ngrams_url": "https://api.openalex.org/works/W2902001243/ngrams",
        "cited_by_api_url": "https://api.openalex.org/works?filter=cites:W2902001243",
        "counts_by_year": [
            {
                "year": 2023,
                "cited_by_count": 1
            },
            {
                "year": 2022,
                "cited_by_count": 2
            },
            {
                "year": 2021,
                "cited_by_count": 3
            },
            {
                "year": 2020,
                "cited_by_count": 3
            },
            {
                "year": 2019,
                "cited_by_count": 1
            }
        ],
        "updated_date": "2023-09-27T05:54:42.992792",
        "created_date": "2018-12-11"
    }
},
{
    "id": 7,
    "value": {
        "id": "https://openalex.org/W2995359462",
        "doi": "https://doi.org/10.4000/edc.9014",
        "title": "Da Sylva Lyne, Cuxac Pascal : Analyse et exploitation des bibliothèques numériques",
        "display_name": "Da Sylva Lyne, Cuxac Pascal : Analyse et exploitation des bibliothèques numériques",
        "publication_year": 2019,
        "publication_date": "2019-06-01",
        "ids/openalex": "https://openalex.org/W2995359462",
        "ids/doi": "https://doi.org/10.4000/edc.9014",
        "ids/mag": "2995359462",
        "language": "fr",
        "primary_location/is_oa": true,
        "primary_location/landing_page_url": "https://doi.org/10.4000/edc.9014",
        "primary_location/pdf_url": null,
        "primary_location/source/id": "https://openalex.org/S4210179695",
        "primary_location/source/display_name": "Etudes de communication",
        "primary_location/source/issn_l": "1270-6841",
        "primary_location/source/issn": [
            "2101-0366",
            "1270-6841"
        ],
        "primary_location/source/is_oa": false,
        "primary_location/source/is_in_doaj": false,
        "primary_location/source/host_organization": "https://openalex.org/P4310311060",
        "primary_location/source/host_organization_name": "Charles de Gaulle University of humanities arts and social sciences",
        "primary_location/source/host_organization_lineage": [
            "https://openalex.org/P4310311060",
            "https://openalex.org/P4310311198"
        ],
        "primary_location/source/host_organization_lineage_names": [
            "Charles de Gaulle University of humanities arts and social sciences",
            "Lille North of France University"
        ],
        "primary_location/source/type": "journal",
        "primary_location/license": null,
        "primary_location/version": "publishedVersion",
        "primary_location/is_accepted": true,
        "primary_location/is_published": true,
        "type": "article",
        "type_crossref": "journal-article",
        "open_access/is_oa": true,
        "open_access/oa_status": "bronze",
        "open_access/oa_url": "https://doi.org/10.4000/edc.9014",
        "open_access/any_repository_has_fulltext": false,
        "authorships": [
            {
                "author_position": "first",
                "author/id": "https://openalex.org/A5024156692",
                "author/display_name": "Florence Thiault",
                "author/orcid": "https://orcid.org/0000-0001-7466-5855",
                "institutions": [],
                "countries": [],
                "is_corresponding": true,
                "raw_author_name": "Florence Thiault",
                "raw_affiliation_string": "",
                "raw_affiliation_strings": []
            }
        ],
        "countries_distinct_count": 0,
        "institutions_distinct_count": 0,
        "corresponding_author_ids": [
            "https://openalex.org/A5024156692"
        ],
        "corresponding_institution_ids": [],
        "apc_list": null,
        "apc_paid": null,
        "has_fulltext": false,
        "cited_by_count": 0,
        "biblio/volume": null,
        "biblio/issue": "52",
        "biblio/first_page": "211",
        "biblio/last_page": "216",
        "is_retracted": false,
        "is_paratext": false,
        "concepts": [
            {
                "id": "https://openalex.org/C75608658",
                "wikidata": "https://www.wikidata.org/wiki/Q44395",
                "display_name": "Pascal (unit)",
                "level": 2,
                "score": 0.663949
            },
            {
                "id": "https://openalex.org/C142362112",
                "wikidata": "https://www.wikidata.org/wiki/Q735",
                "display_name": "Art",
                "level": 0,
                "score": 0.4001369
            },
            {
                "id": "https://openalex.org/C41008148",
                "wikidata": "https://www.wikidata.org/wiki/Q21198",
                "display_name": "Computer science",
                "level": 0,
                "score": 0.2816674
            },
            {
                "id": "https://openalex.org/C199360897",
                "wikidata": "https://www.wikidata.org/wiki/Q9143",
                "display_name": "Programming language",
                "level": 1,
                "score": 0.060611933
            }
        ],
        "mesh": [],
        "locations_count": 1,
        "locations": [
            {
                "is_oa": true,
                "landing_page_url": "https://doi.org/10.4000/edc.9014",
                "pdf_url": null,
                "source": {
                    "id": "https://openalex.org/S4210179695",
                    "display_name": "Etudes de communication",
                    "issn_l": "1270-6841",
                    "issn": [
                        "2101-0366",
                        "1270-6841"
                    ],
                    "is_oa": false,
                    "is_in_doaj": false,
                    "host_organization": "https://openalex.org/P4310311060",
                    "host_organization_name": "Charles de Gaulle University of humanities arts and social sciences",
                    "host_organization_lineage": [
                        "https://openalex.org/P4310311060",
                        "https://openalex.org/P4310311198"
                    ],
                    "host_organization_lineage_names": [
                        "Charles de Gaulle University of humanities arts and social sciences",
                        "Lille North of France University"
                    ],
                    "type": "journal"
                },
                "license": null,
                "version": "publishedVersion",
                "is_accepted": true,
                "is_published": true
            }
        ],
        "best_oa_location/is_oa": true,
        "best_oa_location/landing_page_url": "https://doi.org/10.4000/edc.9014",
        "best_oa_location/pdf_url": null,
        "best_oa_location/source/id": "https://openalex.org/S4210179695",
        "best_oa_location/source/display_name": "Etudes de communication",
        "best_oa_location/source/issn_l": "1270-6841",
        "best_oa_location/source/issn": [
            "2101-0366",
            "1270-6841"
        ],
        "best_oa_location/source/is_oa": false,
        "best_oa_location/source/is_in_doaj": false,
        "best_oa_location/source/host_organization": "https://openalex.org/P4310311060",
        "best_oa_location/source/host_organization_name": "Charles de Gaulle University of humanities arts and social sciences",
        "best_oa_location/source/host_organization_lineage": [
            "https://openalex.org/P4310311060",
            "https://openalex.org/P4310311198"
        ],
        "best_oa_location/source/host_organization_lineage_names": [
            "Charles de Gaulle University of humanities arts and social sciences",
            "Lille North of France University"
        ],
        "best_oa_location/source/type": "journal",
        "best_oa_location/license": null,
        "best_oa_location/version": "publishedVersion",
        "best_oa_location/is_accepted": true,
        "best_oa_location/is_published": true,
        "sustainable_development_goals": [
            {
                "id": "https://metadata.un.org/sdg/4",
                "display_name": "Quality Education",
                "score": 0.34
            },
            {
                "id": "https://metadata.un.org/sdg/9",
                "display_name": "Industry, innovation and infrastructure",
                "score": 0.27
            },
            {
                "id": "https://metadata.un.org/sdg/17",
                "display_name": "Partnerships for the goals",
                "score": 0.15
            },
            {
                "id": "https://metadata.un.org/sdg/8",
                "display_name": "Decent work and economic growth",
                "score": 0.1
            }
        ],
        "grants": [],
        "referenced_works_count": 0,
        "ngrams_url": "https://api.openalex.org/works/W2995359462/ngrams",
        "cited_by_api_url": "https://api.openalex.org/works?filter=cites:W2995359462",
        "counts_by_year": [],
        "updated_date": "2023-09-26T08:50:26.105648",
        "created_date": "2019-12-26"
    }
},
{
    "id": 8,
    "value": "n/a"
}]

POST {{host}}/v1/istex/works/expand?indent=true
content-type: application/json
[
  { "id":1,   "value": "10.1016/S0047-6374(98)00099-2"},
  { "id":2,   "value": "10.1016/S0167-4943(01)00186-8"},
  { "id":3,   "value": "10.1093/ageing/afm016"},
  { "id":4,   "value": ""}
]

HTTP 200
[{
    "id": 1,
    "value": "n/a"
},
{
    "id": 2,
    "value": "n/a"
},
{
    "id": 3,
    "value": {
        "corpusName": "oup",
        "keywords/teeft": [
            "life span",
            "twin pair",
            "risk factor",
            "test score",
            "heavy alcohol",
            "control analysis",
            "zygosity",
            "standard deviation",
            "agct",
            "early adulthood",
            "cardiovascular disease",
            "longevity",
            "vascular score",
            "twin",
            "body mass index",
            "medical condition",
            "cardiovascular",
            "genetic factor",
            "national academy",
            "wwii veteran",
            "health behaviour",
            "genetic component",
            "twin registry",
            "army general test",
            "smoking history",
            "public health",
            "sage publication",
            "clin rehabil",
            "early life",
            "early life environmental factor",
            "higher score",
            "intelligence test",
            "young adulthood",
            "educational level",
            "general conclusion",
            "risk variable",
            "early life intellect",
            "intelligence scale",
            "daily consumption",
            "daily hangover",
            "intoxication daily",
            "continuous variable",
            "severe chest pain",
            "dummy variable",
            "higher intelligence",
            "vascular disease",
            "control model",
            "present study",
            "previous study",
            "physical activity",
            "prospective observational study",
            "scottish mental survey",
            "midspan study",
            "psychol bull",
            "genetic",
            "vascular"
        ],
        "subject": [
            {
                "lang": [
                    "eng"
                ],
                "value": "intelligence"
            },
            {
                "lang": [
                    "eng"
                ],
                "value": "survival"
            },
            {
                "lang": [
                    "eng"
                ],
                "value": "twins"
            },
            {
                "lang": [
                    "eng"
                ],
                "value": "risk factors"
            },
            {
                "lang": [
                    "eng"
                ],
                "value": "elderly"
            }
        ],
        "language": [
            "eng"
        ],
        "originalGenre": [
            "research-article"
        ],
        "qualityIndicators/hasStructuredBody": true,
        "qualityIndicators/teiSource": "pub2tei",
        "qualityIndicators/xmlStats/paragraphCount": 28,
        "qualityIndicators/xmlStats/sectionCount": 11,
        "qualityIndicators/xmlStats/sectionLevels": [
            {
                "sectionCount": 5,
                "level": 0
            },
            {
                "sectionCount": 6,
                "level": 1
            }
        ],
        "qualityIndicators/xmlStats/sectionDepth": 2,
        "qualityIndicators/xmlStats/imageCount": 1,
        "qualityIndicators/xmlStats/tableCount": 2,
        "qualityIndicators/xmlStats/refCount": 25,
        "qualityIndicators/tdmReady": true,
        "qualityIndicators/score": 9.143,
        "qualityIndicators/pdfWordCount": 4563,
        "qualityIndicators/pdfCharCount": 24756,
        "qualityIndicators/pdfVersion": 1.6,
        "qualityIndicators/pdfPageCount": 6,
        "qualityIndicators/pdfPageSize": "612 x 790.5 pts",
        "qualityIndicators/pdfWordsPerPage": 761,
        "qualityIndicators/pdfText": true,
        "qualityIndicators/refBibsNative": true,
        "qualityIndicators/abstractWordCount": 215,
        "qualityIndicators/abstractCharCount": 1437,
        "qualityIndicators/keywordCount": 5,
        "title": "Intelligence in early adulthood and life span up to 65 years later in male elderly twins",
        "genre": [
            "research-article"
        ],
        "host/title": "Age and Ageing",
        "host/language": [
            "unknown"
        ],
        "host/issn": [
            "0002-0729"
        ],
        "host/eissn": [
            "1468-2834"
        ],
        "host/publisherId": [
            "ageing"
        ],
        "host/volume": "36",
        "host/issue": "3",
        "host/pages/first": "286",
        "host/pages/last": "291",
        "host/genre": [
            "journal"
        ],
        "namedEntities/unitex/date": [
            "1940s",
            "1967",
            "40s"
        ],
        "namedEntities/unitex/orgName": [
            "Army General Classification Test",
            "AGCT",
            "National Academy of Sciences"
        ],
        "namedEntities/unitex/orgName_funder": [
            "NIH AG"
        ],
        "namedEntities/unitex/persName": [
            "Dr William Page",
            "Page",
            "Ms Harriet Crawford"
        ],
        "namedEntities/unitex/placeName": [
            "Durham",
            "United States",
            "NC",
            "USA"
        ],
        "ark": [
            "ark:/67375/HXZ-J1BLQKH4-3"
        ],
        "categories/wos": [
            "1 - science",
            "2 - geriatrics & gerontology"
        ],
        "categories/scienceMetrix": [
            "1 - health sciences",
            "2 - clinical medicine",
            "3 - geriatrics"
        ],
        "categories/scopus": [
            "1 - Health Sciences",
            "2 - Medicine",
            "3 - Geriatrics and Gerontology",
            "1 - Life Sciences",
            "2 - Biochemistry, Genetics and Molecular Biology",
            "3 - Ageing",
            "1 - Health Sciences",
            "2 - Medicine",
            "3 - General Medicine"
        ],
        "categories/inist": [
            "1 - sciences humaines et sociales"
        ],
        "publicationDate": "2007",
        "author": [
            {
                "name": "Tracey Holsinger",
                "affiliations": [
                    "Durham VA Medical Center, Psychiatry, Durham, NC, USA",
                    "Duke University Medical Center, Psychiatry, Durham, NC, USA",
                    "E-mail: tracey.holsinger@med.va.gov",
                    "Address correspondence to: Tracey Holsinger. Tel: (919)286-6933; Fax: (919)416-5832. Email: tracey.holsinger@med.va.gov"
                ]
            },
            {
                "name": "Michael Helms",
                "affiliations": [
                    "Duke University Medical Center, Psychiatry, Durham, NC, USA"
                ]
            },
            {
                "name": "Brenda Plassman",
                "affiliations": [
                    "Duke University Medical Center, Psychiatry, Durham, NC, USA"
                ]
            }
        ],
        "articleId": [
            "afm016"
        ],
        "accessCondition/contentType": "isOpenAccess",
        "accessCondition/value": "bronzeOpenAccess",
        "arkIstex": "ark:/67375/HXZ-J1BLQKH4-3",
        "abstract": "Background: previous research has reported that greater intelligence in early life is associated with longer lifespan. Whether this relationship is mediated by genetic factors or environmental factors, some of which could be modified by an individual, is unclear. Objective: we examined the association between intelligence test scores, obtained during the 1940s, and age at death in a group of 492 male twin pairs, members of the National Academy of Sciences - National Research Council Twins Registry of WWII veterans. Design: using self-report information collected in th 1960s, we xamined whether modifiable risk factors for mortality, such as use of tobacco and alcohol, cardiovascular disease, and body mass index altered the association between intelligence and longevity. Results: when each member of a twin pair was treated as an independent observation, higher intelligence test scores were associated with longer life span (P = 0.0002). Modifiable risk factors were associated with life span as expected. However, in co-twin control analyses in which one twin served as the control for the other twin, neither intelligence nor any modifiable risk factors showed a significant association with life span. Conclusion: our findings suggest that genetics and early life environmental factors contribute heavily to lifespan and when one controls for these factors using twins, the effect of intelligence on longevity is diminished.",
        "pmid": [
            "17374599"
        ],
        "hasFormula": false,
        "copyrightDate": "2007",
        "enrichments/grobidFulltext": [
            {
                "original": false,
                "mimetype": "application/tei+xml",
                "extension": "tei",
                "uri": "https://api.istex.fr/document/00467C66104C83EF1C8F53052CFA2F6EBF8C650A/enrichments/grobidFulltext"
            }
        ],
        "enrichments/multicat": [
            {
                "original": false,
                "mimetype": "application/tei+xml",
                "extension": "tei",
                "uri": "https://api.istex.fr/document/00467C66104C83EF1C8F53052CFA2F6EBF8C650A/enrichments/multicat"
            }
        ],
        "enrichments/nb": [
            {
                "original": false,
                "mimetype": "application/tei+xml",
                "extension": "tei",
                "uri": "https://api.istex.fr/document/00467C66104C83EF1C8F53052CFA2F6EBF8C650A/enrichments/nb"
            }
        ],
        "enrichments/refBibs": [
            {
                "original": false,
                "mimetype": "application/tei+xml",
                "extension": "tei",
                "uri": "https://api.istex.fr/document/00467C66104C83EF1C8F53052CFA2F6EBF8C650A/enrichments/refBibs"
            }
        ],
        "enrichments/teeft": [
            {
                "original": false,
                "mimetype": "application/tei+xml",
                "extension": "tei",
                "uri": "https://api.istex.fr/document/00467C66104C83EF1C8F53052CFA2F6EBF8C650A/enrichments/teeft"
            }
        ],
        "enrichments/unitex": [
            {
                "original": false,
                "mimetype": "application/tei+xml",
                "extension": "tei",
                "uri": "https://api.istex.fr/document/00467C66104C83EF1C8F53052CFA2F6EBF8C650A/enrichments/unitex"
            }
        ],
        "doi": [
            "10.1093/ageing/afm016"
        ],
        "id": "00467C66104C83EF1C8F53052CFA2F6EBF8C650A",
        "score": 113.961525,
        "serie": {}
    }
},
{
    "id": 4,
    "value": "n/a"
}]

POST {{host}}/v1/wos/fetch?indent=true
content-type: application/json
[
  {
    "query": "0",
    "value": "XX"
  },
  {
    "query" :"I",
    "value": {
      "databaseId": "WOK",
      "usrQuery": "TS=(cadmium)",
      "count": "5",
      "firstRecord": "1"
    }
  },
  {
    "query" :"II",
    "value": {
      "databaseId": "WOK",
      "usrQuery": "TS=(cadmium)",
      "count": "5",
      "firstRecord": "6"
    }
  }
]



POST {{host}}/v1/wos/works/expand?indent=true
content-type: application/json
[
  { "id":1,   "value": "10.1016/S0047-6374(98)00099-2"},
  { "id":2,   "value": "10.1016/S0167-4943(01)00186-8"},
  { "id":3,   "value": "10.1093/ageing/afm016"},
  { "id":4,   "value": ""}
]

HTTP 200
[{
    "id": 1,
    "value": "n/a"
},
{
    "id": 2,
    "value": "n/a"
},
{
    "id": 3,
    "value": "n/a"
},
{
    "id": 4,
    "value": "n/a"
}]

POST {{host}}/v1/hal/works/expand?indent=true
content-type: application/json
[
  { "id":1,   "value": "10.1016/S0047-6374(98)00099-2"},
  { "id":2,   "value": "10.35562/arabesques.1222"},
  { "id":3,   "value": "10.3324/haematol.2016.148908"},
  { "id":4,   "value": ""}
]

HTTP 200
[{
    "id": 1,
    "value": "n/a"
},
{
    "id": 2,
    "value": {
        "xmlns": "http://www.tei-c.org/ns/1.0",
        "xmlns_xsi": "http://www.w3.org/2001/XMLSchema-instance",
        "xmlns_hal": "http://hal.archives-ouvertes.fr/",
        "version": "1.1",
        "xsi_schemaLocation": "http://www.tei-c.org/ns/1.0 http://api.archives-ouvertes.fr/documents/aofr-sword.xsd",
        "teiHeader": {
            "fileDesc": {
                "titleStmt": {
                    "title": {
                        "_t": "HAL TEI export of hal-03008165"
                    }
                },
                "publicationStmt": {
                    "distributor": {
                        "_t": "CCSD"
                    },
                    "availability": {
                        "status": "restricted",
                        "licence": {
                            "target": "http://creativecommons.org/licenses/by/",
                            "_t": "Attribution"
                        }
                    },
                    "date": {
                        "when": "2023-08-26T21:36:43+02:00"
                    }
                },
                "sourceDesc": {
                    "p": {
                        "part": "N",
                        "_t": "HAL API platform"
                    }
                }
            }
        },
        "text": {
            "body": {
                "listBibl": {
                    "biblFull": {
                        "titleStmt": {
                            "title": {
                                "xml_lang": "fr",
                                "_t": "ISTEX : une nouvelle corde à son ARK"
                            },
                            "author": [
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Pascale"
                                        },
                                        "surname": {
                                            "_t": "Viot"
                                        }
                                    },
                                    "email": [
                                        {
                                            "type": "md5",
                                            "_t": "79a26549e263f0a1f5ef387021a5c123"
                                        },
                                        {
                                            "type": "domain",
                                            "_t": "inist.fr"
                                        }
                                    ],
                                    "idno": [
                                        {
                                            "type": "idhal",
                                            "notation": "numeric",
                                            "_t": "1081692"
                                        },
                                        {
                                            "type": "halauthorid",
                                            "notation": "string",
                                            "_t": "2072198-1081692"
                                        }
                                    ],
                                    "affiliation": {
                                        "ref": "#struct-1814"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Nicolas"
                                        },
                                        "surname": {
                                            "_t": "Thouvenin"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "541308-0"
                                    },
                                    "affiliation": {
                                        "ref": "#struct-1814"
                                    }
                                }
                            ],
                            "editor": {
                                "role": "depositor",
                                "persName": {
                                    "forename": {
                                        "_t": "Pascale"
                                    },
                                    "surname": {
                                        "_t": "Viot"
                                    }
                                },
                                "email": [
                                    {
                                        "type": "md5",
                                        "_t": "79a26549e263f0a1f5ef387021a5c123"
                                    },
                                    {
                                        "type": "domain",
                                        "_t": "inist.fr"
                                    }
                                ]
                            }
                        },
                        "editionStmt": {
                            "edition": {
                                "n": "v1",
                                "type": "current",
                                "date": [
                                    {
                                        "type": "whenSubmitted",
                                        "_t": "2020-11-16 16:31:06"
                                    },
                                    {
                                        "type": "whenModified",
                                        "_t": "2023-03-24 14:53:19"
                                    },
                                    {
                                        "type": "whenReleased",
                                        "_t": "2020-11-16 17:07:43"
                                    },
                                    {
                                        "type": "whenProduced",
                                        "_t": "2018-01"
                                    },
                                    {
                                        "type": "whenEndEmbargoed",
                                        "_t": "2020-11-16"
                                    }
                                ],
                                "ref": [
                                    {
                                        "type": "file",
                                        "target": "https://cnrs.hal.science/hal-03008165/document",
                                        "date": {
                                            "notBefore": "2020-11-16"
                                        }
                                    },
                                    {
                                        "type": "file",
                                        "subtype": "greenPublisher",
                                        "n": "1",
                                        "target": "https://cnrs.hal.science/hal-03008165/file/arabesque_88_18_viot.pdf",
                                        "date": {
                                            "notBefore": "2020-11-16"
                                        }
                                    }
                                ]
                            },
                            "respStmt": {
                                "resp": {
                                    "_t": "contributor"
                                },
                                "name": {
                                    "key": "87983",
                                    "persName": {
                                        "forename": {
                                            "_t": "Pascale"
                                        },
                                        "surname": {
                                            "_t": "Viot"
                                        }
                                    },
                                    "email": [
                                        {
                                            "type": "md5",
                                            "_t": "79a26549e263f0a1f5ef387021a5c123"
                                        },
                                        {
                                            "type": "domain",
                                            "_t": "inist.fr"
                                        }
                                    ]
                                }
                            }
                        },
                        "publicationStmt": {
                            "distributor": {
                                "_t": "CCSD"
                            },
                            "idno": [
                                {
                                    "type": "halId",
                                    "_t": "hal-03008165"
                                },
                                {
                                    "type": "halUri",
                                    "_t": "https://cnrs.hal.science/hal-03008165"
                                },
                                {
                                    "type": "halBibtex",
                                    "_t": "viot:hal-03008165"
                                },
                                {
                                    "type": "halRefHtml",
                                    "_t": "<i>Arabesques</i>, 2018, L’écosystème des ressources continues, 88, pp.18-19. <a target=\"_blank\" href=\"https://dx.doi.org/10.35562/arabesques.1222\">&#x27E8;10.35562/arabesques.1222&#x27E9;</a>"
                                },
                                {
                                    "type": "halRef",
                                    "_t": "Arabesques, 2018, L’écosystème des ressources continues, 88, pp.18-19. &#x27E8;10.35562/arabesques.1222&#x27E9;"
                                }
                            ],
                            "availability": {
                                "status": "restricted",
                                "licence": {
                                    "target": "http://creativecommons.org/licenses/by/",
                                    "_t": "Attribution"
                                }
                            }
                        },
                        "seriesStmt": {
                            "idno": [
                                {
                                    "type": "stamp",
                                    "n": "SHS",
                                    "_t": "Sciences de l'Homme et de la Société"
                                },
                                {
                                    "type": "stamp",
                                    "n": "CNRS",
                                    "_t": "CNRS - Centre national de la recherche scientifique"
                                },
                                {
                                    "type": "stamp",
                                    "n": "INIST",
                                    "_t": "Institut de l'Information Scientifique et Technique"
                                },
                                {
                                    "type": "stamp",
                                    "n": "INTERNE-HALCNRS",
                                    "_t": "INTERNE-HALCNRS"
                                }
                            ]
                        },
                        "notesStmt": {
                            "note": [
                                {
                                    "type": "audience",
                                    "n": "2",
                                    "_t": "International"
                                },
                                {
                                    "type": "popular",
                                    "n": "0",
                                    "_t": "No"
                                },
                                {
                                    "type": "peer",
                                    "n": "1",
                                    "_t": "Yes"
                                }
                            ]
                        },
                        "sourceDesc": {
                            "biblStruct": {
                                "analytic": {
                                    "title": {
                                        "xml_lang": "fr",
                                        "_t": "ISTEX : une nouvelle corde à son ARK"
                                    },
                                    "author": [
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Pascale"
                                                },
                                                "surname": {
                                                    "_t": "Viot"
                                                }
                                            },
                                            "email": [
                                                {
                                                    "type": "md5",
                                                    "_t": "79a26549e263f0a1f5ef387021a5c123"
                                                },
                                                {
                                                    "type": "domain",
                                                    "_t": "inist.fr"
                                                }
                                            ],
                                            "idno": [
                                                {
                                                    "type": "idhal",
                                                    "notation": "numeric",
                                                    "_t": "1081692"
                                                },
                                                {
                                                    "type": "halauthorid",
                                                    "notation": "string",
                                                    "_t": "2072198-1081692"
                                                }
                                            ],
                                            "affiliation": {
                                                "ref": "#struct-1814"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Nicolas"
                                                },
                                                "surname": {
                                                    "_t": "Thouvenin"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "541308-0"
                                            },
                                            "affiliation": {
                                                "ref": "#struct-1814"
                                            }
                                        }
                                    ]
                                },
                                "monogr": {
                                    "idno": [
                                        {
                                            "type": "halJournalId",
                                            "status": "VALID",
                                            "_t": "40971"
                                        },
                                        {
                                            "type": "issn",
                                            "_t": "1269-0589"
                                        }
                                    ],
                                    "title": {
                                        "level": "j",
                                        "_t": "Arabesques"
                                    },
                                    "imprint": {
                                        "publisher": {
                                            "_t": "ABES"
                                        },
                                        "biblScope": [
                                            {
                                                "unit": "serie",
                                                "_t": "L’écosystème des ressources continues"
                                            },
                                            {
                                                "unit": "issue",
                                                "_t": "88"
                                            },
                                            {
                                                "unit": "pp",
                                                "_t": "18-19"
                                            }
                                        ],
                                        "date": {
                                            "type": "datePub",
                                            "_t": "2018-01"
                                        }
                                    }
                                },
                                "idno": {
                                    "type": "doi",
                                    "_t": "10.35562/arabesques.1222"
                                },
                                "ref": {
                                    "type": "publisher",
                                    "_t": "https://publications-prairial.fr/arabesques/index.php?id=1181"
                                }
                            }
                        },
                        "profileDesc": {
                            "langUsage": {
                                "language": {
                                    "ident": "fr",
                                    "_t": "French"
                                }
                            },
                            "textClass": {
                                "classCode": [
                                    {
                                        "scheme": "halDomain",
                                        "n": "shs.info",
                                        "_t": "Humanities and Social Sciences/Library and information sciences"
                                    },
                                    {
                                        "scheme": "halTypology",
                                        "n": "ART",
                                        "_t": "Journal articles"
                                    },
                                    {
                                        "scheme": "halOldTypology",
                                        "n": "ART",
                                        "_t": "Journal articles"
                                    },
                                    {
                                        "scheme": "halTreeTypology",
                                        "n": "ART",
                                        "_t": "Journal articles"
                                    }
                                ]
                            },
                            "abstract": {
                                "xml_lang": "fr",
                                "p": {
                                    "_t": "Les documents issus des bouquets acquis dans le cadre des négociations ISTEX et disponibles sur la plateforme possèdent un identifiant technique interne de 40 caractères, l’ID ISTEX. Ils ont été enrichis depuis peu par un nouvel identifiant normé, pérenne, gratuit et distribué : l’ARK."
                                }
                            }
                        }
                    }
                }
            },
            "back": {
                "listOrg": {
                    "type": "structures",
                    "org": [
                        {
                            "type": "laboratory",
                            "xml_id": "struct-1814",
                            "status": "VALID",
                            "orgName": [
                                {
                                    "_t": "Institut de l'information scientifique et technique"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "INIST"
                                }
                            ],
                            "date": {
                                "type": "start",
                                "_t": "1988-03-15"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "2 rue Jean Zay CS 10310 F-54519 Vandoeuvre-lès-Nancy"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://www.inist.fr"
                                }
                            },
                            "listRelation": {
                                "relation": {
                                    "name": "UAR76 / UPS76",
                                    "active": "#struct-441569",
                                    "type": "direct"
                                }
                            }
                        },
                        {
                            "type": "regroupinstitution",
                            "xml_id": "struct-441569",
                            "status": "VALID",
                            "idno": [
                                {
                                    "type": "IdRef",
                                    "_t": "02636817X"
                                },
                                {
                                    "type": "ISNI",
                                    "_t": "0000000122597504"
                                },
                                {
                                    "type": "ROR",
                                    "_t": "https://ror.org/02feahw73"
                                }
                            ],
                            "orgName": [
                                {
                                    "_t": "Centre National de la Recherche Scientifique"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "CNRS"
                                }
                            ],
                            "date": {
                                "type": "start",
                                "_t": "1939-10-19"
                            },
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "https://www.cnrs.fr/"
                                }
                            }
                        }
                    ]
                }
            }
        }
    }
},
{
    "id": 3,
    "value": {
        "xmlns": "http://www.tei-c.org/ns/1.0",
        "xmlns_xsi": "http://www.w3.org/2001/XMLSchema-instance",
        "xmlns_hal": "http://hal.archives-ouvertes.fr/",
        "version": "1.1",
        "xsi_schemaLocation": "http://www.tei-c.org/ns/1.0 http://api.archives-ouvertes.fr/documents/aofr-sword.xsd",
        "teiHeader": {
            "fileDesc": {
                "titleStmt": {
                    "title": {
                        "_t": "HAL TEI export of hal-01482380"
                    }
                },
                "publicationStmt": {
                    "distributor": {
                        "_t": "CCSD"
                    },
                    "availability": {
                        "status": "restricted",
                        "licence": {
                            "target": "http://creativecommons.org/licenses/by/4.0/",
                            "_t": "Distributed under a Creative Commons Attribution 4.0 International License"
                        }
                    },
                    "date": {
                        "when": "2023-09-28T03:35:43+02:00"
                    }
                },
                "sourceDesc": {
                    "p": {
                        "part": "N",
                        "_t": "HAL API platform"
                    }
                }
            }
        },
        "text": {
            "body": {
                "listBibl": {
                    "biblFull": {
                        "titleStmt": {
                            "title": {
                                "xml_lang": "en",
                                "_t": "Metabolic syndrome in long-term survivors of childhood acute leukemia ă treated without hematopoietic stem cell transplantation: an LEA study"
                            },
                            "author": [
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Marie-Dominique"
                                        },
                                        "surname": {
                                            "_t": "Tabone"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "240890-0"
                                    },
                                    "affiliation": {
                                        "ref": "#struct-360410"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Jean-Hugues"
                                        },
                                        "surname": {
                                            "_t": "Dalle"
                                        }
                                    },
                                    "idno": [
                                        {
                                            "type": "idhal",
                                            "notation": "numeric",
                                            "_t": "767006"
                                        },
                                        {
                                            "type": "halauthorid",
                                            "notation": "string",
                                            "_t": "663506-767006"
                                        },
                                        {
                                            "type": "ORCID",
                                            "_t": "https://orcid.org/0000-0002-8406-0793"
                                        }
                                    ],
                                    "affiliation": {
                                        "ref": "#struct-116327"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Patrick"
                                        },
                                        "surname": {
                                            "_t": "Lutz"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "154937-0"
                                    },
                                    "affiliation": {
                                        "ref": "#struct-406979"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Virginie"
                                        },
                                        "surname": {
                                            "_t": "Gandemer"
                                        }
                                    },
                                    "idno": [
                                        {
                                            "type": "idhal",
                                            "notation": "numeric",
                                            "_t": "756758"
                                        },
                                        {
                                            "type": "halauthorid",
                                            "notation": "string",
                                            "_t": "154936-756758"
                                        },
                                        {
                                            "type": "ORCID",
                                            "_t": "https://orcid.org/0000-0002-4991-233X"
                                        }
                                    ],
                                    "affiliation": [
                                        {
                                            "ref": "#struct-187162"
                                        },
                                        {
                                            "ref": "#struct-301327"
                                        }
                                    ]
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Nicolas Sir"
                                        },
                                        "surname": {
                                            "_t": "Vent"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "1143975-0"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Sandrine"
                                        },
                                        "surname": {
                                            "_t": "Thouvenin"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "1054847-0"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Julie"
                                        },
                                        "surname": {
                                            "_t": "Berbis"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "781452-0"
                                    },
                                    "affiliation": {
                                        "ref": "#struct-233198"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Hervé"
                                        },
                                        "surname": {
                                            "_t": "Chambost"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "702151-0"
                                    },
                                    "affiliation": {
                                        "ref": "#struct-541105"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "André"
                                        },
                                        "surname": {
                                            "_t": "Baruchel"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "153756-0"
                                    },
                                    "affiliation": {
                                        "ref": "#struct-17849"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Guy"
                                        },
                                        "surname": {
                                            "_t": "Leverger"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "153758-0"
                                    },
                                    "affiliation": {
                                        "ref": "#struct-183200"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Gérard"
                                        },
                                        "surname": {
                                            "_t": "Michel"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "197336-0"
                                    },
                                    "affiliation": {
                                        "ref": "#struct-458700"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Paul"
                                        },
                                        "surname": {
                                            "_t": "Saultier"
                                        }
                                    },
                                    "idno": [
                                        {
                                            "type": "idhal",
                                            "notation": "numeric",
                                            "_t": "780499"
                                        },
                                        {
                                            "type": "halauthorid",
                                            "notation": "string",
                                            "_t": "1109829-780499"
                                        },
                                        {
                                            "type": "ORCID",
                                            "_t": "https://orcid.org/0000-0002-6327-0898"
                                        }
                                    ],
                                    "affiliation": {
                                        "ref": "#struct-180118"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Pascal"
                                        },
                                        "surname": {
                                            "_t": "Auquier"
                                        }
                                    },
                                    "email": [
                                        {
                                            "type": "md5",
                                            "_t": "27168e5662f8ad424133c0532e48ff6d"
                                        },
                                        {
                                            "type": "domain",
                                            "_t": "univ-amu.fr"
                                        }
                                    ],
                                    "idno": [
                                        {
                                            "type": "idhal",
                                            "notation": "numeric",
                                            "_t": "860193"
                                        },
                                        {
                                            "type": "halauthorid",
                                            "notation": "string",
                                            "_t": "392290-860193"
                                        }
                                    ],
                                    "affiliation": {
                                        "ref": "#struct-233198"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Yves"
                                        },
                                        "surname": {
                                            "_t": "Bertrand"
                                        }
                                    },
                                    "email": [
                                        {
                                            "type": "md5",
                                            "_t": "854a7b6d562b3738ccb5cc74e40d6dbd"
                                        },
                                        {
                                            "type": "domain",
                                            "_t": "univ-poitiers.fr"
                                        }
                                    ],
                                    "idno": [
                                        {
                                            "type": "idhal",
                                            "notation": "numeric",
                                            "_t": "854932"
                                        },
                                        {
                                            "type": "halauthorid",
                                            "notation": "string",
                                            "_t": "2525267-854932"
                                        }
                                    ],
                                    "affiliation": {
                                        "ref": "#struct-216005"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Camille"
                                        },
                                        "surname": {
                                            "_t": "Vercasson"
                                        }
                                    },
                                    "idno": [
                                        {
                                            "type": "idhal",
                                            "notation": "numeric",
                                            "_t": "775289"
                                        },
                                        {
                                            "type": "halauthorid",
                                            "notation": "string",
                                            "_t": "955663-775289"
                                        },
                                        {
                                            "type": "ORCID",
                                            "_t": "https://orcid.org/0000-0002-7735-2974"
                                        }
                                    ],
                                    "affiliation": {
                                        "ref": "#struct-233198"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Claire"
                                        },
                                        "surname": {
                                            "_t": "Oudin"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "669929-0"
                                    },
                                    "affiliation": {
                                        "ref": "#struct-104634"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Audrey"
                                        },
                                        "surname": {
                                            "_t": "Contet"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "679552-0"
                                    },
                                    "affiliation": {
                                        "ref": "#struct-116528"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Dominique"
                                        },
                                        "surname": {
                                            "_t": "Plantaz"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "317747-0"
                                    },
                                    "affiliation": {
                                        "ref": "#struct-89817"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Marilyne"
                                        },
                                        "surname": {
                                            "_t": "Poiree"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "1143976-0"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Stéphane"
                                        },
                                        "surname": {
                                            "_t": "Ducassou"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "679542-0"
                                    },
                                    "affiliation": {
                                        "ref": "#struct-31375"
                                    }
                                },
                                {
                                    "role": "aut",
                                    "persName": {
                                        "forename": {
                                            "type": "first",
                                            "_t": "Justyna"
                                        },
                                        "surname": {
                                            "_t": "Kanold"
                                        }
                                    },
                                    "idno": {
                                        "type": "halauthorid",
                                        "_t": "303822-0"
                                    },
                                    "affiliation": {
                                        "ref": "#struct-439023"
                                    }
                                }
                            ],
                            "editor": {
                                "role": "depositor",
                                "persName": {
                                    "forename": {
                                        "_t": "Pascal"
                                    },
                                    "surname": {
                                        "_t": "Auquier"
                                    }
                                },
                                "email": [
                                    {
                                        "type": "md5",
                                        "_t": "27168e5662f8ad424133c0532e48ff6d"
                                    },
                                    {
                                        "type": "domain",
                                        "_t": "univ-amu.fr"
                                    }
                                ]
                            }
                        },
                        "editionStmt": {
                            "edition": {
                                "n": "v1",
                                "type": "current",
                                "date": [
                                    {
                                        "type": "whenSubmitted",
                                        "_t": "2017-03-03 15:16:20"
                                    },
                                    {
                                        "type": "whenModified",
                                        "_t": "2023-09-28 03:34:33"
                                    },
                                    {
                                        "type": "whenReleased",
                                        "_t": "2017-03-03 15:16:20"
                                    },
                                    {
                                        "type": "whenProduced",
                                        "_t": "2016-12"
                                    }
                                ],
                                "ref": {
                                    "type": "externalLink",
                                    "target": "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5479621"
                                }
                            },
                            "respStmt": {
                                "resp": {
                                    "_t": "contributor"
                                },
                                "name": {
                                    "key": "85327",
                                    "persName": {
                                        "forename": {
                                            "_t": "Pascal"
                                        },
                                        "surname": {
                                            "_t": "Auquier"
                                        }
                                    },
                                    "email": [
                                        {
                                            "type": "md5",
                                            "_t": "27168e5662f8ad424133c0532e48ff6d"
                                        },
                                        {
                                            "type": "domain",
                                            "_t": "univ-amu.fr"
                                        }
                                    ]
                                }
                            }
                        },
                        "publicationStmt": {
                            "distributor": {
                                "_t": "CCSD"
                            },
                            "idno": [
                                {
                                    "type": "halId",
                                    "_t": "hal-01482380"
                                },
                                {
                                    "type": "halUri",
                                    "_t": "https://hal.science/hal-01482380"
                                },
                                {
                                    "type": "halBibtex",
                                    "_t": "tabone:hal-01482380"
                                },
                                {
                                    "type": "halRefHtml",
                                    "_t": "<i>Haematologica</i>, 2016, 101 (12), pp.1603-1610. <a target=\"_blank\" href=\"https://dx.doi.org/10.3324/haematol.2016.148908\">&#x27E8;10.3324/haematol.2016.148908&#x27E9;</a>"
                                },
                                {
                                    "type": "halRef",
                                    "_t": "Haematologica, 2016, 101 (12), pp.1603-1610. &#x27E8;10.3324/haematol.2016.148908&#x27E9;"
                                }
                            ]
                        },
                        "seriesStmt": {
                            "idno": [
                                {
                                    "type": "stamp",
                                    "n": "SHS",
                                    "_t": "Sciences de l'Homme et de la Société"
                                },
                                {
                                    "type": "stamp",
                                    "n": "UNIV-PARIS7",
                                    "corresp": "UNIV-PARIS",
                                    "_t": "Université Denis Diderot - Paris VII"
                                },
                                {
                                    "type": "stamp",
                                    "n": "HCL",
                                    "_t": "Hospices Civils de Lyon"
                                },
                                {
                                    "type": "stamp",
                                    "n": "UNIV-RENNES1",
                                    "_t": "Université de Rennes 1"
                                },
                                {
                                    "type": "stamp",
                                    "n": "CNRS",
                                    "_t": "CNRS - Centre national de la recherche scientifique"
                                },
                                {
                                    "type": "stamp",
                                    "n": "UNIV-AMU",
                                    "_t": "Aix Marseille Université"
                                },
                                {
                                    "type": "stamp",
                                    "n": "INRA",
                                    "_t": "INRA - Institut national de la recherche agronomique"
                                },
                                {
                                    "type": "stamp",
                                    "n": "APHP",
                                    "corresp": "INSERM",
                                    "_t": "AP-HP"
                                },
                                {
                                    "type": "stamp",
                                    "n": "AO-ECONOMIE",
                                    "_t": "Archives ouvertes de l'Economie"
                                },
                                {
                                    "type": "stamp",
                                    "n": "SANTE_PUB_INSERM",
                                    "corresp": "INSERM",
                                    "_t": "Santé Publique à l'Inserm"
                                },
                                {
                                    "type": "stamp",
                                    "n": "IFR140",
                                    "_t": "SFR Biosit - Biologie et Santé CNRS UMS 3480"
                                },
                                {
                                    "type": "stamp",
                                    "n": "HL",
                                    "_t": "Publications CHU - Rennes 1"
                                },
                                {
                                    "type": "stamp",
                                    "n": "IGDR-EGO",
                                    "corresp": "IGDR",
                                    "_t": "Expression des gènes et oncogenèse"
                                },
                                {
                                    "type": "stamp",
                                    "n": "UNIV-LORRAINE",
                                    "_t": "Université de Lorraine"
                                },
                                {
                                    "type": "stamp",
                                    "n": "UR1-HAL",
                                    "_t": "Publications labos UR1 dans HAL-Rennes 1"
                                },
                                {
                                    "type": "stamp",
                                    "n": "USPC",
                                    "_t": "Université Sorbonne Paris Cité"
                                },
                                {
                                    "type": "stamp",
                                    "n": "AGREENIUM",
                                    "_t": "Archive ouverte en agrobiosciences"
                                },
                                {
                                    "type": "stamp",
                                    "n": "TEST-UNIV-RENNES",
                                    "_t": "TEST Université de Rennes"
                                },
                                {
                                    "type": "stamp",
                                    "n": "TEST-UR-CSS",
                                    "_t": "TEST Université de Rennes CSS"
                                },
                                {
                                    "type": "stamp",
                                    "n": "UNIV-RENNES",
                                    "_t": "Université de Rennes"
                                },
                                {
                                    "type": "stamp",
                                    "n": "SORBONNE-UNIVERSITE",
                                    "_t": "Sorbonne Université"
                                },
                                {
                                    "type": "stamp",
                                    "n": "SU-INF-2018",
                                    "corresp": "SORBONNE-UNIVERSITE",
                                    "_t": "SORBONNE université <2018"
                                },
                                {
                                    "type": "stamp",
                                    "n": "SU-MEDECINE",
                                    "corresp": "SORBONNE-UNIVERSITE",
                                    "_t": "Faculté de Médecine de Sorbonne Université"
                                },
                                {
                                    "type": "stamp",
                                    "n": "SU-MED",
                                    "corresp": "SORBONNE-UNIVERSITE",
                                    "_t": "Médecine - Sorbonne Université"
                                },
                                {
                                    "type": "stamp",
                                    "n": "CHU-CLERMONTFERRAND",
                                    "_t": "CHU DE CLERMONT FERRAND"
                                },
                                {
                                    "type": "stamp",
                                    "n": "INRAE",
                                    "_t": "Institut National de Recherche en Agriculture, Alimentation et Environnement"
                                },
                                {
                                    "type": "stamp",
                                    "n": "UNIV-PARIS",
                                    "_t": "Université Paris Cité"
                                },
                                {
                                    "type": "stamp",
                                    "n": "SU-TI",
                                    "_t": "Sorbonne Université - Texte Intégral"
                                },
                                {
                                    "type": "stamp",
                                    "n": "ALLIANCE-SU",
                                    "_t": "Alliance Sorbonne Université"
                                },
                                {
                                    "type": "stamp",
                                    "n": "BGC",
                                    "corresp": "IGDR",
                                    "_t": "Biologie et génétique du cancer"
                                }
                            ]
                        },
                        "notesStmt": {
                            "note": [
                                {
                                    "type": "audience",
                                    "n": "2",
                                    "_t": "International"
                                },
                                {
                                    "type": "popular",
                                    "n": "0",
                                    "_t": "No"
                                },
                                {
                                    "type": "peer",
                                    "n": "1",
                                    "_t": "Yes"
                                }
                            ]
                        },
                        "sourceDesc": {
                            "biblStruct": {
                                "analytic": {
                                    "title": {
                                        "xml_lang": "en",
                                        "_t": "Metabolic syndrome in long-term survivors of childhood acute leukemia ă treated without hematopoietic stem cell transplantation: an LEA study"
                                    },
                                    "author": [
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Marie-Dominique"
                                                },
                                                "surname": {
                                                    "_t": "Tabone"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "240890-0"
                                            },
                                            "affiliation": {
                                                "ref": "#struct-360410"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Jean-Hugues"
                                                },
                                                "surname": {
                                                    "_t": "Dalle"
                                                }
                                            },
                                            "idno": [
                                                {
                                                    "type": "idhal",
                                                    "notation": "numeric",
                                                    "_t": "767006"
                                                },
                                                {
                                                    "type": "halauthorid",
                                                    "notation": "string",
                                                    "_t": "663506-767006"
                                                },
                                                {
                                                    "type": "ORCID",
                                                    "_t": "https://orcid.org/0000-0002-8406-0793"
                                                }
                                            ],
                                            "affiliation": {
                                                "ref": "#struct-116327"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Patrick"
                                                },
                                                "surname": {
                                                    "_t": "Lutz"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "154937-0"
                                            },
                                            "affiliation": {
                                                "ref": "#struct-406979"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Virginie"
                                                },
                                                "surname": {
                                                    "_t": "Gandemer"
                                                }
                                            },
                                            "idno": [
                                                {
                                                    "type": "idhal",
                                                    "notation": "numeric",
                                                    "_t": "756758"
                                                },
                                                {
                                                    "type": "halauthorid",
                                                    "notation": "string",
                                                    "_t": "154936-756758"
                                                },
                                                {
                                                    "type": "ORCID",
                                                    "_t": "https://orcid.org/0000-0002-4991-233X"
                                                }
                                            ],
                                            "affiliation": [
                                                {
                                                    "ref": "#struct-187162"
                                                },
                                                {
                                                    "ref": "#struct-301327"
                                                }
                                            ]
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Nicolas Sir"
                                                },
                                                "surname": {
                                                    "_t": "Vent"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "1143975-0"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Sandrine"
                                                },
                                                "surname": {
                                                    "_t": "Thouvenin"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "1054847-0"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Julie"
                                                },
                                                "surname": {
                                                    "_t": "Berbis"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "781452-0"
                                            },
                                            "affiliation": {
                                                "ref": "#struct-233198"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Hervé"
                                                },
                                                "surname": {
                                                    "_t": "Chambost"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "702151-0"
                                            },
                                            "affiliation": {
                                                "ref": "#struct-541105"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "André"
                                                },
                                                "surname": {
                                                    "_t": "Baruchel"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "153756-0"
                                            },
                                            "affiliation": {
                                                "ref": "#struct-17849"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Guy"
                                                },
                                                "surname": {
                                                    "_t": "Leverger"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "153758-0"
                                            },
                                            "affiliation": {
                                                "ref": "#struct-183200"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Gérard"
                                                },
                                                "surname": {
                                                    "_t": "Michel"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "197336-0"
                                            },
                                            "affiliation": {
                                                "ref": "#struct-458700"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Paul"
                                                },
                                                "surname": {
                                                    "_t": "Saultier"
                                                }
                                            },
                                            "idno": [
                                                {
                                                    "type": "idhal",
                                                    "notation": "numeric",
                                                    "_t": "780499"
                                                },
                                                {
                                                    "type": "halauthorid",
                                                    "notation": "string",
                                                    "_t": "1109829-780499"
                                                },
                                                {
                                                    "type": "ORCID",
                                                    "_t": "https://orcid.org/0000-0002-6327-0898"
                                                }
                                            ],
                                            "affiliation": {
                                                "ref": "#struct-180118"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Pascal"
                                                },
                                                "surname": {
                                                    "_t": "Auquier"
                                                }
                                            },
                                            "email": [
                                                {
                                                    "type": "md5",
                                                    "_t": "27168e5662f8ad424133c0532e48ff6d"
                                                },
                                                {
                                                    "type": "domain",
                                                    "_t": "univ-amu.fr"
                                                }
                                            ],
                                            "idno": [
                                                {
                                                    "type": "idhal",
                                                    "notation": "numeric",
                                                    "_t": "860193"
                                                },
                                                {
                                                    "type": "halauthorid",
                                                    "notation": "string",
                                                    "_t": "392290-860193"
                                                }
                                            ],
                                            "affiliation": {
                                                "ref": "#struct-233198"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Yves"
                                                },
                                                "surname": {
                                                    "_t": "Bertrand"
                                                }
                                            },
                                            "email": [
                                                {
                                                    "type": "md5",
                                                    "_t": "854a7b6d562b3738ccb5cc74e40d6dbd"
                                                },
                                                {
                                                    "type": "domain",
                                                    "_t": "univ-poitiers.fr"
                                                }
                                            ],
                                            "idno": [
                                                {
                                                    "type": "idhal",
                                                    "notation": "numeric",
                                                    "_t": "854932"
                                                },
                                                {
                                                    "type": "halauthorid",
                                                    "notation": "string",
                                                    "_t": "2525267-854932"
                                                }
                                            ],
                                            "affiliation": {
                                                "ref": "#struct-216005"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Camille"
                                                },
                                                "surname": {
                                                    "_t": "Vercasson"
                                                }
                                            },
                                            "idno": [
                                                {
                                                    "type": "idhal",
                                                    "notation": "numeric",
                                                    "_t": "775289"
                                                },
                                                {
                                                    "type": "halauthorid",
                                                    "notation": "string",
                                                    "_t": "955663-775289"
                                                },
                                                {
                                                    "type": "ORCID",
                                                    "_t": "https://orcid.org/0000-0002-7735-2974"
                                                }
                                            ],
                                            "affiliation": {
                                                "ref": "#struct-233198"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Claire"
                                                },
                                                "surname": {
                                                    "_t": "Oudin"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "669929-0"
                                            },
                                            "affiliation": {
                                                "ref": "#struct-104634"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Audrey"
                                                },
                                                "surname": {
                                                    "_t": "Contet"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "679552-0"
                                            },
                                            "affiliation": {
                                                "ref": "#struct-116528"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Dominique"
                                                },
                                                "surname": {
                                                    "_t": "Plantaz"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "317747-0"
                                            },
                                            "affiliation": {
                                                "ref": "#struct-89817"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Marilyne"
                                                },
                                                "surname": {
                                                    "_t": "Poiree"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "1143976-0"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Stéphane"
                                                },
                                                "surname": {
                                                    "_t": "Ducassou"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "679542-0"
                                            },
                                            "affiliation": {
                                                "ref": "#struct-31375"
                                            }
                                        },
                                        {
                                            "role": "aut",
                                            "persName": {
                                                "forename": {
                                                    "type": "first",
                                                    "_t": "Justyna"
                                                },
                                                "surname": {
                                                    "_t": "Kanold"
                                                }
                                            },
                                            "idno": {
                                                "type": "halauthorid",
                                                "_t": "303822-0"
                                            },
                                            "affiliation": {
                                                "ref": "#struct-439023"
                                            }
                                        }
                                    ]
                                },
                                "monogr": {
                                    "idno": [
                                        {
                                            "type": "halJournalId",
                                            "status": "VALID",
                                            "_t": "22186"
                                        },
                                        {
                                            "type": "issn",
                                            "_t": "0390-6078"
                                        },
                                        {
                                            "type": "eissn",
                                            "_t": "1592-8721"
                                        }
                                    ],
                                    "title": {
                                        "level": "j",
                                        "_t": "Haematologica"
                                    },
                                    "imprint": {
                                        "publisher": {
                                            "_t": "Ferrata Storti Foundation"
                                        },
                                        "biblScope": [
                                            {
                                                "unit": "volume",
                                                "_t": "101"
                                            },
                                            {
                                                "unit": "issue",
                                                "_t": "12"
                                            },
                                            {
                                                "unit": "pp",
                                                "_t": "1603-1610"
                                            }
                                        ],
                                        "date": {
                                            "type": "datePub",
                                            "_t": "2016-12"
                                        }
                                    }
                                },
                                "idno": [
                                    {
                                        "type": "doi",
                                        "_t": "10.3324/haematol.2016.148908"
                                    },
                                    {
                                        "type": "pubmed",
                                        "_t": "27515247"
                                    }
                                ]
                            }
                        },
                        "profileDesc": {
                            "langUsage": {
                                "language": {
                                    "ident": "en",
                                    "_t": "English"
                                }
                            },
                            "textClass": {
                                "keywords": {
                                    "scheme": "author",
                                    "term": {
                                        "xml_lang": "en",
                                        "_t": "quality"
                                    }
                                },
                                "classCode": [
                                    {
                                        "scheme": "halDomain",
                                        "n": "sdv.spee",
                                        "_t": "Life Sciences [q-bio]/Santé publique et épidémiologie"
                                    },
                                    {
                                        "scheme": "halDomain",
                                        "n": "shs.eco",
                                        "_t": "Humanities and Social Sciences/Economics and Finance"
                                    },
                                    {
                                        "scheme": "halDomain",
                                        "n": "shs.psy",
                                        "_t": "Humanities and Social Sciences/Psychology"
                                    },
                                    {
                                        "scheme": "halDomain",
                                        "n": "sdv.mhep.psm",
                                        "_t": "Life Sciences [q-bio]/Human health and pathology/Psychiatrics and mental health"
                                    },
                                    {
                                        "scheme": "halTypology",
                                        "n": "ART",
                                        "_t": "Journal articles"
                                    },
                                    {
                                        "scheme": "halOldTypology",
                                        "n": "ART",
                                        "_t": "Journal articles"
                                    },
                                    {
                                        "scheme": "halTreeTypology",
                                        "n": "ART",
                                        "_t": "Journal articles"
                                    }
                                ]
                            },
                            "abstract": {
                                "xml_lang": "en",
                                "p": {
                                    "_t": "Cardiovascular conditions are serious long-term complications of childhood acute leukemia. However, few studies have investigated the risk of metabolic syndrome, a known predictor of cardiovascular disease, in patients treated without hematopoietic stem cell transplantation. We describe the overall and age-specific prevalence, and the risk factors for metabolic syndrome and its components in the L.E.A. (Leucémie de l'Enfant et de l'Adolescent) French cohort of childhood acute leukemia survivors treated without hematopoietic stem cell transplantation. The study included 650 adult patients (mean age at evaluation: 24.2 years; mean follow-up after leukemia diagnosis: 16.0 years). The prevalence of metabolic syndrome was 6.9% (95% CI 5.1-9.2). The age-specific cumulative prevalence at 20, 25, 30 and 35 years of age was 1.3%, 6.1%, 10.8% and 22.4%, respectively. The prevalence of decreased high-density lipoprotein cholesterol, increased triglycerides, increased fasting glucose, increased blood pressure and increased abdominal circumference was 26.8%, 11.7%, 5.8%, 36.7% and 16.7%, respectively. Risk factors significantly associated with metabolic syndrome in the multivariate analysis were male sex (OR 2.64; 95% CI 1.32-5.29), age at last evaluation (OR 1.10; 95% CI 1.04-1.17) and body mass index at diagnosis (OR 1.15; 95% CI 1.01-1.32). The cumulative steroid dose was not a significant risk factor. Irradiated and non-irradiated patients exhibited different patterns of metabolic abnormalities, with more frequent abdominal obesity in irradiated patients and more frequent hypertension in non-irradiated patients. Survivors of childhood acute leukemia are at risk of metabolic syndrome, even when treated without hematopoietic stem cell transplantation or central nervous system irradiation. A preventive approach with regular screening for cardiovascular risk factors is recommended. clinicaltrials.gov identifier:01756599."
                                }
                            }
                        }
                    }
                }
            },
            "back": {
                "listOrg": {
                    "type": "structures",
                    "org": [
                        {
                            "type": "institution",
                            "xml_id": "struct-360410",
                            "status": "VALID",
                            "orgName": {
                                "_t": "CHU Trousseau [APHP]"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "26 Avenue du Dr Arnold Netter, 75012 Paris"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://www.aphp.fr/contenu/hopital-armand-trousseau-1"
                                }
                            },
                            "listRelation": {
                                "relation": [
                                    {
                                        "active": "#struct-300068",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-413221",
                                        "type": "direct"
                                    }
                                ]
                            }
                        },
                        {
                            "type": "laboratory",
                            "xml_id": "struct-116327",
                            "status": "VALID",
                            "orgName": {
                                "_t": "Hôpital Robert Debré Paris"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Hôpital Robert Debré, service ORL, 48 Boulevard Sérurier, 75019 Paris"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            },
                            "listRelation": {
                                "relation": {
                                    "active": "#struct-300089",
                                    "type": "direct"
                                }
                            }
                        },
                        {
                            "type": "laboratory",
                            "xml_id": "struct-406979",
                            "status": "INCOMING",
                            "orgName": {
                                "_t": "Service de pédiatrie"
                            },
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            },
                            "listRelation": {
                                "relation": [
                                    {
                                        "active": "#struct-93013",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-51016",
                                        "type": "indirect"
                                    },
                                    {
                                        "active": "#struct-300071",
                                        "type": "indirect"
                                    }
                                ]
                            }
                        },
                        {
                            "type": "laboratory",
                            "xml_id": "struct-187162",
                            "status": "VALID",
                            "idno": [
                                {
                                    "type": "ISNI",
                                    "_t": "000000040609882X"
                                },
                                {
                                    "type": "RNSR",
                                    "_t": "201220436R"
                                },
                                {
                                    "type": "ROR",
                                    "_t": "https://ror.org/036xhtv26"
                                }
                            ],
                            "orgName": [
                                {
                                    "_t": "Institut de Génétique et Développement de Rennes"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "IGDR"
                                }
                            ],
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Faculté de Médecine - CS 34317 2 Av du Professeur Léon Bernard 35043 Rennes Cedex"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://igdr.univ-rennes1.fr/"
                                }
                            },
                            "listRelation": {
                                "relation": [
                                    {
                                        "active": "#struct-105160",
                                        "type": "direct"
                                    },
                                    {
                                        "name": "UMR6290",
                                        "active": "#struct-441569",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-453207",
                                        "type": "direct"
                                    }
                                ]
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-301327",
                            "status": "VALID",
                            "orgName": {
                                "_t": "CHU Pontchaillou [Rennes]"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "2 Rue Henri le Guilloux, 35000 Rennes"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://www.chu-rennes.fr/"
                                }
                            }
                        },
                        {
                            "type": "laboratory",
                            "xml_id": "struct-233198",
                            "status": "OLD",
                            "idno": [
                                {
                                    "type": "IdRef",
                                    "_t": "121760081"
                                },
                                {
                                    "type": "RNSR",
                                    "_t": "200014577Z"
                                }
                            ],
                            "orgName": [
                                {
                                    "_t": "Santé Publique et maladies Chroniques : Qualité de vie Concepts, Usages et Limites, Déterminants"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "SPMC"
                                }
                            ],
                            "date": [
                                {
                                    "type": "start",
                                    "_t": "2000"
                                },
                                {
                                    "type": "end",
                                    "_t": "2017-12-31"
                                }
                            ],
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Laboratoire de Santé Publique - 27 bd Jean Moulin 13385 Marseille 05"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            },
                            "listRelation": {
                                "relation": [
                                    {
                                        "name": "EA3279",
                                        "active": "#struct-198056",
                                        "type": "direct"
                                    },
                                    {
                                        "name": "EA3279",
                                        "active": "#struct-300073",
                                        "type": "direct"
                                    }
                                ]
                            }
                        },
                        {
                            "type": "department",
                            "xml_id": "struct-541105",
                            "status": "VALID",
                            "orgName": {
                                "_t": "Service de pédiatrie spécialisée et médecine infantile (neurologie, pneumologie, maladies héréditaires du métabolisme) [Hôpital de la Timone - APHM]"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Hôpital de la Timone EnfantsRue Saint-Pierre13005 Marseille"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://fr.ap-hm.fr/service/pediatrie-specialisee-medecine-infantile-hopital-timone"
                                }
                            },
                            "listRelation": {
                                "relation": {
                                    "active": "#struct-300093",
                                    "type": "direct"
                                }
                            }
                        },
                        {
                            "type": "laboratory",
                            "xml_id": "struct-17849",
                            "status": "OLD",
                            "orgName": {
                                "_t": "Service d'hématologie et immunologie pédiatrique"
                            },
                            "date": {
                                "type": "end",
                                "_t": "2019-12-31"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Paris"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            },
                            "listRelation": {
                                "relation": [
                                    {
                                        "active": "#struct-300068",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-300089",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-300301",
                                        "type": "direct"
                                    }
                                ]
                            }
                        },
                        {
                            "type": "regrouplaboratory",
                            "xml_id": "struct-183200",
                            "status": "VALID",
                            "orgName": {
                                "_t": "Hôpital Trousseau"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Avenue de la République 37170 Chambray-lès-Tours"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            },
                            "listRelation": {
                                "relation": {
                                    "active": "#struct-179009",
                                    "type": "direct"
                                }
                            }
                        },
                        {
                            "type": "department",
                            "xml_id": "struct-458700",
                            "status": "VALID",
                            "orgName": {
                                "_t": "Pédiatrie et oncologie pédiatrique  [Hôpital de la Timone - APHM]"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "264 Rue Saint-Pierre, 13385 Marseille"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            },
                            "listRelation": {
                                "relation": [
                                    {
                                        "active": "#struct-198056",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-300073",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-300093",
                                        "type": "direct"
                                    }
                                ]
                            }
                        },
                        {
                            "type": "laboratory",
                            "xml_id": "struct-180118",
                            "status": "OLD",
                            "idno": [
                                {
                                    "type": "IdRef",
                                    "_t": "123019265"
                                },
                                {
                                    "type": "RNSR",
                                    "_t": "197417835D"
                                }
                            ],
                            "orgName": [
                                {
                                    "_t": "Nutrition, obésité et risque thrombotique"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "NORT"
                                }
                            ],
                            "date": [
                                {
                                    "type": "start",
                                    "_t": "1974"
                                },
                                {
                                    "type": "end",
                                    "_t": "2017-12-31"
                                }
                            ],
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Faculté de Médecine Timone - 27 Bd Jean Moulin 13385 Marseille Cedex 5"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://nort.univ-amu.fr/"
                                }
                            },
                            "listRelation": {
                                "relation": [
                                    {
                                        "name": "UMR_A1260",
                                        "active": "#struct-92114",
                                        "type": "direct"
                                    },
                                    {
                                        "name": "UMR_A1260",
                                        "active": "#struct-198056",
                                        "type": "direct"
                                    },
                                    {
                                        "name": "U1062",
                                        "active": "#struct-303623",
                                        "type": "direct"
                                    }
                                ]
                            }
                        },
                        {
                            "type": "laboratory",
                            "xml_id": "struct-216005",
                            "status": "INCOMING",
                            "orgName": {
                                "_t": "Hématologie et immunologie pédiatrique"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "1 place Joseph Renaut 69008 Lyon"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            },
                            "listRelation": {
                                "relation": [
                                    {
                                        "active": "#struct-300074",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-339246",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-348446",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-352818",
                                        "type": "direct"
                                    }
                                ]
                            }
                        },
                        {
                            "type": "laboratory",
                            "xml_id": "struct-104634",
                            "status": "INCOMING",
                            "orgName": {
                                "_t": "Service d'hématologie pédiatrique"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Marseille"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            },
                            "listRelation": {
                                "relation": [
                                    {
                                        "active": "#struct-5033",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-300073",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-300093",
                                        "type": "direct"
                                    }
                                ]
                            }
                        },
                        {
                            "type": "laboratory",
                            "xml_id": "struct-116528",
                            "status": "INCOMING",
                            "orgName": {
                                "_t": "Unité de Transplantation Médullaire"
                            },
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            },
                            "listRelation": {
                                "relation": [
                                    {
                                        "active": "#struct-300157",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-306764",
                                        "type": "direct"
                                    }
                                ]
                            }
                        },
                        {
                            "type": "laboratory",
                            "xml_id": "struct-89817",
                            "status": "INCOMING",
                            "orgName": {
                                "_t": "Service Hématologie Infantile"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "BP 217X 38045 GRENOBLE"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            },
                            "listRelation": {
                                "relation": {
                                    "active": "#struct-300071",
                                    "type": "direct"
                                }
                            }
                        },
                        {
                            "type": "laboratory",
                            "xml_id": "struct-31375",
                            "status": "INCOMING",
                            "orgName": {
                                "_t": "Hôpital Pellegrin Tripode"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Bordeaux"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            },
                            "listRelation": {
                                "relation": {
                                    "active": "#struct-307238",
                                    "type": "direct"
                                }
                            }
                        },
                        {
                            "type": "laboratory",
                            "xml_id": "struct-439023",
                            "status": "INCOMING",
                            "orgName": {
                                "_t": "Service d'hématologie pédiatrique"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Clemont-Ferrand"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            },
                            "listRelation": {
                                "relation": [
                                    {
                                        "active": "#struct-300144",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-439022",
                                        "type": "direct"
                                    }
                                ]
                            }
                        },
                        {
                            "type": "regroupinstitution",
                            "xml_id": "struct-300068",
                            "status": "VALID",
                            "orgName": [
                                {
                                    "_t": "Assistance publique - Hôpitaux de Paris (AP-HP)"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "AP-HP"
                                }
                            ],
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            }
                        },
                        {
                            "type": "regroupinstitution",
                            "xml_id": "struct-413221",
                            "status": "VALID",
                            "idno": {
                                "type": "ROR",
                                "_t": "https://ror.org/02en5vm52"
                            },
                            "orgName": [
                                {
                                    "_t": "Sorbonne Université"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "SU"
                                }
                            ],
                            "date": {
                                "type": "start",
                                "_t": "2018-01-01"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "21 rue de l’École de médecine - 75006 Paris"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://www.sorbonne-universite.fr/"
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-300089",
                            "status": "VALID",
                            "orgName": {
                                "_t": "Hôpital Robert Debré"
                            },
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            }
                        },
                        {
                            "type": "laboratory",
                            "xml_id": "struct-93013",
                            "status": "VALID",
                            "orgName": {
                                "_t": "CHU Grenoble"
                            },
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            },
                            "listRelation": {
                                "relation": [
                                    {
                                        "active": "#struct-51016",
                                        "type": "direct"
                                    },
                                    {
                                        "active": "#struct-300071",
                                        "type": "direct"
                                    }
                                ]
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-51016",
                            "status": "OLD",
                            "idno": [
                                {
                                    "type": "IdRef",
                                    "_t": "026404796"
                                },
                                {
                                    "type": "ROR",
                                    "_t": "https://ror.org/02aj0kh94"
                                }
                            ],
                            "orgName": [
                                {
                                    "_t": "Université Joseph Fourier - Grenoble 1"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "UJF"
                                }
                            ],
                            "date": {
                                "type": "end",
                                "_t": "2015-12-31"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "BP 53 - 38041 Grenoble Cedex 9"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://www.ujf-grenoble.fr/"
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-300071",
                            "status": "VALID",
                            "orgName": {
                                "_t": "CHU Grenoble"
                            },
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-105160",
                            "status": "VALID",
                            "idno": {
                                "type": "ROR",
                                "_t": "https://ror.org/015m7wh34"
                            },
                            "orgName": [
                                {
                                    "_t": "Université de Rennes"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "UR"
                                }
                            ],
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Campus de Beaulieu, 263 avenue Général Leclerc, CS 74205, 35042 RENNES CEDEX"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "https://www.univ-rennes.fr/"
                                }
                            }
                        },
                        {
                            "type": "regroupinstitution",
                            "xml_id": "struct-441569",
                            "status": "VALID",
                            "idno": [
                                {
                                    "type": "IdRef",
                                    "_t": "02636817X"
                                },
                                {
                                    "type": "ISNI",
                                    "_t": "0000000122597504"
                                },
                                {
                                    "type": "ROR",
                                    "_t": "https://ror.org/02feahw73"
                                }
                            ],
                            "orgName": [
                                {
                                    "_t": "Centre National de la Recherche Scientifique"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "CNRS"
                                }
                            ],
                            "date": {
                                "type": "start",
                                "_t": "1939-10-19"
                            },
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "https://www.cnrs.fr/"
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-453207",
                            "status": "VALID",
                            "idno": [
                                {
                                    "type": "RNSR",
                                    "_t": "201220717W"
                                },
                                {
                                    "type": "ROR",
                                    "_t": "https://ror.org/05cx7ek10"
                                }
                            ],
                            "orgName": [
                                {
                                    "_t": "Structure Fédérative de Recherche en Biologie et Santé de Rennes"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "Biosit : Biologie - Santé - Innovation Technologique"
                                }
                            ],
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Université de Rennes - Campus Santé Villejean -  2, avenue Professeur Léon Bernard 35043 Rennes cedex"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-198056",
                            "status": "VALID",
                            "idno": [
                                {
                                    "type": "IdRef",
                                    "_t": "15863621X"
                                },
                                {
                                    "type": "ISNI",
                                    "_t": "0000 0001 2176 4817"
                                },
                                {
                                    "type": "ROR",
                                    "_t": "https://ror.org/035xkbk20"
                                }
                            ],
                            "orgName": [
                                {
                                    "_t": "Aix Marseille Université"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "AMU"
                                }
                            ],
                            "date": {
                                "type": "start",
                                "_t": "2012-01-01"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Aix-Marseille UniversitéJardins du Pharo58 Boulevard Charles Livon13284 Marseille cedex 7"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://www.univ-amu.fr/"
                                }
                            }
                        },
                        {
                            "type": "regroupinstitution",
                            "xml_id": "struct-300073",
                            "status": "VALID",
                            "orgName": [
                                {
                                    "_t": "Assistance Publique - Hôpitaux de Marseille"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "APHM"
                                }
                            ],
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Direction générale AP-HM80, rue Brochier13 354 Marseille Cedex 5"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://fr.ap-hm.fr/"
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-300093",
                            "status": "VALID",
                            "idno": [
                                {
                                    "type": "ISNI",
                                    "_t": "0000 0001 0404 1115"
                                },
                                {
                                    "type": "ROR",
                                    "_t": "https://ror.org/05jrr4320"
                                }
                            ],
                            "orgName": [
                                {
                                    "_t": "Hôpital de la Timone [CHU - APHM]"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "TIMONE"
                                }
                            ],
                            "date": {
                                "type": "start",
                                "_t": "1974-01-01"
                            },
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://fr.ap-hm.fr/nos-hopitaux/hopital-de-la-timone"
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-300301",
                            "status": "OLD",
                            "idno": [
                                {
                                    "type": "IdRef",
                                    "_t": "027542084"
                                },
                                {
                                    "type": "ISNI",
                                    "_t": "0000000121514068"
                                }
                            ],
                            "orgName": [
                                {
                                    "_t": "Université Paris Diderot - Paris 7"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "UPD7"
                                }
                            ],
                            "date": {
                                "type": "end",
                                "_t": "2019-12-31"
                            },
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "5 rue Thomas-Mann - 75205 Paris cedex 13"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://www.univ-paris-diderot.fr"
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-179009",
                            "status": "VALID",
                            "orgName": [
                                {
                                    "_t": "Centre Hospitalier Régional Universitaire de Tours"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "CHRU Tours"
                                }
                            ],
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Centre Hospitalier Régional Universitaire de Tours2 Boulevard Tonnellé 37044 Tours cedex 9"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "https://www.chu-tours.fr/"
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-92114",
                            "status": "OLD",
                            "orgName": [
                                {
                                    "_t": "Institut National de la Recherche Agronomique"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "INRA"
                                }
                            ],
                            "date": [
                                {
                                    "type": "start",
                                    "_t": "1946-05-18"
                                },
                                {
                                    "type": "end",
                                    "_t": "2019-12-31"
                                }
                            ],
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://www.inra.fr"
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-303623",
                            "status": "VALID",
                            "idno": [
                                {
                                    "type": "IdRef",
                                    "_t": "026388278"
                                },
                                {
                                    "type": "ROR",
                                    "_t": "https://ror.org/02vjkv261"
                                }
                            ],
                            "orgName": [
                                {
                                    "_t": "Institut National de la Santé et de la Recherche Médicale"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "INSERM"
                                }
                            ],
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "101, rue de Tolbiac, 75013 Paris"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://www.inserm.fr"
                                }
                            }
                        },
                        {
                            "type": "regroupinstitution",
                            "xml_id": "struct-300074",
                            "status": "VALID",
                            "idno": [
                                {
                                    "type": "IdRef",
                                    "_t": "026534657"
                                },
                                {
                                    "type": "ROR",
                                    "_t": "https://ror.org/01502ca60"
                                }
                            ],
                            "orgName": [
                                {
                                    "_t": "Hospices Civils de Lyon"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "HCL"
                                }
                            ],
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "3 Quai des Célestins69002 Lyon"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://www.chu-lyon.fr/fr/hospices-civils-de-lyon-hcl"
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-339246",
                            "status": "INCOMING",
                            "orgName": {
                                "_t": "CHU Lyon"
                            },
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-348446",
                            "status": "VALID",
                            "idno": {
                                "type": "ROR",
                                "_t": "https://ror.org/0075rng13"
                            },
                            "orgName": [
                                {
                                    "_t": "Institut d'hématologie et d'oncologie pédiatrique [CHU - HCL]"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "IHOPe"
                                }
                            ],
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "1 place Professeur Joseph Renault69008 Lyon"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://www.chu-lyon.fr/fr/institut-hematologie-et-oncologie-pediatrique-ihope"
                                }
                            },
                            "listRelation": {
                                "relation": {
                                    "active": "#struct-300074",
                                    "type": "direct"
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-352818",
                            "status": "INCOMING",
                            "orgName": {
                                "_t": "Hôpital Femme-Mère-Enfant (HFME)"
                            },
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-5033",
                            "status": "OLD",
                            "idno": {
                                "type": "IdRef",
                                "_t": "026402882"
                            },
                            "orgName": {
                                "_t": "Université de la Méditerranée - Aix-Marseille 2"
                            },
                            "date": [
                                {
                                    "type": "start",
                                    "_t": "1969"
                                },
                                {
                                    "type": "end",
                                    "_t": "2011"
                                }
                            ],
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "58, boulevard Charles Livon - 13284 Marseille cedex 07"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://www.univmed.fr/"
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-300157",
                            "status": "VALID",
                            "orgName": [
                                {
                                    "_t": "Centre Hospitalier Régional Universitaire de Nancy"
                                },
                                {
                                    "type": "acronym",
                                    "_t": "CHRU Nancy"
                                }
                            ],
                            "desc": {
                                "address": {
                                    "addrLine": {
                                        "_t": "Siège social : 29 avenue du Maréchal de Lattre de Tassigny, CO 60034, 54035 NANCY CEDEXHôpital Central : 29 Avenue du Maréchal de Lattre de Tassigny, 54035 NancyHôpitaux de Brabois / Enfants : Rue du Morvan, 54500 Vandœuvre-lès-NancyMaternité régionale :10 Avenue Dr Heydenreich, 54000 Nancy"
                                    },
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "http://www.chu-nancy.fr"
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-306764",
                            "status": "INCOMING",
                            "orgName": {
                                "_t": "Hôpital d'enfants"
                            },
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-307238",
                            "status": "INCOMING",
                            "orgName": {
                                "_t": "Hôpital Pellegrin Tripode"
                            },
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            }
                        },
                        {
                            "type": "regroupinstitution",
                            "xml_id": "struct-300144",
                            "status": "VALID",
                            "idno": [
                                {
                                    "type": "IdRef",
                                    "_t": "026606836"
                                },
                                {
                                    "type": "ISNI",
                                    "_t": "0000000406394151"
                                },
                                {
                                    "type": "ROR",
                                    "_t": "https://ror.org/02tcf7a68"
                                }
                            ],
                            "orgName": {
                                "_t": "CHU Clermont-Ferrand"
                            },
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                },
                                "ref": {
                                    "type": "url",
                                    "_t": "https://www.chu-clermontferrand.fr/"
                                }
                            }
                        },
                        {
                            "type": "institution",
                            "xml_id": "struct-439022",
                            "status": "INCOMING",
                            "orgName": {
                                "_t": "CIC Inserm 501"
                            },
                            "desc": {
                                "address": {
                                    "country": {
                                        "key": "FR"
                                    }
                                }
                            }
                        }
                    ]
                }
            }
        }
    }
},
{
    "id": 4,
    "value": "n/a"
}]

POST {{host}}/v1/conditor/works/expand?indent=true
content-type: application/json
[
  { "id":1,   "value": "10.1016/S0047-6374(98)00099-2"},
  { "id":2,   "value": "10.35562/arabesques.1222"},
  { "id":3,   "value": "10.3324/haematol.2016.148908"},
  { "id":4,   "value": ""}
]

HTTP 200
[{
    "id": 1,
    "value": "n/a"
},
{
    "id": 2,
    "value": {
        "abstract/default": "Les documents issus des bouquets acquis dans le cadre des négociations ISTEX et disponibles sur la plateforme possèdent un identifiant technique interne de 40 caractères, l’ID ISTEX. Ils ont été enrichis depuis peu par un nouvel identifiant normé, pérenne, gratuit et distribué : l’ARK.",
        "abstract/fr": "Les documents issus des bouquets acquis dans le cadre des négociations ISTEX et disponibles sur la plateforme possèdent un identifiant technique interne de 40 caractères, l’ID ISTEX. Ils ont été enrichis depuis peu par un nouvel identifiant normé, pérenne, gratuit et distribué : l’ARK.",
        "authors": [
            {
                "forename": "Pascale",
                "isni": [],
                "researcherId": [],
                "surname": "Viot",
                "affiliations": [
                    {
                        "ref": "struct-1814",
                        "address": "UAR76 / UPS76, Centre National de la Recherche Scientifique CNRS, Institut de l'information scientifique et technique INIST, 2 rue Jean Zay CS 10310 F-54519 Vandoeuvre-lès-Nancy, FR",
                        "isni": "0000000122597504",
                        "idRef": "02636817X",
                        "rnsr": [],
                        "enrichments": {
                            "rnsr": [
                                "198822446E"
                            ]
                        }
                    }
                ],
                "halAuthorId": [
                    "2072198-1081692"
                ],
                "orcId": [],
                "fullname": "Pascale Viot",
                "idHal": [
                    "1081692"
                ],
                "idRef": [],
                "viaf": [],
                "rnsr": [
                    "198822446E"
                ]
            },
            {
                "forename": "Nicolas",
                "isni": [],
                "researcherId": [],
                "surname": "Thouvenin",
                "affiliations": [
                    {
                        "ref": "struct-1814",
                        "address": "UAR76 / UPS76, Centre National de la Recherche Scientifique CNRS, Institut de l'information scientifique et technique INIST, 2 rue Jean Zay CS 10310 F-54519 Vandoeuvre-lès-Nancy, FR",
                        "isni": "0000000122597504",
                        "idRef": "02636817X",
                        "rnsr": [],
                        "enrichments": {
                            "rnsr": [
                                "198822446E"
                            ]
                        }
                    }
                ],
                "halAuthorId": [
                    "541308-0"
                ],
                "orcId": [],
                "fullname": "Nicolas Thouvenin",
                "idHal": [],
                "idRef": [],
                "viaf": [],
                "rnsr": [
                    "198822446E"
                ]
            }
        ],
        "business/duplicateGenre": "Article",
        "business/pageRange": [
            "18-19"
        ],
        "business/sourceUidChain": "!hal$hal-03008165!",
        "business/xPublicationDate": [
            "2018-01"
        ],
        "business/xissn": [
            "1269-0589"
        ],
        "classifications/hal": [
            {
                "code": "shs.info",
                "en": "Humanities and Social Sciences/Library and information sciences"
            }
        ],
        "classifications/tef": [],
        "classifications/dewey": [],
        "classifications/enrichments/hal/code": "shs",
        "classifications/enrichments/hal/en": "Humanities and Social Sciences",
        "classifications/enrichments/hal/fr": "Sciences de l'Homme et Société",
        "classifications/thesisDomain": [],
        "doi": "10.35562/arabesques.1222",
        "enrichments/openAccess/unpaywall/oaStatus": "green",
        "enrichments/openAccess/unpaywall/hasRepositoryCopy": true,
        "enrichments/openAccess/unpaywall/isOa": true,
        "enrichments/openAccess/unpaywall/oaLocations": [
            {
                "license": null,
                "hostType": "repository",
                "urlForPdf": "https://hal-cnrs.archives-ouvertes.fr/hal-03008165/file/arabesque_88_18_viot.pdf",
                "version": "submittedVersion",
                "isBest": true,
                "url": "https://hal-cnrs.archives-ouvertes.fr/hal-03008165/file/arabesque_88_18_viot.pdf",
                "urlForLandingPage": "https://hal-cnrs.archives-ouvertes.fr/hal-03008165/file/arabesque_88_18_viot.pdf"
            },
            {
                "license": "cc-by",
                "hostType": "repository",
                "urlForPdf": "https://cnrs.hal.science/hal-03008165/document",
                "version": "submittedVersion",
                "isBest": false,
                "url": "https://cnrs.hal.science/hal-03008165/document",
                "urlForLandingPage": "https://hal-cnrs.archives-ouvertes.fr/hal-03008165"
            },
            {
                "license": "cc-by",
                "hostType": "repository",
                "urlForPdf": "https://hal-cnrs.archives-ouvertes.fr/hal-03008165/document",
                "version": "submittedVersion",
                "isBest": false,
                "url": "https://hal-cnrs.archives-ouvertes.fr/hal-03008165/document",
                "urlForLandingPage": "https://hal-cnrs.archives-ouvertes.fr/hal-03008165"
            }
        ],
        "fulltextUrl": "https://cnrs.hal.science/hal-03008165/file/arabesque_88_18_viot.pdf",
        "halId": "hal-03008165",
        "host/conference": {},
        "host/pages/range": "18-19",
        "host/issn": "1269-0589",
        "host/issue": "88",
        "host/publisher": "ABES",
        "host/language": [
            "French"
        ],
        "host/title": "Arabesques",
        "host/publicationDate": "2018-01",
        "host/editors": [],
        "keywords/en/author": [],
        "keywords/en/mesh": [],
        "keywords/und/author": [],
        "keywords/fr/author": [],
        "keywords/fr/rameau": [],
        "keywords/fr/mesh": [],
        "originalGenre": "ART",
        "sourceUids": [
            "hal$hal-03008165"
        ],
        "technical/creationDate": [
            1663694373164
        ],
        "technical/sessionName": [
            "MULTICORPUS_2023-04-17_DEDUPLICATE"
        ],
        "title/default": "ISTEX : une nouvelle corde à son ARK",
        "title/fr": "ISTEX : une nouvelle corde à son ARK",
        "origins/abstract": "hal",
        "origins/abstract.default": "hal",
        "origins/abstract.fr": "hal",
        "origins/authors": "hal",
        "origins/business.duplicateGenre": "hal",
        "origins/business.pageRange": "hal",
        "origins/business.sourceUidChain": "hal",
        "origins/business.xPublicationDate": "hal",
        "origins/business.xissn": "hal",
        "origins/classifications": "hal",
        "origins/classifications.enrichments": "hal",
        "origins/classifications.enrichments.hal": "hal",
        "origins/classifications.hal": [
            "hal"
        ],
        "origins/doi": "hal",
        "origins/enrichments": "hal",
        "origins/enrichments.openAccess": "hal",
        "origins/enrichments.openAccess.unpaywall": "hal",
        "origins/fulltextUrl": "hal",
        "origins/halId": "hal",
        "origins/host": "hal",
        "origins/host.issn": "hal",
        "origins/host.issue": "hal",
        "origins/host.language": "hal",
        "origins/host.pages": "hal",
        "origins/host.publicationDate": "hal",
        "origins/host.publisher": "hal",
        "origins/host.title": "hal",
        "origins/keywords": "hal",
        "origins/keywords.en": "hal",
        "origins/keywords.fr": "hal",
        "origins/keywords.und": "hal",
        "origins/originalGenre": "hal",
        "origins/sourceUid": [
            "hal"
        ],
        "origins/technical.creationDate": [
            "hal"
        ],
        "origins/technical.sessionName": [
            "hal"
        ],
        "origins/title.default": "hal",
        "origins/title.fr": "hal",
        "origins/sources": [
            "hal"
        ]
    }
},
{
    "id": 3,
    "value": {
        "abstract/default": "Cardiovascular conditions are serious long-term complications of childhood acute leukemia. However, few studies have investigated the risk of metabolic syndrome, a known predictor of cardiovascular disease, in patients treated without hematopoietic stem cell transplantation. We describe the overall and age-specific prevalence, and the risk factors for metabolic syndrome and its components in the L.E.A. (Leucémie de l'Enfant et de l'Adolescent) French cohort of childhood acute leukemia survivors treated without hematopoietic stem cell transplantation. The study included 650 adult patients (mean age at evaluation: 24.2 years; mean follow-up after leukemia diagnosis: 16.0 years). The prevalence of metabolic syndrome was 6.9% (95% CI 5.1-9.2). The age-specific cumulative prevalence at 20, 25, 30 and 35 years of age was 1.3%, 6.1%, 10.8% and 22.4%, respectively. The prevalence of decreased high-density lipoprotein cholesterol, increased triglycerides, increased fasting glucose, increased blood pressure and increased abdominal circumference was 26.8%, 11.7%, 5.8%, 36.7% and 16.7%, respectively. Risk factors significantly associated with metabolic syndrome in the multivariate analysis were male sex (OR 2.64; 95% CI 1.32-5.29), age at last evaluation (OR 1.10; 95% CI 1.04-1.17) and body mass index at diagnosis (OR 1.15; 95% CI 1.01-1.32). The cumulative steroid dose was not a significant risk factor. Irradiated and non-irradiated patients exhibited different patterns of metabolic abnormalities, with more frequent abdominal obesity in irradiated patients and more frequent hypertension in non-irradiated patients. Survivors of childhood acute leukemia are at risk of metabolic syndrome, even when treated without hematopoietic stem cell transplantation or central nervous system irradiation. A preventive approach with regular screening for cardiovascular risk factors is recommended. clinicaltrials.gov identifier:01756599. Copyright© Ferrata Storti Foundation.",
        "abstract/en": "Cardiovascular conditions are serious long-term complications of childhood acute leukemia. However, few studies have investigated the risk of metabolic syndrome, a known predictor of cardiovascular disease, in patients treated without hematopoietic stem cell transplantation. We describe the overall and age-specific prevalence, and the risk factors for metabolic syndrome and its components in the L.E.A. (Leucémie de l'Enfant et de l'Adolescent) French cohort of childhood acute leukemia survivors treated without hematopoietic stem cell transplantation. The study included 650 adult patients (mean age at evaluation: 24.2 years; mean follow-up after leukemia diagnosis: 16.0 years). The prevalence of metabolic syndrome was 6.9% (95% CI 5.1-9.2). The age-specific cumulative prevalence at 20, 25, 30 and 35 years of age was 1.3%, 6.1%, 10.8% and 22.4%, respectively. The prevalence of decreased high-density lipoprotein cholesterol, increased triglycerides, increased fasting glucose, increased blood pressure and increased abdominal circumference was 26.8%, 11.7%, 5.8%, 36.7% and 16.7%, respectively. Risk factors significantly associated with metabolic syndrome in the multivariate analysis were male sex (OR 2.64; 95% CI 1.32-5.29), age at last evaluation (OR 1.10; 95% CI 1.04-1.17) and body mass index at diagnosis (OR 1.15; 95% CI 1.01-1.32). The cumulative steroid dose was not a significant risk factor. Irradiated and non-irradiated patients exhibited different patterns of metabolic abnormalities, with more frequent abdominal obesity in irradiated patients and more frequent hypertension in non-irradiated patients. Survivors of childhood acute leukemia are at risk of metabolic syndrome, even when treated without hematopoietic stem cell transplantation or central nervous system irradiation. A preventive approach with regular screening for cardiovascular risk factors is recommended. clinicaltrials.gov identifier:01756599. Copyright© Ferrata Storti Foundation.",
        "authors": [
            {
                "forename": "Paul",
                "isni": [],
                "researcherId": [],
                "surname": "Saultier",
                "affiliations": [
                    {
                        "address": "Department of Pediatric Hematology and Oncology, Timone Enfants Hospital, APHM and Aix-Marseille University, Marseille, France paul.saultier@gmail.com.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Paul Saultier",
                "idHal": [],
                "idRef": [],
                "viaf": [],
                "rnsr": [
                    "197417835D"
                ]
            },
            {
                "forename": "Pascal",
                "isni": [],
                "researcherId": [],
                "surname": "Auquier",
                "affiliations": [
                    {
                        "address": "Research Unit EA 3279 and Department of Public Health, Aix-Marseille University and Timone Hospital, Marseille, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Pascal Auquier",
                "idHal": [],
                "idRef": [],
                "viaf": [],
                "rnsr": [
                    "200014577Z"
                ]
            },
            {
                "forename": "Yves",
                "isni": [],
                "researcherId": [],
                "surname": "Bertrand",
                "affiliations": [
                    {
                        "address": "Department of Pediatric Hematology and Oncology, University Hospital of Lyon, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Yves Bertrand",
                "idHal": [],
                "idRef": [],
                "viaf": []
            },
            {
                "forename": "Camille",
                "isni": [],
                "researcherId": [],
                "surname": "Vercasson",
                "affiliations": [
                    {
                        "address": "Research Unit EA 3279 and Department of Public Health, Aix-Marseille University and Timone Hospital, Marseille, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Camille Vercasson",
                "idHal": [],
                "idRef": [],
                "viaf": [],
                "rnsr": [
                    "200014577Z"
                ]
            },
            {
                "forename": "Claire",
                "isni": [],
                "researcherId": [],
                "surname": "Oudin",
                "affiliations": [
                    {
                        "address": "Department of Pediatric Hematology and Oncology, Timone Enfants Hospital, APHM and Aix-Marseille University, Marseille, France.",
                        "rnsr": []
                    },
                    {
                        "address": "Research Unit EA 3279 and Department of Public Health, Aix-Marseille University and Timone Hospital, Marseille, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Claire Oudin",
                "idHal": [],
                "idRef": [],
                "viaf": []
            },
            {
                "forename": "Audrey",
                "isni": [],
                "researcherId": [],
                "surname": "Contet",
                "affiliations": [
                    {
                        "address": "Department of Pediatric Onco-Hematology, Hôpital d'Enfants de Brabois, Vandoeuvre-les-Nancy, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Audrey Contet",
                "idHal": [],
                "idRef": [],
                "viaf": []
            },
            {
                "forename": "Dominique",
                "isni": [],
                "researcherId": [],
                "surname": "Plantaz",
                "affiliations": [
                    {
                        "address": "Department of Pediatric Hematology-Oncology, University Hospital of Grenoble, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Dominique Plantaz",
                "idHal": [],
                "idRef": [],
                "viaf": []
            },
            {
                "forename": "Marilyne",
                "isni": [],
                "researcherId": [],
                "surname": "Poirée",
                "affiliations": [
                    {
                        "address": "Pediatric Hematology and Oncology department, University Hospital L'Archet, Nice, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Marilyne Poirée",
                "idHal": [],
                "idRef": [],
                "viaf": []
            },
            {
                "forename": "Stéphane",
                "isni": [],
                "researcherId": [],
                "surname": "Ducassou",
                "affiliations": [
                    {
                        "address": "Department of Pediatric Hematology and Oncology, University Hospital of Bordeaux, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Stéphane Ducassou",
                "idHal": [],
                "idRef": [],
                "viaf": []
            },
            {
                "forename": "Justyna",
                "isni": [],
                "researcherId": [],
                "surname": "Kanold",
                "affiliations": [
                    {
                        "address": "Department of Pediatric Hematology and Oncology, CIC Inserm 501, University Hospital of Clermont-Ferrand, France.",
                        "rnsr": [],
                        "enrichments": {
                            "rnsr": [
                                "200520116Y"
                            ]
                        }
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Justyna Kanold",
                "idHal": [],
                "idRef": [],
                "viaf": [],
                "rnsr": [
                    "200520116Y"
                ]
            },
            {
                "forename": "Marie-Dominique",
                "isni": [],
                "researcherId": [],
                "surname": "Tabone",
                "affiliations": [
                    {
                        "address": "Pediatric Hematology Department, Trousseau Hospital, Paris, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Marie-Dominique Tabone",
                "idHal": [],
                "idRef": [],
                "viaf": []
            },
            {
                "forename": "Jean-Hugues",
                "isni": [],
                "researcherId": [],
                "surname": "Dalle",
                "affiliations": [
                    {
                        "address": "Pediatric Hematology Department, Robert Debré Hospital, Paris, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Jean-Hugues Dalle",
                "idHal": [],
                "idRef": [],
                "viaf": []
            },
            {
                "forename": "Patrick",
                "isni": [],
                "researcherId": [],
                "surname": "Lutz",
                "affiliations": [
                    {
                        "address": "Department of Pediatric Hematology-Oncology, Hospital University, Strasbourg, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Patrick Lutz",
                "idHal": [],
                "idRef": [],
                "viaf": []
            },
            {
                "forename": "Virginie",
                "isni": [],
                "researcherId": [],
                "surname": "Gandemer",
                "affiliations": [
                    {
                        "address": "Department of Pediatric Hematology and Oncology, University Hospital of Rennes, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Virginie Gandemer",
                "idHal": [],
                "idRef": [],
                "viaf": [],
                "rnsr": [
                    "201220436R",
                    "201220717W"
                ]
            },
            {
                "forename": "Nicolas",
                "isni": [],
                "researcherId": [],
                "surname": "Sirvent",
                "affiliations": [
                    {
                        "address": "Pediatric Hematology and Oncology department, University Hospital, Montpellier, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Nicolas Sirvent",
                "idHal": [],
                "idRef": [],
                "viaf": []
            },
            {
                "forename": "Sandrine",
                "isni": [],
                "researcherId": [],
                "surname": "Thouvenin",
                "affiliations": [
                    {
                        "address": "Pediatric Hematology, University Hospital, Saint Etienne, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Sandrine Thouvenin",
                "idHal": [],
                "idRef": [],
                "viaf": []
            },
            {
                "forename": "Julie",
                "isni": [],
                "researcherId": [],
                "surname": "Berbis",
                "affiliations": [
                    {
                        "address": "Research Unit EA 3279 and Department of Public Health, Aix-Marseille University and Timone Hospital, Marseille, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Julie Berbis",
                "idHal": [],
                "idRef": [],
                "viaf": [],
                "rnsr": [
                    "200014577Z"
                ]
            },
            {
                "forename": "Hervé",
                "isni": [],
                "researcherId": [],
                "surname": "Chambost",
                "affiliations": [
                    {
                        "address": "Department of Pediatric Hematology and Oncology, Timone Enfants Hospital, APHM and Aix-Marseille University, Marseille, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Hervé Chambost",
                "idHal": [],
                "idRef": [],
                "viaf": []
            },
            {
                "forename": "André",
                "isni": [],
                "researcherId": [],
                "surname": "Baruchel",
                "affiliations": [
                    {
                        "address": "Pediatric Hematology Department, Robert Debré Hospital, Paris, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "André Baruchel",
                "idHal": [],
                "idRef": [],
                "viaf": []
            },
            {
                "forename": "Guy",
                "isni": [],
                "researcherId": [],
                "surname": "Leverger",
                "affiliations": [
                    {
                        "address": "Pediatric Hematology Department, Trousseau Hospital, Paris, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Guy Leverger",
                "idHal": [],
                "idRef": [],
                "viaf": []
            },
            {
                "forename": "Gérard",
                "isni": [],
                "researcherId": [],
                "surname": "Michel",
                "affiliations": [
                    {
                        "address": "Department of Pediatric Hematology and Oncology, Timone Enfants Hospital, APHM and Aix-Marseille University, Marseille, France.",
                        "rnsr": []
                    },
                    {
                        "address": "Research Unit EA 3279 and Department of Public Health, Aix-Marseille University and Timone Hospital, Marseille, France.",
                        "rnsr": []
                    }
                ],
                "halAuthorId": [],
                "orcId": [],
                "fullname": "Gérard Michel",
                "idHal": [],
                "idRef": [],
                "viaf": []
            }
        ],
        "business/duplicateGenre": "Article",
        "business/duplicateRules": [
            "Article : 1ID:doi+TiC",
            "Article : 1ID:doi+TiC_ENG",
            "Article : 1ID:doi+pmid",
            "Article : 2Collation:TiC+Ti_Source+issue+page+annee",
            "Article : 2Collation:TiC+Ti_Source+volume+issue+page+annee",
            "Article : 2Collation:TiC+Ti_Source+volume+page+annee",
            "Article : 2Collation:TiC+Ti_SourceM+issue+page+annee",
            "Article : 2Collation:TiC+Ti_SourceM+volume+issue+page+annee",
            "Article : 2Collation:TiC+Ti_SourceM+volume+page+annee",
            "Article : 2Collation:TiC+business.xissn+issue+page+annee",
            "Article : 2Collation:TiC+business.xissn+volume+issue+page+annee",
            "Article : 2Collation:TiC+business.xissn+volume+page+annee",
            "Article : 2Collation:TiC_ENG+Ti_Source+issue+page+annee",
            "Article : 2Collation:TiC_ENG+Ti_Source+volume+issue+page+annee",
            "Article : 2Collation:TiC_ENG+Ti_Source+volume+page+annee",
            "Article : 2Collation:TiC_ENG+Ti_SourceM+issue+page+annee",
            "Article : 2Collation:TiC_ENG+Ti_SourceM+volume+issue+page+annee",
            "Article : 2Collation:TiC_ENG+Ti_SourceM+volume+page+annee",
            "Article : 2Collation:TiC_ENG+business.xissn+issue+page+annee",
            "Article : 2Collation:TiC_ENG+business.xissn+volume+issue+page+annee",
            "Article : 2Collation:TiC_ENG+business.xissn+volume+page+annee"
        ],
        "business/duplicates": [
            {
                "sourceUid": "crossref$10.3324/haematol.2016.148908",
                "internalId": "938790B5F98151C672529FDDE8DA00E55539E228",
                "sessionName": "MULTICORPUS_2023-08-07_DEDUPLICATE",
                "rules": [
                    "Article : 1ID:doi+TiC",
                    "Article : 1ID:doi+TiC_ENG",
                    "Article : 2Collation:TiC+Ti_Source+issue+page+annee",
                    "Article : 2Collation:TiC+Ti_Source+volume+issue+page+annee",
                    "Article : 2Collation:TiC+Ti_Source+volume+page+annee",
                    "Article : 2Collation:TiC+Ti_SourceM+issue+page+annee",
                    "Article : 2Collation:TiC+Ti_SourceM+volume+issue+page+annee",
                    "Article : 2Collation:TiC+Ti_SourceM+volume+page+annee",
                    "Article : 2Collation:TiC+business.xissn+issue+page+annee",
                    "Article : 2Collation:TiC+business.xissn+volume+issue+page+annee",
                    "Article : 2Collation:TiC+business.xissn+volume+page+annee",
                    "Article : 2Collation:TiC_ENG+Ti_Source+issue+page+annee",
                    "Article : 2Collation:TiC_ENG+Ti_Source+volume+issue+page+annee",
                    "Article : 2Collation:TiC_ENG+Ti_Source+volume+page+annee",
                    "Article : 2Collation:TiC_ENG+Ti_SourceM+issue+page+annee",
                    "Article : 2Collation:TiC_ENG+Ti_SourceM+volume+issue+page+annee",
                    "Article : 2Collation:TiC_ENG+Ti_SourceM+volume+page+annee",
                    "Article : 2Collation:TiC_ENG+business.xissn+issue+page+annee",
                    "Article : 2Collation:TiC_ENG+business.xissn+volume+issue+page+annee",
                    "Article : 2Collation:TiC_ENG+business.xissn+volume+page+annee"
                ],
                "source": "crossref"
            },
            {
                "sourceUid": "hal$hal-01482380",
                "internalId": "74A88F25214DB1F4CF21905DC552992F12D4F1D3",
                "source": "hal",
                "sessionName": "MULTICORPUS_2023-09-21_DEDUPLICATE"
            },
            {
                "sourceUid": "pubmed$27515247",
                "internalId": "0970F52A147F38F099DEC709ED9BEC8EDBB5B575",
                "sessionName": "MULTICORPUS_2023-08-07_DEDUPLICATE",
                "source": "pubmed"
            }
        ],
        "business/pageRange": [
            "1603-1610"
        ],
        "business/sourceUidChain": "!crossref$10.3324/haematol.2016.148908!hal$hal-01482380!pubmed$27515247!",
        "business/xPublicationDate": [
            "2016-08-11",
            "2016-12"
        ],
        "business/xissn": [
            "1592-8721"
        ],
        "classifications/hal": [
            {
                "code": "sdv.spee",
                "en": "Life Sciences [q-bio]/Santé publique et épidémiologie"
            },
            {
                "code": "shs.eco",
                "en": "Humanities and Social Sciences/Economics and Finance"
            },
            {
                "code": "shs.psy",
                "en": "Humanities and Social Sciences/Psychology"
            },
            {
                "code": "sdv.mhep.psm",
                "en": "Life Sciences [q-bio]/Human health and pathology/Psychiatrics and mental health"
            }
        ],
        "classifications/tef": [],
        "classifications/dewey": [],
        "classifications/enrichments/hal/code": "sdv",
        "classifications/enrichments/hal/en": "Life Sciences [q-bio]",
        "classifications/enrichments/hal/fr": "Sciences du Vivant [q-bio]",
        "classifications/thesisDomain": [],
        "doi": "10.3324/haematol.2016.148908",
        "enrichments/openAccess/unpaywall/oaStatus": "gold",
        "enrichments/openAccess/unpaywall/hasRepositoryCopy": true,
        "enrichments/openAccess/unpaywall/isOa": true,
        "enrichments/openAccess/unpaywall/oaLocations": [
            {
                "license": "cc-by-nc",
                "hostType": "publisher",
                "urlForPdf": "http://www.haematologica.org/content/haematol/101/12/1603.full.pdf",
                "version": "publishedVersion",
                "isBest": true,
                "url": "http://www.haematologica.org/content/haematol/101/12/1603.full.pdf",
                "urlForLandingPage": "https://doi.org/10.3324/haematol.2016.148908"
            },
            {
                "license": null,
                "hostType": "repository",
                "urlForPdf": "https://europepmc.org/articles/pmc5479621?pdf=render",
                "version": "publishedVersion",
                "isBest": false,
                "url": "https://europepmc.org/articles/pmc5479621?pdf=render",
                "urlForLandingPage": "https://europepmc.org/articles/pmc5479621"
            },
            {
                "license": null,
                "hostType": "repository",
                "urlForPdf": null,
                "version": "publishedVersion",
                "isBest": false,
                "url": "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5479621",
                "urlForLandingPage": "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5479621"
            }
        ],
        "fulltextUrl": "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5479621",
        "host/electronicPublicationDate": "2016-08-11",
        "host/volume": "101",
        "host/conference": {},
        "host/pages/range": "1603-1610",
        "host/issue": "12",
        "host/eissn": "1592-8721",
        "host/language": [
            "English"
        ],
        "host/title": "Haematologica",
        "host/publicationDate": "2016-12",
        "host/editors": [],
        "host/issn": "0390-6078",
        "host/publisher": "Ferrata Storti Foundation",
        "keywords/en/author": [
            "quality"
        ],
        "keywords/en/mesh": [
            "Adolescent",
            "Adult",
            "Age Factors",
            "Antineoplastic Combined Chemotherapy Protocols",
            "adverse effects",
            "therapeutic use",
            "Child",
            "Child, Preschool",
            "Cohort Studies",
            "Combined Modality Therapy",
            "Female",
            "Follow-Up Studies",
            "Humans",
            "Leukemia",
            "complications",
            "therapy",
            "Male",
            "Metabolic Syndrome",
            "epidemiology",
            "etiology",
            "Prevalence",
            "Radiotherapy",
            "methods",
            "Remission Induction",
            "Risk Factors",
            "Survivors",
            "Young Adult"
        ],
        "keywords/und/author": [],
        "keywords/fr/author": [],
        "keywords/fr/rameau": [],
        "keywords/fr/mesh": [],
        "originalGenre": "Journal Article",
        "pii": "haematol.2016.148908",
        "pmId": "27515247",
        "pmcId": "PMC5479621",
        "sourceUids": [
            "pubmed$27515247",
            "crossref$10.3324/haematol.2016.148908",
            "hal$hal-01482380"
        ],
        "technical/creationDate": [
            1663750855011,
            1663762723492,
            1663697679315
        ],
        "technical/sessionName": [
            "MULTICORPUS_2023-09-21_DEDUPLICATE"
        ],
        "title/default": "Metabolic syndrome in long-term survivors of childhood acute leukemia treated without hematopoietic stem cell transplantation: an L.E.A. study.",
        "title/en": "Metabolic syndrome in long-term survivors of childhood acute leukemia treated without hematopoietic stem cell transplantation: an L.E.A. study.",
        "articleNumber": "haematol.2016.148908",
        "halId": "hal-01482380",
        "origins/abstract": "pubmed",
        "origins/abstract.default": "pubmed",
        "origins/abstract.en": "pubmed",
        "origins/authors": "pubmed",
        "origins/business.duplicateGenre": "pubmed",
        "origins/business.duplicateRules": "pubmed",
        "origins/business.duplicates": [
            "pubmed",
            "crossref",
            "hal"
        ],
        "origins/business.pageRange": "pubmed",
        "origins/business.sourceUidChain": "pubmed",
        "origins/business.xPublicationDate": "pubmed",
        "origins/business.xissn": "pubmed",
        "origins/classifications": "pubmed",
        "origins/classifications.enrichments": "pubmed",
        "origins/classifications.enrichments.hal": "pubmed",
        "origins/classifications.hal": [
            "pubmed",
            "crossref",
            "hal"
        ],
        "origins/doi": "pubmed",
        "origins/enrichments": "pubmed",
        "origins/enrichments.openAccess": "pubmed",
        "origins/enrichments.openAccess.unpaywall": "pubmed",
        "origins/fulltextUrl": "pubmed",
        "origins/host": "pubmed",
        "origins/host.eissn": "pubmed",
        "origins/host.electronicPublicationDate": "pubmed",
        "origins/host.issue": "pubmed",
        "origins/host.language": "pubmed",
        "origins/host.pages": "pubmed",
        "origins/host.publicationDate": "pubmed",
        "origins/host.title": "pubmed",
        "origins/host.volume": "pubmed",
        "origins/keywords": "pubmed",
        "origins/keywords.en": "pubmed",
        "origins/keywords.en.author": [
            "pubmed",
            "crossref",
            "hal"
        ],
        "origins/keywords.en.mesh": [
            "pubmed",
            "crossref",
            "hal"
        ],
        "origins/keywords.fr": "pubmed",
        "origins/keywords.und": "pubmed",
        "origins/originalGenre": "pubmed",
        "origins/pii": "pubmed",
        "origins/pmId": "pubmed",
        "origins/pmcId": "pubmed",
        "origins/sourceUid": [
            "pubmed",
            "crossref",
            "hal"
        ],
        "origins/technical.creationDate": [
            "pubmed",
            "crossref",
            "hal"
        ],
        "origins/technical.sessionName": [
            "pubmed",
            "crossref",
            "hal"
        ],
        "origins/title.default": "pubmed",
        "origins/title.en": "pubmed",
        "origins/sources": [
            "pubmed",
            "crossref",
            "hal"
        ],
        "origins/articleNumber": "crossref",
        "origins/halId": "hal",
        "origins/host.issn": "crossref",
        "origins/host.publisher": "hal"
    }
},
{
    "id": 4,
    "value": "n/a"
}]
