# UI Contract: Dividir cuenta

## Pantalla unica

La pantalla debe exponer al usuario estos controles:

- Campo de texto para `Monto total`.
- Campo de texto para `Numero de personas`.
- Campo de texto para `Propina`.
- Selector de modo de redondeo con dos opciones:
  - `Exacto`
  - `Hacia arriba`
- Boton `Calcular`.

## Resultado exitoso

Al tocar `Calcular` con entrada valida, la pantalla debe mostrar:

```text
Paga cada persona: <valor con dos decimales>
```

## Errores

Al tocar `Calcular` con entrada invalida, la pantalla debe mostrar un mensaje de
error y no debe mostrar un resultado anterior como si fuera vigente.

Mensajes obligatorios:

- `Monto inválido`
- `Debe haber al menos una persona`

Para valores negativos, la pantalla debe mostrar un mensaje de error claro y no
mostrar resultado.

## Escenarios contractuales

| Entrada | Modo | Resultado esperado |
| --- | --- | --- |
| 100.00, 4 personas, 10% | Exacto | 27.50 |
| 90.00, 3 personas, 0% | Exacto | 30.00 |
| 50.00, 0 personas | Cualquier modo | Debe haber al menos una persona |
| abc, cualquier personas | Cualquier modo | Monto inválido |
| 10.00, 3 personas, 0% | Exacto | 3.33 |
| 10.00, 3 personas, 0% | Hacia arriba | 4.00 |
