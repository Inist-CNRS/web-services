#!/usr/bin/env python3
import json
import sys
import re
import urllib.parse
import requests
from ratelimit import limits, RateLimitException
from backoff import on_exception, expo

# Filtrage par mot clé pour ne garder que l'essentiel
def filter(affiliation) :
    affiliation_lower = affiliation.lower()
    adress = affiliation_lower.replace(",", "")
    words = adress.split(" ")
    private = ["sas", "sarl", "sa", "private", "edf", "orange"]
    public = ["univ", "hop", "uar", "umr", "cea", "cnrs", "(cnrs)","(cea)","(univ"]
    for word in words :
        if word in private :
            return "private"
        elif word in public :
            return "public"
    return None

# lire le fichier json des abréviations
def read_json_file(file_path):
    with open(file_path, 'r') as file:
        data = json.load(file)
    return data

# Normaliser les abréviations
def expand_abbreviations(affiliation,dict):
    affiliation = affiliation.lower()
    affiliations = affiliation.split(" ")
    res = []
    for word in affiliations :
        short_word = word.replace(",","").replace(".","")
        if short_word in dict:
            suffix = ""
            if "," in word:
                suffix = ","
            res.append(dict[short_word] + suffix)
        else:
            res.append(word)
    return " ".join(res)

# découpage des adresses en plusieurs parties
def name_enterprise(affiliation) :
    affiliation = affiliation.lower()
    affiliations = affiliation.split(',')
    return affiliations[0]

# Repérer le département dans l'affiliation 
def num_dept(affiliation) :
    res = re.findall('f-(\d{2})\d{3}',affiliation)
    if len(res)==0 :
        return None
    return res[0]

# requêtage de l'API pour les données filtrées
@on_exception(expo, RateLimitException, max_time=1)
@limits(calls=7, period=1)

def request(name, dept) :
    url = "https://recherche-entreprises.api.gouv.fr/search?q=" + urllib.parse.quote(name)
    if dept:
        url += "&departement=" + dept
    response = requests.get(url,headers={'Accept':'application/json'})
    return response.json()

# gérer les réponses de l'API
def is_private_public(information):
    if len(information)==0 or 'results' not in information or not information['results']:
        return None
    # Parcourir chaque objet "results" extraire la valeur de "est_service_public"
    est_service_public_list = []
    for result in information['results']:
        complements = result.get('complements')
        est_service_public = complements.get('est_service_public', None)
        if est_service_public is not None:
            est_service_public_list.append(est_service_public)
            if True in est_service_public_list :
                return "public"
            return "private"
        
# return est_service_public_list
def public_or_private(affiliation,my_dict):
    privatePublicOrAffiliation = filter(affiliation)
    if privatePublicOrAffiliation in ["private", "public"]:
        enterprise = name_enterprise(affiliation)
        return {"organisme": enterprise, "statut": privatePublicOrAffiliation}
    
    expanded_affiliation = expand_abbreviations(affiliation,my_dict)
    name = name_enterprise(expanded_affiliation)
    dept = num_dept(expanded_affiliation)
    information = request(name, dept)
    nature = is_private_public(information)
    if nature is None:
        return {"organisme": name, "statut": "n/a"}
    return {"organisme": name, "statut": nature}
    
def main():
    abbreviations_dict = read_json_file('./v1/corporate/abbreviations.json')
    for line in sys.stdin:  
        data = json.loads(line)
        texte = data["value"]
        data["value"] = public_or_private(texte,abbreviations_dict)
        sys.stdout.write(json.dumps(data))
        sys.stdout.write("\n")

if __name__ == "__main__":
    main()
