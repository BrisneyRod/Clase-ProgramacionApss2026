import 'package:flutter/material.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';
import 'pantalla_control.dart';

class PantallaVisor extends StatefulWidget {
  const PantallaVisor({
    super.key,
    required this.obtenerContador,
    required this.incrementar,
    required this.decrementar,
  });

  final ObtenerContador obtenerContador;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  State<PantallaVisor> createState() => _PantallaVisorState();
}

class _PantallaVisorState extends State<PantallaVisor> {
  int _contador = 0;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarContador();
  }

  Future<void> _cargarContador() async {
    try {
      final valor = await widget.obtenerContador();
      if (!mounted) return;
      setState(() => _contador = valor);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo cargar el contador.')),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _irAControl() async {
    final valor = await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(
        builder: (_) => PantallaControl(
          valorInicial: _contador,
          obtenerContador: widget.obtenerContador,
          incrementar: widget.incrementar,
          decrementar: widget.decrementar,
        ),
      ),
    );
    if (!mounted) return;
    if (valor != null) {
      setState(() => _contador = valor);
    } else {
      // El regreso del sistema puede cerrar la ruta sin devolver un valor.
      setState(() => _cargando = true);
      await _cargarContador();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visor')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contador: $_contador',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _cargando ? null : _irAControl,
              child: const Text('Ir a Control'),
            ),
          ],
        ),
      ),
    );
  }
}
