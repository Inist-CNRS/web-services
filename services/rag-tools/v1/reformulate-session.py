#!/usr/bin/env python3

import sys
import json
import time
import requests
import os
import uuid

# ==============================
# Configuration
# ==============================


API_KEY = os.getenv("ILAAS_API_KEY")
MODEL_NAME = "gemma-4-31b"
MAX_RETRIES = 4
RETRY_DELAY = 2
BATCH_SIZE = 32

PROMPT_PATH = "v1/prompt.json"
PROMPT_ID_REFORMULATE = "reformulation_template"
PROMPT_ID_DEFINITION = "definition_reformulation_template"

NO_HISTORY_TEXT = "Aucun historique de conversation disponible."

TMP_DIR = "/tmp"

# ==============================
# Logs
# ==============================

def print_log(message):
    print(message, file=sys.stderr)

# ==============================
# Arguments optionnels
# ==============================

rag_type = sys.argv[sys.argv.index("-p") + 1] if "-p" in sys.argv else "rag"
rag_type = "rag" if rag_type not in ["definition"] else rag_type
print_log("Rag type : " + rag_type)
prompt_id = PROMPT_ID_REFORMULATE
if rag_type == "definition":
    prompt_id = PROMPT_ID_DEFINITION

# ==============================
# Chargement du prompt
# ==============================

def load_prompt(prompt_id):
    with open(PROMPT_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)

    for prompt in data["prompts"]:
        if prompt["id"] == prompt_id:
            return prompt["content"]

    raise ValueError(f"Prompt {prompt_id} not found")


PROMPT_TEMPLATE = load_prompt(prompt_id)


# ==============================
# Gestion de la session (token -> historique persisté sur disque)
# ==============================

def history_path(token: str) -> str:
    return os.path.join(TMP_DIR, token, f"{token}.json")


def generate_token() -> str:
    return uuid.uuid4().hex


def load_historique(token: str) -> list:
    """Charge l'historique associé à un token. Renvoie une liste vide si
    le fichier n'existe pas encore."""
    path = history_path(token)
    if not os.path.exists(path):
        print_log(f"Aucun historique trouvé pour le token {token}, historique vide utilisé")
        return []

    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def resolve_session(token_value):
    """
    `token_value` est ce qui se trouve dans value["historique"] en entrée :
    - absent / None / chaîne vide -> premier appel, on génère un nouveau
      token et l'historique de départ est vide.
    - une chaîne non vide -> token existant, on charge l'historique
      correspondant depuis le disque.

    Renvoie (token, historique).
    """
    if not token_value:
        new_token = generate_token()
        print_log(f"Aucun token fourni, nouvelle session créée : {new_token}")
        return new_token, []

    return token_value, load_historique(token_value)


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
                json=payload,
                timeout=60
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

    Si aucun historique n'est fourni (liste vide), un texte par défaut
    est renvoyé, et on considère qu'il n'y a pas besoin de reformuler.
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
        token, historique = resolve_session(item["value"].get("historique"))

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
            "value": {
                "question": reformulated_question,
                "token": token
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
