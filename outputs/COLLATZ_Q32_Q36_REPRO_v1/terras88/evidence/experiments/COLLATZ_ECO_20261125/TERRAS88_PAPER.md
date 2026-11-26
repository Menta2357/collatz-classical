# Terras 88 · reducción aritmética y casos pendientes

25 de noviembre de 2026. Resultado en papel con comprobación racional exacta. Sigue abierto el paso de 87 a 88 rachas. Las exclusiones de trayectorias cortas de Weaver se usan como insumos ya reproducidos en el proyecto. [Recibo de reproducción](../COLLATZ_TERRAS_87_RUNS_20261125/WEAVER_REPLAY_20261125/RECIBO.json)

## Dominio y reloj

Buscamos un fallo de Terras en el primer cruce **finito** del mapa abreviado, \(k=\min\{s\ge1:3^{d_s}<2^s\}\). Sea \(d=d_k\) el número de entradas impares, \(m\) el número de rachas impares máximas y \(\Lambda=k\ln2-d\ln3\). Se supone exactamente \(m=88\), por Terras 87. Se importan la verificación hasta \(B=28\cdot10^{18}\), la cota de Rhin, la exclusión existente del caso \(T^k(n)=n\) por el límite de mínimos locales y las reducciones de alturas y tramos de Weaver. Por ello basta estudiar \(n>B\) y \(\Delta=T^k(n)-n\ge1\). Los pasos \(k\) de este informe son abreviados. Las consultas externas cuentan bloques completos que terminan en el siguiente inicio impar, aunque la última racha par en \(k\) pueda estar truncada. [Dossier de 87](../COLLATZ_TERRAS_87_RUNS_20261125/RESULTADO.md) · [Weaver, secciones 2–6](https://rstation.ai/problems/collatz/papers/143)

El techo de Rhin da \(d<2^{70}\). Con la misma base unimodular que el verificador alternativo de 87 y \(0<\Lambda<88/B\), la criba recorre 5.356 pares dentro del intervalo racional. El sobre de recíprocos, redondeado hacia arriba, deja exactamente cuatro pares \((k,d)\). Esta lista es la salida de esa criba concreta.

## Resultado de las inclusiones

| Par \((k,d)\) | \(\Delta\ge2\) | \(\Delta=1\) con las cotas actuales |
|---|---|---|
| \((630118245525664765,397560349370386783)\) | Incluido en Q0 de Weaver. Fuente estrictamente menor que \(453027402666008300801\), altura objetivo \(2^{146}-1\), a lo sumo 5 bloques. | Rango 11 sólo da \(2^{92}-1\) con la capacidad de tres rachas. La holgura del precio también es negativa. |
| \((7354673373747273033,4640282259296926456)\) | Incluido en Q1 de Weaver. Fuente estrictamente menor que \(99048017070889459164\), altura objetivo \(2^{170}-1\), a lo sumo 4 bloques. | Rango 6 sólo da \(2^{107}-1\) con la capacidad de tres rachas. La holgura del precio también es negativa. |
| \((14709346747494546066,9280564518593852912)\) | Excluido sin consulta nueva. El quinto valle mide al menos \(2^{85}-1\), los cuatro primeros inicios están por debajo de la altura \(2^{66}\), y la capacidad de tres rachas en \(H=66\) contradice \(d\). | La cota actual del cuarto valle es \(2^{67}-1\). Es insuficiente para deducir \(x_{[3]}+1<2^{66}\). Incluso si se dispusiera de esa altura, la capacidad de tres rachas aplicada a tres inicios sólo da un techo aproximado de \(1,22027d\). |
| \((43497921996957973433,27444133206411171953)\) | Excluido por el mismo argumento que para \(\Delta=1\). | Excluido. El tercer valle mide al menos \(2^{100}-1\), los dos primeros inicios están por debajo de la altura \(2^{67}\), y la capacidad de tres rachas certificada en \(H=67\) da \(d\le67(G_{86}+1)<d\). |

En los tres primeros pares, la altura inicial cumple \(n+1<2^{72}\) por \(n\Lambda<88\). Sea \(a_1\) la longitud de la primera racha impar. Su contribución logarítmica es a lo sumo \((1-(2/3)^{72})/n\). Los demás inicios son \(\ge n\). Para \(q\in\{2,3\}\) y \(\Delta\ge q\) se tiene
\[
\log(1+\Delta/n)>\frac q{n+q},\qquad
\frac{q-(2/3)^{72}}n-\frac q{n+q}
=\frac{q^2/(n+q)-(2/3)^{72}}n<0
\]
por \(n>B\). Así se cancelan los \(q\) recíprocos más bajos de una vez, incluyendo el origen. Se conserva \(\Lambda<\sum_{r=q+1}^{88}1/x_{[r]}\). Para \(q=2\) se sube una posición cada uno de \((\ell,S,R)\) y se usa la capacidad de tres rachas ya certificada. Para \(q=3\) se suben dos posiciones y bastan las cotas ordinarias. El precio de la fuente, la altura objetivo y el número de bloques se conservan en las dos consultas.

Para el doble con \(\Delta\ge2\), el crédito cancela los rangos 1 y 2. Se acota \(1/x_{[3]}\le1/B\) y todos los rangos \(\ge5\) por \(1/(2^{85}-1)\). Esto fuerza \(x_{[4]}+1<2^{66}\) mediante la contribución del rango 4. La partición en cuatro raíces, con la capacidad de tres rachas en \(H=66\), da
\[
d\le66\bigl(G_{84}+3\bigr)<9280564518593852912.
\]

## Cota de cuatro rachas y control de refutación

Propuesta pendiente. Para \(H\in\{66,67,92,107,146,170\}\), si \(x\) es impar positivo y \(x+1<2^H\), sean \(D_i\) las entradas impares acumuladas hasta la \(i\)-ésima racha impar. Basta acreditar
\[
D_4\le(1+\alpha)H,\qquad \alpha=\log_2 3.
\]
El cálculo racional verifica que esas seis alturas son suficientes, reutilizando las tres rachas ya certificadas para los demás rangos. En los dos pares de Weaver, las alturas recuperan los objetivos y los topes estrictos de fuente publicados, incluyendo el rango extra 88. En el doble se recupera \(x_{[3]}+1<2^{66}\) y \(66(G_{84}+2)<d\).

La recurrencia \(D_{i+1}<H+\alpha D_i\) da \(HG_{t-2}\) a partir de \(t=4\) si la propuesta se demuestra. En cada rango donde se necesita esa mejora hay menos de \(88/3\) raíces, así que al menos un segmento tiene longitud \(L\ge4\). Los incrementos de ese segmento al absorber otro segmento son desde \(\alpha^2H\). Esto domina el aporte de un segmento de longitud 2, 3 o 4 más allá de dejarle una raíz de presupuesto \(H\), usando las cotas cortas ya disponibles. Para segmentos de longitud \(t\ge5\), el crecimiento geométrico permite comparar sus incrementos término a término. Se recupera así el sobre de 86 sin suponer convexidad adicional en \(t=1,2,3,4\).

El control de refutación comprueba en las seis alturas todos los levantamientos únicos con \(D_2>H\), y además todos los cofactores impares de las ocho capas \(a_1=H-8,\ldots,H-1\) que no estén ya en \(D_2>H\). La comparación física es \(2^{D_4}\le6^H\), sin aproximar \(\alpha\). No aparecen violaciones. Los máximos \(D_4\) observados para las seis alturas son \(78,78,103,118,160,182\). Para \(D_3\le H\), la recurrencia da la cota sin búsqueda. La parte sin cubrir es \(D_3>H,\ D_2\le H\) fuera de esas ocho capas.

Una opción simbólica para esa parte es fijar \(a_1,b_1,a_2,b_2\) y exigir que la tercera racha mida al menos \(H+1-a_1-a_2\). Escribiendo \(x+1=2^{a_1}u\), se obtiene la congruencia necesaria
\[
3^{a_1+a_2}u
\equiv 2^{b_1+a_2}(1-2^{b_2})-3^{a_2}(2^{b_1}-1)
\pmod {2^{b_1+b_2+H+1-a_1}}.
\]
Proviene de \(3^{a_1}u+(2^{b_1}-1)=2^{b_1+a_2}v\) y de la divisibilidad de \(3^{a_2}v+(2^{b_2}-1)\) en la segunda transición. El módulo es mayor que el dominio \(1\le u<2^{H-a_1}\). Queda a lo sumo un candidato por cuádrupla. La poda y la comprobación exhaustiva de ese conjunto son tareas abiertas.

## Reproducción

Desde la raíz del proyecto:

`python3 -O experiments/COLLATZ_ECO_20261125/TERRAS88_check.py`

El verificador reutiliza las funciones de logaritmos, criba y cotas de `verify_ranked_path.py` del dossier 87. La criba 88, las inclusiones y los controles arriba descritos terminaron con código 0. El resultado cerrado de esta ronda es la reducción a los tres pares heredados con \(\Delta=1\).
