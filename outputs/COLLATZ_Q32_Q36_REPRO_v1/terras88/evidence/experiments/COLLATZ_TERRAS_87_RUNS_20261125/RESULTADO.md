# Descenso en el primer cruce de Terras con hasta 87 rachas impares

**Resultado.** En el mapa abreviado de Collatz, sea \(\tau(n)\) el primer paso cuyo coeficiente \(3^d/2^k\) baja de uno. Para todo entero \(n\ge2\) con \(\tau(n)<\infty\), si el prefijo hasta \(\tau(n)\) contiene a lo sumo **87 rachas máximas impares**, entonces \(T^{\tau(n)}(n)<n\). La prueba extiende en una racha el dominio del teorema 1 de Weaver. Reutiliza sus dos exclusiones finitas de trayectorias crecientes como insumos publicados. El aporte nuevo recupera las alturas de la prueba de 86 al añadir una racha, mediante un certificado exacto de tres rachas. [Weaver, teorema 1 y secciones 5–6](https://rstation.ai/problems/collatz/papers/143)

## 1. Reloj y reducción

Se toma \(T(x)=x/2\) para \(x\) par y \(T(x)=(3x+1)/2\) para \(x\) impar. El reloj \(k\) cuenta las aplicaciones de \(T\), \(d\) cuenta sólo las de entrada impar y \(m\) cuenta rachas máximas impares. Una racha más su siguiente tramo par es un bloque. El tramo par final puede quedar truncado en \(\tau(n)\).

Si \(n\) es par, la afirmación vale en el primer paso. Supongamos \(n\) impar y un fallo \(T^k(n)\ge n\) en \(k=\tau(n)\) con \(m\le87\). Hasta \(k-1\) todos los estados son \(\ge n\) por la fórmula afín con coeficiente \(\ge1\) y aditivo no negativo. La igualdad \(T^k(n)=n\) daría un ciclo no trivial con a lo sumo 87 mínimos locales, excluido por Hercher con su corrección publicada. Considérese por tanto \(T^k(n)>n\). Por el rango verificado, \(n>B=28\cdot10^{18}\). [Hercher y corrección](https://cs.uwaterloo.ca/journals/JIS/VOL26/Hercher/hercher5.html) · [Rozier–Terracol, corolario 5.4](https://arxiv.org/pdf/2502.00948v5)

Escribamos \(\alpha=\log_2 3\), \(G_t=\sum_{i=0}^{t-1}\alpha^i\), \(k=\lceil\alpha d\rceil\le2d\) y \(\Lambda=k\ln2-d\ln3>0\). El término aditivo normalizado aporta menos de uno por racha antes del cruce, por lo que \(n\Lambda<m\le87\). Una racha impone \(a=\nu_2(x+1)\) a su estado inicial \(x\). Además \(x+1\) se multiplica por \(3/2\) en cada entrada impar y disminuye en cada entrada par. Si \(x+1<2^H\), después de \(D\) entradas impares la siguiente racha produce un total \(D_{\rm nuevo}<H+\alpha D\). En particular \(d\le G_m\log_2(n+1)\) para el prefijo entero. Rhin da \(\Lambda\ge k^{-13,3}\). Si \(2^j\le d<2^{j+1}\) y \(j\ge69\), las cotas anteriores dan \(d<G_{87}(7+13,3(j+2))<2^j\). El certificado verifica la última comparación en \(j=69\), y el lado izquierdo crece por un factor menor que dos al aumentar \(j\). Resulta \(d<2^{69}\). [De Jesús, comparador afín](https://hexagonmath.org/pdf/2611.00459) · [Rhin, citado por Rozier–Terracol, proposición 6.3](https://arxiv.org/pdf/2502.00948v5)

## 2. Criba exacta y relación con la semilla

Ordenemos los \(m\) inicios de bloque, con multiplicidades, como \(x_{[1]},\ldots,x_{[m]}\), incluyendo el inicio \(n\) en el empate por el mínimo. La partición cronológica por los \(r\) menores inicios y la convexidad discreta de \(G_t\) dan
\[
\log_2(x_{[r]}+1)\ge \frac{d}{G_{m-r+1}+r-1}.
\]
El extremo final es al menos \(n+1\). En la identidad logarítmica de la órbita, el aporte del bloque iniciado en \(x_{[r]}\) es inferior a \(1/x_{[r]}\), por la suma geométrica de los recíprocos de sus estados impares. El incremento real descuenta \(\ln(T^k(n)/n)>1/(n+1)\). Por tanto
\[
0<\Lambda<\frac{1}{B(B+1)}+\sum_{r=2}^m \frac{1}{x_{[r]}}.
\]
Todo se refiere al prefijo físico de un mismo \(n\). [Weaver, lema 3 e identidad del extremo](https://rstation.ai/problems/collatz/papers/143)

Para enumerar \((k,d)\) usamos el convergente inferior IV de De Jesús \(p/q=423372672964960618/267118416222671843\). Es coprimo y, poniendo \(e=q\ln3-p\ln2>0\), se cumple \(h\ln2=q\Lambda+de\) para \(h=qk-pd\). El intervalo \(0<\Lambda<87/B\) y \(d<2^{69}\) implica \(1\le h\le1399\). Para cada \(h\) se recorre la clase \(d\equiv-hp^{-1}\pmod q\) hasta el límite estricto. El primer verificador usa también el convergente I para omitir \(d\le128000000000000000\). El segundo parametriza la misma red por una base unimodular sin esa omisión.

Para cada \((k,d)\) compatible se aplica la cota de recíprocos anterior. Si \(H_r\) es el suelo de \(d/(G_{87-r+1}+r-1)\) calculado con \(\alpha\) acotado por exceso, se permite reducirlo hasta un tope fijo. Se sustituye cada \(x_{[r]}\) por \(\max(B,2^{H_r}-1)\). Las dos implementaciones independientes dejan exactamente tres pares.

| \(k\) | \(d\) | Procedencia |
|---:|---:|---|
| 630118245525664765 | 397560349370386783 | Primer par de Weaver |
| 7354673373747273033 | 4640282259296926456 | Segundo par de Weaver |
| 14709346747494546066 | 9280564518593852912 | Doble del segundo par |

## 3. Capacidad de tres rachas en una ventana exacta

El certificado verifica para \(H\in\{66,67,92,107,146,170,231,256\}\) que, desde cualquier \(x\) impar positivo con \(x+1<2^H\), las primeras dos rachas suman como máximo \(3H/2\), y las tres primeras suman como máximo \((1+\alpha)H\). En efecto, si las dos primeras suman \(D_2\le H\), la recurrencia anterior da \(D_3<H+\alpha D_2\). Si \(D_2\ge H+1\), escribimos \(x+1=2^a u\), con \(u\) impar y \(1\le u<2^{H-a}\). La primera racha termina en \(3^a u-1\) y la racha par siguiente tiene longitud exacta \(b\). La segunda racha impar tiene al menos \(H+1-a\) entradas. Su divisibilidad impone
\[
u\equiv(1-2^b)(3^a)^{-1}\pmod{2^{b+H+1-a}}.
\]
Como \(2^b\le 3^a u-1<3^H\), basta un rango finito de \(b<\alpha H\). El módulo es mayor que el intervalo de \(u\). Cada par \((a,b)\) aporta a lo sumo un \(u\), para el cual se comprueban el hueco par y las siguientes dos rachas exactas. Sólo se examinan los representantes de las congruencias, sin enumerar todas las semillas de cada ventana. Un segundo verificador prueba este mismo paso con la coordenada global \(x+1\).

Para un segmento de \(t\) rachas iniciado en la ventana, la capacidad es
\[
F_H(1)=H,\qquad F_H(2)=3H/2,\qquad F_H(t)=HG_{t-1}\quad(t\ge3).
\]
El caso \(t=3\) es el certificado anterior. Los demás se obtienen por \(D_{\rm nuevo}<H+\alpha D\). \(F_H\) es creciente y discretamente convexa: sus primeros incrementos son \(H/2\), \(H(\alpha-1/2)\), \(H\alpha^2\), y los posteriores crecen por un factor \(\alpha>1\).

Si \(x_{[r]}+1<2^H\), la partición por los \(r\) inicios menores tiene capacidad total como máximo \(F_H(87-r+1)+(r-1)H\), incluso si \(m<87\). Las raíces incluyen \(n\) y cada segmento cuenta su propia raíz, de modo que todos tienen longitud positiva. Para \(r\le85\), esto es \(H(G_{86-r+1}+r-1)\). Por tanto una comparación estricta de \(d\) con esta capacidad recupera el mismo suelo de alturas que a 86 rachas. Para los dos últimos rangos se usan las capacidades de longitud uno y dos.

## 4. Cierre de los tres pares

**Doble.** La cota ordinaria fuerza \(x_{[4]}\ge2^{85}-1\). El cociente logarítmico y la cota de recíprocos implican \(x_{[3]}+1<2^{66}\). En concreto, si
\[
\delta=\underline\Lambda-\frac1B-\frac1{B(B+1)}-\frac{84}{2^{85}-1},
\]
entonces \(\delta>0\) y \(x_{[3]}<1/\delta<2^{66}-1\). Partir en los tres inicios menores con la capacidad de tres rachas obliga \(d\le66(G_{84}+2)<9280564518593852912\), contradicción. La verificación independiente también excluye este par usando la capacidad de dos rachas de Alick. [Alick, formalización de dos rachas](https://github.com/justinalick/collatz-m-cycles-101-lean/blob/d1895945/Collatz/MCycleTwoRiseHi2.lean)

**Pares heredados.** Se aplica la cota reforzada al rango \(R\) y a cada rango de la cola \(S,\ldots,m\). En la cota de recíprocos, los rangos \(2,\ldots,\ell-1\) aportan a lo sumo \((\ell-2)/B\), y \(\ell,\ldots,S-1\) aportan a lo sumo \((S-\ell)/x_{[\ell]}\). Las comprobaciones racionales, incluyendo el término adicional del rango 87, dan las condiciones siguientes.

| Par | \(\ell\) | \(S\) | \(R\) | Cota superior inclusiva de \(x_{[\ell]}\) | Cota inferior de \(x_{[R]}\) | Bloques |
|---|---:|---:|---:|---:|---:|---:|
| Primero | 6 | 10 | 11 | 453027402666008300865 | \(2^{146}-1\) | \(\le5\) |
| Segundo | 2 | 4 | 6 | 99048017070889459169 | \(2^{170}-1\) | \(\le4\) |

El lema 2 de Weaver, \(d<2^{m+10}\), fuerza que existen esos rangos y \(m>\ell(R-\ell)\). Los inicios que quedan al quitar los \(\ell\) menores forman a lo sumo \(\ell\) cadenas. Alguna tiene \(R-\ell\) miembros o más, y entre sus primeros \(R-\ell\) miembros alguno alcanza la cota inferior certificada de \(x_{[R]}\). El inicio anterior a la cadena es uno de los \(\ell\) menores. Así surge una trayectoria de bloques completos desde un impar \(z>B\) a lo sumo igual a la cota superior de la tabla, con todos los valles intermedios \(\ge z\), hasta la altura especificada. Cada fila pertenece al dominio de la exclusión publicada correspondiente. [Weaver, lemas 2 y 5 y exclusiones de la sección 6](https://rstation.ai/problems/collatz/papers/143)

Los tres casos se contradicen. Como antes del cruce el coeficiente era al menos uno, ese cruce es también el primer descenso real.

## Evidencia y límites

El verificador principal trata \(m\le87\) y el segundo coteja las inclusiones para el caso nuevo \(m=87\). Las comparaciones logarítmicas usan la serie \(2\sum_{i\ge0}z^{2i+1}/(2i+1)\) con \(z=(x-1)/(x+1)\). Tras \(p\) términos la cola es menor que \(2z^{2p+1}/((2p+1)(1-z^2))\). La capacidad de tres rachas se comprueba por dos coordenadas independientes. Los verificadores sólo usan aritmética exacta.

El resultado conserva la condición de que el primer cruce exista. Los dos descartes de trayectorias de la tabla se importan del manuscrito público y quedan pendientes de reproducción integral en este proyecto. Su revisión pública informa reproducción completa de los cómputos del segundo y parcial de los del primero. El teorema de 87 rachas queda pendiente de formalización Lean y revisión externa. La búsqueda halló 86 como máximo público comparable. [Alcance de la revisión pública y suplemento](https://rstation.ai/r/collatz/posts/73)
