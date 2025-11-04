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