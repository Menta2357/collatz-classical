# Terras 88 · capacidad a H=170 e inclusión de Q1

**Q1 queda excluido también cuando la diferencia final es uno.** Para todo impar positivo \(x\) con \(x+1<2^{170}\), el total \(D_4\) de pasos impares de las cuatro primeras rachas satisface \(D_4\le170(1+\log_2 3)\). Junto con las capacidades ya verificadas a \(H=67,107\), esto recupera exactamente el dominio de la exclusión reproducida Q1 de Weaver. Sólo queda Q0 con \(\Delta=1\) en la reducción de Terras 88. [Cotas a \(H=66,67\)](TERRAS88_four_runs_66_67.md) · [Cota a \(H=107\)](TERRAS88_four_runs_107.md)

## Proyecciones exactas

Se conservan las cotas superiores \(P_1,Z_1,P_2\) del algoritmo de \(H=66,67\), y \(a,b,c,d\) siguen siendo las dos longitudes de las primeras rachas impares y los dos huecos pares respectivos, en el orden físico \(a,b,c,d\). El caso \(D_3\le H\) se cubre por la misma recurrencia analítica.

Escribimos \(x+1=2^a u\), con \(1\le u<2^E\), \(E=H-a\). En tres puntos, una proyección más corta ya identifica el único cofactor posible y permite evaluar directamente sus valoraciones efectivas.

1. Si \(b+1\ge E\), se cumple \(3^a u\equiv1+2^b\pmod{2^{b+1}}\), porque la primera valoración de la parte par vale \(b\) exactamente. Se obtiene un solo \(u\) y se calculan todas sus rachas. Esto incluye la rama \(D_2>H\).
2. En caso contrario, se conserva el test de \(D_2>H\) del certificado anterior. Para \(D_2\le H\), si \(b+c+1\ge E\) se cumple \(3^a u\equiv2^{b+c}+1-2^b\pmod{2^{b+c+1}}\), ya que la siguiente longitud impar es \(c\). La proyección fija \(u\). Se calcula su segundo hueco par y se exige que esté en el intervalo permitido por la altura y que \(D_3>H\).
3. Cuando \(b+c+1<E\), sea \(I\) el inverso ancho de \(3^{a+c}\). La expresión CRT para \(D_3>H\) es el representante modular de
   \[
   I\bigl(2^{b+c}-3^c(2^b-1)\bigr)-I\,2^{b+c+d}.
   \]
   Para \(d<E-b-c\), se siguen verificando los huecos individualmente. Para todo \(d\ge E-b-c\), el segundo término se anula módulo \(2^E\). El primer término, reducido módulo \(2^E\), es entonces la única posibilidad dentro del intervalo de \(u\), para todos esos huecos a la vez. Se evalúa su \(d\) físico exacto y se exige que pertenezca al intervalo de la cola y que \(D_3>H\).

Estas proyecciones conservan todo contraejemplo posible de la enumeración de cuádruplas. Se verifican físicamente las cuatro rachas completas para cada superviviente y se exige \(2^{D_4}\le6^H\). El cotejo de regresión con \(H=66\) reprodujo exactamente los 31 casos \(D_2>H\), los 1.075 casos restantes \(D_3>H\), el máximo 80 y su misma semilla. Duró 0,424 s.

| Recorrido para \(H=170\) | Recuento |
|---|---:|
| Proyecciones del primer hueco | 23.019 |
| Proyecciones de la segunda racha | 474.174 |
| Proyecciones de la cola del segundo hueco | 511.666 |
| Huecos comprobados individualmente | 21.813.836 |
| Cofactores físicos con \(D_2>H\) | 73 |
| Otros cofactores físicos con \(D_3>H\) | 7.209 |

El máximo \(D_4\) en \(D_3>H\) fue 189, alcanzado en \(x=279005552485156698445481064812348958928172129042431\) y \(x=558011104970313396890962129624697917856344258084863\). Tiempo observado de 21,509 s en un solo proceso de Python optimizado y salida 0.

## Comparación estricta con la consulta Q1 reproducida

Para \(k=7354673373747273033\) y \(d=4640282259296926456\), el perfil de alturas se comprueba con \(\alpha\) racionalmente acotada por exceso. Las cotas de cuatro rachas a \(H=67,107,170\) recuperan las cotas de los rangos 4, 5 y 6, respectivamente. Las capacidades de tres rachas de \(H=170,256\) certificadas en 87 bastan para los rangos 7 y 8. Por monotonía todos los rangos desde 8 tienen altura al menos \(2^{256}-1\). Así, para \(\Delta=1\), el término recíproco desde el rango 4 se acota superiormente por
\[
\mathcal S=\frac1{2^{67}-1}+\frac1{2^{107}-1}+
\frac2{2^{170}-1}+\frac{81}{2^{256}-1}.
\]
Se conserva el término de origen \(1/(B(B+1))\), con \(B=28\cdot10^{18}\). Si \(\Lambda_{\rm inf}\) es la cota racional inferior de \(\Lambda\), la holgura exacta \(\delta=\Lambda_{\rm inf}-1/(B(B+1))-\mathcal S\) satisface \(\delta>0\) y \(U\delta\ge2\) para \(U=99048017070889459170\). En particular, \(x_{[2]}<2/\delta\le U\). La transferencia con \((\ell,S,R)=(2,4,6)\) fuerza un tramo de a lo sumo cuatro bloques completos, fuente \(B<x<U\), altura objetivo al menos \(2^{170}-1\) y valles intermedios al menos iguales a la fuente. Q1 excluye exactamente ese tramo. [Consulta original](https://rstation.ai/problems/collatz/papers/143) · [Reproducción](../COLLATZ_TERRAS_87_RUNS_20261125/WEAVER_REPLAY_20261125/RECIBO.json)

## Reproducción

Desde la raíz del proyecto:

`python3 -O experiments/COLLATZ_ECO_20261125/TERRAS88_four_runs_107_170.py 170`

`python3 -O experiments/COLLATZ_ECO_20261125/TERRAS88_four_runs_107_170.py q1`

La segunda orden comprueba la inclusión aritmética a partir de las capacidades, sin repetir sus enumeraciones. Quedan pendientes la auditoría independiente de este código y la formalización en Lean. El resultado usa las exclusiones publicadas ya reproducidas y sus hipótesis originales.
