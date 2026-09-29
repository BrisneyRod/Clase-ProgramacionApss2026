import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';

class ConexionCubit extends Cubit<EstadoConexion> {
  ConexionCubit({
    required ConsultarConexion consultarConexion,
    required ObservarConexion observarConexion,
  }) : this._(
         consultarConexion: consultarConexion,
         observarConexion: observarConexion,
       );

  ConexionCubit._({
    required this._consultarConexion,
    required this._observarConexion,
  }) : super(EstadoConexion.otro);

  final ConsultarConexion _consultarConexion;
  final ObservarConexion _observarConexion;
  StreamSubscription<EstadoConexion>? _subscription;

  Future<void> iniciar() async {
    emit(await _consultarConexion());
    await _subscription?.cancel();
    _subscription = _observarConexion().listen(emit);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
