import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';

class VistaEstadoConexion {
  const VistaEstadoConexion({
    required this.texto,
    required this.icono,
    required this.color,
  });

  final String texto;
  final IconData icono;
  final Color color;

  factory VistaEstadoConexion.desde(EstadoConexion? estado) {
    return switch (estado) {
      EstadoConexion.wifi => const VistaEstadoConexion(
        texto: 'Wi-Fi',
        icono: Icons.wifi,
        color: Colors.green,
      ),
      EstadoConexion.datosMoviles => const VistaEstadoConexion(
        texto: 'Datos moviles',
        icono: Icons.signal_cellular_alt,
        color: Colors.green,
      ),
      EstadoConexion.otro => const VistaEstadoConexion(
        texto: 'Datos moviles',
        icono: Icons.network_cell,
        color: Colors.green,
      ),
      EstadoConexion.sinConexion => const VistaEstadoConexion(
        texto: 'Sin conexion',
        icono: Icons.wifi_off,
        color: Colors.red,
      ),
      null => const VistaEstadoConexion(
        texto: 'Sin consulta',
        icono: Icons.help_outline,
        color: Colors.grey,
      ),
    };
  }
}
