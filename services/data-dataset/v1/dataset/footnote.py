from difflib import SequenceMatcher


def extract_footnote(blocks):
    sizes = []
    texts = []
    for block in blocks:
        if "lines" in block.keys():
            spans = block['lines']
            for span in spans:
                data = span['spans']
                for lines in data:
                    texts.append(lines['text'])
                    sizes.append(lines['size'])
    diff = []
    for i in range(1, len(texts)-1):
        if sizes[i] != sizes[i-1] and sizes[i] != sizes[i+1] and len(texts[i]) < 3:
            diff.append([texts[i-1], texts[i], texts[i+1]])
    done = []
    same = []
    for i in range(len(diff)):
        if i not in done:
            for j in range(i+1, len(diff)):
                if diff[i][1] == diff[j][1] and (j not in done):
                    done.append(j)
                    same.append((diff[i], diff[j]))
    final_link = []
    for t in same:
        if "http" in t[0][0]:
            link_adress = t[0][0]
            link = t[1][2]
            marker = t[0][1]
        elif "http" in t[0][2]:
            link_adress = t[0][2]
            link = t[1][0]
            marker = t[0][1]
        elif "http" in t[1][0]:
            link_adress = t[1][0]
            link = t[0][2]
            marker = t[0][1]
        elif "http" in t[1][2]:
            link_adress = t[1][2]
            link = t[0][0]
            marker = t[0][1]
        else:
            continue
        final_link.append({"num": marker, "source": link, "adress": link_adress})
    return final_link


def check_link_w_foot(entity, notes_dic):
    link = "None"
    for dic in notes_dic:
        if SequenceMatcher(None, dic["source"], entity).ratio() > 0.6:
            link = dic["adress"]
            break
    return link
