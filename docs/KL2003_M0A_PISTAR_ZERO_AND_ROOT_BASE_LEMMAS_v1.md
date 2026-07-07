# KL2003_M0A_PISTAR_ZERO_AND_ROOT_BASE_LEMMAS_v1

Fecha: 2026-07-07.

Estado: corolarios semanticos minimos de `piStarFinset` para entrada futura
M0c. No se toca la semantica computable ni se prueba ninguna desigualdad de
arbol.

## Clasificacion

```text
PISTAR_ZERO_BELOW_ROOT_PROVED
ROOT_COUNTS_ITSELF_PROVED
M0C_BASE_SEGMENT_INPUT_CAN_BE_DISCHARGED
M0A_SEMANTIC_COROLLARIES_READY
NO_D1_D2_D3
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_D1_D2_D3
NO_TREE_INEQUALITY_PROOF
NO_RETARDED_INDUCTION_PROOF
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Archivos modificados

```text
CollatzClassical/KL2003/KL2003M0APiStarSemantics.lean
CollatzClassical/KL2003/KL2003M0APiStarSemanticsAxiomAudit.lean
```

## Lemas agregados

Auxiliares semanticos:

```lean
boundedReachesWithFuel_true_implies_root_le_window
boundedReaches_true_implies_root_le_window
boundedReaches_self
```

Corolarios pedidos:

```lean
piStarFinset_eq_empty_of_x_lt_a
piStar_eq_zero_of_x_lt_a
a_mem_piStarFinset_self_window
one_le_piStar_of_one_le_a_le_x
```

Interpretacion:

```text
Si x < a, ningun hit a puede aceptarse dentro de la ventana <= x, porque
boundedReaches acepta n = a solo despues de comprobar n <= x.

Si 1 <= a y a <= x, entonces la raiz a pertenece a piStarFinset a x por hit
inmediato, y por tanto 1 <= piStar a x.
```

## Build

Comando:

```text
lake build CollatzClassical.KL2003.KL2003M0APiStarSemantics
```

Resultado:

```text
Build completed successfully.
```

## Axiom audit

Comando:

```text
lake env lean CollatzClassical/KL2003/KL2003M0APiStarSemanticsAxiomAudit.lean
```

Salida relevante para lemas nuevos:

```text
'CollatzClassical.KL2003.boundedReachesWithFuel_true_implies_root_le_window' depends on axioms: [propext]
'CollatzClassical.KL2003.boundedReaches_true_implies_root_le_window' depends on axioms: [propext]
'CollatzClassical.KL2003.piStarFinset_eq_empty_of_x_lt_a' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.piStar_eq_zero_of_x_lt_a' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.boundedReaches_self' depends on axioms: [propext]
'CollatzClassical.KL2003.a_mem_piStarFinset_self_window' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.one_le_piStar_of_one_le_a_le_x' depends on axioms: [propext, Classical.choice, Quot.sound]
```

No aparece `Lean.trustCompiler`, `Lean.ofReduceBool`, ni uso de
`native_decide`.

## Hashes

```text
9032774e3b69fdfdeb5b4159c0375ca8018a5c976c61d10303351fee31151d3f  CollatzClassical/KL2003/KL2003M0APiStarSemantics.lean
d74cc21fd653a21ae4f9f29e9de548e1bb99d905e69944eab21e125e8620f0c7  CollatzClassical/KL2003/KL2003M0APiStarSemanticsAxiomAudit.lean
```

## Limites

No se hizo:

```text
D1/D2/D3
tree inequality proof
retarded induction proof
M0 proof
M1 theorem
global Collatz claim
```

## Resultado

```text
PISTAR_ZERO_BELOW_ROOT_PROVED = yes
ROOT_COUNTS_ITSELF_PROVED = yes
M0C_BASE_SEGMENT_INPUT_CAN_BE_DISCHARGED = yes
M0A_SEMANTIC_COROLLARIES_READY = yes
NO_D1_D2_D3 = yes
NO_M0_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
