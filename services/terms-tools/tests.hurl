# WARNING: This file should have CRLF line endings. It is an exception.
#          See .gitattributes

POST {{host}}/v1/en/dico_pos/postag?input=terms
Content-Type: text/tab-separated-values
```
id	text
http://data.loterre.fr/ark:/67375/P66#xl_en_9278939f	qualities
http://data.loterre.fr/ark:/67375/P66#xl_en_60f6687f	quality
http://data.loterre.fr/ark:/67375/P66#xl_en_696ab94f	material entities
http://data.loterre.fr/ark:/67375/P66#xl_en_c0a4dac9	material entity
http://data.loterre.fr/ark:/67375/P66#xl_en_ded9af98	processes
```

HTTP 200
```
"id"	"token"	"postag"	"lemma"
"http://data.loterre.fr/ark:/67375/P66#xl_en_9278939f"	"qualities"	"NNS"	"quality"
"http://data.loterre.fr/ark:/67375/P66#xl_en_60f6687f"	"quality"	"NN"	"quality"
"http://data.loterre.fr/ark:/67375/P66#xl_en_696ab94f"	"material entities"	"NN NNS"	"material entity"
"http://data.loterre.fr/ark:/67375/P66#xl_en_c0a4dac9"	"material entity"	"NN NN"	"material entity"
"http://data.loterre.fr/ark:/67375/P66#xl_en_ded9af98"	"processes"	"NNS"	"process"
```
