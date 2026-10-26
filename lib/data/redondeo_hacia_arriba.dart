import '../domain/estrategia_redondeo.dart';

class RedondeoHaciaArriba implements EstrategiaRedondeo {
  const RedondeoHaciaArriba();

  @override
  double aplicar(double valor) => valor.ceilToDouble();
}
