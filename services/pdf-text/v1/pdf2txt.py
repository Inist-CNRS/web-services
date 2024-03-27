#!/usr/bin/env python3
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




def convert_pdf_to_xml(input_path):
    result = subprocess.run(['pdftohtml','-xml', '-stdout','-hidden','-i','-q','-f',p, input_path], capture_output=True, text=True)

    # Check if conversion was successful
    if result.returncode == 0:
        # Get the XML content in a variable
        xml_content = result.stdout
        return xml_content
    else:
        # print error message if needed
        sys.stderr.write(f"Conversion of PDF {input_path} to XML has failed.")
        sys.stderr.write("\n")
        return None


def remove_xml_tags(xml_string):
    # Use regex to find all XML tags and attributes
    pattern = r"<[^>]+>"

    # Delete all XML tags and attributes
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

def is_firstname_lastname(chaine):
    doc = nlp_fr(chaine)
    is_person = False

    for entity in doc.ents:

        if entity.label_ == "PERSON" and entity.text == chaine:
            is_person = True
            break
    return is_person

def is_organization(chaine):
    chaine=chaine.replace(',','')
    chaine=chaine.replace('-',' ')
    doc = nlp_fr(chaine)
    for entite in doc.ents:

        if entite.label_ == "ORG":
            return True
    return False

def is_readable_text(chaine):
    regex_caracteres_speciaux = r"!@#$%^&*()\":{}|<>]"
    regex_url = r"http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"
    regex_doi = r"10\.\d{4,9}/[-._;()/:A-Z0-9]+"

    contient_caracteres_speciaux = re.search(regex_caracteres_speciaux, chaine)
    contient_url = re.search(regex_url, chaine)
    contient_doi = re.search(regex_doi, chaine)

    return not (contient_caracteres_speciaux or contient_url or contient_doi)

def get_alphabetic_numeric_ratio(chaine):
    # Initlialize count variables
    nb_caracteres_alphabetiques = 0
    nb_caracteres_numeriques = 0

    for caractere in chaine:
        if caractere.isalpha():
            nb_caracteres_alphabetiques += 1
        elif caractere.isdigit():
            nb_caracteres_numeriques += 1

    # Check if the denominator is not zero
    if nb_caracteres_numeriques != 0:
        rapport = nb_caracteres_alphabetiques / nb_caracteres_numeriques
    else:
        rapport = float('inf')  # if denominator is zero, set the ratio to infinity

    return rapport



for line in sys.stdin:
    line0=json.loads(line)
    # URL of PDF
    url=line0['value']
    name=str(round(random.random()*1000))+url.split('/')[-1]
    if 'hal.science' in url:
        p='2'
    else:
        p='1'
    
    # path to the PDF
    pdf_filename = '/tmp/'+name
    
    try:
        # dl the PDF
        response = requests.get(url)
        response.raise_for_status()  # check if request succeeded
    
        # save pdf
        with open(pdf_filename, 'wb') as pdf_file:
            pdf_file.write(response.content)
            
    
        # exec pdftohtml for the xml conversion
        xml_data = convert_pdf_to_xml(pdf_filename)
    
        # dl the PDF file in the /tmp folder
        os.remove(pdf_filename)
    
        #print("Conversion terminée avec succès.")

        doc_xml=''
        doc_txt=''
        lines = xml_data.strip().split('\n')
        
        merged_lines=[]
        
        # Regex for extracting font informations
        font_regex = re.compile(r'font="([^"]+)"')
        
        # Variable to keep the current font
        previous_font = None
        current_lines = []
        
        for line in lines:#[0:220]:
            # Extract font information
        
            match = font_regex.search(line)
            if match:
                current_font = match.group(1)
    
            else:
                current_font = None
            if current_font!=None:
                # Check if font changed
                if current_font != previous_font:
                    # add (existing) line in merged_lines
                    if current_lines:
    
                        merged_lines.append(' '.join(current_lines))
                    current_lines = []
       
                current_lines.append(remove_xml_tags(line))
            
                # Update previous font
                previous_font = current_font
        
        # print merged lines
        t=0
        for linef in merged_lines:
            bal=''
            if linef[0:3].lower()=='fig' or linef[0:3].lower()=='tab':
                linef=''
            if get_alphabetic_numeric_ratio(linef)<0.8:
                linef=''
            if is_readable_text(linef) and len(linef)>8 and 'copyright' not in linef.lower():
                if is_firstname_lastname(linef) :
                    bal='Author'
                if is_organization(linef) and t<5:
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
