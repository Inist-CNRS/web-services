POST {{host}}/v1/tools?indent=true
content-type: application/json
[
	{ "value": "Reforming Research Assessment at Strathclyde: A five-year CoARA action plan Background Strathclyde is committed to enabling research activity that adheres to the highest standards of research integrity, underpinned by a positive research culture. Following seminal initiatives such as the San Francisco Declaration on Research Assessment (DORA, 2013), the Leiden Manifesto (2015) and the Metric Tide Report (2016), there is now broad agreement amongst the research community that reform of research assessment is required to promote sustainable research quality and strengthen research cultures." }
]

HTTP 200
[{
    "value": [
        {
            "tool": "san francisco declaration on research assessment",
            "tool_homogenised": "dora",
            "other_tool_form": [
                "dora",
                "declaration on research assessment",
                "san francisco declaration on research assessment"
            ],
            "definition": "No definition provided.",
            "other_tool_form_flatten": "dora ; declaration on research assessment ; san francisco declaration on research assessment"
        },
        {
            "tool": "dora",
            "tool_homogenised": "dora",
            "other_tool_form": [
                "dora",
                "declaration on research assessment",
                "san francisco declaration on research assessment"
            ],
            "definition": "No definition provided.",
            "other_tool_form_flatten": "dora ; declaration on research assessment ; san francisco declaration on research assessment"
        },
        {
            "tool": "leiden manifesto",
            "tool_homogenised": "leiden manifesto",
            "other_tool_form": [
                "leiden manifesto",
                "leiden principles"
            ],
            "definition": "No definition provided.",
            "other_tool_form_flatten": "leiden manifesto ; leiden principles"
        }
    ]
}]

POST {{host}}/v1/methods?indent=true
content-type: application/json
[
	{ "value": "Reforming Research Assessment at Strathclyde: A five-year CoARA action plan Background Strathclyde is committed to enabling research activity that adheres to the highest standards of research integrity, underpinned by a positive research culture. Following seminal initiatives such as the San Francisco Declaration on Research Assessment (DORA, 2013), the Leiden Manifesto (2015) and the Metric Tide Report (2016), there is now broad agreement amongst the research community that reform of research assessment is required to promote sustainable research quality and strengthen research cultures. M5 Receiving feedback from our member associations on the contents of the draft guidelines, with the revised guidelines sent out to consultation for official confirmation by all member associations." }
]


HTTP 200
[{
    "value": [
        "M5 Receiving feedback from our member associations on the contents of the draft guidelines, with the revised guidelines sent out to consultation for official confirmation by all member associations."
    ]
}]