#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import subprocess
import requests
import sys
import json
import re

# Chemin du répertoire temporaire
TMP_DIR = '/tmp'

retrieve_id = str(sys.argv[sys.argv.index('-p') + 1])
OUTPUT_DIR = os.path.join(TMP_DIR, "retrieve", retrieve_id, "datas")
os.makedirs(OUTPUT_DIR, exist_ok=True)


def write_error_in_logs(log_file, sudoc_id, error):
    with open(log_file, 'a') as f_log:
        f_log.write(f"{sudoc_id},{error}"+ '\n')

      
def delete_files():
    to_dels = [f"sudoc_file-{retrieve_id}.xml", f"conditor_file-{retrieve_id}.xml", f"tei_hal-{retrieve_id}.xml"]
    for to_del in to_dels:
        to_del = os.path.join(TMP_DIR, to_del)
        if os.path.exists(to_del):
            os.remove(to_del)


def get_xml_from_sudoc(sudoc_id):
    url = f"https://www.sudoc.fr/{sudoc_id}.xml"
    output_path = os.path.join(TMP_DIR, f"sudoc_file-{retrieve_id}.xml")
    
    response = requests.get(url)
    
    if response.status_code != 200:
        return None
    else: 
        with open(output_path, 'wb') as file:
            file.write(response.content)
        return output_path
                

def download_pdf(res_file):
    with open(res_file, "r") as f:
        file = f.read()
        
    pdf_pattern = re.compile(r'target=\".*?\.pdf\"')
    matches = pdf_pattern.findall(file)
    
    if not any(matches):
        return None
    
    output_pdf = res_file.replace("xml", "pdf")
    url = "http://docnum.univ-lorraine.fr/public/" + matches[0].split('"')[1]
    try:
        response = requests.get(url)
        if response.status_code!=200:
            return None
            
        else:
            with open(output_pdf, 'wb') as f:
                f.write(response.content)
            return output_pdf
        
    except requests.exceptions.RequestException as e:
        return None


def transform_sudoc_to_conditor(sudoc_file):
    conditor_file = os.path.join(TMP_DIR, f"conditor_file-{retrieve_id}.xml")
    cmd = ['xsltproc', '-o', conditor_file, 'v1/xsl-files/SudocThese2Conditor.xsl', sudoc_file]
    result = subprocess.run(cmd, capture_output=True)
    if result.returncode != 0:
        return None
    return conditor_file


def transform_conditor_to_tei_hal(conditor_file):
    tei_hal_file = os.path.join(TMP_DIR, f"tei_hal-{retrieve_id}.xml")
    cmd = ['xsltproc', '-o', tei_hal_file, 'v1/xsl-files/LORR_TheseExe2HAL.xsl', conditor_file]
    result = subprocess.run(cmd, capture_output=True)
    if result.returncode != 0:
        return None
    return tei_hal_file


def validate_tei_hal(tei_hal_file):
    cmd = f'xmllint --noout {tei_hal_file} --schema v1/xsl-files/aofr3.xsd'
    result = subprocess.run(cmd, shell=True, capture_output=True)

    if result.returncode != 0:
        return False
    return True


# Main
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

