import 'package:flutter/material.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

class PantallaControl extends StatefulWidget {
  const PantallaControl({
    super.key,
    required this.valorInicial,
    required this.obtenerContador,
    required this.incrementar,
    required this.decrementar,
  });

  final int valorInicial;
  final ObtenerContador obtenerContador;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  State<PantallaControl> createState() => _PantallaControlState();
}

class _PantallaControlState extends State<PantallaControl> {
  late int _contador;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _contador = widget.valorInicial;
  }

  Future<void> _cambiarContador(Future<int> Function() accion) async {
    if (_guardando) return;
    setState(() => _guardando = true);
    try {
      final valor = await accion();
      if (!mounted) return;
      setState(() => _contador = valor);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el contador.')),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _volver() => Navigator.of(context).pop(_contador);

  @override
  Widget build(BuildContext context) {
    return PopScope<int>(
      canPop: !_guardando,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Control'),
          leading: BackButton(onPressed: _guardando ? null : _volver),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contador: $_contador',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _guardando
                        ? null
                        : () => _cambiarContador(widget.incrementar.call),
                    child: const Text('+1'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _guardando
                        ? null
                        : () => _cambiarContador(widget.decrementar.call),
                    child: const Text('-1'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _guardando ? null : _volver,
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
