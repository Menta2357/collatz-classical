# KL2003_K2_CERTIFICATE_DATA_LEAN_PRIVATE_DRAFT_v1

Fecha: 2026-07-06.

Estado: borrador Lean privado data-only creado. No se registra CC Challenge y
no se declara formalizacion publica. Scaffolding Lake minimo creado y build
dirigido ejecutado.

## Clasificacion

```text
PRIVATE_WORK_MODE_SELECTED
DATA_ONLY_LEAN_PRIVATE_DRAFT_CREATED
LEAN_PROJECT_SCAFFOLDING_CREATED
DATA_ONLY_LEAN_BUILD_PASS
DATA_ONLY_LEAN_AXIOM_AUDIT_PASS
NO_CC_CHALLENGE_REGISTRATION
NO_PUBLIC_FORMALISATION_CLAIM
NO_M0_PROOF
NO_GLOBAL_COLLATZ_CLAIM
```

## Base

```text
docs/KL2003_K2_DATA_LEAN_DRY_RUN_DESIGN_v1.md
docs/KL2003_K2_CERTIFICATE_TO_LEAN_SPEC_BRIDGE_v1.md
docs/KL2003_K2_LAMBDA_POWER_INTERVAL_CERTIFICATION_v1.md
docs/KL2003_REGISTRATION_DECISION_HOLD_OR_EXECUTE_v1.md
```

Esta tarea selecciona trabajo privado:

```text
No registrar CC Challenge.
No hacer claim publico.
Crear solo el primer modulo Lean data-only.
```

## Archivos creados

Modulo data-only:

```text
CollatzClassical/KL2003/KL2003K2CertificateData.lean
sha256 = ed4f95a289a7a7aebe8de0b312e5299d5367c6afb300924a1a7c55c614056621
```

Audit:

```text
CollatzClassical/KL2003/KL2003K2CertificateDataAxiomAudit.lean
sha256 = 6527d1ea403481e2391613c449cd19bf04142ce2292da48cd7e11e40f441165c
```

Scaffolding Lean/Lake:

```text
lean-toolchain
sha256 = d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c

lakefile.lean
sha256 = e31ac41ac108fbd7e30db1bc982a065949d359146e110ee04212378645e54fca

lake-manifest.json
sha256 = 230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
```

Nota tecnica:
- el diseno inicial proponia `Mathlib.Data.Rat.Basic`;
- en Mathlib `v4.21.0`, el import disponible usado para el build es
  `Mathlib.Data.Rat.Defs`.

## Contenido del modulo data-only

El modulo contiene solo:

```text
RationalInterval
LPRowSlack
K2InteriorVariables
BaseSegmentPlaceholder
K2InteriorCertificateData
lambdaQ = 27/20
intervalos racionales A, B target, B strong, D target
variables racionales k=2
slacks racionales
facts enteros cerrados por norm_num
facts racionales cerrados por norm_num
positividad de slacks cerrada por norm_num
reconstruccion racional de filas L2NT_D1/D2/D3
```

Facts principales incluidos:

```text
2^19 < 3^12
3^5 < 2^8
8 * 20^7 < 27^7
(119/135)^12 * (27/20)^5 <= 1
1 <= (8/9)^5 * (27/20)^2
119/135 >= 22/25
8/9 <= 89/100
(27/20) * (119/135) = 119/100
(27/20) * (8/9) = 6/5
```

Slacks incluidos:

```text
lower_c22 = 33/40
upper_c22 = 7/40
lower_c25 = 1/1000
upper_c25 = 999/1000
lower_c28 = 29/40
upper_c28 = 11/40
L2NT_D1 = 73/48600
L2NT_D2 = 271/729000
L2NT_D3 = 2077/145800
aux_c12_le_c22 = 33/40
aux_c12_le_c25 = 1/1000
aux_c12_le_c28 = 29/40
domain_c12_positive = 1
```

## Guardarrailes estaticos

Comando ejecutado:

```bash
rg -n "Real|log|rpow|NNReal|phi|pi_a|inverse|M0|M1|Collatz conjecture|sorry|admit|axiom|unsafe|native_decide|noncomputable" CollatzClassical/KL2003/KL2003K2CertificateData.lean
```

Resultado:

```text
sin coincidencias
```

Por inspeccion y grep, el modulo data-only no contiene:

```text
Real
log
phi
semantica de arbol inverso
M0 theorem
sorry/admit/axiom/unsafe
native_decide
claim KL2003
claim global
```

## Audit creado

El archivo:

```text
CollatzClassical/KL2003/KL2003K2CertificateDataAxiomAudit.lean
```

importa el modulo data-only y lista comandos:

```text
#print axioms ...
```

para los facts enteros/racionales y las positividades de slack.

## Build

Scaffolding creado:

```text
lean-toolchain = leanprover/lean4:v4.21.0
lakefile.lean imports Mathlib v4.21.0
lake-manifest.json creado por lake update
```

Primera ejecucion:

```text
lake update
```

Resultado:
- primer intento fallo por red/sandbox al clonar Mathlib;
- segundo intento con red permitida fallo en post-hook por locale de `tar`;
- tercer intento con `LC_ALL=C` completo correctamente y descargo cache de Mathlib.

Build dirigido:

```bash
env LC_ALL=C lake build CollatzClassical.KL2003.KL2003K2CertificateData
```

Resultado:

```text
✔ [703/703] Built CollatzClassical.KL2003.KL2003K2CertificateData
Build completed successfully.
```

Audit:

```bash
env LC_ALL=C lake env lean CollatzClassical/KL2003/KL2003K2CertificateDataAxiomAudit.lean
```

Resultado:

```text
PASS
```

Todos los facts listados en el audit dependen de:

```text
[propext, Classical.choice, Quot.sound]
```

No aparecen en el audit:

```text
Lean.ofReduceBool
Lean.trustCompiler
```

## Lo que no se hizo

```text
No se ejecuto POST a CC Challenge.
No se registro KrasikovLagarias2003.
No se creo formalisation publica.
No se creo prueba M0.
No se creo puente retarded LP -> lower bound.
No se hizo claim global sobre Collatz.
```

## Resultado

```text
PRIVATE_WORK_MODE_SELECTED = yes
DATA_ONLY_LEAN_PRIVATE_DRAFT_CREATED = yes
LEAN_PROJECT_SCAFFOLDING_CREATED = yes
DATA_ONLY_LEAN_BUILD_PASS = yes
DATA_ONLY_LEAN_AXIOM_AUDIT_PASS = yes
NO_CC_CHALLENGE_REGISTRATION = yes
NO_PUBLIC_FORMALISATION_CLAIM = yes
NO_M0_PROOF = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
