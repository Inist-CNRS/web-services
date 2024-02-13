#!/usr/bin/env python3

import re
from requests_ratelimiter import LimiterSession
import sys
import json
import pandas as pd
import unicodedata
from thefuzz import fuzz


mail_adress = "leo.gaillard@cnrs.fr"
session = LimiterSession(per_second=5)

# get a list of retracted DOIs
dumps_pps = pd.read_csv("./v1/annulled.csv", encoding="cp1252")
retracted_doi = dumps_pps["DOI"].tolist()


# normalize text
def remove_accents(text):
    """
    Remove accents from the input text and return the text with no accents.

    Parameters:
        text (str): The input text with accents.

    Returns:
        str: The input text with accents removed.
    """
    if text == "" or type(text)!= str:
        return ""
    normalized_text = unicodedata.normalize("NFD", text)
    text_with_no_accent = re.sub("[\u0300-\u036f]", "", normalized_text)
    return text_with_no_accent

def uniformize(text):
    """
    Function to uniformize the given text by removing accents, punctuation, and converting to lowercase.
    
    Args:
        text (str): a string input text to be uniformized
        
    Returns:
        str: a string with uniformized text
    """
    text = remove_accents(text) #if text is not a string, it's return ""

    # remove punctuation except " ' "
    text = ''.join(char if char.isalpha() else ' ' for char in text)

    return ' '.join(text.lower().split())

# DOI funtions
def find_doi(text):
    """
    Function to find a DOI (Digital Object Identifier) in the given text.

    Args:
        text: the input text in which to search for the DOI
        
    Returns
        str: the found DOI, or an empty string if not found
    """
    doi_regex = r"\b10.\d{4,}\/[^\s]+\b"
    doi = re.search(doi_regex, text)
    if doi == None:
        return ""
    try:
        doiStr = doi.group()
        return doiStr
    except:
        return ""


def verify_doi(doi, mail=mail_adress):
    """
    Verify a Digital Object Identifier (DOI) by making a GET request to the Crossref API. 

    Args:
        doi (str): The DOI to be verified.
        mail (str): The email address to be included in the API request. Defaults to the value of mail_address.

    Returns:
        int: The HTTP status code of the API response, or 503 if an exception occurs.
    """
    url = f"https://api.crossref.org/works/{doi}/agency?mailto={mail}"

    try:
        response = session.get(url)
        return response.status_code

    except Exception:
        return 503 # if there is an unexpected error from crossref


# Functions for ref_biblio
def get_title_authors_doi(message):
    """
    Get the title, first author's given name, first author's family name, and DOI from the input message.
    
    Args:
        message (dict): The input message containing information about the publication.
    
    Returns:
        dict: A dictionary containing the title, first author's given name, first author's family name, and DOI.
    """
    title = message['title'][0] if 'title' in message else ""
    doi = message['DOI'] if 'DOI' in message else ""
    try:
        first_author_name = message['author'][0]['family']
    except:
        first_author_name = ""
    try:
        first_author_given = message['author'][0]['given']
    except:
        first_author_given = ""
    return {'title': title, 'first_author_given': first_author_given, 'first_author_name': first_author_name, 'doi': doi}

def match_title(title, ref_biblio):
    """
    Match the title of the publication with the title of the biblio reference.
    
    Args:
        title (str): The title of the publication.
        ref_biblio (str): The biblio reference.
    
    Returns:
        bool: True if the title of the publication matches the title of the biblio reference, False otherwise.
    """
    title = uniformize(title)
    ref_biblio = uniformize(ref_biblio)
    
    distance = fuzz.partial_ratio(title, ref_biblio)

    #thereshold here
    return distance > 90

def compare_pubinfo_refbiblio(item,ref_biblio):
    """
    Compare informations of one of the crossref publis with the biblio

    Args:
        item (json): title, authors name and doi from a crossref publi
        ref_biblio (str): the whole biblio reference
    
    Returns:
        tuple (bool, str): True if it's match and whith the doi
    """
    # Check first author
    if item['first_author_name'] not in ref_biblio:
        return False, ""
    if not match_title(item['title'], ref_biblio):
        return False, ""
    return True, item['doi']

def verify_biblio(ref_biblio, mail=mail_adress):
    """
    check with crossref api if a biblio ref is correct.
    
    Args : 
        ref_biblio :a biblio ref
        mail : a mail adress
    
    Returns : 
        a confidence score about the existence + doi of the biblio ref
    """
    url = f'https://api.crossref.org/works?query.bibliographic="{ref_biblio}"&mailto={mail}&rows=5'
    try:
        response = session.get(url)
        data = response.json()
        items = data["message"]["items"] #to check
        for item in items:
            item_info = get_title_authors_doi(item)
            # If no authors name in Crossref, return "not_found"
            if item_info['first_author_name'] == "" or item_info['title']=="":
                continue
            # compare pub_info with ref_biblio
            match_item, doi = compare_pubinfo_refbiblio(item_info,ref_biblio)
            if match_item:
                return "found",doi
            
        return "not_found",""
    except Exception:
        return "error_service",""


for line in sys.stdin:
    data = json.loads(line)
    ref_biblio = data["value"]

    # check if "value" is a string
    if not isinstance(ref_biblio, str):
        data["value"] = {"doi":"","status": "error_data"}
        json.dump(data, sys.stdout)
        sys.stdout.write("\n")
        continue

    doi = find_doi(ref_biblio)
    if doi:  # doi is True if and only if a doi is found with the regex doi_regex
        crossref_status_code = verify_doi(doi) # Verify doi using crossref api
        if crossref_status_code==200:  # If request return code 200
            status = "found"
            if doi in retracted_doi:
                status = "retracted"
            data["value"] = {"doi":doi,"status": status}
            json.dump(data, sys.stdout)
            sys.stdout.write("\n")
            
        elif crossref_status_code==404:  # If request return code 404
            status,doi = verify_biblio(ref_biblio)
            data["value"] = {"doi":doi, "status": status}
            
            json.dump(data, sys.stdout)
            sys.stdout.write("\n")
            
        else:
            data["value"] = {"doi":"","status": "error_service"}
            json.dump(data, sys.stdout)
            sys.stdout.write("\n")


    else:
        status,doi = verify_biblio(ref_biblio)
        data["value"] = {"doi":doi, "status": status}
        
        json.dump(data, sys.stdout)
        sys.stdout.write("\n")
