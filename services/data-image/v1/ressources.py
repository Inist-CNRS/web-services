#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Ressources for imageDup-detect.py.

This module centralises everything heavy (third-party imports, image
processing helpers, the PDF→images pipeline, the per-image SIFT/RANSAC
analysis loop) so imageDup-detect.py stays a thin JSON service.

Public API
----------
- extract_embedded_images(pdf_bytes)  -> iterable of (page, idx, bgr, w, h)
- analyse_images(images, cfg)         -> list[ImageResult]  (matches
                                          detect_image_fraud.ImageResult)
- build_composite(images, out_path,
                  target_width=1600,
                  separator=8)         -> writes a single PNG with every
                                          extracted image stacked
                                          vertically
- process_pdf(pdf_bytes, pid, out_dir=None) -> dict summary used by
                                                imageDup-detect.py to
                                                build its JSON response
"""

from __future__ import annotations

import os
from dataclasses import asdict
from io import BytesIO
from pathlib import Path
from typing import Optional

import cv2
import fitz  # PyMuPDF
import numpy as np
from PIL import Image

# Re-use everything we need from the original pipeline so thresholds,
# filters, and report generation stay in lock-step.
from detect_image_fraud import (
    Config,
    DuplicationDetector,
    ImageResult,
    _bgr_to_b64,
    _should_skip,
    annotate_image,
    generate_html_report,
)


# ---------------------------------------------------------------------------
# PDF → embedded raster images
# ---------------------------------------------------------------------------

def extract_embedded_images(pdf_bytes: bytes, cfg: Optional[Config] = None):
    """
    Iterate over every embedded raster image in the PDF.

    Yields tuples: (label, page_num, img_idx, img_bgr, width, height).
    Mirrors detect_image_fraud.extract_images_from_pdf() but reads from an
    in-memory byte stream and uses Config's min_embedded_dim threshold.
    """
    if cfg is None:
        cfg = Config()

    doc = fitz.open(stream=pdf_bytes, filetype="pdf")
    try:
        seen_xrefs: set[int] = set()
        for page_num, page in enumerate(doc, start=1):
            for img_idx, img_info in enumerate(page.get_images(full=True), start=1):
                xref = img_info[0]
                if xref in seen_xrefs:
                    continue
                seen_xrefs.add(xref)
                try:
                    base_image = doc.extract_image(xref)
                    img_pil = Image.open(BytesIO(base_image["image"])).convert("RGB")
                    img_bgr = cv2.cvtColor(np.array(img_pil), cv2.COLOR_RGB2BGR)
                    h, w = img_bgr.shape[:2]
                    if w < cfg.min_embedded_dim or h < cfg.min_embedded_dim:
                        continue
                    label = f"page{page_num}_img{img_idx}"
                    yield label, page_num, img_idx, img_bgr, w, h
                except Exception as exc:
                    import sys
                    sys.stderr.write(
                        f"[ressources] xref {xref} failed: {exc}\n"
                    )
    finally:
        doc.close()


# ---------------------------------------------------------------------------
# Per-image analysis (same loop as detect_image_fraud.run_pipeline)
# ---------------------------------------------------------------------------

def analyse_images(image_list, cfg: Optional[Config] = None):
    """
    Run the SIFT/RANSAC duplication detector on each image, returning a
    list[ImageResult] ready to feed generate_html_report().

    `image_list` is an iterable of (label, img_bgr) tuples, matching the
    format produced by extract_images_from_pdf in detect_image_fraud.py.
    """
    import time

    if cfg is None:
        cfg = Config()

    detector = DuplicationDetector(cfg)
    results: list[ImageResult] = []

    for idx, (label, img_bgr) in enumerate(image_list, start=1):
        h, w = img_bgr.shape[:2]
        start = time.time()
        r = ImageResult(image_id=idx, source=label, width=w, height=h)

        skip = _should_skip(img_bgr, cfg)
        if skip:
            r.skip_reason = skip
            r.original_b64 = _bgr_to_b64(img_bgr)
            r.processing_time = time.time() - start
            results.append(r)
            continue

        try:
            groups = detector.detect(img_bgr)
            r.groups = groups
            r.original_b64 = _bgr_to_b64(img_bgr)
            if groups:
                annotated = annotate_image(img_bgr, groups, cfg)
                r.annotated_b64 = _bgr_to_b64(annotated)
        except Exception as exc:
            r.error = str(exc)

        r.processing_time = time.time() - start
        results.append(r)

    return results


# ---------------------------------------------------------------------------
# Composite: one big PNG with every extracted image stacked vertically
# ---------------------------------------------------------------------------

def build_composite(
    image_list,
    out_path: str,
    target_width: int = 1600,
    separator: int = 8,
):
    """
    Concatenate every (label, img_bgr) tuple into a single PNG at out_path.

    Behaviour:
      * Target width = min(max(input_widths), target_width). Each image
        is resized with INTER_AREA so wide figures shrink instead of
        blowing up the composite.
      * Vertical stack with a thin white separator between images.
      * Returns the composite height in pixels (for diagnostics).

    `image_list` is an iterable of (label, img_bgr) tuples.
    """
    images = list(image_list)
    if not images:
        return None

    src_widths = [bgr.shape[1] for _, bgr in images]
    common_w = min(max(src_widths), target_width)

    resized = []
    for _, bgr in images:
        h, w = bgr.shape[:2]
        if w != common_w:
            scale = common_w / w
            new_h = max(1, int(round(h * scale)))
            bgr = cv2.resize(bgr, (common_w, new_h), interpolation=cv2.INTER_AREA)
        resized.append(bgr)

    separator_strip = (
        np.full((separator, common_w, 3), 255, dtype=np.uint8)
        if len(resized) > 1
        else None
    )

    parts = []
    for i, bgr in enumerate(resized):
        parts.append(bgr)
        if separator_strip is not None and i < len(resized) - 1:
            parts.append(separator_strip)

    composite = np.vstack(parts)
    cv2.imwrite(out_path, composite)
    return composite.shape[0]


# ---------------------------------------------------------------------------
# Top-level entry point used by imageDup-detect.py
# ---------------------------------------------------------------------------

def process_pdf(
    pdf_bytes: bytes,
    pid: str,
    out_dir: Optional[str] = None,
    cfg: Optional[Config] = None,
) -> dict:
    """
    Full pipeline for one PDF:

      1. Extract embedded images.
      2. Build the per-image analysis list (label, img_bgr).
      3. Run analyse_images() — SIFT/RANSAC per image, like the original.
      4. Render an HTML report next to the composite.
      5. Save the composite PNG.

    Returns a summary dict with paths + counts that imageDup-detect.py
    embeds into its JSON response.
    """
    import time

    if cfg is None:
        cfg = Config()

    if out_dir is None:
        out_dir = os.path.join("/tmp", pid)
    os.makedirs(out_dir, exist_ok=True)

    t0 = time.time()

    # 1+2: extract & pair with labels
    extracted = list(extract_embedded_images(pdf_bytes, cfg))
    image_list = [(label, bgr) for (label, _, _, bgr, _, _) in extracted]

    # 3: per-image analysis
    results = analyse_images(image_list, cfg)

    # 4: HTML report (uses input filename in the header; we have none)
    report_path = os.path.join(out_dir, "report.html")
    html = generate_html_report(
        input_name=f"pid:{pid}",
        results=results,
        elapsed=time.time() - t0,
    )
    Path(report_path).write_text(html, encoding="utf-8")

    # 5: composite PNG
    composite_path = os.path.join(out_dir, "composite.png")
    composite_height = build_composite(image_list, composite_path)

    # Summary
    analysed = [r for r in results if r.skip_reason is None and r.error is None]
    suspicious = [r for r in analysed if r.suspicious]
    skipped = [r for r in results if r.skip_reason]
    return {
        "pid": pid,
        "out_dir": out_dir,
        "composite_path": composite_path,
        "composite_height_px": composite_height,
        "report_path": report_path,
        "n_extracted": len(extracted),
        "n_analysed": len(analysed),
        "n_skipped": len(skipped),
        "n_suspicious": len(suspicious),
        "elapsed_s": round(time.time() - t0, 2),
    }