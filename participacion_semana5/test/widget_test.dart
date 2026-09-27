import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:participacion_semana5/domain/entities/usuario.dart';
import 'package:participacion_semana5/domain/repositories/usuario_repository.dart';
import 'package:participacion_semana5/domain/usecases/obtener_usuarios_con_vocal.dart';
import 'package:participacion_semana5/main.dart';

class RepositorioPrueba implements UsuarioRepository {
  RepositorioPrueba(this.responder);

  final Future<List<Usuario>> Function() responder;
  int llamadas = 0;

  @override
  Future<List<Usuario>> obtener() {
    llamadas++;
    return responder();
  }
}

void main() {
  testWidgets('Carga y muestra los usuarios del caso de uso inyectado', (
    tester,
  ) async {
    final respuesta = Completer<List<Usuario>>();
    final repositorio = RepositorioPrueba(() => respuesta.future);
    final casoDeUso = ObtenerUsuariosConVocal(repositorio);

    await tester.pumpWidget(MyApp(obtenerUsuariosConVocal: casoDeUso));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    respuesta.complete(const [
      Usuario(id: 1, nombre: 'Ana', email: 'ana@example.com'),
      Usuario(id: 2, nombre: 'erika', email: 'erika@example.com'),
      Usuario(id: 3, nombre: 'Bruno', email: 'bruno@example.com'),
    ]);
    await tester.pumpAndSettle();
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('erika'), findsOneWidget);
    expect(find.text('ana@example.com'), findsOneWidget);
    expect(find.text('Bruno'), findsNothing);
    expect(find.byType(ListTile), findsNWidgets(2));

    await tester.pumpWidget(MyApp(obtenerUsuariosConVocal: casoDeUso));
    await tester.pumpAndSettle();
    expect(repositorio.llamadas, 1);
  });

  testWidgets('Muestra error y reintenta mediante el caso de uso', (
    tester,
  ) async {
    var intentos = 0;
    final repositorio = RepositorioPrueba(() async {
      intentos++;
      if (intentos == 1) throw Exception('Sin conexión');
      return [];
    });
    await tester.pumpWidget(
      MyApp(obtenerUsuariosConVocal: ObtenerUsuariosConVocal(repositorio)),
    );
    await tester.pumpAndSettle();
    expect(find.text('No se pudieron cargar los usuarios.'), findsOneWidget);
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(repositorio.llamadas, 2);
    expect(
      find.text('No hay usuarios cuyo nombre empiece con vocal.'),
      findsOneWidget,
    );
  });
}
