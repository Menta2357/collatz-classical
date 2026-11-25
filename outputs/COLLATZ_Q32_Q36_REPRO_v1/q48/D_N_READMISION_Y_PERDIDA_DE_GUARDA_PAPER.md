# Q48 Front4b · dominio repetible y primera pérdida de guarda

25 de noviembre de 2026. **PAPER.** Una sola fila física; el origen `N`,
los relojes y los costes se conservan. Se consume el prefijo certificado
hasta `F=T^60(N)` sin reconstruirlo. No hay barrido orbital ni Lean nuevo.

## Dominio congelado

Fijar `s≥0`, `s≡7 (mod 8)` y, durante toda la iteración, los valores

```text
k=428769801+2^31(108+128s),
N=66972346602545741868196940927
  +79228162514264337593543950336s,
F=71667327748009080469224948461
  +84782316550432407028588866402s,
B60=253163701604367108480427299121,
Segment N F 60 95 B60.
```

El pivote `F` es un parámetro **fijo** del dominio, no se recalcula al
readmitir un estado. Definir

```text
D_{N,F}(x,j,S,B) := Admitted N x j S B ∧ x≤F,

Admitted N x j S B :=
  N≤x ∧ x impar ∧ x<2N+1 ∧ Segment N x j S B ∧
  ∃r≥1, Ones x r ∧ 3·orbit(x,r)+1=4·orbit(x,r+1).
```

En esta fila,

```text
F−N =4694981145463338601028007534
     +5554154036168069435044916066s>0,
12N−11F=15327554002449017256888858053
        +18132468116415573808049873610s>0.
```

Así `N<F<12N/11<2N+1`. La congruencia `F≡11 (mod 16)` fuerza
las valoraciones iniciales exactas `(1,2)`, y por ello
`D_{N,F}(F,60,95,B60)` es una entrada física.

## Sucesor abstracto y rango

Sea `D_{N,F}(x,j,S,B)`. Una cola física desde el **pivote actual** `x`
con `Segment x z len σ C` y `HitsBelow x x len` permite aplicar
`reduce_first_crossing`. En su primer cruce, si el prefijo local tiene
reloj `(m,d,D)` y termina en `u`, el libro retenido es

```text
Segment N u (j+m) (S+d) (3^m·B+2^S·D).
```

El consumidor devuelve `Paid N` o `Admitted N u ...` con `N≤u<x`.
En el segundo caso `u≤F`, así que `D_{N,F}(u,...)` vuelve a valer y
el rango natural `ρ_N(u)=u−N` baja estrictamente frente a `ρ_N(x)`.
También se conserva `11u<12N`, porque `u≤F` y `11F<12N`.
Por inducción fuerte se obtiene el siguiente **contrato condicional**:

```text
(∀x j S B, D_{N,F}(x,j,S,B) →
   Paid N ∨ ∃z len σ C,
     Segment x z len σ C ∧ HitsBelow x x len)
→ (∀x j S B, D_{N,F}(x,j,S,B) → Paid N).
```

Esta prueba abstracta es la misma inducción del consumidor A2, con el
paso adicional `u<x≤F`; no se ha compilado una declaración restringida.
`D_{N,F}` es una sobreaproximación cerrada de los readmitidos realmente
alcanzables; un dominio más pequeño tendría que demostrar su propio
cierre en cada primer cruce.
El `paid_of_total_producer` Lean existente cuantifica sobre **todos**
los `Admitted N`. Un productor sólo para `D_{N,F}` necesita esta versión
restringida formalizada antes de invocarlo.

## Primer contraste: la guarda de par se pierde físicamente

La guarda `G(x): x≡11 (mod 16)` equivale, para un impar positivo, a
empezar con las valoraciones exactas `(1,2)`. No forma parte de
`D_{N,F}`. La progresión siguiente muestra por qué.

Tomar `s=3959+4096q`, `q≥0`. Es una subfila de `s≡7 (mod 8)`.
Aquí `ν₂(F+5)=7`, de modo que se agotan exactamente `m=2` pares:

```text
64(X+5)=81(F+5),
Segment F X 4 6 85.
```

La siguiente valoración real es `d=2` y

```text
4Y=3X+1,                 Y=(243F+319)/256,
Segment F Y 5 8 319,
Segment N Y 65 103 74155671410886369206914093764995.
```

Los márgenes, con el mismo `N(q)`, son

```text
Y−N=4945062837046456440590401058760
    +5115093089654471743997491994720q>0,
F−Y=17048527973288393791353449654068
    +17634721842489940661946484211616q>0.
```

Cada retorno de los dos pares anteriores queda sobre `F`; `Y` es el
**primer** cruce bajo `F`. Además `Y≡7 (mod 32)` fuerza exactamente
`(1,1,2)` desde `Y`, con libro local `Segment Y Z 3 4 19`.
Por `N<Y<F<2N+1` y el libro absoluto, `D_{N,F}(Y,65,103,B65)` vale;
es la rama residual del reductor de ventana en ese primer cruce.
Pero `Y≡7 (mod 16)`, `ν₂(Y+5)=2` y el número de pares iniciales es
cero: `G(Y)` falla. La etiqueta de pares ni el cofactor se tratan
como fuente auxiliar.

La congruencia se obtiene sin criba orbital: `s=119+256t` fuerza
`ν₂(F+5)=7` y la ruptura `d=2`; allí
`Y≡13+6t (mod 32)`, por lo que `Y≡7 (mod 32)` equivale a
`t≡15 (mod 16)`, exactamente `s=3959+4096q`.

## Cota de primer cruce para salidas directas

Si tras `m` pares desde un pivote admitido `x` la valoración real
siguiente es `d∈{2,3,4}`, el terminal `Y` cruza bajo **ese** `x`
si y sólo si

```text
(2^d·8^m−3·9^m)x > 15·9^m−14·8^m.
```

Para `x≥N` en la fila, esto queda garantizado en los intervalos

| `d` | `m` con cruce inmediato garantizado | mayor umbral entero de `x` |
| ---: | ---: | ---: |
| 2 | `m≤2` | 25 |
| 3 | `m≤8` | 81 |
| 4 | `m≤14` | 162 |

Al superar esas cotas de `m`, el coeficiente izquierdo es negativo
y el término derecho positivo, por lo que **esa arista** no cruza
bajo `x`. Un cruce físico de la tabla entra al consumidor, que paga
o readmite en `D_{N,F}`; no garantiza que el sucesor conserve `G`.

**STOP preciso.** Falta el productor para todos los estados de
`D_{N,F}`, en particular para los que pierden `G`, como el `Y` anterior,
y para salidas de bloques largos sin cruce en la primera arista.
Desde un sucesor sin `G` se necesita un pago con fuente impar `w<N`
y libros físicos independientes hasta un mismo terminal, o una cola
real con `HitsBelow` del pivote **actual**. No se afirma ausencia de
una captura posterior ni convergencia global.

Padres: `../COLLATZ_Q47_STRATEGY_20261125/TRANSFERENCIA_MAHLER_FRONT4B.md`,
`../COLLATZ_CONTINUO_20261122/Q17_A2_FIRST_CROSSING_FUSION_LEAN/A2FirstCrossingFusion.lean`,
`../COLLATZ_CONTINUO_20261122/Q17_A2_FIRST_CROSSING_FUSION_LEAN/A2CertifiedLanding.lean`,
`LEGACY/RESULTADO_D2.md`.
