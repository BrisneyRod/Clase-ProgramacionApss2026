import 'package:flutter_test/flutter_test.dart';
import 'package:participacion_semana7/main.dart';

void main() {
  testWidgets('calcula pagos con una persona de valor fijo', (tester) async {
    await tester.pumpWidget(const BillSplitterApp());

    await tester.enterText(find.bySemanticsLabel('Monto total'), '100');
    await tester.enterText(find.bySemanticsLabel('Numero de personas'), '4');
    await tester.enterText(find.bySemanticsLabel('Propina'), '20');
    await tester.tap(find.text('Una persona paga un valor fijo'));
    await tester.pump();
    await tester.enterText(
      find.bySemanticsLabel('Valor fijo de esa persona'),
      '20',
    );
    await tester.enterText(find.bySemanticsLabel('Pagan menos'), '1');
    await tester.enterText(find.bySemanticsLabel('Pagan mas'), '1');
    await tester.pump();

    expect(find.text(r'$20.00'), findsOneWidget);
    expect(find.text(r'$25.00'), findsOneWidget);
    expect(find.text(r'$33.33'), findsOneWidget);
    expect(find.text(r'$41.67'), findsOneWidget);
    expect(find.text(r'Propina: $20.00'), findsOneWidget);
    expect(find.text(r'Total con propina: $120.00'), findsOneWidget);
    expect(find.text(r'Restante a repartir: $100.00'), findsOneWidget);
  });
}
