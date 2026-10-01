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
