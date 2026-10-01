import 'package:flutter/material.dart';

import 'divisor_controller.dart';

class PantallaDivisor extends StatefulWidget {
  const PantallaDivisor({super.key, required this.controller});

  final DivisorController controller;

  @override
  State<PantallaDivisor> createState() => _PantallaDivisorState();
}

class _PantallaDivisorState extends State<PantallaDivisor> {
  final _montoController = TextEditingController();
  final _personasController = TextEditingController();
  final _propinaController = TextEditingController();

  ModoRedondeo _modoRedondeo = ModoRedondeo.exacto;
  EstadoDivisor _estado = const EstadoDivisor();

  @override
  void dispose() {
    _montoController.dispose();
    _personasController.dispose();
    _propinaController.dispose();
    super.dispose();
  }

  void _calcular() {
    final estado = widget.controller.calcular(
      montoTexto: _montoController.text,
      personasTexto: _personasController.text,
      propinaTexto: _propinaController.text,
      modoRedondeo: _modoRedondeo,
    );

    setState(() => _estado = estado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Divisor de cuenta')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Divide la cuenta',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _montoController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Monto total',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _personasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Numero de personas',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _propinaController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Propina',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SegmentedButton<ModoRedondeo>(
              segments: const [
                ButtonSegment(
                  value: ModoRedondeo.exacto,
                  label: Text('Exacto'),
                ),
                ButtonSegment(
                  value: ModoRedondeo.haciaArriba,
                  label: Text('Hacia arriba'),
                ),
              ],
              selected: {_modoRedondeo},
              onSelectionChanged: (seleccion) {
                setState(() => _modoRedondeo = seleccion.first);
              },
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _calcular, child: const Text('Calcular')),
            const SizedBox(height: 20),
            if (_estado.tieneError)
              Text(
                _estado.error!,
                key: const Key('mensaje-error'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            if (_estado.tieneResultado)
              Text(
                'Paga cada persona: ${_estado.resultado}',
                key: const Key('resultado'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
          ],
        ),
      ),
    );
  }
}
