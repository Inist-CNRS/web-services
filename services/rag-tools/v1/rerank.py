#!/usr/bin/env python3

import sys
import json
import time
import requests
import os

# ==============================
# Configuration
# ==============================


API_KEY = os.getenv("ILAAS_API_KEY")
MODEL_NAME = "gemma-4-31b"
MAX_RETRIES = 4
RETRY_DELAY = 2
BATCH_SIZE = 32

PROMPT_PATH = "v1/prompt.json"
PROMPT_ID = "rerank_template"

DEFAULT_TOP_N = 6


# ==============================
# Chargement du prompt
# ==============================

def load_prompt():
    with open(PROMPT_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)

    for prompt in data["prompts"]:
        if prompt["id"] == PROMPT_ID:
            return prompt["content"]

    raise ValueError(f"Prompt {PROMPT_ID} not found")


PROMPT_TEMPLATE = load_prompt()


# ==============================
# Logs
# ==============================

def print_log(message):
    print(message, file=sys.stderr)


# ==============================
# Appel LLM
# ==============================

def call_llm(prompt: str) -> str:
    base_url = "https://llm.ilaas.fr/v1"

    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json"
    }

    payload = {
        "model": MODEL_NAME,
        "messages": [
            {
                "role": "user",
                "content": f"{prompt}"
            }
        ],
        "stream": False,
        "max_tokens": 200
    }

    for attempt in range(1, MAX_RETRIES + 1):
        try:
            response = requests.post(
                f"{base_url}/chat/completions",
                headers=headers,
                json=payload
            )

            result = response.json()

            print_log(
                "LLM result call : "
                + result["choices"][0]["message"]["content"]
            )

            print_log(
                result["choices"][0]["message"].get(
                    "reasoning_content",
                    None
                )
            )

            return result["choices"][0]["message"]["content"].strip()

        except Exception:
            print_log(
                f"Error while calling LLM "
                f"(attempt {attempt}/{MAX_RETRIES})"
            )

            if attempt == MAX_RETRIES:
                return "Error"

            time.sleep(RETRY_DELAY * attempt)
            print_log(
                "Sleeping "
                + str(RETRY_DELAY * attempt)
            )


# ==============================
# Sérialisation des métadonnées
# ==============================

def format_metadata_block(metadata: dict) -> str:
    """
    Construit un bloc texte lisible à partir des métadonnées d'un document.
    Les champs absents sont simplement ignorés (pas de ligne vide/"None").
    """
    if not metadata:
        return ""

    lines = []

    if metadata.get("titre"):
        lines.append(f"Titre : {metadata['titre']}")

    auteurs = metadata.get("auteurs")
    if auteurs:
        lines.append(f"Auteurs : {', '.join(auteurs)}")

    if metadata.get("date_publication"):
        lines.append(f"Date de publication : {metadata['date_publication']}")

    if metadata.get("journal"):
        journal_line = f"Journal : {metadata['journal']}"
        details = []
        if metadata.get("volume"):
            details.append(f"volume {metadata['volume']}")
        if metadata.get("numero"):
            details.append(f"numéro {metadata['numero']}")
        if metadata.get("pages"):
            details.append(f"pages {metadata['pages']}")
        if details:
            journal_line += " (" + ", ".join(details) + ")"
        lines.append(journal_line)

    if metadata.get("doi"):
        lines.append(f"DOI : {metadata['doi']}")

    mots_cles = metadata.get("mots_cles")
    if mots_cles:
        lines.append(f"Mots-clés : {', '.join(mots_cles)}")

    if metadata.get("resume"):
        lines.append(f"Résumé de l'article : {metadata['resume']}")

    return "\n".join(lines)


# ==============================
# Construction du prompt de reranking
# ==============================

def build_documents_text(documents: list[dict]) -> str:
    documents_text = ""

    for i, doc in enumerate(documents, start=1):
        metadata_block = format_metadata_block(doc.get("metadata"))
        text = doc.get("text", "")

        block = f"--- Document {i} ---\n"
        if metadata_block:
            block += metadata_block + "\n"
        block += f"Contenu :\n{text}\n"
        block += f"--- Fin du document {i} ---\n\n"

        documents_text += block

    return documents_text


def build_prompt(question, documents, top_n):
    documents_text = build_documents_text(documents)

    return PROMPT_TEMPLATE.format(
        question=question,
        documents=documents_text,
        top_n=top_n
    )


# ==============================
# Parsing de la réponse du LLM
# ==============================

def parse_ranking(raw_response, documents, top_n):
    """
    Attendu : une chaîne du type "3,1,5".
    Renvoie la liste des documents originaux (dict {text, metadata}),
    réordonnée et tronquée à top_n, dans l'ordre de pertinence donné
    par le LLM.

    En cas de réponse invalide ou d'erreur LLM, on retombe sur les
    top_n premiers documents dans leur ordre d'origine (fallback
    non bloquant plutôt que de casser le pipeline).
    """
    if raw_response == "Error" or not raw_response:
        print_log("Ranking invalide, fallback sur l'ordre d'origine")
        return documents[:top_n]

    cleaned = raw_response.strip()

    if not cleaned:
        return documents[:top_n]

    try:
        indices = [
            int(x.strip())
            for x in cleaned.split(",")
            if x.strip() != ""
        ]
    except ValueError:
        print_log(
            f"Impossible de parser le classement '{raw_response}', "
            "fallback sur l'ordre d'origine"
        )
        return documents[:top_n]

    reranked = []
    seen_indices = set()

    for idx in indices:
        if 1 <= idx <= len(documents) and idx not in seen_indices:
            reranked.append(documents[idx - 1])
            seen_indices.add(idx)

        if len(reranked) >= top_n:
            break

    if not reranked:
        return documents[:top_n]

    return reranked


# ==============================
# Traitement batch
# ==============================

def process_batch(batch):
    if not batch:
        return

    for item in batch:
        question = item["value"]["question"]
        documents = item["value"]["documents"]
        top_n = item["value"].get("top_n", DEFAULT_TOP_N)

        if not documents:
            output = {
                "id": item["id"],
                "value": {
                    "documents": []
                }
            }
        else:
            prompt = build_prompt(
                question,
                documents,
                top_n
            )

            raw_response = call_llm(prompt)

            reranked_documents = parse_ranking(
                raw_response,
                documents,
                top_n
            )

            output = {
                "id": item["id"],
                "value": {
                    "documents": reranked_documents
                }
            }

        sys.stdout.write(
            json.dumps(
                output,
                ensure_ascii=False
            )
        )
        sys.stdout.write("\n")


# ==============================
# Main
# ==============================

batch = []

for line in sys.stdin:
    line = line.strip()

    if not line:
        continue

    data = json.loads(line)

    batch.append(data)

    if len(batch) >= BATCH_SIZE:
        process_batch(batch)
        batch = []


# Dernier batch incomplet
process_batch(batch)
