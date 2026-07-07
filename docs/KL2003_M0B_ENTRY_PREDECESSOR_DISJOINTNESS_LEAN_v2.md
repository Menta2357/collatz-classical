# KL2003_M0B_ENTRY_PREDECESSOR_DISJOINTNESS_LEAN_v2

Fecha: 2026-07-08.

Estado: capa Lean de primer hit / predecesor de entrada refinada para la
particion correcta de D1/D2/D3. La bisagra ya no es "alcanza un hijo inverso"
como criterio primario, sino "el primer hit de la raiz `a` entra por este
predecesor inmediato".

## Clasificacion

```text
ENTRY_PREDECESSOR_LAYER_COMPILED
FIRST_HIT_INTERFACE_PROVED
NOTINCYCLE_HYPOTHESIS_DOCUMENTED
ENTRY_PREDECESSOR_MAPS_TO_ROOT_PROVED
ENTRY_PRED_EQ_OF_REACHES_CHILD_PROVED
INVERSE_CHILD_DISJOINTNESS_PROVED
INVERSE_CHILD_DISJOINTNESS_STATEMENT_REFINED
NO_D1_D2_D3
NO_M0_THEOREM
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Bloqueos no reclamados:

```text
BLOCKED_ON_FIRST_HIT_API
BLOCKED_ON_ENTRY_PREDECESSOR_FORMULATION
BLOCKED_ON_NOTINCYCLE_ARITHMETIC
```

## Archivos

```text
CollatzClassical/KL2003/KL2003M0BEntryPredecessorDisjointness.lean
CollatzClassical/KL2003/KL2003M0BEntryPredecessorDisjointnessAxiomAudit.lean
```

## Definiciones

`FirstHitsAt` queda como definicion Prop, no como estructura:

```lean
def FirstHitsAt (a n k : Nat) : Prop :=
  T^[k] n = a ∧ forall j, j < k -> T^[j] n != a
```

`NotInCycle` no se redefine en el modulo para evitar duplicar nombres: se
consume la definicion ya existente en `KL2003M0BReachabilityAPI.lean`, que
coincide con la semantica requerida:

```lean
def NotInCycle (a : Nat) : Prop :=
  forall q, 0 < q -> T^[q] a != a
```

El modulo incluye cabecera explicando por que `NotInCycle a` es esencial. Sin
esa hipotesis, la disyuncion ingenua falla: conceptualmente, en el ciclo
positivo `1 <-> 2`, una orbita puede pasar por la raiz y mas tarde tocar otra
rama inversa.

## Lemas probados

Primer hit:

```lean
firstHitsAt_of_natFind
exists_firstHitsAt_of_reachesWithin
```

`exists_firstHitsAt_of_reachesWithin` usa el invariante ya cerrado:

```lean
reachesWithin_has_bounded_min_hit
```

y obtiene:

```lean
exists k, k <= x ∧ FirstHitsAt a n k ∧
  forall j, j <= k -> T^[j] n <= x
```

Aritmetica local de `T`:

```lean
T_ne_self :
  1 <= n -> T n != n

inverseChild_ne_root_of_one_le :
  InverseChild a c -> 1 <= c -> c != a
```

Predecesor de entrada:

```lean
entry_predecessor_maps_to_root :
  FirstHitsAt a n k ->
  n != a ->
  0 < k ->
  T (T^[k - 1] n) = a

entry_predecessor_is_inverse_child :
  FirstHitsAt a n k ->
  n != a ->
  0 < k ->
  InverseChild a (T^[k - 1] n)
```

Bisagra principal:

```lean
entry_pred_eq_of_reaches_child :
  NotInCycle a ->
  T c = a ->
  ReachesWithin c x n ->
  a <= x ->
  FirstHitsAt a n k0 ->
  0 < k0 ->
  T^[k0 - 1] n = c
```

La hipotesis `a <= x` queda en la firma para coincidir con el consumidor de
ventanas de D1/D2/D3, aunque la igualdad del predecesor usa solo el hit a `c`,
el primer hit a `a` y `NotInCycle a`.

Consumidor de disyuncion por fibras:

```lean
inverse_children_disjoint_descendants :
  NotInCycle a ->
  c1 != c2 ->
  T c1 = a ->
  T c2 = a ->
  ReachesWithin c1 x n ->
  ReachesWithin c2 x n ->
  a <= x ->
  FirstHitsAt a n k0 ->
  0 < k0 ->
  False
```

La prueba compara los dos valores de `T^[k0 - 1] n`. Si ambos subarboles
pretenden entrar por el mismo primer hit de `a`, ese predecesor inmediato no
puede ser simultaneamente `c1` y `c2`.

## Build

Comando:

```text
lake build CollatzClassical.KL2003.KL2003M0BEntryPredecessorDisjointness
```

Resultado:

```text
Build completed successfully.
```

## Axiom audit

Comando:

```text
lake env lean CollatzClassical/KL2003/KL2003M0BEntryPredecessorDisjointnessAxiomAudit.lean
```

Salida:

```text
'CollatzClassical.KL2003.firstHitsAt_of_natFind' does not depend on any axioms
'CollatzClassical.KL2003.exists_firstHitsAt_of_reachesWithin' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.T_ne_self' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.inverseChild_ne_root_of_one_le' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.entry_predecessor_maps_to_root' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.entry_predecessor_is_inverse_child' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.iterate_from_later_hit' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.entry_pred_eq_of_reaches_child' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.inverse_children_disjoint_descendants' depends on axioms: [propext, Quot.sound]
```

No se introdujo `sorry`, `admit`, `axiom`, `unsafe`, `native_decide`,
`Lean.trustCompiler` ni `Lean.ofReduceBool`.

## Hashes

```text
db8a0e0faee509106f8fa957c82a3df6aff16fc078a043fb1d9f3a2b47339083  CollatzClassical/KL2003/KL2003M0BEntryPredecessorDisjointness.lean
53c1e3d94d835b62bf9c229171457152f2c9ccc7df6e2a7a49da650c53bfac3c  CollatzClassical/KL2003/KL2003M0BEntryPredecessorDisjointnessAxiomAudit.lean
```

## Resultado

```text
ENTRY_PREDECESSOR_LAYER_COMPILED = yes
FIRST_HIT_INTERFACE_PROVED = yes
NOTINCYCLE_HYPOTHESIS_DOCUMENTED = yes
ENTRY_PREDECESSOR_MAPS_TO_ROOT_PROVED = yes
ENTRY_PRED_EQ_OF_REACHES_CHILD_PROVED = yes
INVERSE_CHILD_DISJOINTNESS_PROVED = yes
INVERSE_CHILD_DISJOINTNESS_STATEMENT_REFINED = yes
NO_D1_D2_D3 = yes
NO_M0_THEOREM = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
