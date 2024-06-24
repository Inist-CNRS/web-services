#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 17 15:18:10 2021

@author: cuxac

A partir d'un texte (pas d'un mot) affiche le code langue du texte (2 caractères) si ça probabilité est supérieure au seuil de 0.85

"""

import cld3
import json
import sys

# fin=json.loads(json.dumps([{
# "id":1,
# "value":"The COVID-19 pandemic, also known as the coronavirus pandemic, is an ongoing global pandemic of coronavirus disease 2019 (COVID-19) caused by severe acute respiratory syndrome coronavirus2 (SARS-CoV-2). It was first identified in December 2019 in Wuhan, China. The World Health Organization declared the outbreak a Public Health Emergency of International Concern on 20 January 2020, and later a pandemic on 11 March 2020. As of 2 April 2021, more than 129 million cases have been confirmed, with more than 2.82 million deaths attributed to COVID-19, making it one of the deadliest pandemics in history."
# },
# {"id":2,
# "value":"In the southern French Massif Central, the Montagne Noire axial zone is a NE-SW elongated granite-migmatite dome emplaced within Visean south-verging recumbent folds and intruded by syn- to late-migmatization granitoids. The tectonic setting of this dome is still disputed, thus several models have been proposed. In order to better understand the emplacement mechanism of this dome, petrofabric and Anisotropy of Magnetic Susceptibility (AMS) studies have been carried out. In the granites and migmatites that form the dome core, magmatic texture and to a lesser extent weak solid-state texture are dominant. As a paramagnetic mineral, biotite is the main carrier of the magnetic susceptibility. On the basis of 135 AMS sites, the magnetic fabrics appear as independent of the lithology but related to the dome architecture. Coupling our results with previous structural and geochronological studies, allows us to propose a new emplacement model. Between 340-325 Ma, the Palaeozoic series underwent a compressional deformation represented by nappes and recumbent folds involving the thermal event leading to partial melting. Until ~325-310 Ma, the dome emplacement was assisted by diapiric processes. An extensional event took place at 300 Ma, after the emplacement of the late to post-migmatitic granitic plutons. In the northeast side of the dome, a brittle normal-dextral faulting controlled the opening of the Graissessac coal-basin."
# },
# {"id":3,
# "value":"La pandémie de Covid-19 est une pandémie d'une maladie infectieuse émergente, appelée la maladie à coronavirus 2019 ou Covid-19, provoquée par le coronavirus SARS-CoV-2, apparue à Wuhan le 16 novembre 20193, dans la province de Hubei (en Chine centrale), avant de se propager dans le monde. L'Organisation mondiale de la santé (OMS) alerte dans un premier temps la République populaire de Chine et ses autres états membres, puis prononce l'état d'urgence de santé publique de portée internationale le 30 janvier 2020."}
# ,
# {"id":4,
# "value":"Au dernier recensement de 2018, la commune comptait 46 513 habitants appelés les Carcassonnais. Carcassonne est la ville principale de la Carcassonne Agglo 111 452 habitants (2016), de l'aire urbaine de Carcassonne 99 448 habitants (2017)1 et de son unité urbaine qui compte 48 633 habitants (2017). Occupée depuis le Néolithique, Carcassonne se trouve dans la plaine de l'Aude entre deux grands axes de circulation reliant l'Atlantique à la mer Méditerranée et le Massif central aux Pyrénées. La ville est connue pour la Cité de Carcassonne, ensemble architectural médiéval restauré par Viollet-le-Duc au xixe siècle et inscrit au patrimoine mondial de l'UNESCO depuis 1997."}
# ,
# {"id":5,
# "value":"Par rapport à la période écoulée, le fait d'avoir appris après coup que des circulaires imposaient de manière retroactive le retrait de jours de congés pour des personnes qui s'étaient mises en ASA pour cause de garde d'enfants m'a semblé particulièrement injuste et m'a mis vraiment en colère. J'aurais eu besoin de soutien à ce niveau là de la part du CNRS, car faire l'école à la maison était un travail à temps plein aussi nécessaire à la nation que mon travail au CNRS.Par rapport au satisfaction, j'ai trouvé que le télétravail me convenait bien."
# }
# ]))


for line in sys.stdin:
    data = json.loads(line)

    text = data['value']
    if cld3.get_language(text).probability > 0.85:

        data['value'] = cld3.get_language(text).language  # ,round(cld3.get_language(text).probability,2)

    else:
        data['value'] = 'unknown'

    sys.stdout.write(json.dumps(data))
    sys.stdout.write('\n')
