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
  testWidgets('muestra resultado exacto valido', (tester) async {
    await _pumpPantalla(tester);

    await _llenarFormulario(
      tester,
      monto: '100.00',
      personas: '4',
      propina: '10',
    );
    await tester.tap(find.text('Calcular'));
    await tester.pump();

    expect(find.text('Paga cada persona: 27.50'), findsOneWidget);
  });

  testWidgets('muestra resultado con redondeo hacia arriba', (tester) async {
    await _pumpPantalla(tester);

    await _llenarFormulario(
      tester,
      monto: '10.00',
      personas: '3',
      propina: '0',
    );
    await tester.tap(find.text('Hacia arriba'));
    await tester.pump();
    await tester.tap(find.text('Calcular'));
    await tester.pump();

    expect(find.text('Paga cada persona: 4.00'), findsOneWidget);
  });

  testWidgets('muestra error y oculta resultado anterior', (tester) async {
    await _pumpPantalla(tester);

    await _llenarFormulario(
      tester,
      monto: '10.00',
      personas: '3',
      propina: '0',
    );
    await tester.tap(find.text('Calcular'));
    await tester.pump();
    expect(find.byKey(const Key('resultado')), findsOneWidget);

    await _llenarFormulario(
      tester,
      monto: '50.00',
      personas: '0',
      propina: '0',
    );
    await tester.tap(find.text('Calcular'));
    await tester.pump();

    expect(find.text('Debe haber al menos una persona'), findsOneWidget);
    expect(find.byKey(const Key('resultado')), findsNothing);
  });

  testWidgets('muestra Monto inválido desde la pantalla', (tester) async {
    await _pumpPantalla(tester);

    await _llenarFormulario(tester, monto: 'abc', personas: '3', propina: '0');
    await tester.tap(find.text('Calcular'));
    await tester.pump();

    expect(find.text('Monto inválido'), findsOneWidget);
    expect(find.byKey(const Key('resultado')), findsNothing);
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

Future<void> _llenarFormulario(
  WidgetTester tester, {
  required String monto,
  required String personas,
  required String propina,
}) async {
  await tester.enterText(find.bySemanticsLabel('Monto total'), monto);
  await tester.enterText(find.bySemanticsLabel('Numero de personas'), personas);
  await tester.enterText(find.bySemanticsLabel('Propina'), propina);
}
