import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/main.dart';

class _ConexionRepositoryMemoria implements ConexionRepository {
  _ConexionRepositoryMemoria(this.estado);

  EstadoConexion estado;
  final StreamController<EstadoConexion> controller =
      StreamController<EstadoConexion>();

  @override
  Future<EstadoConexion> consultarAhora() async => estado;

  @override
  Stream<EstadoConexion> observarCambios() => controller.stream;

  Future<void> cerrar() => controller.close();
}

void main() {
  testWidgets('muestra las pantallas Future y Stream en pestanas', (
    tester,
  ) async {
    final repository = _ConexionRepositoryMemoria(EstadoConexion.wifi);

    await tester.pumpWidget(
      MyApp(
        consultarConexion: ConsultarConexion(repository),
        observarConexion: ObservarConexion(repository),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Con Future'), findsOneWidget);
    expect(find.text('Con Stream'), findsOneWidget);
    expect(find.text('Consultar ahora'), findsOneWidget);

    await tester.tap(find.text('Con Stream'));
    await tester.pumpAndSettle();

    expect(find.text('Wi-Fi'), findsOneWidget);
    expect(find.text('Cambios recibidos: 0'), findsOneWidget);

    repository.controller.add(EstadoConexion.sinConexion);
    await tester.pumpAndSettle();

    expect(find.text('Sin conexion'), findsOneWidget);
    expect(find.text('Cambios recibidos: 1'), findsOneWidget);

    await repository.cerrar();
  });
}
