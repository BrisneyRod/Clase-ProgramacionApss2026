import 'dart:async';

import 'package:aplicacion_apis/main.dart';
import 'package:aplicacion_apis/video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('Extrae el iframe y conserva los parámetros del video', () {
    final url = obtenerUrlVideo([
      {'embed': '<div>Sin video</div>'},
      {
        'embed': '<iframe src="https://www.scorebat.com/embed/v/123/?a=1&amp;b=2"></iframe>',
      },
    ]);
    expect(url.toString(), 'https://www.scorebat.com/embed/v/123/?a=1&b=2');
    expect(
      obtenerUrlVideo([
        {'embed': '<iframe src="javascript:alert(1)"></iframe>'},
      ]),
      isNull,
    );
    expect(obtenerUrlVideo([]), isNull);
  });

  testWidgets('Habilita Ver video solo cuando hay un iframe válido', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PartidosPage(
          cargar: () async => [
            {
              'title': 'Con video',
              'videos': [
                {
                  'embed': '<iframe src="https://www.scorebat.com/embed/v/123/"></iframe>',
                },
              ],
            },
            {'title': 'Sin resumen', 'videos': []},
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    final activo = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Ver video'),
    );
    final inactivo = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Sin video'),
    );
    expect(activo.onPressed, isNotNull);
    expect(inactivo.onPressed, isNull);
  });

  test('Lee la respuesta de ScoreBat', () async {
    final client = MockClient((request) async {
      expect(request.url.toString(), 'https://www.scorebat.com/video-api/v3/');
      return http.Response('{"response":[{"title":"A - B"}]}', 200);
    });
    addTearDown(client.close);
    expect((await cargarPartidos(client: client)).single['title'], 'A - B');
  });

  test('Rechaza errores HTTP y respuestas inesperadas', () async {
    for (final response in [
      http.Response('No disponible', 503),
      http.Response('{"error":"Acceso denegado"}', 200),
    ]) {
      final client = MockClient((_) async => response);
      addTearDown(client.close);
      await expectLater(cargarPartidos(client: client), throwsException);
    }
  });

  testWidgets('Muestra carga y datos del partido', (tester) async {
    final resultado = Completer<List<dynamic>>();
    await tester.pumpWidget(
      MaterialApp(home: PartidosPage(cargar: () => resultado.future)),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    resultado.complete([
      {
        'title': 'Equipo A - Equipo B',
        'competition': 'Liga de prueba',
        'date': '2026-09-10T15:00:00Z',
        'videos': [
          {'title': 'Resumen'},
        ],
      },
    ]);
    await tester.pumpAndSettle();
    expect(find.text('Equipo A - Equipo B'), findsOneWidget);
    expect(find.text('Liga de prueba'), findsOneWidget);
    expect(find.text('Videos disponibles: 1'), findsOneWidget);
  });

  testWidgets('Reintenta y actualiza una lista vacía', (tester) async {
    var intentos = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: PartidosPage(
          cargar: () async {
            intentos++;
            if (intentos == 1) throw Exception('Sin conexión');
            return [];
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('No hay partidos disponibles.'), findsOneWidget);
    await tester.tap(find.byTooltip('Actualizar'));
    await tester.pumpAndSettle();
    expect(intentos, 3);
  });
}
