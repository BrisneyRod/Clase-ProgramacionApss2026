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

    // Tap the '+' button and trigger a frame.
    await tester.tap(find.text('+'));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Second button opens the image route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    final secondBottomButton = find.widgetWithText(
      ElevatedButton,
      'Segundo botón',
    );
    expect(
      tester.widget<ElevatedButton>(secondBottomButton).onPressed,
      isNotNull,
    );

    await tester.ensureVisible(secondBottomButton);
    await tester.tap(secondBottomButton);
    await tester.pumpAndSettle();

    expect(find.text('Ventana con imagen'), findsOneWidget);
    expect(find.byKey(const Key('routeImage')), findsOneWidget);
    final imagePageRoute = ModalRoute.of(
      tester.element(find.byType(ImagePage)),
    );
    expect(imagePageRoute?.settings.name, ImagePage.routeName);
  });
}
