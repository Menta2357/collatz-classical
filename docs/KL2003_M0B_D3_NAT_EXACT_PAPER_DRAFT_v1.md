# KL2003_M0B_D3_NAT_EXACT_PAPER_DRAFT_v1

Fecha: 2026-07-08.

Estado: borrador de papel Nat-exacto para D3. No se abre Lean nuevo. No se
prueba la desigualdad D3 completa.

## Clasificacion

```text
D3_NAT_EXACT_STATEMENT_DRAFTED
D3_RETARDED_INJECTION_SCOPED
D3_ADVANCED_INJECTION_SCOPED
D3_RESIDUE_MIN_JUSTIFIED
D3_ROUNDING_LEDGER_OPEN
D3_SLACK_LEDGER_REQUIRED
D3_LEAN_NOT_STARTED
NO_D1_D2
NO_M0_THEOREM
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Enunciado Nat-Exacto D3

Variables naturales:

```text
a : Nat          raiz original D3
x : Nat          ventana final de piStarFinset a x
c : Nat          predecesor advanced de a
xRet : Nat       ventana de la rama retardada
xAdv : Nat       ventana de la rama advanced
```

Hipotesis aritmeticas y semanticas:

```text
1 <= a
a % 9 = 8
NotInCycle a
a <= x
3 * c = 2 * a - 1
T c = a
2 * a <= x                      -- ruta retardada: 4a -> 2a -> a
xRet <= x
xAdv <= x
```

Condiciones de no vacio o de ventana de las raices trasladadas:

```text
retarded root condition:
  4 * a <= xRet
  o, de forma mas exacta en una prueba por elementos:
  n in piStarFinset (4*a) xRet implica 4*a <= xRet

advanced root condition:
  c <= xAdv
  o, de forma mas exacta en una prueba por elementos:
  n in piStarFinset c xAdv implica c <= xAdv
```

La formulacion combinatoria esperada es:

```text
identity maps
  piStarFinset (4*a) xRet
and
  piStarFinset c xAdv
into disjoint fibers of
  piStarFinset a x

therefore:
  card (piStarFinset (4*a) xRet)
  + card (piStarFinset c xAdv)
  <= card (piStarFinset a x)
```

Este es el D3 Nat-exacto. No contiene:

```text
2^y * a
alpha
lambda
rpow
```

La vuelta a `y` y a la frontera continua queda separada en una capa de
escalado posterior.

## Nivel 1: Validez Combinatoria

La parte combinatoria solo necesita ventanas naturales y rutas finitas bajo
`T`.

### D3_retarded_injection

Rama:

```text
4*a -> 2*a -> a
```

Nombre:

```text
D3_retarded_injection
```

Entrada:

```text
n in piStarFinset (4*a) xRet
```

Por `mem_piStarFinset_reachesWithin_iff`, se obtiene:

```text
n <= xRet
1 <= n
ReachesWithin (4*a) xRet n
```

Con `xRet <= x`, se usa:

```text
reachesWithin_window_mono
```

para considerar la parte ya recorrida dentro de `x`.

Luego se anexa la ruta:

```text
PathWithin (4*a) a x 2
```

cerrada por:

```text
T (4*a) = 2*a
T (2*a) = a
4*a <= x
2*a <= x
a <= x
```

La condicion `4*a <= x` puede venir de `4*a <= xRet` y `xRet <= x`; si se
trabaja por elemento, `ReachesWithin (4*a) xRet n` ya fuerza `4*a <= xRet`.

Consumidores:

```text
mem_piStarFinset_reachesWithin_iff
reachesWithin_window_mono
reachesWithin_append_path
boundedReaches_iff
```

Salida:

```text
n in piStarFinset a x
```

Ademas, respecto a la particion por predecesor de entrada, esta rama entra por
la fibra de:

```text
2*a
```

porque el ultimo paso antes del primer hit de `a` queda forzado a ser `2*a`
bajo `NotInCycle a`.

### D3_advanced_injection

Rama:

```text
c -> a
c = (2*a - 1)/3
```

Nombre:

```text
D3_advanced_injection
```

Entrada:

```text
n in piStarFinset c xAdv
```

Por `mem_piStarFinset_reachesWithin_iff`, se obtiene:

```text
n <= xAdv
1 <= n
ReachesWithin c xAdv n
```

Con `xAdv <= x`, se usa:

```text
reachesWithin_window_mono
```

Luego se anexa la ruta:

```text
PathWithin c a x 1
```

cerrada por:

```text
T c = a
c <= x
a <= x
```

La condicion `c <= x` puede venir de `c <= xAdv` y `xAdv <= x`; si se trabaja
por elemento, `ReachesWithin c xAdv n` ya fuerza `c <= xAdv`.

Consumidores:

```text
mem_piStarFinset_reachesWithin_iff
reachesWithin_window_mono
reachesWithin_append_path
boundedReaches_iff
```

Salida:

```text
n in piStarFinset a x
```

Esta rama entra por la fibra de:

```text
c
```

## Disyuncion De Fibras

La disyuncion correcta no es simplemente "alcanza un hijo inverso", sino:

```text
el predecesor inmediato del primer hit de a
```

Las dos fibras D3 son:

```text
fibra retardada: 2*a
fibra advanced:  c = (2*a - 1)/3
```

La capa Lean ya disponible aporta:

```text
entry_pred_eq_of_reaches_child
inverse_children_disjoint_descendants
```

Uso esperado:

```text
NotInCycle a
T (2*a) = a
T c = a
ReachesWithin (2*a) x n
ReachesWithin c x n
a <= x
FirstHitsAt a n k0
0 < k0
```

entonces el predecesor inmediato del primer hit de `a` debe ser simultaneamente
`2*a` y `c`. Por tanto las ramas son disjuntas si:

```text
2*a != c
```

Derivacion de `2*a != c`:

```text
c = (2*a - 1)/3
3*c = 2*a - 1
si c = 2*a, entonces 6*a = 2*a - 1
por tanto 4*a = -1, imposible en Nat
```

En Lean convendra probar una forma sin resta ambigua:

```text
3*c + 1 = 2*a
->
c != 2*a
```

o trabajar en `Int` para esta micro-aritmetica.

## Nivel 2: Escalado Posterior

La identidad real de frontera:

```text
2^(y+alpha-1) * (2a-1)/3
=
2^y*a - 2^(y-1)
```

no pertenece al enunciado Nat-exacto. Solo explica como elegir, en una capa
posterior, la ventana natural `xAdv` a partir de una frontera continua.

La capa Nat-exacta solo necesita:

```text
xAdv <= x
c <= xAdv
T c = a
```

Cuando se vuelva a `y`, se debera justificar una eleccion como:

```text
x      approx floor(2^y * a)
xAdv   approx floor(2^y*a - 2^(y-1))
```

o una variante con `ceil`, siempre con un ledger de perdida.

## Residuo De La Rama Advanced

Supongamos:

```text
a % 9 = 8
```

Escribimos:

```text
a = 9*t + 8
```

Entonces:

```text
c = (2*a - 1)/3
  = (2*(9*t + 8) - 1)/3
  = (18*t + 15)/3
  = 6*t + 5
```

Ahora separamos por `t mod 3`.

Si:

```text
t = 3*s
```

entonces:

```text
c = 18*s + 5
c % 9 = 5
```

Si:

```text
t = 3*s + 1
```

entonces:

```text
c = 18*s + 11
c % 9 = 2
```

Si:

```text
t = 3*s + 2
```

entonces:

```text
c = 18*s + 17
c % 9 = 8
```

Por tanto:

```text
c mod 9 in {5, 2, 8}
```

Esto justifica que la contribucion advanced de D3 se mida contra:

```text
min(phi_2^2, phi_2^5, phi_2^8)
```

La clase concreta del advanced child determina que ledger de coeficiente se
consume:

```text
t % 3 = 0  -> c % 9 = 5 -> fila c25
t % 3 = 1  -> c % 9 = 2 -> fila c22
t % 3 = 2  -> c % 9 = 8 -> fila c28
```

## Ledger De Redondeos

La identidad real pertenece al escalado:

```text
X_real    = 2^y * a
XAdv_real = X_real - 2^(y-1)
```

La capa combinatoria usa:

```text
x : Nat
xAdv : Nat
```

Por tanto debe registrarse:

```text
x      = floor/ceil/other(X_real)
xAdv   = floor/ceil/other(XAdv_real)
loss   = diferencia entre frontera continua y ventana natural usada
```

Opciones:

```text
usar floor:
  seguro para inclusion de ventanas, pero reduce el conteo fuente;

usar ceil:
  puede preservar conteo, pero exige probar que la ventana no excede la
  frontera admisible o pagar el exceso con slack;

usar parametros Nat directos:
  evita Real/rpow en M0B, pero desplaza el enlace con KL2003 a un modulo de
  escalado posterior.
```

La perdida debe cargarse contra el ledger de la clase residual de `c`:

```text
c % 9 = 2 -> fila c22
c % 9 = 5 -> fila c25
c % 9 = 8 -> fila c28
```

Atencion: la fila `c25` tiene slack pequeno, aproximadamente:

```text
0.000274
```

No se debe asumir que el redondeo cabe sin ledger. En particular, cuando
`t % 3 = 0`, la rama advanced cae en `c % 9 = 5`, y cualquier perdida o exceso
por redondeo debe cargarse explicitamente sobre `c25`.

## Statement Lean Futuro

Un statement combinatorio razonable podria tener la forma:

```lean
theorem D3_nat_exact_injection
    {a x c xRet xAdv : Nat}
    (ha_pos : 1 <= a)
    (ha_mod : a % 9 = 8)
    (ha_cycle : NotInCycle a)
    (hc_eq : 3 * c = 2 * a - 1)
    (hc_T : T c = a)
    (hax : a <= x)
    (hxRet : xRet <= x)
    (hxAdv : xAdv <= x)
    (hroute_ret : PathWithin (4*a) a x 2)
    (hroute_adv : PathWithin c a x 1) :
    card (piStarFinset (4*a) xRet)
      + card (piStarFinset c xAdv)
      <= card (piStarFinset a x)
```

Este statement todavia es borrador. Probablemente convendra partirlo en:

```text
D3_retarded_injection
D3_advanced_injection
D3_retarded_advanced_disjoint
D3_card_bound
```

La prueba futura consumira:

```text
boundedReaches_iff
mem_piStarFinset_reachesWithin_iff
reachesWithin_window_mono
reachesWithin_append_path
entry_pred_eq_of_reaches_child
inverse_children_disjoint_descendants
```

## No Reclamado

```text
No hay Lean nuevo.
D3 no esta probado.
D1/D2 no se tocan.
No hay M0 theorem.
No hay M1 theorem.
No hay claim global de Collatz.
```
