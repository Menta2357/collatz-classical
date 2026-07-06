# KL2003_K2_TRANSCENDENTAL_ENDPOINTS_LEAN_v1

Fecha: 2026-07-07.

Estado: submodulo B del puente trascendental KL2003 k=2 creado, compilado y auditado.

## Clasificacion

```text
TRANSCENDENTAL_ENDPOINTS_LEAN_CREATED
D_ENDPOINTS_PROVED_BY_RPOW
B_ENDPOINTS_DERIVED_BY_FACTORISATION
B_EQUALS_D_DIV_LAMBDA_USED
RPOW_FRONTIER_CROSSED
K2_RATIONAL_VERIFIER_CAN_CONSUME_ENDPOINTS
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Base

```text
CollatzClassical/KL2003/KL2003K2CertificateData.lean
CollatzClassical/KL2003/KL2003K2CertificateVerifier.lean
CollatzClassical/KL2003/KL2003K2AlphaBounds.lean
docs/KL2003_K2_TRANSCENDENTAL_ENDPOINT_BRIDGE_SCOPING_v1.md
```

## Archivos creados

Modulo:

```text
CollatzClassical/KL2003/KL2003K2TranscendentalEndpoints.lean
sha256 = ef512fad3d044f3b4337e7c90e00d23c9168f20e8e46beb5e56aa3afb754bc7b
```

Audit:

```text
CollatzClassical/KL2003/KL2003K2TranscendentalEndpointsAxiomAudit.lean
sha256 = 8a795ba69f8706402d9d47e3611b20ff121466cf9696751e741355f1a8c3a18f
```

## Definiciones

```lean
noncomputable def BReal : Real := lambdaR ^ (alpha - 2)
noncomputable def DReal : Real := lambdaR ^ (alpha - 1)
```

## Teoremas probados

Endpoints de `D`:

```lean
theorem D_lower_endpoint :
    (119 / 100 : Real) <= lambdaR ^ ((7 / 12 : Real))

theorem D_upper_endpoint :
    lambdaR ^ ((3 / 5 : Real)) <= (6 / 5 : Real)

theorem DReal_lower : (119 / 100 : Real) <= DReal

theorem DReal_upper : DReal <= (6 / 5 : Real)
```

Factorizacion usada para `B`:

```lean
theorem BReal_eq_DReal_div_lambda : BReal = DReal / lambdaR
```

Endpoints de `B`:

```lean
theorem BReal_lower : (119 / 135 : Real) <= BReal

theorem BReal_upper : BReal <= (8 / 9 : Real)
```

Paquetes finales:

```lean
theorem BReal_within_strong_interval :
    (119 / 135 : Real) <= BReal /\ BReal <= (8 / 9 : Real)

theorem DReal_within_target_interval :
    (119 / 100 : Real) <= DReal /\ DReal <= (6 / 5 : Real)
```

## Diseno matematico

El modulo evita manejar exponentes negativos directamente.

Primero prueba los endpoints de:

```text
D = lambda^(alpha - 1)
```

usando:

```text
19/12 < alpha < 8/5
```

por tanto:

```text
7/12 < alpha - 1 < 3/5
```

y monotonicidad de `Real.rpow` para base `lambda = 27/20 > 1`.

Despues deriva los endpoints de:

```text
B = lambda^(alpha - 2)
```

mediante la identidad:

```text
B = D / lambda
```

Esta factorizacion explica las constantes:

```text
119/135 = (119/100) / (27/20)
8/9     = (6/5)     / (27/20)
```

Asi el modulo necesita dos pruebas `rpow` reales y dos pasos algebraicos.

## Build

Comando:

```bash
env LC_ALL=C lake build CollatzClassical.KL2003.KL2003K2TranscendentalEndpoints
```

Resultado:

```text
Build completed successfully.
```

## Audit

Comando:

```bash
env LC_ALL=C lake env lean CollatzClassical/KL2003/KL2003K2TranscendentalEndpointsAxiomAudit.lean
```

Resultado:

```text
D_lower_endpoint              -> [propext, Classical.choice, Quot.sound]
D_upper_endpoint              -> [propext, Classical.choice, Quot.sound]
DReal_lower                   -> [propext, Classical.choice, Quot.sound]
DReal_upper                   -> [propext, Classical.choice, Quot.sound]
BReal_eq_DReal_div_lambda     -> [propext, Classical.choice, Quot.sound]
BReal_lower                   -> [propext, Classical.choice, Quot.sound]
BReal_upper                   -> [propext, Classical.choice, Quot.sound]
BReal_within_strong_interval  -> [propext, Classical.choice, Quot.sound]
DReal_within_target_interval  -> [propext, Classical.choice, Quot.sound]
```

No aparecieron:

```text
sorryAx
axiomas de proyecto
Lean.trustCompiler
native_decide
unsafe
```

## Limite

Este modulo cierra la identificacion trascendental de los endpoints `B` y `D`
del certificado k=2.

Todavia no prueba:

```text
M0
M1
semantica KL2003
semantica del arbol inverso
base segment lower bound
lower bound theorem
claim global sobre Collatz
```

## Resultado

```text
TRANSCENDENTAL_ENDPOINTS_LEAN_CREATED = yes
D_ENDPOINTS_PROVED_BY_RPOW = yes
B_ENDPOINTS_DERIVED_BY_FACTORISATION = yes
B_EQUALS_D_DIV_LAMBDA_USED = yes
RPOW_FRONTIER_CROSSED = yes
K2_RATIONAL_VERIFIER_CAN_CONSUME_ENDPOINTS = yes
NO_M0_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
