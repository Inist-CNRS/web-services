#!/usr/bin/env python3
import networkx as nx
import json
import math
import sys

json_data = json.load(sys.stdin)

G = nx.DiGraph()

doi_info = {}
for citation in json_data:
    citation_id = citation["id"]
    count = citation["value"]["count"]
    citing_dois = citation["value"]["citing_doi"]

    # Mettre à jour le statut du DOI cité
    if citation_id not in doi_info:
        doi_info[citation_id] = {"count": count, "cité": True, "citant": False}
    else:
        doi_info[citation_id]["count"] = count
        doi_info[citation_id]["cité"] = True

    # Parcourir les DOIs citants
    for citing_doi in citing_dois:
        if citing_doi not in doi_info:
            doi_info[citing_doi] = {"count": 1, "cité": False, "citant": True}
        else:
            doi_info[citing_doi]["citant"] = True

        # Ajouter l'arête
        G.add_edge(citing_doi, citation_id)

# Ajouter les nœuds avec leurs attributs
for doi, info in doi_info.items():
    count = info["count"]
    size = math.log(count + 1, 10) * 50 + 50

    # Déterminer la couleur
    if info["cité"] and info["citant"]:
        color = {"r": 0, "g": 255, "b": 0, "a": 0.8}  # Vert (cité/citant)
        statut = "cité/citant"
    elif info["cité"]:
        color = {"r": 255, "g": 0, "b": 0, "a": 0.8}  # Rouge
        border_color = None
        statut = "cité"
    elif info["citant"]:
        color = {"r": 0, "g": 0, "b": 255, "a": 0.8}  # Bleu
        border_color = None
        statut = "citant"

    # Ajouter le nœud avec les attributs
    G.add_node(doi, viz={"size": size, "color": color}, count=count, statut=statut)

# Sauvegarder le graphe en format GEXF
linefeed = "\n"
gexf_string = linefeed.join(nx.generate_gexf(G))
sys.stderr.write(gexf_string)


sys.stdout.write(json.dumps({"value": gexf_string}))
sys.stdout.write("\n")
