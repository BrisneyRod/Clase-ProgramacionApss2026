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
- `.github/workflows/ci.yml`: pipeline de CI y entrega del APK.
- `evidencias/`: capturas del deber y resultados de GitHub Actions.
- `respuestas.md`: respuestas y enlaces a las evidencias de esta entrega.

Las carpetas `parte_a_contador/`, `parte_b_conexion/` y el archivo `demo.mp4`
son trabajos anteriores conservados en el repositorio; no forman parte de la
entrega del Deber 4. La entrega actual es el proyecto Flutter de la raíz.

## Comandos locales

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

## Pipeline

El job `ci` se ejecuta en cada pull request y en cada `push` a `main`.
Analiza el código, ejecuta las pruebas y compila el APK de depuración.
Después de un `push` a `main`, el job `entrega` vuelve a compilar el APK y
lo publica como artifact `deber4-apk-debug`.

## Protección de `main`

En GitHub configura una regla para `main` con:

- `Require a pull request before merging`.
- `Require status checks to pass before merging`.
- Check obligatorio: `ci`.
- Opcional/recomendado: `Require branches to be up to date before merging`.

Así una modificación no puede unirse a `main` si falla el análisis, una
prueba o la compilación.
