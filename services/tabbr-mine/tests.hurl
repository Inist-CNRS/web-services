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
            "Source": "value",
            "Abbreviation": "convolutional neural network (cnn)",
            "X": "genuine",
            "Count": 1
        }
    ]
},
{
    "value": [
        {
            "Source": "value",
            "Abbreviation": "convolutional brain organization (cnn)",
            "X": "tortured",
            "Count": 1
        }
    ]
}]

POST {{host}}/v1/mine-pdf?indent=true
Content-Type: application/pdf
[Options]
skip: {{blocked}}
file,./example.pdf;


HTTP 200
# Capture the computing token
[Captures]
fr_computing_ref: jsonpath "$[0].value"
[Asserts]
variable "fr_computing_ref" exists