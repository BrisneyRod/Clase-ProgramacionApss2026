# Deber 5 — MCP Detective

Este directorio contiene la implementación del servidor MCP del Deber 5 de
Programación Asistida de Aplicaciones.

## Archivos

- `server.py`: servidor MCP en Python con transporte `stdio` y tres tools.
- `casos.json`: datos deterministas de los casos `INC-001`, `INC-002` e
  `INC-003`.

## Tools disponibles

- `listar_casos`: lista cada caso, su sistema y cantidad de eventos.
- `consultar_eventos`: devuelve los eventos exactos de un caso.
- `registrar_alerta`: valida y registra en memoria una alerta por caso.

Las alertas se almacenan solo mientras vive la instancia del servidor. El
servidor carga `casos.json` usando una ruta relativa a `__file__` y se ejecuta
por stdio:

```bash
python mcp-detective/server.py
```

## Evidencia

La captura de la implementación está en
`evidencias/parte1_server.png`.
