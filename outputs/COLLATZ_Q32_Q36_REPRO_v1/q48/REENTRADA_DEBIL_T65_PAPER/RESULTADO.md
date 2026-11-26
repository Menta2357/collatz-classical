# Q48 · Primer desacople débil bajo F

**PAPER exacto; sin compilación Lean.** De Bono breve: AGO fija el mismo
origen y el pivote físico; CAF compara `N≤U<F`; FIP prueba primero la
guarda literal de `Admitted`, antes de atribuirle un productor posterior.

Sea `s≥0`, `s≡7 (mod 8)`,
`k=428769801+2^31(108+128s)`, y siempre
`N=110482433359989887+2^58 k`. En coordenadas `s`:

```text
N = 66972346602545741868196940927
  + 79228162514264337593543950336 s
F = T^60(N) = 71667327748009080469224948461
  + 84782316550432407028588866402 s.
```

El libro original recibido es `(60,95,253163701604367108480427299121)`;
la identidad `2^95 F=3^60 N+B60` vale coeficiente a coeficiente.
Además `N<F<2N+1` por márgenes afines positivos.

## Primera salida directa no pagada

Tras `m=1` par `(1,2)`, la ruptura directa `d=2` daría
`Y=(27F+23)/32<N`, ya que

```text
32N−27F−23 = 208097242085218567113228501194
             + 246178653594783813221507017898 s > 0.
```

Las rupturas mayores sólo reducen ese terminal. El primer contraste
directo que puede quedar entre `N` y `F` es `m=2,d=2`.
Escriba `c=(F+5)/128`. En la subclase física `c≡3 (mod 4)`, los dos
pares llevan a `X=162c−5` y la siguiente valoración es exactamente 2.
Por tanto `U=T^65(N)=(243c−7)/2`, o equivalentemente
`256U=243F+319`. La palabra original de `F` a `U` es
`(1,2,1,2,2)` y su libro propio `(5,8,319)`; el libro absoluto es

```text
Segment N U 65 103 74155671410886369206914093764995.
```

Las desigualdades son uniformes en `s≥0` dentro de esa subclase:

```text
256(U−N) = 270239912514496635763245599030
           + 319693318103404483999843249670 s > 0;
256(F−U) = 931675260724118046099924329674
           + 1102170115155621291371655263226 s > 0.
```

Así `U` es el primer cruce bajo `F`: los pares y sus estados intermedios
suben, mientras `N<U<F`. El rango candidato es exactamente
`U−N=[270239912514496635763245599030+
319693318103404483999843249670 s]/256`, menor que `F−N`.

## Readmisión y primer fallo

La guarda `c≡15 (mod 32)` equivale a `s≡1399 (mod 2048)`.
En ella `U≡11 (mod 16)`, de modo que la cola física desde **U** es
`(1,2)`, con libro propio `(2,3,5)` y terminal `(9U+5)/8`.
Junto con `N<U<F<2N+1` y el libro absoluto anterior, esto prueba
literalmente `Admitted N U 65 103 74155671410886369206914093764995`
con `r=1`. La readmisión reduce el rango del pivote actual de `F−N`
a `U−N`; la convergencia no se sigue sin productor para este nuevo U.

En cambio `c≡3 (mod 8)` equivale a `s≡119 (mod 512)`.
También hay cruce físico `N<U<F` con el **mismo** libro, pero
`U≡1 (mod 4)`, así que `v₂(3U+1)≥2` y no existe el primer retorno
de valoración 1 que exige `Ones U r` para `r≥1`. Éste es el primer
desacople bajo `F` que rompe la readmisión automática. El menor
representante es `s=119`, donde `c≡27 (mod 32)` y la valoración
inmediata desde `U` es 3.

Alcance: el certificado clasifica esta salida `m=2,d=2` y exhibe
admisión real y fallo real. No clasifica aquí las salidas posteriores
`d=3,4`, las salidas parciales ni las colas después de U. Una fila
afín parametrizada por el origen `N(s)` no puede reiniciarse en U
mediante otro parámetro sin justificar que sigue siendo el mismo N.

Padres: `../../q47/TRANSFERENCIA_MAHLER_FRONT4B.md`
y `../../COLLATZ_CONTINUO_20261122/Q17_A2_FIRST_CROSSING_FUSION_LEAN/A2FirstCrossingFusion.lean`.
