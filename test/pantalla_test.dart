import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:participacion_semana7/data/redondeo_exacto.dart';
import 'package:participacion_semana7/data/redondeo_hacia_arriba.dart';
import 'package:participacion_semana7/domain/calcular_division.dart';
import 'package:participacion_semana7/domain/validar_entrada.dart';
import 'package:participacion_semana7/presentation/divisor_controller.dart';
import 'package:participacion_semana7/presentation/formateador_moneda.dart';
import 'package:participacion_semana7/presentation/pantalla_divisor.dart';

void main() {
  testWidgets('calcula y muestra 27.50', (tester) async {
    await _pumpPantalla(tester);

    await tester.enterText(find.bySemanticsLabel('Monto total'), '100');
    await tester.enterText(find.bySemanticsLabel('Numero de personas'), '4');
    await tester.enterText(find.bySemanticsLabel('Propina'), '10');
    await tester.tap(find.text('Calcular'));
    await tester.pump();

    expect(find.text('Paga cada persona: 27.50'), findsOneWidget);
  });

  testWidgets('muestra error cuando hay cero personas', (tester) async {
    await _pumpPantalla(tester);

    await tester.enterText(find.bySemanticsLabel('Monto total'), '50');
    await tester.enterText(find.bySemanticsLabel('Numero de personas'), '0');
    await tester.enterText(find.bySemanticsLabel('Propina'), '0');
    await tester.tap(find.text('Calcular'));
    await tester.pump();

    expect(find.text('Debe haber al menos una persona'), findsOneWidget);
    expect(find.byKey(const Key('resultado')), findsNothing);
  });

  testWidgets('muestra error cuando el monto no es numerico', (tester) async {
    await _pumpPantalla(tester);

    await tester.enterText(find.bySemanticsLabel('Monto total'), 'abc');
    await tester.enterText(find.bySemanticsLabel('Numero de personas'), '4');
    await tester.enterText(find.bySemanticsLabel('Propina'), '0');
    await tester.tap(find.text('Calcular'));
    await tester.pump();

    expect(find.text('Monto inválido'), findsOneWidget);
  });
}

Future<void> _pumpPantalla(WidgetTester tester) async {
  const controller = DivisorController(
    validarEntrada: ValidarEntrada(),
    calcularDivision: CalcularDivision(),
    redondeoExacto: RedondeoExacto(),
    redondeoHaciaArriba: RedondeoHaciaArriba(),
    formateadorMoneda: FormateadorMoneda(),
  );

  await tester.pumpWidget(
    const MaterialApp(home: PantallaDivisor(controller: controller)),
  );
}
