import re
from requests_ratelimiter import LimiterSession
import unicodedata
from thefuzz import fuzz
import pickle
import os
import sys
import json

api_token = os.getenv("CROSSREF_API_KEY")
headers = {
    "Crossref-Plus-API-Token": api_token
}
session = LimiterSession(per_second=10)
session_pdf = LimiterSession(per_second=10)

# get a list of retracted DOIs
with open("v1/annulled.pickle", "rb") as file:
    retracted_doi = pickle.load(file)


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
    Uniformize the given text by removing accents, punctuation, and converting to lowercase.
    
    Args:
        text (str): a string input text to be uniformized
        
    Returns:
        str: a string with uniformized text
    """
    
    text = remove_accents(text) #if text is not a string, it's return ""

    # remove punctuation
    text = "".join(char if char.isalpha() else " " for char in text)

    return " ".join(text.lower().split())


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


# specially designed functions for crossref API
def get_title_authors_doi_source_date(message):
    
    """
    Get the title, first author's given name, first author's family name, and DOI from the input message.
    Objective : For a response to crossref API, this function is used to get informations from this response.
    
    Args:
        message (dict): The input message containing information about the publication.
    
    Returns:
        dict: A dictionary containing the title, first author's given name, first author's family name, and DOI.
    """
    
    title = message["title"][0] if "title" in message else ""
    doi = message["DOI"] if "DOI" in message else ""
    try:
        first_author_name = message["author"][0]["family"]
    except:
        first_author_name = ""
    try:
        first_author_given = message["author"][0]["given"]
    except:
        first_author_given = ""
    try:
        date = str(message["published"]["date-parts"][0][0])
    except:
        try:
            date = str(message["published-print"]["date-parts"][0][0])
        except:
            date = ""
    
    source = {}
    try :
        source["source-long"] = message["container-title"][0]
    except:
        try:
            source["source-long"] = message["event"]["name"]
        except:
            source["source-long"] = ""
    try :
        source["source-short"] = message["short-container-title"][0]
    except:
        try:
            source["source-short"] = message["event"]["acronym"]
        except:
            source["source-short"] = ""

    return {
        "title": title,
        "first_author_given": first_author_given,
        "first_author_name": first_author_name,
        "doi": doi,
        "date": str(date),
        "source": source
        }
    

def verify_doi(doi, headers=headers):
    
    """
    Verify a Digital Object Identifier (DOI) by making a GET request to the Crossref API. 

    Args:
        doi (str): The DOI to be verified.
        mail (str): The email address to be included in the API request. Defaults to the value of mail_address.

    Returns:
        (int,dict): HTTP status code of the API response and dict informations found
    """
    
    url = f"https://api.crossref.org/works/{doi}"

    try:
        response = session.get(url, headers=headers)
        status_code = response.status_code
        if status_code != 200 :
            return (status_code, None)
        message = response.json()["message"]
        others_biblio_info = get_title_authors_doi_source_date(message)
            
        return (response.status_code , others_biblio_info)

    except:
        return (503, None) # if there is an unexpected error from crossref


def clean_crossref_title(text):
    
    """
    Function to delete "retracted" informations from crossref title
    Objective : Sometimes, title starts with "RETRACTED >" or something similar ; 
    this function delete this to clean title for comparison
    
    Args:
        text (str): the title

    Returns:
        text: the title without retracted informations
    """
    pattern = r'^(RETRACT(?:ED)?(?:ION)?\s?(?:ARTICLE)?\s?:\s?)'
    match = re.match(pattern, text, flags=re.IGNORECASE)
    if match:
        text = re.sub(pattern, '', text, count=1, flags=re.IGNORECASE)
        
    if "</" in text:
        text = re.sub(r'<[^>]*>', '', text)
        
    return text.strip()


# Functions that compare informations between the Crossref metadata and 
# the bibliographic reference given.
def compare_pubinfo_refbiblio(item,ref_biblio):
    
    """
    Compare informations of one of the crossref publis with the biblio.

    This is the function to change if we want to update matches
    criterias.
    
    criteria : partial title (0.90 using fuzz.partial_ratio), first
    author name
    
    Args:
        item (json): 
            title, authors name and doi from a crossref publi
        ref_biblio (str):
            the whole biblio reference
    
    Returns:
        tuple (bool, str): 
            True if it's match with the doi, else false + empty
        string
    """
    items_score = 0
    # Title
    title_score = fuzz.partial_ratio(uniformize(clean_crossref_title(item["title"])), ref_biblio)/100

    if title_score > 0.9:
        items_score += 1

    # Check first author
    first_author = uniformize(item["first_author_name"])
    if first_author and first_author in ref_biblio:
        items_score +=1
    
    # Date
    if item["date"] and item["date"] in ref_biblio:
        items_score +=1
        
    # Source
    if fuzz.partial_ratio(uniformize(item["source"]["source-short"]), ref_biblio)/100 > 0.8 or fuzz.partial_ratio(uniformize(item["source"]["source-short"]), ref_biblio)/100 > 0.8 :
        items_score +=1

    return items_score, title_score, item["doi"]


# This is the function to update if you want stronger or weaker criteria
# For now, criteria is 2 or more matches on informations on title, authors, date and source except if it is date and source.
def verify_biblio_without_doi(ref_biblio, headers=headers):

    """
    check with crossref api if a biblio ref is correct.
    Objective : In this function, we check if the biblio ref exist if no doi is found : we use as critera the compare_pubinfo_refbiblio function
    
    Args : 
        ref_biblio :a biblio ref
        mail : a mail adress
    
    Returns : 
        a confidence score about the existence + doi of the biblio ref
    """
    
    url = f'https://api.crossref.org/works?query.bibliographic="{ref_biblio}"&rows=5' #take only the 5 first results
    hallucinated = False
    
    try:
        response = session.get(url, headers=headers)
        data = response.json()
        items = data["message"]["items"] #to check
        
        for item in items:
            item_info = get_title_authors_doi_source_date(item)
            
            # compare pub_info with ref_biblio
            match_items_score, title_score, doi = compare_pubinfo_refbiblio(item_info, ref_biblio)

            # Matches criteria when there is no doi in the reference
            if match_items_score >= 3:
                return "found", doi
            
            elif match_items_score < 2:

                if title_score > 0.9:
                    hallucinated = True
                continue
            
            # here match_item_score == 2, we need title OR soft critera on title :
            else:
                ## if title match found is returned
                ## If title doesn't match, we need at least a weak criteria on title

                if title_score < 0.75:
                    continue
                
                else:
                    return "found", doi
        
        if hallucinated:
            return "hallucinated", ""
        
        else:
            return "not_found", ""
        
    except Exception as e:
        sys.stderr.write("Error in verify_biblio function : "+str(e)+"\n")
        return "error_service", ""


def biblio_ref(ref_biblio,retracted_doi=retracted_doi):
    """
    The main function of this service : use all previous function to validate a biblio ref.
    Args:
        ref_biblio (_type_): _description_
        retracted_doi (_type_): _description_
    """
        # check types
    if not isinstance(ref_biblio, str):
        return {"doi":"","status": "error_data"}

    doi = find_doi(ref_biblio)
    ref_biblio = uniformize(ref_biblio) # Warining : in the rest of code, the biblio ref is uniformize (remove some informations)
    # First case : doi is found
    if doi:
        crossref_status_code, others_biblio_info = verify_doi(doi) # Verify doi using crossref api
        
        ## If DOI exists
        if crossref_status_code==200:
            status = "found"
            
            ### Can be retracted
            if doi in retracted_doi:
                return {"doi":doi, "status": "retracted"}
                  
            ### can be hallucinated
            if len(doi)*1.5 < len(ref_biblio): 
                match_items_score, title_score, doi = compare_pubinfo_refbiblio(others_biblio_info,ref_biblio)
                
                if match_items_score < 2:
                    return {"doi":"","status": "hallucinated"}
                
            return {"doi":doi, "status": status}


        
        ## If DOI doesn't exist
        elif crossref_status_code==404:
            status, doi = verify_biblio_without_doi(ref_biblio)
            
            ### Can be retracted
            if doi in retracted_doi:
                return {"doi":doi, "status": "retracted"}
            
            return {"doi":doi, "status": status}
                    
        ### for others errors
        else:
            sys.stderr.write("DOI requests failed. Crossref status code :" + str(crossref_status_code)+"\n")
            return {"doi":"","status": "error_service"}

    # second case : no doi is found
    else:
        status,doi = verify_biblio_without_doi(ref_biblio)
        
        ### Can be retracted
        if doi in retracted_doi:
            return {"doi":doi, "status": "retracted"}
            
        return {"doi":doi, "status": status}
