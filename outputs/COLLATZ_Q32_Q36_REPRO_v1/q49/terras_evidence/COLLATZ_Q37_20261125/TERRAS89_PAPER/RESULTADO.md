# Terras 89 · Reducción a Q0 con desplazamiento uno

**Reducción en papel con aritmética exacta.** Si falla el descenso en el primer cruce finito del coeficiente y el prefijo tiene a lo sumo 89 rachas impares máximas, después de Terras 88 sólo hay que estudiar exactamente 89 rachas. La presente reducción elimina seis de los siete pares de relojes de la criba y elimina todos los desplazamientos de al menos dos para el séptimo. El caso pendiente es el par Q0 con extremo exactamente \(N+1\). [Cierre Terras 88](../../COLLATZ_ECO_20261125/TERRAS88_CIERRE.md) · [Recibo Weaver](../../COLLATZ_TERRAS_87_RUNS_20261125/WEAVER_REPLAY_20261125/RECIBO.json)

## Reducción aritmética

Se usa el mapa abreviado \(T(x)=x/2\) para \(x\) par y \(T(x)=(3x+1)/2\) para \(x\) impar. Sea \(k\) el primer instante con \(3^d<2^k\), con \(d\) el número de entradas impares hasta ese instante. La semilla par desciende en el primer paso. En el caso impar, todos los estados anteriores a \(k\) son al menos \(N\), por el coeficiente afín y el aditivo no negativo. Un extremo igual a \(N\) daría un ciclo no trivial con a lo sumo 89 mínimos locales, excluido por Hercher y su corrección. Por tanto basta estudiar \(\Delta=T^k(N)-N\ge1\) y \(N>B=28\cdot10^{18}\). [Hercher y corrección](https://cs.uwaterloo.ca/journals/JIS/VOL26/Hercher/hercher5.html) · [Rozier–Terracol, corolario 5.4 y proposición 6.3](https://arxiv.org/pdf/2502.00948v5)

Sea \(\Lambda=k\ln2-d\ln3\) y \(\alpha=\log_2 3\). Se conservan \(N\Lambda<89\), \(k\le 2d\) y \(d\le G_{89}\log_2(N+1)\), donde \(G_t=\sum_{i=0}^{t-1}\alpha^i\). Por Rhin, \(\Lambda\ge k^{-13,3}\). Si \(2^j\le d<2^{j+1}\), entonces \(\log_2(N+1)<7+13,3(j+2)\). Para \(j=70\), la cota superior racional de \(G_{89}\bigl(7+13,3(70+2)\bigr)\) queda por debajo de \(2^{70}\). Al incrementar \(j\), el paréntesis crece menos de un factor dos. Así \(d<2^{70}\).

El verificador usa la base unimodular de Terras 88, conserva tanto los pares primitivos como los múltiplos y redondea por exceso las contribuciones recíprocas. El límite del coeficiente positivo de la base es 2.797. La ventana de logaritmos racionales retiene 5.413 pares antes de aplicar el sobre ordinario de valles, que deja los siete siguientes.

| Par | \((k,d)\) | \(\Delta=1\) | \(\Delta\ge2\) |
| --- | --- | --- | --- |
| Q0 | (630118245525664765, 397560349370386783) | **Pendiente** | Weaver Q0 |
| \(2\mathrm{Q0}\) | (1260236491051329530, 795120698740773566) | Contradicción de recíprocos | La misma contradicción |
| Q1 | (7354673373747273033, 4640282259296926456) | Weaver Q0 | La misma inclusión |
| P | (7984791619272937798, 5037842608667313239) | Contradicción de recíprocos | La misma contradicción |
| \(2\mathrm{Q1}\) | (14709346747494546066, 9280564518593852912) | Weaver Q0 | La misma inclusión |
| \(3\mathrm{Q1}\) | (22064020121241819099, 13920846777890779368) | Contradicción de recíprocos | La misma contradicción |
| J | (43497921996957973433, 27444133206411171953) | Contradicción de recíprocos | La misma contradicción |

## Exclusiones con los certificados existentes

Sean \(x_{[i]}\) los inicios de racha ordenados con multiplicidad, con \(x_{[1]}=N\). Se reutilizan las capacidades verificadas de dos, tres y cuatro rachas de Terras 87 y 88. Si el rango \(p\) está en la ventana \(x_{[p]}+1<2^H\), la capacidad ordinaria es \(H(G_{89-p+1}+p-1)\). Con capacidad de tres rachas y \(p\le87\), es \(H(G_{88-p+1}+p-1)\). Con capacidad de cuatro y \(89>3p\), es \(H(G_{87-p+1}+p-1)\), por absorción de segmentos. Cada comparación estricta de \(d\) por encima de la capacidad fuerza el suelo \(x_{[p]}\ge2^H-1\). La recurrencia de alturas y la comparación de capacidades usan siempre una cota racional superior de \(\alpha\).

Para cualquier \(\Delta\ge1\), el desplazamiento del mismo \(N\) deja

\[
\Lambda<\frac1{B(B+1)}+\sum_{i=2}^{89}\frac1{x_{[i]}}.
\]

Esta desigualdad es la que se contradice directamente para \(2\mathrm{Q0},P,3\mathrm{Q1},J\). Para Q0 con \(\Delta\ge2\), la cota \(N+1<2^{72}\) permite descontar los dos primeros términos, usando \(4/(B+2)<(2/3)^{72}\) y el crédito reforzado de Terras 88. Se conserva \(\Lambda<\sum_{i=3}^{89}1/x_{[i]}\).

Para extraer un tramo, sea \(q\in\{1,2\}\) el número de rangos descontados, con corrección \(c=1/(B(B+1))\) cuando \(q=1\) y cero cuando \(q=2\). Dada la cota inferior racional \(\lambda_-\) de \(\Lambda\) y suelos \(H_i\), se calcula

\[
\eta=\lambda_--c-\frac{\ell-q-1}{B}-\sum_{i=S}^{89}\frac1{\max(B,2^{H_i}-1)}.
\]

La comprobación \(\eta>0\) y \(U\eta\ge S-\ell\) da \(x_{[\ell]}<U\). Con \(89>\ell(R-\ell)\), la extracción cronológica de Weaver da un tramo de a lo sumo \(R-\ell\) bloques completos. El tramo tiene fuente \(z\) con \(B<z<U\), valles intermedios al menos \(z\) y extremo al menos \(x_{[R]}\). Se usa la misma consulta Q0 en las tres filas. Su exclusión de segmentos depende de las condiciones sobre el tramo, así que se aplica igualmente cuando el par de relojes global es Q1 o su doble. [Weaver, lema 5 y §6](https://rstation.ai/problems/collatz/papers/143)

| Caso | \((q,\ell,S,R)\) | Cota estricta \(U\) | Suelo del extremo | Bloques completos |
| --- | --- | ---: | ---: | ---: |
| Q1, \(\Delta\ge1\) | (1, 2, 6, 7) | 148321243831049467988 | \(2^{170}-1\) | 5 |
| \(2\mathrm{Q1}\), \(\Delta\ge1\) | (1, 2, 4, 7) | 42408176569367664067 | \(2^{170}-1\) | 5 |
| Q0, \(\Delta\ge2\) | (2, 7, 11, 12) | 453027402666008300801 | \(2^{146}-1\) | 5 |

## Primera prueba pendiente

En Q0 con \(\Delta=1\), los suelos disponibles en rangos 10 y 11 son de alturas 23 y 92. Para \((\ell,S,R)=(6,10,11)\), falta recuperar los suelos \(x_{[10]}\ge2^{92}-1\) y \(x_{[11]}\ge2^{146}-1\). El presupuesto actual es negativo para esa elección. La comprobación de todos los índices de la misma plantilla de transferencia tampoco devuelve una inclusión en las dos consultas ya reproducidas.

Basta demostrar la capacidad de cinco rachas \(D_5(x)\le(1+\alpha)H\) para positividad impar y \(x+1<2^H\), en las dos ventanas \(H=92,146\). Condicionalmente, la recurrencia de alturas daría capacidad local \(HG_{t-3}\) para \(t\ge5\). Como \(89>4p\) en los rangos 10 y 11, existe un segmento de longitud al menos cinco. Sus incrementos desde \(H\alpha^2\) absorben los de cualquier otro segmento dejando una racha por raíz, incluidos los incrementos nulos al pasar de tres a cuatro y de cuatro a cinco. La capacidad global resultante permite forzar ambas alturas. El resto de la cola usa los certificados actuales. Se verifica entonces \(\eta>0\) y \(453027402666008300866\eta\ge4\), con extremo al menos \(2^{146}-1\) y cinco bloques. Esto recuperaría la consulta Q0 de Weaver con su tope estricto exacto.

Una capacidad hipotética de cinco rachas en \(H=69\), por sí sola, no recupera la consulta. Tampoco basta añadir sólo una de las dos alturas 92 y 146 en esta plantilla. La primera obligación programable es la proyección de \(D_5\) a \(H=92\), empezando por el complemento \(D_4>92\), ya que \(D_4\le H\) implica \(D_5<H+\alpha D_4\le(1+\alpha)H\). La comparación en los candidatos físicos es la desigualdad entera \(2^{D_5}\le6^H\). Después queda la ventana 146 o una prueba alternativa del suelo del rango 11. Puede reutilizarse la proyección general de Marshall. [Marshall, teorema R](https://raw.githubusercontent.com/LeeMarshall1113/collatz-m-cycles/4c5dfafd/METHOD.md)

## Reproducción y alcance

Desde la raíz del proyecto, ejecutar `python3 -B experiments/COLLATZ_Q37_20261125/TERRAS89_PAPER/check.py`. El programa fija por SHA-256 los dos recibos y los dos archivos aritméticos heredados. Recalcula la criba, los presupuestos, las inclusiones y las implicaciones condicionales. Conserva los libros del mismo \(N\). Las búsquedas de capacidades y de Weaver se consumen como insumos sellados. [Verificador](check.py) · [Salida](VERIFICACION.txt) · [Recibo](RECIBO.json)

Quedan pendientes Q0 con \(T^k(N)=N+1\), la formalización de esta reducción y la existencia del primer cruce para toda semilla. El verificador no ejecuta búsquedas de órbitas ni evalúa las dos capacidades hipotéticas de cinco rachas.
