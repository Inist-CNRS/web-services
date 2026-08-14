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
PROMPT_ID = "reformulation_template"

NO_HISTORY_TEXT = "Aucun historique de conversation disponible."


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
        "max_tokens": 2000
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
# Construction de l'historique
# ==============================

def build_history_text(historique):
    """
    Construit le texte de l'historique de la conversation.

    `historique` est attendu comme une liste de tours de dialogue,
    chaque tour étant un dict avec les clés "role" et "content".

    Si aucun historique n'est fourni (absent, None ou liste vide),
    un texte par défaut est renvoyé, et on considère qu'il n'y a
    pas besoin de reformuler.
    """
    if not historique:
        return NO_HISTORY_TEXT

    lines = []

    for turn in historique:
        role = turn.get("role", "inconnu")
        content = turn.get("content", "")
        lines.append(f"{role} : {content}")

    return "\n".join(lines)


# ==============================
# Construction du prompt de reformulation
# ==============================

def build_prompt(question, historique):
    historique_text = build_history_text(historique)

    return PROMPT_TEMPLATE.format(
        question=question,
        historique=historique_text
    )


# ==============================
# Traitement batch
# ==============================

def process_batch(batch):
    if not batch:
        return

    for item in batch:
        question = item["value"]["question"]
        historique = item["value"].get("historique", [])

        # Pas d'historique -> pas besoin d'appeler le LLM,
        # la question reste inchangée.
        if not historique:
            reformulated_question = question
        else:
            prompt = build_prompt(
                question,
                historique
            )

            reformulated_question = call_llm(prompt)

            if reformulated_question == "Error":
                # En cas d'échec, on retombe sur la question d'origine
                # plutôt que de bloquer le pipeline.
                print_log(
                    "Reformulation failed, "
                    "falling back to original question"
                )
                reformulated_question = question

        output = {
            "id": item["id"],
            "value": reformulated_question
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