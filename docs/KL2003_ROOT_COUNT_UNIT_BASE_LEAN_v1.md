# KL2003_ROOT_COUNT_UNIT_BASE_LEAN_v1

Fecha: 2026-07-10.

Estado: puente Lean minimo root-count para avanzar hacia
`BaseSegmentUnitLowerBound`. No se define `Phi`, no se abre la politica
Real->Nat/window y no se toca M0C.

## Clasificacion

```text
ROOT_COUNT_UNIT_LEMMA_PROVED
BASE_SEGMENT_UNIT_SEMANTIC_DEBT_ADVANCES
REAL_TO_NAT_WINDOW_POLICY_STILL_OPEN
PHI_INSTANTIATION_STILL_OPEN
NO_RETARDED_INDUCTION
NO_SCALING_LEDGER
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Archivos

Creado:

```text
CollatzClassical/KL2003/KL2003RootCountUnitBase.lean
CollatzClassical/KL2003/KL2003RootCountUnitBaseAxiomAudit.lean
docs/KL2003_ROOT_COUNT_UNIT_BASE_LEAN_v1.md
```

## Lemas

El modulo importa solo:

```lean
CollatzClassical.KL2003.KL2003M0APiStarSemantics
```

y reempaqueta los lemas M0A existentes con nombres de puente:

```lean
root_mem_piStarFinset_of_root_in_window :
  1 <= a -> a <= x -> a ∈ piStarFinset a x

root_count_unit_lower_bound_for_window :
  1 <= a -> a <= x -> 1 <= piStar a x
```

La prueba usa:

```lean
a_mem_piStarFinset_self_window
one_le_piStar_of_one_le_a_le_x
```

## Deuda Restante

Sigue abierto:

```text
REAL_TO_NAT_WINDOW_POLICY_STILL_OPEN
PHI_INSTANTIATION_STILL_OPEN
```

El siguiente puente debe aportar una politica de ventana `x_y(a)` y demostrar:

```text
0 <= y -> y <= 14 -> 1 <= a -> a <= x_y(a)
```

Luego, una realizacion semantica de `Phi` podra convertir el root-count
puntual en:

```lean
BaseSegmentUnitLowerBound Phi
```

## No Objetivos

No se prueba:

```text
retarded induction
scaling seam ledger
D1/D2/D3
M1 theorem
global Collatz claim
```

No se usa:

```text
sorry
admit
axiom
unsafe
native_decide
```

## Resultado

```text
ROOT_COUNT_UNIT_LEMMA_PROVED = yes
BASE_SEGMENT_UNIT_SEMANTIC_DEBT_ADVANCES = yes
REAL_TO_NAT_WINDOW_POLICY_STILL_OPEN = yes
PHI_INSTANTIATION_STILL_OPEN = yes
NO_RETARDED_INDUCTION = yes
NO_SCALING_LEDGER = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
