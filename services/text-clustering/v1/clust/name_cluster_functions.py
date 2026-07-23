from __future__ import annotations
import requests
import json
import os
import time
import logging
import sys

logging.basicConfig(level=logging.WARNING, format='%(asctime)s | %(levelname)s | %(message)s', datefmt='%Y-%m-%d %H:%M:%S')

api_key = os.getenv("ILAAS_API_KEY")
try:
    IDENTIFIER = str(sys.argv[sys.argv.index("-identifier") + 1] if "-identifier" in sys.argv else "")
except Exception:
    IDENTIFIER = ""

PROMPT_PATH = os.path.join(os.path.dirname(__file__), "prompt.txt")

def write_in_logs(message, error=None):
    if error:
        logging.error(f"id: {IDENTIFIER} | Message: {message} | Python_error: {str(error)}")
    else:
        logging.warning(f"id: {IDENTIFIER} | Message: {message}")


def construct_llm_prompt(keywords):
    """From a dictionary of cluster_id / keywords, generate
    a prompt for a llm.
    Ex : input {"1":["kw1","kw2"]}

    Args:
        keywords (dict): id to kw dict
    """
    with open(PROMPT_PATH, "r", encoding="utf-8") as f:
        template = f.read()
    return template.format(user_prompt=json.dumps(keywords, ensure_ascii=False, indent=2))


def build_cluster_schema(cluster_ids: list) -> dict:
    """
    Construit un JSON Schema strict imposant EXACTEMENT une clé (string)
    par cluster_id fourni, chacune associée à une valeur de type string
    (le titre du cluster). additionalProperties=False + required=toutes
    les clés => le modèle ne peut ni en oublier, ni en inventer.
    """
    return {
        "type": "object",
        "properties": {k: {"type": "string"} for k in cluster_ids},
        "required": cluster_ids,
        "additionalProperties": False,
    }


def parse_llm_output(answer: str, expected_keys: set) -> dict | None:
    try:
        parsed_answer = json.loads(answer)

        if set(parsed_answer.keys()) != expected_keys:
            write_in_logs(f"Clés reçues différentes des clés attendues : {sorted(parsed_answer.keys())} vs {sorted(expected_keys)}"
            )
            return None

        return parsed_answer
    except Exception as e:
        write_in_logs("Erreur de parsing JSON", e)
        return None


def call_llm_prompt(
    message: str,
    cluster_ids,
    model_name: str = "gemma-4-31b",
    timeout: int = 30,
    retries: int = 3,
) -> dict:
    messages = [{"role": "user", "content": message}]
    base_url = "https://llm.ilaas.fr/v1"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }

    json_schema = build_cluster_schema(cluster_ids)

    payload = {
        "model": model_name,
        "messages": messages,
        "stream": False,
        "max_completion_tokens": 2000,
        "response_format": {
            "type": "json_schema",
            "json_schema": {
                "name": "cluster_titles",
                "strict": True,
                "schema": json_schema,
            },
        },
    }

    for attempt in range(retries):
        try:
            response = requests.post(
                f"{base_url}/chat/completions",
                headers=headers,
                json=payload,
                timeout=timeout
            )
            if response.ok:
                response_json = response.json()
                if "choices" in response_json and len(response_json["choices"]) > 0:
                    output = parse_llm_output(
                        response_json["choices"][0]["message"]["content"],
                        set(cluster_ids),
                    )
                    if output:
                        return output
                    else:
                        raise ValueError(
                            f"Impossible de parser la réponse du LLM : {response_json}"
                        )
                else:
                    raise ValueError(f"Réponse inattendue de l'API : {response_json}")
            else:
                write_in_logs(
                    f"Attempt {attempt + 1}: API returned {response.status_code} - {response.text}"
                )
                if attempt < retries - 1:
                    time.sleep(2 * (attempt + 1))
        except Exception as e:
            write_in_logs(f"Attempt {attempt + 1}: Exception", e)
            if attempt < retries - 1:
                time.sleep(2 * (attempt + 1))

    return {cid: "Unknown" for cid in cluster_ids}


def name_cluster_with_kw(keywords: dict) -> dict:
    """From a dictionary of cluster_id / keywords, generate
    a dictionary cluster_id / cluster_name.
    Ex : input {"1":["kw1","kw2"]}
    output {"1": "title1"}

    Args:
        keywords (dict): id to kw dict
    """
    prompt = construct_llm_prompt(keywords)
    output = call_llm_prompt(prompt, cluster_ids=list(keywords.keys()))
    return output
