import '../domain/calcular_division.dart';
import '../domain/estrategia_redondeo.dart';
import '../domain/validar_entrada.dart';
import 'formateador_moneda.dart';

enum ModoRedondeo { exacto, haciaArriba }

class EstadoDivisor {
  const EstadoDivisor({this.resultado, this.error});

  final String? resultado;
  final String? error;

  bool get tieneResultado => resultado != null;
  bool get tieneError => error != null;
}

class DivisorController {
  const DivisorController({
    required this.validarEntrada,
    required this.calcularDivision,
    required this.redondeoExacto,
    required this.redondeoHaciaArriba,
    required this.formateadorMoneda,
  });

  final ValidarEntrada validarEntrada;
  final CalcularDivision calcularDivision;
  final EstrategiaRedondeo redondeoExacto;
  final EstrategiaRedondeo redondeoHaciaArriba;
  final FormateadorMoneda formateadorMoneda;

  EstadoDivisor calcular({
    required String montoTexto,
    required String personasTexto,
    required String propinaTexto,
    required ModoRedondeo modoRedondeo,
  }) {
    final validacion = validarEntrada.ejecutar(
      montoTexto: montoTexto,
      personasTexto: personasTexto,
      propinaTexto: propinaTexto,
    );

    if (!validacion.esValido) {
      return EstadoDivisor(error: validacion.error);
    }

    final estrategia = switch (modoRedondeo) {
      ModoRedondeo.exacto => redondeoExacto,
      ModoRedondeo.haciaArriba => redondeoHaciaArriba,
    };

    final resultado = calcularDivision.ejecutar(validacion.cuenta!, estrategia);

    return EstadoDivisor(
      resultado: formateadorMoneda.formatear(resultado.pagoPorPersona),
    );
  }
}
