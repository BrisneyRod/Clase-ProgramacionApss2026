# Data Model: Dividir cuenta

## Cuenta

Representa los datos numericos necesarios para calcular la division.

**Fields**:

- `montoTotal`: numero decimal mayor o igual a `0`.
- `numeroPersonas`: entero mayor o igual a `1`.
- `porcentajePropina`: numero decimal mayor o igual a `0`.

**Validation Rules**:

- Si `montoTotal` no es numerico, el resultado de validacion es `Monto inválido`.
- Si `numeroPersonas` es menor que `1`, el resultado de validacion es
  `Debe haber al menos una persona`.
- Si cualquier campo numerico es negativo, el resultado de validacion es un
  mensaje de error y no se calcula resultado.

## Resultado

Representa el pago que corresponde a cada persona.

**Fields**:

- `pagoPorPersona`: numero decimal ya ajustado segun la estrategia de redondeo.

**Validation Rules**:

- Siempre se presenta al usuario con dos decimales.
- No existe si la entrada no pasa validacion.

## EstrategiaRedondeo

Representa la regla elegida por el usuario para ajustar el pago por persona.

**Variants**:

- `exacto`: conserva el valor calculado y luego se muestra con dos decimales.
- `haciaArriba`: sube el pago por persona al entero superior; si ya es entero,
  lo mantiene.

## Relationships

- `CalcularDivision` recibe una `Cuenta` valida y una `EstrategiaRedondeo`.
- `CalcularDivision` devuelve un `Resultado`.
- `ValidarEntrada` convierte texto ingresado por el usuario en una `Cuenta`
  valida o en un mensaje de error.
