import 'package:flutter/material.dart';

import 'data/repositories/usuario_memoria.dart';
import 'domain/usecases/obtener_usuarios_con_vocal.dart';
import 'presentation/screens/usuarios_screen.dart';

void main() {
  final obtenerUsuariosConVocal = ObtenerUsuariosConVocal(UsuarioMemoria());
  runApp(MyApp(obtenerUsuariosConVocal: obtenerUsuariosConVocal));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.obtenerUsuariosConVocal});

  final ObtenerUsuariosConVocal obtenerUsuariosConVocal;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Usuarios',
    theme: ThemeData(colorSchemeSeed: Colors.indigo),
    home: UsuariosScreen(obtenerUsuariosConVocal: obtenerUsuariosConVocal),
  );
}
