# Misión 5 — comparación didáctica

Solicitud común prevista para ambas condiciones:

> Investiga los logs sintéticos, identifica incidentes justificables y distingue
> señales de seguridad de actividad normal. Devuelve evidencia concreta.

## Resultado de la comparación

No se presenta una comparación controlada inventada. Esta interfaz no permite
cerrar y abrir una sesión independiente del agente de forma verificable dentro
de la misma entrega. La corrida observable con skill corresponde a la Prueba A
de la Misión 3; una corrida independiente sin skill no fue observada. Por eso
las celdas “sin skill” no se rellenan con suposiciones.

| Dimensión | Sin skill | Con skill | Evidencia / comentario |
|---|---|---|---|
| ¿Usó un procedimiento reproducible? | No disponible: no hubo sesión independiente observable | Sí, en la corrida explícita | Se inspeccionó el CSV, se leyó la referencia y se aplicaron ventanas/umbrales |
| ¿Citó filas concretas? | No disponible | Sí | `hallazgos.md` cita 17–28, 33, 38, 39, 41, 42, 59, 67, 68, 70, 71, 73, 74 y 78, 80–84 según el caso |
| Alertas sustentadas | No disponible | 4 alertas justificadas | Fuerza bruta, spraying, token potencial y cambio de rol no aprobado |
| Falsos positivos detectados o evitados | No disponible | Sí | Tres fallos de 38, 39 y 41 no alcanzan seis; `healthcheck` 78, 80–84 no cuenta |
| ¿Ocultó posibles tokens? | No disponible | Sí | La fila 33 se reporta como `[REDACTED]` |
| ¿Reconoció incertidumbre? | No disponible | Sí | Se aclara que son heurísticas, no conclusiones forenses |
| ¿Qué hizo gracias al skill? | No evaluable | Umbrales, referencia consultable, filas originales, redacción y límites | La mejora concreta está observada dentro de la corrida con skill, pero no es una diferencia causal medida |

## Qué aportó el skill

La contribución observable no fue solo estética: convirtió la revisión en un
procedimiento reproducible, obligó a conservar filas originales, separó alertas
de hechos confirmados, definió controles contra falsos positivos y evitó
imprimir el valor de `token=`. También delimitó cuándo activarse y cuándo no.

No es válido afirmar cuánto mejoró frente a una sesión sin skill porque esa
condición independiente no se pudo ejecutar en esta interfaz. La comparación
debe completarse manualmente en dos sesiones nuevas si el agente/proveedor
permite cerrarlas: misma solicitud, mismo CSV, sin cargar recursos en la
primera y comprobando `SKILL.md`/`detection-rules.md` en la segunda.

Tiempo y tokens: no disponible de forma confiable.
