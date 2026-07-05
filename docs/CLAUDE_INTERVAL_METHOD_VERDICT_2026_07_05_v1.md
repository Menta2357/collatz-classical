# CLAUDE_INTERVAL_METHOD_VERDICT_2026_07_05_v1

Fecha: 2026-07-05.

Base:

- `docs/KL2003_K2_INTERIOR_RATIONAL_CERTIFICATE_SCRIPT_v1.md`
- `scripts/kl2003_k2_interior_rational_certificate_v1.py`
- `outputs/KL2003_K2_INTERIOR_RATIONAL_CERTIFICATE_v1/certificate.json`
- revision externa de Claude Fable.

## Veredicto

```text
HILO_A_NEXT_GO                 = FIRMADO
HILO_B_NEXT_GO                 = FIRMADO
REGISTRO_KL2003                = DIFERIDO_HASTA_INTERVAL_CERTIFICATE
GAPS_BLOQUEANTES               = ninguno
```

## Metodo recomendado para intervalos `lambda^beta`

Parametros:

```text
lambda = 27/20
alpha  = log_2(3)
```

La certificacion debe evitar floats y `Real.log` en el verificador. La ruta
recomendada usa solo desigualdades enteras:

1. Acotar `alpha` por racionales mediante convergentes:

```text
19/12 < alpha     <=> 2^19 < 3^12
alpha < 65/41     <=> 3^41 < 2^65
```

2. Usar monotonia de `t |-> lambda^t`, porque `lambda > 1`.

3. Reducir comparaciones racionales-potencia a enteros:

```text
(27/20)^(p/q) >= n/d
  <=> 27^p * d^q >= n^q * 20^p
```

con variantes `<=` analogas.

## Intervalos recomendados

Claude verifico intervalos mas estrechos que los placeholders iniciales:

```text
B = lambda^(alpha - 2) in [882/1000, 884/1000]
D = lambda^(alpha - 1) in [1191/1000, 1193/1000]
A = lambda^(-2) = 400/729 exacto
```

El siguiente script debe guardar los testigos enteros de cada comparacion en
el JSON, de forma que el ledger sea consumible por una futura verificacion
Lean fila a fila.

## Claim M1 adicional

El exponente asociado a `lambda = 27/20` satisface:

```text
gamma = log_2(27/20) > 3/7
```

por la comparacion entera:

```text
(27/20)^7 > 2^3
<=> 27^7 > 8 * 20^7
<=> 10460353203 > 10240000000
```

Este claim debe agregarse al SPEC como objetivo final M1-surrogate, sin
presentarlo todavia como teorema Lean.

## Acciones autorizadas

### Hilo A

Continuar con `ELIAHOU1993_L_VS_CARDOMEGA_BRIDGE_AUDIT_v1`.

Foco:

```text
paper cycle Omega -> exists c : CollatzCycle (Card Omega)
hk : 0 < c.numOdd derivable?
```

### Hilo B

Continuar con `KL2003_K2_LAMBDA_POWER_INTERVAL_CERTIFICATION_v1`.

Requisitos:

```text
- implementar bracket racional de alpha;
- certificar B y D con testigos enteros;
- actualizar certificate.json para pasar de placeholders a intervalos certificados;
- mantener NO_M0_PROOF y NO_LEAN_THEOREM.
```

## Clasificacion

```text
INTEGER_POWER_INTERVAL_METHOD_IDENTIFIED
LAMBDA_POWER_INTERVAL_CERTIFICATION_ROUTE_OPEN
M1_GAMMA_GT_THREE_SEVENTHS_INTEGER_WITNESS_IDENTIFIED
REGISTER_KL2003_AFTER_INTERVAL_CERTIFICATE
NO_M0_PROOF_CLAIMED
NO_GLOBAL_COLLATZ_CLAIM
```
