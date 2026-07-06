# KL2003_K2_TRANSCENDENTAL_ENDPOINT_BRIDGE_SCOPING_v1

Fecha: 2026-07-07.

Estado: diseno del modulo 3 de la escalera KL2003 k=2. No se crea Lean en
esta tarea.

## Clasificacion

```text
TRANSCENDENTAL_ENDPOINT_BRIDGE_SCOPED
REAL_IMPORT_FRONTIER_IDENTIFIED
ALPHA_LOG_BOUNDS_TARGET_DEFINED
RPOW_ENDPOINT_TARGET_DEFINED
K2_RATIONAL_VERIFIER_CONSUMER_READY
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Base

```text
CollatzClassical/KL2003/KL2003K2CertificateData.lean
CollatzClassical/KL2003/KL2003K2CertificateVerifier.lean
docs/KL2003_K2_CERTIFICATE_VERIFIER_LEAN_v1.md
docs/KL2003_K2_LAMBDA_POWER_INTERVAL_CERTIFICATION_v1.md
outputs/KL2003_K2_LAMBDA_POWER_INTERVAL_CERTIFICATION_v1/interval_certificate.json
```

## Cantidades matematicas

Definiciones futuras:

```text
alpha = log 3 / log 2
lambda = 27/20
B = lambda^(alpha - 2)
D = lambda^(alpha - 1)
```

Identidad objetivo para `D`:

```text
D = lambda * B
```

En Lean esta identidad deberia salir de:

```text
alpha - 1 = (alpha - 2) + 1
Real.rpow_add lambda_pos (alpha - 2) 1
Real.rpow_one
```

## Ya certificado en Lean

Del modulo data-only:

```text
k2_two_pow_19_lt_three_pow_12 : 2^19 < 3^12
k2_three_pow_5_lt_two_pow_8  : 3^5 < 2^8
```

Reducciones racionales:

```text
k2_B_lower_rational_reduction :
  (119/135)^12 * (27/20)^5 <= 1

k2_B_upper_rational_reduction :
  1 <= (8/9)^5 * (27/20)^2
```

Endpoints racionales ya disponibles:

```text
BStrong = [119/135, 8/9]
DTarget = [119/100, 6/5]
```

Del verificador k=2:

```text
k2CertificateData_valid
k2_coefficient_intervals_valid
k2_declared_slacks_positive
k2_L2NT_row_equations_hold
```

El modulo trascendental debe consumir estos datos, no reabrir el LP.

## Lemas futuros: modulo A

Modulo propuesto:

```text
CollatzClassical/KL2003/KL2003K2AlphaBounds.lean
```

Imports probables:

```lean
import CollatzClassical.KL2003.KL2003K2CertificateData
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
```

Definiciones:

```lean
noncomputable def alphaR : Real := Real.log (3 : Real) / Real.log (2 : Real)
def lambdaR : Real := (27 / 20 : Rat)
```

Lemas objetivo:

```lean
theorem log_two_pos : 0 < Real.log (2 : Real)

theorem alpha_lower_bound :
    (19 / 12 : Real) < alphaR

theorem alpha_upper_bound :
    alphaR < (8 / 5 : Real)
```

Ruta para `alpha_lower_bound`:

```text
1. Convertir k2_two_pow_19_lt_three_pow_12 a Real:
     (2 : Real)^19 < (3 : Real)^12
2. Aplicar Real.log_lt_log a bases positivas.
3. Reescribir con Real.log_pow:
     19 * log 2 < 12 * log 3
4. Usar Real.log_pos para log 2 > 0.
5. Dividir por 12 * log 2.
```

Ruta para `alpha_upper_bound`:

```text
1. Convertir k2_three_pow_5_lt_two_pow_8 a Real:
     (3 : Real)^5 < (2 : Real)^8
2. Aplicar Real.log_lt_log.
3. Reescribir con Real.log_pow:
     5 * log 3 < 8 * log 2
4. Dividir por 5 * log 2.
```

Nombres mathlib v4.21.0 identificados:

```text
Real.log_lt_log
Real.log_le_log
Real.log_lt_log_iff
Real.log_le_log_iff
Real.log_pow
Real.log_pos
Real.log_mul
Real.log_div
```

Riesgo principal del modulo A:

```text
La aritmetica de division por Real.log 2 puede necesitar una normalizacion
manual con have hlog2 : 0 < Real.log (2 : Real), field_simp y linarith.
```

## Lemas futuros: modulo B

Modulo propuesto:

```text
CollatzClassical/KL2003/KL2003K2TranscendentalEndpoints.lean
```

Imports probables:

```lean
import CollatzClassical.KL2003.KL2003K2CertificateVerifier
import CollatzClassical.KL2003.KL2003K2AlphaBounds
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
```

Definiciones:

```lean
noncomputable def BReal : Real := lambdaR ^ (alphaR - 2)
noncomputable def DReal : Real := lambdaR ^ (alphaR - 1)
```

Positividad/base:

```lean
theorem lambda_pos : 0 < lambdaR
theorem lambda_gt_one : 1 < lambdaR
```

Lemas de exponentes:

```lean
theorem B_exponent_lower :
    (-(5 : Real) / 12) < alphaR - 2

theorem B_exponent_upper :
    alphaR - 2 < (-(2 : Real) / 5)
```

Estos salen de `alpha_lower_bound` y `alpha_upper_bound` por `linarith`.

Puente racional-rpow inferior:

```lean
theorem B_lower_rpow_floor :
    (119 / 135 : Real) <= lambdaR ^ (-(5 : Real) / 12)
```

Debe consumir:

```text
(119/135)^12 * (27/20)^5 <= 1
```

Una ruta posible:

```text
1. Elevar ambos lados a potencia 12 usando positividad.
2. Reescribir (lambda^(-5/12))^12 como lambda^(-5).
3. Reescribir lambda^(-5) como 1 / lambda^5.
4. Reducir a (119/135)^12 * lambda^5 <= 1.
```

Lemas mathlib candidatos:

```text
Real.rpow_le_rpow_iff
Real.rpow_mul
Real.rpow_natCast
Real.rpow_neg
Real.rpow_inv_le_iff_of_pos
```

Puente racional-rpow superior:

```lean
theorem B_upper_rpow_ceiling :
    lambdaR ^ (-(2 : Real) / 5) <= (8 / 9 : Real)
```

Debe consumir:

```text
1 <= (8/9)^5 * (27/20)^2
```

Ruta posible:

```text
1. Elevar ambos lados a potencia 5.
2. Reescribir (lambda^(-2/5))^5 como lambda^(-2).
3. Reducir a 1 <= (8/9)^5 * lambda^2.
```

Endpoints `B`:

```lean
theorem B_lower :
    (119 / 135 : Real) <= BReal

theorem B_upper :
    BReal <= (8 / 9 : Real)
```

Ruta:

```text
B_lower_rpow_floor <= lambda^(alpha - 2)
  por Real.rpow_lt_rpow_of_exponent_lt lambda_gt_one B_exponent_lower.

lambda^(alpha - 2) <= B_upper_rpow_ceiling
  por Real.rpow_le_rpow_of_exponent_le lambda_gt_one.le B_exponent_upper.le.
```

Nombres mathlib v4.21.0 identificados:

```text
Real.rpow_lt_rpow_of_exponent_lt
Real.rpow_le_rpow_of_exponent_le
Real.strictMono_rpow_of_base_gt_one
Real.rpow_le_rpow_left_iff
Real.rpow_lt_rpow_left_iff
Real.rpow_add
Real.rpow_sub
Real.rpow_mul
Real.rpow_natCast
Real.rpow_intCast
Real.rpow_inv_le_iff_of_pos
Real.le_rpow_inv_iff_of_pos
Real.rpow_inv_rpow
Real.rpow_pos_of_pos
```

Endpoints `D`:

```lean
theorem D_eq_lambda_mul_B :
    DReal = lambdaR * BReal

theorem D_lower :
    (119 / 100 : Real) <= DReal

theorem D_upper :
    DReal <= (6 / 5 : Real)
```

Ruta:

```text
D_eq_lambda_mul_B:
  lambda^(alpha - 1)
    = lambda^((alpha - 2) + 1)
    = lambda^(alpha - 2) * lambda

D_lower:
  multiplicar B_lower por lambda_pos;
  usar norm_num para lambda * (119/135) = 119/100.

D_upper:
  multiplicar B_upper por lambda_pos;
  usar norm_num para lambda * (8/9) = 6/5.
```

## Consumidor racional listo

Una vez probados:

```text
B_lower
B_upper
D_lower
D_upper
```

el verificador k=2 racional ya puede consumirlos como justificacion real de:

```text
BStrongInterval
DTargetInterval
```

sin cambiar:

```text
K2InteriorCertificateData.ValidData
k2CertificateData_valid
```

El consumidor futuro deberia ser un pequeno theorem de pegado, por ejemplo:

```lean
theorem k2_transcendental_endpoints_match_data :
    (119 / 135 : Real) <= BReal ∧
    BReal <= (8 / 9 : Real) ∧
    (119 / 100 : Real) <= DReal ∧
    DReal <= (6 / 5 : Real)
```

Este theorem sigue siendo solo endpoint bridge. No debe mencionar KL2003
semantica, M0 ni M1.

## Riesgos

Coerciones:

```text
Rat -> Real coercions around (27/20), (119/135), (8/9).
Nat powers -> Real powers when converting 2^19 < 3^12.
Real.rpow exponents are Real, while pow endpoints use Nat.
```

Nombres de theorem:

```text
Los nombres de log/rpow existen en Mathlib v4.21.0, pero algunas pruebas
pueden necesitar variantes _iff, _of_pos, o casts explicitos.
```

Normalizacion:

```text
Evitar confiar en linarith sobre expresiones con divisiones sin preparar.
Preferir:
  have hlog2 : 0 < Real.log (2 : Real)
  field_simp [hlog2.ne']
  ring_nf
  linarith
```

Rpow racional:

```text
Las reducciones con exponentes -5/12 y -2/5 son el punto mas delicado.
Puede ser mejor probar primero lemas generales pequenos:
  endpoint_le_rpow_neg_div_iff_pow_mul_le_one
  rpow_neg_div_le_endpoint_iff_one_le_pow_mul
```

Tacticas:

```text
No usar native_decide.
Mantener norm_num para endpoints racionales.
Usar ring_nf solo despues de despejar denominadores reales.
```

## No hacer en esta fase

```text
No crear prueba KL2003.
No crear prueba M0.
No crear teorema M1.
No introducir semantica del arbol inverso.
No probar lower bound.
No registrar target publico.
No usar native_decide.
No hacer claim global sobre Collatz.
```

## Decision

No se crea Lean todavia en esta tarea. El siguiente paso recomendado es:

```text
1. Crear KL2003K2AlphaBounds.lean.
2. Compilar solo alpha_lower_bound y alpha_upper_bound.
3. Crear audit de axiomas para ese modulo.
4. Solo despues crear KL2003K2TranscendentalEndpoints.lean.
```

Esta separacion evita mezclar el primer contacto con `Real.log` y la parte
mas delicada de `Real.rpow` en un unico archivo.
