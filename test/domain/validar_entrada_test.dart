import 'package:flutter_test/flutter_test.dart';
import 'package:participacion_semana7/domain/validar_entrada.dart';

void main() {
  const validarEntrada = ValidarEntrada();

  test('rechaza cero personas', () {
    final resultado = validarEntrada.ejecutar(
      montoTexto: '50.00',
      personasTexto: '0',
      propinaTexto: '0',
    );

    expect(resultado.esValido, isFalse);
    expect(resultado.error, 'Debe haber al menos una persona');
  });

  test('rechaza monto no numerico', () {
    final resultado = validarEntrada.ejecutar(
      montoTexto: 'abc',
      personasTexto: '3',
      propinaTexto: '0',
    );

    expect(resultado.esValido, isFalse);
    expect(resultado.error, 'Monto inválido');
  });

  test('rechaza valores negativos', () {
    final resultado = validarEntrada.ejecutar(
      montoTexto: '10',
      personasTexto: '3',
      propinaTexto: '-1',
    );

    expect(resultado.esValido, isFalse);
    expect(resultado.error, 'No se permiten valores negativos');
  });
}
