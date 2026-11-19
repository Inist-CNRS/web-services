#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import argparse
import gc
import json
import os
import re
import signal
import sys
import time
from xml.sax.saxutils import escape

import defusedxml.ElementTree as DefusedET
Q = chr(34)  # double quote, for XML attribute escaping

import numpy as np
from llama_cpp import Llama
from rdflib import Graph
from rdflib.namespace import RDF, SKOS, OWL
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
from tqdm import tqdm
from unidecode import unidecode

parser = argparse.ArgumentParser(description="Aligne deux thesauri SKOS (SBERT + LLM, CPU uniquement).")
parser.add_argument("source", help="Fichier SKOS source")
parser.add_argument("target", help="Fichier SKOS cible")
parser.add_argument("-o", "--output", default="alignments_hierarchy.xml", help="Fichier SKOS de sortie")
parser.add_argument("--lang", default="fr,en,es", help="Langues preferees, ordre de priorite")
parser.add_argument("--min_score", type=float, default=0.7)
parser.add_argument("--top_k", type=int, default=5)
parser.add_argument("--no-hierarchy", action="store_true", help="Ne pas raffiner en broader/narrower")
parser.add_argument("--model", default="mistral-7b-instruct-v0.2.Q4_K_M.gguf", help="Chemin du modele GGUF")
parser.add_argument("--threads", type=int, default=min(8, os.cpu_count() or 4), help="Threads CPU llama.cpp")
parser.add_argument("--checkpoint", default="checkpoint.jsonl", help="Fichier de reprise (classifications uniquement)")
parser.add_argument("--llm-retries", type=int, default=3, help="Nombre de tentatives par appel LLM")
parser.add_argument("--llm-max-error-rate", type=float, default=0.05, help="Taux d'erreurs LLM max avant abandon (0.05 = 5%)")
parser.add_argument("--max-minutes", type=float, default=0, help="Duree max (minutes), exit 124 si depassee")
args = parser.parse_args()

preferred_languages = args.lang.split(",")
start_time = time.time()
deadline = start_time + args.max_minutes * 60 if args.max_minutes > 0 else None

def check_deadline():
    if deadline is not None and time.time() > deadline:
        print("ERREUR: delai max atteint (--max-minutes). Abandon (exit 124).")
        clean_exit(124)

def on_sigterm(signum, frame):
    print("SIGTERM recu. Abandon (exit 130).")
    clean_exit(130)

signal.signal(signal.SIGTERM, on_sigterm)

def progress(event, **kw):
    print(json.dumps({"event": event, "elapsed_s": round(time.time() - start_time, 1), **kw}, ensure_ascii=False), flush=True)

checkpoint = {}
if os.path.exists(args.checkpoint):
    with open(args.checkpoint, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                e = json.loads(line)
                checkpoint[(e["kind"], e["text1"], e["text2"])] = e["classification"]
ckpt_file = open(args.checkpoint, "a", encoding="utf-8")

def clean_exit(code, msg=""):
    if msg:
        print(msg)
    try:
        out_f.write("</rdf:RDF>\n")
        out_f.close()
    except Exception:
        pass
    try:
        ckpt_file.close()
    except Exception:
        pass
    sys.exit(code)

def save_ckpt(kind, t1, t2, score, cls):
    ckpt_file.write(json.dumps({"kind": kind, "text1": t1, "text2": t2, "score": score, "classification": cls}, ensure_ascii=False) + "\n")
    ckpt_file.flush()

print(f"Reprise: {len(checkpoint)} paires deja classifiees.")
print(f"Source: {args.source} | Cible: {args.target} | Sortie: {args.output}")

def is_singular_plural(text1, text2):
    t1 = unidecode(text1.lower().strip())
    t2 = unidecode(text2.lower().strip())
    if t1 == t2 + 's' or t1 + 's' == t2 or t1 == t2 + 'x' or t1 + 'x' == t2:
        return True
    irregular_plurals = [('au', 'aux'), ('al', 'aux'), ('eau', 'eaux'), ('ou', 'oux'), ('ail', 'aux')]
    for singular, plural in irregular_plurals:
        if (t1.endswith(singular) and t2.endswith(plural)) or (t1.endswith(plural) and t2.endswith(singular)):
            base1 = t1[:-len(singular)] if t1.endswith(singular) else t1[:-len(plural)]
            base2 = t2[:-len(plural)] if t2.endswith(plural) else t2[:-len(singular)]
            if base1 == base2:
                return True
    return False

def is_word_order_permutation(text1, text2):
    words1 = text1.split()
    words2 = text2.split()
    return sorted(words1) == sorted(words2) and words1 != words2

MAX_SKO_SIZE = 200 * 1024 * 1024  # 200 Mio max par fichier SKOS

def safe_parse_skos(file_path):
    size = os.path.getsize(file_path)
    if size > MAX_SKO_SIZE:
        raise ValueError(f"{file_path} trop volumineux ({size} octets > {MAX_SKO_SIZE})")
    DefusedET.parse(file_path)  # rejette XML dangereux (XXE, entites, billion laughs)
    return Graph().parse(file_path, format="xml")

def extract_skos_concepts(file_path):
    g = safe_parse_skos(file_path)
    concepts_set = set(g.subjects(RDF.type, SKOS.Concept))
    print(f"{file_path}: {len(g)} triplets, {len(concepts_set)} concepts")
    concepts = []
    for s in tqdm(concepts_set, desc=f"Parsing {os.path.basename(file_path)}"):
        pref_labels, alt_labels, definitions = [], [], []
        for p, o in g.predicate_objects(s):
            p_str = str(p)
            lang = o.language if hasattr(o, "language") else None
            if "prefLabel" in p_str:
                pref_labels.append((str(o), lang))
            elif "altLabel" in p_str:
                alt_labels.append((str(o), lang))
            elif "definition" in p_str:
                definitions.append((str(o), lang))
        text = ""
        pref_lang = None
        for lang in preferred_languages:
            for label, l in pref_labels:
                if l == lang:
                    text = unidecode(label.lower().strip())
                    pref_lang = l
                    break
            if text:
                break
        if not text and pref_labels:
            text = unidecode(pref_labels[0][0].lower().strip())
            pref_lang = pref_labels[0][1]
        alt = [(unidecode(l.lower().strip()), lg) for l, lg in alt_labels]
        definition = ""
        for lang in preferred_languages:
            for defn, l in definitions:
                if l == lang:
                    definition = unidecode(defn.lower().strip())
                    break
            if definition:
                break
        all_text = f"{text} | {definition} | " + " | ".join(a for a, _ in alt)
        concepts.append({"iri": str(s), "text": text, "definition": definition,
                         "pref_label_lang": pref_lang, "alt_labels_with_lang": alt, "all_text": all_text})
    return concepts

print("\n=== Chargement SKOS ===")
try:
    source_ontology = extract_skos_concepts(args.source)
    target_ontology = extract_skos_concepts(args.target)
except Exception as e:
    print(f"ERREUR: lecture SKOS impossible ({e}). Abandon (exit 2).")
    sys.exit(2)

out_f = open(args.output + ".tmp", "w", encoding="utf-8")
out_f.write('<?xml version="1.0" encoding="UTF-8"?>\n')
out_f.write(f'<rdf:RDF xmlns:rdf="{RDF}" xmlns:skos="{SKOS}" xmlns:owl="{OWL}">\n')

relation_counts = {}
written = set()

def relation_of(rt, ht=None):
    if rt == "exact":
        return "skos:exactMatch"
    if rt == "close":
        return "skos:closeMatch"
    if rt == "related":
        if ht == "broader":
            return "skos:broadMatch"
        if ht == "narrower":
            return "skos:narrowMatch"
        return "skos:relatedMatch"
    return "owl:differentFrom"

def write_pair(source_iri, target_iri, relation):
    key = (source_iri, target_iri)
    if key in written:
        return
    written.add(key)
    local = relation.split(":")[1]
    out_f.write(f'  <rdf:Description rdf:about="{escape(source_iri, {Q: "&quot;"})}">\n')
    out_f.write(f'    <skos:{local} rdf:resource="{escape(target_iri, {Q: "&quot;"})}" />\n')
    out_f.write('  </rdf:Description>\n')
    out_f.flush()
    relation_counts[relation] = relation_counts.get(relation, 0) + 1

print("\n=== Correspondances exactes ===")
exact_match_iris = set()

def build_index(ont, lang):
    idx = {}
    for i, c in enumerate(ont):
        if c["pref_label_lang"] == lang and c["text"]:
            idx.setdefault(c["text"], []).append(i)
        for alt, al in c["alt_labels_with_lang"]:
            if al == lang:
                idx.setdefault(alt, []).append(i)
    return idx

for lang in preferred_languages:
    s_idx = build_index(source_ontology, lang)
    t_idx = build_index(target_ontology, lang)
    for text, slist in s_idx.items():
        for ti in t_idx.get(text, []):
            for si in slist:
                key = (source_ontology[si]["iri"], target_ontology[ti]["iri"])
                if key not in exact_match_iris:
                    exact_match_iris.add(key)
                    write_pair(key[0], key[1], "skos:exactMatch")
print(f"exactMatch: {relation_counts.get('skos:exactMatch', 0)}")

print("\n=== Encodage SBERT (CPU) ===")
sbert = SentenceTransformer("paraphrase-multilingual-MiniLM-L12-v2", device="cpu")
source_texts = [c["all_text"] for c in source_ontology]
target_texts = [c["all_text"] for c in target_ontology]
source_emb = sbert.encode(source_texts, batch_size=64, show_progress_bar=True, convert_to_numpy=True).astype(np.float32)
target_emb = sbert.encode(target_texts, batch_size=64, show_progress_bar=True, convert_to_numpy=True).astype(np.float32)
del sbert
check_deadline()
gc.collect()

print("\n=== Paires candidates ===")
candidate_pairs = []
block = 2048
for start in tqdm(range(0, len(source_emb), block), desc="Candidats"):
    check_deadline()
    sims = cosine_similarity(source_emb[start:start + block], target_emb)
    k = min(args.top_k, sims.shape[1])
    for i in range(sims.shape[0]):
        row = sims[i]
        top = np.argpartition(row, -k)[-k:]
        for j in top:
            if row[j] > args.min_score:
                gi = start + i
                key = (source_ontology[gi]["iri"], target_ontology[int(j)]["iri"])
                if key not in exact_match_iris:
                    candidate_pairs.append({
                        "source": key[0],
                        "target": key[1],
                        "source_text": source_ontology[gi]["text"],
                        "target_text": target_ontology[int(j)]["text"],
                        "source_def": source_ontology[gi]["definition"],
                        "target_def": target_ontology[int(j)]["definition"],
                        "score": float(row[j]),
                    })
    del sims
gc.collect()
del source_emb, target_emb, source_ontology, target_ontology, source_texts, target_texts
gc.collect()
print(f"{len(candidate_pairs)} paires candidates.")
progress("candidates", count=len(candidate_pairs))

# --- Point 1 : LLM obligatoire et robuste ---
llm = None
llm_stats = {"calls": 0, "retries": 0, "errors": 0}

if candidate_pairs:
    print("\n=== Chargement LLM (CPU) ===")
    try:
        llm = Llama(model_path=args.model, n_ctx=2048, n_threads=args.threads, n_gpu_layers=0, verbose=False)
    except Exception as e:
        print(f"ERREUR: modele LLM indisponible ({e}). Abandon (exit 3).")
        out_f.write("</rdf:RDF>\n")
        out_f.close()
        ckpt_file.close()
        sys.exit(3)
    print("Modele charge.")

def check_llm_health():
    if llm_stats["errors"] > args.llm_max_error_rate * max(1, llm_stats["calls"]):
        print(f"ERREUR: taux d'erreurs LLM trop eleve ({llm_stats['errors']}/{llm_stats['calls']} > {args.llm_max_error_rate}). Abandon (exit 4).")
        out_f.write("</rdf:RDF>\n")
        out_f.close()
        ckpt_file.close()
        sys.exit(4)

def llm_classify(prompt, allowed):
    for attempt in range(args.llm_retries):
        try:
            llm_stats["calls"] += 1
            out = llm(prompt, max_tokens=8, temperature=0.0, stop=["[/INST]"], echo=False)
            text = out["choices"][0]["text"]
            markers = re.findall(r"[([]([%s])]" % "".join(allowed), text)
            if markers:
                return int(markers[-1])
        except Exception as e:
            llm_stats["retries"] += 1
            print(f"LLM erreur, tentative {attempt + 1}/{args.llm_retries}: {e}")
        time.sleep(0.5 * (attempt + 1))
    llm_stats["errors"] += 1
    return None

def classify_equivalence(t1, t2, d1, d2, score, hint=None):
    prompt = (
        "[INST]\n"
        "Tu es un expert en alignement de thesauri SKOS. Relation entre deux termes :\n"
        f'Terme 1: "{t1}" (definition: {d1 or "aucune"})\n'
        f'Terme 2: "{t2}" (definition: {d2 or "aucune"})\n'
        f"Score de similarite: {score:.2f}\n"
        + (f"Indice: {hint}\n" if hint else "")
        + "Reponds UNIQUEMENT par un marqueur: [1]=exact, [2]=close, [3]=related, [4]=unrelated.\n"
        "[/INST]"
    )
    cls = llm_classify(prompt, "1234")
    if cls is None:
        return "unresolved"
    if cls == 1 and score < 0.85:
        cls = 2
    elif cls == 2 and score < 0.75:
        cls = 3
    elif cls == 3 and score < 0.6:
        cls = 4
    return {1: "exact", 2: "close", 3: "related", 4: "unrelated"}[cls]

def classify_hierarchy(t1, t2, d1, d2, score):
    prompt = (
        "[INST]\n"
        "Tu es un expert en alignement de thesauri SKOS. Relation hierarchique entre deux concepts :\n"
        f'Concept 1: "{t1}" (definition: {d1 or "aucune"})\n'
        f'Concept 2: "{t2}" (definition: {d2 or "aucune"})\n'
        f"Score de similarite: {score:.2f}\n"
        "Reponds UNIQUEMENT par un marqueur: [1]=broader (concept 2 plus general), [2]=narrower (concept 2 plus specifique), [3]=related.\n"
        "[/INST]"
    )
    cls = llm_classify(prompt, "123")
    if cls is None:
        return "unresolved"
    return {1: "broader", 2: "narrower", 3: "related"}[cls]

related_pairs = []
if llm and candidate_pairs:
    print("\n=== Classification LLM (equivalence) ===")
    for pair in tqdm(candidate_pairs, desc="Equivalence"):
        check_deadline()
        if llm_stats["calls"] % 50 == 0:
            progress("classifying", llm_calls=llm_stats["calls"], total=len(candidate_pairs))
        t1, t2 = pair["source_text"], pair["target_text"]
        variant = is_singular_plural(t1, t2) or is_word_order_permutation(t1, t2)
        hint = "les deux libelles ne different que par une flexion (singulier/pluriel) ou une permutation de mots" if variant else None
        key = ("equivalence", t1, t2)
        if key in checkpoint:
            rt = checkpoint[key]
        else:
            rt = classify_equivalence(t1, t2, pair["source_def"], pair["target_def"], pair["score"], hint)
            if rt == "unresolved":
                save_ckpt("llm_error", t1, t2, pair["score"], "unresolved")
                check_llm_health()
                continue
            save_ckpt("equivalence", t1, t2, pair["score"], rt)
            check_llm_health()
        if rt in ("exact", "close"):
            write_pair(pair["source"], pair["target"], relation_of(rt))
        elif rt == "related":
            related_pairs.append(pair)

if llm and related_pairs and not args.no_hierarchy:
    print(f"\n=== Raffinage hierarchique ({len(related_pairs)} paires) ===")
    for pair in tqdm(related_pairs, desc="Hierarchie"):
        check_deadline()
        t1, t2 = pair["source_text"], pair["target_text"]
        key = ("hierarchy", t1, t2)
        if key in checkpoint:
            ht = checkpoint[key]
        else:
            ht = classify_hierarchy(t1, t2, pair["source_def"], pair["target_def"], pair["score"])
            if ht == "unresolved":
                save_ckpt("llm_error", t1, t2, pair["score"], "unresolved")
                check_llm_health()
                continue
            save_ckpt("hierarchy", t1, t2, pair["score"], ht)
            check_llm_health()
        write_pair(pair["source"], pair["target"], relation_of("related", ht))
elif related_pairs:
    for pair in tqdm(related_pairs, desc="relatedMatch"):
        write_pair(pair["source"], pair["target"], "skos:relatedMatch")

out_f.write("</rdf:RDF>\n")
out_f.close()
ckpt_file.close()
os.replace(args.output + ".tmp", args.output)

total = sum(relation_counts.values())
elapsed = time.time() - start_time
print(f"\n=== Termine en {int(elapsed // 60)}m {int(elapsed % 60)}s ===")
print(f"Alignements ecrits dans {args.output}: {total}")
if llm is not None:
    print(f"LLM: {llm_stats['calls']} appels, {llm_stats['retries']} retries, {llm_stats['errors']} erreurs definitives (non ecrites).")
if total > 0:
    for rel in ["skos:exactMatch", "skos:closeMatch", "skos:relatedMatch", "skos:broadMatch", "skos:narrowMatch"]:
        c = relation_counts.get(rel, 0)
        if c:
            print(f"  {rel}: {c} ({c / total * 100:.1f}%)")

if llm is not None:
    del llm
del candidate_pairs, related_pairs
gc.collect()

progress("done", total_alignments=total, counts=relation_counts)
report = {
    "generator": "loterre-align",
    "source": args.source,
    "target": args.target,
    "params": {"lang": args.lang, "min_score": args.min_score, "top_k": args.top_k, "no_hierarchy": args.no_hierarchy, "max_minutes": args.max_minutes},
    "counts": relation_counts,
    "total_alignments": total,
    "llm": dict(llm_stats),
    "elapsed_seconds": round(elapsed, 1),
}
report_path = os.path.join(os.path.dirname(os.path.abspath(args.output)), "report.json")
with open(report_path + ".tmp", "w", encoding="utf-8") as rf:
    json.dump(report, rf, ensure_ascii=False, indent=2)
os.replace(report_path + ".tmp", report_path)
print("OK")