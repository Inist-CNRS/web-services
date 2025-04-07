# terms_tools

Bibliothèque d'outils pour l'étiquetage POS de liste et la reconnaissance de termes

## POStag et lemmatisation une liste de termes en français et en anglais  

### INPUT

exemple : `test_labelEN.tsv`

```tsv
id	text  
http://data.loterre.fr/ark:/67375/P66#xl_en_9278939f	qualities
http://data.loterre.fr/ark:/67375/P66#xl_en_696ab94f	material entities
http://data.loterre.fr/ark:/67375/P66#xl_en_d9fccd58	process
http://data.loterre.fr/ark:/67375/P66#xl_en_0fa9a1f2	empirical effect
http://data.loterre.fr/ark:/67375/P66#xl_en_ba359dd0	empirical generalization
http://data.loterre.fr/ark:/67375/P66#xl_en_06b45a8a	general empirical observation
http://data.loterre.fr/ark:/67375/P66#xl_en_d9a365b6	empirical generalisations
```

### Trois types d'OUTPUT sont disponibles

#### sous la forme d'un dictionnaire jsonld avec l'ensemble des informations (option -o json)

Exemple de sortie :

```tsv
http://data.loterre.fr/ark:/67375/P66#xl_en_53acd26b	[{"id": 0, "start": 0, "end": 7, "tag": "JJ", "pos": "ADJ", "morph": "Degree=Pos", "lemma": "general"}, {"id": 1, "start": 8, "end": 17, "tag": "JJ", "pos": "ADJ", "morph": "Degree=Pos", "lemma": "empirical"}, {"id": 2, "start":18, "end": 30, "tag": "NNS", "pos": "NOUN", "morph": "Number=Plur", "lemma": "observation"}]
```

##### WebService

```bash
ROUTE = /v1/en/dico-pos/postag?input=terms**  
URL =  https://loterre-annotator-1.terminology.inist.fr   

curl -X 'POST' '$URL/v1/en/dico-pos/postag?input=terms' --data-binary '@../terms_tools/test/data/test_labelEN.tsv'  

curl -X 'POST' '$URL/v1/fr/dico-pos/postag?input=terms' --data-binary '@../terms_tools/test/data/test_labelFR.tsv'  
```

#### sous une forme tabulée simplifiée, format :    URI   POSTAG LEMMA      (option -o dico_pos)

Exemple de sortie :

```tsv
http://data.loterre.fr/ark:/67375/P66#xl_en_542d3e8b	cognitive qualities	JJ NNS	cognitive quality
http://data.loterre.fr/ark:/67375/P66#xl_en_9ac2b72c	cognitive quality	 JJ NN	cognitive quality
http://data.loterre.fr/ark:/67375/P66#xl_en_ef4050c0	objects	NNS	object  
```

##### WebService

```bash
ROUTE = v1/en/dico-annot/postag?input=terms
URL =    

curl -X 'POST' '$URL/v1/en/dico-annot/postag?input=terms' --data-binary '@../terms_tools/test/data/test_labelEN.tsv'

curl -X 'POST' '$URL/v1/fr/dico-annot/postag?input=terms' --data-binary '@../terms_tools/test/data/test_labelFR.tsv'
```

#### sous la forme d'un dictionnaire pour termMatcher

Exemple de sortie :

```tsv
http://data.loterre.fr/ark:/67375/P66#xl_en_d2b95b32	{"label": "empirical generalisation ", "pattern": [{"pos": "ADJ", "lemma": "empirical"}, {"pos": "NOUN", "lemma": "generalisation"}], "id": "http://data.loterre.fr/ark:/67375/P66#xl_en_d2b95b32"}  
```

##### WebService



```bash
ROUTE = v1/en/full-morph/postag?input=terms
URL =  

curl -X 'POST' '$URL/v1/en/full-morph/postag?input=terms' --data-binary '@../terms_tools/test/data/test_labelEN.tsv'  

curl -X 'POST' '$URL/v1/fr/full-morph/postag?input=terms' --data-binary '@../terms_tools/test/data/test_labelFR.tsv'  
```

## Reconnaissance de termes


##### WebService

```
ROUTE = /v1/en/terms_matcher/<CODE_VOC>/format=<FORMAT>
URL = !
```

**FORMAT**
|  format | description |
| :--------------- | :--------------- |
| json-standoff | liste de termes reconnus sous le forme json |
| json-indoc| document avec termes annotés, format json id, value |
| xml-standoff | liste de termes reconnus sous le forme xml (loterre widget) |

CODE_VOC = voir la liste des codes vocabulaires de loterre


#### Exemples :

- Reconnaissance des termes en appartenant au vocabulaire  https://loterre.istex.fr/P66/ 
CODE_VOC=P66   ; format=json-standoff
- Sortie au format json standoff

#### Requête :

```
cat <<EOF | curl -v --proxy "" -X POST --data-binary @- https://loterre-annotator-1.terminology.inist.fr/v1/en/terms-matcher/P66?format=json-standoff
[
    {
        "id": "1",
        "value": "The Mem-Pro-Clinic test is a clinical test to assess difficulties in event- and time-based prospective thoughts. This result implies that activated long-term memory provides a representational basis for semantic verbal short-term signal."
    },
    {
        "id": "2",
        "value": "A new method to implant false autobiographical books: Blind implantation call blind implantation methods."
    },
    {
        "id": "3",
        "value": "A guy with hypermnesia (Pathology) is capable of storing idea in an extraordinarily efficient manner."
    }
]
EOF
   
```

#### Résultats :
```
[
    {
        "id": "18",
        "value": [
            {
                "idx": "1-5",
                "text": "Mem-Pro-Clinic test",
                "lemma": "mem - pro-clinic test",
                "id": "http://data.loterre.fr/ark:/67375/P66-WG17XBG4-V"
            },
            {
                "idx": "19-21",
                "text": "prospective thoughts",
                "lemma": "prospective thought",
                "id": "http://data.loterre.fr/ark:/67375/P66-VLJ0CQH4-G"
            },
            {
                "idx": "27-31",
                "text": "long-term memory",
                "lemma": "long - term memory",
                "id": "http://data.loterre.fr/ark:/67375/P66-J8FC45M1-6"
            }
        ]
    },
    {
        "id": "27",
        "value": [
            {
                "idx": "12-15",
                "text": "blind implantation methods",
                "lemma": "blind implantation method",
                "id": "http://data.loterre.fr/ark:/67375/P66-D6XL3PDR-M"
            }
        ]
    },
    {
        "id": "35",
        "value": [
            {
                "idx": "3-7",
                "text": "hypermnesia (Pathology)",
                "lemma": "hypermnesia ( pathology )",
                "id": "http://data.loterre.fr/ark:/67375/P66-FQXK8KBN-C"
            }
        ]
    }
]
```
