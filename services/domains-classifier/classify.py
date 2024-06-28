#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import logging
import plac
import sys

from models import model_init
from tools_prediction import do_predictions


# parametres cli
@plac.annotations(

    profondeur=("profondeur = nombre de code par document", "option", "p", int),

)
def main(profondeur=3):
    # test hauteur maxi de l arbo des modeles
    hauteur_maxi = 3
    if (profondeur not in range(1, hauteur_maxi + 1)):
        logging.error("Tree model not correct!")
        exit(1)

    compteur = 0
    # lecture ligne a ligne sur lentrée standard
    # 1 ligne = un json {}
    for json_line in sys.stdin:
        # deserialisation json
        compteur += 1
        try:
            data = json.loads(json_line)
            # trace
            # print("******** FORMAT OK : id:{}".format(data["id"]))
        except json.decoder.JSONDecodeError:
            logging.error("Input format problem line :{} : String could not be converted to JSON".format(compteur))
            exit(1)

        # execution de la prediction
        param = (data["value"], int(profondeur))
        result = do_predictions(*param, **model_init)

        # Supprimer le code "003" s'il est en debut de code pour les niveaux 2 et 3
        for level in result:
            if level["code"].startswith("003"):
                if level["code"] == "003":
                    pass
                else:
                    level["code"] = level["code"][3:]

        data["value"] = result

        # serialisation json et ecriture sur la sortie standard
        sys.stdout.write(json.dumps(data))
        sys.stdout.write("\n")


if __name__ == "__main__":

    if False:
        import cProfile
        import pstats

        cProfile.runctx("plac.call(main)", globals(), locals(), "Profile.prof")
        s = pstats.Stats("Profile.prof")
        s.strip_dirs().sort_stats("time").print_stats()
    else:
        plac.call(main)
