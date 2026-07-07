# KL2003_M0B_ENTRY_PREDECESSOR_DISJOINTNESS_LEAN_v1

Fecha: 2026-07-08.

Estado: capa Lean de primer hit / predecesor de entrada creada y compilada.
No se prueban D1/D2/D3.

## Clasificacion

```text
ENTRY_PREDECESSOR_LAYER_COMPILED
FIRST_HIT_INTERFACE_PROVED
ENTRY_PREDECESSOR_MAPS_TO_ROOT_PROVED
INVERSE_CHILD_DISJOINTNESS_PROVED
INVERSE_CHILD_DISJOINTNESS_STATEMENT_REFINED
NO_D1_D2_D3
NO_M0_THEOREM
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Clasificaciones de bloqueo no reclamadas:

```text
BLOCKED_ON_FIRST_HIT_API
BLOCKED_ON_ENTRY_PREDECESSOR_FORMULATION
```

## Archivos creados

```text
CollatzClassical/KL2003/KL2003M0BEntryPredecessorDisjointness.lean
CollatzClassical/KL2003/KL2003M0BEntryPredecessorDisjointnessAxiomAudit.lean
```

## Interfaz de primer hit

Se definio la interfaz Prop minima:

```lean
structure FirstHitsAt (a n k : Nat) : Prop where
  hit : T^[k] n = a
  minimal : forall j, j < k -> T^[j] n != a
```

El constructor canonico usa `Nat.find` sobre el predicado de hit puro:

```lean
exists k, T^[k] n = a
```

Lemas cerrados:

```lean
firstHitsAt_of_natFind
firstHitsAt_exists_of_reachesWithin
firstHitsAt_le_of_reachesWithin
```

`firstHitsAt_le_of_reachesWithin` consume el invariante ya probado en M0B:

```lean
reachesWithin_has_bounded_min_hit
```

y devuelve un primer hit `k <= x` con cotas de ventana heredadas.

## Predecesor de entrada

Se probo:

```lean
theorem entry_predecessor_maps_to_root {a n k : Nat}
    (h : FirstHitsAt a n k) (hk : 0 < k) :
    T (T^[k - 1] n) = a

theorem entry_predecessor_is_inverse_child {a n k : Nat}
    (h : FirstHitsAt a n k) (hk : 0 < k) :
    InverseChild a (T^[k - 1] n)
```

Esto da la pieza local de "punto anterior a la entrada" sin abrir todavia
entry-predecessor como estructura global ni las filas D1/D2/D3.

## Disyuncion refinada

La formulacion final del consumidor incluye la hipotesis necesaria:

```lean
NotInCycle a
```

Motivo: sin exclusion de ciclos en la raiz, un mismo nodo puede volver a pasar
por `a` y entrar mas tarde en otra rama inversa. Esta dependencia ya estaba
marcada en el scoping de M0B.

Lemas auxiliares:

```lean
iterate_from_later_hit
cycle_from_ordered_inverse_child_hits
inverse_children_hits_eq
first_entry_unique
```

El consumidor probado es:

```lean
theorem inverse_children_disjoint_descendants {a c1 c2 x n : Nat}
    (hne : c1 != c2)
    (hc1 : InverseChild a c1)
    (hc2 : InverseChild a c2)
    (ha : NotInCycle a)
    (h1 : ReachesWithin c1 x n)
    (h2 : ReachesWithin c2 x n) :
    False
```

La prueba no requiere que `h1` y `h2` sean first hits: si la orbita alcanza dos
hijos inversos de la misma raiz, entonces o los hits son simultaneos, y los
hijos son iguales, o hay una diferencia positiva de tiempos que induce un
ciclo positivo en `a`.

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
'CollatzClassical.KL2003.firstHitsAt_exists_of_reachesWithin' does not depend on any axioms
'CollatzClassical.KL2003.firstHitsAt_le_of_reachesWithin' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.entry_predecessor_maps_to_root' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.entry_predecessor_is_inverse_child' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.iterate_from_later_hit' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.cycle_from_ordered_inverse_child_hits' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.inverse_children_hits_eq' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.first_entry_unique' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.inverse_children_disjoint_descendants' depends on axioms: [propext, Quot.sound]
```

No se introdujo `sorry`, `admit`, `axiom`, `unsafe`, `native_decide`,
`Lean.trustCompiler` ni `Lean.ofReduceBool`.

## Hashes

```text
c548f9caf0e7461bc7007798cef8d5e4c9140259317d421c661f81669375c403  CollatzClassical/KL2003/KL2003M0BEntryPredecessorDisjointness.lean
a38d7c521af07f7d0aeec9e30b08943a07289b1f7560ff64bb074c703c6b9c49  CollatzClassical/KL2003/KL2003M0BEntryPredecessorDisjointnessAxiomAudit.lean
```

## Resultado

```text
ENTRY_PREDECESSOR_LAYER_COMPILED = yes
FIRST_HIT_INTERFACE_PROVED = yes
ENTRY_PREDECESSOR_MAPS_TO_ROOT_PROVED = yes
INVERSE_CHILD_DISJOINTNESS_PROVED = yes
INVERSE_CHILD_DISJOINTNESS_STATEMENT_REFINED = yes
NO_D1_D2_D3 = yes
NO_M0_THEOREM = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
