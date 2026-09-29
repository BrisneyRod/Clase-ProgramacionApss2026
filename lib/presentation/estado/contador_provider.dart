import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/contador_repository.dart';
import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

final contadorRepositoryProvider = Provider<ContadorRepository>((ref) {
  throw UnimplementedError('Configura el repositorio en main.dart');
});

final obtenerContadorProvider = Provider<ObtenerContador>((ref) {
  return ObtenerContador(ref.watch(contadorRepositoryProvider));
});

final incrementarProvider = Provider<Incrementar>((ref) {
  return Incrementar(ref.watch(contadorRepositoryProvider));
});

final decrementarProvider = Provider<Decrementar>((ref) {
  return Decrementar(ref.watch(contadorRepositoryProvider));
});

final contadorProvider = AsyncNotifierProvider<ContadorNotifier, int>(
  ContadorNotifier.new,
);

class ContadorNotifier extends AsyncNotifier<int> {
  @override
  Future<int> build() {
    return ref.watch(obtenerContadorProvider).call();
  }

  Future<void> cargar() async {
    state = const AsyncLoading<int>();
    state = await AsyncValue.guard(() {
      return ref.read(obtenerContadorProvider).call();
    });
  }

  Future<void> incrementar() async {
    state = await AsyncValue.guard(() {
      return ref.read(incrementarProvider).call();
    });
  }

  Future<void> decrementar() async {
    state = await AsyncValue.guard(() {
      return ref.read(decrementarProvider).call();
    });
  }
}
