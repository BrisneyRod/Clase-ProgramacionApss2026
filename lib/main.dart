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
  final _fixedPeopleController = TextEditingController(text: '0');
  final _fixedAmountController = TextEditingController(text: '0');

  bool _hasFixedPayer = false;

  @override
  void dispose() {
    _totalController.dispose();
    _peopleController.dispose();
    _tipController.dispose();
    _lessPeopleController.dispose();
    _morePeopleController.dispose();
    _fixedPeopleController.dispose();
    _fixedAmountController.dispose();
    super.dispose();
  }

  double get _total => double.tryParse(_totalController.text) ?? 0;
  int get _people => int.tryParse(_peopleController.text) ?? 0;
  double get _tipPercent => double.tryParse(_tipController.text) ?? 0;
  int get _lessPeople => int.tryParse(_lessPeopleController.text) ?? 0;
  int get _morePeople => int.tryParse(_morePeopleController.text) ?? 0;
  int get _fixedPeopleInput =>
      _hasFixedPayer ? int.tryParse(_fixedPeopleController.text) ?? 0 : 0;
  int get _fixedPeople => _fixedPeopleInput.clamp(0, _people).toInt();
  double get _fixedAmountPerPerson =>
      _hasFixedPayer ? double.tryParse(_fixedAmountController.text) ?? 0 : 0;
  double get _fixedTotal => _fixedPeople * _fixedAmountPerPerson;
  int get _flexiblePeople => (_people - _fixedPeople).clamp(0, _people).toInt();
  int get _safeLessPeople => _lessPeople.clamp(0, _flexiblePeople).toInt();
  int get _safeMorePeople =>
      _morePeople.clamp(0, _flexiblePeople - _safeLessPeople).toInt();
  int get _normalPeople =>
      (_flexiblePeople - _safeLessPeople - _safeMorePeople)
          .clamp(0, _people)
          .toInt();

  double get _tipAmount => _total * (_tipPercent / 100);
  double get _grandTotal => _total + _tipAmount;
  double get _remainingTotal =>
      (_grandTotal - _fixedTotal).clamp(0, _grandTotal).toDouble();
  double get _weightedUnits =>
      (_safeLessPeople * 0.75) + _normalPeople + (_safeMorePeople * 1.25);
  double get _baseShare =>
      _weightedUnits > 0 ? _remainingTotal / _weightedUnits : 0;
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
              'Divide la cuenta a tu manera',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'Puedes dejar personas con pago fijo y repartir el resto.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            _section(
              title: 'Cuenta',
              children: [
                _numberField(
                  controller: _totalController,
                  label: 'Monto total',
                  prefixText: r'$ ',
                  decimal: true,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _numberField(
                        controller: _peopleController,
                        label: 'Numero de personas',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _numberField(
                        controller: _tipController,
                        label: 'Propina',
                        suffixText: '%',
                        decimal: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _section(
              title: 'Pago fijo',
              children: [
                SwitchListTile(
                  value: _hasFixedPayer,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Hay personas con valor fijo'),
                  subtitle: const Text(
                    'Ese valor se descuenta antes de repartir',
                  ),
                  onChanged: (value) => setState(() => _hasFixedPayer = value),
                ),
                if (_hasFixedPayer)
                  Row(
                    children: [
                      Expanded(
                        child: _numberField(
                          controller: _fixedPeopleController,
                          label: 'Personas fijas',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _numberField(
                          controller: _fixedAmountController,
                          label: 'Valor fijo',
                          prefixText: r'$ ',
                          decimal: true,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _section(
              title: 'Reparto del resto',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _numberField(
                        controller: _lessPeopleController,
                        label: 'Pagan menos',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _numberField(
                        controller: _morePeopleController,
                        label: 'Pagan mas',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _summaryCard(context),
          ],
        ),
      ),
    );
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _numberField({
    required TextEditingController controller,
    required String label,
    String? prefixText,
    String? suffixText,
    bool decimal = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
        suffixText: suffixText,
        border: const OutlineInputBorder(),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _summaryCard(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (_hasFixedPayer)
              _summaryLine(
                'Pago fijo',
                _fixedAmountPerPerson,
                '$_fixedPeople personas',
              ),
            _summaryLine('Pagan menos', _lessShare, '$_safeLessPeople personas'),
            _summaryLine('Normal', _normalShare, '$_normalPeople personas'),
            _summaryLine('Pagan mas', _moreShare, '$_safeMorePeople personas'),
            const Divider(height: 28),
            Text('Propina: \$${_tipAmount.toStringAsFixed(2)}'),
            Text('Total con propina: \$${_grandTotal.toStringAsFixed(2)}'),
            if (_hasFixedPayer)
              Text('Total fijo: \$${_fixedTotal.toStringAsFixed(2)}'),
            Text('Restante a repartir: \$${_remainingTotal.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _summaryLine(String label, double amount, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text('$label ($detail)')),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            key: Key('$label-amount'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
