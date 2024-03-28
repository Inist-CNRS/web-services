import re
from requests_ratelimiter import LimiterSession
import unicodedata
from thefuzz import fuzz


mail_address = "leo.gaillard@cnrs.fr"
session = LimiterSession(per_second=10)

# get a list of retracted DOIs
with open("./v1/annulled.csv", "r") as annulled_file:
    retracted_doi = [line.rstrip() for line in annulled_file]


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
    text = "".join(char if char.isalpha() else ' ' for char in text)

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


def verify_doi(doi, mail=mail_address):
    
    """
    Verify a Digital Object Identifier (DOI) by making a GET request to the Crossref API. 

    Args:
        doi (str): The DOI to be verified.
        mail (str): The email address to be included in the API request. Defaults to the value of mail_address.

    Returns:
        (int,dict): HTTP status code of the API response and dict informations found
    """
    
    url = f"https://api.crossref.org/works/{doi}?mailto={mail}"

    try:
        response = session.get(url)
        status_code = response.status_code
        if status_code != 200 :
            return (status_code,{'title': "", 'first_author_given': "", 'first_author_name': "", 'doi': ""})
        message = response.json()["message"]
        others_biblio_info = {}
        others_biblio_info["title"] = message["title"][0] if 'title' in message else ""
        others_biblio_info["doi"] = message['DOI'] if "DOI" in message else ""
        try:
            others_biblio_info["first_author_name"] = message['author'][0]['family']
        except:
            others_biblio_info["first_author_name"] = ""
        try:
            others_biblio_info["first_author_given"] = message['author'][0]['given']
        except:
            others_biblio_info["first_author_given"] = ""
            
        return (response.status_code , others_biblio_info)

    except:
        return (503,{'title': "", 'first_author_given': "", 'first_author_name': "", 'doi': ""}) # if there is an unexpected error from crossref


# specially designed functions for crossref API
def get_title_authors_doi(message):
    
    """
    Get the title, first author's given name, first author's family name, and DOI from the input message.
    Objective : For a response to crossref API, this function is used to get informations from this response.
    
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

def remove_retracted_prefix(text):
    
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
    
    # Check first author
    if uniformize(item['first_author_name']) not in ref_biblio:
        return False, ""
    if fuzz.partial_ratio(uniformize(remove_retracted_prefix(item['title'])), ref_biblio)<90:
        return False, ""
    return True, item['doi']


def verify_biblio(ref_biblio, mail=mail_address):

    """
    check with crossref api if a biblio ref is correct.
    Objective : In this function, we check if the biblio ref exist if no doi is found : we use as critera the compare_pubinfo_refbiblio function
    
    Args : 
        ref_biblio :a biblio ref
        mail : a mail adress
    
    Returns : 
        a confidence score about the existence + doi of the biblio ref
    """
    
    url = f'https://api.crossref.org/works?query.bibliographic="{ref_biblio}"&mailto={mail}&rows=5' #take only the 5 first results
    try:
        response = session.get(url)
        data = response.json()
        items = data["message"]["items"] #to check
        for item in items:
            item_info = get_title_authors_doi(item)
            # If no authors name or title in Crossref, return "not_found"
            if item_info['first_author_name'] == "" or item_info['title']=="":
                continue
            # compare pub_info with ref_biblio
            match_item, doi = compare_pubinfo_refbiblio(item_info,ref_biblio)
            if match_item:
                if doi in retracted_doi:
                    return "retracted",doi
                return "found",doi
            
        return "not_found",""
    except:
        return "error_service",""
