# KL2003_K2_CERTIFICATE_VERIFIER_LEAN_v1

Fecha: 2026-07-07.

Estado: verificador Lean minimo creado y compilado para el certificado k=2
data-level. No se prueba KL2003, M0 ni M1.

## Clasificacion

```text
K2_CERTIFICATE_VERIFIER_LEAN_CREATED
DATA_LEVEL_VALIDITY_PROVED
BOX_CONSTRAINTS_PROVED
SLACK_POSITIVITY_AGGREGATED
L2NT_ROW_EQUATIONS_AGGREGATED
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Base

```text
CollatzClassical/KL2003/KL2003K2CertificateData.lean
CollatzClassical/KL2003/KL2003K2CertificateDataAxiomAudit.lean
docs/KL2003_K2_CERTIFICATE_DATA_LEAN_PRIVATE_DRAFT_v1.md
docs/KL2003_K2_CERTIFICATE_TO_LEAN_SPEC_BRIDGE_v1.md
docs/KL2003_K2_LAMBDA_POWER_INTERVAL_CERTIFICATION_v1.md
```

## Archivos creados

Verificador:

```text
CollatzClassical/KL2003/KL2003K2CertificateVerifier.lean
sha256 = 8d70831a5642f8f20612396ea98c160fc72682084edcdd06f7aefe1c12f3912d
```

Audit:

```text
CollatzClassical/KL2003/KL2003K2CertificateVerifierAxiomAudit.lean
sha256 = fe34d62e688d23959838f900a5a3501618b0fc95b8393cdea882f25cfdeab9d8
```

## Predicates definidos

```text
RationalInterval.Valid
LPRowSlack.Positive
K2InteriorVariables.InBox
K2InteriorCertificateData.ValidData
```

Tambien se definieron agregadores data-level:

```text
DeclaredSlacksPositive
L2NTRowEquationsHold
CoefficientIntervalsValid
```

## Teoremas probados

Intervalos:

```text
AInterval_valid
BTargetInterval_valid
BStrongInterval_valid
DTargetInterval_valid
k2_coefficient_intervals_valid
```

Box k=2:

```text
k2Vars_inBox
```

Positividad de slacks:

```text
lower_c22_row_positive
upper_c22_row_positive
lower_c25_row_positive
upper_c25_row_positive
lower_c28_row_positive
upper_c28_row_positive
L2NT_D1_row_positive
L2NT_D2_row_positive
L2NT_D3_row_positive
aux_c12_le_c22_row_positive
aux_c12_le_c25_row_positive
aux_c12_le_c28_row_positive
domain_c12_positive_row_positive
k2_declared_slacks_positive
```

Filas L2NT:

```text
k2_L2NT_row_equations_hold
```

Validez agregada:

```text
k2CertificateData_valid
```

## Guardarrailes estaticos

Comando:

```bash
rg -n "Real|log|rpow|NNReal|phi|pi_a|inverse|M0|M1|Collatz conjecture|sorry|admit|axiom|unsafe|native_decide|noncomputable" CollatzClassical/KL2003/KL2003K2CertificateVerifier.lean
```

Resultado:

```text
sin coincidencias
```

Tambien se verifico en el verificador y audit:

```bash
rg -n "sorryAx|sorry|admit|unsafe|native_decide|noncomputable" CollatzClassical/KL2003/KL2003K2CertificateVerifier.lean CollatzClassical/KL2003/KL2003K2CertificateVerifierAxiomAudit.lean
```

Resultado:

```text
sin coincidencias
```

## Build

El repo ya contiene:

```text
lakefile.lean
lean-toolchain
lake-manifest.json
```

Comando ejecutado:

```bash
lake build CollatzClassical.KL2003.KL2003K2CertificateVerifier
```

Resultado:

```text
Built CollatzClassical.KL2003.KL2003K2CertificateVerifier
Build completed successfully.
```

## Audit

Comando ejecutado:

```bash
lake env lean CollatzClassical/KL2003/KL2003K2CertificateVerifierAxiomAudit.lean
```

Resultado:

```text
Cada theorem auditado depende solo de:
[propext, Classical.choice, Quot.sound]
```

No aparecieron:

```text
sorryAx
axiomas de proyecto
admit
unsafe
```

## Limite

Este verificador solo valida datos racionales y agregados aritmeticos del
certificado k=2:

```text
intervalos validos
box de variables k=2
slacks positivos
ecuaciones racionales L2NT_D1/D2/D3
```

No contiene ni prueba:

```text
Real
log
phi
semantica de arbol inverso
teorema M0
teorema M1
puente retarded LP -> lower bound
claim global sobre Collatz
```

## Resultado

```text
K2_CERTIFICATE_VERIFIER_LEAN_CREATED = yes
DATA_LEVEL_VALIDITY_PROVED = yes
BOX_CONSTRAINTS_PROVED = yes
SLACK_POSITIVITY_AGGREGATED = yes
L2NT_ROW_EQUATIONS_AGGREGATED = yes
NO_M0_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
