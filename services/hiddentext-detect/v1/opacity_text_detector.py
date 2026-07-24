#!/usr/bin/env python3
"""
Ce script détecte le texte rendu avec une opacité (alpha) faible ou nulle et les textes cachés derrière des images.

Types de texte détectés ici :
  - Texte avec alpha < seuil (quasi ou totalement transparent)
  - Texte noir sur fond blanc caché derrière une image (si l'image est opaque et recouvre le texte)
"""

import fitz  # PyMuPDF
import sys
import json
from typing import Dict, List, Optional


class OpacityTextDetector:
    def __init__(self, alpha_threshold: int = 25):
        """
        alpha_threshold: Seuil en dessous duquel un span est considéré comme invisible.
        Valeur entre 0 (transparent) et 255 (opaque). Défaut : 25 (~10% d'opacité).
        """
        self.alpha_threshold = alpha_threshold

    def is_transparent(self, alpha: Optional[float]) -> bool:
        """
        Vérifie si une valeur d'opacité est en dessous du seuil considéré comme invisible.
        """
        if alpha is None:
            return False
        return alpha < self.alpha_threshold

    # IMAGE 
    def _get_opaque_images(self, page) -> List[Dict]:
        """
        Récupère les images opaques d'une page avec leurs bbox (4 coordonnées de l'image).
        Une image est opaque si son alpha est 255 ou non défini (par défaut opaque).
        """
        opaque_images = []
        try:
            # Récupère toutes les images de la page
            image_list = page.get_images(full=True)
            for img in image_list:
                xref = img[0]
                # Récupère les infos de l'image (y compris bbox et alpha)
                image_info = page.get_image_info(xref)
                for info in image_info:
                    print(f"Image info: {info}", file=sys.stderr)  # Debug: affiche les infos de l'image
                    bbox = info["bbox"]
                    alpha = info.get("alpha", 255)  # Par défaut opaque si alpha non défini
                    if alpha == 255:  # Image opaque
                        opaque_images.append({"bbox": bbox, "alpha": alpha})
        except Exception as e:
            print(f"Erreur dans _get_opaque_images: {e}", file=sys.stderr)
            pass
        return opaque_images

    def _is_covered_by_opaque_image(self, text_bbox: List[float], text_color: int, opaque_images: List[Dict]) -> bool:
        """
        Vérifie si un texte (définis par son bbox) est complètement recouvert par une image opaque.
        """
        if text_color != 0:  # Si le texte n'est pas noir, il sera trouvé par d'autres conditions, donc on ne le considère pas ici.
            return False

        for img in opaque_images:

            # Récupère les coordonnées de la bbox du texte et de l'image
            img_bbox = img["bbox"]
            text_x0, text_y0, text_x1, text_y1 = text_bbox
            img_x0, img_y0, img_x1, img_y1 = img_bbox

            # Le texte commence après ou au même endroit que l'image (x0)
            is_x0_inside = text_x0 >= img_x0
            # Le texte se termine avant ou au même endroit que l'image (x1)
            is_x1_inside = text_x1 <= img_x1

            # Le texte commence en dessous ou au même endroit que l'image (y0)
            is_y0_inside = text_y0 >= img_y0
            # Le texte se termine au-dessus ou au même endroit que l'image (y1)
            is_y1_inside = text_y1 <= img_y1

            # Si vrai, le texte est complètement recouvert
            if is_x0_inside and is_x1_inside and is_y0_inside and is_y1_inside:
                return True

        return False


    def detect(self, pdf_path: str) -> Optional[Dict]:
        results = {
            'total_suspicious_spans': 0,
            'pages': {}
        }

        try:
            doc = fitz.open(pdf_path)
        except Exception as e:
            print(f"Erreur lors de l'ouverture du PDF (PyMuPDF): {e}", file=sys.stderr)
            return None

        try:
            for page_num, page in enumerate(doc, start=1):
                page_results = self._analyze_page(page)
                if page_results['suspicious_spans']:
                    results['pages'][page_num] = page_results
                    results['total_suspicious_spans'] += len(page_results['suspicious_spans'])
        except Exception as e:
            print(f"Erreur lors de l'analyse du PDF (PyMuPDF): {e}", file=sys.stderr)
            return None
        finally:
            doc.close()

        return results

    def _analyze_page(self, page) -> Dict:
        """
        Analyse une page pour détecter :
        1. Le texte à opacité réduite.
        2. Le texte noir caché sous une image opaque.
        """
        page_info = {
            'suspicious_spans': [],
            'hidden_text': ''
        }

        try:
            text_dict = page.get_text("dict")
            opaque_images = self._get_opaque_images(page)
        except Exception:
            return page_info

        for block in text_dict.get("blocks", []):
            if "lines" not in block:
                continue  # bloc image ou autre, pas du texte

            for line in block["lines"]:
                for span in line.get("spans", []):
                    text = span.get("text", "")
                    if not text:
                        continue

                    # 'alpha' peut être absent selon la version de PyMuPDF / le PDF
                    alpha = span.get("alpha", 1.0)
                    color = span.get("color", 0)  # couleur du texte (0 = noir)
                    bbox = span.get("bbox", []) # position

                     # 1. Détection de texte transparent (opacité)
                    if self.is_transparent(alpha):
                        if not text.isspace():
                            page_info['hidden_text'] += text
                        page_info['suspicious_spans'].append({
                            'text': text,
                            'reasons': {f"Opacité trop faible ({alpha})"},
                            'size': span.get('size', 0),
                            'color': color,
                            'bbox': bbox,
                        })

                     # 2. Détection de texte noir caché sous une image opaque
                    if bbox:  # On vérifie que bbox existe
                        if self._is_covered_by_opaque_image(bbox, color, opaque_images):
                            if not text.isspace():
                                page_info['hidden_text'] += text
                            page_info['suspicious_spans'].append({
                                'text': text,
                                'reasons': {"Texte noir caché sous une image opaque"},
                                'size': span.get('size', 0),
                                'color': color,
                                'bbox': bbox,
                            })

        return page_info


def result_filter(detection_result: Dict) -> List[Dict]:
    res_list = []
    for page_num, page_data in detection_result.get("pages", {}).items():
        for span in page_data["suspicious_spans"]:
            res_list.append({
                "Page": page_num,
                "Texte_suspect": span["text"],
                "Motif": list(span["reasons"]),
            })
    return res_list

if __name__ == "__main__":

    detector = OpacityTextDetector(alpha_threshold=25.0)
    for line in sys.stdin:
        data = json.loads(line)
        if "filename" in data.keys():
            filename = data["filename"]
            print(f"Processing file (opacity): {filename}", file=sys.stderr)
            results = detector.detect(filename)
            if results is None:
                data["value"] = "Erreur lors du traitement du PDF"
            else:
                filtered_results = result_filter(results)
                if not filtered_results:
                    data["value"] = [{"Page": "N/A", "Texte_suspect": "Aucun texte suspect détecté", "Motif": []}]
                else:
                    data["value"] = filtered_results
        else:
            data["value"] = "Aucune donnée à traiter"
        json.dump(data, sys.stdout, ensure_ascii=False)
        sys.stdout.write("\n")