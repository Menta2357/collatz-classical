# KL2003_M0B_REACHABILITY_BOOL_PROP_IFF_LEAN_v1

Fecha: 2026-07-07.

Estado: puente Bool/Prop reforzado para M0B, con completitud e iff
condicionales. El iff absoluto

```text
boundedReaches a x n = true <-> ReachesWithin a x n
```

queda bloqueado por el invariante de suficiencia del fuel `x + 1`.

## Clasificacion

```text
BOUNDEDREACHES_SOUND_PROVED
PISTARPROPFINSET_DEDUPLICATED_OR_AUXILIARY_ONLY
BLOCKED_ON_FUEL_SUFFICIENCY_INVARIANT
NO_D1_D2_D3
NO_M0_THEOREM
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Clasificaciones no reclamadas:

```text
BOOL_PROP_BRIDGE_IFF_PROVED
BOUNDEDREACHES_COMPLETE_PROVED
PISTAR_FINSET_PROP_CHARACTERIZATION_PROVED
```

`PISTAR_FINSET_PROP_CHARACTERIZATION_PROVED` no se reclama en forma
absoluta: se probo una direccion incondicional y la caracterizacion completa
solo bajo el mismo invariante de fuel.

Guardarrailes:

```text
NO_D1_D2_D3
NO_FIRST_HIT_ENTRY_PREDECESSOR_PROOF
NO_TREE_INEQUALITY_PROOF
NO_RETARDED_INDUCTION_PROOF
NO_M0_THEOREM
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
NO_NATIVE_DECIDE
```

## Archivos actualizados

```text
CollatzClassical/KL2003/KL2003M0BReachabilityAPI.lean
CollatzClassical/KL2003/KL2003M0BReachabilityAPIAxiomAudit.lean
```

## Resultado Lean

Se mantiene `ReachesWithin`, `InverseChild`, `NotInCycle` y `PathWithin`.

`piStarPropFinset` queda conservado solo como vista auxiliar Prop:

```lean
-- Auxiliary Prop-view finset for M0B reasoning.  The primary validated
-- definition remains `piStarFinset` from M0A.
noncomputable def piStarPropFinset (a x : Nat) : Finset Nat
```

La direccion Bool -> Prop queda cerrada:

```lean
theorem boundedReachesWithFuel_sound {fuel a x n : Nat}
    (h : boundedReachesWithFuel fuel a x n = true) :
    ReachesWithin a x n

theorem boundedReaches_sound {a x n : Nat}
    (h : boundedReaches a x n = true) :
    ReachesWithin a x n
```

Tambien se probo completitud desde un witness ya acotado por fuel:

```lean
theorem boundedReachesWithFuel_complete_of_witness {fuel a x n k : Nat}
    (hwin : forall j, j <= k -> T^[j] n <= x)
    (hhit : T^[k] n = a)
    (hk : k <= fuel) :
    boundedReachesWithFuel fuel a x n = true

theorem boundedReaches_complete_of_witness {a x n k : Nat}
    (hwin : forall j, j <= k -> T^[j] n <= x)
    (hhit : T^[k] n = a)
    (hk : k <= x + 1) :
    boundedReaches a x n = true
```

Para no ocultar la hipotesis matematica pendiente, se introdujo:

```text
def ReachesWithinFuelSufficient (a x n : Nat) : Prop :=
  forall _h : ReachesWithin a x n,
    exists k,
      k <= x + 1 /\
      (forall j, j <= k -> T^[j] n <= x) /\
      T^[k] n = a
```

Bajo esta hipotesis, el puente completo queda disponible como lema
condicional:

```text
theorem boundedReaches_complete_of_fuel_sufficient {a x n : Nat}
    (hsuff : ReachesWithinFuelSufficient a x n)
    (h : ReachesWithin a x n) :
    boundedReaches a x n = true

theorem boundedReaches_iff_of_fuel_sufficient {a x n : Nat}
    (hsuff : ReachesWithinFuelSufficient a x n) :
    boundedReaches a x n = true <-> ReachesWithin a x n
```

La caracterizacion del finset M0a existente queda tambien separada:

```text
theorem mem_piStarFinset_reachesWithin_of_mem {a x n : Nat}
    (h : n in piStarFinset a x) :
    n <= x /\ 1 <= n /\ ReachesWithin a x n

theorem mem_piStarFinset_reachesWithin_iff_of_fuel_sufficient {a x n : Nat}
    (hsuff : ReachesWithinFuelSufficient a x n) :
    n in piStarFinset a x <->
      n <= x /\ 1 <= n /\ ReachesWithin a x n

theorem piStarPropFinset_eq_piStarFinset_of_fuel_sufficient {a x : Nat}
    (hsuff : forall n, ReachesWithinFuelSufficient a x n) :
    piStarPropFinset a x = piStarFinset a x
```

## Bloqueo exacto

El lema faltante es:

```text
reachesWithin_has_hit_before_fuel_x_plus_one :
  ReachesWithin a x n ->
  exists k,
    k <= x + 1 /\
    (forall j, j <= k -> T^[j] n <= x) /\
    T^[k] n = a
```

Esto es precisamente la instancia global de `ReachesWithinFuelSufficient`.
El obstaculo no es aritmetica local del Bool, sino convertir un witness
existencial arbitrario de `ReachesWithin` en un witness antes de `x + 1`.

Ruta esperada para cerrar el bloqueo:

```text
1. escoger primer hit/minimal witness;
2. probar no repeticion estricta antes del primer hit;
3. usar pigeonhole sobre los estados dentro de la ventana {0, ..., x};
4. deducir que el primer hit ocurre con k <= x + 1.
```

Esta ruta toca la API de first-hit/ciclos y por eso se dejo fuera de esta
tarea, conforme al guardarrail de no entrar en entry predecessor ni
disjointness.

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

Salida relevante:

```text
'CollatzClassical.KL2003.reachesWithin_self' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.reachesWithin_window_mono' does not depend on any axioms
'CollatzClassical.KL2003.reachesWithin_append_path' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.mem_piStarPropFinset_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.boundedReachesWithFuel_sound' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.boundedReaches_sound' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.boundedReachesWithFuel_complete_of_witness' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.boundedReaches_complete_of_witness' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.boundedReaches_complete_of_fuel_sufficient' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.boundedReaches_iff_of_fuel_sufficient' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.mem_piStarFinset_reachesWithin_of_mem' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.mem_piStarFinset_reachesWithin_iff_of_fuel_sufficient' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.piStarPropFinset_eq_piStarFinset_of_fuel_sufficient' depends on axioms: [propext, Classical.choice, Quot.sound]
```

No aparece `Lean.trustCompiler`, `Lean.ofReduceBool`, `native_decide`,
`sorry`, `admit`, `axiom` ni `unsafe` en el modulo API.

## Hashes

```text
b476b0345e85be9e567a762ac58366f91b5e6bd4905a67080e850afd1a7e9fb6  CollatzClassical/KL2003/KL2003M0BReachabilityAPI.lean
56b532107c1ecf4bb3fbbb5cb02dc4e472d64c781f5806f768bf588aabce71c6  CollatzClassical/KL2003/KL2003M0BReachabilityAPIAxiomAudit.lean
```

## Resultado

```text
BOOL_PROP_BRIDGE_IFF_PROVED = no
BOUNDEDREACHES_SOUND_PROVED = yes
BOUNDEDREACHES_COMPLETE_PROVED = no
PISTAR_FINSET_PROP_CHARACTERIZATION_PROVED = conditional only
PISTARPROPFINSET_DEDUPLICATED_OR_AUXILIARY_ONLY = yes
BLOCKED_ON_FUEL_SUFFICIENCY_INVARIANT = yes
NO_D1_D2_D3 = yes
NO_M0_THEOREM = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
