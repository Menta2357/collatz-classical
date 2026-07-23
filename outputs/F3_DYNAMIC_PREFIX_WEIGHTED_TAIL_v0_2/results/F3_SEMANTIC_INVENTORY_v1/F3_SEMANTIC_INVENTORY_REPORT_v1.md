# F3 semantic inventory — informe v1

Estado: `FINITE_RULE_TO_STATE_TO_PISTAR_INVENTORY_PASS`.

## Resultado

La generación Python y la re-verificación Lean cubren las 1215 filas de la
matriz split-edge no-estéril:

```text
729 retarded
243 advanced_direct_c2
243 advanced_parity_lift_c1
0 sterile edges in the core matrix
```

Lean comprueba con `native_decide`:

```text
semantic_edge_count = 1215
semantic_edges_valid = true
semantic_edges_are_frozen = true
```

El generador también verifica que las claves `(source_id, target_id,
channel)` son únicas y que el conjunto de claves del inventario coincide
exactamente con el conjunto de `split_edges.csv`:
`python_bidirectional_edge_coverage = PASS`. Esta es una verificación de
generador y no se presenta como un teorema Lean de igualdad de conjuntos.

La validez incluye el ID de estado, el representante `a`, el objetivo `c` o
`2c`, la ecuación `3c+1=2a` y el residuo del canal. El teorema
`semantic_rule_piStar` usa las inyecciones de `piStarFinset` ya demostradas y
la nueva composición parity-lift.

## Coste y stops

```text
native_decide compile = 103.53 s
single-command limit = 300 s
```

El intento monolítico con `decide` agotó heartbeats a 61.93 s; el segundo
intento se detuvo a 276.60 s al acercarse al límite de 300 s. La solución fue
usar `native_decide`, sin cambiar las filas ni relajar las propiedades. Estos
son stops de escalabilidad del checker, no fallos de la aritmética ni de
`piStar`.

## Límite

El inventario conecta reglas y filas con inyecciones de `piStar`, pero todavía
no prueba la conversión renewal global ni el teorema F3. Permanecen
`NO_RHO_CERTIFICATE`, `NO_DENSITY_THEOREM` y `NO_GLOBAL_COLLATZ_CLAIM`.
