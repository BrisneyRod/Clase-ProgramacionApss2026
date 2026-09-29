import 'package:deber1_estado_streams/domain/repositories/contador_repository.dart';
import 'package:deber1_estado_streams/domain/usecases/decrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/incrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/obtener_contador.dart';
import 'package:deber1_estado_streams/presentation/estado/contador_cubit.dart';
import 'package:deber1_estado_streams/presentation/pantallas/pantalla_visor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _RepositorioMemoria implements ContadorRepository {
  _RepositorioMemoria(this.valor);

  int valor;

  @override
  Future<int> leer() async => valor;

  @override
  Future<void> guardar(int valor) async {
    this.valor = valor;
  }
}

Widget _crearApp(_RepositorioMemoria repository) {
  return BlocProvider(
    create: (_) => ContadorCubit(
      obtenerContador: ObtenerContador(repository),
      incrementar: Incrementar(repository),
      decrementar: Decrementar(repository),
    )..cargar(),
    child: MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PantallaVisor(),
    ),
  );
}

void main() {
  testWidgets('BLoC comparte el contador entre pantallas', (tester) async {
    final repository = _RepositorioMemoria(0);

    await tester.pumpWidget(_crearApp(repository));
    await tester.pumpAndSettle();

    expect(find.text('Contador: 0'), findsOneWidget);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();

    expect(find.text('Contador: 3'), findsOneWidget);
    expect(repository.valor, 3);

    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();

    expect(find.text('Visor'), findsOneWidget);
    expect(find.text('Contador: 3'), findsOneWidget);
  });

  testWidgets('el boton atras del sistema mantiene actualizado el visor', (
    tester,
  ) async {
    final repository = _RepositorioMemoria(3);

    await tester.pumpWidget(_crearApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();

    expect(repository.valor, 4);
    expect(find.text('Contador: 4'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Visor'), findsOneWidget);
    expect(find.text('Contador: 4'), findsOneWidget);
  });
}
