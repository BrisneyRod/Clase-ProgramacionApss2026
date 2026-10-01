import 'cuenta.dart';

class ResultadoValidacion {
  const ResultadoValidacion._({this.cuenta, this.error});

  const ResultadoValidacion.valido(Cuenta cuenta) : this._(cuenta: cuenta);

  const ResultadoValidacion.invalido(String error) : this._(error: error);

  final Cuenta? cuenta;
  final String? error;

  bool get esValido => cuenta != null;
}

class ValidarEntrada {
  const ValidarEntrada();

  ResultadoValidacion ejecutar({
    required String montoTexto,
    required String personasTexto,
    required String propinaTexto,
  }) {
    final monto = double.tryParse(montoTexto);
    if (monto == null) {
      return const ResultadoValidacion.invalido('Monto inválido');
    }

    final propina = double.tryParse(propinaTexto);
    if (propina == null) {
      return const ResultadoValidacion.invalido('Propina invalida');
    }

    if (monto < 0 || propina < 0) {
      return const ResultadoValidacion.invalido(
        'No se permiten valores negativos',
      );
    }

    final personas = int.tryParse(personasTexto);
    if (personas == null || personas < 1) {
      return const ResultadoValidacion.invalido(
        'Debe haber al menos una persona',
      );
    }

    return ResultadoValidacion.valido(
      Cuenta(
        montoTotal: monto,
        numeroPersonas: personas,
        porcentajePropina: propina,
      ),
    );
  }
}
