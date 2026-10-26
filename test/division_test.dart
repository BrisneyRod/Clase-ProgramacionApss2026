import 'package:flutter_test/flutter_test.dart';
import 'package:participacion_semana7/data/redondeo_exacto.dart';
import 'package:participacion_semana7/data/redondeo_hacia_arriba.dart';
import 'package:participacion_semana7/domain/calcular_division.dart';
import 'package:participacion_semana7/domain/estrategia_redondeo.dart';
import 'package:participacion_semana7/domain/validar_entrada.dart';

import 'casos_de_prueba.dart';

void main() {
  const validarEntrada = ValidarEntrada();
  const calcularDivision = CalcularDivision();
  const redondeoExacto = RedondeoExacto();
  const redondeoHaciaArriba = RedondeoHaciaArriba();

  for (final caso in casos) {
    test(caso.nombre, () {
      final validacion = validarEntrada.ejecutar(
        montoTexto: _textoMonto(caso.monto),
        personasTexto: caso.personas.toString(),
        propinaTexto: caso.propina.toString(),
      );

      if (caso.errorEsperado != null) {
        expect(validacion.esValido, isFalse);
        expect(validacion.error, caso.errorEsperado);
        return;
      }

      expect(validacion.esValido, isTrue);

      final resultado = calcularDivision.ejecutar(
        validacion.cuenta!,
        _estrategiaPara(caso.modo),
      );

      expect(resultado.pagoPorPersona, closeTo(caso.esperado!, 0.001));
    });
  }

  test('LSP: CalcularDivision acepta cualquier EstrategiaRedondeo', () {
    final validacion = validarEntrada.ejecutar(
      montoTexto: '10.00',
      personasTexto: '3',
      propinaTexto: '0',
    );

    final estrategias = <EstrategiaRedondeo>[
      redondeoExacto,
      redondeoHaciaArriba,
    ];

    final resultados = [
      for (final estrategia in estrategias)
        calcularDivision.ejecutar(validacion.cuenta!, estrategia),
    ];

    expect(resultados[0].pagoPorPersona, closeTo(3.33, 0.001));
    expect(resultados[1].pagoPorPersona, closeTo(4.00, 0.001));
  });
}

String _textoMonto(double monto) {
  if (monto.isNaN) {
    return 'abc';
  }

  return monto.toStringAsFixed(2);
}

EstrategiaRedondeo _estrategiaPara(String modo) {
  return switch (modo) {
    'exacto' => const RedondeoExacto(),
    'arriba' => const RedondeoHaciaArriba(),
    _ => throw ArgumentError('Modo no soportado: $modo'),
  };
}
