# ADVERSARIAL_AUDIT_CHECKLIST_v1

Destilado operativo de un programa de ~2 años de formalización Collatz con
revisión adversarial continua. Cada ítem existe porque el fallo que detecta
ocurrió de verdad al menos una vez (en nuestro trabajo o en repos auditados).

Aplicar en orden. El veredicto de cada sección usa:
`SOUND / CONDITIONAL / GAP / OVERCLAIM`.

## 1. Cierre mecánico (necesario, jamás suficiente)

- [ ] `lake build` reproducido por el auditor, no citado del autor.
- [ ] Axiom audit reproducido: lista exacta de axiomas por teorema central.
      Esperado: `[propext, Classical.choice, Quot.sound]`. Cualquier otro
      axioma o `sorry` en el árbol = GAP inmediato.
- [ ] Sin `native_decide` / `ofReduceBool` salvo justificación explícita
      (mueven la confianza del kernel al compilador).

## 2. Carga de hipótesis (el ítem que más overclaims caza)

Para cada teorema central, tabular: hipótesis / quién la descarga / cómo.

- [ ] ¿La hipótesis contiene la parte difícil del problema? Un teorema
      `HipótesisDura → ConclusiónDébil` es plomería condicional, no avance.
      Test: enunciar en una frase qué costaría probar la hipótesis sola.
- [ ] ¿Las instancias que descargan hipótesis provienen de enumeración
      finita? Entonces el resultado es finito, diga lo que diga el nombre.

## 3. Verificador vs. generador

- [ ] Todo `∀ k` / `∀ n` central: ¿el cuerpo se deriva estructuralmente o
      se instancia caso a caso con datos precomputados? Lo segundo es un
      verificador con cuantificador sintáctico. No es falso; es finito.
- [ ] ¿Existe al menos UNA instancia probada por método no enumerativo?
      Si no, el "productor" es un catálogo.

## 4. Selección a posteriori / sesgo de supervivencia

- [ ] ¿Alguna constante del enunciado (cotas, denominadores, umbrales) se
      eligió DESPUÉS de computar los datos que debe acotar? Ajuste-a-muestra:
      el teorema certifica una tautología sobre los datos vistos.
- [ ] ¿Los objetos "buenos" se seleccionan por cumplir la propiedad que
      luego se demuestra típica? Circularidad por selección (variante del
      patrón κ≠0 del repo hyperlocal).

## 5. Anclaje semántico

- [ ] ¿Las cotas se prueban sobre el objeto primario (traza/órbita real) o
      sobre contadores almacenados? Contador ≠ dinámica: exigir lema de
      consistencia traza↔contador o marcar GAP semántico.
- [ ] ¿El enunciado formal coincide con el enunciado del paper? Buscar
      debilitamientos silenciosos: densidad logarítmica vendida como
      natural, "casi acotado" vendido como acotado, stopping time vendido
      como convergencia a 1.

## 6. Márgenes y estadística (para resultados con componente computacional)

- [ ] Reportar cotas con margen ABSOLUTO en eventos, no solo PASS/FAIL.
      Margen < √(conteo) = indistinguible de ruido de Poisson; el PASS es
      una moneda que cayó de cara.
- [ ] Series sobre parámetros (k, ventanas): reportar pendiente, no solo
      el peor caso. Un máximo muestral al 94% del techo no es holgura.

## 7. Calibración de etiquetas

- [ ] Nombres de módulos/teoremas: ¿prometen más que su contenido?
      ("Renormalization", "Producer", "Global" sobre objetos finitos).
- [ ] La columna ABIERTO del proyecto: ¿se ha movido en las últimas N
      entregas, o solo crece CERRADO con piezas condicionales? Columna
      ABIERTO inmóvil + CERRADO creciente = andamiaje, no avance.

## 8. Veredicto final

```
SECCIONES:        1[..] 2[..] 3[..] 4[..] 5[..] 6[..] 7[..]
RESULTADO NETO:   qué queda demostrado incondicionalmente, en una frase
RESIDUO HONESTO:  el enunciado más fuerte que el trabajo soporta tal cual
OVERCLAIM GAP:    distancia entre lo que el título dice y el residuo
```

Regla de tono: específico, reproducible, sin adjetivos. Acreditar
explícitamente lo que está bien hecho — un audit que solo encuentra fallos
sin reconocer los cierres válidos pierde autoridad.
