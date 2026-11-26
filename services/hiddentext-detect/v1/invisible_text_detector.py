#!/usr/bin/env python3
"""
Ce script détecte et extrait le texte invisible dans les fichiers PDF.
Il identifie plusieurs types de texte caché :
  - Texte positionné en dehors des limites de la page
  - Texte de très petite taille (< min_font_size points)
  - Texte de la même couleur que son fond (blanc sur blanc, gris sur gris, etc.)
    
Si aucun fichier n'est spécifié, le script renvoie: `{ "value": "No data to process" }`
"""

import pdfplumber
import sys
from pathlib import Path
from typing import Dict, List, Tuple, Optional
import json


class InvisibleTextDetector:
    """Détecteur de texte invisible dans les PDFs"""
    
    def __init__(self, min_font_size: float = 3.0, color_threshold: float = 0.95,
                 color_tolerance: float = 0.05):
        """
        Initialise le détecteur
        
        Args:
            min_font_size: Taille minimale de police considérée comme visible (en points)
            color_threshold: Seuil pour détecter les couleurs claires (0-1)
            color_tolerance: Écart maximal (0-1) entre la couleur du texte et celle
                             du fond pour considérer qu'elles sont identiques
        """
        self.min_font_size = min_font_size
        self.color_threshold = color_threshold
        self.color_tolerance = color_tolerance
    
    def is_outside_page(self, x0: float, y0: float, page_width: float, page_height: float) -> Tuple[bool, List[str]]:
        """
        Vérifie si un caractère est en dehors des limites de la page
        
        Returns:
            Tuple (est_suspect, liste_de_raisons)
        """
        reasons = []
        is_suspicious = False
        
        if x0 < 0 or y0 < 0:
            is_suspicious = True
            reasons.append("Texte hors des limites de la page")
        
        if x0 > page_width or y0 > page_height:
            is_suspicious = True
            reasons.append("Texte hors des limites de la page")
        
        return is_suspicious, reasons
    
    def is_too_small(self, size: float) -> Tuple[bool, str]:
        """
        Vérifie si un caractère est trop petit
        
        Returns:
            Tuple (est_suspect, raison)
        """
        if size < self.min_font_size:
            return True, f"Taille du texte minuscule ({size:.2f}pt)"
        return False, ""

    def normalize_color(self, col) -> Optional[Tuple[float, float, float]]:
        """Ramène gris / RGB / CMYK au format (r, g, b) entre 0 et 1."""
        if col is None:
            return None

        # Un seul nombre → gris
        if isinstance(col, (int, float)):
            return (col, col, col)

        if len(col) == 1:   # gris
            return (col[0], col[0], col[0])
        if len(col) == 3:   # RGB
            return tuple(col)
        if len(col) == 4:   # CMYK
            c, m, y, k = col
            return ((1 - c) * (1 - k), (1 - m) * (1 - k), (1 - y) * (1 - k))

        return None  # format inconnu

    def get_filled_shapes(self, page) -> List[dict]:
        """Récupère les formes remplies de la page avec leur couleur."""
        shapes = []
        for shape in page.rects + page.curves:
            if not shape.get('fill', True):
                continue

            rgb = self.normalize_color(shape.get('non_stroking_color'))
            if rgb is None:
                continue

            shapes.append({
                'x0': shape['x0'], 'x1': shape['x1'],
                'top': shape['top'], 'bottom': shape['bottom'],
                'rgb': rgb,
            })
        return shapes
    
    def get_background_color(self, char: dict, shapes: List[dict]) -> Tuple[float, float, float]:
        """
        Renvoie la couleur du fond sous le centre du caractère (blanc par défaut).
        ==> Trouver le fond
        """
        cx = (char['x0'] + char['x1']) / 2
        cy = (char['top'] + char['bottom']) / 2

        bg_rgb = (1, 1, 1)  # page blanche par défaut
        for shape in shapes:
            if shape['x0'] <= cx <= shape['x1'] and shape['top'] <= cy <= shape['bottom']:
                bg_rgb = shape['rgb']  # la dernière forme est dessinée au-dessus
        return bg_rgb

    def same_color(self, rgb1, rgb2) -> bool:
        """
        Deux couleurs sont identiques si chaque composante diffère de moins que la tolérance.
        ==> comparer deux couleurs
        """
        return all(abs(a - b) < self.color_tolerance for a, b in zip(rgb1, rgb2))

    def is_char_in_same_color_rect(self, char: dict, shapes: List[dict]) -> Tuple[bool, str]:
        """
        Vérifie si un caractère a la même couleur que son fond.
        ==> 
        """
        char_rgb = self.normalize_color(char.get('non_stroking_color'))
        if char_rgb is None:
            return False, ""

        # Texte blanc de grande taille : probablement un titre visible sur un fond foncé
        is_white = all(v >= 0.99 for v in char_rgb)
        if is_white and char.get('size', 0) > 20:
            return False, ""

        bg_rgb = self.get_background_color(char, shapes)

        if self.same_color(char_rgb, bg_rgb):
            return True, "Texte de la même couleur que son fond"
        return False, ""

    def analyze_character(self, char: dict, page_width: float, page_height: float, shapes: List[dict]) -> Tuple[bool, List[str]]:
        """
        Analyse un caractère pour déterminer s'il est invisible
        
        Args:
            char: Dictionnaire contenant les informations du caractère
            page_width: Largeur de la page
            page_height: Hauteur de la page
            shapes: Formes remplies de la page (voir get_filled_shapes)
        
        Returns:
            Tuple (est_invisible, liste_des_raisons)
        """
        reasons = []
        
        # Extraire les informations du caractère
        x0 = char.get('x0', 0)
        y0 = char.get('y0', 0)
        size = char.get('size', 0)
        
        # Vérifier la position
        outside, outside_reasons = self.is_outside_page(x0, y0, page_width, page_height)
        if outside:
            reasons.extend(outside_reasons)
        
        # Vérifier la taille
        too_small, size_reason = self.is_too_small(size)
        if too_small:
            reasons.append(size_reason)

        # Vérifier la couleur
        in_same_rect, rect_reason = self.is_char_in_same_color_rect(char, shapes)
        if in_same_rect:
            reasons.append(rect_reason)
        
        return len(reasons) > 0, reasons
    
    def detect(self, pdf_path: str) -> Optional[Dict]:
        """
        Détecte le texte invisible dans un PDF
        
        Args:
            pdf_path: Chemin vers le fichier PDF
        
        Returns:
            Dictionnaire contenant les résultats de l'analyse
        """
        results = {
            'total_suspicious_chars': 0,
            'pages': {}
        }
        
        try:
            with pdfplumber.open(pdf_path) as pdf:
                for page_num, page in enumerate(pdf.pages, start=1):
                    page_results = self._analyze_page(page, page_num)
                    
                    if page_results['suspicious_chars'] > 0:
                        results['pages'][page_num] = page_results
                        results['total_suspicious_chars'] += page_results['suspicious_chars']
        
        except Exception as e:
            print(f"Erreur lors de l'analyse du PDF: {e}", file=sys.stderr)
            return None
        
        return results
    
    def _analyze_page(self, page, page_num: int) -> Dict:
        """
        Analyse une page pour détecter le texte invisible
        
        Args:
            page: Objet page de pdfplumber
            page_num: Numéro de la page
        
        Returns:
            Dictionnaire contenant les résultats pour cette page
        """
        page_info = {
            'suspicious_chars': 0,
            'suspicious_spans': [],
            'hidden_text': ''
        }
        
        chars = page.chars
        shapes = self.get_filled_shapes(page)  # calculé une seule fois par page
        current_span = {'text': '', 'reasons': set(), 'positions': [], 'size': 0}

        for char in chars:
            text = char.get('text', '')
            if not text:
                continue
            
            # Vérifier si le caractère est suspect (même pour les espaces)
            is_suspicious, reasons = self.analyze_character(
                char, page.width, page.height, shapes
            )
            
            if is_suspicious:
                # Compter seulement les caractères non-espaces
                if not text.isspace():
                    page_info['suspicious_chars'] += 1
                
                # Mais toujours ajouter le texte (y compris espaces) au texte caché
                page_info['hidden_text'] += text
                
                # Regrouper les caractères adjacents en spans
                if current_span['text'] and set(reasons) == current_span['reasons']:
                    current_span['text'] += text
                    current_span['positions'].append((
                        char.get('x0', 0), char.get('y0', 0),
                        char.get('x1', 0), char.get('y1', 0)
                    ))
                else:
                    if current_span['text']:
                        page_info['suspicious_spans'].append(current_span.copy())
                    
                    current_span = {
                        'text': text,
                        'reasons': set(reasons),
                        'positions': [(
                            char.get('x0', 0), char.get('y0', 0),
                            char.get('x1', 0), char.get('y1', 0)
                        )],
                        'size': char.get('size', 0)
                    }
        
        # Ajouter le dernier span
        if current_span['text']:
            page_info['suspicious_spans'].append(current_span)
        
        return page_info

def result_filter(dict) :
    res = {}
    for key, value in dict["pages"].items() :
        res[key] = []
        for span in value["suspicious_spans"] :
            res[key].append({
                "Page": key,
                "Texte_suspect": span["text"],
                "Motif": list(span["reasons"]),
            })
    res_list = []
    for page_items in res.values():
        for item in page_items:
            if len(item["Texte_suspect"]) > 4:
                res_list.append(item)
    
    return res_list

# Main program
if __name__ == "__main__":

    detector = InvisibleTextDetector(min_font_size=3.0, color_threshold=0.95, color_tolerance=0.05)
    for line in sys.stdin:
        data = json.loads(line)
        if "filename" in data.keys():
            filename = data["filename"]
            print(f"Processing file: {filename}", file=sys.stderr)
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
        # print(data)
        json.dump(data, sys.stdout,ensure_ascii=False)
        sys.stdout.write("\n")