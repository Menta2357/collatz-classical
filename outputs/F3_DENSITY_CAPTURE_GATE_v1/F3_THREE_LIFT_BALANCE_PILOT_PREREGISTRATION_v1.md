# F3 — prerregistro del piloto de balance entre tres lifts v1

Fecha de congelación: 2026-07-21.

Estado inicial:

```text
PREREGISTERED_BEFORE_CALIBRATION
TYPES_FIXED
SPLIT_FIXED
SCALES_FIXED
FREEZE_RULE_FIXED
HOLDOUT_NOT_ACCESSED
PENDING_PUBLIC_CUSTODY
NO_LEAN
```

## 1. Pregunta única

Cuando un tipo padre módulo \(M\) se refina en los tres lifts módulo \(3M\),
¿la masa advanced queda unilateralmente balanceada, o algún lift puede llevar
una fracción arbitrariamente pequeña de la masa agregada?

Este piloto no busca densidad ni tasa \(\rho\). Solo decide si un lema de
balance merece una página de papel posterior.

## 2. Tipos congelados

```text
modulos M             = {36, 108} = {4*3^2, 4*3^3}
clases padre mod 9    = {2, 8}
D1 / clase 2          = hijo advanced b(a) = 2*(2a-1)/3
D3 / clase 8          = hijo advanced b(a) =   (2a-1)/3
residuo padre r       = 0 <= r < M, r mod 9 en {2,8}
lifts                  = t en {0,1,2}
raiz                   = a(M,r,t,q) = r + t*M + 3*M*q
escalas                = y en {8,9,10}
x                      = 2^y * a
xAdv                   = x - ceil(x/(2a)) = x - 2^(y-1)
```

No se añadirán módulos, clases, escalas, etiquetas rich/thin ni excepciones
después de ver calibración o holdout.

## 3. Partición calibración/holdout congelada

```text
calibracion = q en {0,1,2,3,4,5,6,7}
holdout     = q en {8,9,10,11,12,13,14,15}
```

La separación es por bloques de cociente y deja ocho raíces por lift, tipo y
fase. El holdout está en el bloque de mayor tamaño de raíz, deliberadamente
adversarial frente al drift observado en E2.

## 4. Funcional medido

Para cada fase \(s\), módulo \(M\), tipo padre \(r\), lift \(t\) y escala
\(y\), se define

\[
A_{M,r,t}^{(s)}(y)
=\sum_{q\in Q_s}\pi^*(b(a),xAdv(a,y)).
\]

La cuota advanced del lift es

\[
\sigma_{M,r,t}^{(s)}(y)
=\frac{A_{M,r,t}^{(s)}(y)}
       {\sum_{u=0}^2 A_{M,r,u}^{(s)}(y)}.
\]

Se registran además la masa target

\[
T_{M,r,t}^{(s)}(y)=\sum_{q\in Q_s}\pi^*(a,2^y a)
\]

y la razón de captura advanced total, pero ninguna de las dos se usa para
seleccionar tipos o cambiar el veredicto de balance.

Un denominador advanced total cero es fallo automático.

## 5. Hooks miembro a miembro obligatorios

Para cada raíz:

```text
a mod M = r
(a-r)/M mod 3 = t
q pertenece solo a la fase declarada
(2a-1) divisible por 3
D1: T(2c)=c y T(c)=a
D3: T(c)=a
xAdv <= x
pi*(b,xAdv) <= pi*(a,x)
```

Cualquier fallo produce `INVALID_EXPERIMENT`, no un dato excluible.

## 6. Regla de congelación tras calibración

Sea

\[
\beta_{cal}=\min_{M,r,t,y}\sigma_{M,r,t}^{(cal)}(y).
\]

La cota congelada se calcula mecánicamente:

\[
\beta_{frozen}
=\left\lfloor1000\max(0,\beta_{cal}-0.02)\right\rfloor/1000.
\]

No se permite otra regla. El contrato congelado guarda hashes del script y de
este prerregistro antes de acceder al holdout.

Umbral de utilidad predeclarado:

```text
beta_frozen >= 0.200
```

El 0.200 no prueba suficiencia espectral; evita promocionar un balance tan
débil que no justifique una ruta de papel separada.

## 7. Veredicto dado únicamente por el holdout

```text
HOLDOUT_BALANCE_PASS
  iff toda cuota holdout >= beta_frozen

UTILITY_PASS
  iff beta_frozen >= 0.200

LOCAL_PROVISIONAL_GO_TO_BALANCE_LEMMA
  iff hooks PASS, HOLDOUT_BALANCE_PASS y UTILITY_PASS

STOP_OR_REDESIGN
  en cualquier otro caso
```

Aunque pase, el resultado permanece `LOCAL_PENDING_PUBLIC_CUSTODY` hasta que
prerregistro, contrato, código, outputs y manifiestos estén en un repositorio
público accesible. Solo después puede emitirse un veredicto coordinado formal.

## 8. No-claims

```text
NO_UNIFORM_BALANCE_LEMMA
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN
```

