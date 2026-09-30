import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:participacion_semana7/main.dart';

void main() {
  testWidgets('calcula pagos con varias personas de valor fijo', (tester) async {
    await tester.pumpWidget(const BillSplitterApp());

    await tester.enterText(find.bySemanticsLabel('Monto total'), '100');
    await tester.enterText(find.bySemanticsLabel('Numero de personas'), '6');
    await tester.enterText(find.bySemanticsLabel('Propina'), '20');
    await tester.tap(find.text('Hay personas con valor fijo'));
    await tester.pump();
    await tester.enterText(find.bySemanticsLabel('Personas fijas'), '2');
    await tester.enterText(find.bySemanticsLabel('Valor fijo'), '20');
    await tester.enterText(find.bySemanticsLabel('Pagan menos'), '1');
    await tester.enterText(find.bySemanticsLabel('Pagan mas'), '1');
    await tester.pump();

    expect(_textForKey(tester, 'Pago fijo-amount'), r'$20.00');
    expect(_textForKey(tester, 'Pagan menos-amount'), r'$15.00');
    expect(_textForKey(tester, 'Normal-amount'), r'$20.00');
    expect(_textForKey(tester, 'Pagan mas-amount'), r'$25.00');
    expect(find.text(r'Propina: $20.00'), findsOneWidget);
    expect(find.text(r'Total con propina: $120.00'), findsOneWidget);
    expect(find.text(r'Total fijo: $40.00'), findsOneWidget);
    expect(find.text(r'Restante a repartir: $80.00'), findsOneWidget);
  });
}

String _textForKey(WidgetTester tester, String key) {
  final text = tester.widget<Text>(find.byKey(Key(key)));
  return text.data ?? '';
}
