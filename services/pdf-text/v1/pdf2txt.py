#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Mon Jul  3 11:42:06 2023

@author: cuxac
"""

import subprocess
import re
import spacy
import requests
import os
import unidecode
import random
import json
import sys

nlp_en = spacy.load("en_core_web_sm")
nlp_fr=spacy.load("fr_core_news_sm")



#fin=json.loads(json.dumps([{
#       "id":1,
#        "value":"https://hal.science/hal-01990444v1/file/EGC_2019.pdf"},
#    {"id":2,
#    "value":"https://arxiv.org/pdf/2307.03172.pdf"}
#    ]))





def convert_pdf_to_xml(input_path):
    result = subprocess.run(['pdftohtml','-xml', '-stdout','-hidden','-i','-q','-f',p, input_path], capture_output=True, text=True)

    # Vérifier si la conversion a réussi
    if result.returncode == 0:
        # Récupérer le contenu XML dans une variable
        xml_content = result.stdout
        return xml_content
    else:
        # Afficher un message d'erreur en cas d'échec de la conversion
        print("La conversion PDF vers XML a échoué.")
        return None


def remove_xml_tags(xml_string):
    # Expression régulière pour trouver les balises XML et leurs attributs
    pattern = r"<[^>]+>"

    # Supprimer les balises XML et leurs attributs en les remplaçant par une chaîne vide
    cleaned_string = re.sub(pattern, "", xml_string)

    return cleaned_string


def contains_verb(sentence):
    # Parse the sentence using the appropriate model
    if "en" in nlp_en.meta["lang"]:
        doc = nlp_fr(sentence)
    elif "fr" in nlp_fr.meta["lang"]:
        doc = nlp_fr(sentence)
    else:
        return False
    # Check if the sentence contains a verb
    for token in doc:
        if token.pos_ == "VERB":
            return True
    
    return False

def est_prenom_nom(chaine):
    doc = nlp_fr(chaine)
    est_personne = False

    for entite in doc.ents:

        if entite.label_ == "PERSON" and entite.text == chaine:
            est_personne = True
            break
    return est_personne

def est_organisation(chaine):
    chaine=chaine.replace(',','')
    chaine=chaine.replace('-',' ')
    doc = nlp_fr(chaine)
    for entite in doc.ents:

        if entite.label_ == "ORG":
            return True
    return False

def est_texte_lisible(chaine):
    regex_caracteres_speciaux = r"!@#$%^&*()\":{}|<>]"
    regex_url = r"http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"
    regex_doi = r"10\.\d{4,9}/[-._;()/:A-Z0-9]+"

    contient_caracteres_speciaux = re.search(regex_caracteres_speciaux, chaine)
    contient_url = re.search(regex_url, chaine)
    contient_doi = re.search(regex_doi, chaine)

    return not (contient_caracteres_speciaux or contient_url or contient_doi)

def calculer_rapport_alphabetique_numerique(chaine):
    # Initialiser les compteurs
    nb_caracteres_alphabetiques = 0
    nb_caracteres_numeriques = 0

    # Parcourir chaque caractère de la chaîne
    for caractere in chaine:
        if caractere.isalpha():
            nb_caracteres_alphabetiques += 1
        elif caractere.isdigit():
            nb_caracteres_numeriques += 1

    # Vérifier si le dénominateur est différent de zéro
    if nb_caracteres_numeriques != 0:
        rapport = nb_caracteres_alphabetiques / nb_caracteres_numeriques
    else:
        rapport = float('inf')  # Si le dénominateur est zéro, rapport est infini

    return rapport



for line in sys.stdin:
    line0=json.loads(line)
    # URL du PDF
    url=line0['value']
    name=str(round(random.random()*1000))+url.split('/')[-1]
    if 'hal.science' in url:
        p='2'
    else:
        p='1'
    
    # Chemin vers le fichier PDF téléchargé
    pdf_filename = '/tmp/'+name
    
    # Chemin vers le fichier XML de sortie
    #xml_filename = 'EGC_2019.xml'
    
    
    #response = requests.get(url)
    #pdf_content= response.content

        
    try:
        # Télécharger le PDF
        response = requests.get(url)
        response.raise_for_status()  # Vérifie si la requête a réussi
    
        # Enregistrer le PDF sur le disque
        with open(pdf_filename, 'wb') as pdf_file:
            pdf_file.write(response.content)
            
    
        # Exécuter pdftohtml pour la conversion en XML

        xml_data = convert_pdf_to_xml(pdf_filename)
    
        # Supprimer le fichier PDF téléchargé
        os.remove(pdf_filename)
    
        #print("Conversion terminée avec succès.")

        doc_xml=''
        doc_txt=''
        lines = xml_data.strip().split('\n')
        
        merged_lines=[]
        
        # Regex pour extraire la police de caractères
        
        font_regex = re.compile(r'font="([^"]+)"')
        
        # Variables pour garder la police de caractères précédente
        previous_font = None
        current_lines = []
        
        for line in lines:#[0:220]:
            # Extraire la police de caractères de la ligne
        
            match = font_regex.search(line)
            if match:
                current_font = match.group(1)
    
            else:
                current_font = None
            if current_font!=None:
                # Vérifier si la police de caractères a changé
                if current_font != previous_font:
                    # Ajouter les lignes actuelles dans merged_lines si elles existent
                    if current_lines:
    
                        merged_lines.append(' '.join(current_lines))
                    current_lines = []
            
                # Ajouter la ligne actuelle aux lignes actuelles
       
                #print(line)
                current_lines.append(remove_xml_tags(line))
            
                # Mettre à jour la police de caractères précédente
                previous_font = current_font
        
        # Afficher les lignes rassemblées
        t=0
        for linef in merged_lines:
            bal=''
            if linef[0:3].lower()=='fig' or linef[0:3].lower()=='tab':
                linef=''
            if calculer_rapport_alphabetique_numerique(linef)<0.8:
                linef=''
            if est_texte_lisible(linef) and len(linef)>8 and 'copyright' not in linef.lower():
            #if len(linef)>4:
                if est_prenom_nom(linef) :
                    bal='Author'
                if est_organisation(linef) and t<5:
                    bal='Affiliation'
                if contains_verb(linef):
                    if t>0:
                        bal='Text'
                    else: 
                        bal='Title'
                    t=t+1
                if bal=='':
                    bal='Part'
    
                doc_xml=doc_xml+('<'+bal+'>'+linef+'<\\'+bal+'>'+'\n')
                if bal=='Part' and ("references" in unidecode.unidecode(linef.lower()) or "biblio" in linef.lower()) :
    
                    break
                if bal!='Author' and bal!='Affiliation':
                    doc_txt=doc_txt+linef+' '
        doc_txt=doc_txt.replace('( )','')
        doc_txt=re.sub(r"\[[0-9, ]+\]", "",doc_txt)
    
        line0['value']=doc_txt
    
    except requests.exceptions.RequestException:
        #print("Erreur lors du téléchargement du PDF:", e)
        line0['value']="Erreur lors du telechargement du PDF"
    
    except subprocess.CalledProcessError:
        #print("Erreur lors de l'exécution de pdftohtml:", e)
        line0['value']="Erreur lors de l'execution de pdftohtml"
    
    except OSError :
        #print("Erreur lors de la suppression du fichier PDF:", e)
        line0['value']="Erreur lors de la suppression du fichier PDF"
    
    sys.stdout.write(json.dumps(line0))
    sys.stdout.write('\n')
