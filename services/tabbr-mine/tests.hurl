POST {{host}}/v1/mine?indent=true
content-type: application/json
[
	{ "value": "Convolutional neural network (CNN)" },
	{ "value": "Convolutional brain organization (CNN)" }
]


HTTP 200
[{
    "value": [
        {
            "Abbreviation": "convolutional neural network (cnn)",
            "Prediction": "genuine",
            "Count": 1
        }
    ]
},
{
    "value": [
        {
            "Abbreviation": "convolutional brain organization (cnn)",
            "Prediction": "to be checked",
            "Count": 1
        }
    ]
}]

POST {{host}}/v1/mine-pdf?indent=true
Content-Type: application/pdf
[Options]
skip: {{blocked}}
file,example.pdf;


HTTP 200
[Asserts]
# Ignore filename field
jsonpath "$[0].value" count == 6
jsonpath "$[0].value[0].Abbreviation" == "de neurones récurrents (rnn)"
jsonpath "$[0].value[0].Prediction" == "to be checked"
jsonpath "$[0].value[0].Count" == 1
jsonpath "$[0].value[1].Abbreviation" == "géographique et forestière (ign)"
jsonpath "$[0].value[1].Prediction" == "genuine"
jsonpath "$[0].value[1].Count" == 1
jsonpath "$[0].value[2].Abbreviation" == "nommés dans le code respectivement flairembeddings (fr) flairembeddings (frforward) et flairembeddings (fr-backward)"
jsonpath "$[0].value[2].Prediction" == "to be checked"
jsonpath "$[0].value[2].Count" == 1
jsonpath "$[0].value[3].Abbreviation" == "océanographique de la marine (shom)"
jsonpath "$[0].value[3].Prediction" == "genuine"
jsonpath "$[0].value[3].Count" == 1
jsonpath "$[0].value[4].Abbreviation" == "respectivement flairembeddings (fr)"
jsonpath "$[0].value[4].Prediction" == "to be checked"
jsonpath "$[0].value[4].Count" == 1
jsonpath "$[0].value[5].Abbreviation" == "sont nommés dans le code respectivement flairembeddings (fr) flairembeddings (frforward)"
jsonpath "$[0].value[5].Prediction" == "to be checked"
jsonpath "$[0].value[5].Count" == 1
