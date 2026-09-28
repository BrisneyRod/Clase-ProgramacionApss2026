# Respuestas del deber

## 1. Regreso con el boton atras del sistema y coordinacion entre pantallas

En la version basica planteada por el deber, al incrementar de 3 a 4 en Control y salir con el boton atras de Android, el 4 queda guardado en disco, pero el visor sigue mostrando 3. El regreso del sistema no ejecuta nuestro boton Volver, que llama a Navigator.pop(context, contador) para devolver el valor. La ruta se cierra sin resultado y el Future de Navigator.push devuelve null.

Lo desactualizado es el campo _contador del State de PantallaVisor y, por tanto, el texto que muestra ese estado. No es el dato persistido. Control modifica su propio State; su setState no actualiza el State del visor. Ademas, al regresar se reutiliza el visor existente y no se vuelve a ejecutar su initState.

En nuestra implementacion actual ese problema ya esta contemplado: si el resultado es null, el visor llama a ObtenerContador y actualiza su estado con setState. Por eso la prueba automatizada del regreso del sistema muestra 4. No observamos un visor desactualizado en esta version; ese seria el comportamiento sin dicha recarga. La comprobacion en un proceso Android real quedo pendiente por la descarga de Gradle.

Contando los puntos del protocolo de ida y vuelta, tuvieron que ponerse de acuerdo cuatro lugares:

1. El visor envia su valor actual al crear la ruta hacia Control.
2. Control lo recibe por constructor y lo copia a su estado local.
3. El boton Volver devuelve el valor actualizado mediante Navigator.pop.
4. El visor espera el resultado de Navigator.push y lo aplica mediante setState.

Son cuatro puntos de coordinacion repartidos entre dos pantallas. El regreso del sistema requiere ademas manejar el caso sin resultado; en nuestra version se resuelve volviendo a leer el valor guardado.
