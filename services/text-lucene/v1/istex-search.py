#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import requests
import json
import sys
import os
import time

api_key = os.getenv("ILAAS_API_KEY")
model = "gemma-4-31b"


def construct_llm_prompt(user_prompt):
    with open("./v1/prompt.txt", "r", encoding="utf-8") as f:
        template = f.read()
    return template.format(user_prompt=user_prompt)


def generate_lucene(prompt: str, model_name: str) -> str:
    base_url = "https://llm.ilaas.fr/v1"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    payload = {
        "model": model_name,
        "messages": [{"role": "user", "content": f"{prompt}"}],
        "stream": False,
        "max_tokens": 4096
    }
    response = requests.post(
        f"{base_url}/chat/completions",
        headers=headers,
        json=payload)

    result = response.json()

    return result['choices'][0]['message']['content']


def process_llm_response(llm_output):
    lucene_equation = llm_output.split("```")[1]
    return lucene_equation.replace("\n", " ").replace("  ", " ").strip()


class NoAnswerError(Exception):
    pass


def main():
    retries = 3
    for line in sys.stdin:
        try:
            user_prompt = json.loads(line)
            value = user_prompt["value"]
            if len(value) < 10:
                raise Exception("Too short request")
            prompt = construct_llm_prompt(value)
            output = None

            for retry in range(retries):
                try:
                    response = generate_lucene(prompt, model_name=model)
                    response = process_llm_response(response)
                    # If model doesn't generate "```",
                    # this function returns an IndexError.
                    if len(response) < 10:
                        # We consider the response to short to be a lucene eq.
                        raise NoAnswerError("Empty output")
                    output = response
                    break
                except (NoAnswerError, IndexError):
                    if retry < retries - 1:
                        time.sleep(2 * (retry + 1))
                    continue
                except Exception:
                    output = None
                    break

            if output is None:
                output = ""
            
            user_prompt["value"] = output

        except Exception as e:
            sys.stderr.write(f"Unexpected error: {str(e)}")
            sys.stderr.write("\n")
            user_prompt["value"] = ""
        sys.stdout.write(json.dumps(user_prompt))
        sys.stdout.write("\n")


if __name__ == "__main__":
    main()
