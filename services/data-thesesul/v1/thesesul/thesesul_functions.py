#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import subprocess
import requests
import sys
import re
import zipfile
import time
import datetime

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


def write_in_stderr(message):
    date = str(datetime.datetime.now()).split('.')[0]
    sys.stderr.write(f"{date} - {message} \n")


def get_xml_from_sudoc(sudoc_id, max_attempt=4, delay_seconds=2):
    url = f"https://www.sudoc.fr/{sudoc_id}.xml"
    output_path = os.path.join(TMP_DIR, f"sudoc_file-{retrieve_id}.xml")
    for attempt in range(max_attempt):
        try:
            response = requests.get(url)
            
            if response.status_code != 200:
                write_in_stderr(f"Error {str(response.status_code)} in requests in get_xml_from_sudoc")
                time.sleep(delay_seconds*attempt)
                continue

            else:
                with open(output_path, 'wb') as file:
                    file.write(response.content)
                return output_path

        except Exception:
            time.sleep(delay_seconds*attempt)
            continue

    raise Exception(f"Could not download XML from Sudoc (max attempt:{max_attempt}).")


def download_pdf(xml_file, max_attempt=4, delay_seconds=2):
    with open(xml_file, "r") as f:
        file = f.read()

    pdf_pattern = re.compile(r'target=\".*?\.pdf\"')
    matches = pdf_pattern.findall(file)

    if not any(matches):
        return None

    pdf_name = matches[0].split('"')[1]
    output_pdf = os.path.join(OUTPUT_DIR, pdf_name)
    url = "http://docnum.univ-lorraine.fr/public/" + pdf_name
    for attempt in range(max_attempt):
        try:
            response = requests.get(url)
            if response.status_code != 200:
                write_in_stderr(f"Error {str(response.status_code)} in requests in download_pdf")
                time.sleep(delay_seconds*attempt)
                continue

            else:
                with open(output_pdf, 'wb') as f:
                    f.write(response.content)
                return output_pdf

        except Exception:
            time.sleep(delay_seconds*attempt)
            continue

    raise Exception(f"Could not download PDF from Sudoc (max attempt:{max_attempt}).")


def transform_sudoc_to_conditor(sudoc_file):
    conditor_file = os.path.join(TMP_DIR, f"conditor_file-{retrieve_id}.xml")
    cmd = ['xsltproc', '-o', conditor_file, 'v1/xsl-files/SudocThese2Conditor.xsl', sudoc_file]
    result = subprocess.run(cmd, capture_output=True)
    if result.returncode != 0:
        raise Exception("Erreur : Schéma invalide (transformation XLST vers TEI-Hal impossible - 1)")
    return conditor_file


def transform_conditor_to_tei_hal(conditor_file):
    tei_hal_file = os.path.join(TMP_DIR, f"tei_hal-{retrieve_id}.xml")
    cmd = ['xsltproc', '-o', tei_hal_file, 'v1/xsl-files/LORR_TheseExe2HAL.xsl', conditor_file]
    result = subprocess.run(cmd, capture_output=True)
    if result.returncode != 0:
        raise Exception("Erreur : Schéma invalide (transformation XLST vers TEI-Hal impossible - 2)")
    return tei_hal_file


def validate_tei_hal(tei_hal_file):
    cmd = f'xmllint --noout {tei_hal_file} --schema v1/xsl-files/aofr3.xsd'
    result = subprocess.run(cmd, shell=True, capture_output=True)

    if result.returncode != 0:
        raise Exception("Erreur : Fichier TEI généré invalide")


def create_zip(sudoc_id, xml_file, pdf_file, log_file):
    files_to_zip = [xml_file, pdf_file]
    output_zip = os.path.join(OUTPUT_DIR,f'{sudoc_id}.zip')

    try:
        with zipfile.ZipFile(output_zip, 'w') as archive:
            for fichier in files_to_zip:
                archive.write(fichier, arcname=fichier.split('/')[-1])
        os.remove(pdf_file)        
        os.remove(xml_file)

    except Exception:
        os.remove(pdf_file)
        write_error_in_logs(log_file, sudoc_id, "Warning : Récuperation du fichier PDF impossible")


def get_hal_zip_from_sudoc_id(sudoc_id, log_file):
    try:
        sudoc_file = get_xml_from_sudoc(sudoc_id)
        
        cond_file = transform_sudoc_to_conditor(sudoc_file)

        tei_hal_file = transform_conditor_to_tei_hal(cond_file)

        # validate_tei_hal(tei_hal_file)

        xml_file = os.path.join(OUTPUT_DIR, f'{sudoc_id}.xml')
        with open(tei_hal_file, 'r') as f_in:
            with open(xml_file, 'w') as f_out:
                f_out.write(f_in.read())

        pdf_file = download_pdf(xml_file)

        create_zip(sudoc_id, xml_file, pdf_file, log_file)
        return

    except Exception as e:
        last_error = str(e)
        write_error_in_logs(log_file, sudoc_id, last_error)
