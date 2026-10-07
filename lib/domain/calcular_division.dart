import 'cuenta.dart';
import 'estrategia_redondeo.dart';
import 'resultado.dart';

class CalcularDivision {
  const CalcularDivision();

  static const porcentajeBase = 100;

  Resultado ejecutar(Cuenta cuenta, EstrategiaRedondeo estrategiaRedondeo) {
    final propina =
        cuenta.montoTotal * (cuenta.porcentajePropina / porcentajeBase);
    final totalConPropina = cuenta.montoTotal + propina;
    final pagoBase = totalConPropina / cuenta.numeroPersonas;
    final pagoRedondeado = estrategiaRedondeo.aplicar(pagoBase);

    return Resultado(pagoPorPersona: pagoRedondeado);
  }
}
