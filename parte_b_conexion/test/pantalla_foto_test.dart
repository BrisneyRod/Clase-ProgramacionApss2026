import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/presentation/pantallas/pantalla_foto.dart';

class _ConexionRepositoryMemoria implements ConexionRepository {
  _ConexionRepositoryMemoria(this.estado);

  EstadoConexion estado;

  @override
  Future<EstadoConexion> consultarAhora() async => estado;

  @override
  Stream<EstadoConexion> observarCambios() => const Stream.empty();
}

void main() {
  testWidgets('la foto de conexion no cambia hasta consultar otra vez', (
    tester,
  ) async {
    final repository = _ConexionRepositoryMemoria(EstadoConexion.wifi);

    await tester.pumpWidget(
      MaterialApp(
        home: PantallaFoto(consultarConexion: ConsultarConexion(repository)),
      ),
    );

    await tester.tap(find.text('Consultar ahora'));
    await tester.pumpAndSettle();

    expect(find.text('Wi-Fi'), findsOneWidget);
    expect(find.text('Sin conexion'), findsNothing);

    repository.estado = EstadoConexion.sinConexion;
    await tester.pumpAndSettle();

    expect(find.text('Wi-Fi'), findsOneWidget);
    expect(find.text('Sin conexion'), findsNothing);

    await tester.tap(find.text('Consultar ahora'));
    await tester.pumpAndSettle();

    expect(find.text('Wi-Fi'), findsNothing);
    expect(find.text('Sin conexion'), findsOneWidget);
  });
}
