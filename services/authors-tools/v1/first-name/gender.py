#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pickle
import sys
import json
import re
from unidecode import unidecode


def detector(name,my_dict) :
    name = name.replace("'","")
    if re.match(r"^([A-Z][. '-]+){2,}[A-Z]*",name) or re.match(r"\b[A-Z]+\b\.?",name) :
        return "name error"
    else :
        name = unidecode(name.lower())
        name = name.replace(".","")
        name = name.replace("- ","-")
        name = name.replace("'","")
        name = re.split("[,\s-]+", name)

######################## POUR LES PRENOMS SIMPLE. EXEMPLE : BOB ###########################################################
        if len(name) == 1 :
            if name[0] in my_dict.keys() :
                if my_dict[name[0]] == "M":
                    return u"masculin"
                elif my_dict[name[0]] == "1M" or my_dict[name[0]] == "?M":
                    return u"mixte_masculin"
                elif my_dict[name[0]] == "F":
                    return u"feminin"
                elif my_dict[name[0]] == "1F" or my_dict[name[0]] == "?F":
                    return u"mixte_feminin"
                elif my_dict[name[0]] == "?":
                    return u"mixte"
                else :
                    return "unknown" 
            else :
                return "unknown"
######################## POUR LES PRENOMS COMPOSES : JEAN-CHRISTOPHE OU ERIN NICOLE #########################################
########## ON RECHERCHE LE PRENOM COMPOSES EN ENTIER #######################################################################
################## SI LE PRENOM COMPOSES N'EST PAS PRESENT ALORS ON REGARDE SEULEMENT LE PREMIER #########################
        elif len(name) >= 2 and len(name[0]) > 1 and len(name[1]) > 1:
            possible_keys = [name[0]+name[1],name[0]+"-"+name[1],name[0]+" "+name[1],name[0]]
            for key in possible_keys:
                if key in my_dict:
                    if my_dict[key] == "M":
                        return u"masculin"
                    elif my_dict[key] == "1M" or my_dict[key] == "?M":
                        return u"mixte_masculin"
                    elif my_dict[key] == "F":
                        return u"feminin"
                    elif my_dict[key] == "1F" or my_dict[key] == "?F":
                        return u"mixte_feminin"
                    elif my_dict[key] == "?":
                        return u"mixte"
            return "unknown"
######################### POUR LES PRENOMS TYPES : JAMES A OU JAMES JR ########################################################    
        elif len(name) >= 2 and len(name[0]) > 1 and len(name[1]) <= 2 :
            if name[0] in my_dict.keys() :
                if my_dict[name[0]] == "M":
                    return u"masculin"
                elif my_dict[name[0]] == "1M" or my_dict[name[0]] == "?M":
                    return u"mixte_masculin"
                elif my_dict[name[0]] == "F":
                    return u"feminin"
                elif my_dict[name[0]] == "1F" or my_dict[name[0]] == "?F":
                    return u"mixte_feminin"
                elif my_dict[name[0]] == "?":
                    return u"mixte"
                else :
                    return "unknown"
            else :
                return "unknown"
        else :
            return "name error"


def main():
    with open('./v1/first-name/name_gender.pickle', 'rb') as handle:
        my_dict = pickle.load(handle)

    for line in sys.stdin:
        data = json.loads(line)
        texte = data["value"]
        data["value"] = detector(unidecode(texte), my_dict)
        sys.stdout.write(json.dumps(data))
        sys.stdout.write("\n")

if __name__ == "__main__":
    main()