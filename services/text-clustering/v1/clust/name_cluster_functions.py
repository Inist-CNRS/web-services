import requests
import json
import os
import time
import logging

logging.basicConfig(level=logging.WARNING, format='%(asctime)s | %(levelname)s | %(message)s', datefmt='%Y-%m-%d %H:%M:%S')

api_key = os.getenv("ILAAS_API_KEY")

PROMPT_PATH = os.path.join(os.path.dirname(__file__), "prompt.txt")

def write_in_logs(message, error=None):
    if error:
        logging.error(f"Message: {message} | Python_error: {error}")
    else:
        logging.warning(f"Message: {message}")


def clean_dict_keys(d: dict) -> dict: 
    return {int(k) if isinstance(k, str) else k: v for k, v in d.items()}

def construct_llm_prompt(keywords):
    """From a dictionary of cluster_id / keywords, generate
    a prompt for a llm.
    Ex : input {"1":["kw1","kw2"]}

    Args:
        keywords (dict): id to kw dict
    """
    with open(PROMPT_PATH, "r", encoding="utf-8") as f:
        template = f.read()
    return template.format(user_prompt=keywords)


def parse_llm_output(answer: str, len_clusters: int) -> dict:
    try:
        parsed_answer = json.loads(answer.split("```json")[1].split("```")[0].strip())
        if len_clusters != len(parsed_answer):
            write_in_logs("Len between entry and llm answer different !")
            return None
        return clean_dict_keys(parsed_answer)
    except Exception:
        return None


def call_llm_prompt(message: str, len_clusters, model_name: str = "gemma-4-31b", timeout: int = 30, retries: int = 3) -> dict:
    messages = [{"role": "user", "content":message}]
    base_url = "https://llm.ilaas.fr/v1"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    payload = {
        "model": model_name,
        "messages": messages,
        "stream": False,
        "max_completion_tokens": 2000
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
                if 'choices' in response_json and len(response_json['choices']) > 0:
                    output = parse_llm_output(response_json['choices'][0]['message']['content'], len_clusters)
                    if output :
                        return output
                    else:
                        raise ValueError(f"Impossible de parser la réponse du LLM : {response_json}")
                else:
                    raise ValueError(f"Réponse inattendue de l'API : {response_json}")
            else:
                write_in_logs(f"Attempt {attempt + 1}: API returned {response.status_code} - {response.text}")
                if attempt < retries - 1:
                    time.sleep(2*(attempt+1))
        except Exception as e:
            write_in_logs(f"Attempt {attempt + 1}: Exception", e)
            if attempt < retries - 1:
                time.sleep(2*(attempt+1))
    return {i+1: "Unknown" for i in range(len_clusters)}



def name_cluster_with_kw(keywords):
    """From a dictionary of cluster_id / keywords, generate
    a dictionary cluster_id / cluster_name.
    Ex : input {"1":["kw1","kw2"]}
    output {"1": "title1"}

    Args:
        keywords (dict): id to kw dict
    """
    prompt = construct_llm_prompt(keywords)
    output = call_llm_prompt(prompt, len(keywords))

    return output
