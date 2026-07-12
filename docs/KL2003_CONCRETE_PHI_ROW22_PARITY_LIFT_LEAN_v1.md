# KL2003_CONCRETE_PHI_ROW22_PARITY_LIFT_LEAN_v1

Fecha: 2026-07-13.

Estado: capa de parity lift row22 formalizada en Lean. No se prueba row22
completo, no se abre row28 nested case analysis, no se prueba
`I2ELAbstractRowsV2 concretePhi`, y no se declara ningun M1.

## Clasificacion

```text
ROW22_ADVANCED_CHILD_ARITH_PROVED
ROW22_PARITY_LIFT_ROUTE_PROVED
ROW22_LIFTED_CHILD_NOTINCYCLE_PROVED
ROW22_LIFTED_CHILD_RESIDUE_SPLIT_PROVED
ROW22_PARITY_WINDOW_EXACT_PROVED
ROW22_PARITY_PISTAR_TRANSFER_PROVED
ROW22_FULL_SEAM_NOT_STARTED
ROW28_NESTED_CASE_ANALYSIS_NOT_STARTED
K2_INPUTS_V2_NOT_YET_PROVED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_ROW22_FULL_SEAM_THIS_PASS
NO_ROW28_NESTED_THIS_PASS
NO_ROWS_V2_FULL_SEAM
NO_K2_INPUTS_V2_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ
NO_COLLATZ_CLOSURE
NO_ALMOST_ALL
```

## Definiciones

Se anadieron:

```lean
row22AdvancedChild (a : Nat) := 6 * (a / 9) + 1
row22LiftedChild (a : Nat) := 2 * row22AdvancedChild a
```

Para `a % 9 = 2`, `row22AdvancedChild a` es el child advanced directo
`c = (2a - 1)/3`; `row22LiftedChild a` es el child trackeado `2c`.

## Aritmetica Del Child

Lemas:

```lean
row22_root_decomp :
  a % 9 = 2 -> a = 9 * (a / 9) + 2

row22_advanced_child_arith :
  a % 9 = 2 ->
  3 * row22AdvancedChild a + 1 = 2 * a

row22_advanced_child_mod_three :
  row22AdvancedChild a % 3 = 1
```

Esto formaliza que el child advanced directo no cae en las clases trackeadas
`{2,5,8} mod 9`; queda en `1 mod 3`.

## Ruta De Paridad

Lemas:

```lean
row22_parity_lift_maps_to_child :
  T (row22LiftedChild a) = row22AdvancedChild a

row22_advanced_child_maps_to_root :
  a % 9 = 2 ->
  T (row22AdvancedChild a) = a

row22_parity_lift_route_to_root :
  a % 9 = 2 ->
  T^[2] (row22LiftedChild a) = a
```

Esta es la ruta:

```text
2c -> c -> a
```

y es la razon del shift:

```text
(alpha - 1) - 1 = alpha - 2
```

## NotInCycle

Se probo el cierre generico:

```lean
notInCycle_of_iterate_maps_to_notInCycle :
  NotInCycle a ->
  T^[k] b = a ->
  NotInCycle b
```

Consumidores row22:

```lean
row22_advanced_child_notInCycle :
  a % 9 = 2 ->
  NotInCycle a ->
  NotInCycle (row22AdvancedChild a)

row22_lifted_child_notInCycle :
  a % 9 = 2 ->
  NotInCycle a ->
  NotInCycle (row22LiftedChild a)
```

Esto no es una afirmacion global de Collatz. Es solo transporte local de
hipotesis `NotInCycle` a lo largo de una ruta finita ya probada.

## Split De Residuos

Lemas base por `t % 3`:

```lean
row22_lifted_child_residue_mod_9_of_t_mod_0 :
  t % 3 = 0 -> (2 * (6 * t + 1)) % 9 = 2

row22_lifted_child_residue_mod_9_of_t_mod_1 :
  t % 3 = 1 -> (2 * (6 * t + 1)) % 9 = 5

row22_lifted_child_residue_mod_9_of_t_mod_2 :
  t % 3 = 2 -> (2 * (6 * t + 1)) % 9 = 8
```

Versiones para `a / 9`:

```lean
row22_lifted_child_residue_mod_9_of_root_t_mod_0
row22_lifted_child_residue_mod_9_of_root_t_mod_1
row22_lifted_child_residue_mod_9_of_root_t_mod_2
```

Wrappers de membresia:

```lean
row22_lifted_child_classRoot_mod2 :
  a : ClassRoots 2 ->
  (a.1 / 9) % 3 = 0 ->
  ClassRoots 2

row22_lifted_child_classRoot_mod5 :
  a : ClassRoots 2 ->
  (a.1 / 9) % 3 = 1 ->
  ClassRoots 5

row22_lifted_child_classRoot_mod8 :
  a : ClassRoots 2 ->
  (a.1 / 9) % 3 = 2 ->
  ClassRoots 8
```

## Ventana Exacta

Lema:

```lean
row22_parity_concreteWindow :
  concreteWindow (z - 1) (2 * c) = concreteWindow z c
```

La igualdad es exacta para la `concreteWindow` actual basada en `Nat.ceil`,
porque:

```text
2^(z-1) * (2c) = 2^z * c
```

No se introduce pad ni perdida de floor en esta capa.

## Transfer PiStar

Version Nat:

```lean
row22_parity_piStar_transfer_nat :
  xLift <= x ->
  piStar (2 * c) xLift <= piStar c x
```

Version concreta:

```lean
row22_parity_piStar_transfer :
  (piStar (2 * c) (concreteWindow (z - 1) (2 * c)) : Real)
    <=
  (piStar c (concreteWindow z c) : Real)
```

La prueba usa:

```text
2c -> c
mem_piStarFinset_reachesWithin_iff
reachesWithin_window_mono
reachesWithin_append_path
two_branch_child_path_to_root
row22_parity_concreteWindow
```

## Auditoria

Se extendio:

```text
CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
```

con `#print axioms` para todos los lemas row22 parity lift nuevos.

## Verificacion

Comandos ejecutados:

```text
lake build CollatzClassical.KL2003.KL2003ConcretePhiRealization
lake env lean CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
git diff --check
```

Resultado:

```text
lake build PASS
axiom audit PASS
git diff --check PASS
```

Barrido textual:

```text
no sorry
no admit
no unsafe
no native_decide
```

## Pendiente

```text
concretePhi_row22_seam
row28 nested case analysis
I2ELAbstractRowsV2 concretePhi
K2RetardedInductionInputsV2 concretePhi
M1 theorem
global Collatz claim
```
