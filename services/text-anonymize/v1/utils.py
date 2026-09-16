"""
Anonymiseur de texte multilingue (FR / EN) : détecte et remplace les données
personnelles (emails, téléphones, dates de naissance, adresses, identifiants,
mots de passe, noms de personnes, ...) par des balises génériques.

Pour changer de langue, modifier la variable LANGUE ci-dessous ("fr" ou "en").

Le script combine 3 niveaux de détection, du plus fiable au moins fiable :

1. LIBELLÉS DE CHAMPS : dans beaucoup de documents (formulaires, fiches,
   emails administratifs), une donnée personnelle est précédée de son nom
   de champ ("Sexe :", "Mot de passe :", "Permis de conduire :", ...).
   Repérer ces libellés permet de catégoriser correctement des valeurs qui
   seraient sinon impossibles à deviner par une simple regex (un mot de
   passe aléatoire, un numéro de bâtiment, un pseudo...).
2. REGEX : motifs autonomes, sans contexte de libellé nécessaire -> emails,
   URLs, IP, IBAN, cartes bancaires, téléphones, dates (formats numériques
   et en toutes lettres), codes postaux, adresses, passeports FR,
   numéros de sécurité sociale FR, coordonnées GPS.
3. NER (spaCy) : détecte les noms de personnes, lieux et organisations
   mentionnés dans du texte libre (hors champs de formulaire).

Le mode NER est optionnel : si le modèle spaCy correspondant n'est pas
installé, le script bascule automatiquement en mode "regex + libellés".

Installation (optionnelle mais recommandée) :
    pip install spacy --break-system-packages
    python -m spacy download fr_core_news_sm   # pour le français
    python -m spacy download en_core_web_sm    # pour l'anglais

Usage :
    from utils import anonymiser
    texte_anonymise = anonymiser(texte)                 # utilise LANGUE définie plus bas
    texte_anonymise = anonymiser(texte, langue="en")     # ou en forçant la langue à l'appel
"""

import re
from functools import lru_cache

# ----------------------------------------------------------------------
# 0. Configuration : langue par défaut du texte à traiter
# ----------------------------------------------------------------------

LANGUE = "fr"  # "fr" pour le français, "en" pour l'anglais

# ----------------------------------------------------------------------
# 1. Détection par libellés de champs ("Label : valeur")
# ----------------------------------------------------------------------
# Chaque entrée : (motif du libellé, tag). Le motif du libellé est complété
# automatiquement pour tolérer du texte variable avant les ":" (ex: "Heure
# de connexion", "Heure de consultation", ... sont tous reconnus par "heure").
# L'ORDRE COMPTE : les libellés les plus spécifiques doivent être placés
# avant les libellés génériques qui les contiennent (ex: "nom d'utilisateur"
# avant "nom" tout court), sinon le générique les intercepterait en premier.

LIBELLES_PAR_LANGUE = {
    "fr": [
        (r"nom\s+d['’]utilisateur", "USERNAME"),
        (r"nom\s+de\s+jeune\s+fille", "LASTNAME1"),
        (r"nom\s+de\s+famille", "LASTNAME1"),
        (r"nom\s+de\s+l['’]\w+", "LASTNAME1"),          # "Nom de l'étudiant/élève"
        (r"pr[ée]nom\s+de\s+l['’]\w+", "GIVENNAME1"),   # "Prénom de l'étudiant"
        (r"deuxi[eè]me\s+pr[ée]nom", "GIVENNAME2"),
        (r"pr[ée]nom\s*1", "GIVENNAME1"),
        (r"pr[ée]nom", "GIVENNAME1"),
        (r"participant\s*id", "USERNAME"),
        (r"[ée]l[eè]ve", "LASTNAME1"),
        (r"membre", "LASTNAME1"),
        (r"deuxi[eè]me\s+adresse\s+de\s+s[ée]curit[ée]", "SECADDRESS"),
        (r"deuxi[eè]me\s+adresse", "SECADDRESS"),
        (r"adresse\s+secondaire", "SECADDRESS"),
        (r"num[ée]ro\s+de\s+s[ée]curit[ée]\s+sociale", "SOCIALNUMBER"),
        (r"s[ée]curit[ée]\s+sociale", "SOCIALNUMBER"),
        (r"num[ée]ro\s+de\s+passeport", "PASSPORT"),
        (r"passeport", "PASSPORT"),
        (r"num[ée]ro\s+d['’]identification\b", "IDCARD"),
        (r"num[ée]ro\s+de\s+carte\s+d['’]identit[ée]", "IDCARD"),
        (r"carte\s+d['’]identit[ée]", "IDCARD"),
        (r"permis\s+de\s+conduire", "DRIVERLICENSE"),
        (r"mot\s+de\s+passe", "PASS"),
        (r"code\s+postal", "POSTCODE"),
        (r"adresse\s+ip", "IP"),
        (r"b[aâ]timent", "BUILDING"),
        (r"coordonn[ée]es\s+gps|g[ée]olocalisation", "GEOCOORD"),
        (r"heure", "TIME"),
        (r"date\s+de\s+naissance", "BOD"),
        (r"date", "DATE"),
        (r"sexe", "SEX"),
        (r"titre", "TITLE"),
        (r"t[ée]l[ée]phone|\btel\b", "TEL"),
        (r"ville", "CITY"),
        (r"r[ée]gion|[ée]tat", "STATE"),
        (r"pays", "COUNTRY"),
        (r"rue", "STREET"),
        (r"email|courriel|e-?mail|\bmail\b", "EMAIL"),
        (r"identifiant|pseudo|username|utilisateur", "USERNAME"),
        (r"adresse", "STREET"),   # générique, en dernier recours
        (r"nom", "LASTNAME1"),    # générique, en tout dernier recours
    ],
    "en": [
        (r"last\s*name\s*2|surname\s*2", "LASTNAME2"),
        (r"last\s*name\s*3|surname\s*3", "LASTNAME3"),
        (r"given\s*name\s*2|middle\s+name", "GIVENNAME2"),
        (r"given\s*name\s*1|given\s+name|first\s*name", "GIVENNAME1"),
        (r"user\s*name|user\s*id\b|login", "USERNAME"),
        (r"maiden\s+name", "LASTNAME1"),
        (r"last\s*name\s*1|last\s*name|surname|family\s+name", "LASTNAME1"),
        (r"student\s+name|full\s+name|team\s+member|applicant|student\b(?!\s*id)", "LASTNAME1"),
        (r"second(?:ary)?\s+address", "SECADDRESS"),
        (r"social\s+security(?:\s+number)?|social\s+number|\bssn\b", "SOCIALNUMBER"),
        (r"passport(?:\s+number)?", "PASSPORT"),
        (r"id\s*card(?:\s+(?:number|type))?|identification\s+card|"
         r"farm\s+certification\s+id", "IDCARD"),
        (r"driver.?s?\s+licen[cs]e|licen[cs]e\s*no\.?|licen[cs]e\b", "DRIVERLICENSE"),
        (r"password", "PASS"),
        (r"post\s*code|postal\s*code|zip\s*code", "POSTCODE"),
        (r"ip\s+address", "IP"),
        (r"building(?:\s+(?:number|no\.?))?", "BUILDING"),
        (r"geographical\s+coordinates|gps\s+coordinates?|geoloc\w*", "GEOCOORD"),
        (r"time(?:stamp)?", "TIME"),
        (r"date\s+of\s+birth|birthdate", "BOD"),
        (r"date", "DATE"),
        (r"\bsex\b|gender", "SEX"),
        (r"title", "TITLE"),
        (r"phone(?:\s+number)?|telephone|\btel\b", "TEL"),
        (r"city|town", "CITY"),
        (r"state|region", "STATE"),
        (r"country|nationality", "COUNTRY"),
        (r"street|address\s*line", "STREET"),
        (r"e-?mail", "EMAIL"),
        (r"location|residence", "STREET"),   # générique, en dernier recours
        (r"\bid\b", "IDCARD"),               # générique, en dernier recours
        (r"address", "STREET"),              # générique, en dernier recours
        (r"name", "LASTNAME1"),              # générique, en tout dernier recours
    ],
}


# Classe de caractères tolérés juste avant le libellé (puces, numérotation).
# L'anglais tolère en plus les guillemets, pour le format JSON ("sex": "F").
# Le français garde EXACTEMENT la même classe qu'avant (aucun changement).
PREFIXE_CLASSE_PAR_LANGUE = {
    "fr": r"[\s\-*\d.\)]",
    "en": r"[\s\-*\d.\)\"']",
}

PREFIXE_EXTRA_PAR_LANGUE = {
    "fr": "",
    "en": r"(?:[A-Za-z]{2,15}\s+){0,2}",
}


def _compiler_libelles(langue: str):
    """Compile les patterns de libellés pour la langue donnée.
    Chaque pattern reconnaît : début de ligne/puce -> libellé -> texte libre
    -> ':' -> valeur jusqu'à la fin de la ligne."""
    prefixe_classe = PREFIXE_CLASSE_PAR_LANGUE.get(langue, r"[\s\-*\d.\)]")
    prefixe_extra = PREFIXE_EXTRA_PAR_LANGUE.get(langue, "")
    compiles = []
    for mot_cle, tag in LIBELLES_PAR_LANGUE[langue]:
        # ATTENTION : le préfixe utilise UNE SEULE classe bornée (pas de
        # quantificateurs imbriqués du type (?:X{0,n})*) pour éviter tout
        # risque de backtracking catastrophique (ReDoS) sur des lignes
        # contenant de longues répétitions de tirets/étoiles/points.
        pattern = re.compile(
            rf"(?:^|\n){prefixe_classe}{{0,15}}{prefixe_extra}(?:{mot_cle})[^\n:]{{0,40}}?"
            rf":\s*\**\s*([^\n]+)",
            re.IGNORECASE,
        )
        compiles.append((pattern, tag))
    return compiles


@lru_cache(maxsize=None)
def _libelles_compiles(langue: str):
    return tuple(_compiler_libelles(langue))


def _nettoyer_valeur(valeur: str, start: int):
    """Ajuste le span de la valeur capturée en retirant les espaces/`**`
    de fin de ligne (retours à la ligne markdown) et les guillemets/virgules
    de fin (valeurs au format JSON, ex: "Feminine",), pour ne pas déborder
    sur du texte qui n'est pas la donnée elle-même."""
    debut = valeur
    debut_nettoye = re.sub(r'^[\s"\']+', "", debut)
    decalage_debut = len(debut) - len(debut_nettoye)
    fin_nettoyee = re.sub(r'[\s"\',*]+$', "", debut_nettoye)
    return start + decalage_debut, start + decalage_debut + len(fin_nettoyee)


_BALISE_XML = re.compile(r"<([A-Za-z_]+)>([^<\n]{1,80})</\1>")


def _spans_xml(texte: str, langue: str):
    """Détecte les valeurs au format XML (ex: <sex>M</sex>) en réutilisant
    les mots-clés déjà définis pour les libellés classiques : le nom de la
    balise est comparé aux mêmes motifs que pour "Label : valeur"."""
    spans = []
    zones_prises = []

    def chevauche(a_start, a_end):
        return any(a_start < b_end and b_start < a_end for b_start, b_end in zones_prises)

    mots_cles = LIBELLES_PAR_LANGUE[langue]
    for m in _BALISE_XML.finditer(texte):
        nom_balise = m.group(1)
        for mot_cle, tag in mots_cles:
            if re.fullmatch(mot_cle, nom_balise, re.IGNORECASE):
                start, end = m.start(2), m.end(2)
                if end > start and not chevauche(start, end):
                    spans.append((start, end, tag))
                    zones_prises.append((start, end))
                break
    return spans


def _spans_libelles_avec_zones_protegees(texte: str, langue: str):
    """Comme _spans_libelles, mais retourne en plus les zones correspondant
    au LIBELLÉ lui-même (ex: le mot "Sexe" ou "Ville" avant les ":"). Ces
    zones ne portent pas de tag (ce ne sont pas des données personnelles),
    mais doivent être protégées d'une éventuelle (més)détection par le NER
    (ex: le mot "Ville" est un nom commun que spaCy peut confondre avec un
    lieu réel)."""
    spans = []
    zones_protegees = []

    def chevauche(a_start, a_end):
        return any(a_start < b_end and b_start < a_end for b_start, b_end in zones_protegees)

    for pattern, tag in _libelles_compiles(langue):
        for m in pattern.finditer(texte):
            g_start, g_end = m.start(1), m.end(1)
            g_start, g_end = _nettoyer_valeur(m.group(1), g_start)
            if g_end > g_start and not chevauche(g_start, g_end):
                spans.append((g_start, g_end, tag))
                # on protège tout le match (libellé + valeur), pas seulement
                # la valeur, pour empêcher le NER de retagger le libellé
                zones_protegees.append((m.start(), g_end))
    return spans, zones_protegees


def _spans_libelles(texte: str, langue: str):
    """Retourne les (start, end, tag) détectés via les libellés de champs.
    (Conservé pour compatibilité ; voir _spans_libelles_avec_zones_protegees
    pour la version utilisée par anonymiser(), qui protège aussi le libellé
    lui-même contre le NER.)"""
    spans, _ = _spans_libelles_avec_zones_protegees(texte, langue)
    return spans


# ----------------------------------------------------------------------
# 2. Détection par expressions régulières autonomes (sans libellé), par langue
# ----------------------------------------------------------------------

_EMAIL = re.compile(r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
_URL = re.compile(r"\bhttps?://[^\s]+|\bwww\.[^\s]+")
_IP = re.compile(
    r"\b(?:\d{1,3}\.){3}\d{1,3}\b"                                   # IPv4
    r"|\b(?:[0-9a-fA-F]{1,4}:){2,7}[0-9a-fA-F]{0,4}\b"                # IPv6
)
_CARTE_BANCAIRE = re.compile(r"\b(?:\d[ -]?){13,16}\b")
_IBAN = re.compile(r"\b[A-Z]{2}\d{2}(?:[ ]?[A-Z0-9]{4}){2,7}(?:[ ]?[A-Z0-9]{1,4})?\b")
_TIME = re.compile(r"\b\d{1,2}:\d{2}(?::\d{2})?\b")
_TIME_AMPM = re.compile(r"\b\d{1,2}(?::\d{2})?\s?(?:am|pm)\b", re.IGNORECASE)
_TIME_FR = re.compile(r"\b\d{1,2}\s?h(?:\s?\d{2})?\b")
_GEOCOORD = re.compile(r"-?\d{1,3}\.\d{3,8}\s*,\s*-?\d{1,3}\.\d{3,8}")
_PASSPORT_FR = re.compile(r"\b\d{2}[A-Z]{2}\d{5}\b")
# Carte d'identité FR (repli, sans libellé) : 1 lettre + 7 à 13 chiffres.
# Format assez distinctif (peu de risque de collision) pour être utilisé
# même hors contexte de libellé (ex: listes à puces sans "Carte d'identité :").
_IDCARD_FR = re.compile(r"\b[A-Z]\d{7,13}\b")
# Carte d'identité EN (repli, sans libellé) : 2-3 lettres + 4-6 chiffres +
# 0-2 lettres (ex: "UK57900JK", "XW39670SY"). Format distinct du FR.
_IDCARD_EN = re.compile(r"\b[A-Z]{1,3}\d{4,13}[A-Z]{0,2}\b")
_SOCIALNUMBER_FR = re.compile(
    r"\b[12][\s\-]?\d{2}[\s\-]?(?:0[1-9]|1[0-2])[\s\-]?\d{2}[\s\-]?\d{3}[\s\-]?\d{3}[\s\-]?\d{2}\b"
)

_MOIS_FR = (
    r"jan(?:vier)?|f[ée]v(?:rier)?|mars|avr(?:il)?|mai|juin|juil(?:let)?|"
    r"ao[uû]t|sept(?:embre)?|oct(?:obre)?|nov(?:embre)?|d[ée]c(?:embre)?"
)
_DATE_FR = re.compile(
    rf"\b\d{{1,2}}(?:er|e)?\s+(?:{_MOIS_FR})\.?\s+\d{{2,4}}"           # "23e avril 1948"
    rf"|\b(?:{_MOIS_FR})\.?\s+\d{{1,2}}(?:er|e)?,?\s*\d{{2,4}}"        # "septembre 29, 2000"
    rf"|\b(?:{_MOIS_FR})/\d{{2,4}}"                                    # "décembre/89"
    r"|\b\d{1,2}[/\-.]\d{1,2}[/\-.]\d{2,4}\b",                         # "08/10/1953"
    re.IGNORECASE,
)

_MOIS_EN = (
    r"jan(?:uary)?|feb(?:ruary)?|mar(?:ch)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|"
    r"aug(?:ust)?|sep(?:t(?:ember)?)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?"
)
_DATE_EN = re.compile(
    rf"\b(?:{_MOIS_EN})\.?\s+\d{{1,2}}(?:st|nd|rd|th)?,?\s*\d{{2,4}}"  # "March 15, 2024"
    rf"|\b\d{{1,2}}(?:st|nd|rd|th)?\s+(?:{_MOIS_EN})\.?,?\s*\d{{2,4}}" # "15 March 2024" / "7th August 1963"
    rf"|\b(?:{_MOIS_EN})/\d{{2,4}}"                                    # "September/54"
    r"|\b\d{1,2}[/\-.]\d{1,2}[/\-.]\d{2,4}\b",
    re.IGNORECASE,
)

_TITRES_FR = re.compile(
    r"\b(?:Madame|Monsieur|Mademoiselle|Docteur(?:e)?|Professeur(?:e)?|Ma[iî]tre|"
    r"Abb[ée]|Abbesse|Mairesse|Maire|Huissier|Dame|Sire|Seigneur|Baron(?:ne)?|"
    r"Comte(?:sse)?|Duc(?:hesse)?|Marquis(?:e)?|Vicomte(?:sse)?|Chevalier|[ÉE]cuyer|"
    r"S[ée]nateur(?:rice)?|Prince(?:sse)?|Roi|Reine|Empereur|Imp[ée]ratrice|"
    r"Dr\.|Mme\.?|Mlle\.?|M\.(?=\s[A-ZÀ-Ö]))\b"
)
_TITRES_EN = re.compile(
    r"\b(?:Mr\.?|Mrs\.?|Ms\.?|Miss|Dr\.?|Prof(?:essor)?\.?|Sir|Madam|Dame|"
    r"Lord|Lady|Duke|Duchess|Baron(?:ess)?|Count(?:ess)?|Viscount(?:ess)?|"
    r"Earl|Knight|Friar|Father|Mother|Sister|Brother|Reverend|Rev\.?|"
    r"Mayor(?:ess)?|Prince(?:ss)?|King|Queen|Emperor|Empress)\b"
)

REGEX_PATTERNS_PAR_LANGUE = {
    "fr": {
        "EMAIL": _EMAIL,
        "URL": _URL,
        "IP": _IP,
        "IBAN": _IBAN,
        "PASSPORT": _PASSPORT_FR,
        "SOCIALNUMBER": _SOCIALNUMBER_FR,
        "IDCARD": _IDCARD_FR,
        "CARTE_BANCAIRE": _CARTE_BANCAIRE,
        "TITLE": _TITRES_FR,
        # Les séparateurs sont volontairement OBLIGATOIRES entre les groupes
        # de chiffres (au moins 2 groupes séparés) : ça évite de capturer
        # une suite de chiffres bruts sans séparateur (code postal, ID, ...).
        "TEL": re.compile(
            r"(?:\+\d{1,3}[\s.\-])?0?\d{1,4}(?:[\s.\-]\d{2,4}){2,5}"
        ),
        "ADRESSE": re.compile(
            r"\b\d{1,4}(?:\s?(?:bis|ter))?\s+"
            r"(?:rue|avenue|boulevard|bd|impasse|chemin|all[ée]e|place|route|quai|"
            r"square|villa|passage|cours)\s+"
            r"[A-Za-zÀ-ÖØ-öø-ÿ0-9'’\-\s]{2,40}",
            re.IGNORECASE
        ),
        "GEOCOORD": _GEOCOORD,
        "TIME": re.compile(f"{_TIME.pattern}|{_TIME_FR.pattern}"),
        "DATE": _DATE_FR,
        "CODE_POSTAL": re.compile(r"\b\d{5}\b"),
    },
    "en": {
        "EMAIL": _EMAIL,
        "URL": _URL,
        "IP": _IP,
        "IBAN": _IBAN,
        "IDCARD": _IDCARD_EN,
        "CREDITCARD": _CARTE_BANCAIRE,
        "TITLE": _TITRES_EN,
        # Séparateurs obligatoires entre groupes de chiffres (comme pour le
        # FR) : évite de capturer une suite de chiffres bruts sans séparateur
        # (postcode, ID...).
        "TEL": re.compile(
            r"(?:\+\d{1,3}[\s.\-])?0?\d{1,4}(?:[\s.\-]\d{2,4}){2,5}"
            r"|\(\d{3}\)[\s.\-]?\d{3}[-.\s]?\d{4}"
        ),
        "ADDRESS": re.compile(
            r"\b\d{1,5}[A-Za-z]?\s+[A-Za-z0-9\s]{2,40}\s+"
            r"(?:Street|St|Avenue|Ave|Road|Rd|Boulevard|Blvd|Lane|Ln|"
            r"Drive|Dr|Court|Ct|Place|Pl|Way|Square|Sq|Terrace|Ter)\b",
            re.IGNORECASE
        ),
        "GEOCOORD": _GEOCOORD,
        "TIME": re.compile(f"{_TIME_AMPM.pattern}|{_TIME.pattern}", re.IGNORECASE),
        "DATE": _DATE_EN,
        # Zip US (5 ou 9 chiffres), postcode UK complet ("SW1A 1AA") ou
        # "outward code" seul ("GL54", "WV14", "L39", "B97").
        "POSTCODE": re.compile(
            r"\b\d{5}(?:-\d{4})?\b"
            r"|\b[A-Z]{1,2}\d[A-Z\d]?\s?\d[A-Z]{2}\b"
            r"|\b[A-Z]{1,2}\d{1,2}\b"
        ),
    },
}

# Ordre de priorité : motifs spécifiques avant motifs génériques.
# Les noms de catégories FR (ADRESSE, CODE_POSTAL, CARTE_BANCAIRE) et EN
# (ADDRESS, POSTCODE, CREDITCARD) coexistent dans cette liste partagée :
# chaque langue n'a que les clés qui la concernent dans son propre dict de
# patterns (REGEX_PATTERNS_PAR_LANGUE), donc les clés de l'autre langue sont
# simplement ignorées (voir "if categorie not in patterns" plus bas).
ORDRE_REGEX = [
    "EMAIL", "URL", "IP", "IBAN", "PASSPORT", "SOCIALNUMBER", "IDCARD",
    "CARTE_BANCAIRE", "CREDITCARD",
    "TITLE", "GEOCOORD", "TEL", "ADRESSE", "ADDRESS", "TIME", "DATE",
    "CODE_POSTAL", "POSTCODE",
]


def _spans_regex(texte: str, langue: str, zones_deja_prises=None):
    """Retourne une liste de (start, end, tag) pour tous les motifs regex
    autonomes de la langue donnée, sans chevauchement entre eux ni avec
    des zones déjà attribuées ailleurs (ex: par les libellés)."""
    patterns = REGEX_PATTERNS_PAR_LANGUE[langue]
    spans = []
    zones_prises = list(zones_deja_prises or [])

    def chevauche(a_start, a_end):
        return any(a_start < b_end and b_start < a_end for b_start, b_end in zones_prises)

    for categorie in ORDRE_REGEX:
        if categorie not in patterns:
            continue
        for m in patterns[categorie].finditer(texte):
            start, end = m.start(), m.end()
            if not chevauche(start, end):
                spans.append((start, end, categorie))
                zones_prises.append((start, end))
    return spans


# ----------------------------------------------------------------------
# 3. Détection par NER (noms de personnes, lieux, organisations), par langue
# ----------------------------------------------------------------------

MODELES_SPACY_PAR_LANGUE = {
    "fr": "fr_core_news_sm",
    "en": "en_core_web_sm",
}

LABELS_NER_PAR_LANGUE = {
    "fr": {"PER": "PERSONNE", "LOC": "LIEU", "ORG": "ORGANISATION"},
    "en": {"PERSON": "PERSON", "GPE": "LOCATION", "LOC": "LOCATION", "ORG": "ORGANIZATION"},
}


@lru_cache(maxsize=None)
def _charger_modele_spacy(langue: str):
    """Charge le modèle spaCy correspondant à la langue (mise en cache)."""
    nom_modele = MODELES_SPACY_PAR_LANGUE.get(langue)
    if nom_modele is None:
        return None
    try:
        import spacy
        try:
            return spacy.load(nom_modele)
        except OSError:
            return None
    except ImportError:
        return None


def _spans_ner(texte: str, nlp, langue: str):
    labels = LABELS_NER_PAR_LANGUE[langue]
    doc = nlp(texte)
    spans = []
    for ent in doc.ents:
        tag = labels.get(ent.label_)
        if tag:
            spans.append((ent.start_char, ent.end_char, tag))
    return spans


def precharger_modeles(*langues):
    """Charge à l'avance le(s) modèle(s) spaCy pour la/les langue(s) données
    (utile dans un service long-running, pour ne pas payer le coût du
    chargement lors du tout premier appel à anonymiser()). Sans argument,
    précharge le français et l'anglais."""
    if not langues:
        langues = tuple(MODELES_SPACY_PAR_LANGUE)
    for langue in langues:
        _charger_modele_spacy(langue)


# ----------------------------------------------------------------------
# 4. Fonction principale
# ----------------------------------------------------------------------

def anonymiser(texte: str, utiliser_ner: bool = True, langue: str = None) -> str:
    """
    Anonymise un texte en remplaçant les données personnelles détectées
    par des balises de catégorie ([EMAIL], [TEL], [PASS], [LASTNAME1], ...).

    Paramètres
    ----------
    texte : str
        Le texte à anonymiser.
    utiliser_ner : bool
        Si True (par défaut), tente d'utiliser spaCy pour détecter les noms
        de personnes/lieux/organisations mentionnés en texte libre (hors
        champs de formulaire). Bascule automatiquement en mode sans NER si
        le modèle n'est pas installé.
    langue : str, optionnel
        "fr" ou "en". Si non fourni, utilise la variable globale LANGUE
        définie en haut du fichier.

    Retour
    ------
    str : le texte anonymisé.
    """
    if not texte:
        return texte

    langue = (langue or LANGUE).lower()
    if langue not in REGEX_PATTERNS_PAR_LANGUE:
        raise ValueError(
            f"Langue '{langue}' non supportée. Langues disponibles : "
            f"{list(REGEX_PATTERNS_PAR_LANGUE)}"
        )

    # On détecte TOUTES les entités (libellés + XML[EN uniquement] + regex +
    # NER) sur le texte ORIGINAL, sans jamais modifier le texte entre les
    # étapes, pour éviter toute corruption. Priorité : libellés > XML > regex
    # spécifiques > NER.
    spans, zones_protegees = _spans_libelles_avec_zones_protegees(texte, langue)
    if langue == "en":
        # Format XML (<sex>M</sex>) rencontré dans une partie du dataset EN.
        # Activé UNIQUEMENT pour l'anglais : n'affecte jamais le français.
        zones_tmp = [(s, e) for s, e, _ in spans]
        spans += [
            (s, e, t) for s, e, t in _spans_xml(texte, langue)
            if not any(s < ze and zs < e for zs, ze in zones_tmp)
        ]
    zones = [(s, e) for s, e, _ in spans]
    spans += _spans_regex(texte, langue, zones_deja_prises=zones)

    if utiliser_ner:
        nlp = _charger_modele_spacy(langue)
        if nlp is not None:
            # Le NER ne doit toucher ni aux zones déjà taguées, ni aux
            # libellés eux-mêmes (ex: le mot "Ville" que spaCy peut
            # confondre avec un lieu réel).
            for start, end, tag in _spans_ner(texte, nlp, langue):
                if not any(start < e and s < end for s, e, _ in spans) and \
                   not any(start < ze and zs < end for zs, ze in zones_protegees):
                    spans.append((start, end, tag))

    # Une seule passe de substitution, de la fin vers le début du texte.
    spans.sort(key=lambda s: s[0], reverse=True)
    resultat = texte
    for start, end, tag in spans:
        resultat = resultat[:start] + f"[{tag}]" + resultat[end:]

    return resultat