import 'package:flutter_test/flutter_test.dart';
import 'package:participacion_semana7/data/redondeo_exacto.dart';
import 'package:participacion_semana7/domain/calcular_division.dart';
import 'package:participacion_semana7/domain/cuenta.dart';

void main() {
  const calcularDivision = CalcularDivision();
  const redondeoExacto = RedondeoExacto();

  test('calcula 100.00 entre 4 con 10% de propina en modo exacto', () {
    final resultado = calcularDivision.ejecutar(
      const Cuenta(montoTotal: 100, numeroPersonas: 4, porcentajePropina: 10),
      redondeoExacto,
    );

    expect(resultado.pagoPorPersona, 27.5);
  });

  test('calcula 90.00 entre 3 con 0% de propina en modo exacto', () {
    final resultado = calcularDivision.ejecutar(
      const Cuenta(montoTotal: 90, numeroPersonas: 3, porcentajePropina: 0),
      redondeoExacto,
    );

    expect(resultado.pagoPorPersona, 30);
  });

  test('calcula 10.00 entre 3 con 0% de propina en modo exacto', () {
    final resultado = calcularDivision.ejecutar(
      const Cuenta(montoTotal: 10, numeroPersonas: 3, porcentajePropina: 0),
      redondeoExacto,
    );

    expect(resultado.pagoPorPersona.toStringAsFixed(2), '3.33');
  });
}
