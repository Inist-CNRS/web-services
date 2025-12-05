#!/usr/bin/env python3
import requests
from collections import defaultdict
import json
import sys
import os
import time

OPENALEX_TOKEN = os.getenv("OPENALEX_API_KEY")

def get_openalex_info(doi):
    url = f"https://api.openalex.org/works/doi:{doi}"

    for attempt in range(3):  # 3 tentatives maximum
        try:
            print(f"[DEBUG] Starting request for DOI {doi}, attempt {attempt+1}", file=sys.stderr)

            time.sleep(0.12)
            response = requests.get(url, timeout=(5, 10))

            print(f"HTTP={response.status_code} for DOI {doi}", file=sys.stderr)

            # 1. Erreurs HTTP
            if response.status_code != 200:
                print(f"[ERROR] API OpenAlex HTTP {response.status_code}", file=sys.stderr)
                continue  # on réessaie

            # 2. JSON validation
            try:
                data = response.json()
            except ValueError:
                print("[ERROR] Réponse non-JSON reçue", file=sys.stderr)
                continue  # on réessaie

            # 3. Vérification des champs attendus
            if "id" not in data:
                print("[ERROR] JSON invalide ou incomplet", file=sys.stderr)
                continue 

            return data

        except requests.exceptions.Timeout:
            pass
            print(f"[ERROR] Timeout pour DOI {doi} (tentative {attempt+1})", file=sys.stderr)

        except requests.exceptions.RequestException as e:
            pass
            print(f"[ERROR] Exception réseau pour DOI {doi} : {e} (tentative {attempt+1})", file=sys.stderr)

    # Si on arrive ici = les 3 tentatives ont échoué
    print(f"[ERROR] Abandon du DOI {doi} après 3 tentatives", file=sys.stderr)
    return None



def extract_doi_referenced_works(data):
    if data:
        doi_url = data.get('doi')
        referenced_works = data.get('referenced_works', [])
        if not referenced_works:
            return {doi_url: "champ referenced_works vide"}
        else :
            return {doi_url: referenced_works}
    else:
        return {}

def openAlex_to_doi(url) :

    url_parse = url.split("/")
    id = url_parse[-1]
    url = f"https://api.openalex.org/works/{id}"

    time.sleep(0.12)
    response = requests.get(url)

    if response.status_code == 200:
        data = response.json()
        doi = data.get('doi')
        if doi:
            return doi
    return f"https://openalex.org/{id}"
    

def main():
    # Définition de la limite par défaut à 10 citations
    nbCitations = int(sys.argv[sys.argv.index('-p') + 1]) if '-p' in sys.argv else 10

    dois = []
    for line in sys.stdin:
        data = json.loads(line)
        if "value" not in data:
            continue
        dois.append(data["value"])

    all_references = {}
    
    for i, doi in enumerate(dois, start=1):
        # --- traitement du DOI ---
        get_info_doi = get_openalex_info(doi)
        references = extract_doi_referenced_works(get_info_doi)
        all_references.update(references)

        print(f"DOI {i}/{len(dois)} MB", file=sys.stderr)


    # inialisation du dict avec deux clés possibles :
    #  le compteur du nombre de citation à 0 et la liste pour les futurs dois
    citation_count = defaultdict(lambda: {"count": 0, "doi": []})

    # parcours le dictionnaire où les dois sont des clés et les références des listes de valeurs
    for doi, references in all_references.items():
        if references == "champ referenced_works vide":
            # Ajouter une entrée dans le JSON indiquant que le champ referenced_works est vide
            #print({"id": doi, "value": {"message": "champ referenced_works vide"}})
            sys.stdout.write(json.dumps({"id": doi, "value": {"message": "champ referenced_works vide"}}))
            sys.stdout.write("\n")
        else : 
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
    # on récupère les n valeurs les plus grandes, par défaut 10
    # voir pour modifier ce paramètre
    top_citations = sorted_citations[:nbCitations]

    result = []
    # on itère sur la liste qui contient les tuples citation, count et doi pour les ajouter aux différents champs
    for citation, info in top_citations:
        # result.append({"id": openAlex_to_doi(citation),"value": {"count": info["count"],"citing_doi": info["doi"]}})
        sys.stdout.write(json.dumps({"id":openAlex_to_doi(citation), "value":{"count": info["count"],"citing_doi": info["doi"]}}))
        sys.stdout.write("\n")

    # with open("output-topcitation.json", "w", encoding="utf-8") as f:
    #             json.dump(result, f, ensure_ascii=False, indent=2)


if __name__ == "__main__":
    main()
