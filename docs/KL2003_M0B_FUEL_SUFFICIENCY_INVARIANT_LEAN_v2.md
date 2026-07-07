# KL2003_M0B_FUEL_SUFFICIENCY_INVARIANT_LEAN_v2

Fecha: 2026-07-07.

Estado: invariante de fuel cerrado en Lean para la API M0B. Con esto el
puente entre la semantica computable Bool de M0a y la API Prop de M0B queda
cerrado:

```lean
boundedReaches a x n = true ↔ ReachesWithin a x n
```

## Clasificacion

```text
FUEL_SUFFICIENCY_INVARIANT_PROVED
BOUNDEDREACHES_COMPLETE_PROVED
BOOL_PROP_BRIDGE_IFF_PROVED
PISTAR_FINSET_PROP_CHARACTERIZATION_PROVED
NO_D1_D2_D3
NO_ENTRY_PREDECESSOR_YET
NO_M0_THEOREM
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Clasificaciones de bloqueo no reclamadas:

```text
BLOCKED_ON_ITERATE_REPEAT_PROPAGATION
BLOCKED_ON_MINIMAL_HIT_DISTINCTNESS
BLOCKED_ON_PIGEONHOLE_BOUND
BLOCKED_ON_BOUNDED_MIN_HIT
BLOCKED_ON_COMPLETE_ASSEMBLY
```

## Archivos actualizados

```text
CollatzClassical/KL2003/KL2003M0BReachabilityAPI.lean
CollatzClassical/KL2003/KL2003M0BReachabilityAPIAxiomAudit.lean
```

## Lemas cerrados

El lema de repeticion se enuncio en la forma de la v2:

```lean
theorem iterate_repeat_propagates {n j p : Nat}
    (h : T^[j] n = T^[j + p] n) :
    ∀ i, T^[j + i] n = T^[j + i + p] n
```

La minimalidad del primer hit queda separada de las cotas de ventana. El
`Nat.find` busca solo el predicado de hit:

```lean
∃ m, T^[m] n = a
```

y el lema de distincion es:

```lean
theorem minimal_hit_distinct {a n k0 : Nat}
    (hhit : T^[k0] n = a)
    (hmin : ∀ j, j < k0 -> T^[j] n ≠ a) :
    ∀ i j, i <= k0 -> j <= k0 -> T^[i] n = T^[j] n -> i = j
```

El conteo finito queda aislado en:

```lean
theorem pigeonhole_bound {x k0 n : Nat}
    (hwin : ∀ j, j <= k0 -> T^[j] n <= x)
    (hdistinct :
      ∀ i j, i <= k0 -> j <= k0 -> T^[i] n = T^[j] n -> i = j) :
    k0 <= x
```

El ensamblaje del primer hit acotado es:

```lean
theorem reachesWithin_has_bounded_min_hit {a x n : Nat}
    (h : ReachesWithin a x n) :
    ∃ k0,
      k0 <= x ∧
      T^[k0] n = a ∧
      ∀ j, j <= k0 -> T^[j] n <= x
```

y la suficiencia de fuel:

```lean
theorem fuel_sufficient_of_reachesWithin {a x n : Nat}
    (_h : ReachesWithin a x n) :
    ReachesWithinFuelSufficient a x n
```

## Puente cerrado

El lema de completitud desde witness con `k <= fuel` ya existia y no se rehizo.
La v2 solo lo consume despues de probar el witness acotado:

```lean
theorem boundedReaches_complete {a x n : Nat}
    (h : ReachesWithin a x n) :
    boundedReaches a x n = true

theorem boundedReaches_iff {a x n : Nat} :
    boundedReaches a x n = true ↔ ReachesWithin a x n
```

La caracterizacion incondicional del finset validado de M0a queda cerrada:

```lean
theorem mem_piStarFinset_reachesWithin_iff {a x n : Nat} :
    n ∈ piStarFinset a x ↔
      n <= x ∧ 1 <= n ∧ ReachesWithin a x n
```

Tambien queda disponible la igualdad absoluta entre la vista Prop auxiliar y el
finset principal:

```lean
theorem piStarPropFinset_eq_piStarFinset {a x : Nat} :
    piStarPropFinset a x = piStarFinset a x
```

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

Salida relevante para los lemas nuevos:

```text
'CollatzClassical.KL2003.iterate_repeat_propagates' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.minimal_hit_distinct' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.pigeonhole_bound' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.reachesWithin_has_bounded_min_hit' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.fuel_sufficient_of_reachesWithin' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.boundedReaches_complete' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.boundedReaches_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.mem_piStarFinset_reachesWithin_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.piStarPropFinset_eq_piStarFinset' depends on axioms: [propext, Classical.choice, Quot.sound]
```

No se introdujo `sorry`, `admit`, `axiom`, `unsafe`, `native_decide`,
`Lean.trustCompiler` ni `Lean.ofReduceBool`.

## Hashes

```text
87c657b95b413708ef1e69dc2e1a4b1999953e0d1a2fc6f40fc5e97d87b28c02  CollatzClassical/KL2003/KL2003M0BReachabilityAPI.lean
b0a21261e4c1421f2fc474764995d4d9ebb5f31201be194958b767c15e450f29  CollatzClassical/KL2003/KL2003M0BReachabilityAPIAxiomAudit.lean
```

## Resultado

```text
FUEL_SUFFICIENCY_INVARIANT_PROVED = yes
BOUNDEDREACHES_COMPLETE_PROVED = yes
BOOL_PROP_BRIDGE_IFF_PROVED = yes
PISTAR_FINSET_PROP_CHARACTERIZATION_PROVED = yes
NO_D1_D2_D3 = yes
NO_ENTRY_PREDECESSOR_YET = yes
NO_M0_THEOREM = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
