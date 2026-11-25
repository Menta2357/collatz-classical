# Q46 · Rama B con b67=1

Estado: prueba aritmética exacta en papel; no se ha compilado en Lean.

## Dominio y libro

Sea `q≥0`, `k=3805769794057+2^47 q` y el **mismo**
`N=110482433359989887+288230376151711744 k`. En coordenadas `q`:

```text
N = 1096938459287982130584268295295
  + 40564819207303340847894502572032 q
F = T^60(N) = 1173837442903630371840880211687
  + 43408546073821392398637499597824 q
T^66(N) = 3342685530768541176062506540315
          + 123612617530530449447682567214116 q
T^67(N) = 5014028296152811764093759810473
          + 185418926295795674171523850821174 q
```

La palabra original llega a T66 con valoración `a66=2` y a T67 con
`b67=1`. Su libro absoluto es
`(67,104,660904333371807647179556239957403)`, verificado por
`2^104 T^67(N)=3^67 N+660904333371807647179556239957403`
coeficiente a coeficiente. No se usa ninguna fuente auxiliar.

## Siguiente conector

Poniendo `Y=3T^67(N)+1`, se obtiene

```text
Y = 15042084888458435292281279431420
  + 556256778887387022514571552463522 q.
```

La congruencia exacta es `16 | Y` si y sólo si `q≡2 (mod 8)`.
En esa subprogresión, la valoración física `a68=v₂(Y)≥4` queda libre y
`T^68(N)=Y/2^a68` es impar. El margen

```text
16N−Y = 2508930460149278797067013293300
      + 92780328429466431051740488688990 q > 0
```

prueba `T^68(N)<N<F` para todo `q≥0` de la subprogresión. El libro
absoluto original se extiende a
`(68,104+a68,2002995409719074611962615971158225)`, pues el término
aditivo es `3·660904333371807647179556239957403+2^104`.

Para las otras clases, la valoración real es `1` si `q` es impar, `2`
si `q≡0 (mod 4)`, y `3` si `q≡6 (mod 8)`. El primer fallo exacto del
cruce inmediato bajo `F` es

```text
8F−Y = −5651385345229392317554237737924
      − 208988410296815883325471555680930 q < 0.
```

Así, en esas clases `T^68(N)≥Y/8>F`. El resultado sólo resuelve el
conector T67→T68: no cubre sus colas posteriores ni un productor total.

El prefijo hasta `F` y su condición de pivote proceden de
`../../COLLATZ_Q45_20261125/Q45_B_7A1_READMISION_TASADA_PAPER.md`;
la rama `a66=2, b67=1` y el libro de T67 son la entrada asignada a Q46.
