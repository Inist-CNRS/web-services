import requests
import json
import sys
import os
import time
import datetime

api_key = os.getenv("ILAAS_API_KEY")


def write_in_logs(message, error=None):
    date_error = datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d %H:%M:%S')
    if error is None:
        sys.stderr.write(f"{date_error} | Message : {message} |\n")
    else:
        sys.stderr.write(f"{date_error} | Message : {message} | Error : {str(error)}\n")


def clean_dict_keys(d):
    return {int(k) if isinstance(k, str) else k: v for k, v in d.items()}

def construct_llm_prompt(keywords):
    """From a dictionary of cluster_id / keywords, generate
    a prompt for a llm.
    Ex : input {"1":["kw1","kw2"]}

    Args:
        keywords (dict): id to kw dict
    """
    with open("./v1/clust/prompt.txt", "r", encoding="utf-8") as f:
        template = f.read()
    return template.format(user_prompt=keywords)


def parse_llm_output(answer, len_clusters):
    try:
        parsed_answer = json.loads(answer.split("```json")[1].split("```")[0].strip())
        if len_clusters != len(parsed_answer):
            write_in_logs("Len between entry and llm answer different !")
            return None
        return clean_dict_keys(parsed_answer)
    except Exception:
        return None


def call_llm_prompt(message: str, len_clusters, model_name: str = "gemma-4-31b", timeout: int = 30, retries: int = 3) -> str:
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
                        raise ValueError(f"Impossible de parser la réponse d LLM : {response_json}")
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
    return {i+1: "Unkown" for i in range(len_clusters)}



def name_cluster_with_kw(keywords):
    """From a dictionary of cluster_id / keywords, generate
    a dictonary cluster_id / cluster_name.
    Ex : input {"1":["kw1","kw2"]}
    output {"1": "title1"}

    Args:
        keywords (dict): id to kw dict
    """
    prompt = construct_llm_prompt(keywords)
    output = call_llm_prompt(prompt, len(keywords))

    return output
