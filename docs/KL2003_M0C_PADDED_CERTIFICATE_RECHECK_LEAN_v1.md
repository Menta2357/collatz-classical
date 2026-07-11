# KL2003_M0C_PADDED_CERTIFICATE_RECHECK_LEAN_v1

Fecha: 2026-07-11.

Estado: recheck Lean del certificado padded para `I2ELAbstractRowsV2`, antes de
consumir V2 en la induccion M0C principal.

## Clasificacion

```text
PADDED_CERTIFICATE_RECHECK_PROVED
LAMBDA_NEG_THREE_EPSILON_BOUND_PROVED
PADDED_ROW22_ARITHMETIC_PROVED
PADDED_ROW28_ARITHMETIC_PROVED
ROW25_NO_ADVANCED_PAD_CONFIRMED
M0C_MAIN_INDUCTION_READY
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes mantenidos:

```text
NO_MAIN_INDUCTION_THIS_PASS
NO_M1_THEOREM
NO_GLOBAL_COLLATZ
NO_COLLATZ_CLOSURE
NO_ALMOST_ALL
```

## Lemas Lean Anadidos

En:

```text
CollatzClassical/KL2003/KL2003M0CRetardedInduction.lean
```

se probaron:

```text
lambdaR_cube_lt_four :
  lambdaR ^ (3 : Real) < 4

pad_inv_power_ge_four :
  (4 : Real) <= (10000 / 9997 : Real) ^ (10000 : Real)

lambdaR_three_epsilon_le_pad_inv :
  lambdaR ^ (3 * epsilon0) <= (10000 / 9997 : Real)

lambda_neg_three_epsilon_ge :
  (9997 / 10000 : Real) <= lambdaR ^ (-(3 * epsilon0))
```

La prueba de `pad_inv_power_ge_four` usa Bernoulli mediante
`one_add_mul_self_le_rpow_one_add`:

```text
(1 + 3/9997)^10000 >= 1 + 10000*(3/9997) >= 4
```

Asi se evita expandir potencias enormes.

## Filas Racionales Padded

Se usa el factor uniforme conservador:

```text
q := 9997/10000
```

que cubre una perdida de hasta profundidad 3 por
`lambda_neg_three_epsilon_ge`.

### row22/D1

```text
padded_row22_slack_eq :
  (400/729)*c28R + (119/135)*q*c12R - c22R
    = 33037/12150000

padded_row22_arithmetic :
  c22R <= (400/729)*c28R + (119/135)*q*c12R
```

### row25/D2

`row25` sigue sin pad advanced:

```text
row25_no_advanced_pad_arithmetic :
  c25R <= (400/729)*c22R
```

Esto confirma que `row25/D2` no gasta el margen fino en redondeo advanced.

### row28/D3

```text
padded_row28_slack_eq :
  (400/729)*c25R + (119/100)*q*c12R - c28R
    = 10124747/729000000

padded_row28_arithmetic :
  c28R <= (400/729)*c25R + (119/100)*q*c12R
```

El uso de `q = 9997/10000` es uniforme y conservador para los niveles 1, 2 y
3 del bloque advanced/min de V2.

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

## Estado

El recheck padded queda cerrado como aritmetica Lean. La induccion principal
M0C todavia no se inicia en este paso, pero el contrato V2 ya tiene el recheck
aritmetico necesario para ser consumido en el siguiente modulo/patch.

