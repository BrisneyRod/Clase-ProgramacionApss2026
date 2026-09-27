import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sesion_provider.dart';
import 'pantalla_usuarios.dart';

class PantallaIngreso extends StatefulWidget {
  const PantallaIngreso({super.key});

  @override
  State<PantallaIngreso> createState() => _PantallaIngresoState();
}

class _PantallaIngresoState extends State<PantallaIngreso> {
  final correo = TextEditingController();
  final clave = TextEditingController();
  final nombre = TextEditingController();
  bool _navegando = false;

  @override
  void dispose() {
    correo.dispose();
    clave.dispose();
    nombre.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sesion = context.watch<SesionProvider>();

    if (sesion.idUsuario != null && !_navegando) {
      _navegando = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (context.read<SesionProvider>().idUsuario == null) {
          _navegando = false;
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (_) => const PantallaUsuarios()),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ingreso')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: correo,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: clave,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Clave'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nombre,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 24),
              if (sesion.cargando) ...[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 16),
              ],
              if (sesion.error != null) ...[
                Text(sesion.error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
              ],
              ElevatedButton(
                onPressed: sesion.cargando
                    ? null
                    : () => context.read<SesionProvider>().ingresar(
                        correo.text,
                        clave.text,
                      ),
                child: const Text('Ingresar'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: sesion.cargando
                    ? null
                    : () => context.read<SesionProvider>().registrar(
                        correo.text,
                        clave.text,
                        nombre.text,
                      ),
                child: const Text('Crear cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
