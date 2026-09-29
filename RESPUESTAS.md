# RESPUESTAS

## Parte A - Contador

### 1. setState y el boton atras

En el paso 3, al incrementar en Control y salir con el boton atras del sistema, el valor si quedo guardado en disco, pero el Visor podia quedar desactualizado. Lo que quedo viejo fue el estado local de la pantalla Visor, es decir, el valor que tenia guardado en su propio `State`.

Paso porque con `setState` cada pantalla maneja su propio estado. Si Control cambia el contador, el Visor solo se entera si Control le devuelve el valor al hacer `Navigator.pop(context, valor)` y el Visor lo recibe para hacer `setState`.

Para que el contador viajara entre las dos pantallas, varios lugares tuvieron que ponerse de acuerdo: el Visor tenia que mandar el valor inicial, Control tenia que recibirlo, Control tenia que devolver el valor al salir, y el Visor tenia que esperar ese resultado y actualizarse. Si uno de esos puntos falla, la UI queda vieja.

### 2. Riverpod y el boton atras

Con Riverpod el boton atras del sistema no rompe nada porque ya no dependemos de devolver un valor con `Navigator.pop`.

El contador vive en el `contadorProvider`. Las dos pantallas observan el mismo estado compartido. Cuando Control incrementa o decrementa, actualiza el provider usando los casos de uso del domain. Entonces, al volver al Visor, aunque sea con el boton atras del sistema, el Visor ya esta mirando el valor actualizado.

### 3. BlocObserver

El `BlocObserver` permite ver la secuencia de cambios de estado en consola, por ejemplo:

```text
ContadorCubit: 3 -> 4
```

Eso no lo tenia tan claro en las versiones anteriores. Con `setState` el cambio queda dentro de cada widget, y con Riverpod la pantalla se actualiza, pero no dejamos un registro global de cada transicion.

Seria util en una app real cuando hay un bug dificil de seguir, por ejemplo si el contador, una sesion de usuario o un carrito de compras cambia sin que sepamos desde donde. El log ayuda a ver el orden exacto de los cambios.

### 4. Prueba de arquitectura

Salida de:

```bash
git diff version/setstate version/riverpod -- lib/domain lib/data
```

```text

```

Salida de:

```bash
git diff version/setstate version/bloc -- lib/domain lib/data
```

```text

```

Salida de:

```bash
git diff version/setstate version/bloc --stat -- lib/presentation
```

```text
lib/presentation/estado/contador_cubit.dart      |  42 ++++++++
lib/presentation/pantallas/pantalla_control.dart | 132 ++++++++---------------
lib/presentation/pantallas/pantalla_visor.dart   |  90 ++++------------
3 files changed, 105 insertions(+), 159 deletions(-)
```

Que los dos primeros comandos salgan vacios demuestra que `domain/` y `data/` no cambiaron al pasar de `setState` a Riverpod o BLoC. La logica de la app quedo igual.

Que el tercer comando si tenga diferencias demuestra que el cambio de administrador de estado quedo en la frontera correcta: `presentation/`.

Si manana tuviera que cambiar Riverpod por otro paquete, tendria que volver a escribir la capa `presentation/`: providers, pantallas y forma de conectar la UI con el estado. No tendria que reescribir `domain/` ni `data/`.

### 5. Cual elegiria

Si la app tuviera una sola pantalla, elegiria `setState`, porque es simple, directo y suficiente cuando el estado vive cerca del widget que lo usa.

Si la app tuviera ocho pantallas que comparten cinco datos distintos, usaria Riverpod o Cubit. En ese caso ya conviene tener un estado compartido fuera de las pantallas para no estar pasando datos por constructores ni devolviendo valores con `pop`.

`setState` si es la opcion correcta cuando el estado es local, pequeno y solo afecta a un widget o una pantalla. Tambien cuando no necesito compartir ese dato con otras partes de la app.

| Pregunta | setState | Riverpod | Cubit |
| --- | --- | --- | --- |
| Donde vive el contador? | En el `State` de las pantallas. | En el `contadorProvider`. | En el `ContadorCubit`. |
| Las pantallas se pasan datos? | Si. El Visor manda el valor y Control lo devuelve. | No. Las dos leen el mismo provider. | No. Las dos usan el mismo Cubit. |
| Archivos de `presentation/` que tocaste | `pantallas/pantalla_visor.dart`, `pantallas/pantalla_control.dart`. | `estado/contador_provider.dart`, `pantallas/pantalla_visor.dart`, `pantallas/pantalla_control.dart`. | `estado/contador_cubit.dart`, `pantallas/pantalla_visor.dart`, `pantallas/pantalla_control.dart`. |
| Que pasa con el boton atras? | Puede dejar el Visor desactualizado si Control no devuelve el valor. | Funciona porque el estado esta compartido. | Funciona porque el estado esta compartido. |
| Tuviste que tocar `domain/`? | No. | No. | No. |

## Parte B - Conexion

### 6. Future como foto

La pantalla siguio mostrando "Wi-Fi" porque habia consultado la conexion una sola vez. Esa consulta era un `Future`: pregunto como estaba la conexion en ese momento y guardo esa respuesta en pantalla.

Cuando apague el Wi-Fi, la pantalla no tenia ningun flujo escuchando cambios. Por eso no se entero sola.

La app no tenia un dato incorrecto en el momento en que lo obtuvo. Tenia un dato correcto de un momento equivocado. Era una foto vieja.

### 7. Cancelar el StreamSubscription

Si borro el `cancel()` del `close()` del Cubit y el usuario entra y sale de esa pantalla cincuenta veces, se pueden quedar suscripciones vivas al stream.

Eso puede causar fugas de memoria y multiples Cubits viejos escuchando cambios aunque sus pantallas ya no existan. Tambien podria provocar logs repetidos, emisiones innecesarias o errores al intentar actualizar algo que ya deberia estar cerrado.

### 8. Future y Stream

Decimos que un `Future` es una foto porque en la pantalla "Con Future" la app pregunta una vez como esta la conexion. Si en ese momento hay Wi-Fi, muestra "Wi-Fi" con esa hora. Si luego apago el Wi-Fi, la pantalla no cambia sola porque solo tenia una foto del pasado.

Decimos que un `Stream` es una pelicula porque en la pantalla "Con Stream" la app queda escuchando. Cuando la conexion cambia de Wi-Fi a sin conexion, o vuelve a Wi-Fi, la pantalla recibe nuevos eventos y se actualiza sola.

Dos datos que pediria con `Future`:

- El perfil del usuario al abrir la app.
- Una factura o recibo especifico.

Dos datos que observaria con `Stream`:

- El estado de conexion del telefono.
- Los mensajes nuevos de un chat en tiempo real.

