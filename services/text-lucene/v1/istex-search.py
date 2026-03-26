#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import requests
import json
import sys
import os
import time

api_key = os.getenv("ILAAS_API_KEY")
model = "gpt-oss-120b"


def construct_llm_prompt(user_prompt):
    # Documentation des champs Istex
    fields_doc = """
    - `abstract:()` pour rechercher des mots-clés dans l'abstract
    - `title:()` pour rechercher des mots-clés dans le titre
    - `subject.value:()` pour rechercher des mots-clés parmis ceux renseignés par les auteurs
    - `publicationDate:[N TO M]` : pour rechercher entre l'année N et M.
    - `publicationDate:[N TO *]` : pour obtenir les documents publiés uniquement après l'année N.
    - `author.name:()` : pour inclure des noms d'auteurs spécifiquement. Uniquement le **nom de famille**.
    - `language.raw:()` : permet de choisir la langues de documents ("fre" pour français, "eng" pour anglais, "deu" pour allemand et "spa" pour espagnol.)
    - `AND genre.raw:"research-article"` permet d'avoir uniquement les articles de recherche si l'utilisateur veut quelque chose de filtré.
    """

    prompt = f"""
    Tu es un assistant spécialisé dans la génération de requêtes en syntaxe Lucene. Voici les règles strictes à suivre :

    ### Contexte :
    **Prompt utilisateur** : {user_prompt}
    **Liste des champs disponibles** : {fields_doc}

    ### Consignes :
    1. **Analyse du prompt utilisateur** :
    - Identifie les mots-clés, les champs mentionnés explicitement, et les intentions de recherche.
    - Pour la langue, on récupère la ou les langue(s) demandée(s) par l'utilisateur. Si aucune langue n'est demandé, n'utilise **pas** le champ `language.raw`.
    - Si aucun mot-clé n'est présent, extrapole des mots-clés scientifiques pertinents à partir du contexte, et leur variantes (pluriels, féminins)
    - Les mots clés seront présents dans les langues demandées par l'utilisateur. Si aucune langue n'est demandée, génères des mots clés dans la langue de la requête **et** en anglais.
    - une fois les mots-clés déterminés, ils seront systématiquement recherchés dans le titre, dans l'abstract et dans `subject.value` sauf mention contraire de l'utilisateur.
    - Répond très précisément à la demande de l'utilisateur.

    2. **Respect des champs** : Ne **jamais** inventer ou ajouter des champs non documentés.

    3. **Génération de la requête Lucene** : Construis une requête syntaxiquement correcte en Lucene, en utilisant les champs et mots-clés identifiés. Utilise les opérateurs Lucene appropriés (AND, OR, NOT, etc.) pour refléter la logique de la demande utilisateur.

    4. **Contrôle de la sortie** : Ne retourne que la requête Lucene finale **encadrée uniquement de triple quote**, sans explication ni commentaire. La sortie doit être **strictement** au format :
        ```
        [Requête Lucene valide]
        ```

    ### Exemple de sortie attendue :
    1. Exemple 1 : Si l'utilisateur demande "I want to create a recent corpus (publications released after 2015) on electric cars",
    une réponse possible est
    ```
    (title:("electric car" "electrics cars" "electric vehicle" "electrics vehicles") OR abstract:("electric car" "electrics cars" "electric vehicle" "electrics vehicles") OR subject.value:("electric car" "electrics cars" "electric vehicle" "electrics vehicles")) AND publicationDate:[2015 TO *]
    ```

    2. Exemple 2 : Si l'utilisateur demande "Trouve tous les articles scientifiques parus entre 2000 et 2020 sur la mémoire",
    une réponse possible est
    ```
    (title:("memory" "memories" "metamemory" "mémoire" "mémoires" "métamémoire") OR abstract:("memory" "memories" "metamemory" "mémoire" "mémoires" "métamémoire") OR subject.value:("memory" "memories" "metamemory" "mémoire" "mémoires" "métamémoire")) AND publicationDate:[2000 TO 2020] AND genre.raw:("research-article")
    ```

    3. Exemple 3 : Si l'utilisateur demande "Je veux créer un corpus à partir de ces mots-clés : réchauffement climatique, réchauffement planétaire, réchauffement global, changement climatique, dérèglement climatique. Les documents peuvent être en anglais ou en français."
    Ici les langues sont spécifiées. Après traduction des mots clés données dans les langues souhaitées, une réponse possible est
    ```
    (title:("réchauffement climatique" "réchauffement planétaire" "réchauffement global" "changement climatique" "dérèglement climatique" "global warming" "climate warming" "climate disruption") OR abstract:("réchauffement climatique" "réchauffement planétaire" "réchauffement global" "changement climatique" "dérèglement climatique" "global warming" "climate warming" "climate disruption") OR subject.value:("réchauffement climatique" "réchauffement planétaire" "réchauffement global" "changement climatique" "dérèglement climatique" "global warming" "climate warming" "climate disruption")) AND language.raw:("eng" "fre")
    ```

    4. Exemple 4 : Si l'utilisateur demande "réchauffement climatique, réchauffement planétaire, réchauffement global, changement climatique, dérèglement climatique."
    Bien que la langue ne soit pas spécifiée, l'utilisateur donne juste une liste de mots-clés précis dans une seule langue précise : on utilisera seulement celle-ci. Une réponse possible est
    ```
    (title:("réchauffement climatique" "réchauffement planétaire" "réchauffement global" "changement climatique" "dérèglement climatique") OR abstract:("réchauffement climatique" "réchauffement planétaire" "réchauffement global" "changement climatique" "dérèglement climatique") OR subject.value:("réchauffement climatique" "réchauffement planétaire" "réchauffement global" "changement climatique" "dérèglement climatique")) AND language.raw:("fre")
    ```

    5. Exemple 5 : Si l'utilisateur demande "Je souhaite récupérer les études de Léon Gaillad ou J. Rebol sur la traduction automatique."
    En ne récupérant que les noms des auteurs, une réponse possible est :
    ```
    (title:("machine translation" "automatic translation" "automated translation" "traduction automatique") OR abstract:("machine translation" "automatic translation" "automated translation" "traduction automatique") OR subject.value:("machine translation" "automatic translation" "automated translation" "traduction automatique")) AND author.name:("Gaillad" "Rebol")
    ```

    6. Exemple 6 : si l'utilisateur demande "What documents discuss the impact of screen time on the mental health ? Spanish or english documents only."
    Après voir séparé les deux notions qui doivent apparaître toutes deux (**mental health** et **screen time**), une réponse possible est
    ```
    (title:("screen time" "time on screen" "tiempo de pantalla" "tiempo frente a la pantalla" "uso de pantallas") OR abstract:("screen time" "time on screen" "tiempo de pantalla" "tiempo frente a la pantalla" "uso de pantallas") OR subject.value:("screen time" "time on screen" "tiempo de pantalla" "tiempo frente a la pantalla" "uso de pantallas")) AND (title:("mental health" "mental disorder" "mental disorders" "salud mental" "trastorno mental" "trastornos mentales" "enfermedad mental" "enfermedades mentales") OR abstract:("mental health" "mental disorder" "mental disorders" "salud mental" "trastorno mental" "trastornos mentales" "enfermedad mental" "enfermedades mentales") OR subject.value:("mental health" "mental disorder" "mental disorders" "salud mental" "trastorno mental" "trastornos mentales" "enfermedad mental" "enfermedades mentales")) AND language.raw:("eng" "spa")
    ```

    7. Exemple 7 : si l'utilisateur demande "Je veux un corpus d'articles scientifiques publiés post 2020 sur la biodiversité dans la méditerranée nord. Les documents seront en anglais."
    Après voir séparé les deux notions qui doivent apparaître toutes deux (la **biodiversité** et **la méditerranée nord**), une réponse possible est
    ```
    (title:("biodiversity" "marine biodiversity" "ocean biodiversity" "oceanic biodiversity") OR abstract:("biodiversity" "marine biodiversity" "ocean biodiversity" "oceanic biodiversity") OR subject.value:("biodiversity" "marine biodiversity" "ocean biodiversity" "oceanic biodiversity")) AND (title:("north mediterranean" "north mediterranean sea") OR abstract:("north mediterranean" "north mediterranean sea") OR subject.value:("north mediterranean" "north mediterranean sea")) AND language.raw:("eng") AND genre.raw:"research-article" AND publicationDate:[2020 TO *]
    ```

    ### Exécution :
    Génère maintenant la requête Lucene pour le prompt utilisateur fourni :
    """

    return prompt


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
