# Investigación de logs sintéticos — sesión independiente con skill

## Archivos del skill leídos realmente

- `incident-investigator/SKILL.md`
- `incident-investigator/references/detection-rules.md`

También se leyó y verificó el archivo fuente `logs_sinteticos.csv`. No se modificó el CSV ni se consultaron sus IP en servicios externos. El CSV contiene las columnas obligatorias `timestamp`, `ip`, `user`, `event`, `result` y `detail`, con 93 registros de datos más el encabezado. La numeración de filas conserva el encabezado como fila 1.

## Método aplicado

Se siguió el procedimiento del skill: verificación de columnas y timestamps, lectura de las reglas, revisión cronológica de ventanas inclusivas de ≤5 minutos, coincidencia exacta de `event` y `result`, cita de filas originales y separación entre alertas heurísticas y hechos confirmados. Las IP se trataron únicamente como valores del fixture sintético.

## Hallazgos

| alerta | severidad orientativa | regla | timestamp | ip | usuario | filas/evidencia | limitaciones |
|---|---|---|---|---|---|---|---|
| Fuerza bruta probable | Alta | ≥6 filas exactas `event=login`, `result=failed`, misma IP y usuario dentro de ≤5 min | `01:14–01:18` (-05:00); éxito posterior `01:19` | `198.51.100.77` | `admin` | Filas **17, 19, 20, 22, 23, 25, 26 y 27**: 8 fallos con `incorrect password`. Fila **28**: `login/success` un minuto después, dentro de los 5 minutos siguientes. | Es una alerta de patrón; no prueba compromiso, identidad, intención ni causalidad del éxito posterior. |
| Password spraying probable | Alta | Misma IP con `login/failed` exacto contra ≥5 usuarios distintos en ≤5 min | `02:01–02:03` (-05:00) | `203.0.113.89` | `ana`, `carlos`, `luisa`, `diego`, `maria`, `sofia` | Filas **67, 68, 70, 71, 73 y 74**; 6 usuarios distintos, todos con `incorrect password`. | El patrón no permite atribuir intención, autoría ni éxito del ataque. |
| Token potencialmente expuesto | Alta | `detail` contiene `token=` | `2026-11-05T01:27:00-05:00` | `192.0.2.44` | `api_service` | Fila **33**: `event=debug`, `result=warning`, `detail=token=[REDACTED]; debug output`. | No se puede determinar si el valor es válido, utilizable o real; el valor completo se omite deliberadamente. |
| Cambio de rol no aprobado según el registro | Alta | Exactamente `event=role_change`, `result=success` y `detail` contiene `approved=false` | `2026-11-05T01:50:00-05:00` | `203.0.113.42` | `guest` | Fila **59**: el detalle indica `role=user->admin; approved=false`. | Solo se reporta lo que indica el registro; no se infiere culpabilidad ni abuso intencional. |

## Actividad normal y controles de falsos positivos

- Los `login/success` con `detail=ordinary login` son actividad normal registrada. Un éxito aislado no constituye por sí solo un incidente.
- Las filas **38, 39 y 41** son tres `login/failed` para `maria` desde `192.0.2.25`, entre `01:35` y `01:37`. No alcanzan el umbral de seis fallos para fuerza bruta. La fila **42** (`login/success` a `01:38`) no cambia ese conteo.
- Las filas **60 y 61** son un fallo de `diego` seguido por un éxito un minuto después; es un fallo aislado y no alcanza el umbral de fuerza bruta.
- Las filas **78, 80, 81, 82, 83 y 84** son `healthcheck/success` de `healthbot` con `scheduled monitoring`. No son `login/failed`, por lo que no cuentan en las ventanas de fuerza bruta ni spraying.
- No se mezclaron éxitos ni `healthcheck` con los conteos: las alertas de autenticación usan coincidencias exactas de `event=login` y `result=failed`.

## Resumen, incertidumbre y limitaciones

Se identifican **cuatro alertas justificadas**: fuerza bruta probable, password spraying probable, token potencialmente expuesto y cambio de rol no aprobado según el registro. La evidencia confirma que esos eventos y patrones aparecen en las filas citadas; no confirma intrusión, compromiso de cuentas, identidad, intención, culpabilidad ni abuso exitoso.

No se identifican duplicados de forma inequívoca, así que no se aplicó una deduplicación inventada. El hash SHA-256 observado del CSV durante la revisión fue `7D8219E9F8C9DD995BE0C2DC038F4F7E67F0F12446B4FDC07FADF508BEFB5DA8`; se incluye solo como referencia de integridad local. Ningún token completo aparece en este informe.
