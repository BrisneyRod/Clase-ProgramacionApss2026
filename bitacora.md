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
| Iteraciones (veces que le tuviste que volver a pedir algo) |  |  |
| Casos de aceptacion que cumple (0-6) |  |  |
| Pruebas automatizadas que pasan |  |  |
| Archivos en `lib/` |  |  |
| Lineas de codigo en `lib/` |  |  |
| ¿`domain/` depende de Flutter? |  |  |
| ¿Existe separacion `presentation/domain/data`? |  |  |
| ¿El agente agrego algo que nadie pidio? |  |  |
| ¿Se puede agregar otra estrategia sin modificar el calculo existente? |  |  |

## Metrica secundaria opcional

| Metrica secundaria opcional | Rama vibe | Rama sdd |
| --- | --- | --- |
| Tiempo aproximado hasta cumplir los 6 escenarios |  |  |
