#!/usr/bin/env python3
"""
Détecteur de Texte Invisible dans les PDFs
===========================================

Ce script détecte et extrait le texte invisible dans les fichiers PDF.
Il identifie plusieurs types de texte caché :
  - Texte positionné en dehors des limites de la page
  - Texte de très petite taille (< 2 points)
  - Texte blanc ou transparent
    
Si aucun fichier n'est spécifié, le script renvoie: `{ "value": "No data to process" }`
"""

import pdfplumber
import sys
from pathlib import Path
from typing import Dict, List, Tuple, Optional
import json


class InvisibleTextDetector:
    """Détecteur de texte invisible dans les PDFs"""
    
    def __init__(self, min_font_size: float = 2.0, color_threshold: float = 0.95):
        """
        Initialise le détecteur
        
        Args:
            min_font_size: Taille minimale de police considérée comme visible (en points)
            color_threshold: Seuil pour détecter les couleurs claires (0-1)
        """
        self.min_font_size = min_font_size
        self.color_threshold = color_threshold
    
    def is_outside_page(self, x0: float, y0: float, page_width: float, page_height: float) -> Tuple[bool, List[str]]:
        # voir si le texte est en blanc ou transparent
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


    def is_char_in_same_color_rect(self, char: dict, page) -> Tuple[bool, str]:
        
        # Récupération de la couleur du caractère
        char_color = char.get('non_stroking_color')
        if char_color is None:
            return False, ""

        def normalize_color(col):
            # Normalisation : toutes les couleurs sont ramenées au format [R, G, B]
            if isinstance(col, (list, tuple)):
                if len(col) == 1: return [col[0]]*3
                if len(col) == 3: return list(col)
            return [col, col, col] if isinstance(col, (int, float)) else None

        # Normalisation de la couleur du caractère
        char_rgb = normalize_color(char_color)
        if char_rgb is None:
            return False, ""
        
        def is_white(rgb) -> bool:
            return all(v >= 0.99 for v in rgb)

        # On vérifie si la couleur (normalisée) du caractère est blanche ([1, 1, 1])
        if not is_white(char_rgb):
            return False, ""

        # Texte blanc de grande taille → probablement visible sur fond coloré/image
        if char.get('size', 0) > 20:
            return False, ""

         # Coordonnées du caractère pour vérifier sa position dans les rects
        char_x0, char_y0, char_x1, char_y1 = char.get('x0'), char.get('y0'), char.get('x1'), char.get('y1')

         # Récupération de toutes les shapes de la page
        shapes = list(page.rects)
        for curve in page.curves:
            if curve.get('non_stroking_color') is not None:
                shapes.append(curve)

        # Parcours de tous les rects/shapes de la page pour vérifier si le caractère blanc est contenu dans une forme colorée non-blanche
        for shape in shapes:
            shape_x0, shape_y0, shape_x1, shape_y1 = shape.get('x0'), shape.get('y0'), shape.get('x1'), shape.get('y1')
            
            # Vérification que le caractère est bien à l'intérieur du rect
            if (shape_x0 <= char_x0 and shape_x1 >= char_x1 and shape_y0 <= char_y0 and shape_y1 >= char_y1):
                shape_rgb = normalize_color(shape.get('non_stroking_color'))
                if shape_rgb and not is_white(shape_rgb):
                    return False, ""

        # Texte blanc, hors rect coloré → fond blanc par défaut → invisible
        return True, "Texte blanc sur fond blanc (masqué)"

    def analyze_character(self, char: dict, page_width: float, page_height: float, page) -> Tuple[bool, List[str]]:
        """
        Analyse un caractère pour déterminer s'il est invisible
        
        Args:
            char: Dictionnaire contenant les informations du caractère
            page_width: Largeur de la page
            page_height: Hauteur de la page
        
        Returns:
            Tuple (est_invisible, liste_des_raisons)
        """
        reasons = []
        
        # Extraire les informations du caractère
        x0 = char.get('x0', 0)
        y0 = char.get('y0', 0)
        x1 = char.get('x1', 0)
        y1 = char.get('y1', 0)
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
        in_same_rect, rect_reason = self.is_char_in_same_color_rect(char, page)
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
        current_span = {'text': '', 'reasons': set(), 'positions': [], 'size': 0}

        for char in chars:
            text = char.get('text', '')
            if not text:
                continue
            
            # Vérifier si le caractère est suspect (même pour les espaces)
            is_suspicious, reasons = self.analyze_character(
                char, page.width, page.height, page
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
                "Texte suspect": span["text"],
                "Motif": list(span["reasons"]),
            })
    return res


# Main program
if __name__ == "__main__":

    detector = InvisibleTextDetector(min_font_size=2.0, color_threshold=0.95)
    for line in sys.stdin:
        data = json.loads(line)
        if "filename" in data.keys():
            filename = data["filename"]
            print(f"Processing file: {filename}", file=sys.stderr)
            results = detector.detect(filename)
            if results is None:
                data["value"] = "Error processing file"
            else:
                data["value"] = result_filter(results)
        else:
            data["value"] = "No data to process"
        # print(data)
        json.dump(data, sys.stdout,ensure_ascii=False)
        sys.stdout.write("\n")