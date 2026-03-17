# Loterre Terms-Matcher

**Loterre Terms-Matcher** est outil accessible par WebService qui permet la reconnaissance de termes Loterre [https://loterre.istex.fr/fr/](https://loterre.istex.fr/fr/) dans un texte, en français et en anglais.

## Accès au service  

#### URL du service 

> https://terms-tools.services.istex.fr/v1/CODE_LANGUE/terms-matcher/FORMAT/annotate?loterreID=CODE_VOC

#### Parametres

**- CODE_LANGUE** = Deux langues sont disponibles [ fr | en ]  

**- FORMAT** = Trois types de sorties sont proposées  [ json-standoff | json-indoc ]  


|  format | description |
| :--------------- | :--------------- |
| json-standoff | liste des termes reconnus, format json |
| json-indoc | document avec les termes identifiés, format json |

**- CODE_VOC** = voir la [liste des codes vocabulaires](#liste-des-vocabulaires)  


## Exemples

- Dans un texte anglais, identification des termes appartenant au vocabulaire "Psychologie cognitive de la mémoire humaine"  https://loterre.istex.fr/P66/  dont le loterreID est P66 :

### Requête 

```
cat <<EOF | curl -v --proxy "" -X POST --data-binary @- https://terms-tools.services.istex.fr/v1/en/terms-matcher/FORMAT/annotate?loterreID=P66
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

###  Sortie au format 'json standoff' :
 FORMAT = json-standoff  
>https://terms-tools.services.istex.fr/v1/en/terms-matcher/json-standoff/annotate?loterreID=P66

|nom du champ|contenu|
|:---:|:---|
| doc | le texte original avec de repérage des termes (markdown) |
|idx | position des termes dans le texte|
|text | fragment de texte qui a matché| 
|term | le terme du vocabulaire qui a matché|
|id | id du concept|
```
[
  {
    "id": "18",
    "value": [
      {
        "doc": "The [Mem-Pro-Clinic test](http://data.loterre.fr/ark:/67375/P66-WG17XBG4-V) is a clinical test to assess difficulties in event- and time-based [prospective thoughts](http://data.loterre.fr/ark:/67375/P66-VLJ0CQH4-G) . This result implies that activated [long-term memory](http://data.loterre.fr/ark:/67375/P66-J8FC45M1-6) provides a representational basis for semantic verbal short-term signal.",
        "matches": [
          {
            "idx": {
              "start": "1",
              "end": "7"
            },
            "match": {
              "id": "http://data.loterre.fr/ark:/67375/P66-WG17XBG4-V",
              "text": "Mem-Pro-Clinic test",
              "term": "Mem-Pro-Clinic test"
            }
          },
          {
            "idx": {
              "start": "20",
              "end": "22"
            },
            "match": {
              "id": "http://data.loterre.fr/ark:/67375/P66-VLJ0CQH4-G",
              "text": "prospective thoughts",
              "term": "prospective thought"
            }
          },
          {
            "idx": {
              "start": "28",
              "end": "32"
            },
            "match": {
              "id": "http://data.loterre.fr/ark:/67375/P66-J8FC45M1-6",
              "text": "long-term memory",
              "term": "long-term memory"
            }
          }
        ]
      }
    ]
  },
  {
    "id": "27",
    "value": [
      {
        "doc": "A new method to implant false autobiographical books: Blind implantation call implantation methods](http://data.loterre.fr/ark:/67375/P66-D6XL3PDR-M) .",
        "matches": [
          {
            "idx": {
              "start": "12",
              "end": "15"
            },
            "match": {
              "id": "http://data.loterre.fr/ark:/67375/P66-D6XL3PDR-M",
              "text": "blind implantation methods",
              "term": "blind implantation method"
            }
          }
        ]
      }
    ]
  },
  {
    "id": "35",
    "value": [
      {
        "doc": "A guy with [hypermnesia ( Pathology )](http://data.loterre.fr/ark:/67375/P66-FQXK8KBN-C) is capable of storing idea in an extraordinarily efficient manner.",
        "matches": [
          {
            "idx": {
              "start": "3",
              "end": "7"
            },
            "match": {
              "id": "http://data.loterre.fr/ark:/67375/P66-FQXK8KBN-C",
              "text": "hypermnesia (Pathology)",
              "term": "hypermnesia (pathology)"
            }
          }
        ]
      }
    ]
  }
]
```

### Sortie avec les termes annotés dans le texte initial :
  FORMAT = json-indoc  
>https://terms-tools.services.istex.fr/v1/en/terms-matcher/json-indoc/annotate?loterreID=P66  

 Le marquage des termes suit la convention markdown pour la représentation des hyperliens : [TERM](ID du concept)  

```
[
  {
    "id": "18",
    "value": "The [Mem-Pro-Clinic test](http://data.loterre.fr/ark:/67375/P66-WG17XBG4-V) is a clinical test to assess difficulties in event- and time-based [prospective thoughts](http://data.loterre.fr/ark:/67375/P66-VLJ0CQH4-G) . This result implies that activated [long-term memory](http://data.loterre.fr/ark:/67375/P66-J8FC45M1-6) provides a representational basis for semantic verbal short-term signal."
  },
  {
    "id": "27",
    "value": "A new method to implant false autobiographical books: Blind implantation call [blind implantation methods](http://data.loterre.fr/ark:/67375/P66-D6XL3PDR-M) ."
  },
  {
    "id": "35",
    "value": "A guy with [hypermnesia ( Pathology )](http://data.loterre.fr/ark:/67375/P66-FQXK8KBN-C) is capable of storing idea in an extraordinarily efficient manner."
  }
]
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
