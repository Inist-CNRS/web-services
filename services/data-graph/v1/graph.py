#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
from ressources import *
import time

thresh_edge = sys.argv[sys.argv.index("-p") + 1] if "-p" in sys.argv else "auto"
thresh_node = sys.argv[sys.argv.index("-q") + 1] if "-q" in sys.argv else "auto"

print(thresh_edge, thresh_node, file=sys.stderr)

# load all datas
lines = []
for line in sys.stdin:
    data = json.loads(line)
    isPid = [x for x in list(data.keys()) if x.startswith("PID")]
    if len(isPid) > 0:
        pid = data[isPid[0]][5:]
    lines.append(data["value"])

print("PID ", pid, file=sys.stderr)
print(time.strftime("%A %d %B %Y %H:%M:%S"), file=sys.stderr)
keyword = []
L = []
freq = {}
for line in lines:
    L.append(line)
    for w in line:
        if w not in freq:
            freq[w] = 1
        else:
            freq[w] += 1

freq = {k: v for k, v in sorted(freq.items(), key=lambda item: item[1], reverse=True)}
# print(freq, file=sys.stderr)

# Seuil node
if thresh_node == "auto":
    if len(freq) < 100:
        thresh_node = 1
    else:
        diff_words = 0
        threshold = 0.175
        threshold_step = 0.025
        while diff_words < 50 and threshold < 0.6:
            diff_words = 0
            threshold += threshold_step
            total = sum(freq.values())
            target = total * threshold
            cumulative = 0
            for key, value in freq.items():
                diff_words += 1
                cumulative += value
                if cumulative >= target:
                    thresh_node = freq[key]
                    break
        print(
            "Selected threshold : ",
            threshold,
            "different words : ",
            diff_words,
            file=sys.stderr,
        )
else:
    thresh_node = int(thresh_node)

for liste in L:
    l = []
    for w in liste:
        if freq[w] >= thresh_node:
            l.append(w)
    if len(l) > 0:
        keyword.append(l)

# Seuil edge
if thresh_edge == "auto":
    if thresh_node == 1:
        thresh_edge = 0
    else:
        thresh_edge = thresh_node / 6
        if thresh_edge < 1:
            thresh_edge = 1
else:
    thresh_edge = int(thresh_edge)


print(thresh_node, thresh_edge, file=sys.stderr)
# print(keyword, file=sys.stderr)
node_weight, edge_weight, ignore_edge = get_weights(keyword, thresh_edge)
# print(node_weight, file=sys.stderr)
G = build_graph(node_weight, edge_weight)
partition, communities = build_partition(G)

linefeed = "\n"
gexf = linefeed.join(plot_2D(G, partition, ignore_edge, pid))

print("Finished", file=sys.stderr)
sys.stdout.write(json.dumps({"value": gexf}))
sys.stdout.write("\n")
