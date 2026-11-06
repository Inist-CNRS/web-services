#!/usr/bin/env python3
"""
utils.py -- moteur de détection de duplication d'image + helpers du web service.

Objectif : détecter, à l'intérieur d'UNE MÊME image, des régions identiques
(copier-coller), même après rotation, changement d'échelle ou miroir.

Organisation du fichier
-----------------------
1. Configuration (`Config`) : tous les seuils réglables.
2. Structures de données : `BoundingBox`, `DuplicationGroup`, `ImageResult`.
3. Pré-filtrage : masque des zones "photographiques", détection du texte.
4. `DuplicationDetector` : le détecteur lui-même.
5. Annotation des images et rapport HTML.
6. Lecture des entrées (PDF ou image) et pipeline complet.
7. Helpers du web service : lecture de la requête (pid, id, octets) et
   sauvegarde des résultats dans /tmp/retrieve/<pid>/.

Principe du détecteur
---------------------------------------------------------
1. Réduction de l'image pour borner le temps de calcul.
2. Masque d'éligibilité : on ne garde que les zones texturées (photos),
   pas les aplats blancs ni les fonds unis.
3. Points d'intérêt SIFT (variante RootSIFT).
4. Appariement g2NN : retrouve les points qui ont 1, 2, 3... copies.
   Une seconde passe compare l'image à son reflet pour les copies en MIROIR.
5. RANSAC séquentiel avec un modèle de similarité (rotation + échelle +
   translation) : regroupe les paires de points qui obéissent à la même
   transformation.
6. Vérification pixel : on déforme la région source avec la transformation
   estimée et on mesure sa corrélation avec la région copie (NCC). Le texte
   répété (étiquettes, axes) est écarté à cette étape.
7. Dédoublonnage (A->B et B->A sont la même détection).
"""

from __future__ import annotations

import base64
import hashlib
import json
import logging
import os
import re
import time
from dataclasses import dataclass, field
from io import BytesIO
from pathlib import Path
from typing import Optional

import cv2
try:  # PyMuPDF >= 1.24.3 : 'import fitz' affiche un avertissement sur STDOUT
    import pymupdf as fitz
except ImportError:  # anciennes versions
    import fitz  # type: ignore
import numpy as np
from PIL import Image, ImageOps

log = logging.getLogger("fraud_detector")

# Dossier racine où sont déposés les résultats : /tmp/retrieve/<pid>/<id>.{json,html,png}
RETRIEVE_DIR = "/tmp/retrieve"


# ===========================================================================
# 1. Configuration
# ===========================================================================

@dataclass
class Config:
    """Tous les seuils du détecteur. Les valeurs par défaut ont été calibrées
    sur des figures d'articles scientifiques (JPEG, 1000 à 2500 px de large)."""

    # --- Pré-filtre : quelles images analyser -------------------------------
    min_embedded_dim: int = 150       # côté minimal (px) d'une image à analyser
    max_aspect: float = 8.0           # rapport L/H maxi (au-delà : bandeau, barre d'échelle)
    min_eligible_fraction: float = 0.02   # part minimale de zones texturées dans l'image

    # --- Réduction avant analyse -------------------------------------------
    max_side: int = 2000              # plus grand côté après réduction (px)

    # --- Masque d'éligibilité (zones "photographiques") ---------------------
    white_level: int = 250            # gris >= ce niveau = "blanc pur" (fond de figure)
    patch: int = 41                   # taille (px) du voisinage utilisé pour le masque
    flat_range: int = 2               # voisinage 5x5 d'écart <= 2 niveaux = aplat
    flat_min_level: int = 60          # les aplats SOMBRES (fond noir de fluo) sont conservés
    max_white_frac: float = 0.5       # un voisinage > 50 % blanc/aplat est exclu
    min_patch_std: float = 6.0        # un voisinage trop uniforme est exclu

    # --- SIFT ----------------------------------------------------------------
    sift_contrast_threshold: float = 0.02   # bas = plus de points (utile pour les blots lisses)
    sift_edge_threshold: float = 10.0
    sift_sigma: float = 1.6
    max_keypoints: int = 12000        # on garde les N points les plus forts

    # --- Appariement g2NN ----------------------------------------------------
    knn: int = 6                      # nb de voisins examinés par point
    g2nn_ratio: float = 0.6           # seuil du rapport de distances successives
    min_pair_dist: float = 16.0       # écart spatial minimal d'une paire (px, image réduite)

    # --- RANSAC (modèle de similarité) ----------------------------------------
    ransac_thr: float = 3.0           # erreur de reprojection tolérée (px)
    ransac_iters: int = 5000
    min_inliers: int = 13             # paires concordantes minimales pour retenir un groupe
    max_clusters: int = 12            # nb maximal de groupes cherchés par passe
    scale_range: tuple = (0.5, 2.0)   # facteurs d'échelle acceptés

    # --- Vérification pixel -------------------------------------------------
    mask_dilate: int = 12             # dilatation (px) de l'enveloppe des points
    min_region_px: int = 1200         # aire minimale d'une région dupliquée (px²)
    min_ncc: float = 0.85             # corrélation minimale source/copie
    max_overlap: float = 0.30         # recouvrement maximal source/copie
    min_region_std: float = 8.0       # écart-type minimal des gris dans la région
    max_white_in_region: float = 0.5  # part maximale de blanc pur dans la région
    nearwhite_level: int = 235        # "presque blanc"
    max_nearwhite_in_region: float = 0.6   # part maximale de presque-blanc

    # --- Rejet du texte et des schémas ----------------------------------------
    # Le texte répété (étiquettes, axes, légendes) est la principale source de
    # faux positifs. Deux détecteurs complémentaires :
    #  (a) traits fins sur fond uni ;  (b) ligne de glyphes alignés.
    flat_pixel_range: int = 3         # voisinage 3x3 "uni" si max-min <= 3
    max_flat_fraction: float = 0.05   # au-delà : le fond de la région est "uni"
    ink_level: int = 140              # pixel d'"encre" = gris < ink_level
    ink_open_kernel: int = 5          # un trait plus fin que ça disparaît à l'ouverture
    min_thin_ink_ratio: float = 0.8   # part d'encre en traits fins => texte
    text_min_components: int = 4      # ligne de texte : au moins 4 glyphes alignés
    text_max_align: float = 1.0       # écart-type / taille médiane des glyphes

    # --- Miroir ----------------------------------------------------------------
    detect_mirror: bool = True        # chercher aussi les copies retournées

    # --- Annotation des images ---------------------------------------------------
    annotation_thickness: int = 3     # épaisseur minimale des contours (px)
    annotation_alpha: float = 0.30    # opacité du remplissage coloré

    # --- Rapport HTML (taille maîtrisée : un rapport trop lourd se fait tronquer) -
    report_max_width: int = 1100      # largeur des images suspectes (originale + annotée)
    report_thumb_width: int = 640     # largeur des vignettes des images sans détection
    report_jpeg_quality: int = 78


# ===========================================================================
# 2. Structures de données
# ===========================================================================

@dataclass
class BoundingBox:
    """Rectangle (x, y) = coin haut-gauche, (w, h) = largeur et hauteur, en px."""
    x: int
    y: int
    w: int
    h: int

    @property
    def x2(self) -> int:
        """Abscisse du bord droit."""
        return self.x + self.w

    @property
    def y2(self) -> int:
        """Ordonnée du bord bas."""
        return self.y + self.h

    @property
    def area(self) -> int:
        """Aire du rectangle (px²)."""
        return self.w * self.h

    def iou(self, o: "BoundingBox") -> float:
        """Intersection sur union (0 = disjoints, 1 = identiques) avec un autre rectangle."""
        ix1, iy1 = max(self.x, o.x), max(self.y, o.y)
        ix2, iy2 = min(self.x2, o.x2), min(self.y2, o.y2)
        inter = max(0, ix2 - ix1) * max(0, iy2 - iy1)
        union = self.area + o.area - inter
        return inter / union if union > 0 else 0.0


@dataclass
class DuplicationGroup:
    """Une détection : une région source et sa copie, avec la transformation."""
    group_id: int
    boxes: list                     # [BoundingBox source, BoundingBox copie]
    match_count: int                # nb de paires de points concordantes (inliers RANSAC)
    confidence: float               # score 0..100 (dépend de la NCC et du nb d'inliers)
    polygons: list = field(default_factory=list)   # enveloppes convexes (coord. image d'origine)
    ncc: float = 0.0                # corrélation entre la source déformée et la copie
    angle_deg: float = 0.0          # rotation source -> copie
    scale: float = 1.0              # échelle source -> copie
    mirrored: bool = False          # True si la copie est retournée (miroir)


@dataclass
class ImageResult:
    """Résultat de l'analyse d'une image (alimente le rapport et le JSON de sortie)."""
    image_id: int
    source: str                     # étiquette de l'image (ex. "page3_img1")
    width: int
    height: int
    groups: list = field(default_factory=list)      # list[DuplicationGroup]
    original_b64: str = ""          # image d'origine réduite, en JPEG base64
    annotated_b64: str = ""         # image annotée réduite (si détection)
    # Image annotée pleine résolution (si détection), gardée en mémoire pour construire
    # l'image de sortie du document ; non affichée dans le repr pour ne pas noyer les logs.
    annotated_img: Optional[np.ndarray] = field(default=None, repr=False)
    processing_time: float = 0.0
    skip_reason: Optional[str] = None      # renseigné si l'image n'a pas été analysée
    error: Optional[str] = None            # renseigné si l'analyse a échoué

    @property
    def suspicious(self) -> bool:
        """True si au moins une duplication a été détectée."""
        return len(self.groups) > 0


# ===========================================================================
# 3. Pré-filtrage et détection du texte
# ===========================================================================

def _eligibility_mask(gray: np.ndarray, cfg: Config) -> np.ndarray:
    """Carte booléenne des pixels "photographiques" (où chercher des points d'intérêt).

    Un pixel est éligible si son voisinage (cfg.patch x cfg.patch) est texturé et
    n'est pas majoritairement du blanc pur ou un aplat clair. Cela exclut le fond
    des figures, les axes, les légendes et les histogrammes vectoriels, qui
    produisent sinon des faux positifs.
    """
    g = gray.astype(np.float32)
    k = (cfg.patch, cfg.patch)
    # Aplat = voisinage 5x5 quasi constant (max - min <= flat_range). Les aplats
    # sombres sont conservés : un fond noir de fluorescence reste analysable.
    k5 = np.ones((5, 5), np.uint8)
    flat = (cv2.dilate(gray, k5).astype(np.int16) - cv2.erode(gray, k5).astype(np.int16)) <= cfg.flat_range
    flat_bright = flat & (gray >= cfg.flat_min_level)
    # Part de "blanc ou aplat clair" dans le voisinage de chaque pixel
    white_frac = cv2.blur(((gray >= cfg.white_level) | flat_bright).astype(np.float32), k)
    # Écart-type local des gris (moyenne des carrés - carré de la moyenne)
    m = cv2.blur(g, k)
    m2 = cv2.blur(g * g, k)
    std = np.sqrt(np.maximum(m2 - m * m, 0))
    return (white_frac < cfg.max_white_frac) & (std > cfg.min_patch_std)


def _thin_ink_ratio(gray: np.ndarray, sel: np.ndarray, level: int, k: int) -> float:
    """Part de l'« encre » de la région qui est faite de traits fins.

    L'encre = pixels plus sombres que `level`. On applique une ouverture
    morphologique k x k : les traits plus fins que k px disparaissent. Retourne
    la part d'encre supprimée (0 = formes épaisses comme une bande de blot,
    1 = uniquement des traits fins comme du texte).
    """
    ink = (gray < level)
    n_ink = int((ink & sel).sum())
    if n_ink < 30:                       # trop peu d'encre pour conclure
        return 0.0
    opened = cv2.morphologyEx(ink.astype(np.uint8), cv2.MORPH_OPEN, np.ones((k, k), np.uint8)) > 0
    return 1.0 - float((opened & sel).sum()) / n_ink


def _text_line_components(gray: np.ndarray, mask: np.ndarray, level: int) -> tuple:
    """Cherche une « ligne de texte » dans la région.

    On extrait les composantes connexes sombres de taille « glyphe » (4 à 90 px).
    Si elles sont assez nombreuses et que leurs centres sont alignés
    (horizontalement, ou verticalement pour du texte pivoté à 90°), c'est du texte.
    Retourne (nb_composantes_retenues, ratio_d_alignement). Le ratio est
    l'écart-type des centres rapporté à la taille médiane des glyphes : petit
    (< 1) = aligné = texte ; grand = dispersé (cellules, blots, photo).
    """
    ink = ((gray < level) & (mask > 0)).astype(np.uint8)
    n, _, st, cen = cv2.connectedComponentsWithStats(ink, connectivity=8)
    comps = [(st[i, 2], st[i, 3], cen[i, 0], cen[i, 1]) for i in range(1, n)
             if 12 <= st[i, 4] <= 1500 and 4 <= st[i, 2] <= 90 and 4 <= st[i, 3] <= 90]
    if len(comps) < 4:
        return len(comps), 9.0
    w = np.array([c[0] for c in comps], float)
    h = np.array([c[1] for c in comps], float)
    cx = np.array([c[2] for c in comps])
    cy = np.array([c[3] for c in comps])
    horiz = cy.std() / max(np.median(h), 1.0)    # ligne horizontale : centres y alignés
    vert = cx.std() / max(np.median(w), 1.0)     # ligne verticale   : centres x alignés
    return len(comps), float(min(horiz, vert))


def _should_skip(img_bgr: np.ndarray, cfg: Config) -> Optional[str]:
    """Décide si une image ne vaut pas la peine d'être analysée.

    Retourne None si l'image doit être analysée, sinon la raison (texte) du
    rejet : image trop petite, bandeau trop allongé, ou aucune zone texturée.
    """
    h, w = img_bgr.shape[:2]
    if w < cfg.min_embedded_dim or h < cfg.min_embedded_dim:
        return f"too small ({w}×{h})"
    aspect = w / h
    if aspect > cfg.max_aspect or aspect < 1 / cfg.max_aspect:
        return f"extreme aspect ratio ({aspect:.2f})"
    # Test de contenu sur une version réduite (rapide)
    gray = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2GRAY)
    s = min(1.0, 800 / max(h, w))
    if s < 1:
        gray = cv2.resize(gray, None, fx=s, fy=s, interpolation=cv2.INTER_AREA)
    frac = float(_eligibility_mask(gray, cfg).mean())
    if frac < cfg.min_eligible_fraction:
        return f"no textured/photographic content ({frac:.1%} usable)"
    return None


# ===========================================================================
# 4. Détecteur
# ===========================================================================

class DuplicationDetector:
    """Détecte les régions dupliquées dans une image (voir le docstring du module).

    Usage :
        detector = DuplicationDetector(Config())
        groups = detector.detect(image_bgr)     # list[DuplicationGroup]
    """

    def __init__(self, cfg: Config):
        """Prépare SIFT et le moteur d'appariement (FLANN, arbres kd) une seule fois."""
        self.cfg = cfg
        self._sift = cv2.SIFT_create(
            nfeatures=0,
            contrastThreshold=cfg.sift_contrast_threshold,
            edgeThreshold=cfg.sift_edge_threshold,
            sigma=cfg.sift_sigma,
        )
        self._flann = cv2.FlannBasedMatcher(dict(algorithm=1, trees=4), dict(checks=64))

    # ------------------------------------------------------------------
    # Point d'entrée
    # ------------------------------------------------------------------
    def detect(self, image_bgr: np.ndarray) -> list:
        """Analyse une image BGR et retourne la liste des duplications trouvées.

        Étapes : réduction -> masque d'éligibilité -> points SIFT -> paires g2NN
        -> RANSAC (mode normal, puis mode miroir) -> vérification pixel.
        Les coordonnées retournées sont celles de l'image d'ORIGINE (pas réduite).
        """
        cfg = self.cfg
        H0, W0 = image_bgr.shape[:2]
        # 1. Réduction (facteur s <= 1) pour borner le temps de calcul
        s = min(1.0, cfg.max_side / max(H0, W0))
        img = cv2.resize(image_bgr, None, fx=s, fy=s, interpolation=cv2.INTER_AREA) if s < 1 else image_bgr
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        h, w = gray.shape
        blur = cv2.GaussianBlur(gray, (0, 0), 1.0)
        # Version passe-haut (différence de gaussiennes) : la corrélation finale
        # porte sur le détail fin, pas sur les dégradés lents (ex. barre de couleurs)
        hp = blur.astype(np.float32) - cv2.GaussianBlur(gray, (0, 0), 4.0).astype(np.float32)

        # 2. Zones où chercher, puis points d'intérêt
        elig = _eligibility_mask(gray, cfg)
        pts, desc = self._features(gray, elig)
        log.debug("  %d keypoints éligibles", len(pts))
        if len(pts) < cfg.min_inliers * 2:
            return []

        cands = []   # groupes candidats (avant vérification pixel)

        # 3a. Mode normal : l'image est comparée à elle-même
        pairs = self._self_pairs(pts, desc)
        cands += self._ransac_clusters(pts, pts, pairs, mirrored=False, w=w)

        # 3b. Mode miroir : l'image est comparée à son reflet horizontal
        if cfg.detect_mirror:
            gray_f = np.ascontiguousarray(gray[:, ::-1])
            pts_f, desc_f = self._features(gray_f, np.ascontiguousarray(elig[:, ::-1]))
            if len(pts_f) >= cfg.min_inliers * 2:
                pairs_m = self._cross_pairs(desc, desc_f, pts, pts_f, w)
                cands += self._ransac_clusters(pts, pts_f, pairs_m, mirrored=True, w=w)

        # 4. Vérification pixel, rejet du texte, dédoublonnage
        return self._verify_and_dedupe(cands, blur, hp, h, w, s, gray)

    # ------------------------------------------------------------------
    # Points d'intérêt
    # ------------------------------------------------------------------
    def _features(self, gray: np.ndarray, elig: np.ndarray):
        """Calcule les points SIFT (dans la zone éligible) et leurs descripteurs RootSIFT.

        Retourne (points (N,2), descripteurs (N,128)). On ne garde que les
        cfg.max_keypoints points les plus forts. RootSIFT = racine carrée du
        descripteur normalisé en L1 : plus robuste que SIFT pour l'appariement.
        """
        cfg = self.cfg
        mask = elig.astype(np.uint8) * 255
        kps, desc = self._sift.detectAndCompute(gray, mask)
        if desc is None or len(kps) == 0:
            return np.zeros((0, 2), np.float32), np.zeros((0, 128), np.float32)
        if len(kps) > cfg.max_keypoints:
            order = np.argsort([-k.response for k in kps])[: cfg.max_keypoints]
            kps = [kps[i] for i in order]
            desc = desc[order]
        desc = desc.astype(np.float32)
        desc /= (desc.sum(axis=1, keepdims=True) + 1e-7)
        desc = np.sqrt(desc)
        pts = np.array([k.pt for k in kps], dtype=np.float32)
        return pts, desc

    # ------------------------------------------------------------------
    # Appariement
    # ------------------------------------------------------------------
    def _g2nn(self, dist_row, idx_row) -> list:
        """Sélection g2NN des voisins retenus pour UN point.

        Le ratio de Lowe classique (1er voisin / 2e voisin) échoue dès qu'une
        région existe en plus de 2 exemplaires (le 2e voisin est alors aussi une
        copie). g2NN teste les ratios successifs d_i / d_(i+1) et garde les
        voisins tant que le ratio reste sous le seuil : tous les exemplaires
        d'une même région sont ainsi retenus.
        """
        kept = []
        for j in range(len(dist_row) - 1):
            if dist_row[j + 1] <= 1e-9:
                break
            if dist_row[j] / dist_row[j + 1] < self.cfg.g2nn_ratio:
                kept.append(idx_row[j])
            else:
                break
        return kept

    def _self_pairs(self, pts: np.ndarray, desc: np.ndarray) -> list:
        """Paires de points similaires DANS la même image (mode normal).

        Chaque point est comparé aux autres (lui-même exclu) ; les paires
        trop proches spatialement sont ignorées (un point et son voisin immédiat
        se ressemblent naturellement). Chaque paire est ajoutée dans les deux sens.
        """
        cfg = self.cfg
        k = cfg.knn + 1                      # +1 : le point lui-même est son 1er voisin
        if len(desc) <= k:
            return []
        knn = self._flann.knnMatch(desc, desc, k=k)
        pairs = set()
        for qi, ms in enumerate(knn):
            ms = [m for m in ms if m.trainIdx != qi]     # on retire le point lui-même
            if len(ms) < 2:
                continue
            d = [m.distance for m in ms]
            ix = [m.trainIdx for m in ms]
            for ti in self._g2nn(d, ix):
                if np.hypot(*(pts[qi] - pts[ti])) > cfg.min_pair_dist:
                    pairs.add((qi, ti))
                    pairs.add((ti, qi))
        return list(pairs)

    def _cross_pairs(self, desc: np.ndarray, desc_f: np.ndarray,
                     pts: np.ndarray, pts_f: np.ndarray, w: int) -> list:
        """Paires de points entre l'image et son REFLET horizontal (mode miroir).

        Un point de l'image qui ressemble à un point du reflet correspond à une
        région dont une copie existe en miroir. `w` = largeur de l'image, pour
        convertir les points du reflet en coordonnées de l'image d'origine
        (x_orig = w - 1 - x_reflet) et vérifier qu'ils sont assez éloignés.
        """
        cfg = self.cfg
        k = cfg.knn
        if len(desc_f) <= k:
            return []
        knn = self._flann.knnMatch(desc, desc_f, k=k)
        pairs = set()
        for qi, ms in enumerate(knn):
            if len(ms) < 2:
                continue
            d = [m.distance for m in ms]
            ix = [m.trainIdx for m in ms]
            for ti in self._g2nn(d, ix):
                x_orig = (w - 1) - pts_f[ti][0]
                if np.hypot(pts[qi][0] - x_orig, pts[qi][1] - pts_f[ti][1]) > cfg.min_pair_dist:
                    pairs.add((qi, ti))
        return list(pairs)

    # ------------------------------------------------------------------
    # RANSAC séquentiel
    # ------------------------------------------------------------------
    def _ransac_clusters(self, pts_a, pts_b, pairs, mirrored: bool, w: int) -> list:
        """Regroupe les paires de points en « clusters » obéissant à une même transformation.

        Boucle : RANSAC ajuste une similarité (rotation + échelle + translation)
        sur les paires restantes ; les paires concordantes (inliers) forment un
        cluster, puis sont retirées ; on recommence jusqu'à épuisement.
        Chaque cluster = une région source copiée vers une autre place.

        pts_a / pts_b : points source / destination ; pairs : indices (a, b).
        En mode miroir, pts_b vit dans l'image retournée : la transformation
        finale (source -> copie dans l'image d'origine) est recomposée avec le
        retournement. Retourne une liste de dicts (src, dst, M3, n, scale, angle...).
        """
        cfg = self.cfg
        if len(pairs) < cfg.min_inliers:
            return []
        P = np.float32([pts_a[a] for a, _ in pairs])
        Q = np.float32([pts_b[b] for _, b in pairs])
        alive = np.ones(len(pairs), bool)          # paires pas encore attribuées à un cluster
        # En mode normal, A->B et B->A décrivent la même copie : on retire l'inverse
        lookup = {(a, b): i for i, (a, b) in enumerate(pairs)} if not mirrored else None
        out = []
        for _ in range(cfg.max_clusters):
            idx = np.flatnonzero(alive)
            if len(idx) < cfg.min_inliers:
                break
            M, inl = cv2.estimateAffinePartial2D(
                P[idx], Q[idx], method=cv2.RANSAC,
                ransacReprojThreshold=cfg.ransac_thr,
                maxIters=cfg.ransac_iters, confidence=0.995, refineIters=10)
            if M is None or inl is None:
                break
            sel = idx[inl.ravel().astype(bool)]
            if len(sel) < cfg.min_inliers:
                break
            alive[sel] = False
            if lookup is not None:
                for i in sel:
                    a, b = pairs[i]
                    j = lookup.get((b, a))
                    if j is not None:
                        alive[j] = False
            sc = float(np.hypot(M[0, 0], M[1, 0]))       # facteur d'échelle de la similarité
            if not (cfg.scale_range[0] <= sc <= cfg.scale_range[1]):
                continue
            M3 = np.vstack([M, [0, 0, 1]]).astype(np.float64)
            src = P[sel]
            dst = Q[sel].copy()
            if mirrored:
                # Reflet : x_orig = (w-1) - x_reflet. On compose avec cette symétrie
                F = np.array([[-1, 0, w - 1], [0, 1, 0], [0, 0, 1]], np.float64)
                M3 = F @ M3
                dst[:, 0] = (w - 1) - dst[:, 0]
            out.append(dict(src=src, dst=dst, M3=M3, mirrored=mirrored,
                            n=len(sel), scale=sc,
                            angle=float(np.degrees(np.arctan2(M[1, 0], M[0, 0])))))
        return out

    # ------------------------------------------------------------------
    # Vérification pixel
    # ------------------------------------------------------------------
    def _region_mask(self, pts: np.ndarray, h: int, w: int):
        """Masque (h x w) de la région couverte par des points : enveloppe convexe dilatée.

        Retourne (masque uint8 0/255, sommets de l'enveloppe (N,2)).
        """
        cfg = self.cfg
        hull = cv2.convexHull(pts.astype(np.float32)).astype(np.int32)
        m = np.zeros((h, w), np.uint8)
        cv2.fillConvexPoly(m, hull, 255)
        if cfg.mask_dilate > 0:
            k = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (2 * cfg.mask_dilate + 1,) * 2)
            m = cv2.dilate(m, k)
        return m, hull.reshape(-1, 2)

    def _verify_and_dedupe(self, cands: list, blur: np.ndarray, hp: np.ndarray,
                           h: int, w: int, s: float, gray: np.ndarray) -> list:
        """Valide les candidats au niveau des PIXELS, écarte le texte, dédoublonne.

        Pour chaque candidat : on déforme la région source avec la
        transformation estimée et on la compare à la région copie.
        Rejets successifs : région trop petite, copie sortant de l'image,
        recouvrement source/copie, contenu trop uniforme ou presque blanc,
        texte (traits fins sur fond uni, ou ligne de glyphes alignés),
        corrélation (NCC) trop faible.
        Les coordonnées sont ensuite ramenées à l'image d'origine (facteur 1/s).
        """
        cfg = self.cfg
        accepted = []
        for c in cands:
            # --- Géométrie : taille, sortie d'image, recouvrement -------------
            mA, hullA = self._region_mask(c["src"], h, w)         # région source
            area = int((mA > 0).sum())
            if area < cfg.min_region_px:
                continue
            mB = cv2.warpAffine(mA, c["M3"][:2], (w, h), flags=cv2.INTER_NEAREST)  # copie prédite
            areaB = int((mB > 0).sum())
            if areaB < 0.6 * area * c["scale"] ** 2:     # la copie sort largement de l'image
                continue
            overlap = float(((mA > 0) & (mB > 0)).sum()) / max(min(area, areaB), 1)
            if overlap > cfg.max_overlap:
                continue

            # --- Contenu : assez de texture, pas de blanc -----------------------
            warped = cv2.warpAffine(blur, c["M3"][:2], (w, h), flags=cv2.INTER_LINEAR)
            sel = mB > 0                                  # pixels de la région copie
            a = warped[sel].astype(np.float32)            # la source, déformée
            b = blur[sel].astype(np.float32)              # la copie, telle qu'elle est
            if a.std() < cfg.min_region_std or b.std() < cfg.min_region_std:
                continue
            if float((b >= cfg.white_level).mean()) > cfg.max_white_in_region:
                continue
            nw = float((b >= cfg.nearwhite_level).mean())
            if nw > cfg.max_nearwhite_in_region:
                continue

            # --- Corrélation sur l'image passe-haut -----------------------------
            wa = cv2.warpAffine(hp, c["M3"][:2], (w, h), flags=cv2.INTER_LINEAR)[sel]
            ncc = float(np.corrcoef(wa, hp[sel])[0, 1])
            log.debug("  cand n=%d ncc=%.2f nearwhite=%.2f area=%d", c["n"], ncc, nw, area)

            # --- Rejet du texte -------------------------------------------------
            # (a) TRAITS FINS sur fond UNI. Les deux conditions sont nécessaires :
            #  - fond uni seul    : vrai aussi pour un Western blot (bandes épaisses) ;
            #  - traits fins seuls: vrai aussi pour des cellules sur fond bruité (Transwell).
            k3 = np.ones((3, 3), np.uint8)
            rng3 = (cv2.dilate(gray, k3).astype(np.int16) - cv2.erode(gray, k3).astype(np.int16))[sel]
            flat_frac = float((rng3 <= cfg.flat_pixel_range).mean())
            if flat_frac > cfg.max_flat_fraction:
                thin = _thin_ink_ratio(gray, sel, cfg.ink_level, cfg.ink_open_kernel)
                if thin >= cfg.min_thin_ink_ratio:
                    log.debug("  rejet: texte/schéma (traits fins sur fond uni)")
                    continue
            # (b) LIGNE DE GLYPHES alignés (couvre aussi les fonds JPEG légèrement bruités)
            n_txt, align = _text_line_components(gray, mA, cfg.ink_level)
            if n_txt >= cfg.text_min_components and align <= cfg.text_max_align:
                log.debug("  rejet: ligne de texte (%d composants alignés)", n_txt)
                continue

            # --- Corrélation insuffisante : ce n'est pas une copie --------------
            if not np.isfinite(ncc) or ncc < cfg.min_ncc:
                log.debug("  rejet: NCC=%.2f (n=%d)", ncc, c["n"])
                continue

            # --- Candidat validé : boîtes, polygones, score ---------------------
            _, hullB = self._region_mask(c["dst"], h, w)
            ys, xs = np.where(mA > 0)
            boxA = BoundingBox(int(xs.min()), int(ys.min()), int(xs.max() - xs.min()), int(ys.max() - ys.min()))
            ys, xs = np.where(mB > 0)
            boxB = BoundingBox(int(xs.min()), int(ys.min()), int(xs.max() - xs.min()), int(ys.max() - ys.min()))
            conf = 100.0 * float(np.clip((ncc - 0.7) / 0.3, 0, 1)) * float(np.clip(c["n"] / 40.0, 0.4, 1.0))
            accepted.append((conf, c, boxA, boxB, hullA, hullB, ncc))

        # --- Dédoublonnage : A->B et B->A sont la même détection ----------------
        accepted.sort(key=lambda t: -t[0])
        kept = []
        for t in accepted:
            _, _, bA, bB, *_ = t
            dup = False
            for k in kept:
                _, _, kA, kB, *_ = k
                if (bA.iou(kA) > 0.4 and bB.iou(kB) > 0.4) or (bA.iou(kB) > 0.4 and bB.iou(kA) > 0.4):
                    dup = True
                    break
            if not dup:
                kept.append(t)

        # --- Retour aux coordonnées de l'image d'ORIGINE (annule la réduction) ---
        inv = 1.0 / s

        def sbox(b: BoundingBox) -> BoundingBox:
            """Remet un rectangle de l'image réduite à l'échelle de l'image d'origine."""
            return BoundingBox(int(b.x * inv), int(b.y * inv), int(b.w * inv), int(b.h * inv))

        groups = []
        for gid, (conf, c, bA, bB, hA, hB, ncc) in enumerate(kept):
            groups.append(DuplicationGroup(
                group_id=gid, boxes=[sbox(bA), sbox(bB)], match_count=c["n"],
                confidence=round(conf, 1),
                polygons=[(hA * inv).astype(np.int32), (hB * inv).astype(np.int32)],
                ncc=round(ncc, 3), angle_deg=round(c["angle"], 1),
                scale=round(c["scale"], 3), mirrored=c["mirrored"]))
        return groups


# ===========================================================================
# 5. Annotation et rapport HTML
# ===========================================================================

# Couleurs (BGR) des groupes, réutilisées cycliquement
_PALETTE = [(0, 0, 220), (0, 200, 0), (220, 120, 0), (0, 200, 200),
            (200, 0, 200), (0, 140, 255), (128, 0, 128), (0, 128, 128)]


def annotate_image(image_bgr: np.ndarray, groups: list, cfg: Config) -> np.ndarray:
    """Retourne une copie de l'image avec les duplications dessinées.

    Pour chaque groupe : contour + remplissage translucide de la source et de la
    copie (même couleur), flèche source -> copie et étiquette « G<n> ».
    """
    annotated = image_bgr.copy()
    overlay = image_bgr.copy()           # calque pour le remplissage translucide
    th = max(cfg.annotation_thickness, int(max(image_bgr.shape[:2]) / 600))
    for g in groups:
        color = _PALETTE[g.group_id % len(_PALETTE)]
        for poly in g.polygons:
            cv2.fillPoly(overlay, [poly.reshape(-1, 1, 2)], color)
            cv2.polylines(annotated, [poly.reshape(-1, 1, 2)], True, color, th)
        if len(g.boxes) == 2:
            c0 = (g.boxes[0].x + g.boxes[0].w // 2, g.boxes[0].y + g.boxes[0].h // 2)
            c1 = (g.boxes[1].x + g.boxes[1].w // 2, g.boxes[1].y + g.boxes[1].h // 2)
            cv2.arrowedLine(annotated, c0, c1, color, max(1, th - 1), tipLength=0.05)
        bx = g.boxes[0]
        cv2.putText(annotated, f"G{g.group_id + 1}", (bx.x + 4, max(bx.y - 6, 18)),
                    cv2.FONT_HERSHEY_SIMPLEX, max(0.6, th / 4), color, max(2, th - 1),
                    lineType=cv2.LINE_AA)
    cv2.addWeighted(overlay, cfg.annotation_alpha, annotated, 1 - cfg.annotation_alpha, 0, annotated)
    return annotated


def _bgr_to_b64(img: np.ndarray, max_width: int = 1100, quality: int = 78) -> str:
    """Encode une image en JPEG base64 (pour l'intégrer au rapport HTML).

    L'image est réduite à `max_width` si besoin. JPEG plutôt que PNG : environ
    10 fois plus léger, ce qui garde le rapport sous quelques Mo.
    """
    h, w = img.shape[:2]
    if w > max_width:
        img = cv2.resize(img, (max_width, int(h * max_width / w)), interpolation=cv2.INTER_AREA)
    _, buf = cv2.imencode(".jpg", img, [cv2.IMWRITE_JPEG_QUALITY, quality])
    return base64.b64encode(buf.tobytes()).decode("ascii")


# Feuille de style du rapport HTML
_STYLE = """
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Segoe UI',Arial,sans-serif;background:#f4f6f8;color:#222;padding:24px}
h1{font-size:1.8rem;color:#1a1a2e;margin-bottom:4px}
.sub{color:#555;margin-bottom:24px;font-size:.95rem}
.sumbox{background:#fff;border-radius:10px;padding:18px 24px;box-shadow:0 2px 8px rgba(0,0,0,.08);margin-bottom:28px}
.sumbox h2{font-size:1.1rem;color:#333;margin-bottom:10px}
.stat{display:inline-block;background:#eef2ff;border-radius:8px;padding:10px 20px;margin:4px 6px 4px 0}
.stat .num{font-size:1.6rem;font-weight:700;color:#3949ab}
.stat .lbl{font-size:.78rem;color:#666;margin-top:2px}
.card{background:#fff;border-radius:10px;padding:20px 24px;box-shadow:0 2px 8px rgba(0,0,0,.08);margin-bottom:22px}
.card.suspicious{border-left:5px solid #e53935}
.card.clean{border-left:5px solid #43a047}
.card.skipped{border-left:5px solid #90a4ae}
.card h2{font-size:1.05rem;color:#333;margin-bottom:6px}
.card .meta{font-size:.82rem;color:#777;margin-bottom:14px}
.badge{display:inline-block;border-radius:12px;padding:3px 10px;font-size:.78rem;font-weight:600;margin-left:8px}
.badge.alert{background:#fce4e4;color:#c62828}
.badge.ok{background:#e8f5e9;color:#2e7d32}
.badge.skip{background:#eceff1;color:#546e7a}
.img-row{display:flex;gap:16px;flex-wrap:wrap}
.img-block{flex:1 1 45%;min-width:240px}
.img-block p{font-size:.82rem;color:#555;margin-bottom:6px;font-weight:600;text-transform:uppercase;letter-spacing:.04em}
.img-block img{width:100%;border-radius:6px;border:1px solid #ddd;display:block}
.gt{width:100%;border-collapse:collapse;margin-top:14px;font-size:.84rem}
.gt th{background:#e8eaf6;text-align:left;padding:6px 10px}
.gt td{padding:5px 10px;border-bottom:1px solid #eee}
.footer{text-align:center;color:#aaa;font-size:.78rem;margin-top:32px}
</style>
"""


def generate_html_report(input_name: str, results: list, elapsed: float) -> str:
    """Construit le rapport HTML autonome (images intégrées en base64).

    `results` : list[ImageResult]. Le rapport contient un bandeau de synthèse
    (images trouvées / analysées / ignorées / suspectes), puis une carte par
    image : vignette si rien de détecté, original + annotée + tableau des
    groupes si suspect, motif si l'image a été ignorée ou a provoqué une erreur.
    """
    analysed = [r for r in results if r.skip_reason is None and r.error is None]
    suspicious = [r for r in analysed if r.suspicious]
    skipped = [r for r in results if r.skip_reason]

    stats = f"""
    <div class="stat"><div class="num">{len(results)}</div><div class="lbl">Images found</div></div>
    <div class="stat"><div class="num">{len(analysed)}</div><div class="lbl">Analysed</div></div>
    <div class="stat"><div class="num" style="color:#546e7a">{len(skipped)}</div><div class="lbl">Skipped</div></div>
    <div class="stat"><div class="num" style="color:#c62828">{len(suspicious)}</div><div class="lbl">Suspicious</div></div>
    <div class="stat"><div class="num" style="color:#2e7d32">{len(analysed) - len(suspicious)}</div><div class="lbl">Clean</div></div>
    <div class="stat"><div class="num">{elapsed:.1f}s</div><div class="lbl">Processing time</div></div>"""

    cards = ""
    for r in results:
        if r.error:
            cards += (f'<div class="card"><h2>Image {r.image_id} — {r.source}</h2>'
                      f'<div class="meta" style="color:#c00">Error: {r.error}</div></div>')
            continue
        if r.skip_reason:
            cards += f"""
            <div class="card skipped"><h2>Image {r.image_id} — {r.source}
              <span class="badge skip">⊘ Skipped</span></h2>
              <div class="meta">{r.width}×{r.height} px — {r.skip_reason}</div>
              <div class="img-row"><div class="img-block"><p>Image</p>
                <img src="data:image/jpeg;base64,{r.original_b64}"></div></div></div>"""
            continue

        badge = ('<span class="badge alert">⚠ Suspicious</span>' if r.suspicious
                 else '<span class="badge ok">✓ Clean</span>')
        cls = "suspicious" if r.suspicious else "clean"
        img_row = f'<div class="img-row"><div class="img-block"><p>Original</p><img src="data:image/jpeg;base64,{r.original_b64}"></div>'
        if r.suspicious:
            img_row += f'<div class="img-block"><p>Annotated</p><img src="data:image/jpeg;base64,{r.annotated_b64}"></div>'
        img_row += "</div>"
        tbl = ""
        if r.groups:
            rows = "".join(
                f"<tr><td>G{g.group_id + 1}</td><td>{g.match_count}</td><td>{g.ncc:.2f}</td>"
                f"<td>{g.confidence:.0f}%</td>"
                f"<td>{'miroir, ' if g.mirrored else ''}{g.angle_deg:.0f}°, ×{g.scale:.2f}</td>"
                f"<td style='font-size:.76rem'>"
                + " → ".join(f"({b.x},{b.y},{b.w}×{b.h})" for b in g.boxes) + "</td></tr>"
                for g in r.groups)
            tbl = f"""<table class="gt"><tr><th>Group</th><th>Inliers</th><th>NCC</th>
              <th>Confidence</th><th>Transform</th><th>Source → copy (x,y,w×h)</th></tr>{rows}</table>"""
        cards += f"""
        <div class="card {cls}"><h2>Image {r.image_id} — {r.source} {badge}</h2>
        <div class="meta">{r.width}×{r.height} px | {r.processing_time:.2f}s</div>{img_row}{tbl}</div>"""

    return f"""<!DOCTYPE html><html lang="fr"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Scientific Image Integrity Report</title>{_STYLE}</head><body>
<h1>🔬 Scientific Image Integrity Report</h1>
<p class="sub">Input: <strong>{input_name}</strong></p>
<div class="sumbox"><h2>Summary</h2>{stats}</div>{cards}
<div class="footer">utils.py v2 — SIFT + g2NN + RANSAC(similarity) + NCC — {time.strftime('%Y-%m-%d %H:%M:%S')}</div>
</body></html>"""


# ===========================================================================
# 6. Lecture des entrées (PDF ou image) et pipeline complet
# ===========================================================================

def _iter_pdf_images(doc, cfg: Config):
    """Itère sur les images raster d'un document PyMuPDF ouvert.

    Génère des tuples (étiquette, image BGR), ex. ("page3_img1", array).
    Une image réutilisée sur plusieurs pages n'est donnée qu'une fois (xref).
    Les images plus petites que cfg.min_embedded_dim sont ignorées, et une image
    illisible est signalée dans les logs sans interrompre la suite.
    """
    seen: set = set()
    for page_num, page in enumerate(doc, start=1):
        for img_idx, info in enumerate(page.get_images(full=True), start=1):
            xref = info[0]
            if xref in seen:
                continue
            seen.add(xref)
            try:
                base = doc.extract_image(xref)
                pil = Image.open(BytesIO(base["image"])).convert("RGB")
                bgr = cv2.cvtColor(np.array(pil), cv2.COLOR_RGB2BGR)
                h, w = bgr.shape[:2]
                if w < cfg.min_embedded_dim or h < cfg.min_embedded_dim:
                    continue
                yield f"page{page_num}_img{img_idx}", bgr
            except Exception as exc:
                log.warning("xref %d failed: %s", xref, exc)


def extract_embedded_images(pdf_bytes: bytes, cfg: Optional[Config] = None):
    """Itère sur les images raster embarquées d'un PDF fourni en mémoire (octets).

    Génère des tuples (étiquette, image BGR). Voir `_iter_pdf_images`.
    """
    cfg = cfg or Config()
    doc = fitz.open(stream=pdf_bytes, filetype="pdf")
    try:
        yield from _iter_pdf_images(doc, cfg)
    finally:
        doc.close()


def load_image(image_bytes: bytes, label: str = "image") -> list:
    """Décode une image fournie en mémoire (PNG, JPEG, TIFF, BMP, WebP...).

    Retourne une liste d'un seul élément [(étiquette, image BGR)], même format
    que `extract_embedded_images`, pour que le reste du pipeline soit commun.
    L'orientation EXIF est appliquée (photos de téléphone). Lève ValueError si
    les octets ne sont pas une image lisible.
    """
    try:
        pil = ImageOps.exif_transpose(Image.open(BytesIO(image_bytes))).convert("RGB")
    except Exception as exc:
        raise ValueError(f"cannot decode image: {exc}") from exc
    return [(label, cv2.cvtColor(np.array(pil), cv2.COLOR_RGB2BGR))]


def analyse_one(idx: int, label: str, img_bgr: np.ndarray,
                detector: DuplicationDetector, cfg: Config) -> ImageResult:
    """Analyse UNE image et prépare ce qu'il faut pour le rapport.

    Ignore l'image si `_should_skip` le demande, sinon lance le détecteur. Pour
    une image suspecte : version annotée (gardée en pleine résolution dans
    `annotated_img`, et en JPEG réduit pour le rapport). Une exception du
    détecteur est capturée dans `ImageResult.error` pour ne pas bloquer les
    autres images.
    """
    h, w = img_bgr.shape[:2]
    t = time.time()
    r = ImageResult(image_id=idx, source=label, width=w, height=h)
    skip = _should_skip(img_bgr, cfg)
    q = cfg.report_jpeg_quality
    if skip:
        r.skip_reason = skip
        r.original_b64 = _bgr_to_b64(img_bgr, cfg.report_thumb_width, q)
    else:
        try:
            r.groups = detector.detect(img_bgr)
            if r.groups:
                annotated = annotate_image(img_bgr, r.groups, cfg)
                r.annotated_img = annotated
                r.original_b64 = _bgr_to_b64(img_bgr, cfg.report_max_width, q)
                r.annotated_b64 = _bgr_to_b64(annotated, cfg.report_max_width, q)
            else:
                r.original_b64 = _bgr_to_b64(img_bgr, cfg.report_thumb_width, q)
        except Exception as exc:
            log.exception("Detection failed")
            r.error = str(exc)
            r.original_b64 = _bgr_to_b64(img_bgr, cfg.report_thumb_width, q)
    r.processing_time = time.time() - t
    return r


def analyse_images(image_list, cfg: Optional[Config] = None) -> list:
    """Analyse une série d'images. `image_list` : itérable de (étiquette, image BGR).

    Retourne list[ImageResult], dans le même ordre. Un seul détecteur est créé
    et réutilisé pour toutes les images.
    """
    cfg = cfg or Config()
    detector = DuplicationDetector(cfg)
    return [analyse_one(i, label, bgr, detector, cfg)
            for i, (label, bgr) in enumerate(image_list, start=1)]


def build_composite(image_list, out_path: str, target_width: int = 1600,
                    separator: int = 8):
    """Empile verticalement toutes les images dans un seul PNG (out_path).

    `image_list` : itérable de (étiquette, image BGR). Dans le pipeline, on y
    place l'image ANNOTÉE pour les images suspectes et l'originale pour les autres.
    Cas d'une seule image (image seule, ou PDF à une image) : elle est écrite
    telle quelle, en pleine résolution. Sinon : largeur commune = min(plus grande
    largeur, target_width) et une fine bande blanche (`separator` px) sépare les
    images. Retourne la hauteur du PNG en px, ou None s'il n'y a aucune image.
    """
    images = list(image_list)
    if not images:
        return None
    if len(images) == 1:
        cv2.imwrite(out_path, images[0][1])
        return images[0][1].shape[0]
    common_w = min(max(bgr.shape[1] for _, bgr in images), target_width)
    parts = []
    for i, (_, bgr) in enumerate(images):
        h, w = bgr.shape[:2]
        if w != common_w:
            bgr = cv2.resize(bgr, (common_w, max(1, round(h * common_w / w))),
                             interpolation=cv2.INTER_AREA)
        parts.append(bgr)
        if i < len(images) - 1:
            parts.append(np.full((separator, common_w, 3), 255, np.uint8))
    composite = np.vstack(parts)
    cv2.imwrite(out_path, composite)
    return composite.shape[0]


def _build_summary(pid: str, doc_id: Optional[str], paths: dict, results: list,
                   n_extracted: int, image_height: Optional[int],
                   elapsed: float) -> dict:
    """Assemble le dictionnaire de synthèse renvoyé dans le champ "summary" du JSON.

    Contient l'identifiant du document, les chemins des 3 fichiers produits
    (json, rapport html, image png), les compteurs (extraites, analysées,
    ignorées, en erreur, suspectes) et, pour chaque image suspecte, le détail
    des groupes (boîtes source/copie, NCC, angle, échelle, miroir).
    """
    analysed = [r for r in results if r.skip_reason is None and r.error is None]
    suspicious = [r for r in analysed if r.suspicious]
    return {
        "pid": pid,
        "id": doc_id,
        "out_dir": paths["dir"],
        "json_path": paths["json"],
        "report_path": paths["html"],
        "report_size_mb": round(os.path.getsize(paths["html"]) / 1e6, 2),
        "image_path": paths["png"] if image_height else None,
        "image_height_px": image_height,
        "n_extracted": n_extracted,
        "n_analysed": len(analysed),
        "n_skipped": sum(1 for r in results if r.skip_reason),
        "n_errors": sum(1 for r in results if r.error),
        "n_suspicious": len(suspicious),
        "suspicious": [
            {
                "image": r.source,
                "groups": [{
                    "inliers": g.match_count, "ncc": g.ncc,
                    "confidence": g.confidence, "angle_deg": g.angle_deg,
                    "scale": g.scale, "mirrored": g.mirrored,
                    "source_box": [g.boxes[0].x, g.boxes[0].y, g.boxes[0].w, g.boxes[0].h],
                    "copy_box": [g.boxes[1].x, g.boxes[1].y, g.boxes[1].w, g.boxes[1].h],
                } for g in r.groups],
            } for r in suspicious
        ],
        "elapsed_s": round(elapsed, 2),
    }


def process_document(data: bytes, pid: str, doc_id: Optional[str],
                     data_type: str = "pdf", cfg: Optional[Config] = None) -> dict:
    """Pipeline complet pour UN document ; retourne le résumé du JSON de sortie.

    data_type : "pdf" (analyse toutes les images embarquées) ou "img" (le
    document est directement une image). Le reste est identique :
      1. récupérer les images,
      2. les analyser une à une,
      3. écrire dans /tmp/retrieve/<pid>/ :
           <nom>.html : le rapport ;
           <nom>.png  : l'image de sortie = toutes les images empilées (PDF) ou
                        l'image seule (image), avec les duplications dessinées
                        sur celles qui sont suspectes.
    <nom> est dérivé de `doc_id` (voir `safe_name`). Le JSON de sortie
    (<nom>.json) est écrit ensuite par `save_json`.
    """
    cfg = cfg or Config()
    paths = output_paths(pid, doc_id)
    t0 = time.time()

    if data_type == "img":
        image_list = load_image(data)
    else:
        image_list = list(extract_embedded_images(data, cfg))

    results = analyse_images(image_list, cfg)

    Path(paths["html"]).write_text(
        generate_html_report(doc_id or f"pid:{pid}", results, time.time() - t0),
        encoding="utf-8")

    # Image de sortie : annotée si une duplication a été trouvée, sinon l'originale
    output_images = [
        (r.source, r.annotated_img if r.annotated_img is not None else bgr)
        for r, (_, bgr) in zip(results, image_list)
    ]
    image_height = build_composite(output_images, paths["png"])
    for r in results:                    # libère la mémoire des images annotées
        r.annotated_img = None

    return _build_summary(pid, doc_id, paths, results, len(image_list),
                          image_height, time.time() - t0)


# ===========================================================================
# 7. Helpers du web service : lecture de la requête et sauvegarde des résultats
# ===========================================================================

def parse_pid(data: dict) -> str:
    """Extrait le pid de la requête JSON.

    Le pid est lu dans la première clé qui commence par "PID", à partir du 6e
    caractère de sa valeur (ex. "PID: 4242" -> "4242"). Il sert de nom de
    dossier : tout caractère hors [A-Za-z0-9_.-] est remplacé, pour interdire
    de sortir de /tmp (ex. "../../etc"). Vaut "unknown" s'il est absent.
    """
    keys = [k for k in data if k.startswith("PID")]
    pid = str(data[keys[0]])[5:] if keys else ""
    pid = re.sub(r"[^A-Za-z0-9_.-]", "_", pid).strip(".")
    return pid or "unknown"


def to_bytes(payload) -> bytes:
    """Convertit le champ "value" de la requête en octets (contenu du PDF ou de l'image).

    Formats acceptés :
      - {"data": [37, 80, ...]}  Buffer Node.js sérialisé en JSON (format des
                                 autres web services) ;
      - [37, 80, ...]            liste d'octets ;
      - bytes / bytearray ;
      - str                      un caractère = un octet (latin-1).
    """
    if isinstance(payload, dict):
        if "data" not in payload:
            raise ValueError(f"unsupported value dict (keys: {list(payload)})")
        payload = payload["data"]
    if isinstance(payload, (bytes, bytearray, memoryview)):
        return bytes(payload)
    if isinstance(payload, list):
        return bytes(payload)
    if isinstance(payload, str):
        return payload.encode("latin-1", errors="replace")
    raise TypeError(f"unsupported value type: {type(payload).__name__}")


def safe_name(doc_id) -> str:
    """Transforme l'id d'un document en nom de fichier valide et lisible.

    L'id a la forme "dossier/fichier.ext" (ex. "test_2/test2.png"). Règles :
      - "/" devient "__" et "." devient "_" ; "test_2/test2.png" donne donc
        "test_2__test2_png" (les extensions différentes donnent des noms
        différents : test2.png et test2.jpg ne se mélangent pas) ;
      - tout autre caractère non valide (espace, ":", "?"...) devient "_" ;
        les lettres accentuées sont conservées ;
      - aucun "/" ni ".." ne subsiste : impossible de sortir du dossier du pid ;
      - un id trop long est tronqué et complété par une courte empreinte de
        l'id complet pour rester unique ;
      - id absent ou vide : "unknown".
    """
    if doc_id is None or str(doc_id).strip() == "":
        return "unknown"
    raw = str(doc_id).strip().replace("\\", "/").strip("/")
    name = raw.replace("/", "__").replace(".", "_")
    name = re.sub(r"[^\w-]", "_", name)
    if len(name) > 150:
        name = name[:140] + "_" + hashlib.sha1(raw.encode("utf-8")).hexdigest()[:8]
    return name or "unknown"


def output_paths(pid: str, doc_id) -> dict:
    """Chemins des 3 fichiers de sortie d'un document, et crée le dossier du pid.

    Retourne {"dir", "name", "json", "html", "png"} :
    /tmp/retrieve/<pid>/<nom>.json|html|png, avec <nom> = safe_name(doc_id).
    """
    out_dir = os.path.join(RETRIEVE_DIR, pid)
    os.makedirs(out_dir, exist_ok=True)
    name = safe_name(doc_id)
    return {
        "dir": out_dir,
        "name": name,
        "json": os.path.join(out_dir, name + ".json"),
        "html": os.path.join(out_dir, name + ".html"),
        "png": os.path.join(out_dir, name + ".png"),
    }


def save_json(response: dict, pid: str, doc_id) -> None:
    """Enregistre le JSON de sortie dans /tmp/retrieve/<pid>/<nom>.json.

    `response` est l'objet renvoyé sur stdout ({"value": ..., "summary": ...}),
    y compris en cas d'erreur. Un échec d'écriture (disque plein, droits...) est
    seulement journalisé : il ne doit pas arrêter le service.
    """
    try:
        path = output_paths(pid, doc_id)["json"]
        Path(path).write_text(json.dumps(response, ensure_ascii=False, indent=2),
                              encoding="utf-8")
    except Exception as exc:
        log.warning("cannot save json for pid=%s id=%s: %s", pid, doc_id, exc)