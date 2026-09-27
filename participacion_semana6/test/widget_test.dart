import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:participacion_semana6/domain/entities/perfil.dart';
import 'package:participacion_semana6/domain/repositories/auth_repository.dart';
import 'package:participacion_semana6/domain/repositories/perfiles_repository.dart';
import 'package:participacion_semana6/domain/usecases/registrar_usuario.dart';
import 'package:participacion_semana6/main.dart';
import 'package:participacion_semana6/presentation/providers/perfiles_provider.dart';
import 'package:participacion_semana6/presentation/providers/sesion_provider.dart';

void main() {
  testWidgets('Registro, cierre de sesion, ingreso y error de clave', (
    tester,
  ) async {
    final auth = _AuthFake();
    final perfiles = _PerfilesFake();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) =>
                SesionProvider(auth, RegistrarUsuario(auth, perfiles)),
          ),
          ChangeNotifierProvider(create: (_) => PerfilesProvider(perfiles)),
        ],
        child: const MyApp(),
      ),
    );

    Future<void> completar(String clave) async {
      await tester.enterText(find.byType(TextField).at(0), 'ana@example.com');
      await tester.enterText(find.byType(TextField).at(1), clave);
      await tester.enterText(find.byType(TextField).at(2), 'Ana');
    }

    Future<void> pulsar(String texto) async {
      final boton = texto == 'Cerrar sesión'
          ? find.byTooltip(texto)
          : find.text(texto);
      await tester.ensureVisible(boton);
      await tester.tap(boton);
      await tester.pumpAndSettle();
    }

    expect(find.text('Ingresar'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).obscureText,
      isTrue,
    );
    await completar('correcta');
    await pulsar('Crear cuenta');
    expect(perfiles.creados, [('usuario-id', 'Ana')]);
    expect(find.text('Usuarios'), findsOneWidget);
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('2026-09-26 00:00:00.000'), findsOneWidget);
    expect(perfiles.cargas, 1);
    await tester.tap(find.byTooltip('Recargar'));
    await tester.pumpAndSettle();
    expect(perfiles.cargas, 2);

    await pulsar('Cerrar sesión');
    expect(find.text('Ingresar'), findsOneWidget);
    expect(auth.id, isNull);
    await completar('correcta');
    await pulsar('Ingresar');
    expect(find.text('Usuarios'), findsOneWidget);

    await pulsar('Cerrar sesión');
    await completar('incorrecta');
    await pulsar('Ingresar');
    final error = find.text('Exception: Credenciales incorrectas');
    expect(error, findsOneWidget);
    expect(tester.widget<Text>(error).style?.color, Colors.red);
    expect(find.text('Ingresar'), findsOneWidget);
  });
}

class _AuthFake implements AuthRepository {
  String? id;

  @override
  Future<String> registrar(String correo, String clave) async {
    id = 'usuario-id';
    return id!;
  }

  @override
  Future<void> ingresar(String correo, String clave) async {
    if (correo != 'ana@example.com' || clave != 'correcta') {
      throw Exception('Credenciales incorrectas');
    }
    id = 'usuario-id';
  }

  @override
  Future<void> salir() async => id = null;

  @override
  String? obtenerIdActual() => id;
}

class _PerfilesFake implements PerfilesRepository {
  final creados = <(String, String)>[];
  int cargas = 0;

  @override
  Future<void> crear(String id, String nombre) async =>
      creados.add((id, nombre));

  @override
  Future<List<Perfil>> obtenerTodos() async {
    cargas++;
    return creados
        .map(
          (datos) => Perfil(
            id: datos.$1,
            nombre: datos.$2,
            creadoEn: DateTime(2026, 9, 26),
          ),
        )
        .toList();
  }
}
