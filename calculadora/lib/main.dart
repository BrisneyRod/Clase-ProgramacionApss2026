import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String numero1 = '';
  String numero2 = '';
  String operador = '';
  String resultado = '0';

  void presionarNumero(String numero) {
    setState(() {
      if (operador.isEmpty) {
        numero1 += numero;
        resultado = numero1;
      } else {
        numero2 += numero;
        resultado = numero2;
      }
    });
  }

  void seleccionarOperador(String op) {
    if (numero1.isNotEmpty) {
      setState(() {
        operador = op;
      });
    }
  }

  void calcular() {
    if (numero1.isEmpty || numero2.isEmpty || operador.isEmpty) {
      return;
    }

    double n1 = double.parse(numero1);
    double n2 = double.parse(numero2);
    double respuesta = 0;

    switch (operador) {
      case '+':
        respuesta = n1 + n2;
        break;

      case '-':
        respuesta = n1 - n2;
        break;

      case '×':
        respuesta = n1 * n2;
        break;

      case '÷':
        if (n2 == 0) {
          setState(() {
            resultado = 'Error';
          });
          return;
        }

        respuesta = n1 / n2;
        break;
    }

    setState(() {
      if (respuesta % 1 == 0) {
        resultado = respuesta.toInt().toString();
      } else {
        resultado = respuesta.toString();
      }

      numero1 = resultado;
      numero2 = '';
      operador = '';
    });
  }

  void limpiar() {
    setState(() {
      numero1 = '';
      numero2 = '';
      operador = '';
      resultado = '0';
    });
  }

  Widget boton(String texto, {VoidCallback? accion}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ElevatedButton(
          onPressed: accion,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 22),
          ),
          child: Text(
            texto,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              alignment: Alignment.bottomRight,
              child: Text(
                resultado,
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Row(
            children: [
              boton('C', accion: limpiar),
              boton('÷', accion: () => seleccionarOperador('÷')),
            ],
          ),

          Row(
            children: [
              boton('7', accion: () => presionarNumero('7')),
              boton('8', accion: () => presionarNumero('8')),
              boton('9', accion: () => presionarNumero('9')),
              boton('×', accion: () => seleccionarOperador('×')),
            ],
          ),

          Row(
            children: [
              boton('4', accion: () => presionarNumero('4')),
              boton('5', accion: () => presionarNumero('5')),
              boton('6', accion: () => presionarNumero('6')),
              boton('-', accion: () => seleccionarOperador('-')),
            ],
          ),

          Row(
            children: [
              boton('1', accion: () => presionarNumero('1')),
              boton('2', accion: () => presionarNumero('2')),
              boton('3', accion: () => presionarNumero('3')),
              boton('+', accion: () => seleccionarOperador('+')),
            ],
          ),

          Row(
            children: [
              boton('0', accion: () => presionarNumero('0')),
              boton('=', accion: calcular),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}