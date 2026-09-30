# Bitacora de comparacion: vibe vs SDD

## Regla para contar iteraciones

La solicitud inicial para empezar el trabajo de cada rama no cuenta como iteracion.
Cuenta como iteracion cada nuevo mensaje enviado al agente despues de esa solicitud
para pedir una correccion, cambio, explicacion o accion adicional.

Las herramientas que el agente ejecute por su cuenta no cuentan como iteraciones.
Se aplicara la misma regla en las dos ramas y se anotara cualquier decision de
conteo que pueda afectar la comparacion.

Ejemplos:

| Mensaje | Conteo |
| --- | --- |
| Solicitud inicial | No cuenta |
| "Falta la propina" | Iteracion 1 |
| "Corrige este error" | Iteracion 2 |
| "Ahora agrega validacion" | Iteracion 3 |

## Preparacion del repositorio

Resultado de `git rev-parse --show-toplevel`: Caso A. La carpeta actual no esta
dentro de un repositorio Git.

Commit inicial creado con el mensaje:

```text
proyecto base de flutter, sin tocar
```

El hash exacto se verifica con `git log --oneline --all`.

Ramas creadas desde el mismo commit inicial:

```text
main
sdd
vibe
```

Remoto configurado:

```text
origin https://github.com/BrisneyRod/Clase-ProgramacionApss2026.git
```

| Metrica | Rama vibe | Rama sdd |
| --- | --- | --- |
| Iteraciones (veces que le tuviste que volver a pedir algo) | 3 |  |
| Casos de aceptacion que cumple (0-6) | 6/6 por revision manual |  |
| Pruebas automatizadas que pasan | No confirmado: `flutter test` se bloqueo sin salida |  |
| Archivos en `lib/` | 1 |  |
| Lineas de codigo en `lib/` | 282 |  |
| `domain/` depende de Flutter? | No existe `domain/` |  |
| Existe separacion `presentation/domain/data`? | No |  |
| El agente agrego algo que nadie pidio? | Si: pesos 75%/100%/125% definidos por el agente |  |
| Se puede agregar otra estrategia sin modificar el calculo existente? | No |  |

## Metrica secundaria opcional

| Metrica secundaria opcional | Rama vibe | Rama sdd |
| --- | --- | --- |
| Tiempo aproximado hasta cumplir los 6 escenarios | No registrado |  |

## Decisiones de conteo

| Rama | Mensaje | Conteo |
| --- | --- | --- |
| vibe | "Hazme una app en Flutter para dividir la cuenta entre varias personas." | Solicitud inicial, no cuenta |
| vibe | "quiero que pongas opciones para gente que quiera pagar menos o quiera pagar mas" | Iteracion 1 |
| vibe | "tambien quiero que hagas que una persona ya tenga un valor como por default..." | Iteracion 2 |
| vibe | "falta la en el pago fijo poner cuantas personas pueden entrar ahi..." | Iteracion 3 |

## Verificaciones rama vibe

`flutter analyze` y `flutter test` se intentaron ejecutar, pero ambos comandos
se quedaron sin salida por mas de un minuto y fueron interrumpidos. La revision
disponible fue manual y con `git diff --check`.
