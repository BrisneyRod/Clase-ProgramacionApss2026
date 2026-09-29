import 'package:flutter/material.dart';

void main() {
  runApp(const BillSplitterApp());
}

class BillSplitterApp extends StatelessWidget {
  const BillSplitterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Divisor de cuenta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const BillSplitterPage(),
    );
  }
}

class BillSplitterPage extends StatefulWidget {
  const BillSplitterPage({super.key});

  @override
  State<BillSplitterPage> createState() => _BillSplitterPageState();
}

class _BillSplitterPageState extends State<BillSplitterPage> {
  final _totalController = TextEditingController();
  final _peopleController = TextEditingController(text: '2');
  final _tipController = TextEditingController(text: '10');
  final _lessPeopleController = TextEditingController(text: '0');
  final _morePeopleController = TextEditingController(text: '0');

  @override
  void dispose() {
    _totalController.dispose();
    _peopleController.dispose();
    _tipController.dispose();
    _lessPeopleController.dispose();
    _morePeopleController.dispose();
    super.dispose();
  }

  double get _total => double.tryParse(_totalController.text) ?? 0;
  int get _people => int.tryParse(_peopleController.text) ?? 0;
  double get _tipPercent => double.tryParse(_tipController.text) ?? 0;
  int get _lessPeople => int.tryParse(_lessPeopleController.text) ?? 0;
  int get _morePeople => int.tryParse(_morePeopleController.text) ?? 0;
  int get _normalPeople =>
      (_people - _lessPeople - _morePeople).clamp(0, _people);

  double get _tipAmount => _total * (_tipPercent / 100);
  double get _grandTotal => _total + _tipAmount;
  double get _weightedUnits =>
      (_lessPeople * 0.75) + _normalPeople + (_morePeople * 1.25);
  double get _baseShare => _weightedUnits > 0 ? _grandTotal / _weightedUnits : 0;
  double get _lessShare => _baseShare * 0.75;
  double get _normalShare => _baseShare;
  double get _moreShare => _baseShare * 1.25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Divisor de cuenta')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Calcula cuanto paga cada persona',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _totalController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Monto total',
                prefixText: r'$ ',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _peopleController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Numero de personas',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tipController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Propina',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lessPeopleController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Pagan menos',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _morePeopleController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Pagan mas',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pago por persona'),
                    const SizedBox(height: 8),
                    Text(
                      'Normal: \$${_normalShare.toStringAsFixed(2)}',
                      key: const Key('normal-share'),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 16),
                    Text('Pagan menos: \$${_lessShare.toStringAsFixed(2)}'),
                    Text('Pagan mas: \$${_moreShare.toStringAsFixed(2)}'),
                    Text('Personas normales: $_normalPeople'),
                    Text('Propina: \$${_tipAmount.toStringAsFixed(2)}'),
                    Text(
                      'Total con propina: \$${_grandTotal.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
