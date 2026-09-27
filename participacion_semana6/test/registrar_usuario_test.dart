import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:participacion_semana6/domain/entities/perfil.dart';
import 'package:participacion_semana6/domain/repositories/auth_repository.dart';
import 'package:participacion_semana6/domain/repositories/perfiles_repository.dart';
import 'package:participacion_semana6/domain/usecases/registrar_usuario.dart';

void main() {
  test('Espera el registro y crea el perfil con el id devuelto', () async {
    final registro = Completer<String>();
    final auth = _AuthFake((correo, clave) {
      expect(correo, 'usuario@example.com');
      expect(clave, 'clave-prueba');
      return registro.future;
    });
    final perfiles = _PerfilesFake();
    final resultado = RegistrarUsuario(auth, perfiles)(
      'usuario@example.com',
      'clave-prueba',
      'Ana',
    );

    expect(perfiles.creados, isEmpty);
    registro.complete('usuario-id');
    await resultado;
    expect(perfiles.creados, [('usuario-id', 'Ana')]);
  });

  test('Propaga el error al crear el perfil', () async {
    final error = StateError('No se pudo crear el perfil');
    final auth = _AuthFake((_, _) async => 'usuario-id');
    final perfiles = _PerfilesFake(error: error);

    await expectLater(
      RegistrarUsuario(auth, perfiles)('correo', 'clave', 'Ana'),
      throwsA(same(error)),
    );
    expect(perfiles.creados, [('usuario-id', 'Ana')]);
  });

  test('No crea un perfil cuando falla el registro', () async {
    final error = StateError('No se pudo registrar');
    final auth = _AuthFake((_, _) async => throw error);
    final perfiles = _PerfilesFake();

    await expectLater(
      RegistrarUsuario(auth, perfiles)('correo', 'clave', 'Ana'),
      throwsA(same(error)),
    );
    expect(perfiles.creados, isEmpty);
  });
}

class _AuthFake implements AuthRepository {
  final Future<String> Function(String, String) registrarCuenta;

  _AuthFake(this.registrarCuenta);

  @override
  Future<String> registrar(String correo, String clave) =>
      registrarCuenta(correo, clave);

  @override
  Future<void> ingresar(String correo, String clave) =>
      throw UnimplementedError();

  @override
  Future<void> salir() => throw UnimplementedError();

  @override
  String? obtenerIdActual() => throw UnimplementedError();
}

class _PerfilesFake implements PerfilesRepository {
  final Object? error;
  final creados = <(String, String)>[];

  _PerfilesFake({this.error});

  @override
  Future<void> crear(String id, String nombre) async {
    creados.add((id, nombre));
    final fallo = error;
    if (fallo != null) throw fallo;
  }

  @override
  Future<List<Perfil>> obtenerTodos() => throw UnimplementedError();
}
