import 'package:flutter/material.dart';

import 'data/redondeo_exacto.dart';
import 'data/redondeo_hacia_arriba.dart';
import 'domain/calcular_division.dart';
import 'domain/validar_entrada.dart';
import 'presentation/divisor_controller.dart';
import 'presentation/formateador_moneda.dart';
import 'presentation/pantalla_divisor.dart';

void main() {
  const controller = DivisorController(
    validarEntrada: ValidarEntrada(),
    calcularDivision: CalcularDivision(),
    redondeoExacto: RedondeoExacto(),
    redondeoHaciaArriba: RedondeoHaciaArriba(),
    formateadorMoneda: FormateadorMoneda(),
  );

  runApp(const DivisorCuentaApp(controller: controller));
}

class DivisorCuentaApp extends StatelessWidget {
  const DivisorCuentaApp({super.key, required this.controller});

  final DivisorController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Divisor de cuenta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: PantallaDivisor(controller: controller),
    );
  }
}
