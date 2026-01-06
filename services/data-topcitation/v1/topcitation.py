#!/usr/bin/env python3
import requests
from collections import defaultdict
import json
import sys
import os
import time
import re

OPENALEX_TOKEN = os.getenv("OPENALEX_API_KEY")


def get_openalex_info(doi):
    url = f"https://api.openalex.org/works/doi:{doi}?api_key={OPENALEX_TOKEN}"

    for attempt in range(3):  # 3 tentatives maximum
        try:
            time.sleep(0.12)
            response = requests.get(url, timeout=(5, 10))

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

        title = data.get('title')
        if not title :
            title = "Titre non disponible"

        referenced_works = data.get('referenced_works', [])
        if not referenced_works:
            referenced_works = "champ referenced_works vide"

        return {doi_url: {"title": title, "referenced_works": referenced_works}}

    else:
        return {}

def openAlex_to_doi_and_title(url) :
    url_parse = url.split("/")
    id = url_parse[-1]
    url = f"https://api.openalex.org/works/{id}?api_key={OPENALEX_TOKEN}"

    time.sleep(0.12)
    response = requests.get(url)

    if response.status_code == 200:
        data = response.json()
        doi = data.get('doi')
        title = data.get('title') or "Titre non disponible"
        if doi:
            return {"doi": doi, "title": title}
    return {"doi":f"https://openalex.org/{id}", "title": "Titre non disponible"}

def normalize_title(title):
    if not title:
        return "Titre non disponible"

    # <tag>contenu</tag> → contenu
    title = re.sub(r"<[^>/]+>(.*?)</[^>]+>", r"\1", title)

    # supprimer toutes les autres balises
    title = re.sub(r"<[^>]+>", "", title)

    return title


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
        get_info_doi = get_openalex_info(doi)
        references = extract_doi_referenced_works(get_info_doi)
        all_references.update(references)

        print(f"DOI {i}/{len(dois)} traité", file=sys.stderr)
    # inialisation du dict avec deux clés possibles :
    #  le compteur du nombre de citation à 0 et la liste pour les futurs dois
    citation_count = defaultdict(lambda: {"count": 0, "doi": []})

    # parcours le dictionnaire où les dois sont des clés et les datas qui contient le titre du document et la liste des références
    for doi, data in all_references.items():
        references = data["referenced_works"]
        title = data["title"]
        if references == "champ referenced_works vide":
            continue
            # Ajouter une entrée dans le JSON indiquant que le champ referenced_works est vide
            # sys.stdout.write(json.dumps({"id": doi, "value": {"title": title, "message": "champ referenced_works vide"}}))
            # sys.stdout.write("\n")
        else : 
        # itération de la liste des références
            for citation in references:
                # chaque citation est un clé qui a comme valeur les clés count et doi
                # count est une clé qui a pour valeur le nombre de fois qu'apparait une citation
                citation_count[citation]["count"] += 1
                # doi est une clé qui a pour valeur le ou les doi(s) qui cite la citation
                citer_title = all_references.get(doi, {}).get("title")
                if not citer_title:
                    citer_title = openAlex_to_doi_and_title(doi)["title"]
                citation_count[citation]["doi"].append({"doi": doi, "title": citer_title})
# exemple : {"id": "DOI de la citation","value": {"title": "Titre de la citation","count": 3,
# "citing_doi": [{"doi": "DOI1", "title": "Titre1"},{"doi": "DOI2", "title": "Titre2"}]}}

    # utilisation de la méthode sorted() pour trier le dictionnaire en fonciton de count
    sorted_citations = sorted(citation_count.items(), key=lambda item: item[1]['count'], reverse=True)
    # on récupère les n valeurs les plus grandes, par défaut 10
    # voir pour modifier ce paramètre
    top_citations = sorted_citations[:nbCitations]

    # on itère sur la liste qui contient les tuples citation, count et doi pour les ajouter aux différents champs
    for citation, info in top_citations:
        citation_info = openAlex_to_doi_and_title(citation)

        clean_title = normalize_title(citation_info["title"])  # <-- NEW

        # Normaliser aussi les titres des citing_doi
        clean_citers = []
        for entry in info["doi"]:
            clean_citers.append({"doi": entry["doi"],"title": normalize_title(entry["title"])})
        sys.stdout.write(json.dumps({"id": citation_info["doi"],"value": {"title": clean_title,"count": info["count"],"citing_doi": clean_citers}}))
        sys.stdout.write("\n")

if __name__ == "__main__":
    main()
