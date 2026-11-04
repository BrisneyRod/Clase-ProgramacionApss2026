from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from mcp.server import MCPServer


RUTA_CASOS = Path(__file__).resolve().parent / "casos.json"

with RUTA_CASOS.open(encoding="utf-8") as archivo:
    CASOS: dict[str, dict[str, Any]] = json.load(archivo)

ALERTAS_REGISTRADAS: dict[str, dict[str, str]] = {}
NIVELES_VALIDOS = {"bajo", "medio", "alto"}

mcp = MCPServer("MCP Detective")


def listar_casos_logica() -> list[dict]:
    """Construye el resumen de los casos disponibles."""
    return [
        {
            "id": caso_id,
            "sistema": datos["sistema"],
            "cantidad_eventos": len(datos["eventos"]),
        }
        for caso_id, datos in CASOS.items()
    ]


def consultar_eventos_logica(caso_id: str) -> list[dict]:
    """Obtiene los eventos exactos de un caso existente."""
    if not isinstance(caso_id, str) or caso_id not in CASOS:
        raise ValueError(f"El caso '{caso_id}' no existe.")
    return [dict(evento) for evento in CASOS[caso_id]["eventos"]]


def registrar_alerta_logica(caso_id: str, nivel: str, motivo: str) -> dict:
    """Valida y registra una única alerta en memoria por caso."""
    if not isinstance(caso_id, str) or caso_id not in CASOS:
        raise ValueError(f"El caso '{caso_id}' no existe.")
    if not isinstance(nivel, str) or nivel not in NIVELES_VALIDOS:
        raise ValueError("El nivel debe ser exactamente 'bajo', 'medio' o 'alto'.")
    if not isinstance(motivo, str) or not motivo.strip():
        raise ValueError("El motivo debe contener al menos un carácter no blanco.")
    if caso_id in ALERTAS_REGISTRADAS:
        raise ValueError(f"Ya existe una alerta registrada para el caso '{caso_id}'.")

    alerta = {
        "caso_id": caso_id,
        "nivel": nivel,
        "motivo": motivo,
        "estado": "registrada",
    }
    ALERTAS_REGISTRADAS[caso_id] = alerta
    return dict(alerta)


@mcp.tool()
def listar_casos() -> list[dict]:
    """Lista los casos disponibles con su sistema y cantidad de eventos."""
    return listar_casos_logica()


@mcp.tool()
def consultar_eventos(caso_id: str) -> list[dict]:
    """Devuelve los eventos exactos del caso indicado."""
    return consultar_eventos_logica(caso_id)


@mcp.tool()
def registrar_alerta(caso_id: str, nivel: str, motivo: str) -> dict:
    """Registra en memoria una alerta válida y única para un caso."""
    return registrar_alerta_logica(caso_id, nivel, motivo)


if __name__ == "__main__":
    mcp.run(transport="stdio")
