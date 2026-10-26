# Análisis de portabilidad

Revisión final: corrige el conteo anterior de 33, que no coincidía con la tabla y agrupaba ideas independientes. Unidad: regla normativa independiente; repeticiones entre FR, escenarios, edge cases y supuestos se consolidan con referencias. Los seis escenarios se cuentan como criterios verificables completos. Se excluyen títulos, fechas y explicaciones de prioridad. Las entidades describen los mismos datos de FR-002/003 y no añaden requisitos. El conteo es reproducible por las filas siguientes.

## Spec

| Enunciado y origen | Tipo | ¿Viaja? | Justificación |
|---|---|---|---|
| FR-001: Una sola pantalla | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-002: Ingresar monto | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-002: Ingresar personas | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-002: Ingresar propina | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-003: Elegir modo exacto o hacia arriba | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-004: Calcular total con propina antes de dividir | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-005: Calcular al activar Calcular | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-005/006; SC-003: Mostrar pago con dos decimales | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-007: Redondear hacia arriba al entero superior | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-008: Personas menores que uno: mensaje Debe haber al menos una persona | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-008: Personas menores que uno: ocultar resultado | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-009: Monto no numérico: mensaje Monto inválido | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-009: Monto no numérico: ocultar resultado | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-010; SC-004: Funcionar sin conexión | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-010: No usar red | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-010: No usar base de datos | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-011: Monto negativo: mostrar error | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-011: Personas negativas: mostrar error | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-011: Propina negativa: mostrar error | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| FR-011: Valores negativos: ocultar resultado | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| US1/AC1: 100,4,10 exacto → 27.50 | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| US1/AC2: 90,3,0 exacto → 30.00 | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| US1/AC3: 10,3,0 exacto → 3.33 | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| US2/AC1: 10,3,0 arriba → 4.00 | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| US3/AC1: 50,0 → error de personas | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| US3/AC2: abc → Monto inválido | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| SC-001: Sin navegación adicional | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| SC-002: Cumplir los seis escenarios | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| SC-004; supuestos: Sin persistencia | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| Supuestos: Propina como porcentaje del monto | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| Supuestos: Exacto: dividir total con propina entre personas | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| Supuestos: Hacia arriba conserva valores enteros | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| Supuestos: Sin pagos diferenciados | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| Supuestos: Sin personas con monto fijo | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| Supuestos: Sin historial | QUÉ | Intacto | Comportamiento o criterio independiente del framework |
| Supuestos: Sin monedas múltiples | QUÉ | Intacto | Comportamiento o criterio independiente del framework |

Total: 36; QUÉ: 36 (100%); CÓMO: 0 (0%); MIXTO: 0 (0%). Reutilización textual: 100%; adaptación: 0%; no reusable: 0%. “Tocar” también es válido en web; no requiere cambiar la spec. El 30% es únicamente el umbral pedagógico del deber, no una regla universal.

## Constitución

Fuentes: [Flutter](https://github.com/BrisneyRod/divisor_cuenta_web/blob/master/evidencias/constitution_flutter.md) y [React](.specify/memory/constitution.md). Clasificación de reglas, no identidad literal de toda la traducción.

| Regla | Clasificación | Sección Flutter → React | Justificación |
|---|---|---|---|
| SRP clases → funciones/módulos | adaptada en redacción | I → I | Misma responsabilidad; vocabulario JavaScript |
| Cálculo no valida | idéntica | I → I | Responsabilidades separadas |
| Cálculo no formatea | idéntica | I → I | Formato en presentación |
| OCP nuevos redondeos sin editar cálculo | adaptada en redacción | I → I | Clases pasan a módulos |
| LSP sin comprobar tipos concretos | idéntica | I → I | Contrato aplicar |
| ISP interfaces pequeñas | idéntica | I → I | Una operación |
| Nadie depende de métodos que no usa | adaptada en redacción | I → I | Explicitar también en React |
| DIP presentación depende del dominio | adaptada en redacción | I → I | Rutas src |
| Capas lib → src | adaptada en redacción | II → II | La separación se conserva |
| presentation → domain ← data | idéntica | II → II | No cambia dirección |
| Dominio sin Flutter → sin React/DOM | adaptada en redacción | II → II | Mismo aislamiento |
| Dart puro → JavaScript puro | reemplazada | II → II | Nuevo lenguaje |
| main.dart → src/main.jsx | adaptada en redacción | II → II | Mismo punto único de composición |
| No secretos, claves, credenciales, tokens o estado privado | idéntica | III → III | Seguridad |
| Secretos fuera de Git; documentar solo nombre | idéntica | III → III | Seguridad |
| Pruebas de conducta crítica | idéntica | IV → IV | Calidad |
| Criterios automatizados o excepción manual justificada | reemplazada | IV → IV | Parte 4 exige todos ejecutables |
| Explicar qué hace cada función | idéntica | V → V | Regla académica |
| Explicar por qué existe | idéntica | V → V | Regla académica |
| Explicar entradas | idéntica | V → V | Regla académica |
| Explicar salidas | idéntica | V → V | Regla académica |
| Explicar errores y estados inválidos | idéntica | V → V | Regla académica |
| Divisor de una pantalla Flutter → web | adaptada en redacción | Architecture Rules → Product Constraints | Mismo alcance |
| No ampliar comportamiento sin spec posterior | idéntica | Architecture Rules → Product Constraints | Control de alcance |
| Nombres de dominio en español | idéntica | Architecture Rules → Product Constraints | Convención |
| UI para hispanohablantes | idéntica | Architecture Rules → Product Constraints | Producto |
| Documentar paquetes Flutter/Dart → npm | adaptada en redacción | Architecture Rules → Product Constraints | Mismo control |
| flutter analyze → npm run lint/build | reemplazada | Quality Gates → Quality Gates | Herramientas distintas |
| flutter test → npm test | reemplazada | Quality Gates → Quality Gates | Runner distinto |
| Registrar fallos de entorno | idéntica | Quality Gates → Quality Gates | Trazabilidad |
| Verificación manual con entradas, esperado y observado | idéntica | Quality Gates → Quality Gates | Evidencia |
| Revisar dominio independiente | adaptada en redacción | Quality Gates → Quality Gates | React sustituye Flutter |
| Revisar composición única | adaptada en redacción | Quality Gates → Quality Gates | main.jsx sustituye main.dart |
| Revisar extensión de estrategias sin editar cálculo | idéntica | Quality Gates → Quality Gates | OCP |
| Constitución gobierna artefactos | idéntica | Governance → Governance | Precedencia |
| Enmiendas documentadas con razón | idéntica | Governance → Governance | Trazabilidad |
| Versionado MAJOR/MINOR/PATCH | idéntica | Governance → Governance | Misma política |
| Revisar cumplimiento al planificar e implementar | idéntica | Governance → Governance | Proceso |
| Corregir o documentar violaciones con tarea | idéntica | Governance → Governance | Proceso |

39 reglas: 24 idénticas, 11 adaptadas y 4 reemplazadas. Offline/no red/no base de datos en React explicitan FR-010 de la spec original. No hay requisitos de negocio nuevos.

Autoría: análisis preparado por el agente; el estudiante debe revisarlo personalmente porque la Parte 2 pide hacerlo a mano. No se declara como trabajo escrito manualmente por el estudiante.
