#!/usr/bin/env python3
import json
import sys
import requests
from requests.exceptions import HTTPError, Timeout, RequestException
from ratelimit import limits, RateLimitException
from backoff import on_exception, expo

# Normalisation ville (supprime " City" de la ville)
def normalize_city(city):
    if isinstance(city, str):
        normalized = city.replace(" city", "").strip()
        return normalized
    return city

# Fonction de WS de découpage d'adresse
def ws_affiliation(affiliation):
    url = "http://localhost:31976/v1/addresses/parse"
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

    return houses


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
        return "Error"

    try:
        response = requests.get(url, headers={"Accept": "application/json"})
        response.raise_for_status()
    except HTTPError as http_err:
        print(
            f"HTTP error occurred: {http_err}", file=sys.stderr
        )  # Erreur HTTP (par exemple, 404, 500, etc.)
    except Timeout as timeout_err:
        print(
            f"Timeout error occurred: {timeout_err}", file=sys.stderr
        )  # La requête a expiré
    except RequestException as req_err:
        print(
            f"Error occurred: {req_err}", file=sys.stderr
        )  # Autres erreurs (par exemple, problèmes de connexion, etc.)
    else:
        return response.json()


# Fonction d'appel de toutes les fonctions précédentes
def api_ror(affiliation):
    aff_ws = ws_affiliation(affiliation)
    name = extract_house(aff_ws)
    city = extract_city(aff_ws)
    result = request(name)
    return result, city


# Filtre la sortie de l'API ROR pour ne récupérer que ce qui intéresse
def filter_api(json, city=None, short=False):
    if json == "Error":
        return {"status": "Unexpected data"}

    if json and "items" in json:
        for item in json["items"]:
            try :
                matching_string = item["substring"]
                id_ror = item["organization"]["id"]
                score_similarity = item["score"]

                all_names = item["organization"]["names"]
                name_display = all_names[0]["value"]

                for name in all_names:
                    for type_name in name["types"]:
                        if type_name in ("label", "ror_display"):
                            name_display = name["value"]
                            break
                    else:
                        continue
                    break

                all_relations = item.get("organization", {}).get("relationships", [])

                parent_relations = []
                for relation in all_relations:
                    if relation.get("type", "").lower() == "parent":
                        parent_relations.append(relation.get("label", "Unknown"))

                ror_relations = []
                for relation in all_relations:
                    if relation.get("type", "").lower() == "parent":
                        ror_relations.append(relation.get("id", "Unknown"))

                type = item["organization"]["types"]
                name_geonames = item["organization"]["locations"][0]["geonames_details"]["name"]
                id_geonames = item["organization"]["locations"][0]["geonames_id"]

                # Normalisation de la ville
                normalized_geonames_city = normalize_city(name_geonames)

                json_dict = {
                    "status": "Found",
                    "matching_string": matching_string,
                    "information_ror": {
                        "id_ror": id_ror,
                        "score": score_similarity,
                        "name": name_display,
                        "parent_organization": parent_relations,
                        "parent_ror" : ror_relations,
                        "type": type,
                        "city": normalized_geonames_city,
                        "id_geonames": id_geonames,
                    },
                }
            except Exception:
                json_dict = {"status": "Incomplete data"}
                return json_dict

            if city:
                try:
                    # Comparaison avec la ville normalisée
                    if normalized_geonames_city.lower() == normalize_city(city).lower():
                        return json_dict
                    elif short:
                        return json_dict
                except :
                    json_dict = {"status": "Incomplete data"}
                    return json_dict

            elif short:
                return json_dict
            else:
                json_dict = {"status": "No city found", "matching_string": matching_string, "information_ror" : {}}
                return json_dict

        if city:
            json_dict = {"status": "No match found","matching_string": matching_string,"information_ror" : {}}
            return json_dict

        return None
    else:
        json_dict = {"status": "Unexpected data"}
        return json_dict

def main():
    for line in sys.stdin:
        data = json.loads(line)
        affiliation = data["value"]

        # Boucle pour les affiliations longues (utilisation du WS + house + city)
        if len(affiliation.split(",")) > 2:
            extracted_info, city = api_ror(affiliation)
            # Si l'API a donné une réponse
            if extracted_info is not None:
                filter_affiliation = filter_api(extracted_info, city)

                if filter_affiliation:
                    data["value"] = filter_affiliation

                else:
                    # Par exemple : "NSF’s National Optical-Infrared Astronomy Research Laboratory, 950 North Cherry Avenue, Paris, AZ 85719, USA"
                    # Boucle "sécurité" > "filter_api"
                    data["value"] = {"status": "No match found"}

            else:
                # Boucle "sécurité" > "extract_house"
                data["value"] = {"status": "No house found"}

        # Boucle pour l'affiliation courte (simple, on envoie tout)
        else:
            aff_short = request(affiliation)
            data["value"] = filter_api(aff_short, short=True)
        sys.stdout.write(json.dumps(data, ensure_ascii=False))
        sys.stdout.write("\n")


if __name__ == "__main__":
    main()
