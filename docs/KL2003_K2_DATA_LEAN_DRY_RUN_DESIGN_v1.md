# KL2003_K2_DATA_LEAN_DRY_RUN_DESIGN_v1

Fecha: 2026-07-05.

Estado: diseno dry-run del primer modulo Lean data-only. No se crea archivo
Lean, no se inicia prueba M0 y no se registra KL2003.

## Clasificacion

```text
DATA_LEAN_DRY_RUN_DESIGN_READY
IMPORTS_MINIMAL_POLICY_READY
NORM_NUM_FACTS_LISTED
NO_LEAN_FILE_CREATED
KL2003_REGISTRATION_STILL_DEFERRED
NO_M0_PROOF
```

Guardarrailes:

```text
NO_LEAN_FILE_YET
NO_M0_PROOF
NO_TARGET_REGISTRATION
NO_FLOAT_EVIDENCE
NO_GLOBAL_COLLATZ_CLAIM
```

## Archivo futuro

Archivo propuesto, no creado todavia:

```text
CollatzClassical/KL2003/KL2003K2CertificateData.lean
```

Proposito: transportar al repositorio Lean solo datos racionales, testigos
enteros y facts aritmeticos `norm_num` asociados al certificado `k=2`.

No debe contener semantica KL2003, ni `phi`, ni arbol inverso, ni puente M0.

## Imports minimos

Politica de import:

```lean
import Mathlib.Data.Rat.Basic
import Mathlib.Tactic.NormNum
```

Si `Mathlib.Tactic.NormNum` no estuviera disponible por layout de mathlib,
fallback permitido:

```lean
import Mathlib.Tactic
```

No importar:

```text
Mathlib.Analysis.*
Mathlib.Topology.*
Mathlib.MeasureTheory.*
Mathlib.Data.Real.*
```

Motivo: el modulo data-only no debe mencionar `Real`, `log`, potencias reales,
`phi`, arbol inverso ni analisis. Los lemas trascendentales permanecen SPEC en
documentacion.

## Estructura exacta del archivo

Orden recomendado:

```text
1. module header / comentario de guardarrailes
2. imports minimos
3. namespace CollatzClassical
4. namespace KL2003
5. estructuras data-only
6. constantes racionales
7. intervalos racionales
8. variables del certificado k=2
9. integer witnesses norm_num
10. rational reductions norm_num
11. endpoint implications norm_num
12. row slack positivity norm_num
13. base segment placeholder como dato/string, no theorem
14. end namespaces
```

Cabecera esperada:

```lean
/-!
Data-only certificate layer for the KL2003 k=2 M1-surrogate LP skeleton.
No Real, no log, no phi, no inverse-tree semantics, no M0 theorem.
-/
```

## Estructuras permitidas

Pseudocodigo Lean permitido:

```lean
structure RationalInterval where
  lo : Rat
  hi : Rat

structure LPRowSlack where
  name : String
  slack : Rat

structure K2InteriorVariables where
  c22 : Rat
  c25 : Rat
  c28 : Rat
  c12 : Rat
  cmax : Rat

structure BaseSegmentPlaceholder where
  name : String
  status : String

structure K2InteriorCertificateData where
  lambda : Rat
  A : RationalInterval
  B : RationalInterval
  D : RationalInterval
  vars : K2InteriorVariables
  baseSegment : BaseSegmentPlaceholder
```

Nota: evitar poner proofs dentro de las estructuras en el primer archivo. Los
facts `norm_num` deben vivir como teoremas separados para que el axiom audit sea
legible linea por linea.

## Constants permitidas

Racionales:

```lean
def lambdaQ : Rat := 27 / 20

def AInterval : RationalInterval := { lo := 400 / 729, hi := 400 / 729 }
def BTargetInterval : RationalInterval := { lo := 22 / 25, hi := 89 / 100 }
def BStrongInterval : RationalInterval := { lo := 119 / 135, hi := 8 / 9 }
def DTargetInterval : RationalInterval := { lo := 119 / 100, hi := 6 / 5 }

def k2Vars : K2InteriorVariables :=
  { c22 := 73 / 40
    c25 := 1001 / 1000
    c28 := 69 / 40
    c12 := 1
    cmax := 2 }
```

Datos de slacks:

```lean
def lower_c22_slack : Rat := 33 / 40
def upper_c22_slack : Rat := 7 / 40
def lower_c25_slack : Rat := 1 / 1000
def upper_c25_slack : Rat := 999 / 1000
def lower_c28_slack : Rat := 29 / 40
def upper_c28_slack : Rat := 11 / 40
def L2NT_D1_slack : Rat := 73 / 48600
def L2NT_D2_slack : Rat := 271 / 729000
def L2NT_D3_slack : Rat := 2077 / 145800
def aux_c12_le_c22_slack : Rat := 33 / 40
def aux_c12_le_c25_slack : Rat := 1 / 1000
def aux_c12_le_c28_slack : Rat := 29 / 40
def domain_c12_positive_slack : Rat := 1
```

Base placeholder:

```lean
def baseSegmentPlaceholder : BaseSegmentPlaceholder :=
  { name := "BaseSegmentLowerBound_phi_I2ELSystem_Y0"
    status := "SPEC_PLACEHOLDER_PRESENT_NOT_PROVED" }
```

## Facts permitidos

Todos los facts de este archivo deben ser aritmeticos y cerrarse con
`by norm_num`.

Integer witnesses:

```lean
theorem k2_two_pow_19_lt_three_pow_12 : 2^19 < 3^12 := by norm_num
theorem k2_three_pow_5_lt_two_pow_8 : 3^5 < 2^8 := by norm_num
theorem k2_gamma_gt_three_sevenths_int :
    8 * 20^7 < 27^7 := by norm_num
```

Rational reductions:

```lean
theorem k2_B_lower_rational_reduction :
    (119 / 135 : Rat)^12 * (27 / 20 : Rat)^5 <= 1 := by norm_num

theorem k2_B_upper_rational_reduction :
    1 <= (8 / 9 : Rat)^5 * (27 / 20 : Rat)^2 := by norm_num
```

Endpoint facts:

```lean
theorem k2_B_lower_implies_target : (22 / 25 : Rat) <= 119 / 135 := by norm_num
theorem k2_B_upper_implies_target : (8 / 9 : Rat) <= 89 / 100 := by norm_num
theorem k2_D_lower_endpoint : (27 / 20 : Rat) * (119 / 135) = 119 / 100 := by norm_num
theorem k2_D_upper_endpoint : (27 / 20 : Rat) * (8 / 9) = 6 / 5 := by norm_num
```

Interval well-formedness:

```lean
theorem k2_A_interval_ok : AInterval.lo <= AInterval.hi := by norm_num [AInterval]
theorem k2_B_target_interval_ok : BTargetInterval.lo <= BTargetInterval.hi := by norm_num [BTargetInterval]
theorem k2_B_strong_interval_ok : BStrongInterval.lo <= BStrongInterval.hi := by norm_num [BStrongInterval]
theorem k2_D_target_interval_ok : DTargetInterval.lo <= DTargetInterval.hi := by norm_num [DTargetInterval]
```

## Norm-num facts: row slack positivity

Allowed theorem list:

```lean
theorem lower_c22_slack_pos : 0 < lower_c22_slack := by norm_num [lower_c22_slack]
theorem upper_c22_slack_pos : 0 < upper_c22_slack := by norm_num [upper_c22_slack]
theorem lower_c25_slack_pos : 0 < lower_c25_slack := by norm_num [lower_c25_slack]
theorem upper_c25_slack_pos : 0 < upper_c25_slack := by norm_num [upper_c25_slack]
theorem lower_c28_slack_pos : 0 < lower_c28_slack := by norm_num [lower_c28_slack]
theorem upper_c28_slack_pos : 0 < upper_c28_slack := by norm_num [upper_c28_slack]
theorem L2NT_D1_slack_pos : 0 < L2NT_D1_slack := by norm_num [L2NT_D1_slack]
theorem L2NT_D2_slack_pos : 0 < L2NT_D2_slack := by norm_num [L2NT_D2_slack]
theorem L2NT_D3_slack_pos : 0 < L2NT_D3_slack := by norm_num [L2NT_D3_slack]
theorem aux_c12_le_c22_slack_pos : 0 < aux_c12_le_c22_slack := by norm_num [aux_c12_le_c22_slack]
theorem aux_c12_le_c25_slack_pos : 0 < aux_c12_le_c25_slack := by norm_num [aux_c12_le_c25_slack]
theorem aux_c12_le_c28_slack_pos : 0 < aux_c12_le_c28_slack := by norm_num [aux_c12_le_c28_slack]
theorem domain_c12_positive_slack_pos : 0 < domain_c12_positive_slack := by norm_num [domain_c12_positive_slack]
```

Optional but useful row reconstruction facts, still rational-only:

```lean
theorem k2_L2NT_D1_slack_eq :
    (400/729 : Rat) * (69/40) + (22/25) * 1 - (73/40) = 73/48600 := by norm_num

theorem k2_L2NT_D2_slack_eq :
    (400/729 : Rat) * (73/40) - (1001/1000) = 271/729000 := by norm_num

theorem k2_L2NT_D3_slack_eq :
    (400/729 : Rat) * (1001/1000) + (119/100) * 1 - (69/40) = 2077/145800 := by norm_num
```

## What must not appear

The data module must not contain:

```text
Real
log
Real.rpow
NNReal
phi
pi_a
pi_a_star
inverse tree
I2EL semantic theorem
retarded LP -> lower bound theorem
M0 theorem
M1 lower bound theorem
global Collatz statement
sorry
admit
axiom
unsafe
noncomputable
```

Static grep policy for review:

```text
rg -n "Real|log|rpow|NNReal|phi|pi_a|inverse|M0|M1|Collatz conjecture|sorry|admit|axiom|unsafe|noncomputable" CollatzClassical/KL2003/KL2003K2CertificateData.lean
```

Expected result: no matches, except harmless occurrences inside the module
comment if reviewers decide to keep the guardrail comment. Cleaner option:
avoid those forbidden words in comments too.

## Axiom audit design

Future audit file, not created yet:

```text
CollatzClassical/KL2003/KL2003K2CertificateDataAxiomAudit.lean
```

Expected contents:

```lean
import CollatzClassical.KL2003.KL2003K2CertificateData

#print axioms k2_two_pow_19_lt_three_pow_12
#print axioms k2_three_pow_5_lt_two_pow_8
#print axioms k2_gamma_gt_three_sevenths_int
#print axioms k2_B_lower_rational_reduction
#print axioms k2_B_upper_rational_reduction
#print axioms k2_L2NT_D1_slack_eq
#print axioms k2_L2NT_D2_slack_eq
#print axioms k2_L2NT_D3_slack_eq
```

Command after the file exists:

```text
lake env lean CollatzClassical/KL2003/KL2003K2CertificateDataAxiomAudit.lean
```

Expected audit output: each listed theorem reports no axioms beyond Lean/kernel
trusted foundations used by `norm_num`; no project axioms, no `sorryAx`.

Static pre-audit command:

```text
rg -n "sorry|admit|axiom|unsafe|noncomputable|Real|log|rpow|NNReal|phi|inverse" CollatzClassical/KL2003/KL2003K2CertificateData.lean
```

## Registration gate

Do not create the Lean file until the human gate for KL2003 registration is
cleared. Current registration status remains:

```text
KL2003_REGISTRATION_STILL_DEFERRED
```

## Decision

Dry-run design is ready. The first Lean file should be data-only and
`norm_num`-only. It should not import real analysis, should not mention KL2003
semantics, and should not contain any proof of M0 or lower-bound bridge.
