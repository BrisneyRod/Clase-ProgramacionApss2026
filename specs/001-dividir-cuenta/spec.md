# Feature Specification: Dividir cuenta

**Feature Branch**: `sdd`

**Created**: 2026-09-30

**Status**: Draft

**Input**: User description: "Una app de una sola pantalla para dividir la cuenta de un restaurante entre varias personas. El usuario ingresa el monto total, el numero de personas y el porcentaje de propina, y al tocar Calcular ve cuanto paga cada persona con dos decimales. Hay dos modos de redondeo que el usuario elige: exacto, o hacia arriba al entero mas cercano. La app funciona sin conexion: no hay red ni base de datos."

## Clarifications

### Session 2026-09-30

- Q: Como debe comportarse la app si el usuario ingresa un monto, numero de
  personas o porcentaje de propina negativo? -> A: Rechazar cualquier valor
  negativo con mensaje de error.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Calcular pago por persona (Priority: P1)

Como persona que divide una cuenta de restaurante, quiero ingresar monto total,
numero de personas, porcentaje de propina y modo de redondeo para saber cuanto
paga cada persona.

**Why this priority**: Es el flujo principal del MVP y resuelve la necesidad
central de la app.

**Independent Test**: Se puede probar ingresando valores validos, tocando
"Calcular" y verificando que el resultado mostrado por persona tenga dos
decimales.

**Acceptance Scenarios**:

1. **Given** monto `100.00`, `4` personas, `10%` de propina y modo exacto,
   **When** el usuario toca "Calcular", **Then** se muestra `27.50` por persona.
2. **Given** monto `90.00`, `3` personas, `0%` de propina y modo exacto,
   **When** el usuario toca "Calcular", **Then** se muestra `30.00` por persona.
3. **Given** monto `10.00`, `3` personas, `0%` de propina y modo exacto,
   **When** el usuario toca "Calcular", **Then** se muestra `3.33` por persona.

---

### User Story 2 - Elegir modo de redondeo (Priority: P2)

Como persona que divide una cuenta, quiero elegir entre resultado exacto y
redondeo hacia arriba al entero mas cercano para adaptar el pago al acuerdo del
grupo.

**Why this priority**: El redondeo cambia el resultado final y es parte explicita
del alcance solicitado.

**Independent Test**: Se puede probar con los mismos valores de entrada y modos
distintos para verificar que el resultado cambia segun la opcion elegida.

**Acceptance Scenarios**:

1. **Given** monto `10.00`, `3` personas, `0%` de propina y modo hacia arriba,
   **When** el usuario toca "Calcular", **Then** se muestra `4.00` por persona.

---

### User Story 3 - Validar entradas invalidas (Priority: P3)

Como persona usuaria, quiero recibir mensajes claros cuando los datos no sirven
para calcular, para corregirlos sin ver resultados equivocados.

**Why this priority**: Evita resultados incorrectos y cubre errores basicos de
uso.

**Independent Test**: Se puede probar ingresando datos invalidos y verificando
que aparece el mensaje esperado y no se muestra un resultado.

**Acceptance Scenarios**:

1. **Given** monto `50.00` y `0` personas, **When** el usuario toca "Calcular",
   **Then** se muestra `Debe haber al menos una persona` y no se muestra
   resultado.
2. **Given** monto `abc`, **When** el usuario toca "Calcular", **Then** se
   muestra `Monto inválido` y no se muestra resultado.

### Edge Cases

- Si el numero de personas es `0`, la app debe mostrar `Debe haber al menos una
  persona` y no debe mostrar resultado.
- Si el monto no es numerico, la app debe mostrar `Monto inválido` y no debe
  mostrar resultado.
- Si el monto, numero de personas o porcentaje de propina es negativo, la app
  debe mostrar un mensaje de error y no debe mostrar resultado.
- Si el resultado exacto tiene mas de dos decimales, la app debe mostrarlo con
  dos decimales.
- Si el modo elegido es hacia arriba, el pago por persona debe subir al entero
  mas cercano y mostrarse con dos decimales.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La app MUST mostrar una sola pantalla para ingresar datos y ver el
  resultado del divisor de cuenta.
- **FR-002**: El usuario MUST poder ingresar monto total, numero de personas y
  porcentaje de propina.
- **FR-003**: El usuario MUST poder elegir entre modo exacto y modo hacia arriba
  al entero mas cercano.
- **FR-004**: La app MUST calcular el total con propina antes de dividirlo entre
  las personas.
- **FR-005**: La app MUST mostrar el pago por persona con dos decimales despues
  de tocar "Calcular".
- **FR-006**: En modo exacto, la app MUST mostrar el cociente con dos decimales.
- **FR-007**: En modo hacia arriba, la app MUST redondear el pago por persona al
  entero superior y mostrarlo con dos decimales.
- **FR-008**: Si el numero de personas es menor que `1`, la app MUST mostrar
  `Debe haber al menos una persona` y MUST NOT mostrar resultado.
- **FR-009**: Si el monto total no es numerico, la app MUST mostrar `Monto
  inválido` y MUST NOT mostrar resultado.
- **FR-010**: La app MUST funcionar sin conexion, sin red y sin base de datos.
- **FR-011**: Si monto total, numero de personas o porcentaje de propina es
  negativo, la app MUST mostrar un mensaje de error y MUST NOT mostrar resultado.

### Key Entities

- **Entrada de cuenta**: datos ingresados por el usuario; incluye monto total,
  numero de personas, porcentaje de propina y modo de redondeo.
- **Resultado de division**: valor que debe pagar cada persona, siempre mostrado
  con dos decimales.
- **Modo de redondeo**: opcion elegida por el usuario; puede ser exacto o hacia
  arriba al entero mas cercano.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: El usuario puede completar el calculo principal en una sola
  pantalla, sin navegacion adicional.
- **SC-002**: Los 6 escenarios de aceptacion definidos en esta especificacion
  producen exactamente el resultado o mensaje esperado.
- **SC-003**: Todo resultado monetario visible para el usuario aparece con dos
  decimales.
- **SC-004**: La app permite calcular sin conexion, sin solicitar acceso a red y
  sin depender de almacenamiento persistente.

## Assumptions

- El porcentaje de propina se interpreta como porcentaje del monto total.
- "Modo exacto" significa dividir el total con propina entre el numero de
  personas y mostrar el resultado con dos decimales.
- "Hacia arriba al entero mas cercano" significa tomar el pago por persona y
  subirlo al siguiente entero cuando tenga decimales; si ya es entero, se
  mantiene.
- La especificacion no incluye pagos diferenciados, personas con valor fijo,
  historial, persistencia, monedas multiples, red ni base de datos.
