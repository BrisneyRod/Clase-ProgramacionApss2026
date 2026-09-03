// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:contador_con_botones/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Verify that the bottom button has no action.
    final bottomButton = find.widgetWithText(ElevatedButton, 'Botón');
    expect(tester.widget<ElevatedButton>(bottomButton).onPressed, isNull);

    // Verify that the second bottom button has no action either.
    final secondBottomButton = find.widgetWithText(
      ElevatedButton,
      'Segundo botón',
    );
    expect(tester.widget<ElevatedButton>(secondBottomButton).onPressed, isNull);

    // Tap the '+' button and trigger a frame.
    await tester.tap(find.text('+'));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
