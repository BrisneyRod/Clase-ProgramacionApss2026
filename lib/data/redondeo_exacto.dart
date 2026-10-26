import '../domain/estrategia_redondeo.dart';

class RedondeoExacto implements EstrategiaRedondeo {
  const RedondeoExacto();

  @override
  double aplicar(double valor) => double.parse(valor.toStringAsFixed(2));
}
