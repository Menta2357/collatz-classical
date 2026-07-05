# KL2003_K2_CERTIFICATE_TO_LEAN_SPEC_BRIDGE_v1

Fecha: 2026-07-05.

Estado: puente SPEC-ready desde los certificados JSON/scripts cerrados hacia
una futura formalizacion Lean. No se crea archivo Lean, no se inicia prueba M0
y no se registra KL2003.

## Clasificacion

```text
LEAN_READY_CERTIFICATE_SCHEMA_SCOPED
INTEGER_WITNESSES_NORM_NUM_READY
ROW_SLACKS_NORM_NUM_READY
TRANSCENDENTAL_LEMMAS_SPEC_ONLY
BASE_SEGMENT_STILL_SPEC
M0_PROOF_NOT_STARTED
KL2003_REGISTRATION_STILL_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_LEAN_FILE_YET
NO_M0_PROOF
NO_TARGET_REGISTRATION
NO_FLOAT_EVIDENCE
NO_GLOBAL_COLLATZ_CLAIM
```

## Inputs cerrados

Certificados de entrada:

```text
outputs/KL2003_K2_LAMBDA_POWER_INTERVAL_CERTIFICATION_v1/interval_certificate.json
outputs/KL2003_K2_INTERIOR_RATIONAL_CERTIFICATE_v1/certificate.json
```

Estados actuales:

```text
PASS_RATIONAL_INTERVAL_VERIFIER
PASS_RATIONAL_SKELETON
PASS_FORMAL_INTERVAL_SKELETON
```

Scripts fuente:

```text
scripts/kl2003_k2_lambda_power_interval_certification_v1.py
scripts/kl2003_k2_interior_rational_certificate_v1.py
```

## Proximo modulo Lean propuesto

Nombre recomendado:

```text
KL2003K2CertificateData.lean
```

Ubicacion futura sugerida, aun no creada:

```text
CollatzClassical/KL2003/KL2003K2CertificateData.lean
```

Alcance del primer modulo:

- datos racionales cerrados;
- testigos enteros;
- filas LP y holguras;
- intervalos racionales de coeficientes;
- placeholder visible para `BaseSegmentLowerBound`;
- sin puente retarded LP -> lower bound;
- sin teorema M0;
- sin registro de target.

## Formato Lean-ready del certificado

Pseudofirmas SPEC, no archivo Lean:

```text
structure RationalInterval where
  lo : Rat
  hi : Rat
  lo_le_hi : lo <= hi

structure IntegerPowerWitness where
  lhsBase : Nat
  lhsExp : Nat
  rhsBase : Nat
  rhsExp : Nat
  relation : Relation
  conclusionTag : String

structure RationalPowerReduction where
  name : String
  lhs : Rat
  rhs : Rat
  relation : Relation
  margin : Rat

structure LPRowSlack where
  rowName : String
  lhsDesc : String
  rhsDesc : String
  slack : Rat
  slack_pos : 0 < slack

structure K2InteriorVariables where
  c22 : Rat
  c25 : Rat
  c28 : Rat
  c12 : Rat
  cmax : Rat

structure K2InteriorCertificate where
  lambda : Rat
  A : RationalInterval
  B : RationalInterval
  D : RationalInterval
  vars : K2InteriorVariables
  rowSlacks : List LPRowSlack
  baseSegment : BaseSegmentLowerBoundPlaceholder

structure BaseSegmentLowerBoundPlaceholder where
  name : String
  status : String
```

`Relation` can be a small inductive with constructors `lt`, `le`, `ge`.
All values above are data or local arithmetic facts, not semantic KL2003
proofs.

## JSON field mapping

### interval_certificate.json

| JSON path | Future Lean structure | Meaning |
|---|---|---|
| `schema` | module doc/version constant | Certificate schema id. |
| `lambda` | `K2InteriorCertificate.lambda` | `27/20`. |
| `alpha_bounds.lower` | `IntegerPowerWitness` | `2^19 < 3^12`, hence `19/12 < log_2 3`. |
| `alpha_bounds.upper` | `IntegerPowerWitness` | `3^5 < 2^8`, hence `log_2 3 < 8/5`. |
| `checks[*]` integer checks | `IntegerPowerWitness` | Norm-num-ready integer inequalities. |
| `checks[*]` rational checks | `RationalPowerReduction` | Norm-num-ready rational reductions. |
| `power_intervals.B_lambda_alpha_minus_2.certified_stronger_interval` | `RationalInterval` | Strong interval `[119/135, 8/9]` for `B`. |
| `power_intervals.B_lambda_alpha_minus_2.target_interval` | `RationalInterval` | Target interval `[22/25, 89/100]` used by LP verifier. |
| `power_intervals.D_lambda_alpha_minus_1.derived_interval_from_lambda_times_B` | `RationalInterval` | Derived interval `[119/100, 6/5]` for `D`. |
| `lemma_ledger` | SPEC lemma declarations | Real-power/log lemmas still not proved here. |
| `float_evidence_detected` | audit assertion | Must be `false`. |
| `verifier_status` | audit status | Must be `PASS_RATIONAL_INTERVAL_VERIFIER`. |

### certificate.json

| JSON path | Future Lean structure | Meaning |
|---|---|---|
| `lambda.value` | `K2InteriorCertificate.lambda` | `27/20`. |
| `coefficient_intervals.A_lambda_minus_2` | `RationalInterval` | Exact `[400/729, 400/729]`. |
| `coefficient_intervals.B_lambda_alpha_minus_2` | `RationalInterval` | Target `[22/25, 89/100]`, justified by interval certificate. |
| `coefficient_intervals.D_lambda_alpha_minus_1` | `RationalInterval` | Target `[119/100, 6/5]`, justified by interval certificate. |
| `variables.c_2_2` | `K2InteriorVariables.c22` | `73/40`. |
| `variables.c_2_5` | `K2InteriorVariables.c25` | `1001/1000`. |
| `variables.c_2_8` | `K2InteriorVariables.c28` | `69/40`. |
| `variables.c_1_2` | `K2InteriorVariables.c12` | `1`. |
| `variables.C_2_max` | `K2InteriorVariables.cmax` | `2`. |
| `rows[*]` | `LPRowSlack` | Row name, description, rational slack, positivity proof. |
| `base_segment_placeholder` | `BaseSegmentLowerBoundPlaceholder` | Present but not proved. |
| `verifier_report.float_evidence_detected` | audit assertion | Must be `false`. |
| `verifier_report.missing_coefficient_intervals` | audit assertion | Must be empty. |
| `verifier_report.nonpositive_slacks` | audit assertion | Must be empty. |
| `verifier_report.uncertified_transcendental_intervals` | audit assertion | Must be empty. |
| `formal_certificate_status` | audit status | Must be `PASS_FORMAL_INTERVAL_SKELETON`. |

## Constants to transcribe

Rational constants:

```text
lambda = 27/20

A = lambda^(-2) = 400/729
B target interval = [22/25, 89/100]
B strong interval = [119/135, 8/9]
D target interval = [119/100, 6/5]

c_2^2 = 73/40
c_2^5 = 1001/1000
c_2^8 = 69/40
c_1^2 = 1
C_2^max = 2
```

Integer witnesses:

```text
2^19 = 524288 < 531441 = 3^12
3^5 = 243 < 256 = 2^8
27^7 = 10460353203 > 10240000000 = 8 * 20^7
```

The last witness gives the future arithmetic proof of:

```text
gamma = log_2(27/20) > 3/7
```

provided the future real-log lemma
`log_2(lambda) > p/q <-> lambda^q > 2^p` for `lambda > 1` is available.

## Norm-num-ready obligations

These should be direct arithmetic obligations in the future Lean file.

Integer power witnesses:

```text
2^19 < 3^12
3^5 < 2^8
27^7 > 8 * 20^7
```

Rational power reductions:

```text
(119/135)^12 * (27/20)^5 <= 1
(8/9)^5 * (27/20)^2 >= 1
```

Endpoint implications:

```text
119/135 >= 22/25
8/9 <= 89/100
(27/20) * (119/135) = 119/100
(27/20) * (8/9) = 6/5
```

Row slack positivity:

```text
lower_c_2_2              slack = 33/40
upper_c_2_2              slack = 7/40
lower_c_2_5              slack = 1/1000
upper_c_2_5              slack = 999/1000
lower_c_2_8              slack = 29/40
upper_c_2_8              slack = 11/40
L2NT_D1                  slack = 73/48600
L2NT_D2                  slack = 271/729000
L2NT_D3                  slack = 2077/145800
aux_c_1_2_le_c_2_2       slack = 33/40
aux_c_1_2_le_c_2_5       slack = 1/1000
aux_c_1_2_le_c_2_8       slack = 29/40
domain_c_1_2_positive    slack = 1
```

These are data-level facts. They do not prove that KL2003's `phi` satisfies
the inequalities, nor the retarded-LP theorem.

## SPEC-only obligations

The following should remain outside the first data module, or appear only as
named assumptions/SPEC declarations:

```text
monotonicity of x |-> lambda^x for lambda > 1
log bracket lemmas connecting 2^p < 3^q with p/q < log_2(3)
real-power rational exponent reductions
lambda^(alpha-1) = lambda * lambda^(alpha-2)
gamma = log_2(lambda) bridge and gamma > 3/7 real-log bridge
retarded LP certificate -> lower bound theorem
positive monotone solution semantics for KL2003 phi
base segment lower bound
```

The first future Lean pass may include theorem names for these, but should not
claim them proved unless they are actually formalized and audited.

## Base segment placeholder

The JSON field:

```text
base_segment_placeholder.name =
  BaseSegmentLowerBound_phi_I2ELSystem_Y0
```

maps to:

```text
BaseSegmentLowerBoundPlaceholder
```

Status remains:

```text
BASE_SEGMENT_STILL_SPEC
```

No base segment theorem is proved in this phase.

## Proposed file contents order

Future `KL2003K2CertificateData.lean` should be data-first:

1. Imports limited to rational/integer arithmetic needed for constants.
2. Definitions of small structures, or imports from a later shared certificate
   module if such a module already exists.
3. `lambdaQ : Rat := 27/20`.
4. Coefficient intervals `AInterval`, `BInterval`, `DInterval`.
5. K2 variable record.
6. Integer witnesses.
7. Rational reduction witnesses.
8. LP row slack list.
9. Base segment placeholder constant.
10. Audit status constants as comments or data, not theorem claims.

Do not include:

```text
theorem feasible_retarded_LP_certificate_to_lower_bound
theorem M1_surrogate_lower_bound
registration metadata for KL2003
global Collatz statements
```

## Decision

The certificate is Lean-ready at the data/schema level. The immediate next
safe step, after review, is to create a data-only Lean module with arithmetic
checks suitable for `norm_num`.

M0 proof remains not started. KL2003 registration remains deferred. No global
Collatz claim is made.
