import 'package:flutter_test/flutter_test.dart';
import 'package:participacion_semana7/main.dart';

void main() {
  testWidgets('calcula pagos normales, menores y mayores', (tester) async {
    await tester.pumpWidget(const BillSplitterApp());

    await tester.enterText(find.bySemanticsLabel('Monto total'), '100');
    await tester.enterText(find.bySemanticsLabel('Numero de personas'), '4');
    await tester.enterText(find.bySemanticsLabel('Propina'), '20');
    await tester.enterText(find.bySemanticsLabel('Pagan menos'), '1');
    await tester.enterText(find.bySemanticsLabel('Pagan mas'), '1');
    await tester.pump();

    expect(find.text(r'Normal: $30.00'), findsOneWidget);
    expect(find.text(r'Pagan menos: $22.50'), findsOneWidget);
    expect(find.text(r'Pagan mas: $37.50'), findsOneWidget);
    expect(find.text(r'Propina: $20.00'), findsOneWidget);
    expect(find.text(r'Total con propina: $120.00'), findsOneWidget);
  });
}
