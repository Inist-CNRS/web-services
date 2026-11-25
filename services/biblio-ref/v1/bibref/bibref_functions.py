import os
import re
import sys
import pickle
import datetime
import unicodedata
import urllib.parse
from functools import lru_cache

from requests_ratelimiter import LimiterSession
from thefuzz import fuzz


CROSSREF_TOKEN = os.getenv("CROSSREF_API_KEY")
METADORE_TOKEN = os.getenv("METADORE_API_KEY")
METADORE_URL = os.getenv("METADORE_URL")
CROSSREF_URL = "https://api.crossref.org/works"

crossref_headers = {
    "Crossref-Plus-API-Token": CROSSREF_TOKEN
}
metadore_headers = {
    "X-API-KEY": METADORE_TOKEN
}

session_crossref = LimiterSession(per_second=10)
session_metadore = LimiterSession(per_second=10)
REQUEST_TIMEOUT = 10  # seconds.
title_match_threshold = 0.84
source_match_threshold = 0.8


def _load_doi_set(path):
    """Load a pickled collection of DOIs as a frozenset of lowercase DOIs (O(1) lookups)."""
    with open(path, "rb") as file:
        return frozenset(doi.lower() for doi in pickle.load(file))


# get a list of retracted DOIs
retracted_doi = _load_doi_set("v1/annulled.pickle")

# get a list of clayfeet DOIs
clayfeet_doi = _load_doi_set("v1/clayfeet.pickle")


# Regex compiled once (instead of at each call)
_ACCENTS_RE = re.compile("[\u0300-\u036f]")
_NON_ALNUM_RE = re.compile(r"[\W_]+")
_SPACES_RE = re.compile(r"\s+")
_YEAR_RE = re.compile(r"(?<!\d)(?:19|20)\d{2}(?!\d)")
_HTML_TAG_RE = re.compile(r"<[^>]*>")
_RETRACTED_RE = re.compile(r"^(RETRACT(?:ED)?(?:ION)?\s?(?:ARTICLE)?\s?:\s?)", flags=re.IGNORECASE)
_ARXIV_RE = re.compile(r"(?<!\d)(\d{4}\.\d{4,5}(?:v\d+)?)(?!\d)")

# Default mode : the DOI stops at the first space, comma or quotation mark.
_DOI_RE = re.compile(r"(?<!\d)(10\.\d{4,9}/)([^\s,\"“”«»]*)")

# "Broken DOI" mode (line break / OCR) : spaces are allowed inside the DOI, but it
# stops at the usual end markers: a comma, a dot followed by a space, a quotation
# mark, a standalone dash / pipe (" - "), an opening bracket or the end of the text.
_DOI_SPLIT_RE = re.compile(
    r"(?<!\d)(10\.\d{4,9}/)(.*?)"
    r"(?=,|\.(?:\s|$)|[\"“”«»]|\s[-–—|]\s|\s[(\[]|$)",
    flags=re.DOTALL,
)
_CLOSING_BRACKETS = {")": "(", "]": "[", "}": "{"}


def write_in_logs(message):
    date_error = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    sys.stderr.write(f"{date_error}: {message}\n")


def remove_accents(text):
    """
    Remove accents from the input text and return the text with no accents.

    Parameters:
        text (str): The input text with accents.

    Returns:
        str: The input text with accents removed.
    """
    if text == "" or not isinstance(text, str):
        return ""
    return _ACCENTS_RE.sub("", unicodedata.normalize("NFD", text))


@lru_cache(maxsize=4096)
def _uniformize_str(text):
    text = remove_accents(text)
    # remove punctuation (runs of non alphanumeric characters become one space)
    return _NON_ALNUM_RE.sub(" ", text).lower().strip()


def uniformize(text):
    """
    Uniformize the given text by removing accents, punctuation, and converting to lowercase.
    The result is cached : the same biblio ref is uniformized many times when it is
    compared with the 5 crossref results.
    Args:
        text (str): a string input text to be uniformized
    Returns:
        str: a string with uniformized text
    """
    if not isinstance(text, str):
        return ""
    return _uniformize_str(text)


def extract_year_from_ref(ref_biblio):
    """
    Extrait la date d'une référence bibliographique par regex
    (une année isolée : les 4 chiffres ne doivent pas faire partie d'un nombre plus long,
    sinon un DOI comme 10.1000/07420528 donnerait "2052")
    """
    year_match = _YEAR_RE.search(ref_biblio)

    return year_match.group(0) if year_match else None


def process_mismatches(mismatches_json):
    """
    Here is a function, to update easily mismatches output.
    """
    return " ; ".join(mismatches_json)


def _strip_doi_tail(doi):
    """
    Remove the punctuation at the end of a DOI which belongs to the sentence
    (".", ",", ";", ":", quote, unbalanced closing bracket).
    A balanced bracket is kept : 10.1016/0021-9681(87)90171-8 is a valid DOI.
    """
    while doi:
        last = doi[-1]
        if last in ".,;:'’":
            doi = doi[:-1]
        elif last in _CLOSING_BRACKETS and doi.count(last) > doi.count(_CLOSING_BRACKETS[last]):
            doi = doi[:-1]
        else:
            break
    return doi


def find_doi(text, delete_line_break=False, process_deleted_underscore=False):
    """
    Cherche un DOI dans le texte donné.

    Par défaut, le DOI s'arrête au premier espace, à la première virgule ou au
    premier guillemet. Les points / parenthèses finales (ponctuation de la
    phrase) sont retirés.

    Quand le DOI est coupé (saut de ligne) ou qu'un "_" a été remplacé par un
    espace (OCR), le DOI contient des espaces. Avec l'un des deux paramètres
    ci-dessous, on accepte donc les espaces dans le DOI, mais on s'arrête aux
    marqueurs de fin habituels : virgule, ". ", guillemet, " - ", " (", " [",
    ou la fin du texte.

    Args:
        text (str): le texte dans lequel chercher le DOI.
        delete_line_break (bool): si True, les espaces/retours à la ligne
            trouvés à l'intérieur du DOI (coupure due à un saut de ligne)
            sont supprimés.
        process_deleted_underscore (bool): si True, les espaces trouvés à
            l'intérieur du DOI sont remplacés par des "_" (underscore perdu
            à l'OCR). Prioritaire sur delete_line_break si les deux sont True.
    Returns:
        str: le DOI trouvé (en minuscules), ou une chaîne vide si non trouvé.
    """
    if not isinstance(text, str):
        return ""

    if delete_line_break or process_deleted_underscore:
        match = _DOI_SPLIT_RE.search(text)
    else:
        match = _DOI_RE.search(text)

    if match is None:
        return _find_arxiv_id(text)

    prefix, suffix = match.group(1), match.group(2)

    if process_deleted_underscore:
        suffix = _SPACES_RE.sub("_", suffix.strip())
    elif delete_line_break:
        suffix = _SPACES_RE.sub("", suffix)

    return _strip_doi_tail((prefix + suffix).lower())


def _find_arxiv_id(text):
    if "arxiv" not in text.lower():
        return ""
    arxiv_id = _ARXIV_RE.search(text)
    if arxiv_id is None:
        return ""
    return "10.48550/arxiv." + arxiv_id.group(1).lower()


def _special_status(doi, retracted_doi, clayfeet_doi):
    """Return "retracted", "feet_of_clay" or "" for a DOI."""
    doi = doi.lower()
    if doi in retracted_doi:
        return "retracted"
    if doi in clayfeet_doi:
        return "feet_of_clay"
    return ""


def _result(doi, status, reference_found, mismatches):
    """Build the dict returned by biblio_ref (one single place to update the output)."""
    return {
        "doi": doi,
        "status": status,
        "reference_found": reference_found,
        "mismatches_detected": process_mismatches(mismatches)
    }


# specially designed functions for crossref API
def get_title_authors_doi_source_date(message):
    """
    Get the title, first author's given name, first author's family name,
    and DOI from the input message.
    Objective : For a response to crossref API, this function is used to get
    informations from this response.
    Args:
        message (dict): The input message containing information about the
        publication.
    Returns:
        dict: A dictionary containing the title, first author's given name,
        first author's family name, and DOI.
    """
    doi = message["DOI"] if "DOI" in message else ""

    try:
        title = message["title"][0] if "title" in message else ""
    except Exception:
        title = ""

    try:
        first_author_name = message["author"][0]["family"]
    except Exception:
        first_author_name = ""
    try:
        first_author_given = message["author"][0]["given"]
    except Exception:
        first_author_given = ""

    date = ""

    try:
        date_fields = ["issued", "published", "published-print", "published-online"]

        for field in date_fields:
            if field in message and "date-parts" in message[field]:
                date_parts = message[field]["date-parts"]
                if date_parts and isinstance(date_parts[0], list) and date_parts[0]:
                    date = str(date_parts[0][0]).replace(" ", "")  # Année uniquement
                    break
    except Exception:
        date = ""

    source = {}

    try:
        source["source-long"] = message["container-title"][0]
    except Exception:
        try:
            source["source-long"] = message["event"]["name"]
        except Exception:
            source["source-long"] = ""
    try:
        source["source-short"] = message["short-container-title"][0]
    except Exception:
        try:
            source["source-short"] = message["event"]["acronym"]
        except Exception:
            source["source-short"] = ""

    # RAW_REF
    raw_ref = "FROM CROSSREF > "

    try:
        if len(message["author"]) >= 2:
            raw_ref += f"{first_author_name} et al."
        # I keep this other possibility for later
        # elif len(message["author"])==2:
        #     raw_ref += f' ({message["author"][0]["given"]} {message["author"][0]["family"]} and {message["author"][1]["given"]} {message["author"][1]["family"]}), '
        else:
            raw_ref += f'{first_author_given} {first_author_name}.'
    except Exception:
        raw_ref += " "

    if len(date) > 0:
        raw_ref += f" ({date}). "

    raw_ref += " "+title+". "

    if len(source["source-long"]) > 0:
        raw_ref += f' {source["source-long"]}. '
    else:
        if len(source["source-short"]) > 0:
            raw_ref += f' {source["source-short"]}. '

    if len(doi) > 0:
        raw_ref += f" {doi}."

    return {
        "title": title,
        "first_author_given": first_author_given,
        "first_author_name": first_author_name,
        "doi": doi.rstrip("."),
        "date": str(date),
        "source": source,
        "raw_ref": raw_ref.replace("  ", " ")
        }


def verify_doi_crossref(doi, headers=crossref_headers):
    """
    Verify a Digital Object Identifier (DOI) by making a GET request to
    the Crossref API.

    Args:
        doi (str): The DOI to be verified.
        headers (dict): headers of the request (Crossref Plus token).

    Returns:
        (int,dict): status code of the API response and dict informations found
    """
    url = f"{CROSSREF_URL}/{urllib.parse.quote(doi)}"

    try:
        response = session_crossref.get(url, headers=headers, timeout=REQUEST_TIMEOUT)
        status_code = response.status_code
    except Exception as e:
        write_in_logs("Error while checking DOI : " + str(e))
        return (503, None)  # if there is an unexpected error from crossref

    if status_code != 200:
        return (status_code, None)

    try:
        message = response.json()["message"]
        others_biblio_info = get_title_authors_doi_source_date(message)
        return (status_code, others_biblio_info)

    except Exception as e:
        write_in_logs("Error while processing crossref response : " + str(e))
        return (503, None)  # if there is an unexpected error from crossref


def clean_crossref_title(text):
    """
    Function to delete "retracted" informations from crossref title
    Objective : Sometimes, title starts with "RETRACTED >".
    this function delete this to clean title for comparison

    Args:
        text (str): the title

    Returns:
        text: the title without retracted informations
    """
    text = _RETRACTED_RE.sub("", text, count=1)

    if "</" in text:
        text = _HTML_TAG_RE.sub("", text)

    return text.strip()


def compute_partial_ratio(bibliographic_item, raw_ref):
    # L'ordre importe ! la chaîne la plus longue à droite
    return fuzz.partial_ratio(uniformize(bibliographic_item), uniformize(raw_ref))/100


# Functions that compare informations between the Crossref metadata and
# the bibliographic reference given.
def compare_pubinfo_refbiblio(item, ref_biblio):
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
        tuple (int, float, str, dict):
            number of matching criteria, title score, doi, and the
            informations that differ
    """
    items_score = 0
    potential_different_content = {}

    # Title
    title_score = compute_partial_ratio(clean_crossref_title(item["title"]), ref_biblio)

    if title_score > title_match_threshold:
        items_score += 1
    else:
        potential_different_content["title"] = item["title"]

    # Check first author
    first_author = uniformize(item["first_author_name"])
    if first_author and first_author in ref_biblio:
        items_score += 1
    else:
        potential_different_content["first_author_name"] = item["first_author_name"]

    # Date
    ref_year = extract_year_from_ref(ref_biblio)

    if item["date"] and item["date"] == ref_year:
        items_score += 1
    else:
        potential_different_content["date"] = item["date"]

    # Source
    if (compute_partial_ratio(item["source"]["source-short"], ref_biblio) > source_match_threshold
            or compute_partial_ratio(item["source"]["source-long"], ref_biblio) > source_match_threshold):
        items_score += 1
    else:
        if len(item["source"]["source-long"]) > 0:
            potential_different_content["source"] = item["source"]["source-long"]
        elif len(item["source"]["source-short"]) > 0:
            potential_different_content["source"] = item["source"]["source-short"]

    try:
        doi = item["doi"].lower()
    except Exception:
        write_in_logs("Can't lower doi")
        doi = ""

    return items_score, title_score, doi, potential_different_content


# This is the function to update if you want stronger or weaker criteria
# For now, criteria is 2 or more matches on informations on title, authors, date and source except if it is date and source.
def verify_biblio_without_doi(ref_biblio, headers=crossref_headers, wrong_doi=False):
    """
    check with crossref api if a biblio ref is correct.
    Objective : In this function, we check if the biblio ref exist if no doi
    is found : we use as critera the compare_pubinfo_refbiblio function

    Args :
        ref_biblio :a biblio ref
        headers : headers of the request (Crossref Plus token)
        wrong_doi : True if the reference has a DOI which doesn't exist

    Returns :
        a confidence score about the existence + doi of the biblio ref
    """
    params = {"query.bibliographic": ref_biblio, "rows": 5}  # take only the 5 first results
    hallucinated = False
    most_similar_item_info = {"raw_ref": ""}

    try:
        response = session_crossref.get(CROSSREF_URL, params=params, headers=headers, timeout=REQUEST_TIMEOUT)
        response.raise_for_status()
        items = response.json()["message"]["items"]  # to check

        for item in items:
            item_info = get_title_authors_doi_source_date(item)

            # compare pub_info with ref_biblio
            match_items_score, title_score, doi, potential_different_content = compare_pubinfo_refbiblio(item_info, ref_biblio)

            # Matches criteria when there is no doi in the reference
            if match_items_score >= 3:
                return "found", doi, item_info, potential_different_content

            # if doi is wrong
            if wrong_doi:
                continue

            if title_score < 0.6:
                continue

            if title_score > 0.9 and match_items_score < 2:
                hallucinated = True
                most_similar_item_info = item_info
                continue

            if match_items_score == 2 and title_score > 0.98:
                return "found", doi, item_info, potential_different_content

            # Here match_items_score =/= title that's why it's 2 either
            if match_items_score == 2 and 0.6 < title_score < 0.9:
                return "found", doi, item_info, potential_different_content

        if wrong_doi:
            return "to_be_verified", "", {"raw_ref": ""}, {}

        if hallucinated:
            return "to_be_verified", "", most_similar_item_info, {}

        else:
            return "not_found", "", {"raw_ref": ""}, {}

    except Exception as e:
        write_in_logs("Error in verify_biblio function : " + str(e))
        return "error_service", "", {"raw_ref": ""}, {}


def _doi_candidates(doi, raw_ref):
    """
    Yield the DOI variants to try, without duplicates :
      1. the DOI as found
      2. without the spaces due to a line break
      3. with "_" instead of the spaces (underscore lost by the OCR)
    When the DOI has no space, the 3 variants are the same : only one API
    call is made (instead of 3 identical calls on each 404).
    """
    seen = set()
    for candidate in (
        doi.strip("."),
        find_doi(raw_ref, delete_line_break=True),
        find_doi(raw_ref, process_deleted_underscore=True),
    ):
        # a candidate ending with "/" is only a DOI prefix : nothing to check
        if candidate and not candidate.endswith("/") and candidate not in seen:
            seen.add(candidate)
            yield candidate


def _process_doi(doi, raw_ref, verify_func):
    """
    Check a DOI with verify_func (Crossref or Metadore). Process if this one is cut
    (line break) or if "_" was replaced by spaces (OCR) : the next variant is tried
    only if the previous one is not found (404).

    Returns:
        (int, str, dict): status code, the DOI which gave this status code
        (the DOI found in the reference if no variant exists), informations found
    """
    status_code, others_biblio_info = 404, None
    for candidate in _doi_candidates(doi, raw_ref):
        status_code, others_biblio_info = verify_func(candidate)
        if status_code != 404:
            return status_code, candidate, others_biblio_info
    # Nothing found : we keep the DOI of the reference (not the last variant tried)
    return status_code, doi, others_biblio_info


def process_crossref_doi(doi, raw_ref):
    """Check DOI on Crossref. Process if this one is cut (line break) or if "_" was replaced by spaces (OCR)."""
    return _process_doi(doi, raw_ref, verify_doi_crossref)


def get_title_authors_doi_source_date_metadore(message):
    """
    Get the title, first author's given name, first author's family name,
    and DOI from the input message.
    Objective : For a response to Metadore API, this function is used to get
    informations from this response.
    Args:
        message (dict): The input message containing information about the
        publication.
    Returns:
        dict: A dictionary containing the title, first author's given name,
        first author's family name, and DOI.
    """
    doi = message["doi"] if "doi" in message else ""

    try:
        title = message["titles"][0]["title"]
    except Exception:
        title = ""

    try:
        first_author_name = message["creators"][0]["familyName"]
    except Exception:
        first_author_name = ""
    try:
        first_author_given = message["creators"][0]["givenName"]
    except Exception:
        first_author_given = ""

    date = ""  # Before : "date" was not defined when there was no year (NameError)
    try:
        match = _YEAR_RE.search(message["dates"][0]["date"])
        if match:
            date = match.group()
    except Exception:
        date = ""

    try:
        source = message["publisher"]
    except Exception:
        source = ""

    # RAW REF
    raw_ref = "FROM DATACITE > "

    try:
        if len(message["creators"]) >= 2:
            raw_ref += f"{first_author_name} et al. "
        else:
            raw_ref += f'{first_author_given} {first_author_name}. '
    except Exception:
        raw_ref += " "

    if len(date) > 0:
        raw_ref += f" ({date}). "

    raw_ref += " "+title+". "

    if len(source) > 0:
        raw_ref += f"{source}. "

    if len(doi) > 0:
        raw_ref += f"{doi}"

    return {
        "title": title,
        "first_author_given": first_author_given,
        "first_author_name": first_author_name,
        "doi": doi,
        "date": str(date),
        "source": {
            "source-short": source,
            "source-long": source
        },
        "raw_ref": raw_ref.replace("  ", " ")
    }


def verify_doi_metadore(doi, headers=metadore_headers):
    """
    Verify a Digital Object Identifier (DOI) by making a GET request to
    the Metadore API.

    The API can answer with approximate matches : we only keep the record whose
    DOI is exactly the DOI we asked for (before, the first record was always
    taken, even if it had nothing to do with the DOI).

    Args:
        doi (str): The DOI to be verified.
        headers (dict): headers of the request (Metadore token).

    Returns:
        (int,dict): status code of the API response and dict informations found
    """
    params = {"query": f'(attributes.doi:"{doi}")'}  # requests does the url encoding
    try:
        response = session_metadore.get(METADORE_URL, params=params, headers=headers, timeout=REQUEST_TIMEOUT)
        status_code = response.status_code
    except Exception as e:
        write_in_logs("Error while checking DOI on metadore : " + str(e))
        return (503, None)  # if there is an unexpected error from metadore

    if status_code != 200:
        return (status_code, None)

    try:
        for record in response.json()["data"]:
            attributes = record["attributes"]
            if (attributes.get("doi") or "").lower() == doi.lower():
                return (status_code, get_title_authors_doi_source_date_metadore(attributes))
        return (404, None)

    except Exception as e:
        write_in_logs("Error while processing metadore response : "+str(e))
        return (503, None)  # if there is an unexpected error from metadore


def process_metadore_doi(doi, raw_ref):
    """Check DOI on Metadore. Process if this one is cut (line break) or if "_" was replaced by spaces (OCR)."""
    return _process_doi(doi, raw_ref, verify_doi_metadore)


def _check_doi_found(doi, others_biblio_info, ref_biblio, retracted_doi, clayfeet_doi,
                     found_mismatches=True, suspect_mismatches=False):
    """
    Common part for a DOI which exists on Crossref or on Metadore.

    If the DOI is most of the reference (len(doi)*2 > len(ref_biblio)), there is nothing
    else to compare. Otherwise, the metadata are compared with the reference : less than 3
    matching criteria means that the DOI is probably hallucinated.

    found_mismatches / suspect_mismatches : do we return the mismatches for "found" /
    "to_be_verified". Crossref : (True, False). Metadore : (False, True), it is the
    historical behaviour of the code (the opposite of Crossref, maybe by mistake).
    """
    reference_found = others_biblio_info["raw_ref"]
    only_doi = len(doi)*2 > len(ref_biblio)
    potential_different_content = {}

    if not only_doi:
        match_items_score, title_score, doi, potential_different_content = compare_pubinfo_refbiblio(others_biblio_info, ref_biblio)

    ### Can be retracted or clayfeet
    special_status = _special_status(doi, retracted_doi, clayfeet_doi)
    if special_status:
        return _result(doi, special_status, reference_found, potential_different_content)

    ### can be hallucinated
    if not only_doi and match_items_score < 3:
        # We return "REFERENCE ASSOCIATED WITH THE DOI" when we suspect an hallucination
        reference_found = "REFERENCE ASSOCIATED WITH THE DOI " + reference_found
        return _result("", "to_be_verified", reference_found,
                       potential_different_content if suspect_mismatches else {})

    return _result(doi, "found", reference_found,
                   potential_different_content if found_mismatches else {})


def biblio_ref(ref_biblio, retracted_doi=retracted_doi, clayfeet_doi=clayfeet_doi):
    """
    The main function of this service : use all previous function to validate a biblio ref.
    Args:
        ref_biblio (str): raw ref
        retracted_doi (set): retracted references - from pps
        clayfeet_doi(set): feet of clay references - from pps
    """
    # check types
    if not isinstance(ref_biblio, str):
        return _result("", "error_data", "", {})

    doi = find_doi(ref_biblio)
    save_ref_biblio = ref_biblio
    ref_biblio = uniformize(ref_biblio)  # Warning : in the rest of code, the biblio ref is uniformized (remove some informations)

    # First case : doi is found
    if doi:
        others_biblio_info = None
        # Use crossref API only if the doi is not from arxiv (DataCite DOI)
        if "arxiv" not in doi.lower():
            crossref_status_code, doi, others_biblio_info = process_crossref_doi(doi, save_ref_biblio)
        else:
            crossref_status_code = 404

        # # If DOI exists
        if crossref_status_code == 200:
            return _check_doi_found(doi, others_biblio_info, ref_biblio, retracted_doi, clayfeet_doi,
                                    found_mismatches=True, suspect_mismatches=False)

        # # If DOI doesn't exist
        elif crossref_status_code == 404:

            # # Check if it is a DataCite DOI using MetaDoRe
            metadore_status_code, doi, others_biblio_info = process_metadore_doi(doi, save_ref_biblio)
            if metadore_status_code == 200:
                return _check_doi_found(doi, others_biblio_info, ref_biblio, retracted_doi, clayfeet_doi,
                                        found_mismatches=False, suspect_mismatches=True)

            status, doi, others_biblio_info, potential_different_content = verify_biblio_without_doi(ref_biblio, wrong_doi=True)
            reference_found = others_biblio_info["raw_ref"]

            ### can't be not found : there is a doi. Should be on Crossref or DataCite.
            if status == "not_found":
                return _result("", "to_be_verified", "", {})

            ### Can be retracted or clayfeet
            special_status = _special_status(doi, retracted_doi, clayfeet_doi)
            if special_status:
                return _result(doi, special_status, reference_found, potential_different_content)

            return _result(doi, status, reference_found, potential_different_content)

        ### for others errors
        else:
            write_in_logs("DOI requests failed. Crossref status code :" + str(crossref_status_code))
            return _result("", "error_service", "", {})

    # second case : no doi is found
    else:
        status, doi, others_biblio_info, potential_different_content = verify_biblio_without_doi(ref_biblio)
        reference_found = others_biblio_info["raw_ref"]

        if status != "not_found":
            ### Can be retracted or clayfeet
            special_status = _special_status(doi, retracted_doi, clayfeet_doi)
            if special_status:
                return _result(doi, special_status, reference_found, potential_different_content)

        if status != "found":
            potential_different_content = {}
        return _result(doi, status, reference_found, potential_different_content)
