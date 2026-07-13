# KL2003_CONCRETE_PHI_ROWS_V2_SEAM_SCOPING_v1

Fecha: 2026-07-12.

Estado: ultima pagina de planificacion del seam para probar
`I2ELAbstractRowsV2 concretePhi`, fila por fila. No se crea Lean nuevo, no se
prueba `K2RetardedInductionInputsV2 concretePhi`, y no se declara ningun M1.

## Clasificacion

```text
ROWS_V2_SEAM_SCOPED
ROW22_PARITY_LIFT_CHAIN_IDENTIFIED
ROW25_EXACT_RETARDED_CHAIN_IDENTIFIED
ROW28_DIRECT_CORE_CHAIN_IDENTIFIED
NOTINCYCLE_CLOSURE_REQUIREMENTS_IDENTIFIED
CONCRETE_PHI_MONOTONICITY_REQUIRED
PAD_ABSORBS_FLOOR_REQUIRED
EMPIRICAL_CHAIN_TEST_PLANNED
K2_INPUTS_V2_NOT_YET_PROVED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_NEW_LEAN
NO_K2_INPUTS_V2_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ
NO_COLLATZ_CLOSURE
NO_ALMOST_ALL
```

## Objetivo Exacto

La obligacion semantica restante es:

```lean
theorem concretePhi_rowsV2 :
  I2ELAbstractRowsV2 concretePhi
```

Esto completaria el ultimo input no trivial para construir despues:

```lean
K2RetardedInductionInputsV2 concretePhi
```

porque ya estan probados:

```lean
concretePhi_zeroExtension :
  K2PhiZeroExtension concretePhi

concretePhi_weightedBase :
  BaseSegmentWeightedLowerBound concretePhi
```

Ese constructor de inputs no se ejecuta en esta etapa.

## Convencion De Ventanas

La pagina de seam puede escribirse con `floor`, porque las identidades
retardadas son exactas:

```text
floor(2^y * a) = floor(2^(y-2) * 4a)
```

El Lean actual define:

```lean
concreteWindow y a := Nat.ceil ((2 : Real)^y * (a : Real))
```

La identidad retardada tambien es exacta para `ceil`, porque los argumentos
reales son literalmente iguales:

```text
ceil(2^y * a) = ceil(2^(y-2) * 4a)
```

Por tanto el plan puede usar la igualdad algebraica continua como nucleo y
cerrar luego la variante `floor` o `ceil` que quede fijada definitivamente.

## Lemas De Soporte Previos

Antes de rowsV2 hacen falta:

```text
piStar_window_mono:
  x1 <= x2 -> piStar a x1 <= piStar a x2

concretePhi_mono:
  y1 <= y2 -> concretePhiComponent m y1 <= concretePhiComponent m y2

concretePhiComponent_le_piStar_of_classRoot:
  0 <= y ->
  a : ClassRoots m ->
  concretePhiComponent m y
    <= (piStar a.1 (concreteWindow y a.1) : Real)

le_concretePhiComponent_of_pointwise:
  0 <= y ->
  (forall a : ClassRoots m,
    b <= (piStar a.1 (concreteWindow y a.1) : Real)) ->
  b <= concretePhiComponent m y
```

The `ciInf` transfer lemmas must handle the direct definition:

```lean
concretePhiComponent m y =
  if y < 0 then 0 else
  if Nonempty (ClassRoots m) then
    iInf (fun a : ClassRoots m =>
      (piStar a.1 (concreteWindow y a.1) : Real))
  else 1
```

For source terms, `ciInf_le` requires constructing the transformed source as a
member of the correct `ClassRoots` subtype.

## NotInCycle Closure

Current `ClassRoots m` is:

```lean
{a : Nat // a % 9 = m ∧ NotInCycle a ∧ 1 <= a}
```

Thus the seam needs local closure lemmas:

```text
NotInCycle a -> NotInCycle (4*a)
NotInCycle a -> 3*c + 1 = 2*a -> NotInCycle c
NotInCycle a -> 3*c + 1 = 2*a -> NotInCycle (2*c)
```

The last one is needed by the row22 parity-lift chain. These are local
transfer lemmas under a `NotInCycle a` hypothesis; they are not global Collatz
claims.

## Row25 / D2

### Chain

For target:

```text
a : ClassRoots 5
```

use the single-branch corollary:

```lean
d2_single_branch_core_instantiation
```

with:

```text
source root = 4a
target root = a
x := concreteWindow y a
xRet := x
```

### Residue

If:

```text
a = 9t + 5
```

then:

```text
4a ≡ 2 mod 9
```

This is already packaged as:

```lean
retarded_residue_mod_9_of_root_mod_5
```

### Window

The retarded window is exact:

```text
floor(2^y * a) = floor(2^(y-2) * 4a)
```

and likewise for the current `ceil` implementation.

Thus:

```text
concreteWindow (y - 2) (4*a) = concreteWindow y a
```

or at least the needed inclusion:

```lean
concreteWindow (y - 2) (4*a) <= concreteWindow y a
```

### No Advanced Pad

Row25 is structurally single-branch in EL:

```text
no advanced branch consumed
no advanced floor loss charged to row25
```

This preserves the seam-v2 correction: row25 is immune to advanced rounding.

## Row28 / D3

### Direct Core

For target:

```text
a : ClassRoots 8
```

use:

```lean
d3_core_instantiation
```

with:

```text
source retarded root = 4a
advanced child c, 3*c + 1 = 2*a
```

### Advanced Child Residues

For:

```text
a = 9t + 8
c = (2a - 1)/3 = 6t + 5
```

the class of `c` is:

```text
t % 3 = 0 -> c % 9 = 5
t % 3 = 1 -> c % 9 = 2
t % 3 = 2 -> c % 9 = 8
```

The corresponding Lean residue lemmas already exist:

```lean
d3_advanced_residue_mod_9_of_t_mod_0
d3_advanced_residue_mod_9_of_t_mod_1
d3_advanced_residue_mod_9_of_t_mod_2
```

### Mapping Into row28EL

The outer advanced block in row28EL is:

```lean
min
  (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y)
  (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
```

Case map:

```text
c % 9 = 2:
  use the second arm
    Phi22(y + shiftAlphaMinus3Pad)

c % 9 = 8:
  use the first arm through
    Phi28(y + shiftAlphaMinus3Pad)
  plus nonnegativity / lower support for M1V2

c % 9 = 5:
  use the first arm through M1V2.
  This is the EL elimination case: class 5 is not a direct outer arm and must
  be expanded by the nested M1V2/M2V2 chain.
```

The nested block is:

```lean
M1V2 Phi y =
  min
    (Phi.phi28 (y + shift2AlphaMinus5Pad2) + M2V2 Phi y)
    (Phi.phi25 (y + shift2AlphaMinus5Pad2))

M2V2 Phi y =
  min3
    Phi.phi22 (y + shift3AlphaMinus5Pad3)
    Phi.phi25 (y + shift3AlphaMinus5Pad3)
    Phi.phi28 (y + shift3AlphaMinus5Pad3)
```

Each nested arm must be justified by an additional D1/D2/D3 core application
plus the corresponding window inclusion.

## Row22 / D1

### Structural Finding

For target:

```text
a : ClassRoots 2
```

the immediate advanced child is:

```text
c = (2a - 1)/3
```

If:

```text
a = 9t + 2
```

then:

```text
c = 6t + 1
c ≡ 1 mod 3
```

So `c` is not in any tracked class `{2,5,8} mod 9`. A direct two-branch seam
would not match the `min3` in row22.

### Correct Parity-Lift Chain

The row22 chain is:

```text
1. Apply D1 core directly to get advanced child c.
2. Insert the even parity lift c -> 2c.
3. Use T(2c) = c, so descendants of 2c feed the c branch.
4. Track 2c instead of c in concretePhi.
```

Residues:

```text
2c = 12t + 2
t % 3 = 0 -> 2c % 9 = 2
t % 3 = 1 -> 2c % 9 = 5
t % 3 = 2 -> 2c % 9 = 8
```

Thus the lifted child `2c` lands exactly in `{2,5,8}`, matching:

```lean
min3
  (Phi.phi22 (y + shiftAlphaMinus2Pad))
  (Phi.phi25 (y + shiftAlphaMinus2Pad))
  (Phi.phi28 (y + shiftAlphaMinus2Pad))
```

### Shift Accounting

The direct advanced branch has scale:

```text
y + alpha - 1
```

The parity lift from `c` to `2c` contributes one retarded dyadic step:

```text
-1
```

Therefore:

```text
(alpha - 1) - 1 = alpha - 2
```

After rounding protection, row22 consumes:

```lean
shiftAlphaMinus2Pad = alpha - 2 - epsilon0
```

### Window Identity

Let:

```text
y' := y + alpha - 1
```

The parity lift uses:

```text
floor(2^(y'-1) * 2c) = floor(2^y' * c)
```

and likewise for the current `ceil` implementation. This is the exact window
identity that makes `2c` the tracked source without changing the continuous
advanced frontier.

## Pad Absorbs Floor

The formal seam needs a lemma family:

```text
pad_absorbs_floor
```

schematically:

```lean
concreteWindow (y + shift - epsilon0) source
  <= chosenNatWindowForUnpaddedShift
```

after target floor/ceil losses and advanced-window losses are accounted for.

At `y = 14`, the pad margin per root is:

```text
2^14 * a * (1 - 2^(-1/10000))
```

Using the minimum roots requested:

```text
class 22: a_min = 11
class 25: a_min = 5
class 28: a_min = 8
```

the numerical margins are:

```text
class 22: 12.4917428111066555...
class 25:  5.6780649141393889...
class 28:  9.0849038626230222...
```

All are above `1.5`, so the current base segment `y <= 14` looks sufficient
for this diagnostic. If a future rational proof finds a class margin below
`1.5`, the conservative recommendation is to widen the base to `15`.

For reference, at base `15` the margins double:

```text
class 22: 24.983485622213311...
class 25: 11.356129828278778...
class 28: 18.169807725246044...
```

These are planning numerics, not a formal Lean proof.

## Empirical Chain Test

Before the Lean seam proof, add a script:

```text
scripts/kl2003_concrete_phi_rows_v2_chain_empirical_v1.py
```

Suggested outputs:

```text
outputs/KL2003_CONCRETE_PHI_ROWS_V2_CHAIN_EMPIRICAL_v1/summary.json
outputs/KL2003_CONCRETE_PHI_ROWS_V2_CHAIN_EMPIRICAL_v1/grid.csv
outputs/KL2003_CONCRETE_PHI_ROWS_V2_CHAIN_EMPIRICAL_v1/mismatch.csv
outputs/KL2003_CONCRETE_PHI_ROWS_V2_CHAIN_EMPIRICAL_v1/row22_parity_lift_cases.csv
outputs/KL2003_CONCRETE_PHI_ROWS_V2_CHAIN_EMPIRICAL_v1/manifest_sha256.csv
```

Grid:

```text
a in a reasonable range, e.g. 1..1000
a % 9 in {2,5,8}
y or x windows covering the base/first inductive region
```

Checks:

```text
row25 exact retarded chain
row22 direct child c and parity-lift child 2c
row28 direct child class split
piStar cardinal inequalities member-by-member/cardinality
window inclusion failures
NotInCycle/admissibility failures
```

Summary fields:

```text
total_cases
row22_cases
row25_cases
row28_cases
row22_parity_lift_ok_count
row22_parity_lift_fail_count
window_inclusion_fail_count
core_inequality_fail_count
mismatch_count
worst_pad_margin_by_class
```

This empirical hook should mirror the previous D3 sanity style, but must cover
all three row chains.

## Lean Order Recommended

1. `piStar_window_mono`.
2. `concretePhiComponent_le_piStar_of_classRoot`.
3. `le_concretePhiComponent_of_pointwise`.
4. `concretePhi_mono` in `y`.
5. Retarded exact window identity for row25 and retarded branches.
6. Row22 parity-lift residue and window lemmas.
7. `NotInCycle` closure lemmas for `4a`, `c`, and `2c`.
8. `pad_absorbs_floor` rational/interval proof.
9. `row25_seam`.
10. `row22_seam`.
11. `row28EL_seam`.
12. `concretePhi_rowsV2`.

## Resultado

```text
ROWS_V2_SEAM_SCOPED = yes
ROW22_PARITY_LIFT_CHAIN_IDENTIFIED = yes
ROW25_EXACT_RETARDED_CHAIN_IDENTIFIED = yes
ROW28_DIRECT_CORE_CHAIN_IDENTIFIED = yes
NOTINCYCLE_CLOSURE_REQUIREMENTS_IDENTIFIED = yes
CONCRETE_PHI_MONOTONICITY_REQUIRED = yes
PAD_ABSORBS_FLOOR_REQUIRED = yes
EMPIRICAL_CHAIN_TEST_PLANNED = yes
K2_INPUTS_V2_NOT_YET_PROVED = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
