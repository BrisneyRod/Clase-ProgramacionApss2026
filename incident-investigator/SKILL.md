---
name: incident-investigator
description: Investiga archivos CSV sintéticos de autenticación y seguridad cuando el usuario pide investigar un incidente o encontrar intentos sospechosos/no autorizados, fuerza bruta, password spraying, tokens o secretos potencialmente expuestos y cambios de rol no aprobados, citando evidencia por fila. No se activa para peticiones descriptivas como “cuántos eventos hay por hora”, conteos, agregaciones, resúmenes o visualizaciones si el usuario excluye la investigación de amenazas; trabaja sin red y reporta alertas justificadas, no conclusiones forenses.
---

# Incident Investigator

Usa este skill sobre otro CSV compatible con las columnas `timestamp`, `ip`,
`user`, `event`, `result` y `detail`. No memorices respuestas de un archivo
concreto.

## Activación y límites

Actívalo cuando la petición solicite investigar un incidente, detectar actividad
sospechosa, clasificar alertas de seguridad, buscar secretos potencialmente
expuestos o revisar cambios de rol no aprobados en registros. No lo actives por
defecto si la petición solo solicita contar eventos, agruparlos por hora,
resumirlos o visualizarlos sin investigar amenazas. Si una solicitud combina
descripción e investigación, la parte descriptiva solo sirve como apoyo.

## Procedimiento

1. Inspecciona el CSV y verifica columnas obligatorias, formato y parseabilidad
   de `timestamp`. Confirma que el material sea sintético y no modifiques el
   archivo fuente.
2. Antes de clasificar alertas, abre
   [references/detection-rules.md](references/detection-rules.md). Esa referencia
   contiene los umbrales, coincidencias exactas y controles de falsos positivos.
3. Conserva los números de fila originales: el encabezado es la fila 1. Ordena
   una vista de trabajo por `timestamp` para revisar ventanas, sin perder la
   correspondencia con las filas originales.
4. Aplica cada regla únicamente cuando coincidan exactamente `event` y
   `result`. Reúne las filas, IP, usuarios y timestamps que la sustentan.
5. Distingue una alerta heurística de un hecho confirmado. No infieras
   compromiso, identidad, intención, culpabilidad ni éxito de un ataque.
6. En el informe, redacta cualquier valor posterior a `token=` como
   `[REDACTED]`; nunca muestres el token completo.
7. Reporta limitaciones, datos faltantes y duplicados ambiguos en vez de
   inventar una regla o un evento.

## Formato de salida

Incluye una tabla con estas columnas:

| alerta | severidad orientativa | regla | timestamp | ip | usuario | filas/evidencia | limitaciones |
|---|---|---|---|---|---|---|---|

Después de la tabla, agrega una narrativa breve basada en las filas, los
controles de falsos positivos, las notas de redacción y una declaración de
incertidumbre. Las conclusiones son alertas justificadas, no conclusiones
forenses.

## Seguridad

Trabaja únicamente con logs inventados/de aula y sin conexión a servicios
externos. No consultes las IP ni las trates como infraestructura real; pueden
ser rangos reservados para documentación. No inventes eventos, no modifiques el
CSV y no expongas tokens ni otros secretos. Si el material parece real o incluye
credenciales utilizables, detén el análisis y solicita un fixture seguro.
