# Reglas de detección

Lee esta referencia antes de clasificar. Ordena una vista de trabajo por
`timestamp`, conserva la fila original y usa una ventana inclusiva de `≤ 5`
minutos, incluyendo ambos extremos. Cuenta solo coincidencias exactas de
`event` y `result`.

## Fuerza bruta probable

Señala una alerta cuando haya al menos 6 filas con `event=login` y
`result=failed` desde la misma IP hacia el mismo usuario dentro de una ventana
de 5 minutos. Cita todas las filas de la ventana. Revisa por separado si existe
después un `event=login` y `result=success` de esa IP/usuario dentro de los 5
minutos siguientes y repórtalo como contexto, no como prueba de causalidad.

## Password spraying probable

Señala una alerta cuando una misma IP genere filas `event=login` y
`result=failed` contra al menos 5 usuarios distintos dentro de una ventana de 5
minutos. Cita las filas y la lista de usuarios distintos.

## Token potencialmente expuesto

Si `detail` contiene `token=`, señala un token potencialmente expuesto. Cita la
fila original, pero sustituye el valor completo por `[REDACTED]`. Nunca imprimas
el token.

## Cambio de rol no aprobado según el registro

Señala el registro cuando `event=role_change`, `result=success` y `detail`
contenga `approved=false`. Describe únicamente que el registro indica un
cambio no aprobado; no infieras culpabilidad ni atribuyas el evento a una
persona.

## Controles de falsos positivos

- Tres fallos aislados no alcanzan el umbral de fuerza bruta.
- Un `healthcheck` no es un `login/failed` y no cuenta para ninguna de esas
  ventanas.
- Si no puedes identificar duplicados de forma inequívoca, declara la
  limitación y no inventes una regla de deduplicación.

Estas reglas son heurísticas didácticas. No demuestran intrusión, intención,
atribución ni abuso exitoso.
