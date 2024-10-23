#!/usr/bin/env python3
import requests
from collections import defaultdict
import json
import sys

def get_openalex_info(doi):
    url = f"https://api.openalex.org/works/doi:{doi}"

    response = requests.get(url)

    if response.status_code == 200:
        return response.json()
    else:
        return None
    
def extract_doi_referenced_works(data):
    if data:
        doi_url = data.get('doi')
        referenced_works = data.get('referenced_works', [])
        
        return {doi_url: referenced_works}
    else:
        return {}
    
def openAlex_to_doi(url) :

    url_parse = url.split("/")
    id = url_parse[-1]

    url = f"https://api.openalex.org/works/{id}"
    response = requests.get(url)

    if response.status_code == 200:
        data = response.json()
        doi = data.get('doi')
        if doi is not None :
            return doi
        else:
            return f"https://openalex.org/{id}"
    

def main():
    dois = []
    for line in sys.stdin:
        data = json.loads(line)
        if "value" in data :
            dois.append(data["value"])

    all_references = {}
    
    for doi in dois:
        get_info_doi = get_openalex_info(doi)
        references = extract_doi_referenced_works(get_info_doi)
        
        all_references.update(references)

    # inialisation du dict avec deux clés possibles :
    #  le compteur du nombre de citation à 0 et la liste pour les futurs dois
    citation_count = defaultdict(lambda: {"count": 0, "doi": []})

    # parcours le dictionnaire où les dois sont des clés et les références des listes de valeurs
    for doi, references in all_references.items():
        # itération de la liste des références
        for citation in references:
            # chaque citation est un clé qui a comme valeur les clés count et doi
            # count est une clé qui a pour valeur le nombre de fois qu'apparait une citation
            citation_count[citation]["count"] += 1
            # doi est une clé qui a pour valeur le ou les doi(s) qui cite la citation
            citation_count[citation]["doi"].append(doi)
# exemple : {'https://openalex.org/W107566402': {'count': 1, 'doi': ['https://doi.org/10.1007/s10844-014-0317-4']}

    # utilisation de la méthode sorted() pour trier le dictionnaire en fonciton de count
    sorted_citations = sorted(citation_count.items(), key=lambda item: item[1]['count'], reverse=True)
    # on ne récupère que les 10 valeurs les plus grandes 
    # voir pour modifier ce paramètre
    top_citations = sorted_citations[:10]

    result = {"id":"n/a","value":[]}
    
    # on itère sur la liste qui contient les tuples citation, count et doi pour les ajouter aux différents champs
    for citation, info in top_citations:
        result["value"].append({
            "cited_ref": openAlex_to_doi(citation),
            "count": info["count"],
            "citing_doi": info["doi"]
        })

    sys.stdout.write(json.dumps(result))
    sys.stdout.write("\n")

if __name__ == "__main__":
    main()
