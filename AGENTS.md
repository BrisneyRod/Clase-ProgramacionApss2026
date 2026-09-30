# Instrucciones del agente

Agente usado: Codex CLI.

Version detectada:

```text
codex-cli 0.155.0-alpha.16.3
```

Modelo usado en esta practica: Codex basado en GPT-5.
Configuracion de razonamiento: la misma sesion/configuracion usada para la rama `vibe`.

## Reglas para esta rama SDD

- Trabajar solo en la rama `sdd`.
- No modificar `main` ni la rama `vibe`.
- Mantener el alcance del MVP: una app Flutter de una pantalla para dividir una cuenta.
- Usar SDD antes de implementar: constitution, specify, clarify, plan, tasks, analyze e implement.
- Mantener las reglas SOLID y arquitectura limpia en la Constitution.
- Separar responsabilidades entre `presentation`, `domain` y `data` cuando exista codigo de aplicacion.
- El dominio no debe depender de Flutter.
- No agregar funciones fuera del alcance acordado sin registrarlas como decision.
- Registrar iteraciones, decisiones y metricas en `bitacora.md`.
- Verificar con comandos cuando el entorno lo permita y anotar cualquier bloqueo.
