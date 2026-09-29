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

  @override
  void dispose() {
    _totalController.dispose();
    _peopleController.dispose();
    _tipController.dispose();
    super.dispose();
  }

  double get _total => double.tryParse(_totalController.text) ?? 0;
  int get _people => int.tryParse(_peopleController.text) ?? 0;
  double get _tipPercent => double.tryParse(_tipController.text) ?? 0;

  double get _tipAmount => _total * (_tipPercent / 100);
  double get _grandTotal => _total + _tipAmount;
  double get _amountPerPerson => _people > 0 ? _grandTotal / _people : 0;

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
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cada persona paga'),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_amountPerPerson.toStringAsFixed(2)}',
                      key: const Key('amount-per-person'),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 16),
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
