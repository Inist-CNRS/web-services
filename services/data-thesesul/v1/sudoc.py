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
            sudoc_file = get_xml_from_sudoc(sudoc_id)
            if sudoc_file :
                cond_file = transform_sudoc_to_conditor(sudoc_file)
                if cond_file:
                    tei_hal_file = transform_conditor_to_tei_hal(cond_file)
                    if tei_hal_file:
                        if validate_tei_hal(tei_hal_file):
                            input_file = os.path.join(TMP_DIR, f"tei_hal-{retrieve_id}.xml")
                            res_file = os.path.join(OUTPUT_DIR, f'{sudoc_id}.xml')
                            with open(input_file, 'r') as f_in:
                                with open(res_file, 'w') as f_out:
                                    f_out.write(f_in.read())
                                    
                            pdf_file = download_pdf(res_file)
                            if not pdf_file:
                                write_error_in_logs(log_file, sudoc_id, "Erreur : Récuperation du fichier PDF impossible")
                            else:
                                modify_target_in_xml(res_file, sudoc_id)
                                create_zip(sudoc_id)
                        else:
                            write_error_in_logs(log_file, sudoc_id, "Erreur : Fichier TEI généré invalide")
                    else:
                        write_error_in_logs(log_file, sudoc_id, "Erreur :  Schéma invalide (transformation XLST vers TEI-Hal impossible - 2)")
                else:
                    write_error_in_logs(log_file, sudoc_id, "Erreur : Schéma invalide (transformation XLST vers TEI-Hal impossible - 1)")
            else:
                write_error_in_logs(log_file, sudoc_id, "Erreur : Récupération du fichier XML du Sudoc impossible")
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

