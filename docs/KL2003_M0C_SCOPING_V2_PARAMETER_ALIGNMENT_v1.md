# KL2003_M0C_SCOPING_V2_PARAMETER_ALIGNMENT_v1

Fecha: 2026-07-09.

Estado: patch documental para alinear M0C con scaling seam v2. No se crea Lean,
no se ejecutan builds, no se modifica certificado y no se toca M0B.

## Clasificacion

```text
M0C_SCOPING_ALIGNED_WITH_SEAM_V2
OLD_DELTA_LAMBDA_MINUS_TWO_DEPRECATED
BASE_SEGMENT_0_14_REGISTERED
DELTA_V2_REGISTERED
ROW22_ROW28_THRESHOLDS_REFERENCED
ROW25_ADVANCED_ROUNDING_IMMUNITY_REFERENCED
M0C_LEAN_READY_BY_DOCUMENTATION
NO_NEW_LEAN
NO_M0C_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Cambio De Parametros

El scoping original de M0C usaba parametros pre-seam-v2:

```text
base segment: 0 <= y < 2
Delta: lambda^-2 = (20/27)^2
```

Tras `KL2003_SCALING_SEAM_LEDGER_MAP_AND_BASE_SEGMENT_PATCH_v2`, esos
parametros quedan deprecados como parametros finales. M0C Lean debe usar seam-v2
como fuente:

```text
base segment: 0 <= y < 14
DeltaV2 = (20/27)^14 / 2
        = 1 / (2 * (27/20)^14)
```

## Condiciones Laterales Del Seam-v2

M0C debe referenciar como inputs externos, sin probarlos:

```text
row22 advanced rounding absorbed for xAdv >= 128
row28 advanced rounding absorbed for xAdv >= 37
row25/D2 has no advanced rounding charge
small windows below thresholds are covered by base segment widening
```

## Contrato Lean Futuro

Modulo futuro:

```text
CollatzClassical/KL2003/KL2003M0CRetardedInduction.lean
```

Debe incluir:

```text
abstract Phi functions
EL row hypotheses
zero-extension for y < 0
retardedRank with delta = 5 - 3*alpha
base segment [0,14]
DeltaV2 = (20/27)^14 / 2
```

Conclusion abstracta esperada:

```text
phi_m(y) >= DeltaV2 * c_m * lambda^y
```

en la region inductiva, o la formulacion abstracta equivalente que se fije en
Lean.

## Separacion De Responsabilidades

M0C sigue siendo abstracto:

```text
M0C consumes EL rows as hypotheses
M0C does not touch piStarFinset
M0C does not prove scaling seam
M0C does not prove rounding ledger
M0C does not prove M1 theorem
```

## Archivos

Actualizado:

```text
docs/KL2003_M0C_RETARDED_INDUCTION_SCOPING_v1.md
```

Creado:

```text
docs/KL2003_M0C_SCOPING_V2_PARAMETER_ALIGNMENT_v1.md
```

## Resultado

```text
M0C_SCOPING_ALIGNED_WITH_SEAM_V2 = yes
OLD_DELTA_LAMBDA_MINUS_TWO_DEPRECATED = yes
BASE_SEGMENT_0_14_REGISTERED = yes
DELTA_V2_REGISTERED = yes
ROW22_ROW28_THRESHOLDS_REFERENCED = yes
ROW25_ADVANCED_ROUNDING_IMMUNITY_REFERENCED = yes
M0C_LEAN_READY_BY_DOCUMENTATION = yes
NO_NEW_LEAN = yes
NO_M0C_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
