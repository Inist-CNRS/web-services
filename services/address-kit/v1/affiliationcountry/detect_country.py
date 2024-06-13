#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 31 16:36:28 2022

@author: cuxac
"""

from geopy.geocoders import Nominatim
#import time
import functools
import unidecode
import re
#import pycountry
from iso3166 import countries
import json
import sys

osm = Nominatim(timeout=60,user_agent='inistTDM')

locator = functools.lru_cache(maxsize=128)(functools.partial(osm.geocode, timeout=60,language='en'))
locator_rev = functools.lru_cache(maxsize=128)(functools.partial(osm.reverse, timeout=60,language='en'))

#fin=json.loads(json.dumps([{
#        "id":1,
#        "value":"université sciences et technologies bordeaux 1 institut national de physique nucléaire et de physique des particules du cnrs in2p3 UMR5797"},
#    {"id":2,
#    "value":"uar76 / ups76 centre national de la recherche scientifique cnrs institut de l'information scientifique et technique inist"},
#    {"id":3,
#    "value":"centre de recherches sur la géologie des matières premières minérales et énergétiques cregu université de lorraine ul umr7359 centre national de la recherche scientifique"},
#    {"id":4,
#     "value":"auf der morgenstelle 8, 72076 tuebingen"
#      },
#    {"id":5,
#     "value":"z.i. de kermelin,16, rue ampère,  56017 Vannes"
#     },
#     {"id":6,
#      "value":"campus de santa apolónia, 5300-253 bragança"},
#     {"id":7,
#      "value":"campus romanus de maron"}  ,
#      {"id":8,
#       "value":"Inist-CNRS, vandoeuvre les Nancy, France"}
#        ]))



def placeaddress(address):
    place, (lat, lng)=locator(address)
    res=locator_rev(str(lat)+","+str(lng))
    try :
        country=res.raw['address']['country']
    except KeyError:
        country=res.raw['address']['country_code']
    try:
        village=res.raw['address']['village']
    except KeyError:
        village=''
    return country,lat,lng,village

#for line in fin:
for line in sys.stdin:
    country=""
    data=json.loads(line)
    aff=data['value']
    lines=aff.replace('"','')

    adr=lines.strip()
    adr=adr.replace('&amp;',';')
    ad=adr.split(';')
    ads=[i.strip() for i in ad]

    for a in set(ads) :

        a=a.lower()
        a=a.replace('cedex','')
        a=re.sub(' U[0-9]+','',a,flags=re.IGNORECASE)
        a=re.sub("both in ",'',a,flags=re.IGNORECASE)
        a=re.sub(' UMR[0-9]+','',a,flags=re.IGNORECASE)
        a=a.replace('...',' ')
        a=a.replace('_',' ')

        a=re.sub('\([a-zA-Z0-9 ,:\–]+\)','',a)

        ##-1 on traite avec libpostal et on regarde s'il y a un pays
        #nl=parse_address(a.strip().strip('.'))
        #d=dict(map(reversed,nl))
        
        ars=re.split(',|:',a)
        if re.match(r'u[amsrp]+ ?[0-9]+',a):
            country='France'
        else:
            try:
                #country=d['country']
                country=countries.get(ars[-1].strip()).name
    #            if len(country)==3:
    #                cd=country.upper()
    #                #x=pycountry.countries.get(alpha_3=cd)
    #                country=countries.get(cd).name
    #                
    #                #country=x.name
                country=placeaddress(country)[0]
    
    
            except (KeyError,TypeError) as error:
                #- 2 s'il n'y a pas de pays avec libpostal on essaye avec nominatim de trouver un pays
    
                try:
    
                    country=placeaddress(a)[0]
    
                    if placeaddress(a)[3].lower()!=a.lower():
    
    
                        country=country
    
                #-3 si ça ne fonctionne pas on essaye de spliter l'adresse et de traiter les éléments séparéément
                except (KeyError,TypeError) as error:
    
                    a=a.lower()
                    a2=''
    
                    if "university" in unidecode.unidecode(a).lower():#.split()[:-1]:
    
                        a1=re.findall("faculty of [a-zA-Z]+",unidecode.unidecode(a), flags=re.IGNORECASE)
                        a11=re.findall("college of [a-zA-Z]+",unidecode.unidecode(a), flags=re.IGNORECASE)
                        if len(a1)>0:
                            a=a.replace(a1[0],'')           
                        if len(a11)>0:
                            a=a.replace(a11[0],'')
                        if "university" in a.lower().split()[:-1]:
                    
                            a=a.replace(' hospital ',' ')
    
                            a2=re.findall("university [a-zA-Z&]+",unidecode.unidecode(a), flags=re.IGNORECASE)
                            if len(a2)>1:
                            
                                a3=a2[0].replace("university of ","university ")
                            if len(a2)<1:
                                a2=unidecode.unidecode(a).lower().replace('university','$ university').split('$ ')
                            a2.insert(0,a3)
                            try:
                                a2.remove('university of science')
                            except ValueError:
                                uos=0
                        elif ("university" ==a.split()[-1].lower()) or ("university," in a.lower()):
                            a2=re.findall("[ a-zA-Z]+ university",unidecode.unidecode(a), flags=re.IGNORECASE)
                            a2.insert(0,'')
    
                    elif "universite " in unidecode.unidecode(a).lower():
    
                        a2=re.findall("universite (?:[A-Za-z]+\s){1}[A-Za-z]+",unidecode.unidecode(a), flags=re.IGNORECASE)
                        a3=re.findall("(?:[A-Za-z]+\s){1}[A-Za-z]+ universite",unidecode.unidecode(a), flags=re.IGNORECASE)
                        if len(a3)==0:
                            a3=[' ']
                        a2.insert(0,a3[0])
                        if len(a2)<2:
                            a2=unidecode.unidecode(a).lower().replace('universite','$ universite').split('$ ')
    
                    elif "universidad " in unidecode.unidecode(a).lower():
                        a2=re.findall("universidad [ a-zA-Z]+",unidecode.unidecode(a), flags=re.IGNORECASE)
                        a2.insert(0,'')
                        if len(a2)<2:
                            a2=unidecode.unidecode(a).lower().replace('universidad','$ universidad').split('$ ')
       
                    elif "universitat " in unidecode.unidecode(a).lower():
                        a2=re.findall("universitat [ a-zA-Z]+",unidecode.unidecode(a), flags=re.IGNORECASE)
                        a2.insert(0,'')
                        if len(a2)<2:
                            a2=unidecode.unidecode(a).lower().replace('universitat','$ universitat').split('$ ')
    
                    elif "hopital " in unidecode.unidecode(a).lower():
                        a2=re.findall("hopital [a-zA-Z']+",unidecode.unidecode(a), flags=re.IGNORECASE)
                        a2.insert(0,'')
    
                    elif ("chu" and "chru") in unidecode.unidecode(a).lower():
                        if ("chu de " and "chru de ") in unidecode.unidecode(a).lower():
                            a2=re.findall("ch[r]?u de [a-zA-Z']+",unidecode.unidecode(a), flags=re.IGNORECASE)
                            a2.insert(0,'')
                        else:
                            
                            a2=re.findall("ch[r]?u [a-zA-Z']+",unidecode.unidecode(a), flags=re.IGNORECASE)
                            a3=a2[0].replace("chru","chu")
                            a2.insert(0,a3)
                   
                    elif ',' in a: 
                        a2=a.split(',')
    
                    elif ':' in a:
                        a2=a.split(':')
    
                    elif " et " in a.split()[:-2]:
    
                        a2=a.split(' et ')
    
                    elif (' — ' and ' - ') in a:
    
                        if ' — ' in a:
                            a2=a.split(' — ')
                        else:
                            a2=a.split(' - ')
                    elif ' an der ' in a:
    
                        a2=a.split(' an der ')
                    elif '-' in a:
    
                        a2=re.findall(r'\w+(?:-\w+)+',a)
                        a2.insert(0,'')
    
                    if len(a2)>1:
                        lon=1
                        for aa in reversed(a2):
                            aa=aa.strip()
                            #time.sleep(1)
                            try:
    
                                country=placeaddress(aa)[0]
                                lat=placeaddress(aa)[1]
                                lng=placeaddress(aa)[2]
    
                                break
                            except TypeError:
                                to=1
    
                                if lon==len(a2):
                                    country="unknown"
    
                            lon+=1
#                                    
#                    elif re.match(r'u[amsrp]+ ?[0-9]+',a):
#                            country='France'
                    else: 
                        country="Unknown"
    try:
        data["value"]=[country, countries.get(country).alpha3]
    except KeyError:
        data["value"]=[country, 'N/A']
    sys.stdout.write(json.dumps(data))
    sys.stdout.write('\n')

                    
            
        


