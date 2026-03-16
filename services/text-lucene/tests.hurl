POST {{host}}/v1/istex-search?indent=true
content-type: application/json
[
	{
		"value": "Je veux un corpus d'articles scientifiques publiés post 2020 sur la biodiversité dans la méditerranée nord. Les documents seront en anglais"
	},
	{
		"value": "no query"
	}
]


HTTP 200
[{
    "value": "(title:(\"biodiversity\" \"marine biodiversity\" \"ocean biodiversity\" \"oceanic biodiversity\") OR abstract:(\"biodiversity\" \"marine biodiversity\" \"ocean biodiversity\" \"oceanic biodiversity\") OR subject.value:(\"biodiversity\" \"marine biodiversity\" \"ocean biodiversity\" \"oceanic biodiversity\")) AND (title:(\"north mediterranean\" \"north mediterranean sea\") OR abstract:(\"north mediterranean\" \"north mediterranean sea\") OR subject.value:(\"north mediterranean\" \"north mediterranean sea\")) AND language.raw:(\"eng\") AND genre.raw:\"research-article\" AND publicationDate:[2020 TO *]"
},
{
    "value": ""
}]