#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import os
import sys
import subprocess
import thesesul.thesesul_functions as th_fu

if __name__ == "__main__":
    TMPDIR = th_fu.TMP_DIR
    retrieve_id = th_fu.retrieve_id

    log_file = str(os.path.join(TMPDIR, "retrieve", retrieve_id, "log.csv"))
    with open(log_file, 'w') as f_log:
        f_log.write("ID du fichier,Erreur" + '\n')

    for line in sys.stdin:
        try:
            line = json.loads(line)
            sudoc_id = line["value"]

            if sudoc_id == "":
                continue

        except Exception:
            th_fu.write_error_in_logs(log_file, "n/a", "Erreur : la liste d'identifiants Sudoc comporte des erreurs")
            continue

        try:
            th_fu.get_hal_zip_from_sudoc_id(sudoc_id, log_file)
        finally:
            # Suppression des fichiers temporaires
            th_fu.delete_files()
    cmd = (
        f'cd /tmp/retrieve/{retrieve_id} && '
        f'tar -czf /tmp/retrieve/{retrieve_id}.tar.gz . && '
        f'cd /app/public/ && '
        f'rm -r /tmp/retrieve/{retrieve_id} && '
        f'mv /tmp/retrieve/{retrieve_id}.tar.gz /tmp/retrieve/{retrieve_id}'
    )
    result = subprocess.run(cmd, shell=True, capture_output=False)

    sys.stdout.write(json.dumps({"value": "empty, just to proc webhook"}))
    sys.stdout.write("\n")
