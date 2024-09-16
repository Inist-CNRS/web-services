terms_tools
===============  

Bibliothèque d'outils pour l'etiquettage POS et la reconnaissance de termes (construite au dessus de stanza)  

## POStag et lemmatisation une liste de termes en francais et en anglais  

### INPUT  
exemple : test_labelEN.tsv'  
id      text  
http://data.loterre.fr/ark:/67375/P66#xl_en_9278939f    qualities  
http://data.loterre.fr/ark:/67375/P66#xl_en_696ab94f    material entities  
http://data.loterre.fr/ark:/67375/P66#xl_en_d9fccd58    process  
http://data.loterre.fr/ark:/67375/P66#xl_en_0fa9a1f2    empirical effect  
http://data.loterre.fr/ark:/67375/P66#xl_en_ba359dd0    empirical generalization  
http://data.loterre.fr/ark:/67375/P66#xl_en_06b45a8a    general empirical observation  
http://data.loterre.fr/ark:/67375/P66#xl_en_d9a365b6    empirical generalisations  

### Trois types d'OUTPUT sont disponibles  :  

#### sous la forme d'un dictionaire jsonld avec l ensemble des informations (option -o json)  
Exemple de sortie :   
http://data.loterre.fr/ark:/67375/P66#xl_en_53acd26b     [{"id": 0, "start": 0, "end": 7, "tag": "JJ", "pos": "ADJ", "morph": "Degree=Pos", "lemma": "general"}, {"id": 1, "start": 8, "end": 17, "tag": "JJ", "pos": "ADJ", "morph": "Degree=Pos", "lemma": "empirical"}, {"id": 2, "start":18, "end": 30, "tag": "NNS", "pos": "NOUN", "morph": "Number=Plur", "lemma": "observation"}]  

##### WebService
```
ROUTE = /v1/en/dic_pos/postag?input=terms**  
URL =    
   
 curl -X 'POST' '$URL/v1/en/dic_pos/postag?input=terms' --data-binary '@../terms_tools/test/data/test_labelEN.tsv'  

 curl -X 'POST' '$URL/v1/fr/dico_pos/postag?input=terms' --data-binary '@../terms_tools/test/data/test_labelFR.tsv'  
 ```

#### sous une forme tabulée simplifiée, format :    URI   POSTAG LEMMA      (option -o dico_pos)  
Exemple de sortie :   
http://data.loterre.fr/ark:/67375/P66#xl_en_542d3e8b     cognitive qualities    JJ NNS  cognitive quality  
http://data.loterre.fr/ark:/67375/P66#xl_en_9ac2b72c     cognitive quality      JJ NN   cognitive quality  
http://data.loterre.fr/ark:/67375/P66#xl_en_ef4050c0     objects        NNS     object  

##### WebService
``` 
ROUTE = v1/en/dic_annot/postag?input=terms
URL =    

 curl -X 'POST' '$URL/v1/en/dico_annot/postag?input=terms' --data-binary '@../terms_tools/test/data/test_labelEN.tsv'    

 curl -X 'POST' '$URL/v1/fr/dico_annot/postag?input=terms' --data-binary '@../terms_tools/test/data/test_labelFR.tsv'   
```

#### sous la forme d'un dictionnaire pour termMatcher  
Exemple de sortie :  
http://data.loterre.fr/ark:/67375/P66#xl_en_d2b95b32     {"label": "empirical generalisation ", "pattern": [{"pos": "ADJ", "lemma": "empirical"}, {"pos": "NOUN", "lemma": "generalisation"}], "id": "http://data.loterre.fr/ark:/67375/P66#xl_en_d2b95b32"}  

##### WebService
```
ROUTE = v1/en/full_morph/postag?input=terms
URL =  
  
 curl -X 'POST' '$URL/v1/en/full_morph/postag?input=terms' --data-binary '@../terms_tools/test/data/test_labelEN.tsv'  

 curl -X 'POST' '$URL/v1/fr/full_morph/postag?input=terms' --data-binary '@../terms_tools/test/data/test_labelFR.tsv'  
  ```

## Reconnaisance de termes

A venir  