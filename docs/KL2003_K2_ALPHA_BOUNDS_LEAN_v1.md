# KL2003_K2_ALPHA_BOUNDS_LEAN_v1

Fecha: 2026-07-07.

Estado: submodulo A del puente trascendental KL2003 k=2 creado y compilado.

## Clasificacion

```text
ALPHA_BOUNDS_LEAN_CREATED
ALPHA_LOWER_BOUND_PROVED
ALPHA_UPPER_BOUND_PROVED
REAL_LOG_FRONTIER_CROSSED
LOGB_DESIGN_USED
REAL_ONLY_NO_NAT_CAST_ROUTE
BRACKET_ENDPOINT_COUPLING_DOCUMENTED
NO_RPOW_ENDPOINTS_YET
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Base

```text
docs/KL2003_K2_TRANSCENDENTAL_ENDPOINT_BRIDGE_SCOPING_v1.md
CollatzClassical/KL2003/KL2003K2CertificateData.lean
CollatzClassical/KL2003/KL2003K2CertificateVerifier.lean
```

## Archivos creados

Modulo:

```text
CollatzClassical/KL2003/KL2003K2AlphaBounds.lean
sha256 = 9400f8d67bc202d2156378c55b57489c55a2d69134c4783cef3804fe3d064b2e
```

Audit:

```text
CollatzClassical/KL2003/KL2003K2AlphaBoundsAxiomAudit.lean
sha256 = ce81bc4d21a464f0ba3125e04211eed53a44e6460c9dc6f8bb8e7d4f30323982
```

## Imports

El modulo importa:

```lean
import CollatzClassical.KL2003.KL2003K2CertificateData
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Log.Base
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
```

Nota: `Real.logb` esta definido en `Mathlib.Analysis.SpecialFunctions.Log.Base`
en mathlib v4.21.0, por eso se incluye `Log.Base` ademas de `Log.Basic`.

## Definiciones

```lean
noncomputable def alpha : Real := Real.logb 2 3
def lambdaR : Real := ((27 / 20 : Rat) : Real)
```

Lemas auxiliares:

```lean
theorem log_two_pos : 0 < Real.log (2 : Real)
theorem lambdaR_pos : 0 < lambdaR
theorem lambdaR_gt_one : 1 < lambdaR
```

## Bounds probados

```lean
theorem alpha_lower_bound : (19 / 12 : Real) < alpha
theorem alpha_upper_bound : alpha < (8 / 5 : Real)
```

Las pruebas empiezan directamente en `Real`, no desde lemas `Nat` casteados.

Lower:

```lean
have key : Real.log ((2 : Real) ^ 19) < Real.log ((3 : Real) ^ 12) :=
  Real.log_lt_log (by positivity) (by norm_num)
```

Upper:

```lean
have key : Real.log ((3 : Real) ^ 5) < Real.log ((2 : Real) ^ 8) :=
  Real.log_lt_log (by positivity) (by norm_num)
```

Luego se usa:

```text
Real.log_pow
Real.log_div_log
positivity
norm_num
div_lt_iff₀ / lt_div_iff₀
```

## Acoplamiento con endpoints

El bracket probado:

```text
19/12 < alpha < 8/5
```

esta acoplado al intervalo fuerte para:

```text
B = lambda^(alpha - 2)
```

usado por el certificado k=2:

```text
BStrong = [119/135, 8/9]
```

En efecto:

```text
alpha > 19/12  =>  alpha - 2 > -5/12
alpha < 8/5    =>  alpha - 2 < -2/5
```

Junto con `lambda = 27/20 > 1`, el siguiente modulo usara monotonia de
`lambda^x` para encerrar:

```text
lambda^(-5/12) <= B <= lambda^(-2/5)
```

y las reducciones racionales ya probadas en el modulo data-only:

```text
(119/135)^12 * (27/20)^5 <= 1
1 <= (8/9)^5 * (27/20)^2
```

Esto alimenta:

```text
BStrong = [119/135, 8/9]
DTarget = [119/100, 6/5]
```

mediante:

```text
D = lambda * B.
```

## Build

Comando:

```bash
lake build CollatzClassical.KL2003.KL2003K2AlphaBounds
```

Resultado:

```text
Built CollatzClassical.KL2003.KL2003K2AlphaBounds
Build completed successfully.
```

## Audit

Comando:

```bash
lake env lean CollatzClassical/KL2003/KL2003K2AlphaBoundsAxiomAudit.lean
```

Resultado:

```text
log_two_pos       -> [propext, Classical.choice, Quot.sound]
lambdaR_pos       -> [propext, Classical.choice, Quot.sound]
lambdaR_gt_one    -> [propext, Classical.choice, Quot.sound]
alpha_lower_bound -> [propext, Classical.choice, Quot.sound]
alpha_upper_bound -> [propext, Classical.choice, Quot.sound]
```

No aparecieron:

```text
sorryAx
axiomas de proyecto
admit
unsafe
native_decide
```

## Guardarrailes

Comando:

```bash
rg -n "phi|pi_a|inverse tree|M0|M1|Collatz conjecture|sorry|admit|axiom|unsafe|native_decide" CollatzClassical/KL2003/KL2003K2AlphaBounds.lean
```

Resultado:

```text
sin coincidencias
```

## Limite

Este modulo solo cruza la frontera `Real.log`/`Real.logb` para acotar
`alpha`.

Todavia no prueba:

```text
B_lower
B_upper
D_lower
D_upper
```

porque esos son objetivos `Real.rpow` del siguiente submodulo.

Tampoco prueba:

```text
M0
M1
semantica KL2003
semantica de arbol inverso
lower bound
claim global sobre Collatz
```

## Resultado

```text
ALPHA_BOUNDS_LEAN_CREATED = yes
ALPHA_LOWER_BOUND_PROVED = yes
ALPHA_UPPER_BOUND_PROVED = yes
REAL_LOG_FRONTIER_CROSSED = yes
LOGB_DESIGN_USED = yes
REAL_ONLY_NO_NAT_CAST_ROUTE = yes
BRACKET_ENDPOINT_COUPLING_DOCUMENTED = yes
NO_RPOW_ENDPOINTS_YET = yes
NO_M0_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
