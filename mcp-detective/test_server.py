import importlib.util
from pathlib import Path

import pytest


RUTA_SERVER = Path(__file__).with_name("server.py")
ESPECIFICACION = importlib.util.spec_from_file_location("mcp_detective_server", RUTA_SERVER)
server = importlib.util.module_from_spec(ESPECIFICACION)
assert ESPECIFICACION.loader is not None
ESPECIFICACION.loader.exec_module(server)


@pytest.fixture
def servidor():
    """Aísla el almacenamiento en memoria de cada prueba."""
    server.ALERTAS_REGISTRADAS.clear()
    yield server
    server.ALERTAS_REGISTRADAS.clear()


def test_listar_casos_devuelve_los_tres_casos(servidor):
    casos = servidor.listar_casos_logica()

    assert [caso["id"] for caso in casos] == ["INC-001", "INC-002", "INC-003"]
    assert [caso["cantidad_eventos"] for caso in casos] == [2, 6, 5]


def test_consultar_eventos_rechaza_caso_desconocido(servidor):
    with pytest.raises(ValueError, match="no existe"):
        servidor.consultar_eventos_logica("INC-999")


def test_consultar_eventos_inc002_devuelve_seis_fallos(servidor):
    eventos = servidor.consultar_eventos_logica("INC-002")

    assert len(eventos) == 6
    assert all(evento["usuario"] == "admin" for evento in eventos)
    assert all(evento["evento"] == "LOGIN_FAILED" for evento in eventos)


def test_registrar_alerta_valida(servidor):
    alerta = servidor.registrar_alerta_logica(
        "INC-003",
        "alto",
        "Cuatro fallos y un acceso exitoso desde la misma IP; requiere investigación",
    )

    assert alerta == {
        "caso_id": "INC-003",
        "nivel": "alto",
        "motivo": "Cuatro fallos y un acceso exitoso desde la misma IP; requiere investigación",
        "estado": "registrada",
    }


def test_registrar_alerta_rechaza_duplicado(servidor):
    servidor.registrar_alerta_logica("INC-003", "alto", "Revisión necesaria")

    with pytest.raises(ValueError, match="alerta registrada"):
        servidor.registrar_alerta_logica("INC-003", "alto", "Otra alerta")


def test_registrar_alerta_rechaza_nivel_y_motivo_invalidos(servidor):
    with pytest.raises(ValueError, match="bajo.*medio.*alto"):
        servidor.registrar_alerta_logica("INC-002", "critico", "Intentos repetidos")

    with pytest.raises(ValueError, match="no blanco"):
        servidor.registrar_alerta_logica("INC-002", "medio", " ")
