# KL2003_M0C_MAIN_RETARDED_INDUCTION_LEAN_v1

Fecha: 2026-07-11.

Estado: cierre parcial honesto. Se avanzo la capa Lean necesaria para la
induccion principal M0C con `I2ELAbstractRowsV2`, pero no se declaro el teorema
principal `RetardedLowerBoundConclusion Phi`.

## Clasificacion

```text
I2_EL_ROWS_V2_CONTRACT_INPUT_DEFINED
RETARDED_RANK_POS_HELPER_PROVED
MIN3_HELPER_PROVED
PADDED_CERTIFICATE_RECHECK_CONSUMED_PARTIALLY
ROW22_ASSEMBLY_PROVED
ROW25_ASSEMBLY_PROVED
M0C_MAIN_INDUCTION_BLOCKED_ON_ROW28_ASSEMBLY
PHI_CONCRETE_INSTANTIATION_STILL_OPEN
REAL_TO_NAT_WINDOW_POLICY_STILL_OPEN
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

No se clasifica como:

```text
M0C_MAIN_INDUCTION_PROVED
RETARDED_RANK_STRONG_INDUCTION_CONSUMED
ABSTRACT_PHI_BOUND_PROVED
```

## Guardarrailes

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

## Lean Anhadido

En:

```text
CollatzClassical/KL2003/KL2003M0CRetardedInduction.lean
```

se definio el input V2, manteniendo V1 intacto:

```text
K2RetardedInductionInputsV2
  certificate
  endpointsB
  endpointsD
  zeroExtension
  weightedBase
  rowsV2 : I2ELAbstractRowsV2 Phi
```

Tambien se probo:

```text
k2_retarded_inputs_v2_from_closed_certificate
retardedRank_pos_of_fourteen_le
le_min3
```

## Ensamblajes Cerrados

### Row25

Se cerro completamente la fila single-branch:

```text
row25_target_le_shifted22
row25_assembly
```

`row25_assembly` consume:

```text
Phi.phi22 (y - 2) <= Phi.phi25 y
Phi22LowerBoundAt Phi (y - 2)
```

y concluye:

```text
Phi25LowerBoundAt Phi y
```

La aritmetica usada es:

```text
row25_no_advanced_pad_arithmetic
```

### Row22

Se cerro el ensamblaje de row22:

```text
lambdaR_shiftAlphaMinus2Pad_factor_lower
alpha2pad_c12_term_le_component
row22_target_le_coeff_sum
row22_assembly
```

`row22_assembly` consume:

```text
row22 de I2ELAbstractRowsV2
Phi28LowerBoundAt Phi (y - 2)
Phi22LowerBoundAt Phi (y + shiftAlphaMinus2Pad)
Phi25LowerBoundAt Phi (y + shiftAlphaMinus2Pad)
Phi28LowerBoundAt Phi (y + shiftAlphaMinus2Pad)
```

y concluye:

```text
Phi22LowerBoundAt Phi y
```

La aritmetica padded consumida es:

```text
padded_row22_arithmetic
lambda_neg_epsilon_ge
```

## Bloqueo Exacto

El cierre principal queda bloqueado en row28. La fila V2 tiene la forma:

```text
Phi.phi25 (y - 2)
  + min
      (Phi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 Phi y)
      (Phi.phi22 (y + shiftAlphaMinus3Pad))
  <= Phi.phi28 y
```

Para consumir `padded_row28_arithmetic`, falta probar el siguiente consumidor
intermedio, o una variante equivalente:

```text
row28_padded_block_lower :
  Phi22LowerBoundAt Phi (y + shiftAlphaMinus3Pad) ->
  Phi28LowerBoundAt Phi (y + shiftAlphaMinus3Pad) ->
  Phi22LowerBoundAt Phi (y + shift2AlphaMinus5Pad2) ->
  Phi28LowerBoundAt Phi (y + shift2AlphaMinus5Pad2) ->
  Phi22LowerBoundAt Phi (y + shift3AlphaMinus5Pad3) ->
  Phi25LowerBoundAt Phi (y + shift3AlphaMinus5Pad3) ->
  Phi28LowerBoundAt Phi (y + shift3AlphaMinus5Pad3) ->
  DeltaV2 * ((119 / 100) * (9997 / 10000) * c12R) * lambdaR^y
    <=
  min
    (Phi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 Phi y)
    (Phi.phi22 (y + shiftAlphaMinus3Pad))
```

Una parte ya se probo:

```text
lambdaR_shiftAlphaMinus3Pad_c22_factor_lower
```

que cierra el segundo brazo del `min`. Falta el primer brazo, donde aparece:

```text
Phi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 Phi y
```

El sublema esperado es algo del tipo:

```text
M1V2_lower_fraction_of_Dq :
  ... ->
  DeltaV2 * ((1/10) * (119 / 100) * (9997 / 10000) * c12R) * lambdaR^y
    <= M1V2 Phi y
```

junto con una cota para:

```text
Phi.phi28 (y + shiftAlphaMinus3Pad)
```

que aporte el resto del termino `D_lo*q`. Esto parece matematicamente
razonable, pero no se cerro en esta pasada sin introducir un wrapper o un
statement no verificado.

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

El audit reporta solo dependencias habituales:

```text
propext
Classical.choice
Quot.sound
```

No se introdujo:

```text
sorry
admit
axiom
unsafe
native_decide
piStarFinset
```

