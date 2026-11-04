# Deber 5 — Reflexión y entrega

## 1. Arquitectura

El LLM interpretó la solicitud y propuso qué herramienta MCP usar y con qué
argumentos. El harness o host (Codex) mantuvo la conversación, descubrió las
tools y coordinó sus llamadas. El cliente MCP convirtió esas llamadas en
mensajes por `stdio` y recibió las respuestas. El servidor MCP, ejecutado por
el proceso de Python configurado en Codex, cargó los datos, ejecutó la lógica y
validó los argumentos. Por tanto, Python lo ejecutó el proceso del servidor
MCP que el cliente lanzó, no el LLM.

Usé Codex como agente. Comprobé la conexión porque Codex descubrió las tres
tools de `mcp-detective` y en la conversación se observan las llamadas reales a
`listar_casos`, `consultar_eventos` y `registrar_alerta`, junto con sus
resultados y errores.

## 2. Evidencia

`INC-003` merece investigación porque muestra cuatro intentos fallidos seguidos
para `admin` desde la misma IP y después un inicio de sesión exitoso en pocos
minutos. Ese patrón es sospechoso, pero los logs no demuestran por sí solos una
intrusión: podría corresponder a un usuario legítimo, una automatización, una
configuración equivocada u otra explicación. Por eso la alerta recomienda
revisión sin afirmar un compromiso confirmado.

## 3. Validación y seguridad

El servidor MCP rechaza `INC-999`, niveles no permitidos, motivos vacíos y
alertas duplicadas mediante validaciones y excepciones `ValueError`. No es
seguro confiar solo en que el modelo genere argumentos correctos porque un LLM
puede equivocarse, omitir datos o producir valores inválidos. La validación
debe estar en el servidor, que es la autoridad que protege los datos y el
estado.

## Instalación, Inspector y conexión

Desde la raíz del proyecto:

```bash
python -m pip install "mcp[cli]>=2,<3" pytest
mcp dev mcp-detective/server.py
```

El Inspector se abrió con el servidor por `stdio`. Para Codex configuré el
servidor con Python y la ruta absoluta de `mcp-detective/server.py`; después
abrí una conversación nueva y comprobé el discovery de las tres herramientas.
No se incluyen tokens ni contraseñas en esta configuración.
