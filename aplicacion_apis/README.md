# Fútbol · ScoreBat

App sencilla en Flutter que consulta https://www.scorebat.com/video-api/v3/
y muestra imagen, partido, competición, fecha local y cantidad de videos.
Muestra hasta 5 partidos. El botón Ver video abre el primer video disponible
dentro de la app, con una flecha para volver a la lista. Si no hay un enlace
válido, el botón aparece desactivado. ScoreBat puede ofrecer resúmenes;
no se garantiza que sean partidos completos.

## Ejecutar

```sh
flutter pub get
flutter run
```

La lista está en `lib/main.dart` y el reproductor en `lib/video_page.dart`.
Usa `http` para consultar la API,
`jsonDecode` para leer el JSON y `FutureBuilder` para mostrar el resultado.
Incluye actualización, indicador de carga, reintento y estado de lista vacía.
El reproductor utiliza `flutter_inappwebview` y extrae el iframe con `html`.
Después de añadir estas dependencias, detén la app y ejecuta `flutter run`
otra vez (no basta con Hot Reload). Para probar en navegador: `flutter run -d chrome`.
La compilación nativa de Windows necesita NuGet en PATH y WebView2 instalado.
Si Flutter muestra `Building with plugins requires symlink support`, activa
el Modo de desarrollador de Windows y vuelve a ejecutar `flutter pub get`.
Si las dependencias ya están descargadas, puedes ejecutar la versión web con
`flutter run -d chrome --no-pub`.

## Verificar

```sh
flutter analyze
flutter test
```

Se necesita Internet y que el endpoint esté disponible. No se añadió una clave
API. Las pruebas usan respuestas simuladas, no verifican el servicio externo.
