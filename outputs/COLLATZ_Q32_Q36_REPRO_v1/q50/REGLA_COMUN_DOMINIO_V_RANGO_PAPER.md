# Q50 · dominio ancho desde V y rango del pivote vigente

26 de noviembre de 2026. **PAPER.** De Bono breve: cambiar el pivote
histórico `F` por el primer estado con ventana A2 útil `V`, y contrastar
una bajada del rango frente a `F` con otra frente al pivote **actual**.
Se conserva el mismo `N`, cada valoración real y el libro absoluto.
No hay barrido orbital ni compilación Lean nueva.

## Entrada física y primera guarda

Fijar `u≥0`, `s=29+32u`, `k=428769801+2^31(12+64s)` y el original
`N=110482433359989887+2^58 k`. Los estados heredados son

```text
N=1156359581173680383779426258047
  +1267650600228229401496703205376u,
F=T^60(N)=2474848360632909354224643722977
  +2713034129613837024914843724864u,
V=T^62(N)=1392102202856011511751362094175
  +1526081697907783326514599595236u.
```

La palabra física `F→V` es `(2,2)`; `V→W=T^63(N)` tiene valoración
real 1. Los libros, siempre desde el **mismo** `N`, son

```text
Segment N F 60 94 253163701604367108480427299121,
Segment N V 62 98 2417122598839266567112547605177,
Segment N W 63 99 7568280446574857051711818616875.
```

El coste local `F→W` para `(2,2,1)` es `(3,5,37)`; no existe aquí
un libro de una fuente auxiliar. Los márgenes afines son

```text
V−N=235742621682331127971935836128
    +258431097679553925017896389860u>0,
5N−4V=213389094444355871891682913535
      +233926209510013701425117645936u>0,
F−V=1082746157776897842473281628802
    +1186952431706053698400244129628u>0.
```

Por ello `N<V<5N/4<2N+1` y `V<F`. `F>2N+1` sigue fuera de la
ventana A2. Si `H=T^61(N)`, entonces `N<H<2N+1`, pero su siguiente
valoración real es 2: **H no es `Admitted N`**. Se reserva la letra
`A` para un eventual residual admitido del reductor, evitando
confundirlo con ese `H`.

## Dominio que sí se conserva bajo un cruce nuevo

Con `N` y `V` fijados por esta semilla, definir

```text
D_{N,V}(x,j,S,B) := Admitted N x j S B ∧ x≤V.
```

Es una sobreaproximación cerrada de los residuales alcanzables.
La aplicación de `reduce_window_certified` a `Segment N V` y
`N<V<2N+1` entrega `Paid N` o un residual `A` con
`Admitted N A` y `A≤V`. En este segundo caso `D_{N,V}(A,...)` vale;
además `4A<5N` y `A−N<F−N`. **Puede ocurrir `A=V`**, por lo que
esta última bajada frente al antiguo `F` no es una bajada frente
al pivote vigente `V`.

Para cualquier `D_{N,V}(x,j,S,B)`, supongamos ahora una cola física
`Segment x z len σ C` y `HitsBelow x x len`. El consumidor Lean
`reduce_first_crossing` conserva el libro hasta el primer cruce
`y=orbit(x,m)`:

```text
Segment N y (j+m) (S+d) (3^m B+2^S D),
```

donde `(m,d,D)` es el libro local del prefijo hasta `y`.
Devuelve `Paid N` o, mediante `next_rank`, un `Admitted N x'`
con `N≤x'<x≤V`. Así el nuevo estado vuelve a `D_{N,V}` y
`x'−N<x−N`; `next_rank` retiene también el libro absoluto
`Segment N x' j' S' B'`, que puede incluir una cola posterior a `y`.
La desigualdad de rango **sola** no certifica
imparidad, palabra real ni libro: esos datos vienen de `next_rank`.

La inducción fuerte sobre `x−N` cerraría `Paid N` en este dominio
**si** un productor entregara para cada `D_{N,V}` un pago o una
cola física con `HitsBelow` bajo su propio `x`. El teorema Lean
`paid_of_total_producer` existente pide el productor para **todos**
los `Admitted N`; una restricción a `D_{N,V}` requiere su propio
consumidor formal o una hipótesis más amplia. No se ha probado aquí
la premisa de existencia total del próximo cruce.

## Contraste exacto: la entrada puede readmitirse sin progresar

La forma afín da `V≡31+4u (mod 32)`. En la progresión infinita
`u=2+8t`, `t≥0`, se tiene `V≡7 (mod 32)`. Por tanto las siguientes
valoraciones reales desde `V` son exactamente `(1,1,2)`: `V` mismo
es `Admitted N V 62 98 B62`. El reductor de ventana toma entonces
su rama residual con `A=V` y libro reflejo `Segment V V 0 0 0`.

La cola física conocida conserva sus libros propios y originales:

```text
16Z=27V+19,                 Z=T^65(N),
Segment V Z 3 4 19,
Segment N Z 65 102 71283650519744286969148125565315.
```

Los dos unos suben y el terminal de la ruptura también:
`16(Z−V)=11V+19>0`. Incluso

```text
16(Z−(2N+1))=583252879554538536345136285224
              +639386636206808967999686499340u>0.
```

Así esos tres retornos no son `HitsBelow V V 3`. El ejemplo no
excluye un encuentro pagado o un cruce **posterior**; refuta la
promoción del rango `A−N<F−N` a una disminución automática desde
`A=V`.

**STOP preciso.** `D_{N,V}` conserva una transición *cuando* se
suministra un cruce físico bajo el pivote actual. Falta demostrar
para cada estado admitido que ese cruce o un pago existe. La ventana
`N<V<2N+1`, el retorno `V→W` y el rango heredado desde `F` no
aportan esa premisa.

Padres: `../COLLATZ_Q49_20261125/REENTRADAS_S29_T64_PAPER/RESULTADO.md`,
`../COLLATZ_Q49_20261125/REENTRADAS_S13_E2_PAPER/RESULTADO.md`,
`../COLLATZ_CONTINUO_20261122/Q17_A2_FIRST_CROSSING_FUSION_LEAN/A2FirstCrossingFusion.lean`,
`../COLLATZ_CONTINUO_20261122/Q17_A2_FIRST_CROSSING_FUSION_LEAN/A2CertifiedLanding.lean`,
`LEAN_LANDING/Front4bS29Landing.lean`.
