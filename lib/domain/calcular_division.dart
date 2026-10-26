import 'cuenta.dart';
import 'estrategia_redondeo.dart';
import 'resultado.dart';

class CalcularDivision {
  const CalcularDivision();

  Resultado ejecutar(Cuenta cuenta, EstrategiaRedondeo estrategiaRedondeo) {
    final propina = cuenta.montoTotal * (cuenta.porcentajePropina / 100);
    final totalConPropina = cuenta.montoTotal + propina;
    final pagoBase = totalConPropina / cuenta.numeroPersonas;
    final pagoRedondeado = estrategiaRedondeo.aplicar(pagoBase);

    return Resultado(pagoPorPersona: pagoRedondeado);
  }
}
