import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

class ContadorCubit extends Cubit<int> {
  ContadorCubit({
    required ObtenerContador obtenerContador,
    required Incrementar incrementar,
    required Decrementar decrementar,
  }) : this._(
         obtenerContador: obtenerContador,
         incrementar: incrementar,
         decrementar: decrementar,
       );

  ContadorCubit._({
    required this._obtenerContador,
    required this._incrementar,
    required this._decrementar,
  }) : super(0);

  final ObtenerContador _obtenerContador;
  final Incrementar _incrementar;
  final Decrementar _decrementar;

  Future<void> cargar() async {
    final valor = await _obtenerContador();
    emit(valor);
  }

  Future<void> incrementar() async {
    final valor = await _incrementar();
    emit(valor);
  }

  Future<void> decrementar() async {
    final valor = await _decrementar();
    emit(valor);
  }
}
