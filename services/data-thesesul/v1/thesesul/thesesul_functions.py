#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import subprocess
import requests
import sys
import json
import re
import zipfile
import time

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
                

def download_pdf(xml_file):
    with open(xml_file, "r") as f:
        file = f.read()
        
    pdf_pattern = re.compile(r'target=\".*?\.pdf\"')
    matches = pdf_pattern.findall(file)
    
    if not any(matches):
        return None
    
    pdf_name = matches[0].split('"')[1]
    output_pdf = os.path.join(OUTPUT_DIR, pdf_name)
    url = "http://docnum.univ-lorraine.fr/public/" + pdf_name
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


def create_zip(sudoc_id, xml_file, pdf_file, log_file):
    files_to_zip = [xml_file, pdf_file]
    output_zip = os.path.join(OUTPUT_DIR,f'{sudoc_id}.zip')

    try:
        with zipfile.ZipFile(output_zip, 'w') as archive:
            for fichier in files_to_zip:
                archive.write(fichier, arcname=fichier.split('/')[-1])
        os.remove(pdf_file)        
        os.remove(xml_file)
        
    except Exception as e:
        os.remove(pdf_file)
        write_error_in_logs(log_file, sudoc_id, "Warning : Récuperation du fichier PDF impossible")


def get_hal_zip_from_sudoc_id(sudoc_id, log_file):
    max_attempts = 5
    delay_seconds = 3
    last_error = None

    for attempt in range(max_attempts):
        try:
            sudoc_file = get_xml_from_sudoc(sudoc_id)
            if not sudoc_file:
                raise Exception("Erreur : Récupération du fichier XML du Sudoc impossible")

            cond_file = transform_sudoc_to_conditor(sudoc_file)
            if not cond_file:
                raise Exception("Erreur : Schéma invalide (transformation XLST vers TEI-Hal impossible - 1)")

            tei_hal_file = transform_conditor_to_tei_hal(cond_file)
            if not tei_hal_file:
                raise Exception("Erreur : Schéma invalide (transformation XLST vers TEI-Hal impossible - 2)")

            # if not validate_tei_hal(tei_hal_file):
            #     raise Exception("Erreur : Fichier TEI généré invalide")

            input_file = os.path.join(TMP_DIR, f"tei_hal-{retrieve_id}.xml")
            xml_file = os.path.join(OUTPUT_DIR, f'{sudoc_id}.xml')
            with open(input_file, 'r') as f_in:
                with open(xml_file, 'w') as f_out:
                    f_out.write(f_in.read())

            pdf_file = download_pdf(xml_file)
            if not pdf_file:
                raise Exception("Erreur : Récuperation du fichier PDF impossible")

            create_zip(sudoc_id, xml_file, pdf_file, log_file)
            return

        except Exception as e:
            last_error = str(e)
            if attempt < max_attempts - 1:
                # waiting 3, 6, 9, 12 secs ...(increase for each retry)
                time.sleep(delay_seconds*attempt)
            else:
                write_error_in_logs(log_file, sudoc_id, last_error)
