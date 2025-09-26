# terms_tools

terms_tools est une bibliothèque d'outils qui permet :  
- l'étiquetage en partie du discours (POStag) d'une liste de termes,  
- la reconnaissance de termes Loterre [https://loterre.istex.fr/fr/](https://loterre.istex.fr/fr/) dans un document,  
  
En français et en anglais

## POSTag et lemmatisation d'une liste de termes  

### INPUT

Prnd un fichier tsv en entrée
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

### Trois types de sorties sont disponibles  

#### Sous la forme d'un dictionnaire avec l'ensemble des informations morpho syntaxique => option -o json

##### Exemple de sortie :  

```tsv
http://data.loterre.fr/ark:/67375/P66#xl_en_53acd26b	[{"id": 0, "start": 0, "end": 7, "tag": "JJ", "pos": "ADJ", "morph": "Degree=Pos", "lemma": "general"}, {"id": 1, "start": 8, "end": 17, "tag": "JJ", "pos": "ADJ", "morph": "Degree=Pos", "lemma": "empirical"}, {"id": 2, "start":18, "end": 30, "tag": "NNS", "pos": "NOUN", "morph": "Number=Plur", "lemma": "observation"}]
```
##### WebService :  

```bash  
ROUTE = v1/en/full-morph/postag?input=terms  
URL = https://terms-tools.services.istex.fr  

curl -X 'POST' '$URL/v1/en/full-morph/postag?input=terms' --data-binary '@../terms_tools/data/test_labelEN.tsv'  

curl -X 'POST' '$URL/v1/fr/full-morph/postag?input=terms' --data-binary '@../terms_tools/data/test_labelFR.tsv'  
```


#### Sous une forme tabulée aux informations simplifiées  => option -o dico_pos
        
 format :   URI   POSTAG LEMMA    

##### Exemple de sortie :  

```tsv
http://data.loterre.fr/ark:/67375/P66#xl_en_542d3e8b	cognitive qualities	JJ NNS	cognitive quality
http://data.loterre.fr/ark:/67375/P66#xl_en_9ac2b72c	cognitive quality	 JJ NN	cognitive quality
http://data.loterre.fr/ark:/67375/P66#xl_en_ef4050c0	objects	NNS	object  
```


##### WebService :

```bash
ROUTE = /v1/en/dico-pos/postag?input=terms    
URL = https://terms-tools.services.istex.fr    

curl -X 'POST' '$URL/v1/en/dico-pos/postag?input=terms' --data-binary '@../terms_tools/data/test_labelEN.tsv'  

curl -X 'POST' '$URL/v1/fr/dico-pos/postag?input=terms' --data-binary '@../terms_tools/data/test_labelFR.tsv'  
```



#### Sous la forme d'un dictionnaire pour un Matcher Spacy

##### Exemple de sortie :  

```tsv
http://data.loterre.fr/ark:/67375/P66#xl_en_d2b95b32	{"label": "empirical generalisation ", "pattern": [{"pos": "ADJ", "lemma": "empirical"}, {"pos": "NOUN", "lemma": "generalisation"}], "id": "http://data.loterre.fr/ark:/67375/P66#xl_en_d2b95b32"}  

```

##### WebService :  

```bash
ROUTE = v1/en/dico-annot/postag?input=terms  
URL =  https://terms-tools.services.istex.fr   

curl -X 'POST' '$URL/v1/en/dico-annot/postag?input=terms' --data-binary '@../terms_tools/data/test_labelEN.tsv'

curl -X 'POST' '$URL/v1/fr/dico-annot/postag?input=terms' --data-binary '@../terms_tools/data/test_labelFR.tsv'
```



## Reconnaissance de termes Loterre

Ce service projete un vocabulaire sur un texte afin d'identifier toutes les occurrences de termes présents dans ce texte, en francais ou en anglais, voir la [Liste des vocabulaires](#liste-des-vocabulaires) disponibles sur Loterre [https://loterre.istex.fr/fr/](https://loterre.istex.fr/fr/).  

##### WebService :  

```
ROUTE = /v1/<CODE_LANGUE>/terms_matcher/<CODE_VOC>/format=<FORMAT>  
URL = https://terms-tools.services.istex.fr  
```

##### Parametres :

<CODE_LANGUE> = fr, en

<FORMAT> = json-standoff | json-indoc |  xml-standoff  
|  format | description |
| :--------------- | :--------------- |
| json-standoff | liste des termes reconnus sous le forme json |
| json-indoc| document avec les termes identifiés, format json id, value |
| xml-standoff | liste des termes reconnus sous le forme xml (loterre widget) |

<CODE_VOC> = voir la liste des codes( ) 


#### Exemples :

- Dans un texte anglais, identification des termes appartenant au vocabulaire  https://loterre.istex.fr/P66/  :  

#### Requête :  

```
cat <<EOF | curl -v --proxy "" -X POST --data-binary @- https://terms-tools.services.istex.fr/v1/en/terms-matcher/P66?<FORMAT>
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

- Sortie au format json standoff => format=json-standoff  

|nom du champ|contenu|
|:---:|:---|
|idx | position des termes dans le texte|
|ul | forme du texte qui a matché| 
|term | le terme du vocabulaire qui a matché|
|pref | préférentiel dans la langue|
|id | id du concept|
```
[
   {
      "id":"1",
      "value":[
         {
            "idx":{
               "start":"4",
               "end":"23"
            },
            "match":{
               "id":"http://data.loterre.fr/ark:/67375/p66-wg17xbg4-v",
               "ul":"mem-pro-clinic test",
               "term":"mem-pro-clinic test",
               "pref":"mem-pro-clinic test"
            }
         },
         {
            "idx":{
               "start":"91",
               "end":"111"
            },
            "match":{
               "id":"http://data.loterre.fr/ark:/67375/p66-vlj0cqh4-g",
               "ul":"prospective thoughts",
               "term":"prospective thought",
               "pref":"predictive brain"
            }
         },
         {
            "idx":{
               "start":"118",
               "end":"124"
            },
            "match":{
               "id":" "
            }
         },
         {
            "idx":{
               "start":"148",
               "end":"164"
            },
            "match":{
               "id":"http://data.loterre.fr/ark:/67375/p66-j8fc45m1-6",
               "ul":"long-term memory",
               "term":"long-term memory",
               "pref":"long-term memory"
            }
         }
      ]
   },
   {
      "id":"2",
      "value":[
         {
            "idx":{
               "start":"78",
               "end":"104"
            },
            "match":{
               "id":"http://data.loterre.fr/ark:/67375/p66-d6xl3pdr-m",
               "ul":"blind implantation methods",
               "term":"blind implantation method",
               "pref":"blind implantation method"
            }
         }
      ]
   },
   {
      "id":"3",
      "value":[
         {
            "idx":{
               "start":"11",
               "end":"34"
            },
            "match":{
               "id":"http://data.loterre.fr/ark:/67375/p66-fqxk8kbn-c",
               "ul":"hypermnesia (pathology)",
               "term":"hypermnesia (pathology)",
               "pref":"hypermnesia (pathology)"
            }
         }
      ]
   }
]"s"
```

- Sortie avec les termes annoté dans le texte initial => format = json-indoc   

 Le marquage des termes suit la convention : TERM||terme||id du concept   
 NB : En francais, le texte rendu est la version lemmatisée  

```
[
   {
      "id":"18",
      "value":"the TERM||mem-pro-clinic test||http://data.loterre.fr/ark:/67375/p66-wg17xbg4-v is a clinical test to assess difficulties in event- and time-based TERM||prospective thought||http://data.loterre.fr/ark:/67375/p66-vlj0cqh4-g. this implies that activated TERM||long-term memory||http://data.loterre.fr/ark:/67375/p66-j8fc45m1-6 provides a representational basis for semantic verbal short-term signal."
   },
   {
      "id":"27",
      "value":"a new method to implant false autobiographical books: blind implantation call TERM||blind implantation method||http://data.loterre.fr/ark:/67375/p66-d6xl3pdr-m."
   },
   {
      "id":"35",
      "value":"a guy with TERM||hypermnesia (pathology)||http://data.loterre.fr/ark:/67375/p66-fqxk8kbn-c is capable of storing idea in an extraordinarily efficient manner."
   }
]
```

### Liste des vocabulaires

|Code| Nom du vocabualire|
|:---:|:----|
|1WB|Heat transfers|
|26L|Earth Sciences|
|27X|Art and Archaeology|
|2CX|SantéPsy (thesaurus)|
|2QZ|Fluid mechanics|
|37T|Chemistry|
|3JP|Social Sciences|
|3WV|Ecotoxicology (thesaurus)|
|45G|Geographic Places (GP) Terminology Resource (Getty Research Institute)|
|4V5|History and Sciences of Religions|
|73G|Philosophy|
|8HQ|Periodic table of the elements (thesaurus)|
|8LP|Vocabulary of natural language processing (POC)|
|9SD|Countries and subdivisions (thesaurus)|
|ADM|Administrative Sciences|
|ASYSEL|Agriculture and breeding systems|
|BJW|Electrical engineering - Electro-energetics|
|BL8|Artificial Nutrition (thesaurus)|
|BLH|Biodiversity (thesaurus)|
|BQ7|Corporate Bodies (CB) Terminology Resource (Getty Research Institute)|
|BRMH|Reproduction biotechnology|
|BVM|NETSCITY Toponyms (France)|
|C0X|Covid-19 (thesaurus)|
|CHC|Climate change (Thesaurus)|
|CUEX|Extrusion cooking|
|D63|French Communes (thesaurus)|
|DOM|Scientific fields|
|EMTD|Microbial ecology of the digestive tract|
|ERC|ERC panel structure|
|FMC|Optics|
|G9G|Fish Taxonomy|
|GGMGG|Glossary of molecular genetics and genetic engineering|
|GT|Thematic Vocabulary of Geography|
|HTR|Artist Location (TAL) Terminology Resource (Getty Research Institute)|
|IDIA|Ionization in food industry|
|INS|Health at the INSB (Proof of concept)|
|JLC|Subjects (SH) Terminology Resource (Getty Research Institute)|
|JVN|Personal Names (PN) Terminology Resource (Getty Research Institute)|
|JVR|Medical Subject Headings (thesaurus)|
|KFP|Chemical Entities of Biological Interest Ontology (CHEBI)|
|KG7|Geography of North America|
|KW5|Ethnology|
|LTK|ThesoTM thesaurus|
|MDL|Astronomy (thesaurus)|
|N9J|SAGE Social Science Thesaurus|
|NHT|Condensed matter physics|
|P21|Litterature|
|P66|Cognitive psychology of human memory (CogMemo thesaurus)|
|PAN|Sourdough breadmaking glossary|
|PLP|Pedology lexicon|
|PSR|Mathematics (thesaurus)|
|Q1W|Agri-food vocabulary|
|QJP|Engineering sciences vocabulary|
|QX8|Paleoclimatology (thesaurus)|
|RDR|Electronics - Optoelectronics|
|RVQ|Inorganic compounds (thesaurus)|
|SCO|Sections of the National Committee for Scientific Research (Proof of concept)|
|SEN|Health and environment (proof of concept)|
|SN8|Signal theory and processing|
|TECSEM|Technology of seeds|
|TSM|Membrane-based separation techniques|
|TSO|Open science (thesaurus)|
|TSP|Public Health (thesaurus)|
|Theremy|Taxonomy & Thesaurus for Health Research Methodology (THEREMY)|
|VH8|Human Diseases (thesaurus)|
|VPAC|Vocabulary of the Common Agricultural Policy|
|W7B|Blood Transfusion (thesaurus)|
|X64|Linguistics|
|XD4|History of Science and Technology|
|ZHG|Conference Exhibition (CX) Terminology Resource (Getty Research Institute)|
|th63|Zoological Nomenclature (thesaurus)|
|216|Educational sciences|
|905|Prehistory and Protohistory|
