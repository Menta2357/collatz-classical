# F3 semantic bridge — informe v1

Estado: `RULE_TO_PISTAR_BRIDGE_FINITE_INVENTORY_PASS`.

## Qué queda conectado

`F3ReturnExcursionSemanticBridge.lean` conecta los tres tipos de regla con las
inyecciones reales de `piStarFinset`:

```text
retarded       : piStar(4a, xRet) → piStar(a, x)
advancedDirect : piStar(c, xAdv) → piStar(a, x), T(c)=a
parityLift     : piStar(2c, xLift) → piStar(a, x), T(c)=a
```

El canal parity-lift se prueba componiendo `T(2c)=c` con la ruta advanced. La
estructura `RealizedFrozenRow` obliga a asociar una arista congelada a una
regla aritmética y a conservar el canal declarado.

## Cobertura de filas

El inventario generado desde `split_edges.csv` aporta testigos `a,c` y
reverifica en Lean, para las 1215 filas no-estériles, los IDs de estado, la
ecuación `3c+1=2a`, el residuo fino y la pertenencia exacta a `splitEdges`:

```text
retarded = 729
advanced_direct = 243
parity_lift = 243
semantic_edges_valid = true
semantic_edges_are_frozen = true
```

Las 243 filas estériles permanecen fuera del core y siguen siendo `Q`, no se
convierten en aristas semánticas. La prueba de transporte a `piStar` se aplica
al inventario con la orientación de inyección child → root; el operador matriz
conserva su orientación padre → child y la conversión entre ambas queda
señalada en la página, no escondida en un nombre.

## Claims

Esto es un puente semántico comprobado para todas las filas congeladas no
estériles. No declara certificado de `rho`, teorema de densidad ni resultado
global de Collatz.
