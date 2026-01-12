#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import networkx as nx
from collections import defaultdict
import sys


def get_fixed_color(index):
    # Palette générée
    fixed_colors = [
        {"r": 31,  "g": 119, "b": 180, "a": 0.8},  # Bleu
        {"r": 255, "g": 127, "b": 14,  "a": 0.8},  # Orange
        {"r": 44,  "g": 160, "b": 44,  "a": 0.8},  # Vert
        {"r": 214, "g": 39,  "b": 40,  "a": 0.8},  # Rouge
        {"r": 148, "g": 103, "b": 189, "a": 0.8},  # Violet
        {"r": 140, "g": 86,  "b": 75,  "a": 0.8},  # Brun
        {"r": 227, "g": 119, "b": 194, "a": 0.8},  # Rose
        {"r": 127, "g": 127, "b": 127, "a": 0.8},  # Gris
        {"r": 188, "g": 189, "b": 34,  "a": 0.8},  # Jaune-vert
        {"r": 23,  "g": 190, "b": 207, "a": 0.8},  # Cyan
        {"r": 174, "g": 199, "b": 232, "a": 0.8},  # Bleu clair
        {"r": 255, "g": 187, "b": 120, "a": 0.8},  # Orange clair
        {"r": 152, "g": 223, "b": 138, "a": 0.8},  # Vert clair
        {"r": 255, "g": 152, "b": 150, "a": 0.8},  # Rouge clair
        {"r": 197, "g": 176, "b": 213, "a": 0.8},  # Violet clair
        {"r": 196, "g": 156, "b": 148, "a": 0.8},  # Brun clair
        {"r": 0,   "g": 109, "b": 44,  "a": 0.8},  # Vert foncé
        {"r": 0,   "g": 62,  "b": 124, "a": 0.8},  # Bleu foncé
    ]

    return fixed_colors[index % len(fixed_colors)]



def create_gexf_from_topics(topics_data, topic_colors, output_file="output.gexf"):
    G = nx.Graph()
    nodes = {}
    for topic_id, words_and_weights in topics_data.items():
        color = topic_colors[topic_id]
        words = words_and_weights["words"]
        words_weights = words_and_weights["weights"]

        for word, weight in zip(words, words_weights):
            if G.has_node(word):
                if weight > G.nodes[word]["weight"]:
                    G.nodes[word]["weight"] += weight
                    G.nodes[word]["viz"]["size"] = int(G.nodes[word]["weight"] * 1000)
            else:
                G.add_node(word, label=word, weight=weight, viz={"size": int(weight * 1000), "color": color}, title="a")


        for i in range(len(words)):
            for j in range(i + 1, len(words)):
                G.add_edge(words[i], words[j], color=color)
        
    # Compute position with Fruchterman-Reingold spatialisation
    pos = nx.spring_layout(G, k=0.2, iterations=1000)

    scale = 512
    for node, coords in pos.items():
        G.nodes[node]["viz"]["position"] = {
            "x": float(coords[0] * scale),
            "y": float(coords[1] * scale),
            "z": float(0)
        }

    linefeed = "\n"
    gexf_string = linefeed.join(nx.generate_gexf(G))
    return gexf_string


topics_data = defaultdict(dict)
topic_colors = {}
color_index = 0
for line in sys.stdin:
    try:
        data = json.loads(line)
        if "value" in data and isinstance(data["value"], dict):
            if "topics" in data["value"]:
                topics = data["value"]["topics"]
                if isinstance(topics, dict):
                    for topic_name, topic_info in topics.items():
                        if topic_name not in topic_colors:
                            topic_colors[topic_name] = get_fixed_color(color_index)
                            color_index += 1
                        if "words" in topic_info and "words_weights" in topic_info:
                            topics_data[topic_name]["words"] = topic_info["words"]
                            topics_data[topic_name]["weights"] = [float(w) for w in topic_info["words_weights"]]
    except json.JSONDecodeError:
        continue

gexf_string = create_gexf_from_topics(topics_data, topic_colors)
sys.stdout.write(json.dumps({"value": gexf_string}))
sys.stdout.write("\n")
