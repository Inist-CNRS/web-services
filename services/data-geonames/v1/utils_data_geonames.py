import unicodedata
import requests
import json
from collections import defaultdict
import re
import sys
import pandas as pd
from rapidfuzz import process, fuzz
import os

debug = False

def print_log(text):
    if debug:
        print(text, file=sys.stderr)

if debug:
    print_log("-------------DEBUG LOG---------------")

api_key = os.getenv("ILAAS_API_KEY")
model_name = "gpt-oss-120b"

def normalize_name(name):
    # Supprimer les espaces début/fin
    name = name.strip()
    # Mettre en minuscules
    name = name.lower()
    # Supprimer les accents
    name = ''.join(
        c for c in unicodedata.normalize('NFKD', name)
        if not unicodedata.combining(c)
    )
    return name

def call_llm(prompt: str) -> str:
    base_url = "https://llm.ilaas.fr/v1"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    response = requests.get(f"{base_url}/models", 
                            headers=headers)
    payload = {
        "model": model_name,
        "messages": [{"role": "user", "content": f"{prompt}"}],
        "stream": False,
        "max_tokens": 10000
    }
    try:
        response = requests.post(f"{base_url}/chat/completions", 
                                headers=headers, json=payload)
        result = response.json()
        print_log("LLM result call : " + result['choices'][0]['message']['content'])
        print_log(result['choices'][0]['message'].get('reasoning_content', None))
        return result['choices'][0]['message']['content']
    except: 
        print_log("Error while calling LLM")
        return "Error"

def charger_prompts(chemin: str) -> dict:
    with open(chemin, "r", encoding="utf-8") as f:
        data = json.load(f)
    return {p["id"]: p for p in data["prompts"]}

def get_info_ner(text, ner):
    res = ner(text)

    loc_dict = defaultdict(list)
    word_groups = defaultdict(list)
    for e in res:
        word_groups[e["word"]].append(e)
    sentences = list(re.finditer(r'[^.!?]+[.!?]?', text))
    Total_detected = 0
    for word, group in word_groups.items():
        if len(group) >= 1 and group[0]["entity_group"] == "LOC":
            Total_detected += len(group)

            for e in group:
                # Find context sentence for each entity occurrence
                start = e["start"]
                end = e["end"]
                ent_context = None
                for sent in sentences:
                    if sent.start() <= start <= sent.end():
                        raw_context = sent.group()
                        
                        # Calculate strip offset to compensate for leading whitespace removed by strip()
                        strip_offset = len(raw_context) - len(raw_context.lstrip())
                        
                        rel_start = start - sent.start() - strip_offset
                        rel_end = end - sent.start() - strip_offset
                        
                        ent_context = raw_context.strip()
                        ent_context = (
                            ent_context[:rel_start]
                            + "||" + ent_context[rel_start:rel_end] + "||"
                            + ent_context[rel_end:]
                        )
                        break

                # Store entity + context in loc_dict
                loc_dict[word].append({**e, "context": ent_context})

            print_log(f"\n'{word}' detected {len(group)} times:")
            for e in loc_dict[word]:
                print_log(f"  start={e['start']}, end={e['end']}, group={e['entity_group']}, score={e['score']:.3f}, context={e['context']}")
    
    print_log("Total Loc detected : " + str(Total_detected))
    occurrence_dict = {}
    for word, entities in loc_dict.items():
        occurrences_str = "\n".join(
            f"[{i}] {e['context']}" for i, e in enumerate(entities)
        )
        occurrence_dict[word] = occurrences_str

    return loc_dict, occurrence_dict

def create_group(loc_dict, occurrence_dict, PRE_SORT_TEMPLATE):
    grouped_dict = {}
    for word, occurrences_str in occurrence_dict.items():
        print_log("Create group for word : " + word)
        entities = loc_dict[word]
        
        # Skip LLM for words with 3 or fewer occurrences, each gets its own group
        if len(entities) <= 3:
            for i, entity in enumerate(entities):
                grouped_dict[(word, i)] = [entity]
            continue
        print_log("Calling LLM to create group")
        prompt = PRE_SORT_TEMPLATE.format(WORD=word, OCCURRENCES=occurrences_str)
        llm_answer = call_llm(prompt)
        
        # Validate and parse the LLM response
        try:
            groups = json.loads(llm_answer)
            # Check it's a list of lists of integers
            if (not isinstance(groups, list) or
                not all(isinstance(g, list) for g in groups) or
                not all(isinstance(i, int) for g in groups for i in g)):
                raise ValueError("Bad format")
        except (json.JSONDecodeError, ValueError):
            # Fallback: each occurrence gets its own group
            groups = [[i] for i in range(len(entities))]
        
        # Build grouped_dict entries
        for group_idx, indices in enumerate(groups):
            grouped_dict[(word, group_idx)] = [entities[i] for i in indices]

        for (word, group_idx), entities in grouped_dict.items():
            print_log(f"\n{'='*50}")
            print_log(f"  '{word}' — Group {group_idx} ({len(entities)} occurrence{'s' if len(entities) > 1 else ''})")
            print_log(f"{'='*50}")
            for e in entities:
                print_log(f"  [{group_idx}] score={e['score']:.3f} | context: {e['context']}")

    return grouped_dict

def create_filtered_dataframe(ent_norm, start, end, offsets, columns):
    lines = []
    print_log("Start create dataframe " + str(start) + "-" + str(end) + " get info from file")
    with open("v1/allCountries_sorted.txt", "rb") as f:
        for i in range(start, end):  # indices Python commencent à 0
            f.seek(offsets[i])          # aller directement à la ligne
            line = f.readline().decode().strip()
            lines.append(line)
    rows = [line.split("\t") for line in lines]
    df = pd.DataFrame(rows, columns=columns)
    print_log("Start Fuzzy for : " + ent_norm)
    # Fuzzy pour récuperer ceux ayant au minimum 80% en commun
    matches = process.extract(
        ent_norm,
        df["name_norm"].tolist(),
        scorer=fuzz.ratio,
        score_cutoff=80,
        limit=None
    )

    #Calcul de la dataframe réduite
    indices = [match[2] for match in matches]
    df_filtered = df.loc[indices]
    return df_filtered

def round(round_nb, ent_name, ent_context, text, cols, df_filtered, ROUND_TEMPLATE, lookup_term = None):
    candidate_json = df_filtered[cols].to_dict(orient="records")
    candidate_str = "\n".join([json.dumps(c) for c in candidate_json])

    valid_ids = df_filtered["geonameid"].tolist()
    if round_nb == 1:
        prompt = ROUND_TEMPLATE.format(
            term=ent_name,
            small_context=ent_context,
            context=text,
            candidates=candidate_str,
            valid_ids=valid_ids
        )
    else:
        prompt = ROUND_TEMPLATE.format(
            term=ent_name,
            small_context=ent_context,
            context=text,
            lookup_term=lookup_term,
            candidates=candidate_str
                        )
    #print(prompt, file=sys.stderr)
    return call_llm(prompt)

def remove_hallucinate(list_ans, df_filtered):
    list_ans_final = list_ans.copy()
    # Vérification et suppression des hallucinations
    for id_ans in list_ans:
        if str(id_ans) not in df_filtered["geonameid"].tolist():
            #Hallucination
            list_ans_final.remove(id_ans)
    return ["https://www.geonames.org/"+str(x) for x in list_ans_final]


class resultClass:
    def __init__(self):
        self.all_entities = []
        self.all_document = []
        self.all_local_context = []
        self.all_alignment = []

    def add_result(self, entity, alignment, context, document):
        self.all_entities.append(entity)
        self.all_alignment.append(alignment)
        self.all_local_context.append(context)
        self.all_document.append(document)
        
    def to_list(self):
        return [
            {
                "entity": entity,
                "context": context,
                "alignment": alignment
            }
            for entity, context, alignment in zip(
                self.all_entities,
                self.all_local_context,
                self.all_alignment
            )
        ]