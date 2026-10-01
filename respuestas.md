# Respuestas

## 1. Metricas, agente y resultado general

Agente usado: Codex CLI de OpenAI. La version identificada fue `codex-cli 0.155.0-alpha.16.3`. El modelo usado fue GPT-6 y no cambie el nivel de razonamiento entre ramas; use la configuracion por defecto de la sesion. El archivo de instrucciones del agente fue `AGENTS.md`, creado en la raiz del proyecto para la rama `sdd`.

Caso de Git de la Parte 1.5: Caso A. `git rev-parse --show-toplevel` indico que la carpeta no estaba dentro de un repositorio Git, asi que se inicializo un repositorio propio para este proyecto.

| Metrica | Rama vibe | Rama sdd |
| --- | --- | --- |
| Iteraciones | 3 | 0 correctivas despues de la especificacion |
| Casos de aceptacion que cumple (0-6) | 3/6 contra la spec SDD | 6/6 |
| Pruebas automatizadas que pasan | Las pruebas SDD no compilan en `vibe`; la prueba propia previa no fue confiable | 23 |
| Archivos en `lib/` | 1 | 11 |
| Lineas de codigo en `lib/` | 282 | 332 |
| ¿`domain/` depende de Flutter? | No existe `domain/` | No |
| ¿Existe separacion `presentation/domain/data`? | No | Si |
| ¿El agente agrego algo que nadie pidio? | Si: pesos 75% / 100% / 125% para pagar menos, normal o mas | No en la implementacion; solo rechazo de negativos decidido en clarify |
| ¿Se puede agregar otra estrategia sin modificar el calculo existente? | No | Si |

El enfoque que cumplio mejor los seis escenarios fue `sdd`: paso los 6 escenarios de aceptacion y las pruebas automatizadas. `vibe` resolvio parte del comportamiento visual y agrego opciones utiles, pero al compararlo contra la spec SDD solo cubrio 3 de 6 escenarios.

En `vibe`, las decisiones se completaron durante la conversacion y tambien por cuenta del agente: por ejemplo, el agente decidio que “pagar menos” valia 75% y “pagar mas” valia 125%. En `sdd`, las decisiones principales quedaron explicitas en artefactos: Constitution, spec, clarificaciones, plan, tasks y pruebas. El tiempo no se registro; aun si se hubiera registrado, seria un dato secundario porque depende del equipo, emulador, conexion, configuracion y bloqueos de herramientas, no solo de la calidad del enfoque.

## 2. Parte 10: pruebas de `sdd` contra `vibe`

Al llevar las pruebas de `sdd` a `vibe` con:

```bash
git checkout vibe
git checkout sdd -- test/
flutter test
```

no compilaron. El primer error fue:

```text
test/data/estrategia_redondeo_test.dart:2:8: Error: Error when reading 'lib/data/redondeo_exacto.dart': El sistema no puede encontrar la ruta especificada
import 'package:participacion_semana7/data/redondeo_exacto.dart';
```

Ese error no demuestra automaticamente que la app `vibe` funcione mal. Demuestra una diferencia de arquitectura y testabilidad: las pruebas de `sdd` esperan clases de dominio, datos y presentacion (`lib/domain`, `lib/data`, `lib/presentation`), pero `vibe` concentra la app en `lib/main.dart`.

Despues se ejecuto la app de `vibe` en el emulador Android:

```bash
flutter run -d emulator-5554
```

La app construyo el APK debug, se instalo y arranco. La comparacion manual/codigo contra los seis escenarios fue:

| Escenario | Resultado en `vibe` |
| --- | --- |
| 100.00, 4 personas, 10% propina, exacto -> 27.50 | Cumple el calculo normal si no se activan pagos fijos ni diferenciados. |
| 90.00, 3 personas, 0% propina, exacto -> 30.00 | Cumple el calculo normal. |
| 50.00 y 0 personas -> “Debe haber al menos una persona” | No cumple: no muestra ese mensaje; calcula con 0. |
| monto `abc` -> “Monto inválido” | No cumple: `double.tryParse(...) ?? 0` convierte el monto invalido en 0. |
| 10.00, 3 personas, 0%, exacto -> 3.33 | Cumple el calculo mostrado con dos decimales. |
| 10.00, 3 personas, 0%, hacia arriba -> 4.00 | No cumple: no existe selector de redondeo hacia arriba. |

Resultado: `vibe` cumple 3/6 contra la spec SDD.

## 3. Verificaciones SOLID en `sdd` y `vibe`

Evidencia en `sdd`:

```text
grep -rn "package:flutter" lib/domain/
# sin salida
```

Esto pasa la regla de la Constitution: `lib/domain/` no debe importar Flutter.

```text
grep -rn -E "RedondeoExacto\(\)|RedondeoHaciaArriba\(\)" lib/
lib/data/redondeo_exacto.dart:4:  const RedondeoExacto();
lib/data/redondeo_hacia_arriba.dart:4:  const RedondeoHaciaArriba();
lib/main.dart:15:    redondeoExacto: RedondeoExacto(),
lib/main.dart:16:    redondeoHaciaArriba: RedondeoHaciaArriba(),
```

Las apariciones en `data` son declaraciones de constructores; las instanciaciones concretas estan en `main.dart`. Esto cumple la regla de la Constitution: `main.dart` es el unico punto de composicion donde se instancian implementaciones concretas.

```text
grep -n -E "is Redondeo|as Redondeo" lib/domain/calcular_division.dart
# sin salida
```

Esto evidencia LSP/OCP: `CalcularDivision` no pregunta de que tipo concreto es la estrategia.

```text
grep -n -E "toStringAsFixed|inválido|al menos una persona" lib/domain/calcular_division.dart
# sin salida
```

Esto evidencia SRP: el calculo no formatea ni valida mensajes.

Evidencia en `vibe`:

```text
grep -rn "package:flutter" lib/
lib/main.dart:1:import 'package:flutter/material.dart';
```

```text
ls lib/
main.dart
```

En `vibe` no existe `domain/`, por lo tanto no hay una capa de dominio libre de Flutter que pueda verificarse. La diferencia la explica la Constitution de `sdd`, que exige capas `presentation/domain/data`, regla de dependencia `presentation -> domain <- data`, dominio sin Flutter, SRP, OCP/LSP y DIP. En `vibe` esas reglas no fueron externalizadas antes de programar, asi que el agente produjo una solucion monolitica.

## 4. Preguntas relevantes de `/speckit-clarify`

La pregunta relevante fue sobre valores negativos: que debia pasar si el monto, la propina o el numero de personas eran negativos.

La ambiguedad era real porque la spec original hablaba de monto total, personas y propina, pero no decia si valores negativos debian rechazarse, corregirse automaticamente o tratarse como cero. La decision en `sdd` fue rechazar valores negativos con mensaje de error.

Si hubo otra pregunta, no fue tan relevante para esta app como la de negativos. Gran parte de la ambiguedad ya estaba reducida porque la spec tenia seis escenarios concretos, modo exacto, modo hacia arriba, mensajes esperados y la restriccion de no usar red ni base de datos.

En `vibe`, esa clase de decisiones no quedo documentada como requisito antes de programar. Algunas las tome yo explicitamente durante la conversacion, por ejemplo pedir pagos fijos y personas que paguen mas o menos. Otras las completo el agente por su cuenta, como asignar pesos 75% / 100% / 125% para repartir el monto.

## 5. `git diff vibe sdd --stat` y cosas no pedidas

El comando:

```bash
git diff vibe sdd --stat
```

mostro una diferencia grande entre ramas. En una ejecucion quedo resumido asi:

```text
59 files changed, 6423 insertions(+), 408 deletions(-)
```

La mayor parte de lo agregado por `sdd` corresponde a artefactos pedidos por la practica: `.specify/`, `.agents/skills`, Constitution, spec, plan, tasks, tests y estructura por capas. Eso no fue funcionalidad extra de producto, sino soporte metodologico.

La rama que si agrego una decision no pedida fue `vibe`: para las personas que pagan menos o mas, el agente eligio pesos concretos de 75%, 100% y 125%. Yo pedi la opcion de pagar menos o pagar mas, pero no especifique esos porcentajes. Ese es un ejemplo claro de una decision completada por el agente.

## 6. Otra herramienta SDD y cuando elegir `vibe`

Elegi OpenSpec para compararla brevemente. Segun su documentacion, OpenSpec tiene un esquema `spec-driven` basado en archivos de especificacion que definen que debe hacer el sistema y documentos de diseno que explican el “por que” de las decisiones tecnicas. En cambio, GitHub Spec Kit se presenta como un toolkit para llevar la especificacion por un flujo de specify, plan, tasks, implement y converge con agentes de codigo. GitHub tambien describe Spec Kit como una forma de poner la especificacion en el centro del proceso de ingenieria.

Fuentes consultadas:

- GitHub Spec Kit: https://github.com/github/spec-kit
- Documentacion de Spec Kit: https://github.com/github/spec-kit/blob/main/docs/index.md/
- OpenSpec `spec-driven`: https://openspec.dev/docs/schemas/spec-driven

Preferiria OpenSpec si quiero mantener especificaciones estructuradas y personalizables como artefactos del repositorio, especialmente si mi equipo quiere adaptar schemas o separar con fuerza el “que” y el “por que” antes del codigo. Preferiria Spec Kit cuando quiero un flujo guiado listo para usar con comandos de agente y artefactos encadenados desde Constitution hasta implementacion.

Una situacion real y pequena donde si elegiria `vibe`: una pantalla rapida para uso personal o una maqueta visual que quiero probar hoy, por ejemplo una calculadora interna, un prototipo de formulario o una demo para validar si una idea se entiende. Si el costo de equivocarse es bajo y todavia estoy explorando la interfaz, `vibe` puede ser razonable. Cuando ya hay reglas de negocio, pruebas, mantenimiento por otras personas o cambios futuros esperados, conviene SDD.
