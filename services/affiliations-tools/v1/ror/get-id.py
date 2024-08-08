#!/usr/bin/env python3
import json
import sys
import requests
from requests.exceptions import HTTPError, Timeout, RequestException
from ratelimit import limits, RateLimitException
from backoff import on_exception, expo


# Fonction de modification de la première virgule de l'affiliation
# !!! essentiel car le WS adresse/parse normalise les virgules !!!
def change_part(affiliation):
    aff_change = affiliation.replace(",", "!", 2)
    return aff_change


# Fonction de WS de découpage d'adresse
def ws_affiliation(affiliation):
    url = "https://affiliations-tools.services.istex.fr/v1/addresses/parse"
    headers = {"accept": "application/json", "Content-Type": "application/json"}
    data = [{"id": affiliation, "value": affiliation}]
    response = requests.post(url, headers=headers, json=data)
    response.raise_for_status()
    return response.json()


# Extraction de la valeur "house" de sortie du WS
def extract_house(affiliation_data):
    for item in affiliation_data:
        value = item.get("value", {})
        address = value.get("value", {})
        houses = address.get("house", "")
        if not houses:
            return "n/a"

        house_list = houses.split("!")
        if house_list:
            first_house = house_list[0].lower().strip()
            keywords = ["department", "departament"]
            found_house = None

            for keyword in keywords:
                if keyword in first_house:
                    if len(house_list) > 1:
                        found_house = house_list[1].strip()
                        break

            if found_house:
                return found_house

            return first_house

        return "n/a"
    return "n/a"


# Extraction de la valeur "city" de sortie du WS
def extract_city(affiliation_data):
    for item in affiliation_data:
        value = item.get("value", {})
        address = value.get("value", {})
        city = address.get("city", "")
        result = city.title()
    return result


# Requêtage de l'API pour les données filtrées
@on_exception(expo, RateLimitException, max_time=60)
@limits(calls=5, period=1)
def request(name):
    if not name.strip():
        return "Error"

    url = f"https://api.ror.org/organizations?affiliation={name.replace(' ', '%20')}"
    if url == "https://api.ror.org/organizations?affiliation=n/a":
        return "Error affiliation"

    try:
        response = requests.get(url, headers={"Accept": "application/json"})
        response.raise_for_status()
    except HTTPError as http_err:
        print(f"HTTP error occurred: {http_err}",file=sys.stderr)  # Erreur HTTP (par exemple, 404, 500, etc.)
    except Timeout as timeout_err:
        print(f"Timeout error occurred: {timeout_err}",file=sys.stderr)  # La requête a expiré
    except RequestException as req_err:
        print(f"Error occurred: {req_err}",file=sys.stderr)  # Autres erreurs (par exemple, problèmes de connexion, etc.)
    else:
        return response.json()


# Fonction d'appel de toutes les fonctions précédentes
def api_ror(affiliation):
    new_aff = change_part(affiliation)
    aff_ws = ws_affiliation(new_aff)
    name = extract_house(aff_ws)
    city = extract_city(aff_ws)
    result = request(name)
    return result, city


# Filtre la sortie de l'API ROR pour ne récupérer que ce qui intéresse
def filter_api(json, city=None, short=False):
    if json == "Error affiliation" or json == "Error":
        return "Error affiliation"    

    for item in json["items"]:
        id_ror = item["organization"]["id"]
        score_similarity = item["score"]
        name = item["organization"]["name"]
        type = item["organization"]["types"]
        name_geonames = item["organization"]["addresses"][0]["geonames_city"]["geonames_admin2"]["name"]
        id_geonames = item["organization"]["addresses"][0]["geonames_city"]["geonames_admin2"]["id"]
        # json_dict = {"id_ror": id_ror, "score": score_similarity, "name": name}
        json_dict = {
            "id_ror": id_ror,
            "score": score_similarity,
            "name": name,
            "type": type,
            "name_geonames": name_geonames,
            "id_geonames": id_geonames,
        }
        if city:
            if item["organization"]["addresses"][0]["city"].lower() == city.lower():
                return json_dict
            elif short:
                return json_dict
        elif short == True:
            return json_dict
        else:
            return "no-city"

    if city:
        return "No match found"

    return None


def main():
    for line in sys.stdin:
        data = json.loads(line)
        affiliation = data["value"]

        # Boucle pour les affiliations longues (utilisation du WS + house +
        # city)
        if len(affiliation.split(",")) > 2:
            extracted_info, city = api_ror(affiliation)
            # Si l'API a donné une réponse
            if extracted_info is not None:
                filter_affiliation = filter_api(extracted_info, city)

                if filter_affiliation:
                    data["value"] = filter_affiliation

                else:
                    data["value"] = "No match found"

            else:
                data["value"] = "No house found"

        # Boucle pour l'affiliation courte (simple, on envoie tout)
        else:
            aff_short = request(affiliation)
            data["value"] = filter_api(aff_short, short=True)
        sys.stdout.write(json.dumps(data, ensure_ascii=False))
        sys.stdout.write("\n")


if __name__ == "__main__":
    main()
