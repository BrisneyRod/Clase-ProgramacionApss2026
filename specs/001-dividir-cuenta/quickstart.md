# Quickstart: Dividir cuenta

## Prerrequisitos

- Flutter SDK estable disponible.
- Proyecto abierto en la raiz del repositorio.
- Sin paquetes externos agregados al `pubspec.yaml`.

## Preparacion

```bash
flutter pub get
```

## Verificacion estatica

```bash
flutter analyze
```

Resultado esperado: sin errores de analisis.

## Pruebas automatizadas

```bash
flutter test
```

Resultado esperado: pasan las pruebas de dominio, data y presentation.

## Ejecucion manual

```bash
flutter run
```

## Escenarios a verificar

1. Ingresar `100.00`, `4` personas, `10%`, modo exacto. Tocar `Calcular`.
   Resultado esperado: `27.50`.
2. Ingresar `90.00`, `3` personas, `0%`, modo exacto. Tocar `Calcular`.
   Resultado esperado: `30.00`.
3. Ingresar `50.00`, `0` personas. Tocar `Calcular`.
   Resultado esperado: `Debe haber al menos una persona` y sin resultado.
4. Ingresar monto `abc`. Tocar `Calcular`.
   Resultado esperado: `Monto inválido` y sin resultado.
5. Ingresar `10.00`, `3` personas, `0%`, modo exacto. Tocar `Calcular`.
   Resultado esperado: `3.33`.
6. Ingresar `10.00`, `3` personas, `0%`, modo hacia arriba. Tocar `Calcular`.
   Resultado esperado: `4.00`.

## Reglas de arquitectura a revisar

- `lib/domain/` no importa `package:flutter`.
- `main.dart` es el unico lugar donde se instancian implementaciones concretas.
- `CalcularDivision` no valida ni formatea.
- `ValidarEntrada` no calcula ni formatea.
- Agregar otra estrategia de redondeo no requiere modificar `CalcularDivision`.
