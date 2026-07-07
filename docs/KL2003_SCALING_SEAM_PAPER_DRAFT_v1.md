# KL2003_SCALING_SEAM_PAPER_DRAFT_v1

Fecha: 2026-07-08.

Estado: borrador de papel para la costura entre las filas combinatorias Nat de
M0B y las filas abstractas EL que consumira M0C. No se crea Lean nuevo.

## Clasificacion

```text
SCALING_SEAM_PAPER_DRAFTED
NAT_TO_Y_PHI_INTERFACE_DEFINED
RETARDED_BRANCH_X_TRAP_IDENTIFIED
EL_SYSTEM_REQUIRED_BEFORE_M0C
WINDOW_CHOICE_PROPOSED
ROUNDING_LEDGER_OPEN
C25_SLACK_RISK_IDENTIFIED
M0C_NOT_STARTED
NO_NEW_LEAN
NO_M0_THEOREM
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Objetivo De La Costura

M0B ya cerro una capa combinatoria Nat:

```text
piStarFinset a x
two_branch_card_bound
d1_core_instantiation
d2_single_branch_core_instantiation
d3_core_instantiation
```

M0C no debe consumir directamente esos objetos. M0C consume un sistema
abstracto de funciones de variable real:

```text
phi_2^2(y)
phi_2^5(y)
phi_2^8(y)
```

El papel de esta costura es explicar como una fila Nat sobre ventanas
`x, xRet, xAdv` se convierte en una fila abstracta sobre argumentos
`y + shift`, y donde se pagan los redondeos.

## Dos Niveles

### Nivel Nat combinatorio

Objeto validado:

```text
piStarFinset a x
```

Semantica:

```text
n <= x
1 <= n
la orbita de n alcanza a
todos los intermedios permanecen <= x
```

Fila comun D1/D3 ya probada en Lean:

```text
card(piStarFinset (4*a) xRet)
  + card(piStarFinset c xAdv)
<=
card(piStarFinset a x)
```

con:

```text
1 <= a
NotInCycle a
3*c + 1 = 2*a
a <= x
xRet <= x
xAdv <= x
```

Fila D2 one-branch ya probada en Lean:

```text
card(piStarFinset (4*a) xRet)
<=
card(piStarFinset a x)
```

obtenida anulando la rama advanced con `xAdv = 0`.

### Nivel y/phi abstracto

La lectura semantica futura sera de la forma:

```text
Phi_m(y)  representa un lower envelope de
piStarFinset a x_y(a)
para raices a en la clase m mod 9
```

donde el bound natural canonico sera algo como:

```text
x_y(a) = floor(2^y * a)
```

o una variante equivalente documentada. Esta igualdad no pertenece a M0C:
M0C solo recibe filas abstractas EL sobre `Phi`.

La forma final esperada para las filas abstractas es:

```text
phi_i(y) >= A*phi_j(y - shift1) + B*phi_k(y - shift2) + ...
```

En el diseno actual k=2, M0C usa el sistema I2/EL documentado en
`KL2003_M0C_RETARDED_INDUCTION_SCOPING_v1`.

## La Trampa De La Rama Retardada

La rama retardada de M0B es:

```text
source root = 4*a
source window absolute = xRet
```

La eleccion natural es:

```text
xRet := x
```

Esto no decrece en la ventana absoluta. Por tanto no sirve una induccion fuerte
sobre `x`.

Lo que decrece es el cociente ventana/raiz:

```text
xRet / (4*a) = x / (4*a) = (x/a) / 4
```

Si `x/a` representa `2^y`, entonces:

```text
xRet / (4*a) representa 2^(y-2)
```

Por tanto la rama retardada es una llamada a:

```text
phi_{4m mod 9}(y - 2)
```

Esta es la razon estructural por la que M0C debe inducir sobre `y` o sobre
`retardedRank y`, no sobre `x`.

## Eleccion De Ventanas Nat

### Ventana retardada

Propuesta:

```text
xRet := x
```

Propiedades:

```text
xRet <= x                              trivial
floor(2^(y-2) * 4*a) = floor(2^y*a)    si x = floor(2^y*a)
```

En la parametrizacion Nat exacta por el cociente `rho = x/a`, tambien es
exacta:

```text
rho * (4*a) / 4 = rho * a = x
```

Perdida de redondeo:

```text
ninguna para la rama retardada, si el mismo x fija el cociente objetivo.
```

### Ventana advanced

Para la rama advanced inmediata:

```text
3*c + 1 = 2*a
T c = a
```

Propuesta Nat:

```text
qAdv := ceil(x / (2*a))
xAdv := x - qAdv
```

En aritmetica entera, con `1 <= a`:

```text
qAdv = (x + 2*a - 1) / (2*a)
```

Direccion combinatoria:

```text
xAdv <= x
```

por construccion, luego la inyeccion M0B puede consumir `xAdv`.

Si se parametriza exactamente por `rho = x/a`, entonces:

```text
rho * 2^(alpha-1) * c
  = (x/a) * (3/2) * c
  = x * (3*c) / (2*a)
  = x * (2*a - 1) / (2*a)
  = x - x/(2*a)
```

Por tanto:

```text
xAdv = floor(x - x/(2*a))
     = x - ceil(x/(2*a))
```

Esta es la version Nat-exacta de la identidad continua de frontera.

Condiciones de tamano que debe registrar el modulo posterior:

```text
1 <= a
3*c + 1 = 2*a
a <= x
xAdv <= x
c <= xAdv
```

La ultima condicion deberia salir de las anteriores para hijos validos, pero
debe probarse como lema Nat antes de cerrar el seam.

### Variante real-y canonica

Si se empieza con:

```text
x = floor(2^y * a)
```

entonces `xAdv := x - ceil(x/(2*a))` es conservadora respecto a la frontera
ideal:

```text
2^(y+alpha-1) * c
```

La diferencia entre:

```text
floor(2^(y+alpha-1) * c)
```

y el `xAdv` Nat elegido es una perdida de redondeo. Esa perdida no esta
cerrada en este borrador.

## Identidad Real D3

Para D3, con:

```text
c = (2*a - 1)/3
2^alpha = 3
```

se tiene:

```text
2^(y+alpha-1) * (2a-1)/3
= 2^y * 2^(alpha-1) * (2a-1)/3
= 2^y * (3/2) * (2a-1)/3
= 2^y * (2a-1)/2
= 2^y*a - 2^(y-1)
```

Si:

```text
x approx 2^y*a
```

la frontera advanced se lee como:

```text
xAdv approx x - x/(2*a)
```

La forma Nat propuesta:

```text
xAdv := x - ceil(x/(2*a))
```

es precisamente la version entera inferior de esa frontera cuando `x/a` fija
el cociente de escala.

## Por Que M0C Consume EL Y No El Sistema Crudo

Las filas I2 crudas contienen ramas advanced con shift positivo. En particular
la rama D3 anterior apunta naturalmente a:

```text
y + alpha - 1
```

y:

```text
alpha - 1 > 0
```

Una induccion retardada no puede consumir una llamada futura. Por tanto M0C no
debe aceptar directamente las filas D1/D2/D3 crudas.

La eliminacion EL sustituye esas llamadas avanzadas por combinaciones de filas
que solo usan shifts retardados. El conjunto de shifts que M0C audita es:

```text
-2
alpha - 2
alpha - 3
2*alpha - 5
3*alpha - 5
```

Todos son `<= 0`, y en la region inductiva `2 <= y` quedan dentro de la zona
no negativa gracias al ancho base `2`.

## Filas Abstractas I2/EL Que M0C Asumira

M0C trabajara con un sistema abstracto:

```text
Phi.phi22 : Real -> Real
Phi.phi25 : Real -> Real
Phi.phi28 : Real -> Real
```

Helpers documentales:

```text
min3(u,v,w) = min u (min v w)

M2(Phi,y) =
  min3
    Phi.phi22(y + 3*alpha - 5)
    Phi.phi25(y + 3*alpha - 5)
    Phi.phi28(y + 3*alpha - 5)

M1(Phi,y) =
  min
    (Phi.phi28(y + 2*alpha - 5) + M2(Phi,y))
    Phi.phi22(y + 2*alpha - 5)
```

Filas:

```text
row22:
  Phi.phi28(y - 2)
    + min3
        Phi.phi22(y + alpha - 2)
        Phi.phi25(y + alpha - 2)
        Phi.phi28(y + alpha - 2)
  <= Phi.phi22(y)

row25:
  Phi.phi22(y - 2)
  <= Phi.phi25(y)

row28EL:
  Phi.phi25(y - 2)
    + min
        (Phi.phi28(y + alpha - 3) + M1(Phi,y))
        Phi.phi22(y + alpha - 3)
  <= Phi.phi28(y)
```

Separacion de responsabilidades:

```text
filas combinatorias M0B:
  descargan inyecciones y disyuncion de conteos Nat

certificado racional k=2:
  descarga coeficientes, intervalos y slacks positivos

scaling seam:
  descarga que las ventanas Nat corresponden a argumentos y-shifted

rounding ledger:
  paga las perdidas floor/ceil

M0C:
  consume solo filas EL abstractas y prueba la induccion retardada abstracta
```

## Ledger De Redondeos

El ledger debe registrar cada conversion entre frontera real y ventana Nat.

### Target window

Eleccion canonica:

```text
x = floor(2^y * a)
```

Fuente de perdida:

```text
2^y*a - floor(2^y*a) in [0,1)
```

Signo:

```text
la ventana Nat es menor o igual que la frontera real
```

Carga:

```text
clase objetivo c22/c25/c28, segun a mod 9
```

Estado:

```text
pendiente de ledger racional o numerico.
```

### Retarded window

Eleccion:

```text
xRet = x
```

Fuente de perdida:

```text
ninguna si se usa el mismo x para representar y-2 en la raiz 4*a
```

Signo:

```text
exacto en el cociente ventana/raiz
```

Carga:

```text
ninguna por redondeo local.
```

### Advanced window

Eleccion propuesta:

```text
xAdv = x - ceil(x/(2*a))
```

Fuente de perdida:

```text
floor(2^(y+alpha-1) * c) - xAdv
```

cuando se parte de `x = floor(2^y*a)`. En la parametrizacion exacta por
`x/a`, esta diferencia desaparece; al volver a `y` canonico reaparece como
perdida de target-floor.

Signo:

```text
xAdv es conservadora; puede reducir el conteo fuente disponible
```

Carga:

```text
c % 9 = 2 -> fila c22
c % 9 = 5 -> fila c25
c % 9 = 8 -> fila c28
```

Presupuestos observados para este ledger:

```text
c22 slack approx +0.007727
c25 slack approx +0.000274
c28 slack approx +0.008697
```

Riesgo:

```text
c25 es fino. No se debe asumir que el redondeo cabe.
```

En D3, el split de residuos ya probado en Lean dice:

```text
a = 9*t + 8
c = 6*t + 5
t % 3 = 0 -> c % 9 = 5 -> carga c25
t % 3 = 1 -> c % 9 = 2 -> carga c22
t % 3 = 2 -> c % 9 = 8 -> carga c28
```

El caso `t % 3 = 0` es el que exige mas cuidado por el margen pequeno de
`c25`.

### D2 advanced branch

Para:

```text
a = 9*t + 5
c = 6*t + 3
```

Lean ya registra:

```text
c % 3 = 0
```

La rama advanced existe combinatoriamente, pero no entra en el ledger
`phi_2^2/phi_2^5/phi_2^8`. Por eso D2 se consume como one-branch en el core
actual. La perdida aqui no es un floor/ceil local sino una exclusion estructural
de clase.

## Relacion Con El Certificado Racional

El certificado k=2 data-level fija:

```text
lambda = 27/20
c_2^2 = 73/40
c_2^5 = 1001/1000
c_2^8 = 69/40
c_1^2 = 1
C_2^max = 2
```

Tambien fija slacks racionales positivos para las filas L2NT:

```text
L2NT_D1_slack = 29/9720
L2NT_D2_slack = 271/729000
L2NT_D3_slack = 2077/145800
```

Estos slacks son los del certificado racional ya verificado tras el upgrade
`B_lo = 119/135`. Los presupuestos `c22/c25/c28` anteriores son el margen
observado del seam de redondeos y deben mantenerse como ledger separado hasta
que haya verificacion racional.

Endpoints trascendentales disponibles para el futuro consumo:

```text
B = lambda^(alpha-2) in [119/135, 8/9]
D = lambda^(alpha-1) in [119/100, 6/5]
```

M0C debe consumir estos hechos como inputs ya cerrados; no debe reabrir el LP
ni la certificacion de potencias.

## Test Empirico Posterior

Script propuesto:

```text
scripts/kl2003_scaling_seam_rounding_empirical_v1.py
```

Output propuesto:

```text
outputs/KL2003_SCALING_SEAM_EMPIRICAL_v1/summary.json
outputs/KL2003_SCALING_SEAM_EMPIRICAL_v1/grid.csv
outputs/KL2003_SCALING_SEAM_EMPIRICAL_v1/mismatch.csv
```

Grid inicial:

```text
a in [1, 500], solo clases 2,5,8 mod 9
x in [a, min(10000, 32*a)]
```

Para cada fila:

```text
1. calcular c cuando 3*c + 1 = 2*a;
2. fijar xRet = x;
3. fijar xAdv = x - ceil(x/(2*a));
4. comprobar xRet <= x y xAdv <= x;
5. comprobar c <= xAdv si la rama advanced se consume;
6. calcular piStar(a,x), piStar(4*a,xRet), piStar(c,xAdv);
7. verificar la desigualdad Nat combinatoria miembro/cardinalidad;
8. medir floor_loss_target;
9. medir floor_loss_advanced;
10. asignar la perdida a c22/c25/c28 por residuo;
11. comparar perdida normalizada contra los presupuestos observados.
```

Checks esperados:

```text
core_nat_ok = true para todas las filas cubiertas por M0B
rounding_budget_ok = pendiente hasta fijar normalizacion racional
c25_cases_reported_separately = true
```

Este test no sustituye una prueba Lean. Solo sirve para detectar temprano si
el ledger de redondeos amenaza el margen `c25`.

## Objetivo M1-Surrogate Final

La forma semantica final esperada, una vez ensamblados M0B, scaling seam, EL,
M0C, base segment y ledger de redondeos, es:

```text
piStar_a(x) >= Delta * (x/a)^gamma
```

con:

```text
gamma = log_2(27/20)
```

El candidato de base abstracta M0C es:

```text
DeltaM0CBase = lambda^-2 = (20/27)^2 = 400/729
```

Pero el `Delta` semantico final debe quedar como placeholder hasta cerrar:

```text
scaling seam
rounding ledger
base segment semantico
EL rows abstractas consumidas por M0C
```

## No Objetivos

```text
No se crea Lean nuevo.
No se modifica ningun modulo existente.
No se prueba M0C.
No se cierra el ledger de redondeos.
No se prueba M0.
No se prueba M1.
No se reclama ningun resultado global de Collatz.
```

## Resultado

```text
SCALING_SEAM_PAPER_DRAFTED = yes
NAT_TO_Y_PHI_INTERFACE_DEFINED = yes
RETARDED_BRANCH_X_TRAP_IDENTIFIED = yes
EL_SYSTEM_REQUIRED_BEFORE_M0C = yes
WINDOW_CHOICE_PROPOSED = yes
ROUNDING_LEDGER_OPEN = yes
C25_SLACK_RISK_IDENTIFIED = yes
M0C_NOT_STARTED = yes
NO_NEW_LEAN = yes
NO_M0_THEOREM = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
