# KL2003_K2_INTERIOR_RATIONAL_CERTIFICATE_SCRIPT_v1

Fecha: 2026-07-05.

Estado: script/generator/verifier racional para el LP pequeno `k=2`
`L_2^NT` de KL2003/M1-surrogate. No contiene prueba Lean, no abre M0 y no
registra target.

## Clasificacion

```text
INTERIOR_RATIONAL_CERTIFICATE_FOUND
POSITIVE_RATIONAL_SLACKS_VERIFIED
FLOAT_FRONTIER_AVOIDED
TRANSCENDENTAL_INTERVAL_POLICY_PARTIAL
BLOCKED_ON_RATIONAL_INTERVALS_FOR_LAMBDA_BETA
NO_M0_PROOF_CLAIMED
KL2003_REGISTRATION_STILL_DEFERRED
```

Guardarrailes:

```text
NO_LEAN_THEOREM
NO_M0_PROOF
NO_TARGET_REGISTRATION
NO_FLOAT_ONLY_CERTIFICATE
NO_GLOBAL_COLLATZ_CLAIM
```

## Archivos

Script:

```text
scripts/kl2003_k2_interior_rational_certificate_v1.py
```

Output:

```text
outputs/KL2003_K2_INTERIOR_RATIONAL_CERTIFICATE_v1/certificate.json
```

## Sistema elegido

Se usa `L_2^NT`, por ser el primer certificado mas directo. Variables:

```text
c_2^2, c_2^5, c_2^8, c_1^2, C_2^max
```

Filas verificadas:

```text
1 <= c_2^2 <= C_2^max
1 <= c_2^5 <= C_2^max
1 <= c_2^8 <= C_2^max

c_2^2 <= A*c_2^8 + B*c_1^2
c_2^5 <= A*c_2^2
c_2^8 <= A*c_2^5 + D*c_1^2

c_1^2 <= c_2^2
c_1^2 <= c_2^5
c_1^2 <= c_2^8
0 < c_1^2
```

donde:

```text
A = lambda^(-2)
B = lambda^(alpha-2)
D = lambda^(alpha-1)
alpha = log_2(3)
```

## Eleccion racional interior

El script usa:

```text
lambda = 27/20 = 1.35
```

Esto evita el punto frontera reportado:

```text
27/20 < 1.353400093558369
```

Variables racionales:

```text
c_2^2   = 73/40
c_2^5   = 1001/1000
c_2^8   = 69/40
c_1^2   = 1
C_2^max = 2
```

Intervalos racionales usados por el skeleton:

```text
A = lambda^(-2) in [400/729, 400/729]        certificado exactamente
B = lambda^(alpha-2) in [22/25, 89/100]      placeholder no certificado
D = lambda^(alpha-1) in [119/100, 6/5]       placeholder no certificado
```

## Holguras racionales verificadas

El verificador usa extremos inferiores en el lado derecho de las filas LP. Las
holguras racionales positivas principales son:

```text
L2NT_D1 slack = 73/48600
L2NT_D2 slack = 271/729000
L2NT_D3 slack = 2077/145800
```

Tambien pasan con holgura positiva las cotas `1 <= c`, `c <= C_2^max`, las
filas auxiliares `c_1^2 <= c_2^m`, y la positividad `0 < c_1^2`.

Salida de ejecucion:

```text
rational_skeleton_status=PASS_RATIONAL_SKELETON
formal_certificate_status=BLOCKED_ON_RATIONAL_INTERVALS_FOR_LAMBDA_BETA
positive rational slacks verified for the LP skeleton
transcendental interval placeholders remain uncertified
```

## Politica de intervalos racionales

La regla inicial es:

```text
lhs + slack <= rhs_lower_endpoint
```

para variables no negativas, usando coeficientes exactos o extremos racionales
seguros. Esta regla esta preparada para reemplazar los placeholders de `B` y
`D` por intervalos certificados sin cambiar las filas LP ni las variables.

El JSON incluye:

```text
float_evidence_detected = false
missing_coefficient_intervals = []
nonpositive_slacks = []
base_segment_placeholder_present = true
uncertified_transcendental_intervals =
  [B_lambda_alpha_minus_2, D_lambda_alpha_minus_1]
```

## Fallos esperados del verificador

El script esta estructurado para fallar si:

```text
FAIL_FLOAT_ONLY
FAIL_NONPOSITIVE_SLACK
FAIL_MISSING_COEFFICIENT_INTERVAL
FAIL_MISSING_BASE_SEGMENT_PLACEHOLDER
```

En la ejecucion actual no falla el skeleton racional. El certificado formal
queda bloqueado porque los intervalos trascendentales para `B` y `D` aun no
estan auditados.

## Base segment placeholder

El JSON incluye:

```text
BaseSegmentLowerBound_phi_I2ELSystem_Y0
status = SPEC_PLACEHOLDER_PRESENT_NOT_PROVED
```

Esto satisface el requisito de presencia del placeholder, pero no afirma el
anclaje del puente M0.

## Decision

Resultado:

```text
rational LP skeleton certificate: FOUND
positive rational slacks: VERIFIED
formal M0/M1 certificate: BLOCKED_ON_RATIONAL_INTERVALS_FOR_LAMBDA_BETA
```

No se registra KL2003 todavia. No se escribe prueba M0. No se afirma ningun
resultado global de Collatz.
