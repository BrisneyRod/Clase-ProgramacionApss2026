import 'package:flutter_test/flutter_test.dart';

import 'package:deber1_estado_streams/domain/repositories/contador_repository.dart';
import 'package:deber1_estado_streams/domain/usecases/decrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/incrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/obtener_contador.dart';
import 'package:deber1_estado_streams/main.dart';

class _RepositorioMemoria implements ContadorRepository {
  int valor = 5;

  @override
  Future<int> leer() async => valor;

  @override
  Future<void> guardar(int nuevoValor) async {
    valor = nuevoValor;
  }
}

void main() {
  testWidgets('Carga, modifica y devuelve el contador entre pantallas', (
    tester,
  ) async {
    final repository = _RepositorioMemoria();
    await tester.pumpWidget(
      MyApp(
        obtenerContador: ObtenerContador(repository),
        incrementar: Incrementar(repository),
        decrementar: Decrementar(repository),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Contador: 5'), findsOneWidget);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 5'), findsOneWidget);
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 6'), findsOneWidget);
    expect(repository.valor, 6);
    await tester.tap(find.text('-1'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 5'), findsOneWidget);
    await tester.tap(find.text('-1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 4'), findsOneWidget);
    expect(repository.valor, 4);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 4'), findsOneWidget);
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Contador: 5'), findsOneWidget);
    expect(find.text('Ir a Control'), findsOneWidget);
  });
}
