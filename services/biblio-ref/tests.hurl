POST {{host}}/v1/validate?indent=true
content-type: application/json
[
  {
    "value": "J. A. TORRES, A. GARCIA-FUENTES, C. SALAZAR, E. CANO & F. VALLE - Caracterizacion de los pinares de Pil1l1s halepellsis Mill. en el sur de la Peninsula Iberica"
  },
  {
    "value":"Y. B. LINHART. L. CHAOUNI-BENABDALLAH, J.-M. PARRY & J. D. THOMPSON - Selective herbivory of thyme chemotypes by a mollusk and a grasshopper"
  },
  {
    "value": "https://doi.org/10.1016\/b978-0-323-90638-8.00002-3"
  },
  {
    "value": "RETRACTED > Estruch R., Primary Prevention of Cardiovascular Disease with a Mediterranean Diet, 10.1056/nejmoa1200303"
  },
  {
    "value": "HALLUCINATED > Zohuri, B. (2019). A Comparison of Molten Salt Reactors to Light Water Reactors: Pros and Cons. In Molten Salt Reactors and Thorium Energy (pp. 81-98). Woodhead Publishing. https://doi.org/10.1016\/b978-0-323-90638-8.00002-3"
  },
  {
    "value": "HALUCINATED WITHOUT DOI > Zohuri, B. (2019). Selective herbivory of thyme chemotypes by a mollusk and a grasshopper (pp. 81-98). Woodhead Publishing."
  },
  {
    "value": ["bad","input","type"]
  },
  {
    "value": "nothing here"
  }
]

HTTP 200
[{
    "value": {
        "doi": "10.3406/ecmed.1999.1878",
        "status": "found"
    }
},
{
    "value": {
        "doi": "10.3406/ecmed.1999.1879",
        "status": "found"
    }
},
{
    "value": {
        "doi": "10.1016/b978-0-323-90638-8.00002-3",
        "status": "found"
    }
},
{
    "value": {
        "doi": "10.1056/nejmoa1200303",
        "status": "retracted"
    }
},
{
    "value": {
        "doi": "",
        "status": "hallucinated"
    }
},
{
    "value": {
        "doi": "",
        "status": "hallucinated"
    }
},
{
    "value": {
        "doi": "",
        "status": "error_data"
    }
},
{
    "value": {
        "doi": "",
        "status": "not_found"
    }
}]

POST {{host}}/v1/validate-url?indent=true
content-type: application/json
[
  {
    "value":"https://cnrs.hal.science/hal-04461354/file/anki-gaillard-revol.pdf"
  }
]


HTTP 200
[{
    "value": [
        {
            "doi": "",
            "status": "not_found",
            "reference": "Akbik, A., T. Bergmann, D. Blythe, K. Rasul, S. Schweter, et R. Vollgraf (2019). FLAIR : An easy-to-use framework for state-of-the-art NLP. In NAACL 2019, 2019 Annual Conference of the North American Chapter of the Association for Computational Linguistics (Demonstrations), pp. 54–59.",
            "url_pdf": "https://cnrs.hal.science/hal-04461354/file/anki-gaillard-revol.pdf"
        },
        {
            "doi": "",
            "status": "not_found",
            "reference": "Akbik, A., D. Blythe, et R. Vollgraf (2018). Contextual string embeddings for sequence labeling. In COLING 2018, 27th International Conference on Computational Linguistics, pp.",
            "url_pdf": "https://cnrs.hal.science/hal-04461354/file/anki-gaillard-revol.pdf"
        },
        {
            "doi": "10.1162/tacl_a_00051",
            "status": "found",
            "reference": "Bojanowski, P., E. Grave, A. Joulin, et T. Mikolov (2016). Enriching word vectors with subword information. arXiv preprint arXiv :1607.04606.",
            "url_pdf": "https://cnrs.hal.science/hal-04461354/file/anki-gaillard-revol.pdf"
        },
        {
            "doi": "",
            "status": "not_found",
            "reference": "Brunner, A., N. D. T. Tu, L. Weimer, et F. Jannidis (2020). To bert or not to bert - comparing contextual embeddings in a deep learning architecture for the automatic recognition of four types of speech, thought and writing representation. In SwissText/KONVENS.",
            "url_pdf": "https://cnrs.hal.science/hal-04461354/file/anki-gaillard-revol.pdf"
        },
        {
            "doi": "",
            "status": "not_found",
            "reference": "Guille, A. (2023). Défi textmine 2024.",
            "url_pdf": "https://cnrs.hal.science/hal-04461354/file/anki-gaillard-revol.pdf"
        },
        {
            "doi": "10.1007/s11192-023-04806-2",
            "status": "found",
            "reference": "Smirnova, N. et P. Mayr (2023). Embedding models for supervised automatic extraction and classification of named entities in scientific acknowledgements. Scientometrics, 1–25.",
            "url_pdf": "https://cnrs.hal.science/hal-04461354/file/anki-gaillard-revol.pdf"
        },
        {
            "doi": "",
            "status": "not_found",
            "reference": "Suignard, P., L. Hassani, et M. Bothua (EasyChair, 2023). Participation d’edf rd au défi textmine 2023 : Reconnaissance d’entités d’intérêts dans les signatures d’e-mails. EasyChair",
            "url_pdf": "https://cnrs.hal.science/hal-04461354/file/anki-gaillard-revol.pdf"
        },
        {
            "doi": "10.1109/ispras47671.2019.00017",
            "status": "found",
            "reference": "Vychegzhanin, S. et E. Kotelnikov (2019). Comparison of named entity recognition tools applied to news articles. pp. 72–77.",
            "url_pdf": "https://cnrs.hal.science/hal-04461354/file/anki-gaillard-revol.pdf"
        }
    ]
}]

POST {{host}}/v1/validate-pdf?indent=true
Content-Type: application/pdf
file,./example.pdf;


HTTP 200
# Capture the computing token
[Captures]
fr_computing_ref: jsonpath "$[0].value"
[Asserts]
variable "fr_computing_ref" exists
