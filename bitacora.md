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
| Iteraciones (veces que le tuviste que volver a pedir algo) | 3 | 0 |
| Casos de aceptacion que cumple (0-6) | 3/6 contra la spec SDD | 6/6 |
| Pruebas automatizadas que pasan | Las pruebas SDD no compilan en `vibe`; prueba propia previa no confiable | 23 |
| Archivos en `lib/` | 1 | 11 |
| Lineas de codigo en `lib/` | 282 | 332 |
| `domain/` depende de Flutter? | No existe `domain/` | No |
| Existe separacion `presentation/domain/data`? | No | Si |
| El agente agrego algo que nadie pidio? | Si: pesos 75%/100%/125% definidos por el agente | No en la implementacion; solo rechazo de negativos por clarify |
| Se puede agregar otra estrategia sin modificar el calculo existente? | No | Si |

## Metrica secundaria opcional

| Metrica secundaria opcional | Rama vibe | Rama sdd |
| --- | --- | --- |
| Tiempo aproximado hasta cumplir los 6 escenarios | No registrado | No registrado |

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

## Parte 10: pruebas de SDD copiadas temporalmente en vibe

Comandos ejecutados:

```bash
git checkout vibe
git checkout sdd -- test/
flutter test
```

Resultado: no compilo. Las pruebas de `sdd` importan clases y archivos que
existen en la arquitectura SDD, pero no existen en la rama `vibe`, por ejemplo:

- `lib/data/redondeo_exacto.dart`
- `lib/data/redondeo_hacia_arriba.dart`
- `lib/domain/calcular_division.dart`
- `lib/domain/validar_entrada.dart`
- `lib/presentation/divisor_controller.dart`
- `lib/presentation/pantalla_divisor.dart`

Conclusion de testabilidad: las pruebas no se pueden reutilizar directamente en
`vibe` porque la app fue construida principalmente en `main.dart` y no expone
las mismas unidades pequenas de dominio, datos y presentacion. Para que estas
pruebas corran en `vibe` habria que mover o extraer el calculo, la validacion,
las estrategias de redondeo y la pantalla hacia archivos con una estructura
compatible con `presentation/domain/data`.

Como las pruebas copiadas no compilaron, se intento ejecutar la app manualmente:

```bash
flutter run -d windows
```

Resultado: no arranco en Windows porque falta la toolchain de Visual Studio para
Flutter desktop.

Luego se ejecuto:

```bash
flutter run -d emulator-5554
```

Resultado: la app de `vibe` construyo el APK debug, se instalo en el emulador
Android y arranco correctamente. La comprobacion de los seis escenarios queda
como revision manual sobre la interfaz, porque no se pudieron reutilizar las
pruebas automatizadas de `sdd` sin reestructurar la rama `vibe`.

Revision de los seis escenarios de aceptacion de la spec SDD contra el codigo
de `vibe`:

| Escenario | Resultado en `vibe` |
| --- | --- |
| 100.00, 4 personas, 10% propina, exacto -> 27.50 | Cumple el calculo normal si no hay pagos fijos ni personas diferenciadas. |
| 90.00, 3 personas, 0% propina, exacto -> 30.00 | Cumple el calculo normal. |
| 50.00 y 0 personas -> "Debe haber al menos una persona" y sin resultado | No cumple: la app no muestra ese mensaje; convierte personas invalidas en 0 y muestra resultados en 0. |
| monto "abc" -> "Monto inválido" | No cumple: `double.tryParse(...) ?? 0` trata el monto invalido como 0 y no muestra error. |
| 10.00, 3 personas, 0%, exacto -> 3.33 | Cumple el calculo normal mostrado con dos decimales. |
| 10.00, 3 personas, 0%, hacia arriba -> 4.00 | No cumple: `vibe` no tiene selector de redondeo exacto/hacia arriba. |

Resultado contra los criterios de aceptacion SDD: `vibe` cumple 3 de 6 por
revision del codigo y ejecucion de la app en emulador. Para correr las pruebas
automatizadas habria que extraer clases equivalentes a las de `sdd` o reescribir
las pruebas para la interfaz monolitica de `vibe`.

Distincion pedida por la guia:

1. Testabilidad y estructura: las pruebas de dominio de `sdd` no se pueden
   reutilizar en `vibe` porque `vibe` no tiene contratos ni puntos de prueba
   equivalentes. No existen `domain/`, `data/` ni `presentation/`; solo existe
   `lib/main.dart`.
2. Comportamiento: que las pruebas no compilen no significa por si solo que la
   app `vibe` funcione mal. Por revision manual/codigo, la interfaz cubre 3 de
   los 6 escenarios de la spec SDD y no cubre las validaciones ni el redondeo
   hacia arriba.

Verificaciones SOLID simples en `vibe`:

```bash
grep -rn "package:flutter" lib/
```

Resultado equivalente en PowerShell:

```text
lib/main.dart:1:import 'package:flutter/material.dart';
```

Interpretacion: no hay una capa libre de Flutter que concentre el dominio; el
unico archivo de `lib/` depende directamente de Flutter.

```bash
ls lib/
```

Resultado:

```text
main.dart
```

Interpretacion: no existe `domain/` en `vibe`.

Despues de la copia temporal de pruebas se ejecuto:

```bash
git restore --source=HEAD --staged --worktree test/
```

Resultado: `test/` volvio a su estado original en la rama `vibe`.

## Parte 11: comparacion de mantenibilidad

Comando ejecutado:

```bash
git diff vibe sdd --stat
```

Resumen del resultado:

```text
59 files changed, 6423 insertions(+), 408 deletions(-)
```

El diff incluye los artefactos de Spec Kit, la constitucion, la spec, el plan,
las tareas, las pruebas y la reorganizacion de `lib/`. En codigo de app, la
diferencia principal es que `vibe` concentra la app en `lib/main.dart`, mientras
que `sdd` separa responsabilidades en 11 archivos:

```text
lib/domain/
lib/data/
lib/presentation/
lib/main.dart
```

### Si volviera en dos semanas

Retomaria mas facilmente la rama `sdd`. Tiene spec, plan, tareas, pruebas y
archivos con responsabilidades pequenas. En `vibe`, tendria que releer casi todo
`main.dart` para entender que parte valida, que parte calcula, que parte dibuja
y que decisiones fueron agregadas durante la conversacion.

### Si un companero se suma manana

En `sdd` le mandaria:

- `.specify/memory/constitution.md`
- `specs/001-dividir-cuenta/spec.md`
- `specs/001-dividir-cuenta/plan.md`
- `specs/001-dividir-cuenta/tasks.md`
- `test/casos_de_prueba.dart`
- `test/division_test.dart`

Con esos archivos puede entender requisitos, arquitectura, tareas y pruebas sin
depender de la conversacion original. En `vibe`, principalmente tendria que
mandarle `lib/main.dart` y explicarle de palabra las decisiones que quedaron
mezcladas en la interfaz.

### Si el cliente pide redondear al multiplo de 5 mas cercano

En `sdd` se sabe exactamente que hacer: crear una nueva implementacion en
`lib/data/`, por ejemplo `redondeo_multiplo_cinco.dart`, que implemente
`EstrategiaRedondeo`. El archivo que no deberia tocarse es
`lib/domain/calcular_division.dart`, porque el calculo depende de la abstraccion
y no de una clase concreta.

En `vibe` no hay una interfaz de estrategia ni separacion de dominio, asi que
habria que modificar `lib/main.dart` directamente. Eso aumenta el riesgo de
tocar al mismo tiempo calculo, estado e interfaz.

Conclusion de mantenibilidad: `sdd` requiere mas archivos y mas artefactos, pero
deja mas claro donde leer, probar y extender. `vibe` avanzo rapido para una app
visual, pero es mas dificil de comprobar y modificar sin reabrir decisiones de
diseno dentro del mismo archivo.
