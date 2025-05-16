POST {{host}}/v1/tools?indent=true
content-type: application/json
[
	{ "value": "Reforming Research Assessment at Strathclyde: A five-year CoARA action plan Background Strathclyde is committed to enabling research activity that adheres to the highest standards of research integrity, underpinned by a positive research culture. Following seminal initiatives such as the San Francisco Declaration on Research Assessment (DORA, 2013), the Leiden Manifesto (2015) and the Metric Tide Report (2016), there is now broad agreement amongst the research community that reform of research assessment is required to promote sustainable research quality and strengthen research cultures." }
]


HTTP 200
[{
    "value": {
        "tools": [
            "research integrity",
            "san francisco declaration on research assessment",
            "dora",
            "leiden manifesto"
        ],
        "tools_homogenised": [
            "research integrity",
            "dora",
            "dora",
            "leiden manifesto"
        ]
    }
}]