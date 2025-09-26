POST {{host}}/v1/tagger?indent=true
content-type: application/json
[
	{ "value": "This is a test text for the ner model. Model has to extract software such as BioImag Softr." },
	{ "value": "An RNN-based model was designed using Python3 language with the PyTorch packages." },
	{ "value": "There is no software in this sentence." }
]

HTTP 200
[{
    "value": {
        "SOFT": [
            "BioImag Softr"
        ]
    }
},
{
    "value": {
        "SOFT": [
            "Python3",
            "PyTorch"
        ]
    }
},
{
    "value": {
        "SOFT": []
    }
}]

POST {{host}}/v1/tagger-oa?indent=true
content-type: application/json
[
	{ "value": "This is a test text for the ner model. Model has to extract software such as BioImag Softr." },
	{ "value": "An RNN-based model was designed using Python3 language with the PyTorch packages." },
	{ "value": "There is no software in this sentence." }
]


HTTP 200
[{
    "value": {
        "SOFT": [
            {
                "name": "BioImag Softr",
                "status": "not_found",
                "code_url": "",
                "license": ""
            }
        ]
    }
},
{
    "value": {
        "SOFT": [
            {
                "name": "Python3",
                "status": "found",
                "code_url": "",
                "license": "BSD"
            },
            {
                "name": "PyTorch",
                "status": "found",
                "code_url": "https://github.com/pytorch/pytorch/blob/main/CODE_OF_CONDUCT.md",
                "license": "BSD-3-Clause"
            }
        ]
    }
},
{
    "value": {
        "SOFT": []
    }
}]