import 'package:flutter/material.dart';

import '../../domain/entities/usuario.dart';
import '../../domain/usecases/obtener_usuarios_con_vocal.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key, required this.obtenerUsuariosConVocal});

  final ObtenerUsuariosConVocal obtenerUsuariosConVocal;

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  late Future<List<Usuario>> _usuarios;

  @override
  void initState() {
    super.initState();
    _usuarios = widget.obtenerUsuariosConVocal();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Usuarios que empiezan con vocal')),
    body: FutureBuilder<List<Usuario>>(
      future: _usuarios,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No se pudieron cargar los usuarios.'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _usuarios = widget.obtenerUsuariosConVocal();
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }
        final usuarios = snapshot.data!;
        if (usuarios.isEmpty) {
          return const Center(
            child: Text('No hay usuarios cuyo nombre empiece con vocal.'),
          );
        }
        return ListView.separated(
          itemCount: usuarios.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final usuario = usuarios[index];
            return ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(usuario.nombre),
              subtitle: Text(usuario.email),
            );
          },
        );
      },
    ),
  );
}
