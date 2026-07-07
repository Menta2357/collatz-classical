# KL2003_K2_CERTIFICATE_ENDPOINT_UNIFICATION_BLO_UPGRADE_v1

Fecha: 2026-07-08.

Estado: upgrade racional del endpoint inferior `B_lo` en el certificado k=2.
No se introduce `Real`, `rpow`, M0C, M0, M1 ni claim global.

## Clasificacion

```text
CERTIFICATE_ENDPOINTS_UNIFIED
B_LO_UPGRADED_TO_119_OVER_135
OLD_B_LO_IMPLIED_BY_NEW_B_LO
D1_SLACK_INCREASED
RATIONAL_VERIFIER_REBUILT
AXIOM_AUDIT_PASS
NO_REAL_IN_RATIONAL_VERIFIER
NO_M0C_STARTED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Archivos modificados

```text
CollatzClassical/KL2003/KL2003K2CertificateData.lean
CollatzClassical/KL2003/KL2003K2CertificateDataAxiomAudit.lean
CollatzClassical/KL2003/KL2003K2CertificateVerifier.lean
CollatzClassical/KL2003/KL2003K2CertificateVerifierAxiomAudit.lean
docs/KL2003_SCALING_SEAM_PAPER_DRAFT_v1.md
docs/KL2003_K2_CERTIFICATE_ENDPOINT_UNIFICATION_BLO_UPGRADE_v1.md
```

## Localizacion Del Endpoint Viejo

El endpoint viejo aparecia en el certificado racional como:

```text
B_lo_old = 22/25
```

Usos Lean afectados:

```text
BTargetInterval.lo
L2NTRowEquationsHold, fila D1
k2_L2NT_D1_slack_eq
```

La busqueda posterior confirma que `22/25` ya no aparece en las ecuaciones de
fila ni como endpoint activo. Solo queda en los lemas documentales:

```lean
k2_B_lower_stronger_than_old : (22 / 25 : Rat) < 119 / 135
k2_B_lower_implies_old      : (22 / 25 : Rat) <= 119 / 135
```

## Upgrade

Cambio aplicado:

```text
old_B_lo = 22/25
new_B_lo = 119/135
```

Prueba Lean racional:

```lean
theorem k2_B_lower_stronger_than_old :
    (22 / 25 : Rat) < 119 / 135 := by
  norm_num
```

Por tanto el endpoint fuerte implica el viejo:

```lean
theorem k2_B_lower_implies_old :
    (22 / 25 : Rat) <= 119 / 135 := by
  norm_num
```

Endpoints mantenidos sin cambio:

```text
BTargetInterval.hi = 89/100
BStrongInterval.hi = 8/9
DTargetInterval.lo = 119/100
DTargetInterval.hi = 6/5
lambda = 27/20
variables c22,c25,c28,c12,cmax
```

El modulo trascendental `KL2003K2TranscendentalEndpoints.lean` queda como
fuente/consumidor de los endpoints reales ya probados; no se duplico ni se
importo en el verificador racional.

## Slacks

Fila D1 vieja:

```text
(400/729)*(69/40) + (22/25)*1 - (73/40)
  = 73/48600
```

Fila D1 nueva:

```text
(400/729)*(69/40) + (119/135)*1 - (73/40)
  = 29/9720
  = 145/48600
```

Incremento:

```text
29/9720 - 73/48600
  = 1/675
```

Asi, el slack D1 pasa de:

```text
old_D1_slack = 73/48600  approx 0.001502
new_D1_slack = 29/9720   approx 0.002984
```

D2 y D3 no cambian:

```text
L2NT_D2_slack = 271/729000
L2NT_D3_slack = 2077/145800
```

## Verificacion

Comandos ejecutados:

```text
lake build CollatzClassical.KL2003.KL2003K2CertificateVerifier
lake env lean CollatzClassical/KL2003/KL2003K2CertificateVerifierAxiomAudit.lean
lake env lean CollatzClassical/KL2003/KL2003K2CertificateDataAxiomAudit.lean
```

Resultado:

```text
build passed
verifier audit passed
data audit passed
```

El audit extendido incluye:

```text
k2_B_lower_stronger_than_old
k2_B_lower_implies_old
k2_L2NT_row_equations_hold
k2CertificateData_valid
```

Dependencias de axiomas observadas:

```text
[propext, Classical.choice, Quot.sound]
```

Chequeo estatico:

```text
rg -n "Real|rpow|log|alpha|lambdaR|BReal|DReal" \
  CollatzClassical/KL2003/KL2003K2CertificateVerifier.lean \
  CollatzClassical/KL2003/KL2003K2CertificateData.lean
```

Resultado:

```text
sin coincidencias
```

## No Objetivos

```text
No se cambia M0B.
No se abre M0C.
No se ejecuta scaling seam test.
No se introduce Real/rpow en el verifier racional.
No se cambia el statement global.
No se prueba M0.
No se prueba M1.
No se reclama ningun resultado global de Collatz.
```

## Resultado

```text
CERTIFICATE_ENDPOINTS_UNIFIED = yes
B_LO_UPGRADED_TO_119_OVER_135 = yes
OLD_B_LO_IMPLIED_BY_NEW_B_LO = yes
D1_SLACK_INCREASED = yes
RATIONAL_VERIFIER_REBUILT = yes
AXIOM_AUDIT_PASS = yes
NO_REAL_IN_RATIONAL_VERIFIER = yes
NO_M0C_STARTED = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
