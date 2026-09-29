import 'package:flutter/material.dart';

import 'data/repositories/conexion_plus_repository.dart';
import 'domain/usecases/consultar_conexion.dart';
import 'domain/usecases/observar_conexion.dart';
import 'presentation/pantallas/pantalla_foto.dart';
import 'presentation/pantallas/pantalla_stream.dart';

void main() {
  final repository = ConexionPlusRepository();
  final consultarConexion = ConsultarConexion(repository);
  final observarConexion = ObservarConexion(repository);

  runApp(
    MyApp(
      consultarConexion: consultarConexion,
      observarConexion: observarConexion,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.consultarConexion,
    required this.observarConexion,
  });

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conexion: Future y Stream',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: PantallaPrincipal(
        consultarConexion: consultarConexion,
        observarConexion: observarConexion,
      ),
    );
  }
}

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({
    super.key,
    required this.consultarConexion,
    required this.observarConexion,
  });

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Estado de conexion'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Con Future'),
              Tab(text: 'Con Stream'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PantallaFoto(consultarConexion: consultarConexion),
            PantallaStream(
              consultarConexion: consultarConexion,
              observarConexion: observarConexion,
            ),
          ],
        ),
      ),
    );
  }
}
