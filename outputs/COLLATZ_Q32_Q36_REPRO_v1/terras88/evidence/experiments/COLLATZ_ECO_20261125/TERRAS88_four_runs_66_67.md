# Terras 88 · cuatro rachas en H=66 y H=67

**Resultado en papel y verificación exhaustiva.** Para \(H=66,67\), todo impar positivo \(x\) con \(x+1<2^H\) tiene a lo sumo \(H(1+\log_2 3)\) pasos impares en sus primeras cuatro rachas. En Terras 88 con \(\Delta=T^k(n)-n=1\), esta cota elimina el doble de Q1. Sólo quedan los pares Q0 y Q1, con diferencia final exactamente uno. [Reducción y reloj](TERRAS88_PAPER.md)

## Cobertura de la comprobación

Sean \(D_i\) los pasos impares acumulados hasta el final de la \(i\)-ésima racha. Si \(D_3\le H\), la recurrencia de altura de Terras 87 ya da \(D_4<H+(\log_2 3)D_3\). Para \(D_3>H\), escribimos \(x+1=2^a u\) con \(a\) la primera longitud impar y \(1\le u<U=2^{H-a}\) impar.

Si \(D_2>H\), con \(b\) la primera longitud par, el cofactor satisface
\[
3^a u\equiv1-2^b\pmod {2^{b+H+1-a}}.
\]
El módulo supera \(U\), así que basta examinar el representante único.

Si \(D_2\le H\), fijamos la segunda longitud impar \(c\) y el segundo hueco par \(d\). La tercera longitud impar debe ser al menos \(q=H+1-a-c\ge1\). La congruencia necesaria es
\[
3^{a+c}u\equiv2^{b+c}(1-2^d)-3^c(2^b-1)
\pmod {2^{b+d+H+1-a}}.
\]
Su módulo también supera \(U\). Para contener todas las cuádruplas físicamente realizables, ponemos
\[
P_1=3^a(U-1)-1,\qquad
Z_1=\left\lfloor P_1/2^b\right\rfloor+1,\qquad
P_2=3^c\left\lfloor Z_1/2^c\right\rfloor-1.
\]
El primer pico es \(\le P_1\), la primera entrada impar desplazada es \(\le Z_1\) y el segundo pico es \(\le P_2\). Por tanto \(2^b\le P_1\), \(a+c\le H\), \(2^c\le Z_1\) y \(2^d(2^q-1)\le P_2\). Estas desigualdades enteras acotan los cuatro bucles. Cada inversa ancha de una potencia de 3 se calcula una sola vez y se enmascara al módulo requerido por el caso.

Para cada cofactor retenido se vuelven a calcular las cuatro rachas físicas a partir de \(x=2^a u-1\). La condición final se comprueba con \(2^{D_4}\le6^H\), usando enteros.

| \(H\) | Cuádruplas acotadas | Casos \(D_2>H\) | Otros casos \(D_3>H\) | Máximo \(D_4\) en \(D_3>H\) | Semilla que lo alcanza |
|---:|---:|---:|---:|---:|---:|
| 66 | 4.549.984 | 31 | 1.075 | 80 | 48366890319230271487 |
| 67 | 4.838.442 | 26 | 1.117 | 81 | 136500350603535319039 |

## Exclusión del doble con diferencia final uno

Para \((k,d)=(14709346747494546066,9280564518593852912)\), Terras 87 aporta las capacidades de tres rachas en \(H=67,107\). Con \(m=88\) ellas dan \(x_{[4]}\ge2^{67}-1\) y \(x_{[5]}\ge2^{107}-1\). En el sobre de recíprocos de \(\Delta=1\), se mantiene la corrección de la fuente \(1/(B(B+1))\), se acota el segundo sumando por \(1/B\) y se acotan los 84 términos desde el quinto por \(1/(2^{107}-1)\). La holgura racional verifica
\[
x_{[3]}+1<87363476288193384446<2^{67}.
\]
Al partir las rachas en esos tres inicios bajos, al menos un segmento tiene longitud \(\ge 4\). La nueva capacidad para \(H=67\) permite concentrar allí las longitudes restantes, conservando una raíz por cada segmento. Se obtiene
\[
d\le67(G_{84}+2)<7253407288532299132<9280564518593852912.
\]
La contradicción elimina el tercer par heredado, sin necesitar otras capacidades de cuatro rachas.

## Verificación

Desde la raíz del proyecto:

`python3 experiments/COLLATZ_ECO_20261125/TERRAS88_four_runs_66_67.py 66`

`python3 -O experiments/COLLATZ_ECO_20261125/TERRAS88_four_runs_66_67.py 67`

Los recorridos certificados tardaron 1,971 s y 1,820 s, respectivamente, en el primer ensayo. Las desigualdades del doble se verificaron con la cota racional de \(\alpha\) y el intervalo de \(\Lambda\) importados del dossier 87. Los programas anteriores de criba y las búsquedas de Weaver no se reejecutaron. Esta unidad no contiene nueva formalización Lean ni alcanza el teorema Terras 88.
