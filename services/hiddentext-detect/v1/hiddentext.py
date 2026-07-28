#!/usr/bin/env python3
"""
Cmbine le détecteur pdfplumber (invisible_text_detector.py)
et le détecteur d'opacité PyMuPDF (opacity_text_detector.py).
"""

import sys
import json

# --- Imports des deux détecteurs existants, sans aucune modification ---
from invisible_text_detector import InvisibleTextDetector, result_filter as pdfplumber_result_filter
from opacity_text_detector import OpacityTextDetector, result_filter as opacity_result_filter


def analyze_file(filename: str):
    combined = []

    # 1. Détecteur pdfplumber (positionnement hors page, texte minuscule, blanc-sur-blanc)
    pdfplumber_detector = InvisibleTextDetector(min_font_size=2.0, color_threshold=0.95)
    pdfplumber_results = pdfplumber_detector.detect(filename)
    if pdfplumber_results is not None:
        for item in pdfplumber_result_filter(pdfplumber_results):
            combined.append(item)

    # 2. Détecteur d'opacité PyMuPDF (opacité, texte noir sous image)
    opacity_detector = OpacityTextDetector(alpha_threshold=0.1)
    opacity_results = opacity_detector.detect(filename)
    if opacity_results is not None:
        for item in opacity_result_filter(opacity_results):
            combined.append(item)

    return combined


if __name__ == "__main__":
    for line in sys.stdin:
        data = json.loads(line)
        if "filename" in data.keys():
            filename = data["filename"]
            print(f"Processing file (combined): {filename}", file=sys.stderr)
            try:
                results = analyze_file(filename)
            except Exception as e:
                print(f"Erreur lors du traitement combiné: {e}", file=sys.stderr)
                results = None

            if results is None:
                data["value"] = "Erreur lors du traitement du PDF"
            elif not results:
                data["value"] = [{"Page": "N/A", "Texte_suspect": "Aucun texte invisible détecté", "Motif": []}]
            else:
                data["value"] = results
        else:
            data["value"] = "Aucune donnée à traiter"

        json.dump(data, sys.stdout, ensure_ascii=False)
        sys.stdout.write("\n")