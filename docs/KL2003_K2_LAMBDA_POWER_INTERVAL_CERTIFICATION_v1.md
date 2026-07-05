# KL2003_K2_LAMBDA_POWER_INTERVAL_CERTIFICATION_v1

Fecha: 2026-07-05.

Estado: certificacion racional de intervalos para las potencias de `lambda`
usadas por el certificado interior `k=2` de KL2003/M1-surrogate. No contiene
teorema Lean, no abre prueba M0 y no registra KL2003.

## Clasificacion

```text
LAMBDA_POWER_INTERVALS_CERTIFIED
FORMAL_CERTIFICATE_SKELETON_UNBLOCKED
RATIONAL_INTERVAL_VERIFIER_BUILT
NO_M0_PROOF_CLAIMED
KL2003_REGISTRATION_STILL_DEFERRED
```

No asignadas:

```text
BLOCKED_ON_TRANSCENDENTAL_INEQUALITY_METHOD
NEEDS_EXTERNAL_INTERVAL_ARITHMETIC
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
scripts/kl2003_k2_lambda_power_interval_certification_v1.py
```

Output de intervalos:

```text
outputs/KL2003_K2_LAMBDA_POWER_INTERVAL_CERTIFICATION_v1/interval_certificate.json
```

Certificado LP actualizado:

```text
outputs/KL2003_K2_INTERIOR_RATIONAL_CERTIFICATE_v1/certificate.json
```

## Objetivo cerrado

Con:

```text
lambda = 27/20
alpha = log_2(3)
B = lambda^(alpha-2)
D = lambda^(alpha-1)
```

se certifican los intervalos requeridos:

```text
22/25 <= B <= 89/100
119/100 <= D <= 6/5
```

La certificacion usa de hecho un intervalo mas fuerte para `B`:

```text
119/135 <= B <= 8/9.
```

Como `D = lambda * B`, esto da exactamente:

```text
D in [(27/20)*(119/135), (27/20)*(8/9)]
  = [119/100, 6/5].
```

## Reduccion sin logs numericos

Se evita usar floats como evidencia final. El verificador comprueba dos cotas
racionales para `alpha` mediante desigualdades enteras:

```text
2^19 < 3^12    =>    19/12 < log_2(3)
3^5  < 2^8     =>    log_2(3) < 8/5
```

Entonces:

```text
alpha - 2 > -5/12
alpha - 2 < -2/5
```

Como `lambda > 1`, por monotonia de `lambda^x`:

```text
lambda^(alpha-2) > lambda^(-5/12)
lambda^(alpha-2) < lambda^(-2/5)
```

Las dos comparaciones restantes se reducen a potencias racionales:

```text
lambda^(-5/12) >= 119/135
  <=> (119/135)^12 * (27/20)^5 <= 1

lambda^(-2/5) <= 8/9
  <=> (8/9)^5 * (27/20)^2 >= 1
```

El script verifica exactamente:

```text
(119/135)^12 * (27/20)^5
  = 8064241715186276625588961 / 8172150939843750000000000
  <= 1

(8/9)^5 * (27/20)^2
  = 2048 / 2025
  >= 1
```

## Ledger de lemas

El JSON registra el pequeno ledger de lemas reales que una futura prueba Lean
tendra que formalizar o importar:

```text
If 2^p < 3^q, then p/q < log_2(3).
If 3^q < 2^p, then log_2(3) < p/q.
For lambda > 1, beta1 <= beta2 implies lambda^beta1 <= lambda^beta2.
For positive rationals and positive integer n, x <= y iff x^n <= y^n.
lambda^(alpha-1) = lambda * lambda^(alpha-2).
```

Esto es un skeleton/verifier racional, no una prueba Lean.

## Estado del certificado interior

Despues de actualizar `scripts/kl2003_k2_interior_rational_certificate_v1.py`
y regenerar `certificate.json`, el estado es:

```text
rational_skeleton_status = PASS_RATIONAL_SKELETON
formal_certificate_status = PASS_FORMAL_INTERVAL_SKELETON
float_evidence_detected = false
missing_coefficient_intervals = []
nonpositive_slacks = []
uncertified_transcendental_intervals = []
base_segment_placeholder_present = true
```

El bloqueo previo:

```text
BLOCKED_ON_RATIONAL_INTERVALS_FOR_LAMBDA_BETA
```

queda cerrado para este skeleton `k=2`.

## Limites

Este cierre no es un teorema M0, no prueba el puente de lower bound y no
registra KL2003. El `base_segment_placeholder` sigue siendo solo un placeholder
presente; su contenido pertenece a una fase posterior.

Tampoco se reclama ningun resultado global de Collatz.
