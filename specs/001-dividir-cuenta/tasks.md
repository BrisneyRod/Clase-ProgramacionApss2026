# Tasks: Dividir cuenta

**Input**: Design documents from `specs/001-dividir-cuenta/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Required by Constitution and by the acceptance criteria in spec.md.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Each task includes an exact file path

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare the Flutter project structure without changing scope or dependencies.

- [X] T001 Create folders `lib/domain`, `lib/data`, `lib/presentation`, `test/domain`, `test/data`, and `test/presentation`
- [X] T002 Replace the Flutter counter template entry point with an empty composition shell in `lib/main.dart`
- [X] T003 [P] Confirm no external dependencies were added in `pubspec.yaml`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Domain abstractions and shared classes that all user stories need.

**CRITICAL**: No user story work can begin until this phase is complete.

- [X] T004 [P] Create `EstrategiaRedondeo` with one method in `lib/domain/estrategia_redondeo.dart`
- [X] T005 [P] Create `Cuenta` with fields `montoTotal`, `numeroPersonas`, and `porcentajePropina` in `lib/domain/cuenta.dart`
- [X] T006 [P] Create `Resultado` with field `pagoPorPersona` in `lib/domain/resultado.dart`
- [X] T007 Create `CalcularDivision` in `lib/domain/calcular_division.dart` using `Cuenta` and `EstrategiaRedondeo`, without validation or formatting
- [X] T008 Create `ValidarEntrada` in `lib/domain/validar_entrada.dart` to convert text input into `Cuenta` or an error message
- [X] T009 [P] Create `RedondeoExacto` in `lib/data/redondeo_exacto.dart` implementing `EstrategiaRedondeo`
- [X] T010 [P] Create `RedondeoHaciaArriba` in `lib/data/redondeo_hacia_arriba.dart` implementing `EstrategiaRedondeo`
- [X] T011 [P] Create `FormateadorMoneda` in `lib/presentation/formateador_moneda.dart` to display values with two decimals
- [X] T012 Create `DivisorController` in `lib/presentation/divisor_controller.dart` receiving `ValidarEntrada`, `CalcularDivision`, and rounding strategies by constructor

**Checkpoint**: Foundation ready; user story implementation can begin.

---

## Phase 3: User Story 1 - Calcular pago por persona (Priority: P1) MVP

**Goal**: User enters valid amount, people, tip, exact mode, taps `Calcular`, and sees payment per person with two decimals.

**Independent Test**: Scenarios 1, 2, and 5 from `spec.md` pass in domain/controller/widget tests.

### Tests for User Story 1

- [X] T013 [P] [US1] Add domain test for `100.00`, `4`, `10%`, exact -> `27.50` in `test/domain/calcular_division_test.dart`
- [X] T014 [P] [US1] Add domain test for `90.00`, `3`, `0%`, exact -> `30.00` in `test/domain/calcular_division_test.dart`
- [X] T015 [P] [US1] Add domain test for `10.00`, `3`, `0%`, exact -> `3.33` in `test/domain/calcular_division_test.dart`
- [X] T016 [P] [US1] Add widget test for valid exact calculation in `test/presentation/pantalla_divisor_test.dart`

### Implementation for User Story 1

- [X] T017 [US1] Implement exact calculation flow in `lib/domain/calcular_division.dart`
- [X] T018 [US1] Implement exact result formatting through `lib/presentation/formateador_moneda.dart`
- [X] T019 [US1] Implement `DivisorController` success state in `lib/presentation/divisor_controller.dart`
- [X] T020 [US1] Implement amount, people, tip fields and `Calcular` button in `lib/presentation/pantalla_divisor.dart`
- [X] T021 [US1] Wire `PantallaDivisor` dependencies only in `lib/main.dart`

**Checkpoint**: US1 works independently with exact mode for valid entries.

---

## Phase 4: User Story 2 - Elegir modo de redondeo (Priority: P2)

**Goal**: User chooses exact or upward rounding mode and the displayed result changes according to the selected mode.

**Independent Test**: Scenario 6 from `spec.md` passes without breaking exact mode scenarios.

### Tests for User Story 2

- [X] T022 [P] [US2] Add data test for `RedondeoHaciaArriba` with `3.33` -> `4.00` in `test/data/estrategia_redondeo_test.dart`
- [X] T023 [P] [US2] Add data test for `RedondeoHaciaArriba` with integer value unchanged in `test/data/estrategia_redondeo_test.dart`
- [X] T024 [P] [US2] Add widget test for `10.00`, `3`, `0%`, upward mode -> `4.00` in `test/presentation/pantalla_divisor_test.dart`

### Implementation for User Story 2

- [X] T025 [US2] Implement upward rounding in `lib/data/redondeo_hacia_arriba.dart`
- [X] T026 [US2] Implement exact rounding in `lib/data/redondeo_exacto.dart`
- [X] T027 [US2] Add rounding mode selection to `lib/presentation/pantalla_divisor.dart`
- [X] T028 [US2] Route selected rounding strategy through `lib/presentation/divisor_controller.dart`

**Checkpoint**: US1 and US2 both work independently.

---

## Phase 5: User Story 3 - Validar entradas invalidas (Priority: P3)

**Goal**: User sees clear errors for invalid entries and no stale result is shown.

**Independent Test**: Scenarios 3 and 4 from `spec.md`, plus the clarify negative-value rule, pass.

### Tests for User Story 3

- [X] T029 [P] [US3] Add validation test for `0` people -> `Debe haber al menos una persona` in `test/domain/validar_entrada_test.dart`
- [X] T030 [P] [US3] Add validation test for amount `abc` -> `Monto inválido` in `test/domain/validar_entrada_test.dart`
- [X] T031 [P] [US3] Add validation test for negative amount, people, or tip -> error in `test/domain/validar_entrada_test.dart`
- [X] T032 [P] [US3] Add widget test that invalid input hides result in `test/presentation/pantalla_divisor_test.dart`

### Implementation for User Story 3

- [X] T033 [US3] Implement invalid amount handling in `lib/domain/validar_entrada.dart`
- [X] T034 [US3] Implement people count validation in `lib/domain/validar_entrada.dart`
- [X] T035 [US3] Implement negative value validation in `lib/domain/validar_entrada.dart`
- [X] T036 [US3] Display errors and clear result state in `lib/presentation/divisor_controller.dart`
- [X] T037 [US3] Render error messages without result in `lib/presentation/pantalla_divisor.dart`

**Checkpoint**: All acceptance scenarios are independently testable.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Verify architecture, commands, and documentation.

- [X] T038 [P] Run `flutter analyze` and record result in `bitacora.md`
- [X] T039 [P] Run `flutter test` and record result in `bitacora.md`
- [X] T040 Verify `lib/domain/` has no `package:flutter` imports and record result in `bitacora.md`
- [X] T041 Verify `main.dart` is the only file instantiating concrete data implementations and record result in `bitacora.md`
- [X] T042 Verify the implementation uses no network access or database code and record result in `bitacora.md`
- [X] T043 Count files and lines in `lib/` and update `bitacora.md`
- [X] T044 Review every generated function for student explainability and update `bitacora.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: no dependencies.
- **Foundational (Phase 2)**: depends on Setup and blocks all user stories.
- **US1 (Phase 3)**: depends on Foundational and provides the MVP.
- **US2 (Phase 4)**: depends on Foundational; can be built after US1 for simpler UI integration.
- **US3 (Phase 5)**: depends on Foundational; can be built after US1 for result-clearing behavior.
- **Polish (Phase 6)**: depends on all selected user stories.

### User Story Dependencies

- **US1**: no dependency on other stories after Foundation.
- **US2**: uses the same calculation flow as US1 but remains independently testable.
- **US3**: uses validation and controller result state; remains independently testable.

### Parallel Opportunities

- T004, T005, T006, T009, T010, and T011 can run in parallel.
- T013, T014, T015, and T016 can be written in parallel before US1 implementation.
- T022, T023, and T024 can be written in parallel before US2 implementation.
- T029, T030, T031, and T032 can be written in parallel before US3 implementation.
- T038 and T039 can run independently once implementation is complete.

## Implementation Strategy

### MVP First

1. Complete Phase 1 and Phase 2.
2. Complete US1 tests and implementation.
3. Validate exact mode scenarios before adding rounding mode behavior.

### Incremental Delivery

1. Add US1: valid exact calculations.
2. Add US2: mode selection and upward rounding.
3. Add US3: invalid input behavior.
4. Run polish checks and update metrics.

## Notes

- Tests must be written before implementation tasks in each user story.
- Domain code must remain pure Dart.
- Do not modify `android/` or `ios/`.
- Do not add external packages.
