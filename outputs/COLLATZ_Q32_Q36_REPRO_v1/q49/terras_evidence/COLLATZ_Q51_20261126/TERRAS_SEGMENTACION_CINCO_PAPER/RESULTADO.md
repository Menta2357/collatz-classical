# Q51 · Identidad de segmentación para capacidades de cinco rachas

**PAPER combinatorio exacto.** No se ejecutó criba ni se compiló Lean
nuevo. De Bono breve: cambiar la representación de «bloques completos»
a **ocurrencias de rachas dentro del prefijo de pasos** separa la
identidad de conteo de la desigualdad de absorción.

Sea `T(x)=x/2` para x par y `T(x)=(3x+1)/2` para x impar. Fijar el
mismo `N` impar positivo y un primer reloj finito `τ` con
`3^dτ<2^τ`. Escribir `x_j=T^j(N)` y contar en los pasos
`j=0,...,τ−1` las entradas impares `d` y sus `m≥1` rachas máximas.
Se consume el hecho ya certificado de que `x_(τ−1)` es par y que
`x_j≥N` para `j<τ`; no se reabre su prueba.

Sean `p_i` los índices de inicio de esas rachas, `p_1=0`, y `q_i`
el primer índice par posterior a la racha i. Para `i<m` defina
`b_i=p_(i+1)−q_i`; para el último defina **sólo en el prefijo**
`b_m=τ−q_m`. La última arista sale de un par, luego
`q_m≤τ−1` y `b_m≥1`, aunque el tramo par real continúe más allá
de τ. Con `a_i=q_i−p_i≥1`, las identidades físicas son

```text
d = Σ_(i=1)^m a_i,
τ = Σ_(i=1)^m (a_i+b_i).
```

No se requiere que el último `b_m` sea el hueco par maximal.

## Selección con multiplicidades

Poner `v_i=x_(p_i)`. Ordenar las **parejas** `(v_i,i)` por valor y,
en empate, por índice. Sea `I` el conjunto de índices de las `r`
primeras parejas, con `1≤r≤m`; así cada aparición repetida de un
valor sigue siendo una raíz distinta. Como todos los estados antes
de τ son al menos N, `v_1=N` es mínimo y el desempate asegura `1∈I`.
Ordenar I cronológicamente:
`1=i_1<i_2<...<i_r`, y poner `i_(r+1)=m+1`.
Los intervalos de índices de racha
`[i_j,i_(j+1))` son disjuntos, no vacíos y cubren `1,...,m`.
Si `t_j=i_(j+1)−i_j`, entonces

```text
t_j≥1,                  Σ_j t_j=m,
D_j=Σ_(i=i_j)^(i_(j+1)−1) a_i,   Σ_j D_j=d.
```

El segmento físico j comienza en el estado `v_(i_j)` y termina en
`x_(p_(i_(j+1)))` si `j<r`, o en `x_τ` si `j=r`. El último sólo
recorta pasos **pares** posteriores a `q_m`; las `t_r` rachas impares
del segmento están completas. Por determinismo, son exactamente
las primeras `t_j` rachas de la órbita que arranca en su propia raíz.
Así, si el r-ésimo menor valor satisface `v_[r]+1<2^H`, toda raíz
seleccionada satisface la misma ventana y una capacidad certificada
`C_H(t_j)` de rachas completas se aplica a `D_j`, también en el
segmento final: `D_j≤C_H(t_j)` y `d≤Σ_j C_H(t_j)`.

La identidad sirve igual para una capacidad certificada de cinco
rachas. No prueba por sí sola el **lema de absorción**
`Σ_j C_H(t_j)≤C_H(m−r+1)+(r−1)C_H(1)`: esa desigualdad necesita
convexidad discreta o una comparación explícita de incrementos de
`C_H`, incluida la unión de los regímenes de 4, 5 y 6 rachas.
El corte par y los empates no añaden esa obligación.

## Libro conservado

Cada segmento j tiene el libro físico local
`2^K_j x_fin=3^D_j x_inicio+E_j`. Los intervalos de pasos también
particionan exactamente `[0,τ)`, por lo que `Σ_j K_j=τ` y el
aditivo absoluto desde el **mismo N** es

```text
C_τ = Σ_(j=1)^r 2^(Σ_(h<j) K_h) · 3^(Σ_(h>j) D_h) · E_j,
2^τ T^τ(N) = 3^d N + C_τ.
```

Un paso par del último tramo aumenta `K_r` en uno y deja `D_r,E_r`
sin cambio. Por eso el truncamiento queda reflejado en `τ` sin
alterar la suma de impares ni inventar otro origen o coste.

Alcance: prueba la segmentación y la transferencia **condicional**
de cualquier capacidad válida `C_H(t)`. No certifica aquí una
capacidad numérica de cinco rachas ni su convexidad, y no extrae
por sí sola una nueva conclusión de Terras 88/89.

Padres de reloj: `../LEAN_CLOCK/TerrasClock.lean` y
`../../COLLATZ_TERRAS_87_RUNS_20261125/RESULTADO.md`.
