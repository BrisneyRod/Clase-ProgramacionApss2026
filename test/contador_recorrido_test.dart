import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:deber1_estado_streams/main.dart' as app;

void main() {
  testWidgets('Tres incrementos, recreacion de app y regreso del sistema', (
    tester,
  ) async {
    // Almacenamiento simulado: no equivale a cerrar un proceso Android real.
    SharedPreferences.setMockInitialValues({});
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Contador: 0'), findsOneWidget);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('+1'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 3'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('contador'), 3);

    // Desmonta todo el estado de UI y crea nuevos repositorio y casos de uso.
    await tester.pumpWidget(const SizedBox.shrink());
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Contador: 3'), findsOneWidget);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Ir a Control'), findsOneWidget);
    expect(find.text('Contador: 4'), findsOneWidget);
    expect(prefs.getInt('contador'), 4);
  });
}
