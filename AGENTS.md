# Instrucciones del agente

Este proyecto es una app Flutter de una sola pantalla para dividir una cuenta.
Debe permitir ingresar monto total, numero de personas y porcentaje de propina,
y mostrar cuanto paga cada persona.

## Estructura

Usa esta estructura para el codigo de la app:

- `lib/presentation`
- `lib/domain`
- `lib/data`

La regla de dependencia es:

```text
presentation -> domain <- data
```

`domain` no debe importar nada de `package:flutter`.

## Estandares

- Usa null safety.
- Usa nombres en espanol.
- No agregues paquetes externos.

## Que no tocar

- No modifiques `test/` sin que el usuario lo pida.
- No agregues dependencias al `pubspec.yaml` sin avisar.
- No toques `android/` ni `ios/`.

## Comandos utiles

```bash
flutter pub get
flutter run
flutter analyze
flutter test
```
