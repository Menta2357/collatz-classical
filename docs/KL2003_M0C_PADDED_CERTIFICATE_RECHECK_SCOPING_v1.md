# KL2003_M0C_PADDED_CERTIFICATE_RECHECK_SCOPING_v1

Fecha: 2026-07-11.

Estado: scoping aritmetico/documental para decidir si el contrato
`I2ELAbstractRowsV2` con `epsilon0 = 1/10000` conserva margen antes de ser
consumido por la induccion M0C principal. No se modifica Lean en este paso y no
se inicia la induccion principal.

## Clasificacion

```text
PADDED_CERTIFICATE_RECHECK_SCOPED
BERNOULLI_PAD_BOUND_ROUTE_DEFINED
ROW22_PADDED_SLACK_CHECKED
ROW25_NO_ADVANCED_PAD_CONFIRMED
ROW28_DEPTH_PAD_CHECKED
EPSILON0_ACCEPTED
M0C_MAIN_INDUCTION_NOT_STARTED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

No se clasifica como:

```text
EPSILON0_NEEDS_REVISION
```

## Datos Del Certificado

El verifier racional actual usa:

```text
lambda = 27/20
A = lambda^-2 = 400/729
B_lo = lambda^(alpha - 2) lower endpoint = 119/135
D_lo = lambda^(alpha - 1) lower endpoint = 119/100

c22 = 73/40
c25 = 1001/1000
c28 = 69/40
c12 = 1
```

Las tres filas racionales originales son:

```text
row22/D1:
  A*c28 + B_lo*c12 - c22 = 29/9720

row25/D2:
  A*c22 - c25 = 271/729000

row28/D3:
  A*c25 + D_lo*c12 - c28 = 2077/145800
```

## Ruta Bernoulli Para El Pad

Se quiere formalizar posteriormente:

```text
lambda^(-epsilon0) >= 9999/10000
```

con:

```text
epsilon0 = 1/10000
lambda = 27/20
```

Forma equivalente:

```text
lambda^(1/10000) <= 10000/9999
```

y, elevando a potencia `10000`, basta con:

```text
27/20 <= (10000/9999)^10000
```

La ruta evita un `norm_num` gigante usando Bernoulli:

```text
(10000/9999)^10000
  = (1 + 1/9999)^10000
 >= 1 + 10000*(1/9999)
  = 19999/9999
```

y la comparacion final es pequena:

```text
27/20 <= 19999/9999
```

El futuro lema Lean deberia separar:

```text
bernoulli_pad_power_bound :
  (27/20 : Real) <= (10000/9999 : Real) ^ (10000 : Nat)

lambda_rpow_epsilon0_le_pad_inv :
  lambdaR ^ epsilon0 <= (10000/9999 : Real)

lambda_rpow_neg_epsilon0_ge_pad :
  (9999/10000 : Real) <= lambdaR ^ (-epsilon0)
```

La unica parte trascendental/remanente es el puente monotono de `rpow`/raiz
real; la desigualdad grande se reduce por Bernoulli a aritmetica pequena.

## Factores Por Profundidad

Definimos:

```text
p := 9999/10000
```

Entonces, si `lambda^(-epsilon0) >= p`, por positividad:

```text
profundidad 1: lambda^(-epsilon0)   >= p
profundidad 2: lambda^(-2*epsilon0) >= p^2
profundidad 3: lambda^(-3*epsilon0) >= p^3
```

con:

```text
p   = 9999/10000
p^2 = 99980001/100000000
p^3 = 999700029999/1000000000000
```

## Recheck Racional De Filas

### row22/D1

`row22` consume un termino advanced/min de profundidad 1. El recheck
conservador es:

```text
A*c28 + B_lo*p - c22
  = 35179/12150000
  > 0
```

La perdida cargada por el pad es:

```text
B_lo*(1 - p) = 119/1350000
```

Como:

```text
29/9720 - 119/1350000 = 35179/12150000
```

`row22` conserva margen positivo.

### row25/D2

`row25` es single-branch en EL y no consume rama advanced. Por tanto no paga
pad advanced:

```text
A*c22 - c25
  = 271/729000
  > 0
```

Esto confirma la correccion seam-v2: la fila fina `row25/D2` no debe cargar
redondeo advanced.

### row28/D3

`row28EL` tiene terminos padded en la llamada directa y en las llamadas
auxiliares `M1V2`/`M2V2`. Para este scoping se comprueban las tres
profundidades, aunque el contrato final puede asignar un factor mas fino por
brazo:

```text
depth 1:
  A*c25 + D_lo*p - c28
    = 10298249/729000000
    > 0

depth 2:
  A*c25 + D_lo*p^2 - c28
    = 102115066751/7290000000000
    > 0

depth 3:
  A*c25 + D_lo*p^3 - c28
    = 1012477302443249/72900000000000000
    > 0
```

La comprobacion de profundidad 3 es deliberadamente conservadora. La perdida
maxima registrada aqui es:

```text
D_lo*(1 - p^3)
  = 35696430119/100000000000000
```

y queda muy por debajo del slack original:

```text
2077/145800
```

## Fila Con Menor Margen

Despues del pad, los margenes relevantes son:

```text
row22/D1 padded depth 1:
  35179/12150000

row25/D2 no pad:
  271/729000

row28/D3 padded depth 3 conservative:
  1012477302443249/72900000000000000
```

El menor margen absoluto sigue siendo:

```text
row25/D2 = 271/729000
```

pero esta fila no paga advanced pad. Entre las filas afectadas por el pad, la
menor es:

```text
row22/D1 padded depth 1 = 35179/12150000
```

## Decision

`epsilon0 = 1/10000` queda aceptado para el siguiente paso de diseno:

```text
EPSILON0_ACCEPTED
```

El recheck racional muestra margen positivo incluso con una lectura
conservadora de profundidad 3 para `row28/D3`.

## Trabajo Futuro

Antes de consumir V2 en la induccion principal, falta formalizar en Lean:

```text
lambda_rpow_neg_epsilon0_ge_pad
pad_factor_depth1
pad_factor_depth2
pad_factor_depth3
row22_padded_slack_pos
row25_unpadded_slack_pos
row28_padded_depth3_slack_pos
```

Tambien falta decidir si el modulo M0C principal reemplazara:

```text
I2ELAbstractRows
```

por:

```text
I2ELAbstractRowsV2
```

o si ambos contratos coexistiran con un adaptador explicito. Esta nota no
declara el teorema de induccion M0C, no prueba M1 y no contiene ningun claim
global de Collatz.

