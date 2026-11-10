# Análisis independiente de `logs_sinteticos.csv` — sesión sin skill

## Alcance

Se analizó únicamente el archivo local `logs_sinteticos.csv`. No se cargaron instrucciones ni scripts de ningún skill, no se consultaron las IP y no se modificó el CSV. El encabezado es la fila 1; las referencias usan las filas originales del archivo.

Columnas observadas: `timestamp`, `ip`, `user`, `event`, `result` y `detail`.

## Incidentes justificables

| Señal | Evidencia | Evaluación |
|---|---|---|
| Fuerza bruta probable | La IP `198.51.100.77` intentó acceder como `admin` con `login/failed` en las filas 17, 19, 20, 22, 23, 25, 26 y 27, entre `01:14` y `01:18`. La fila 28 registra `login/success` a `01:19` desde la misma IP y usuario. | Ocho fallos en un intervalo de cinco minutos y un éxito un minuto después justifican una alerta de fuerza bruta probable. No prueban compromiso, identidad ni intención. |
| Password spraying probable | La IP `203.0.113.89` falló contra seis usuarios distintos en las filas 67 (`ana`), 68 (`carlos`), 70 (`luisa`), 71 (`diego`), 73 (`maria`) y 74 (`sofia`), entre `02:01` y `02:03`. | La misma IP alcanzó seis cuentas en tres minutos; es una señal compatible con password spraying. El registro no permite atribuir el comportamiento a una persona o actor concreto. |
| Token potencialmente expuesto | La fila 33, a `01:27`, contiene `event=debug`, `result=warning` y un `detail` con `token=`. | Hay una posible exposición de secreto en una salida de depuración. El valor no se reproduce: `[REDACTED]`. El CSV no permite determinar si el token es válido o utilizable. |
| Cambio de rol no aprobado según el registro | La fila 59, a `01:50`, registra `role_change/success` para `guest`, con `role=user->admin; approved=false`. | El evento documenta un cambio de rol marcado como no aprobado. No se infiere culpabilidad, intrusión ni causa del cambio. |

## Actividad normal o insuficiente para clasificar como incidente

- La mayoría de los `login/success` con `detail=ordinary login` son actividad normal registrada; por ejemplo, filas 2, 4–6, 8–16 y 18.
- Las filas 38, 39 y 41 son tres fallos para `maria` desde `192.0.2.25` entre `01:35` y `01:37`. No alcanzan seis fallos, por lo que no justifican una alerta de fuerza bruta. La fila 42 es un éxito posterior, pero no cambia ese umbral.
- La fila 60 es un fallo aislado para `diego`, seguido por un éxito en la fila 61. Tampoco alcanza el umbral de fuerza bruta.
- Las filas 78 y 80–84 son `healthcheck/success` de `healthbot` con `scheduled monitoring`. No son intentos `login/failed` y no deben contarse como fallos de autenticación.
- La fila 57 (`access/denied` sobre `/admin`) es una señal de acceso denegado que merece contexto, pero por sí sola no satisface las reglas anteriores ni demuestra una escalada.

## Conclusión

El archivo contiene cuatro señales de seguridad sustentadas por filas concretas: fuerza bruta probable (17, 19, 20, 22, 23, 25–28), password spraying probable (67, 68, 70, 71, 73, 74), token potencialmente expuesto (33) y cambio de rol no aprobado según el registro (59).

Estas son clasificaciones heurísticas basadas únicamente en el CSV. No constituyen una conclusión forense: no permiten confirmar compromiso, atribuir acciones, determinar intención ni validar el token. Las IP se trataron como valores del fixture local y no fueron consultadas externamente.
