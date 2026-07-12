# KL2003_M0C_ROW28_ASSEMBLY_LEAN_v1

Fecha: 2026-07-12.

Estado: cierre Lean de `row28_assembly` para el contrato M0C V2. Este paso
resuelve el bloqueo documentado en
`KL2003_M0C_MAIN_RETARDED_INDUCTION_LEAN_v1.md`, pero no inicia todavia la
induccion principal ni declara `RetardedLowerBoundConclusion`.

## Clasificacion

```text
EL_A_MARGIN_PROVED
EL_C_MIN3_BOX_PROVED
M2V2_LOWER_BOUND_PROVED
M1V2_LOWER_BOUND_PROVED
ROW28_BLOCK_LOWER_BOUND_PROVED
ROW28_ASSEMBLY_PROVED
ROW22_ASSEMBLY_RETAINED
ROW25_ASSEMBLY_RETAINED
M0C_MAIN_INDUCTION_READY
NO_MAIN_INDUCTION_THIS_PASS
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes mantenidos:

```text
NO_CONCLUSION_V2
NO_PISTAR_THIS_PASS
NO_CONCRETE_PHI_THIS_PASS
NO_REAL_TO_NAT_WINDOW_POLICY_THIS_PASS
NO_SEAM_BRIDGE_THIS_PASS
NO_M1_THEOREM
NO_GLOBAL_COLLATZ
NO_COLLATZ_CLOSURE
NO_ALMOST_ALL
```

## Lemas Nuevos

En:

```text
CollatzClassical/KL2003/KL2003M0CRetardedInduction.lean
```

se anhadieron los lemas racionales pedidos:

```text
EL_A : c12R * lambdaR ^ (2 : Real) <= c22R
EL_C : c12R <= min3 c22R c25R c28R
```

Tambien se cerro el bloque anidado de `row28EL`:

```text
M2V2_lower
M1V2_lower
row28_second_branch_lower
row28_first_branch_lower
row28_padded_block_lower
```

El bloque exterior queda en la forma:

```text
row28_padded_block_lower :
  DeltaV2 * ((119 / 100) * (9997 / 10000) * c12R) * lambdaR^y
    <=
  min
    (Phi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 Phi y)
    (Phi.phi22 (y + shiftAlphaMinus3Pad))
```

Finalmente se probo:

```text
row28_target_le_coeff_sum
row28_assembly
```

`row28_assembly` consume:

```text
row28EL de I2ELAbstractRowsV2
Phi25LowerBoundAt Phi (y - 2)
Phi22LowerBoundAt Phi (y + shiftAlphaMinus3Pad)
Phi28LowerBoundAt Phi (y + shiftAlphaMinus3Pad)
Phi22LowerBoundAt Phi (y + shift2AlphaMinus5Pad2)
Phi28LowerBoundAt Phi (y + shift2AlphaMinus5Pad2)
Phi22LowerBoundAt Phi (y + shift3AlphaMinus5Pad3)
Phi25LowerBoundAt Phi (y + shift3AlphaMinus5Pad3)
Phi28LowerBoundAt Phi (y + shift3AlphaMinus5Pad3)
```

y concluye:

```text
Phi28LowerBoundAt Phi y
```

## Alcance

Este patch no abre:

```text
RetardedLowerBoundConclusion como teorema probado
piStarFinset
Phi concreto
Real-to-Nat/window policy
scaling seam bridge
M1 theorem
```

El siguiente paso natural es ensamblar la induccion principal abstracta usando
`row22_assembly`, `row25_assembly` y `row28_assembly`.

## Verificacion

Ejecutado:

```text
lake build CollatzClassical.KL2003.KL2003M0CRetardedInduction
lake env lean CollatzClassical/KL2003/KL2003M0CRetardedInductionAxiomAudit.lean
```

Resultado:

```text
LEAN_BUILD_PASS = yes
AXIOM_AUDIT_PASS = yes
```

El audit reporta solo dependencias habituales de Mathlib/Real:

```text
propext
Classical.choice
Quot.sound
```
