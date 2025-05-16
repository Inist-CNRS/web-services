# WARNING: This file was not generated, but manually written.
# DON'T OVERWRITE IT
# Use it to test:
# npx hurl --test data-computer/tests.hurl


POST {{host}}/v1/table-extraction
content-type: application/x-tar
x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,example-table-extraction.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists


POST {{host}}/v1/retrieve-json?indent=true
content-type: application/json
[Options]
delay: 30000
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$" count == 1
jsonpath "$[0].value" count == 2
jsonpath "$[0].value[0].json" exists
jsonpath "$[0].value[0].page" exists
jsonpath "$[0].value[1].json" exists
jsonpath "$[0].value[1].page" exists
# ```
# [{
#     "id": "data/example.pdf",
#     "value": [
#         {
#             "page": 0,
#             "json": {
#                 "0": {
#                     "0": "Variable",
#                     "1": "Variable",
#                     "2": "N_0",
#                     "3": "N_1",
#                     "4": "N_2",
#                     "5": "VAR_0",
#                     "6": "VAR_1",
#                     "7": "VAR_2",
#                     "8": "VAR_3",
#                     "9": "VAR_4",
#                     "10": "C_0",
#                     "11": "C_1"
#                 },
#                 "1": {
#                     "0": "Importance estimée",
#                     "1": "Importance",
#                     "2": "0.0943",
#                     "3": "0.0943",
#                     "4": "0.0943",
#                     "5": "0.0951",
#                     "6": "0.0951",
#                     "7": "0.0951",
#                     "8": "0.0951",
#                     "9": "0.0951",
#                     "10": "0.0951",
#                     "11": "0.0951"
#                 },
#                 "2": {
#                     "0": "Importance estimée",
#                     "1": "LevelMT",
#                     "2": "0",
#                     "3": "0",
#                     "4": "0",
#                     "5": "0",
#                     "6": "0",
#                     "7": "0",
#                     "8": "0",
#                     "9": "0",
#                     "10": "0",
#                     "11": "0"
#                 },
#                 "3": {
#                     "0": "Variable",
#                     "1": "Variable",
#                     "2": "C_2",
#                     "3": "C_3",
#                     "4": "C_4",
#                     "5": "N_3",
#                     "6": "N_4",
#                     "7": "VAR_5",
#                     "8": "VAR_6",
#                     "9": "VAR_7",
#                     "10": "VAR_8",
#                     "11": "VAR_9"
#                 },
#                 "4": {
#                     "0": "Importance estimée",
#                     "1": "Importance)",
#                     "2": "0.0951",
#                     "3": "0.0951",
#                     "4": "0.0951",
#                     "5": "0.1001",
#                     "6": "0.1014",
#                     "7": "0.1052",
#                     "8": "0.1297",
#                     "9": "0.2382",
#                     "10": "0.3416",
#                     "11": "0.7552"
#                 },
#                 "5": {
#                     "0": "Importance estimée",
#                     "1": "LevelMT",
#                     "2": "0",
#                     "3": "0",
#                     "4": "0",
#                     "5": "0",
#                     "6": "0",
#                     "7": "0.0668",
#                     "8": "0.04844",
#                     "9": "0.2216",
#                     "10": "0.3149",
#                     "11": "0.6348"
#                 }
#             }
#         },
#         {
#             "page": 0,
#             "json": {
#                 "0": {
#                     "0": "Data",
#                     "1": "Accident",
#                     "2": "Auslan",
#                     "3": "Credit Scoring",
#                     "4": "Fox",
#                     "5": "Medical data",
#                     "6": "Musk1",
#                     "7": "Musk2",
#                     "8": "Synthétique 1",
#                     "9": "Synthétique 2",
#                     "10": "SpliceJunction",
#                     "11": "20newsgroups"
#                 },
#                 "1": {
#                     "0": "Instances",
#                     "1": "57,783",
#                     "2": "2,565",
#                     "3": "1,526,659",
#                     "4": "2,565",
#                     "5": "1240",
#                     "6": "92",
#                     "7": "102",
#                     "8": "20,000",
#                     "9": "20,000",
#                     "10": "3,178",
#                     "11": "18,846"
#                 },
#                 "2": {
#                     "0": "enregistrements",
#                     "1": "146,949",
#                     "2": "146,949",
#                     "3": "241,938,537",
#                     "4": "146,949",
#                     "5": "3205",
#                     "6": "476",
#                     "7": "6,598",
#                     "8": "2,420,221",
#                     "9": "2,055,870",
#                     "10": "191,400",
#                     "11": "2,435,219"
#                 },
#                 "3": {
#                     "0": "Cat.cols",
#                     "1": "28",
#                     "2": "1",
#                     "3": "194",
#                     "4": "1",
#                     "5": "41",
#                     "6": "1",
#                     "7": "1",
#                     "8": "10",
#                     "9": "10",
#                     "10": "2",
#                     "11": "1"
#                 },
#                 "4": {
#                     "0": "Num.cols",
#                     "1": "6",
#                     "2": "23",
#                     "3": "391",
#                     "4": "23",
#                     "5": "4",
#                     "6": "166",
#                     "7": "166",
#                     "8": "0",
#                     "9": "0",
#                     "10": "1",
#                     "11": "0"
#                 },
#                 "5": {
#                     "0": "Classes",
#                     "1": "2",
#                     "2": "96",
#                     "3": "2",
#                     "4": "96",
#                     "5": "22",
#                     "6": "2",
#                     "7": "2",
#                     "8": "2",
#                     "9": "2",
#                     "10": "3",
#                     "11": "20"
#                 },
#                 "6": {
#                     "0": "Maj.",
#                     "1": "0.945",
#                     "2": "0.011",
#                     "3": "0.9686",
#                     "4": "0.011",
#                     "5": "0.158",
#                     "6": "0.511",
#                     "7": "0.618",
#                     "8": "0.99",
#                     "9": "0.99",
#                     "10": "0.521",
#                     "11": "0.054"
#                 }
#             }
#         }
#     ],
#     "PID1743759829654": "uid:/{{computing_token}}"
# }]
# ```

POST {{host}}/v1/retrieve-csv
content-type: application/json
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
Content-Type: text/csv
[Asserts]
body contains "Page: 0"
body contains "Importance estimée"
body contains "\"Variable\",\"Importance estimée\",\"Importance estimée\",\"Variable\",\"Importance estimée\",\"Importance estimée\""
