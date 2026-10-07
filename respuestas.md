# Respuestas — Deber 3

## 1. Rojo antes de verde

`flutter test` mostró que se esperaba `false`, pero se obtuvo `true` en la prueba de una propina mayor al 100 %. Era importante verla fallar porque así comprobé que la prueba detectaba el problema antes de escribir la solución.

## 2. Linter vs. IA

El linter mostró el aviso `unused_local_variable`: una variable local no estaba siendo utilizada. La IA señaló el número mágico `100` en `calcular_division.dart`. El linter no encontró ese code smell porque el código era válido y funcionaba; el número no rompía ninguna regla automática, pero sí hacía menos claro el significado del código.

## 3. Mi refactorización

Elegí el número mágico `100`. Lo reemplacé por la constante `porcentajeBase`, que explica que el valor se usa para convertir la propina de porcentaje a decimal. La operación y los resultados no cambiaron. Lo comprobé ejecutando todas las pruebas, que terminaron con `All tests passed!`, y ejecutando `flutter analyze`, que terminó con `No issues found!`.

## 4. Coverage

Ningún archivo de `lib/` tuvo un porcentaje más bajo: todos quedaron con 100 % de líneas cubiertas. Esto no significa que el código sea perfecto ni que no pueda tener errores; solo significa que las pruebas ejecutaron todas sus líneas medibles.
