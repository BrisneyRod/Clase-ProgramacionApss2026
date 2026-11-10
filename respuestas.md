# Misión 6 — Plugin Detective

## 1. Skill frente a plugin

`incident-investigator` es un skill porque contiene instrucciones reutilizables
(`SKILL.md`) y una referencia de reglas que orientan al agente sobre cuándo
activarse, cómo investigar y cómo reportar evidencia. No agrega por sí mismo
una conexión externa ni automatiza eventos.

Para distribuirlo como plugin, según la plataforma, podrían empaquetarse un
comando para invocación explícita, un manifiesto y metadatos, hooks para validar
archivos o aplicar redacción, y un servidor MCP si se necesitara una capacidad
externa. Un plugin puede reunir esos componentes junto con el skill; en esta
entrega no se construye ni instala un plugin.

## 2. Ralph Loop

El análisis podría repetirse como máximo tres veces:

1. Ejecutar la investigación sobre el mismo CSV.
2. Comprobar invariantes verificables: columnas, filas originales, umbrales,
   redacción de `token=`, ausencia de red y reconocimiento de incertidumbre.
3. Corregir únicamente el skill o el informe si una comprobación falla.

El criterio de parada es: detenerse antes si todas las comprobaciones pasan; si
alguna sigue fallando después de la tercera iteración, detenerse y reportar el
fallo. No se modifica el CSV para hacer pasar una comprobación ni se fabrica
evidencia nueva.
