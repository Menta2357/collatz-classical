# KL2003_M0B_TWO_BRANCH_CORE_INJECTION_LEAN_v1

Fecha: 2026-07-08.

Estado: nucleo combinatorio de dos ramas creado y compilado. Cubre la forma
comun D1/D3 sin clases de residuo, escalado, redondeos, LP ni teorema M0.

## Clasificacion

```text
TWO_BRANCH_CORE_COMBINATORIAL_BOUND_PROVED
D1_D3_SHARE_COMMON_CORE
ADVANCED_CHILD_T_MAPS_TO_ROOT_PROVED
RETARDED_ROUTE_DERIVED
ROOT_EXCLUSION_LEMMAS_PROVED
ENTRY_FIBER_DISJOINTNESS_CONSUMED
TWO_BRANCH_CARD_BOUND_PROVED
NO_SCALING
NO_ROUNDING_LEDGER
NO_D1_D2_D3_FINAL
NO_M0_THEOREM
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

No se reclaman bloqueos:

```text
BLOCKED_ON_ROOT_EXCLUSION
BLOCKED_ON_ENTRY_PREDECESSOR_APPLICATION
BLOCKED_ON_FINSET_CARDINALITY
BLOCKED_ON_ADVANCED_CHILD_ARITHMETIC
```

## Archivos

```text
CollatzClassical/KL2003/KL2003M0BTwoBranchCore.lean
CollatzClassical/KL2003/KL2003M0BTwoBranchCoreAxiomAudit.lean
```

## Hipotesis Del Nucleo

El teorema cardinal principal usa:

```lean
1 <= a
NotInCycle a
3*c + 1 = 2*a
a <= x
xRet <= x
xAdv <= x
```

No usa:

```text
a % 9 = 8
alpha
lambda
rpow
y real
ledger de redondeos
filas LP
resta Nat tipo 2*a - 1
```

## Micro-Lemas

Aritmetica advanced:

```lean
two_branch_advanced_child_maps_to_root :
  3*c + 1 = 2*a -> T c = a

two_branch_children_distinct :
  1 <= a -> 3*c + 1 = 2*a -> 2*a != c
```

Ruta retardada:

```lean
two_branch_T_four_mul :
  T (4*a) = 2*a

two_branch_T_two_mul :
  T (2*a) = a

two_branch_T_two_steps_four_mul :
  T^[2] (4*a) = a
```

No se introduce `PathWithin` como hipotesis externa. Las rutas se derivan en:

```lean
two_branch_retarded_path_to_child
two_branch_child_path_to_root
two_branch_advanced_path_to_root
```

## Exclusion De Raiz

Se probaron los lemas anticipados para cerrar el caso `k0 = 0` del primer hit:

```lean
root_not_mem_retarded_source :
  1 <= a ->
  NotInCycle a ->
  a notin piStarFinset (4*a) xRet

root_not_mem_advanced_source :
  NotInCycle a ->
  3*c + 1 = 2*a ->
  a notin piStarFinset c xAdv
```

Tambien queda disponible el lema interno:

```lean
not_reaches_inverse_child_from_root
```

## Inyecciones

Rama retardada:

```lean
two_branch_retarded_reaches_child
two_branch_retarded_injection
```

La fuente:

```text
piStarFinset (4*a) xRet
```

entra en el target:

```text
piStarFinset a x
```

por la fibra de predecesor `2*a`.

Rama advanced:

```lean
two_branch_advanced_reaches_child
two_branch_advanced_injection
```

La fuente:

```text
piStarFinset c xAdv
```

entra por la fibra de predecesor `c`.

## Disyuncion Y Cardinalidad

La disyuncion consume el modulo de predecesor de entrada:

```lean
inverse_children_disjoint_descendants
```

Lemas probados:

```lean
two_branch_source_members_disjoint
two_branch_sources_disjoint_in_target
```

La cota cardinal usa la ruta estandar:

```text
A union B subset target
Disjoint A B
card A + card B = card (A union B) <= card target
```

Teorema final:

```lean
two_branch_card_bound :
  1 <= a ->
  NotInCycle a ->
  3*c + 1 = 2*a ->
  a <= x ->
  xRet <= x ->
  xAdv <= x ->
  card (piStarFinset (4*a) xRet)
    + card (piStarFinset c xAdv)
    <= card (piStarFinset a x)
```

## Build

Comando:

```text
lake build CollatzClassical.KL2003.KL2003M0BTwoBranchCore
```

Resultado:

```text
Build completed successfully.
```

## Axiom audit

Comando:

```text
lake env lean CollatzClassical/KL2003/KL2003M0BTwoBranchCoreAxiomAudit.lean
```

Salida relevante:

```text
'CollatzClassical.KL2003.two_branch_advanced_child_maps_to_root' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.two_branch_children_distinct' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.two_branch_T_two_mul' depends on axioms: [propext]
'CollatzClassical.KL2003.two_branch_T_four_mul' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.root_not_mem_retarded_source' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.root_not_mem_advanced_source' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.two_branch_sources_disjoint_in_target' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.two_branch_card_bound' depends on axioms: [propext, Classical.choice, Quot.sound]
```

No aparece `sorry`, `admit`, `axiom`, `unsafe`, `native_decide`,
`Lean.trustCompiler` ni `Lean.ofReduceBool` en el modulo. Las palabras
`Real`, `rpow`, `alpha`, `ledger`, `D1` y `D3` aparecen solo en la cabecera
documental para declarar que no son usados por este nucleo.

## Hashes

```text
d82171b6dabc5510b19f3aa9c6a6f14a41920c3809ff491c62a53316e1f42e48  CollatzClassical/KL2003/KL2003M0BTwoBranchCore.lean
b7b0cc8482b812d252136f2dd0e356e42fdad38453fc54c3df7928a67e1f066a  CollatzClassical/KL2003/KL2003M0BTwoBranchCoreAxiomAudit.lean
```

## Resultado

```text
TWO_BRANCH_CORE_COMBINATORIAL_BOUND_PROVED = yes
D1_D3_SHARE_COMMON_CORE = yes
ADVANCED_CHILD_T_MAPS_TO_ROOT_PROVED = yes
RETARDED_ROUTE_DERIVED = yes
ROOT_EXCLUSION_LEMMAS_PROVED = yes
ENTRY_FIBER_DISJOINTNESS_CONSUMED = yes
TWO_BRANCH_CARD_BOUND_PROVED = yes
NO_SCALING = yes
NO_ROUNDING_LEDGER = yes
NO_D1_D2_D3_FINAL = yes
NO_M0_THEOREM = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
