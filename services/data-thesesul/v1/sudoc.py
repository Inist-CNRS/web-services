#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from thesesul.thesesul_functions import *

if __name__ == "__main__":
    log_file = str(os.path.join(TMP_DIR, "retrieve", retrieve_id, "log.csv"))
    with open(log_file, 'w') as f_log:
        f_log.write(f"ID du fichier,Erreur"+ '\n')

    for line in sys.stdin:
        try:
            line = json.loads(line)
            sudoc_id = line["value"]
            
            if sudoc_id == "":
                continue

        except:
            write_error_in_logs(log_file, "n/a", "Erreur : la liste d'identifiants Sudoc comporte des erreurs")
            continue
        
        try:
            get_hal_zip_from_sudoc_id(sudoc_id, log_file)
        finally:
            # Suppression des fichiers temporaires
            delete_files()
    cmd = (
        f'cd /tmp/retrieve/{retrieve_id} && '
        f'tar -czf /tmp/retrieve/{retrieve_id}.tar.gz . && '
        f'cd /app/public/ && '
        f'rm -r /tmp/retrieve/{retrieve_id} && '
        f'mv /tmp/retrieve/{retrieve_id}.tar.gz /tmp/retrieve/{retrieve_id}'
    )    
    result = subprocess.run(cmd, shell=True, capture_output=False)

    sys.stdout.write(json.dumps({"value":"empty, just to proc webhook"}))
    sys.stdout.write("\n")

