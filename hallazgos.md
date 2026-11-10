# Hallazgos — `logs_sinteticos.csv`

Fuente revisada sin modificar: `C:\Users\brisn\Downloads\logs_sinteticos.csv`.
El encabezado es la fila 1. Las IP pertenecen al fixture de clase y no fueron
consultadas externamente.

| alerta | severidad orientativa | regla | timestamp | ip | usuario | filas/evidencia | limitaciones |
|---|---|---|---|---|---|---|---|
| Fuerza bruta probable | Alta orientativa | ≥6 `login/failed` del mismo IP y usuario en ≤5 min | 01:14–01:18; éxito 01:19 | 198.51.100.77 | admin | Fallos: 17, 19, 20, 22, 23, 25, 26, 27; éxito posterior: 28 | Alerta heurística; no prueba compromiso |
| Password spraying probable | Alta orientativa | Misma IP contra ≥5 usuarios distintos en ≤5 min | 02:01–02:03 | 203.0.113.89 | ana, carlos, luisa, diego, maria, sofia | 67, 68, 70, 71, 73, 74 | No atribuye actor ni intención |
| Token potencialmente expuesto | Alta orientativa | `detail` contiene `token=` | 01:27 | 192.0.2.44 | api_service | Fila 33; valor: `[REDACTED]` | No se muestra el valor completo |
| Cambio de rol no aprobado según el registro | Alta orientativa | `role_change/success` y `approved=false` | 01:50 | 203.0.113.42 | guest | Fila 59 | Solo describe lo que indica el registro; no infiere culpabilidad |

## Control de falsos positivos

- Las filas 38, 39 y 41 son tres `login/failed` para `maria` desde la misma
  IP. Aunque están dentro de pocos minutos, no alcanzan el umbral de seis
  fallos para fuerza bruta. La fila 42 es un éxito posterior y no convierte por
  sí sola el grupo en una alerta de fuerza bruta.
- Las filas 78, 80–84 son `healthcheck/success`, no `login/failed`; no cuentan
  para ninguna ventana de autenticación fallida.

## Incertidumbre

Estas son alertas justificadas por reglas didácticas, no conclusiones forenses.
No se infieren intrusión, identidad, intención, culpabilidad ni abuso exitoso.
