# Q49 · Pago temprano heredado y residual real fuera de Q29

25 de noviembre de 2026. **PAPER de transferencia y primer bloqueo.**
Se conservan el mismo `N`, las valoraciones físicas y los libros
independientes. No se reabren certificados ni se barren órbitas.

## Corte del dominio ya pagado

`q29_capture33` certifica en Lean `PaidMeeting N` en T33 para **todo**
parámetro de Q29, incluidos los parámetros pares. Q29 pertenece a
`j≡131 (mod 4096)`; ya no se toma como residual de Q49.

El adaptador genérico certificado en Lean
`paid_of_small_two_mod_three` tiene exactamente este contrato:

```text
Segment N E j S B,
E>0 impar, E≡2 (mod 3), 2E<3N+1
  ⇒ w=(2E−1)/3, 0<w<N,
     Segment w E 1 1 1, PaidMeeting N.
```

En efecto `3w+1=2E` tiene valoración exacta 1. El segmento de `w`
es suyo; nunca se atribuye a la órbita original. La hipótesis de
precio compara `w` con el `N` del libro heredado.

## Primer contraste fuera de Q29

Fijar `k=428769801+2^31(12+64s)`, `s≥0`. Es una fila real distinta:
su índice heredado `j=131+256(392+1024k)` satisface
`j≡2179 (mod 4096)`, disjunto de Q29. El prefijo certificado es

```text
N=7551224716847488673038978175
  +39614081257132168796771975168s,
F=T^60(N)=16161180670369550395566597319
  +84782316550432407028588866402s,
Segment N F 60 94 253163701604367108480427299121.
```

En `F`, el adaptador falla **antes** de buscar una fuente: `F≡1`
`(mod 3)`. También `F−2N` tiene intercepto
`1058731236674573049488640969` y pendiente
`5554154036168069435044916066`, ambos positivos; por tanto
`2F<3N+1` es falso. `F>2N+1` impide usar `ThinAdmitted` allí.

El cambio de terminal sí activa el adaptador en una subfamilia.
Para `s=6+8t`, las valoraciones desde `F` son `(1,b)` con `b≥3`.
La comprobación exacta de la última valoración es

```text
(3X+1)/8=295230982484792245818993635099
         +381520424476945831628649898809t,
```

cuya paridad es `1+t`. Si `t` es par, `b=3` exactamente.
Escribir `s=6+16u`; entonces

```text
X=T^61(N)=(3F+1)/2,
Y=T^62(N)=(3X+1)/8=(9F+5)/16,
Segment F Y 2 4 5,
Segment N Y 62 98 2377508517582134398315775630009.
```

`Y` es impar, `Y≡2 (mod 3)` y
`Y−N=49995270225151744365322805916+
129215548839776962508948194930u>0`. El nuevo origen auxiliar

```text
w=(2Y−1)/3,
N−w=48415057269779004241008405784
    +125131400811520258576818404276u>0
```

da el libro propio `Segment w Y 1 1 1`. Así toda `s≡6 (mod 16)`
queda pagada por encuentro en T62. Si `t` es impar (`s≡14 (mod 16)`),
la valoración real es `b≥4` y el margen

```text
16N−(3X+1)=1561923536275910056706784186136
          +2018439005097350952957613631032t>0
```

fuerza `T^62(N)<N`; el libro original conserva el exponente real
`(62,95+b,2377508517582134398315775630009)`. Las fórmulas de
la subpartición son **PAPER** aquí. El teorema agregado `paid_row`
de `LEAN_CUT` incluye toda `s≡6 (mod 8)` y su recibo posterior registra
compilación y auditoría Lean PASS.

## Residual físico y primera guarda ausente para A2Thin

Tomar ahora `s=29+32u`, `u≥0`, subclase de `s≡13 (mod 16)`.
Sus residuos `s%64∈{29,61}` no satisfacen ninguna de las guardas
de `paid_row64` (39 de 64 clases); esto identifica un complemento
**real al certificado Q49 actual**, además de quedar fuera de Q29.
Las dos valoraciones reales desde
`F` son exactamente `(2,2)`:

```text
U=T^61(N)=(3F+1)/4,
V=T^62(N)=(9F+7)/16,
Segment N U 61 96 779298145441667409839667884947,
Segment N V 62 98 2417122598839266567112547605177.
```

Los márgenes afines del recibo de reentradas dan `N<V<U<F` y
`U<2N+1`. `U` es el primer cruce estricto bajo `F`; sin embargo,
su siguiente valoración es 2, por lo que no empieza con una racha
`Ones U r` de longitud positiva. Además `11U>12N` y `11V>12N`.
En la parametrización general de la fila, los numeradores positivos
son `4(11U−12N)=170860175713515706747826759138+
896340545821925329698377783202s` y
`16(11V−12N)=150121740731867663937609325058+
787545737123431886850078541542s`.
Así `ThinAdmitted N U` y `ThinAdmitted N V` son falsos, pese a los
libros originales completos. El primer fallo de la recomposición
ocurre ya en `F>2N+1`; cruzar bajo `F` no lo corrige en `U` ni `V`.

El adaptador temprano tampoco paga en esos tres puntos:
`F≡U≡V≡1 (mod 3)`. Para un objetivo impar `E≡1 (mod 3)`, una fuente
de **un** retorno requiere valoración par y su precio mínimo es
`(4E−1)/3`. En `U` esa fuente es `F>N`; en `V` es `U>N`; en `F`
también supera `N`. Esto no excluye fuentes de mayor profundidad.

**STOP preciso.** `s≡29 (mod 32)` es un dominio físico real fuera de
Q29 y del certificado `paid_row64`. En los
checkpoints `F,U,V` no se obtiene una entrada a `A2Thin`. Para
recomponerlo hace falta un terminal físico posterior `P` con
`Segment N P`, `N≤P`, `11P<12N` y la racha/ruptura de `Admitted`,
o un descenso/encuentro pagado con fuente propia `w<N`. No se afirma
que esta familia carezca de otro pago ni que permanezca sobre `N`.

Fuentes: `../COLLATZ_ECO_20261125/Q32_P5_J131_EARLY_CAPTURE_LEAN/RESULTADO.md`,
`../COLLATZ_Q48_FRONT4B_20261125/LEAN_PAID_EARLY/Front4bEarlyMeeting.lean`,
`../COLLATZ_Q48_FRONT4B_20261125/LEAN_THIN/A2ThinDomain.lean`,
`LEAN/Front4bT61S3.lean`, `LEAN_CUT/Front4bValSixCut.lean`,
`LEAN_CUT/RECIBO.json`,
`REENTRADAS_S13_E2_PAPER/RESULTADO.md`.
