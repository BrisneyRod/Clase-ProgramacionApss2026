# Deber 4 — De TDD a CI/CD: automatizar la verificación

Aplicación Flutter para dividir una cuenta entre varias personas. Este
repositorio contiene la implementación de las semanas 7–8, sus pruebas TDD y
la automatización solicitada en el Deber 4.

## Dónde está cada cosa

- `lib/domain/`: reglas de negocio, validación y cálculo.
- `lib/data/`: estrategias de redondeo.
- `lib/presentation/`: pantalla, controller y formato de moneda.
- `test/`: pruebas de dominio, aceptación y widgets.
- `specs/001-dividir-cuenta/`: spec, plan, contratos y tareas.
- `.github/workflows/flutter-ci.yml`: pipeline de CI/CD.
- `evidencias/`: capturas del deber y resultados de GitHub Actions.

Las carpetas `parte_a_contador/`, `parte_b_conexion/` y el archivo `demo.mp4`
son trabajos anteriores conservados en el repositorio; no forman parte de la
entrega del Deber 4. La entrega actual es el proyecto Flutter de la raíz.

## Comandos locales

```bash
flutter pub get
flutter analyze
flutter test --coverage
flutter build apk --release
```

## Pipeline

El workflow se ejecuta en cada `push` y en cada pull request hacia `main`.
Analiza el código, ejecuta todas las pruebas, compila el APK de release y lo
publica como artefacto `deber4-divisor-cuenta-apk`.

## Protección de `main`

En GitHub configura una regla para `main` con:

- `Require a pull request before merging`.
- `Require status checks to pass before merging`.
- Check obligatorio: `Analyze, test and build APK`.
- Opcional/recomendado: `Require branches to be up to date before merging`.

Así una modificación no puede unirse a `main` si falla el análisis, una
prueba o la compilación.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
