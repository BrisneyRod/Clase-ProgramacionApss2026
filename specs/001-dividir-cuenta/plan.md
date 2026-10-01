# Implementation Plan: Dividir cuenta

**Branch**: `sdd` | **Date**: 2026-09-30 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/001-dividir-cuenta/spec.md`

## Summary

Implementar una app Flutter de una sola pantalla para dividir una cuenta de
restaurante. La solucion usara estado local con `setState`, sin paquetes
externos, y separara calculo, validacion, redondeo, formato y presentacion
segun la Constitution.

## Technical Context

**Language/Version**: Dart con Flutter SDK estable

**Primary Dependencies**: Flutter SDK; sin paquetes externos

**Storage**: N/A; la app no usa red, archivos ni base de datos

**Testing**: `flutter test` para pruebas de dominio, controlador y widget

**Target Platform**: Flutter app local de una pantalla

**Project Type**: Aplicacion Flutter

**Performance Goals**: El calculo debe completarse inmediatamente para entradas
humanas de una pantalla; no hay procesamiento intensivo ni red

**Constraints**: Offline, sin paquetes externos, sin base de datos, sin red,
estado local con `setState`, una sola pantalla

**Scale/Scope**: MVP de una pantalla con 6 escenarios de aceptacion

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- SOLID: PASS. El plan separa validacion, calculo, redondeo, formato y UI.
- Capas: PASS. Se usaran `presentation`, `domain` y `data`.
- Dependencias: PASS. `presentation -> domain <- data`.
- Dominio sin Flutter: PASS. `lib/domain/` contendra solo Dart puro.
- Composicion en `main.dart`: PASS. Las implementaciones concretas se
  instanciaran solo en `main.dart`.
- Seguridad: PASS. No hay secretos, red ni credenciales.
- Pruebas criticas: PASS. Los 6 escenarios de aceptacion se convertiran en
  pruebas ejecutables.
- Explicabilidad: PASS. Las clases tienen nombres y responsabilidades concretas.

## Project Structure

### Documentation (this feature)

```text
specs/001-dividir-cuenta/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── ui-contract.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── main.dart
├── domain/
│   ├── cuenta.dart
│   ├── resultado.dart
│   ├── calcular_division.dart
│   ├── validar_entrada.dart
│   └── estrategia_redondeo.dart
├── data/
│   ├── redondeo_exacto.dart
│   └── redondeo_hacia_arriba.dart
└── presentation/
    ├── divisor_controller.dart
    ├── formateador_moneda.dart
    └── pantalla_divisor.dart

test/
├── domain/
│   ├── calcular_division_test.dart
│   └── validar_entrada_test.dart
├── data/
│   └── estrategia_redondeo_test.dart
└── presentation/
    └── pantalla_divisor_test.dart
```

**Structure Decision**: Flutter se mantiene como un solo proyecto. La app usa
capas dentro de `lib/`, con dominio puro y composicion en `main.dart`.

## Complexity Tracking

No hay violaciones de Constitution que justificar.

## Post-Design Constitution Check

- SOLID: PASS. Las responsabilidades quedan asignadas a clases separadas.
- OCP: PASS. Una nueva estrategia de redondeo se agrega implementando
  `EstrategiaRedondeo`.
- DIP: PASS. `DivisorController` recibe dependencias por constructor.
- Dominio sin Flutter: PASS. Los archivos de `domain` no requieren Flutter.
- Pruebas: PASS. Los escenarios de aceptacion quedan cubiertos por tareas de
  pruebas antes de finalizar la implementacion.
