# Misión 5 — comparación didáctica

Se usó la misma solicitud y el mismo `logs_sinteticos.csv` en dos sesiones
independientes. La primera no cargó el skill ni sus recursos; la segunda leyó
`incident-investigator/SKILL.md` y `references/detection-rules.md`.

Solicitud común:

> Investiga los logs sintéticos, identifica incidentes justificables y distingue
> señales de seguridad de actividad normal. Devuelve evidencia concreta.

| Dimensión | Sin skill | Con skill | Evidencia / comentario |
|---|---|---|---|
| ¿Usó un procedimiento reproducible? | Parcialmente: describió columnas, filas y ventanas, pero no siguió una guía externa | Sí: verificó columnas, leyó reglas, ordenó ventanas y aplicó coincidencias exactas | Transcripciones en `evidencias/sesion_sin_skill.md` y `evidencias/sesion_con_skill.md` |
| ¿Citó filas concretas? | Sí | Sí | Ambas citaron las filas originales: 17–28, 33, 38, 39, 41, 42, 59, 67, 68, 70, 71, 73, 74 y 78, 80–84 según el caso |
| Alertas sustentadas | 4 | 4 | Ambas detectaron fuerza bruta, spraying, token potencial y cambio de rol no aprobado |
| Falsos positivos detectados o evitados | Sí | Sí | Ambas descartaron 38, 39 y 41 por estar por debajo de seis fallos; también descartaron `healthcheck` |
| ¿Ocultó posibles tokens? | Sí | Sí | La fila 33 aparece como `[REDACTED]` en ambas respuestas |
| ¿Reconoció incertidumbre? | Sí | Sí | Ambas aclaran que las señales son heurísticas y no prueban compromiso ni culpabilidad |
| ¿Qué hizo gracias al skill? | — | Estandarizó el procedimiento, reglas, formato y límites | En esta corrida no aumentó el número de alertas; mejoró la trazabilidad, la consistencia y la contención de invenciones |

## Qué aportó el skill

La mejora observada no fue solo estética: el skill hizo explícitos los umbrales,
la ventana inclusiva de cinco minutos, las coincidencias exactas, la
conservación de filas originales, el control de falsos positivos y la redacción
obligatoria de `token=`. También fijó cuándo investigar y cuándo no activar el
flujo para un conteo o visualización descriptiva.

En esta comparación didáctica, ambas sesiones llegaron a las mismas cuatro
alertas porque el CSV es claro y la sesión sin skill también razonó
correctamente. Por eso no se afirma que el skill haya mejorado la detección en
cantidad; su aporte concreto fue hacer el análisis más reproducible,
auditable y seguro. Una corrida por condición no constituye evidencia
estadística.

Tiempo y tokens: no disponible de forma confiable.
