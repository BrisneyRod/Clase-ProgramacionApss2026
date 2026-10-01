# Mapa del repositorio

Este repositorio contiene trabajos de la materia en varias ramas. Para no mezclar entregas, esta es la guia de que corresponde a cada cosa.

## Rama `main`

Uso principal: conservar entregas generales y respuestas finales.

Contenido versionado actual:

| Ruta | Corresponde a | Nota |
| --- | --- | --- |
| `parte_a_contador/` | Deber/participacion anterior | Parte A del trabajo del contador. |
| `parte_b_conexion/` | Deber/participacion anterior | Parte B del trabajo de conexion. |
| `RESPUESTAS.md` | Deber/participacion anterior | Respuestas del trabajo anterior. |
| `demo.mp4` | Deber/participacion anterior | Video demo del trabajo anterior. |
| `respuestas.md` | Participacion semana 7 | Respuestas finales de la comparacion `vibe` vs `sdd`. |

Nota sobre Windows: `RESPUESTAS.md` y `respuestas.md` solo se diferencian por mayusculas/minusculas. GitHub los distingue, pero Windows puede mostrarlos de forma confusa. No borrar ninguno sin revisar primero, porque pertenecen a trabajos distintos.

## Rama `vibe`

Uso principal: version de la app divisor de cuenta hecha con vibe coding.

Contenido importante:

| Ruta | Corresponde a |
| --- | --- |
| `lib/main.dart` | App divisor de cuenta de la rama `vibe`. |
| `bitacora.md` | Registro de iteraciones, metricas y comparacion. |
| `test/` | Estado original/restaurado de tests de la rama `vibe`. |

Resultado observado: la app quedo concentrada principalmente en `lib/main.dart`; no tiene separacion `presentation/domain/data`.

## Rama `sdd`

Uso principal: version de la app divisor de cuenta hecha con Spec Kit / SDD.

Contenido importante:

| Ruta | Corresponde a |
| --- | --- |
| `AGENTS.md` | Instrucciones del agente. |
| `.specify/` | Configuracion y artefactos base de Spec Kit. |
| `.specify/memory/constitution.md` | Constitution con reglas SOLID y arquitectura. |
| `specs/001-dividir-cuenta/` | Spec, plan, research, tasks y contratos. |
| `lib/domain/` | Entidades, validacion, caso de uso e interfaz de redondeo. |
| `lib/data/` | Estrategias concretas de redondeo. |
| `lib/presentation/` | Controller, formateador y pantalla. |
| `test/casos_de_prueba.dart` | Tabla de escenarios de aceptacion. |
| `test/division_test.dart` | Pruebas de dominio y LSP. |
| `test/pantalla_test.dart` | Pruebas de widget pedidas por la practica. |
| `bitacora.md` | Registro de metricas y verificaciones SDD. |

Resultado observado: `flutter test`, `flutter analyze` y `flutter build apk --debug` pasaron en esta rama.

## Ramas que se entregan para la participacion semana 7

La participacion semana 7 se revisa en estas tres ramas:

- `main`: contiene `respuestas.md`.
- `vibe`: contiene la app hecha por vibe coding y la bitacora de esa rama.
- `sdd`: contiene Spec Kit, artefactos, app, pruebas y verificaciones.

## Recomendacion para ordenar despues de entregar

Para evitar romper entregas ya subidas, no conviene mover archivos dentro de estas ramas antes de la calificacion. Si despues se quiere limpiar el repositorio, lo mas seguro es crear una rama nueva, por ejemplo:

```bash
git checkout -b ordenar-repositorio
```

Ahi se pueden reorganizar carpetas por fecha o por deber sin afectar lo entregado. Por ejemplo:

```text
2026-09-deber-contador/
2026-10-participacion-semana7/
```

Pero esa reorganizacion deberia hacerse despues de revisar que el profesor no espera rutas exactas en `main`, `vibe` o `sdd`.
