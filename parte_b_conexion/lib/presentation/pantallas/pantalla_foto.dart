import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../widgets/vista_estado_conexion.dart';

class PantallaFoto extends StatefulWidget {
  const PantallaFoto({super.key, required this.consultarConexion});

  final ConsultarConexion consultarConexion;

  @override
  State<PantallaFoto> createState() => _PantallaFotoState();
}

class _PantallaFotoState extends State<PantallaFoto> {
  EstadoConexion? _estado;
  DateTime? _horaConsulta;
  bool _consultando = false;

  Future<void> _consultarAhora() async {
    setState(() {
      _consultando = true;
    });

    final estado = await widget.consultarConexion();

    if (!mounted) {
      return;
    }

    setState(() {
      _estado = estado;
      _horaConsulta = DateTime.now();
      _consultando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vista = VistaEstadoConexion.desde(_estado);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(vista.icono, color: vista.color, size: 72),
          const SizedBox(height: 16),
          Text(
            vista.texto,
            style: Theme.of(context).textTheme.headlineLarge
                ?.copyWith(color: vista.color),
          ),
          const SizedBox(height: 8),
          Text(
            _horaConsulta == null
                ? 'Sin consulta todavia'
                : 'Consultado a las ${_formatearHora(_horaConsulta!)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _consultando ? null : _consultarAhora,
            child: Text(_consultando ? 'Consultando...' : 'Consultar ahora'),
          ),
        ],
      ),
    );
  }

  String _formatearHora(DateTime hora) {
    String dosDigitos(int valor) => valor.toString().padLeft(2, '0');

    return '${dosDigitos(hora.hour)}:'
        '${dosDigitos(hora.minute)}:'
        '${dosDigitos(hora.second)}';
  }
}
