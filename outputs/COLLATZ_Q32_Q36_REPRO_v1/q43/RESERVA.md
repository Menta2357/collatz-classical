# Q43 · Transporte de la reserva de la ruptura 2

Con entradas positivas y valoración exacta `W+1=2^D·u`, `D≥1`, `u` impar positivo, y la relación `V+5=6(W+1)`, escribimos `m=D/3`, `s=D mod 3`. Lean conserva ambos segmentos físicos y sus libros para cualquier `D`. El segmento original de `V` tiene `m` macros `(1,2)` y termina en `X=2^(s+1)·3^(2m+1)·u−5`. El auxiliar de `W` tiene `D−1` unos y termina en `Y=2·3^(D−1)·u−1`. [Código Lean](../lean/A2WeakBreakReserve.lean)

| Segmento local | Retornos | Divisiones | Aditivo |
| --- | ---: | ---: | --- |
| `V → X` | `2m` | `3m` | `5·(3^(2m)−2^(3m))` |
| `W → Y` | `D−1` | `D−1` | `3^(D−1)−2^(D−1)` |

`paired_histories` compone el primero con el libro desde `N`, y el segundo con el libro desde la fuente `w`. Las sumas de valoraciones y los aditivos se calculan en su propio reloj mediante `StagedCylinder.compose`. `reserve_segments` acredita además que `2^D` divide `W+1` y que `2^(D+1)` no lo divide.

## Tabla de salida comprobada en papel

Sea `q=3^(2m+1)·u`, impar. Cuando `s=0`, la primera valoración ya es distinta de 1. Para `s=1,2` el primer retorno tiene valoración 1, y el siguiente se obtiene de la fila correspondiente.

| s | Palabra original desde X | Terminal | Libro local de salida |
| ---: | --- | --- | --- |
| 0 | `(a)` con `a=1+ν₂(3q−7)≥2` | `(3q−7)/2^(a−1)` | `(1,a,1)` |
| 1 | `(1,1)` | `9q−10` | `(2,2,5)` |
| 2 | `(1,a)` con `a=2+ν₂(9q−5)≥3` | `(9q−5)/2^(a−2)` | `(2,1+a,5)` |

Después de los `D−1` unos, el auxiliar sale con `b=1+ν₂(3^D·u−1)≥2` y terminal `(3^D·u−1)/2^(b−1)`. La tabla acredita en papel el agotamiento exacto de los macros y de los unos. El pago o descenso desde esos terminales queda fuera del alcance del transporte certificado.

[Recibo de Lean](../provenance/q43_frozen_build.json)
