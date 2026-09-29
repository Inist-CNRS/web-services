#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Serveur MCP classique (SDK officiel `mcp`), transport Streamable HTTP.

Chaque outil de tools_config.json correspond à un web service distant.
Les web services Inist-CNRS attendent un TABLEAU d'objets {"id", "value"}
et renvoient un tableau de même forme. Deux modes :

- mode "single" (défaut) : un appel d'outil = un document. L'outil prend
  {"value": <ce que CE web service attend>} ; le serveur envoie un tableau
  à un élément et renvoie le "value" de la réponse.

- mode "batch" : pour les services qui traitent un CORPUS (le résultat de
  chaque document dépend des autres, ex. text-clustering). L'outil prend
  {"items": [{"id": ..., "value": ...}, ...]} ; le serveur envoie le
  tableau tel quel et renvoie le tableau complet de la réponse.

Le champ "value" n'est jamais interprété : texte, objet, liste... il est
transmis tel quel. Son schéma est décrit dans tools_config.json.
"""

import asyncio
import io
import json
import os
import sys
import tarfile
import time
import uuid
from pathlib import Path
from typing import Any

import httpx
from mcp.server.fastmcp import FastMCP
from mcp.types import Tool, TextContent

# Un ou plusieurs fichiers de config, séparés par des virgules, ex. :
#   MCP_TOOLS_CONFIG=/app/tools_config.json,/app/tools_config_v2.json
CONFIG_FILES = os.environ.get("MCP_TOOLS_CONFIG", "/app/tools_config.json")
HOST = os.environ.get("MCP_HOST", "0.0.0.0")
PORT = int(os.environ.get("MCP_PORT", "8000"))
DEFAULT_TIMEOUT = float(os.environ.get("MCP_HTTP_TIMEOUT", "30"))


def load_tools(config_files: str) -> dict:
    """Charge et fusionne les outils de tous les fichiers de config indiqués."""
    tools: dict = {}
    for raw_path in config_files.split(","):
        path = Path(raw_path.strip())
        with open(path, "r", encoding="utf-8") as f:
            for tool in json.load(f)["tools"]:
                if tool["name"] in tools:
                    raise ValueError(f"Outil en double '{tool['name']}' (fichier {path})")
                tools[tool["name"]] = tool
    return tools


TOOLS_CONFIG = load_tools(CONFIG_FILES)
print(
    f"[mcp] {len(TOOLS_CONFIG)} outil(s) chargé(s) depuis {CONFIG_FILES} : "
    f"{', '.join(TOOLS_CONFIG)}",
    file=sys.stderr,
    flush=True,
)

mcp = FastMCP("webservices-mcp", host=HOST, port=PORT)

# Client HTTP partagé (réutilisation des connexions vers les web services)
_http_client = httpx.AsyncClient(timeout=DEFAULT_TIMEOUT)


async def _post(spec: dict, payload: list) -> list:
    """Envoie `payload` (tableau d'objets id/value) et renvoie le tableau de réponse."""
    url = spec["url"]
    resp = await _http_client.request(
        spec.get("method", "POST").upper(),
        url,
        json=payload,
        timeout=spec.get("timeout", DEFAULT_TIMEOUT),
        headers=spec.get("headers", {}),
    )
    resp.raise_for_status()
    data = resp.json()

    if not isinstance(data, list):
        raise RuntimeError(
            f"Réponse inattendue du web service '{url}' (tableau attendu): {data!r}"
        )
    return data


async def call_webservice(spec: dict, value: Any) -> Any:
    """Mode single : un document, renvoie le "value" de la réponse."""
    data = await _post(spec, [{"id": str(uuid.uuid4()), "value": value}])
    if not data:
        raise RuntimeError(f"Réponse vide du web service '{spec['url']}'")

    item = data[0]
    if not isinstance(item, dict) or "value" not in item:
        raise RuntimeError(
            f"Élément de réponse du web service '{spec['url']}' sans champ 'value': {item!r}"
        )
    return item["value"]


async def call_webservice_batch(spec: dict, items: Any) -> list:
    """Mode batch : un corpus entier, renvoie le tableau complet de la réponse."""
    if not isinstance(items, list) or not items:
        raise ValueError("'items' doit être un tableau non vide d'objets {id, value}.")

    payload = []
    for index, item in enumerate(items):
        if not isinstance(item, dict) or "value" not in item:
            raise ValueError(f"items[{index}] doit être un objet avec un champ 'value'.")
        payload.append({"id": item.get("id", index), "value": item["value"]})

    return await _post(spec, payload)


def _build_tar_gz(items: list, folder: str) -> bytes:
    """
    Construit en mémoire (sans rien écrire sur disque) un .tar.gz contenant
    un fichier JSON par document, sous un dossier `folder`. Chaque fichier
    contient un seul objet {"id", "value"}.
    """
    buf = io.BytesIO()
    with tarfile.open(fileobj=buf, mode="w:gz") as tar:
        for index, item in enumerate(items):
            doc = {"id": item.get("id", index), "value": item["value"]}
            raw = json.dumps(doc, ensure_ascii=False).encode("utf-8")
            info = tarfile.TarInfo(name=f"{folder}/doc_{index}.json")
            info.size = len(raw)
            info.mtime = int(time.time())
            tar.addfile(info, io.BytesIO(raw))
    return buf.getvalue()


def _looks_like_not_ready_yet(status_code: int, body: Any) -> bool:
    """
    Le service renvoie un 400 tant que le résultat n'est pas prêt, avec une
    erreur interne du type "FILELoad ... File location check failed.".
    On ne retente QUE sur ce message précis ; toute autre erreur 400 est
    considérée comme une vraie erreur et remontée telle quelle.
    """
    if status_code != 400:
        return False
    text = json.dumps(body) if not isinstance(body, str) else body
    return "File location check failed" in text or "FILELoad" in text


async def call_webservice_tarball_batch(spec: dict, items: Any) -> list:
    """
    Mode tarball_batch (ex. text-clustering) :
      1. empaquette `items` en .tar.gz en mémoire et le soumet à `url`,
         ce qui renvoie un token : [{"id": "...", "value": "<token>"}]
      2. interroge `retrieve_url` avec ce token jusqu'à ce que le résultat
         soit prêt (tant qu'il ne l'est pas, le service renvoie un 400
         "File location check failed" -> on patiente et on réessaie), avec
         un backoff croissant borné par poll_timeout_seconds.
    """
    if not isinstance(items, list) or not items:
        raise ValueError("'items' doit être un tableau non vide d'objets {id, value}.")
    for index, item in enumerate(items):
        if not isinstance(item, dict) or "value" not in item:
            raise ValueError(f"items[{index}] doit être un objet avec un champ 'value'.")

    folder = spec.get("archive_folder", "data")
    tar_bytes = _build_tar_gz(items, folder)

    submit_headers = {"Content-Type": "application/x-gzip", **spec.get("headers", {})}
    submit_resp = await _http_client.post(
        spec["url"],
        content=tar_bytes,
        headers=submit_headers,
        timeout=spec.get("timeout", DEFAULT_TIMEOUT),
    )
    submit_resp.raise_for_status()
    submit_data = submit_resp.json()

    if not isinstance(submit_data, list) or not submit_data or "value" not in submit_data[0]:
        raise RuntimeError(f"Réponse de soumission inattendue de '{spec['url']}': {submit_data!r}")
    token = submit_data[0]["value"]

    retrieve_url = spec["retrieve_url"]
    interval = spec.get("poll_interval_seconds", 3)
    max_interval = spec.get("poll_interval_max_seconds", 15)
    deadline = time.monotonic() + spec.get("poll_timeout_seconds", 300)

    while True:
        retrieve_resp = await _http_client.post(
            retrieve_url,
            json=[{"value": token}],
            headers=spec.get("headers", {}),
            timeout=spec.get("timeout", DEFAULT_TIMEOUT),
        )

        if retrieve_resp.status_code == 200:
            result = retrieve_resp.json()
            if not isinstance(result, list):
                raise RuntimeError(f"Réponse inattendue de '{retrieve_url}': {result!r}")
            return result

        try:
            body = retrieve_resp.json()
        except ValueError:
            body = retrieve_resp.text

        if _looks_like_not_ready_yet(retrieve_resp.status_code, body):
            if time.monotonic() >= deadline:
                raise TimeoutError(
                    f"Résultat pas encore prêt après {spec.get('poll_timeout_seconds', 300)}s "
                    f"d'attente (traitement toujours en cours côté serveur distant, pas une erreur). "
                    f"Jeton : '{token}'. Rappelez l'outil text_clustering_retrieve avec "
                    f"{{\"token\": \"{token}\"}} dans quelques secondes à quelques dizaines de "
                    f"secondes selon la taille du corpus, en répétant si besoin jusqu'à obtenir "
                    f"le résultat."
                )
            await asyncio.sleep(interval)
            interval = min(interval * 1.5, max_interval)
            continue

        # Toute autre erreur (400 avec un autre message, 4xx/5xx...) : on la remonte
        retrieve_resp.raise_for_status()
        raise RuntimeError(f"Erreur inattendue de '{retrieve_url}': {body!r}")


async def call_webservice_retrieve(spec: dict, token: str) -> list:
    """
    Interroge directement retrieve_url avec un token déjà obtenu (un seul
    essai, pas de polling) : sert à relancer une récupération plus tard, en
    dehors du cycle complet de text_clustering_run.
    """
    resp = await _http_client.post(
        spec["retrieve_url"],
        json=[{"value": token}],
        headers=spec.get("headers", {}),
        timeout=spec.get("timeout", DEFAULT_TIMEOUT),
    )
    if resp.status_code == 200:
        data = resp.json()
        if not isinstance(data, list):
            raise RuntimeError(f"Réponse inattendue de '{spec['retrieve_url']}': {data!r}")
        return data

    try:
        body = resp.json()
    except ValueError:
        body = resp.text

    if _looks_like_not_ready_yet(resp.status_code, body):
        raise RuntimeError(
            "Résultat pas encore prêt (traitement toujours en cours côté serveur distant, "
            "pas une erreur) : rappelez text_clustering_retrieve avec le même token dans "
            "quelques secondes à quelques dizaines de secondes, en répétant si besoin."
        )

    resp.raise_for_status()
    raise RuntimeError(f"Erreur inattendue de '{spec['retrieve_url']}': {body!r}")


def _tools_list() -> list[Tool]:
    return [
        Tool(
            name=name,
            description=spec.get("description", ""),
            inputSchema=spec.get(
                "input_schema",
                {"type": "object", "properties": {}, "additionalProperties": True},
            ),
        )
        for name, spec in TOOLS_CONFIG.items()
    ]


@mcp._mcp_server.list_tools()
async def list_tools() -> list[Tool]:
    return _tools_list()


@mcp._mcp_server.call_tool()
async def call_tool(name: str, arguments: dict) -> list[TextContent]:
    if name not in TOOLS_CONFIG:
        raise ValueError(f"Outil inconnu : {name}")

    spec = TOOLS_CONFIG[name]
    mode = spec.get("mode")

    if mode == "tarball_batch":
        result = await call_webservice_tarball_batch(spec, arguments.get("items"))
    elif mode == "retrieve":
        result = await call_webservice_retrieve(spec, arguments.get("token"))
    elif mode == "batch":
        result = await call_webservice_batch(spec, arguments.get("items"))
    else:
        # Le schéma MCP d'un outil doit être de type "object" ; la donnée réelle
        # est portée par sa propriété "value" (forme propre à chaque web service).
        result = await call_webservice(spec, arguments.get("value"))

    text = result if isinstance(result, str) else json.dumps(result, ensure_ascii=False)
    return [TextContent(type="text", text=text)]


if __name__ == "__main__":
    mcp.run(transport="streamable-http")