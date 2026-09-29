import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';
import '../estado/conexion_cubit.dart';
import '../widgets/vista_estado_conexion.dart';

class PantallaStream extends StatelessWidget {
  const PantallaStream({
    super.key,
    required this.consultarConexion,
    required this.observarConexion,
  });

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConexionCubit(
        consultarConexion: consultarConexion,
        observarConexion: observarConexion,
      )..iniciar(),
      child: const _PantallaStreamContenido(),
    );
  }
}

class _PantallaStreamContenido extends StatefulWidget {
  const _PantallaStreamContenido();

  @override
  State<_PantallaStreamContenido> createState() =>
      _PantallaStreamContenidoState();
}

class _PantallaStreamContenidoState extends State<_PantallaStreamContenido> {
  int _cambios = 0;
  bool _consultaInicialPendiente = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConexionCubit, EstadoConexion>(
      listenWhen: (anterior, actual) => anterior != actual,
      listener: (context, estado) {
        if (_consultaInicialPendiente) {
          _consultaInicialPendiente = false;
          return;
        }

        setState(() {
          _cambios++;
        });
      },
      child: BlocBuilder<ConexionCubit, EstadoConexion>(
        builder: (context, estado) {
          final vista = VistaEstadoConexion.desde(estado);

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
                  'Cambios recibidos: $_cambios',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
