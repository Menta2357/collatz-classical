# KL2003_M0B_REACHABILITY_PROP_API_LEAN_SKELETON_v1

Fecha: 2026-07-07.

Estado: esqueleto Lean minimo de API `Prop` para reachability M0B. No se
prueban D1/D2/D3.

## Clasificacion

```text
M0B_REACHABILITY_PROP_API_LEAN_SKELETON_CREATED
REACHES_WITHIN_DEFINED
INVERSE_CHILD_DEFINED
NOT_IN_CYCLE_DEFINED
PATH_WITHIN_DEFINED
PISTAR_PROP_FINSET_DEFINED
BASIC_REACHABILITY_LEMMAS_PROVED
BOUNDED_REACHES_SOUND_PROVED
NO_D1_D2_D3_PROOF
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_D1_D2_D3_PROOF
NO_TREE_INEQUALITY_PROOF
NO_RETARDED_INDUCTION_PROOF
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
NO_NATIVE_DECIDE
```

## Archivos creados

```text
CollatzClassical/KL2003/KL2003M0BReachabilityAPI.lean
CollatzClassical/KL2003/KL2003M0BReachabilityAPIAxiomAudit.lean
```

## Definiciones

El modulo define:

```lean
def ReachesWithin (a x n : Nat) : Prop
def InverseChild (a c : Nat) : Prop
def NotInCycle (a : Nat) : Prop
def PathWithin (src dst x len : Nat) : Prop
noncomputable def piStarPropFinset (a x : Nat) : Finset Nat
```

Nota de Mathlib: el scoping escribia conceptualmente `Function.iterate T j n`.
En Lean/mathlib v4.21.0 el identificador `Function.iterate` no existe como
definicion aplicable; la API usa la notacion estandar:

```lean
T^[j] n
```

y los lemas en namespace `Function`, por ejemplo:

```lean
Function.iterate_add_apply
Function.iterate_succ_apply
```

## Lemas probados

```lean
reachesWithin_self
reachesWithin_window_mono
reachesWithin_append_path
mem_piStarPropFinset_iff
boundedReachesWithFuel_sound
boundedReaches_sound
```

`boundedReaches_sound` queda cerrado:

```lean
boundedReaches a x n = true -> ReachesWithin a x n
```

El puente inverso/completitud no se implementa en esta tarea:

```lean
ReachesWithin a x n -> boundedReaches a x n = true
```

porque contiene el argumento finito asociado al fuel `x+1`.

## Build

Comando:

```text
lake build CollatzClassical.KL2003.KL2003M0BReachabilityAPI
```

Resultado:

```text
Build completed successfully.
```

## Axiom audit

Comando:

```text
lake env lean CollatzClassical/KL2003/KL2003M0BReachabilityAPIAxiomAudit.lean
```

Salida:

```text
'CollatzClassical.KL2003.reachesWithin_self' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.reachesWithin_window_mono' does not depend on any axioms
'CollatzClassical.KL2003.reachesWithin_append_path' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.mem_piStarPropFinset_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.boundedReachesWithFuel_sound' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.boundedReaches_sound' depends on axioms: [propext, Quot.sound]
```

No aparece `Lean.trustCompiler`, `Lean.ofReduceBool`, ni uso de
`native_decide`.

## No implementado aun

```text
boundedReaches_complete_of_pos
piStarPropFinset_eq_piStarFinset
inverse_children_disjoint_descendants
D1/D2/D3 injection/disjointness/boundary proofs
M0 proof
M1 theorem
global Collatz claim
```

## Hashes

```text
da6ce61cba4dfb05f7932b26ead84d61f5b208562c2b7bc8f0071f636c425fbf  CollatzClassical/KL2003/KL2003M0BReachabilityAPI.lean
0ceb82796e94d2939e36bdb9b27a9117a7d7bc55f1cabcf201896a3247cd57e5  CollatzClassical/KL2003/KL2003M0BReachabilityAPIAxiomAudit.lean
```

## Resultado

```text
M0B_REACHABILITY_PROP_API_LEAN_SKELETON_CREATED = yes
REACHES_WITHIN_DEFINED = yes
INVERSE_CHILD_DEFINED = yes
NOT_IN_CYCLE_DEFINED = yes
PATH_WITHIN_DEFINED = yes
PISTAR_PROP_FINSET_DEFINED = yes
BASIC_REACHABILITY_LEMMAS_PROVED = yes
BOUNDED_REACHES_SOUND_PROVED = yes
NO_D1_D2_D3_PROOF = yes
NO_M0_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
