# Research: Dividir cuenta

## Decision: Flutter SDK estable

**Rationale**: El proyecto base ya es Flutter y el enunciado pide construir la
app en Flutter. Usar el SDK estable mantiene el entorno alineado con la guia y
evita dependencias experimentales.

**Alternatives considered**:

- Otro framework: descartado porque no corresponde al proyecto base.
- Canal beta/dev de Flutter: descartado porque no aporta valor al MVP.

## Decision: Estado local con setState

**Rationale**: La app tiene una sola pantalla, sin red, sin base de datos y sin
estado compartido entre vistas. `setState` cubre el flujo sin introducir
abstracciones innecesarias.

**Alternatives considered**:

- BLoC, Riverpod, Provider u otros gestores: descartados porque agregan paquetes
  externos o complejidad fuera del alcance.
- Estado global: descartado porque no hay multiples pantallas ni datos
  persistentes.

## Decision: Capas presentation/domain/data

**Rationale**: La Constitution exige `presentation -> domain <- data`, dominio
sin Flutter y composicion en `main.dart`. Esta estructura permite probar el
calculo sin UI y cambiar estrategias de redondeo sin tocar la clase de calculo.

**Alternatives considered**:

- Todo en `main.dart`: descartado porque viola SRP y dificulta pruebas.
- Carpetas por tipo de widget: descartado porque no separa dominio de UI.

## Decision: EstrategiaRedondeo como abstraccion de dominio

**Rationale**: La spec requiere dos modos de redondeo y la Constitution exige OCP.
La interfaz permite agregar otra estrategia sin modificar `CalcularDivision`.

**Alternatives considered**:

- `switch` dentro de `CalcularDivision`: descartado porque obliga a editar esa
  clase al agregar una nueva regla.
- Funciones anonimas desde UI: descartado porque acopla el calculo a la capa de
  presentacion.

## Decision: Sin paquetes externos

**Rationale**: El enunciado del plan lo exige y el MVP no necesita paquetes para
calculo, validacion, formato simple o UI.

**Alternatives considered**:

- Paquetes de formateo monetario: descartados porque el alcance solo requiere
  dos decimales.
