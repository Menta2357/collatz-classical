# KL2003_M0C_ROWS_V2_EPSILON_PAD_SCOPING_v1

Fecha: 2026-07-11.

Estado: scoping documental para revisar el contrato de filas abstractas M0C
antes de intentar la induccion principal. No se modifica Lean, no se prueba la
induccion M0C y no se reabre el ledger de redondeos.

## Clasificacion

```text
M0C_ROWS_EXACT_SHIFT_CONTRACT_REVIEWED
EPSILON_PAD_ROWS_V2_SCOPED
ROUNDING_LOSS_MOVED_INTO_ROW_CONTRACT
RETARDED_RANK_DESCENT_STILL_PLAUSIBLE
CERTIFICATE_SLACK_RECHECK_REQUIRED
M0C_MAIN_INDUCTION_NOT_STARTED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_MAIN_INDUCTION_THIS_PASS
NO_M1_THEOREM
NO_GLOBAL_COLLATZ
NO_COLLATZ_CLOSURE
NO_ALMOST_ALL
```

## Problema Revisado

El contrato Lean actual de M0C contiene filas abstractas con shifts exactos:

```text
y + alpha - 2
y + alpha - 3
y + 2*alpha - 5
y + 3*alpha - 5
```

Estas son las posiciones continuas ideales del sistema EL. El seam Nat,
sin embargo, usa ventanas con `floor`/`ceil`, por ejemplo:

```text
xAdv := x - ceil(x/(2*a))
```

La ventana Nat advanced queda por debajo de la frontera real ideal. Por
monotonicidad esperada de `phi`, si una ventana es ligeramente menor no debe
descargarse contra `phi(y + shift)` sino contra un argumento un poco mas
pequeno:

```text
phi(y + shift - epsilon)
```

Por tanto, el redondeo debe vivir en el contrato de fila que consume M0C, no
en un adapter opaco seam -> V1.

## Constante Propuesta

Definicion documental:

```text
epsilon0 := 1 / 10000
```

En Lean futuro:

```lean
def epsilon0 : Real := (1 / 10000 : Real)
```

El valor es deliberadamente pequeno. Su funcion no es pagar toda la perdida
del ledger global, sino representar un margen uniforme en los argumentos
advanced/min que el seam pueda descargar formalmente.

## I2ELAbstractRowsV2

Se propone una segunda estructura, no destructiva al inicio:

```lean
structure I2ELAbstractRowsV2 (Phi : K2PhiSystem) : Prop where
  row22 :
    forall y, 14 <= y ->
      Phi.phi28 (y - 2)
        + min3
            (Phi.phi22 (y + alpha - 2 - epsilon0))
            (Phi.phi25 (y + alpha - 2 - epsilon0))
            (Phi.phi28 (y + alpha - 2 - epsilon0))
        <= Phi.phi22 y

  row25 :
    forall y, 14 <= y ->
      Phi.phi22 (y - 2) <= Phi.phi25 y

  row28EL :
    forall y, 14 <= y ->
      Phi.phi25 (y - 2)
        + min
            (Phi.phi28 (y + alpha - 3 - epsilon0) + M1V2 Phi y)
            (Phi.phi22 (y + alpha - 3 - epsilon0))
        <= Phi.phi28 y
```

con:

```lean
def M2V2 (Phi : K2PhiSystem) (y : Real) : Real :=
  min3
    (Phi.phi22 (y + 3 * alpha - 5 - epsilon0))
    (Phi.phi25 (y + 3 * alpha - 5 - epsilon0))
    (Phi.phi28 (y + 3 * alpha - 5 - epsilon0))

def M1V2 (Phi : K2PhiSystem) (y : Real) : Real :=
  min
    (Phi.phi28 (y + 2 * alpha - 5 - epsilon0) + M2V2 Phi y)
    (Phi.phi22 (y + 2 * alpha - 5 - epsilon0))
```

Nota: esta version usa un unico pad `epsilon0` por llamada abstracta afectada.
Si el seam formal muestra perdidas acumuladas por profundidad EL, la variante
segura seria sustituir algunos pads por `j * epsilon0` para `j <= profundidad
EL`. Esa posibilidad debe decidirse en el recheck de certificado/seam, no en
la induccion principal.

## Fila Por Fila

### row22

Termino retardado exacto:

```text
Phi.phi28(y - 2)
```

No recibe pad, porque la rama retardada usa `xRet := x` y no pierde ventana
en el cociente y/raiz.

Termino advanced/min:

```text
min3(Phi.phi22, Phi.phi25, Phi.phi28)(y + alpha - 2)
```

pasa a:

```text
min3(...)(y + alpha - 2 - epsilon0)
```

Motivo: la rama advanced se descarga desde una ventana Nat inferior a la
frontera real continua.

### row25

Termino retardado exacto:

```text
Phi.phi22(y - 2)
```

No recibe pad. Row25/D2 es single-branch en EL y no consume rama advanced.
Esto preserva la correccion seam-v2:

```text
row25 no paga redondeo advanced
D2_slack = 271/729000 no se usa para advanced rounding
```

La fila se restringe a `14 <= y` para encajar con el segmento inductivo M0C,
pero su shift sigue exacto.

### row28EL

Termino retardado exacto:

```text
Phi.phi25(y - 2)
```

No recibe pad.

Terminos advanced/min de EL:

```text
Phi.phi28(y + alpha - 3)
Phi.phi22(y + alpha - 3)
M1(Phi,y)
```

reciben pad en las llamadas advanced/min:

```text
Phi.phi28(y + alpha - 3 - epsilon0)
Phi.phi22(y + alpha - 3 - epsilon0)
M1V2(Phi,y)
```

Dentro de `M1V2`:

```text
y + 2*alpha - 5
```

pasa a:

```text
y + 2*alpha - 5 - epsilon0
```

Dentro de `M2V2`:

```text
y + 3*alpha - 5
```

pasa a:

```text
y + 3*alpha - 5 - epsilon0
```

Motivo: estas llamadas provienen de la eliminacion EL de ramas advanced/min y
deben quedar por debajo de la ventana real ideal para ser descargables desde
ventanas Nat conservadoras.

## Descenso De Rank

M0C ya probo en Lean que los shifts exactos satisfacen:

```text
-2 <= -deltaM0C
alpha - 2 <= -deltaM0C
alpha - 3 <= -deltaM0C
2*alpha - 5 <= -deltaM0C
3*alpha - 5 = -deltaM0C
```

Para cualquier shift exacto `s` con:

```text
s <= -deltaM0C
```

el shift padded cumple trivialmente:

```text
s - epsilon0 <= s <= -deltaM0C
```

porque:

```text
0 < epsilon0.
```

Luego los lemas `retardedRank_drop` no se rompen; de hecho tienen mas margen.

Tambien se preserva la no negatividad de argumentos en la region inductiva
`14 <= y`: el peor shift sigue siendo `-2`, y los shifts padded advanced/min
son mayores que `-2` por amplio margen. En particular, `14 + shift - epsilon0`
queda dentro del segmento no negativo.

## Coste Aritmetico Del Pad

Si el lower bound inductivo tiene forma:

```text
Delta * c * lambdaR^(y + shift)
```

al usar:

```text
y + shift - epsilon0
```

la contribucion baja por un factor:

```text
lambdaR^(-epsilon0)
```

Equivalente: el coste multiplicativo relativo es:

```text
lambdaR^epsilon0 - 1
```

Con:

```text
lambdaR = 27/20 = 1.35
epsilon0 = 1/10000
```

estimacion:

```text
log(lambdaR) ~= 0.3001046
lambdaR^epsilon0 - 1 ~= 0.00003001
```

### Comparacion Con Slacks

Slacks definitivos:

```text
D1 = 29/9720      ~= 0.00298354
D2 = 271/729000   ~= 0.00037174
D3 = 2077/145800  ~= 0.01424554
```

Row22/D1:

El termino advanced con coeficiente aproximado `B_lo = 119/135` perderia,
en primera aproximacion:

```text
(119/135) * (1 - lambdaR^(-epsilon0))
  ~= 0.0000265
```

Esto es mucho menor que `D1 ~= 0.00298`.

Row25/D2:

No consume rama advanced. El shift retardado `y - 2` queda exacto. Por tanto
el pad no debe cargar contra `D2`. El slack fino `271/729000` sigue siendo una
alerta general, pero no una amenaza directa por este pad.

Row28/D3:

El termino advanced principal con coeficiente aproximado `D_lo = 119/100`
perderia:

```text
(119/100) * (1 - lambdaR^(-epsilon0))
  ~= 0.0000357
```

Esto es mucho menor que `D3 ~= 0.01425`.

Si la eliminacion EL acumula hasta profundidad `5`, una cota gruesa de orden:

```text
5 * 2 * (lambdaR^epsilon0 - 1) ~= 0.000300
```

sigue pareciendo inferior a los margenes D1/D3, y no deberia cargar en D2.
Pero esta frase es solo diagnostica: antes de un cierre Lean debe hacerse un
recheck racional por fila y por termino.

## Recheck Requerido

Antes de cambiar el target principal de induccion, se requiere un script o
verificador racional que reconstruya las filas con pad:

```text
lambdaR^(-2)                         exacto
lambdaR^(alpha - 2 - epsilon0)       intervalo inferior
lambdaR^(alpha - 3 - epsilon0)       intervalo inferior
lambdaR^(2*alpha - 5 - epsilon0)     intervalo inferior
lambdaR^(3*alpha - 5 - epsilon0)     intervalo inferior
```

Este recheck debe responder:

```text
row22 padded slack > 0
row25 padded slack = old row25 slack or remains > 0
row28EL padded slack > 0
```

y debe confirmar si el pad unico `epsilon0` basta o si se necesita pad
acumulado `j * epsilon0` en las llamadas de profundidad EL.

## Decision De Implementacion Lean

Opciones:

```text
A. reemplazar I2ELAbstractRows por V2;
B. anadir I2ELAbstractRowsV2 al lado de V1 y marcar V1 como ideal/continuo;
C. dejar V1 y anadir un adapter seam->V1 con hipotesis de redondeo.
```

Recomendacion: **B**.

Justificacion:

```text
V1 ya compila y documenta el sistema continuo ideal;
V2 expresa el contrato realmente descargable desde el seam Nat;
mantener ambos permite comparar pruebas y certificados sin romper el modulo
M0C actual antes del recheck racional;
evita un adapter seam->V1 que esconderia la perdida de monotonicidad.
```

Ruta posterior:

```text
1. anadir epsilon0, M1V2, M2V2, I2ELAbstractRowsV2 en Lean;
2. mantener I2ELAbstractRows V1 como ideal/documental;
3. cambiar K2RetardedInductionInputs o crear K2RetardedInductionInputsV2
   solo cuando el recheck racional padded este cerrado;
4. intentar la induccion principal sobre V2.
```

## No Objetivos

No se prueba:

```text
M0C main induction
M1 theorem
global Collatz claim
Collatz closure
almost all
```

No se modifica:

```text
certificado Lean
M0B
M0C
ledger de redondeos
```

## Resultado

```text
M0C_ROWS_EXACT_SHIFT_CONTRACT_REVIEWED = yes
EPSILON_PAD_ROWS_V2_SCOPED = yes
ROUNDING_LOSS_MOVED_INTO_ROW_CONTRACT = yes
RETARDED_RANK_DESCENT_STILL_PLAUSIBLE = yes
CERTIFICATE_SLACK_RECHECK_REQUIRED = yes
M0C_MAIN_INDUCTION_NOT_STARTED = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
