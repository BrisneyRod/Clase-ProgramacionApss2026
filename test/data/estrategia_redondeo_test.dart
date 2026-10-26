import 'package:flutter_test/flutter_test.dart';
import 'package:participacion_semana7/data/redondeo_exacto.dart';
import 'package:participacion_semana7/data/redondeo_hacia_arriba.dart';

void main() {
  test('redondeo exacto conserva el valor', () {
    const redondeo = RedondeoExacto();

    expect(redondeo.aplicar(3.33), 3.33);
  });

  test('redondeo hacia arriba sube decimales al entero superior', () {
    const redondeo = RedondeoHaciaArriba();

    expect(redondeo.aplicar(3.33), 4);
  });

  test('redondeo hacia arriba conserva valores enteros', () {
    const redondeo = RedondeoHaciaArriba();

    expect(redondeo.aplicar(4), 4);
  });
}
