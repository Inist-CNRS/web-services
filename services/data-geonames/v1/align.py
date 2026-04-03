#!/usr/bin/env python3
import pickle
import json
from transformers import AutoTokenizer, pipeline
import ast
import time
from utils_data_geonames import *
import sys
import os


# Nom des colonnes des dataframes pour le traitement
columns = [
    "geonameid","name","asciiname","alternatenames",
    "latitude","longitude","feature_class","feature_code",
    "country_code","cc2","admin1_code","admin2_code",
    "admin3_code","admin4_code","population","elevation",
    "dem","timezone","modification_date", "name_norm"
]

cols = [
    "geonameid","name","asciiname","alternatenames",
    "latitude","longitude","admin1_code","population","elevation","timezone"
]


#Chargement du modèle
model_name = os.getenv("MODEL_DIR", "/app/models/bert-finetuned-ner")

tokenizer = AutoTokenizer.from_pretrained(
    model_name,
    model_max_length=512,
)

ner = pipeline(
    "ner",
    model=model_name,
    tokenizer=tokenizer,
    aggregation_strategy="simple",
    stride=30,
)

# Chargement des prompts
prompts = charger_prompts("v1/prompts.json")
ROUND1_TEMPLATE, ROUND2_TEMPLATE, PRE_SORT_TEMPLATE = (
    prompts["round1_template"]["content"],
    prompts["round2_template"]["content"],
    prompts["pre_sort_template"]["content"]
)


# Import du dictionnaire de référence
filename_ref_dic = "v1/dataset_index.pkl"
with open(filename_ref_dic, "rb") as f:
    offsets = pickle.load(f)

# Import du pkl contenant les indexes de début pour le dictionnaire de référence
filename_index = "v1/dic_3g.pkl"
with open(filename_index, "rb") as f:
    dic_start_end = pickle.load(f)

print(time.strftime("%A %d %B %Y %H:%M:%S"), file=sys.stderr)


start_time = time.time()

datas = []
docs_id = []
for line in sys.stdin:
    data = json.loads(line)
    datas.append(data["value"])
    docs_id.append(data["id"])


results = resultClass()

for ind_text, text in enumerate(datas):
    start_time_i = time.time()
    loc_dict, occurrence_dict = get_info_ner(text, ner)
    grouped_dict = create_group(loc_dict, occurrence_dict, PRE_SORT_TEMPLATE)
    for (word, group_idx), entities in grouped_dict.items():
        print_log("Processing word : " + word + " from group : " + str(group_idx))
        first_entity = True # Si une erreur se produit au premier (ou premier et deuxieme, ...), il faudrai penser à modifier rétroactivement les anciens résultats pour remplacer le "None" par l'alignement
        for entity in entities:
            print_log(entity["context"])
            # If it's not the first element of the group, copy the alignement of the first element
            if first_entity == False:
                results.add_result(entity["word"], first_alignment, entity["context"], docs_id[ind_text])
                continue

            ent_name = entity["word"]
            ent_context = entity["context"]
            ent_norm = normalize_name(ent_name)
            ex_ind = ent_norm[:3]

            # Si les 3 premières lettre ne sont pas dans le dictionnaire des indices, on renvoit aucun alignement
            if ex_ind not in dic_start_end:
                results.add_result(entity["word"], [], entity["context"], docs_id[ind_text])
                continue
            
            # On recupère dans la base uniquement les lignes commencant avec les mêmes 3 premières lettres
            df_filtered = create_filtered_dataframe(ent_norm, dic_start_end[ex_ind][0], 
                                                    dic_start_end[ex_ind][1], offsets, columns)
            # Si aucun terme, on renvoit aucun alignement
            if len(df_filtered) == 0:
                results.add_result(entity["word"], [], entity["context"], docs_id[ind_text])
                first_alignment = []
                first_entity = False
                continue
            
            # Round 1
            print_log("Starting round 1")
            ans = round(1, ent_name, ent_context, text, cols, df_filtered, ROUND1_TEMPLATE)

            # Conversion de la réponse en objet (Passer sur json load ?)
            try:
                list_ans = ast.literal_eval(ans)
            except:
                # Erreur, on renvoit aucun alignement
                results.add_result(entity["word"], [], entity["context"], docs_id[ind_text])
                continue   
            
            # Si le mode demande un lookup, on se dirige vers le début du round 2
            if isinstance(list_ans, dict) and "lookup" in list_ans:
                print_log("Lookup asked, starting round 2")
                lookup_term = list_ans["lookup"]
                lu_norm = normalize_name(lookup_term)
                lu_ind = lu_norm[:3]
                # Si les 3 premières lettre du lookup ne sont pas dans le dictionnaire des indices, on renvoit aucun alignement
                if ex_ind not in dic_start_end:
                    results.add_result(entity["word"], [], entity["context"], docs_id[ind_text])
                    first_alignment = []
                    first_entity = False
                # Sinon on prépare le round 2 de la même façon que le 1
                else:
                    df_filtered = create_filtered_dataframe(lu_norm, dic_start_end[lu_ind][0], 
                                                            dic_start_end[lu_ind][1], offsets, columns)
                    # Si aucun terme, on renvoit aucun alignement
                    if len(df_filtered) == 0:
                        results.add_result(entity["word"], [], entity["context"], docs_id[ind_text])
                        first_alignment = []
                        first_entity = False
                    # Début du round 2
                    else:
                        ans = round(2, ent_name, ent_context, text, cols, df_filtered, ROUND2_TEMPLATE, lookup_term)
                        # Conversion de la réponse en objet (Passer sur json load ?)
                        try:
                            list_ans = ast.literal_eval(ans)
                        except:
                            # Erreur, on renvoit aucun alignement
                            results.add_result(entity["word"], [], entity["context"], docs_id[ind_text])
                            continue
                        # Vérification et suppression des hallucinations
                        list_ans = remove_hallucinate(list_ans, df_filtered)
                        results.add_result(entity["word"], list_ans, entity["context"], docs_id[ind_text])
                        first_alignment = list_ans
                        first_entity = False

            # Si pas de lookup, on traite et renvoit le/les alignements finaux
            else:
                print_log("No lookup asked, add result")
                list_ans_final = list_ans.copy()
                # Vérification et suppression des hallucinations
                list_ans = remove_hallucinate(list_ans, df_filtered)
                results.add_result(entity["word"], list_ans, entity["context"], docs_id[ind_text])
                first_alignment = list_ans
                first_entity = False
    print("Time for document " + docs_id[ind_text] + " : " + str(time.time()-start_time_i), file=sys.stderr)
    print_log("Result : " + str(results.to_list()))
    sys.stdout.write(json.dumps(results.to_list()))
    sys.stdout.write('\n')

print("TOTAL TIME : " + str(time.time()-start_time), file=sys.stderr)

