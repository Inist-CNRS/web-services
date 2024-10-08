#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep 23 16:16:17 2022

@author: cuxac
"""

#import ndjson
import re
import pickle
import json
import sys

   
dico_unite_pkl=open("./v1/cnrsunit/dico_codeunite_intituleunite_v071122.pkl","rb")    
dico_unite=pickle.load(dico_unite_pkl)


#fin=json.loads(json.dumps([{
#        "id":"1",
#        "value":"université sciences et technologies bordeaux 1 institut national de physique nucléaire et de physique des particules du cnrs in2p3 umr5797"},
#    {"id":"2",
#    "value":"uar76 / ups76 centre national de la recherche scientifique cnrs institut de l'information scientifique et technique inist"},
#    {"id":"3",
#    "value":"centre de recherches sur la géologie des matières premières minérales et énergétiques cregu université de lorraine ul umr7359 centre national de la recherche scientifique"},
#    {"id":"4",
#     "value":"umr_d161 institut de recherche pour le développement ird um34 aix marseille université amu umr7330 collège de france cdf institution institut national des sciences de l'univers insu cnrs umr7330 centre national de la recherche scientifique cnrs umr1410 institut national de recherche pour l'agriculture l'alimentation et l'environnement inrae centre européen de recherche et d'enseignement des géosciences de l'environnement cerege europôle méditerranéen de l'arbois"
#      },
#     {"id":"5",
#      "value":"labo toto"}
#        ]))




for line in sys.stdin:
    data=json.loads(line)
    #aff=line['value']
    aff=data['value']



    aff=aff.lower()
    c=re.findall(r'u[amsrp]+ ?[0-9]+',aff)
    cd=list(set(c))
    if len(cd)>0:

        for code in cd:
            
            code=code.lower()
            code=code.replace(' ','')
            code=code.replace('-','')
    
            try:
                if bool(dico_unite[code])==True:
                    name=dico_unite[code][0]
                    label=dico_unite[code][1]
                    rnsr=dico_unite[code][2]
                    inst=dico_unite[code][3]
                else:
                    name=''
                    label=''
                    rnsr=''
                    inst=''

                data["value"]={'name':name,'label':label,'rnsr':rnsr,'inst':inst}
                if len(dico_unite[code])>0:
                    break

            except KeyError:
     
                data["value"]={'name':'','label':'','rnsr':'','inst':''}
    else:
        data["value"]={'name':'','label':'','rnsr':'','inst':''}

        
    sys.stdout.write(json.dumps(data, ensure_ascii=False))
    sys.stdout.write('\n')
        
  
