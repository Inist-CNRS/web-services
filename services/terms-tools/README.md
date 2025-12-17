# Loterre Terms-Matcher

**Loterre Terms-Matcher** est outil accessible par WebService qui permet la reconnaissance de termes Loterre [https://loterre.istex.fr/fr/](https://loterre.istex.fr/fr/) dans un texte, en français et en anglais

## Accès au service   

### URL du service 

> https://terms-tools.services.istex.fr/v1/CODE_LANGUE/terms-matcher/annotate?format=FORMAT&loterreID=CODE_VOC

### Parametres

**- CODE_LANGUE** = deux langues disponibles   [ fr | en ]  

**- FORMAT** = Trois types de sorties proposées  [ json-standoff | json-indoc |  xml-standoff  ]  


|  format | description |
| :--------------- | :--------------- |
| json-standoff | liste des termes reconnus sous le forme json |
| json-indoc| document avec les termes identifiés, format json id, value |
| xml-standoff | liste des termes reconnus sous la forme xml (format loterre annotator widget) |

**- CODE_VOC** = voir la [liste des codes vocabulaires](#liste-des-vocabulaires)  


## Exemples

- Dans un texte anglais, identification des termes appartenant au vocabulaire "Psychologie cognitive de la mémoire humaine"  https://loterre.istex.fr/P66/  dont le loterreID est P66 :

### Requête 

```
cat <<EOF | curl -v --proxy "" -X POST --data-binary @- https://terms-tools.services.istex.fr/v1/en/terms-matcher/annotate?format=<FORMAT>&loterreID=P66
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

- Sortie avec les termes annotés dans le texte initial => format=json-indoc   

 Le marquage des termes suit la convention markdown pour la représentation des hyperliens : [TERM](ID du concept)   
 **NB** : ATTENTION !! En francais, le texte rendu n'est pas la version initiale mais la version lemmatisée  

```
[
   {
      "id":"18",
      "value":"the [Mem-Pro-Clinic test](http://data.loterr.fr/ark:/67375/P66-WG17XBG4-V) is a clinical test to assess difficulties in [events](http://data.loterre.fr/ark:/67375/P66-ZVGCX1H2-G)- and time-based [prospective thought](http://data.loterre.fr/ark:/67375/P66-VLJ0CQH4-G). this   implies that activated [long-term memory](http://data.loterre.fr/ark:/67375/P66-J8FC45M1-6) provides a representational basis for semantic verbal short-term signal."
   },
   {
      "id":"27",
      "value":"a new method to implant false autobiographical books: blind implantation call [blind implantation method](http://data.loterre.fr/ark:/67375/P66-D6XL3PDR-M)."
   },
   {
      "id":"35",
      "value":"a guy with [hypermnesia](http,://data.loterre.fr/ark:/67375/P66-JX046THS-T) is capable of storing idea in an extraordinarily efficient manner."
   }
]
```
  
- Sortie au format xml  => format=xml-standoff  

NB : Ne tolère qu'un seul enregistrement (value) par envoi.  
```
<?xml version="1.0" encoding="UTF-8"?>
<result><text><tag idx_start="4" idx_end="23" id="http://data.loterre.fr/ark:/67375/P66-WG17XBG4-V" text="mem-pro-clinic test" termeReconnu="Mem-Pro-Clinic test" pref="Mem-Pro-Clinic test" lang="en"/><tag idx_start="69" idx_end="74" id="http://data.loterre.fr/ark:/67375/P66-ZVGCX1H2-G" text="event" termeReconnu="events" pref="event" lang="en"/><tag idx_start="91" idx_end="111" id="http://data.loterre.fr/ark:/67375/P66-VLJ0CQH4-G" text="prospective thoughts" termeReconnu="prospective thought" pref="predictive brain" lang="en"/><tag idx_start="118" idx_end="124" id=" " lang="en"/><tag idx_start="148" idx_end="164" id="http://data.loterre.fr/ark:/67375/P66-J8FC45M1-6" text="long-term memory" termeReconnu="long-term memory" pref="long-term memory" lang="en"/></text><text><tag idx_start="78" idx_end="104" id="http://data.loterre.fr/ark:/67375/P66-D6XL3PDR-M" text="blind implantation methods" termeReconnu="blind implantation method" pref="blind implantation method" lang="en"/></text><text><tag idx_start="11" idx_end="34" id="http://data.loterre.fr/ark:/67375/P66-FQXK8KBN-C" text="hypermnesia (pathology)" termeReconnu="hypermnesia (pathology)" pref="hypermnesia (pathology)" lang="en"/></text></result>
```

## Liste des vocabulaires  

|Code| Nom du vocabulaire (01/12/2025)|Etat|
|:---:|:----|:----|
|1WB|Heat transfers|disponible|
|26L|Earth Sciences|disponible|
|27X|Art and Archaeology|disponible|
|2CX|SantéPsy (thesaurus)|disponible fr|
|2QZ|Fluid mechanics|disponible|
|37T|Chemistry|disponible|
|3JP|Social Sciences|disponible|
|3WV|Ecotoxicology (thesaurus)|disponible|
|45G|Geographic Places (GP) Terminology Resource (Getty Research Institute)|non disponible|
|4V5|History and Sciences of Religions|disponible|
|73G|Philosophy|disponible|
|8HQ|Periodic table of the elements (thesaurus)|disponible|
|8LP|Vocabulary of natural language processing (POC)|disponible|
|9SD|Countries and subdivisions (thesaurus)|disponible|
|ADM|Administrative Sciences|disponible|
|ASYSEL|Agriculture and breeding systems|disponible|
|B9M|Primatology (thesaurus)|disponible|
|BJW|Electrical engineering - Electro-energetics|disponible|
|BL8|Artificial Nutrition (thesaurus)|disponible|
|BLH|Biodiversity (thesaurus)|disponible|
|BQ7|Corporate Bodies (CB) Terminology Resource (Getty Research Institute)|non disponible|
|BRMH|Reproduction biotechnology|disponible|
|BVM|NETSCITY Toponyms (France)|disponible|
|C0X|Covid-19 (thesaurus)|disponible|
|CHC|Climate change (Thesaurus)|disponible|
|CUEX|Extrusion cooking|disponible|
|D63|French Communes (thesaurus)|disponible|
|DOM|Scientific fields|disponible|
|EMTD|Microbial ecology of the digestive tract|disponible|
|ERC|ERC panel structure|disponible|
|FMC|Optics|disponible|
|G9G|Fish Taxonomy|disponible|
|GGMGG|Glossary of molecular genetics and genetic engineering|disponible|
|GT|Thematic Vocabulary of Geography|non disponible|
|HTR|Artist Location (TAL) Terminology Resource (Getty Research Institute)|non disponible|
|IDIA|Ionization in food industry|disponible|
|INS|Health at the INSB (Proof of concept)|non disponible|
|JLC|Subjects (SH) Terminology Resource (Getty Research Institute)|non disponible|
|JVN|Personal Names (PN) Terminology Resource (Getty Research Institute)|non disponible|
|JVR|Medical Subject Headings (thesaurus)|disponible|
|KFP|Chemical Entities of Biological Interest Ontology (CHEBI)|non disponible|
|KG7|Geography of North America|disponible|
|KW5|Ethnology|disponible|
|LTK|ThesoTM thesaurus|disponible|
|MDL|Astronomy (thesaurus)|disponible|
|N9J|SAGE Social Science Thesaurus|non disponible|
|NHT|Condensed matter physics|disponible|
|P21|Litterature|disponible|
|P66|Cognitive psychology of human memory (CogMemo thesaurus)|disponible|
|PAN|Sourdough breadmaking glossary|disponible fr|
|PLP|Pedology lexicon|disponible|
|PSR|Mathematics (thesaurus)|disponible|
|Q1W|Agri-food vocabulary|disponible|
|QJP|Engineering sciences vocabulary|disponible|
|QX8|Paleoclimatology (thesaurus)|disponible|
|RDR|Electronics - Optoelectronics|disponible|
|RVQ|Inorganic compounds (thesaurus)|disponible|
|SCO|Sections of the National Committee for Scientific Research (Proof of concept)|non disponible|
|SEN|Health and environment (proof of concept)|non disponible|
|SN8|Signal theory and processing|disponible|
|TECSEM|Technology of seeds|disponible|
|TSM|Membrane-based separation techniques|disponible|
|TSO|Open science (thesaurus)|disponible|
|TSP|Public Health (thesaurus)|disponible fr|
|Theremy|Taxonomy & Thesaurus for Health Research Methodology (THEREMY)|disponible en|
|VH8|Human Diseases (thesaurus)|disponible|
|VPAC|Vocabulary of the Common Agricultural Policy|disponible|
|W7B|Blood Transfusion (thesaurus)|disponible|
|X64|Linguistics|disponible|
|XD4|History of Science and Technology|disponible|
|ZHG|Conference Exhibition (CX) Terminology Resource (Getty Research Institute)|non disponible|
|th63|Zoological Nomenclature (thesaurus)|disponible|
|216|Educational sciences|disponible|
|905|Prehistory and Protohistory|disponible|
