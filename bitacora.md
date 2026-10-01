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

## Agente usado

Agente: Codex CLI.

Version:

```text
codex-cli 0.155.0-alpha.16.3
```

Archivo de instrucciones creado para el agente: `AGENTS.md`.

Modelo usado: Codex basado en GPT-5.
Configuracion de razonamiento: misma sesion/configuracion usada para `vibe` y `sdd`.

| Metrica | Rama vibe | Rama sdd |
| --- | --- | --- |
| Iteraciones (veces que le tuviste que volver a pedir algo) |  |  |
| Casos de aceptacion que cumple (0-6) |  |  |
| Pruebas automatizadas que pasan |  |  |
| Archivos en `lib/` |  |  |
| Lineas de codigo en `lib/` |  |  |
| `domain/` depende de Flutter? |  |  |
| Existe separacion `presentation/domain/data`? |  |  |
| El agente agrego algo que nadie pidio? |  |  |
| Se puede agregar otra estrategia sin modificar el calculo existente? |  |  |

## Metrica secundaria opcional

| Metrica secundaria opcional | Rama vibe | Rama sdd |
| --- | --- | --- |
| Tiempo aproximado hasta cumplir los 6 escenarios |  |  |

## Verificacion de especificacion SDD

Feature generada: `specs/001-dividir-cuenta/spec.md`.

Revision de comportamiento inventado:

- No se agregaron funciones nuevas al alcance funcional pedido.
- La spec excluye explicitamente pagos diferenciados, valores fijos, historial,
  persistencia, red, base de datos y monedas multiples.
- Se agregaron supuestos para hacer comprobables los terminos del enunciado:
  la propina es porcentaje del monto total; modo exacto muestra dos decimales;
  modo hacia arriba sube al entero mas cercano y se muestra con dos decimales.

Clarify hizo una pregunta relevante:

- Pregunta: Como debe comportarse la app si el usuario ingresa un monto, numero
  de personas o porcentaje de propina negativo?
- Respuesta registrada: rechazar cualquier valor negativo con mensaje de error.
- Evaluacion: fue relevante porque afecta validacion, pruebas y mensajes de
  error; la especificacion inicial solo cubria monto no numerico y 0 personas.

## Verificacion de tareas SDD

Archivo de tareas: `specs/001-dividir-cuenta/tasks.md`.

Resultado:

- Se generaron 44 tareas numeradas de `T001` a `T044`.
- Las tareas estan divididas en setup, fundamento, historias de usuario y polish.
- Cada historia tiene tareas de prueba antes de implementacion.
- Las tareas incluyen rutas concretas de archivos.

## Analyze SDD

Se reviso consistencia entre Constitution, spec, plan y tasks antes de programar.

Resultado:

- No quedan contradicciones abiertas entre los artefactos.
- No quedan placeholders ni marcadores `NEEDS CLARIFICATION` en la spec.
- Se detecto y corrigio una brecha de cobertura: el requisito de funcionar sin
  red ni base de datos estaba en spec/plan, pero faltaba una tarea explicita de
  verificacion. Se agrego `T042` en `tasks.md`.
- Las referencias a `package:flutter` en artefactos son intencionales: aparecen
  para prohibir imports de Flutter en `lib/domain/`.
