# Q0 con desplazamiento uno · Segundo valle y corte de relojes

Sea \(M=x_{[2]}=T^K(N)\), con \(B<N<M<35\cdot10^{18}\), en la trayectoria hipotética Q0 de 89 rachas. Sean \(D\) las entradas impares del tramo \(N\to M\). Las dos anclas son valles físicos de esa misma trayectoria. **Uno de los dos tramos \(N\to M\) y \(M\to N+1\) tiene a lo sumo 9 rachas y 2.706 entradas impares. El otro tiene al menos 80 rachas.** En particular no hace falta tratar un reparto central de los relojes. [Corte de los dos valles](RESULTADO.md) · [Recibo del corte cronológico](RECIBO_SHORT_SPLIT.json)

## Segundo valle y primer cruce del sufijo

Todo estado posterior a \(N\) y anterior a \(N+1\), salvo \(M\), supera \(M\). En la primera racha, el primer paso es mayor que \(3N/2>M\). Las demás rachas parten de un valle al menos igual a \(M\), y sus estados impares crecen. Un estado par anterior al siguiente valle es al menos el doble de ese valle. En el último tramo par hasta \(N+1\), los estados anteriores al terminal son al menos \(2(N+1)>M\). Los valles son distintos por el argumento de no repetición ya acreditado.

Escribimos \(g_i=3^{d_i}/2^i\) y \(T^i(N)=g_i(N+C_i/3^{d_i})\). El aditivo normalizado \(C_i/3^{d_i}\) no disminuye. Para \(0<i<K\), el numerador físico supera \(M\) y el denominador normalizado no supera el del instante \(K\). Así \(g_i>g_K\).

El sufijo físico desde \(M\) termina en \(N+1<M\) y su coeficiente final es \(g_k/g_K<1\). Por ello su primer cruce existe y tiene a lo sumo 88 rachas. Terras 88 implica que ese cruce es su primer descenso, en el instante absoluto \(k\). Luego también \(g_i>g_K\) para \(K<i<k\). Así \(K\) es el único mínimo entre los índices \(1,\ldots,k-1\), con \(1<g_K<M/N<5/4\), y \(K=\lfloor D\log_2 3\rfloor\). [Terras 88](../../COLLATZ_ECO_20261125/TERRAS88_CIERRE.md)

Los aditivos \(C_A,C_B\) de los dos tramos conservan las identidades
\[
 2^K M=3^D N+C_A,\qquad
 2^{k-K}(N+1)=3^{d-D}M+C_B,\qquad
 C=3^{d-D}C_A+2^K C_B.
\]
Los relojes del primer cruce no se sustituyen por los del tramo local.

## Capacidad de las dos partes

En ambas anclas se tiene \(x+1<2^{65}\). La capacidad sellada en \(H=66\) da \(D_4\le66(1+\alpha)\), donde \(\alpha=\log_2 3\). Cubre también las primeras tres rachas por monotonía del número de entradas impares. Después, \(D_{j+1}<65+\alpha D_j\), pues \(x+1\) se multiplica por \(3/2\) en un paso impar y disminuye en uno par. La cuenta de la última racha permanece válida si se trunca el hueco par final. Con \(\alpha_+>\alpha\) racional de Q37 y \(G_t=\sum_{i<t}\alpha_+^i\), se obtiene la cota estricta
\[
F(m)=65G_{\max(0,m-4)}+66(1+\alpha_+)\alpha_+^{\max(0,m-4)}.
\]
Es creciente para \(m\ge4\). Una parte tiene como máximo 44 rachas, con \(D_{\rm corto}\le28.221.897.930\). A la otra le quedan más de \(282.651.257.440.574.721\) entradas impares, la cota entera para 79 rachas. Esta segunda parte tiene por tanto al menos 80 rachas. Volviendo a aplicar \(F\), la primera sólo dispone de 9 rachas y \(D_{\rm corto}\le2.706\). Queda excluida, en particular, la descomposición entre los dos grandes convergentes contiguos de Q37 porque sus dos partes superan 2.706 entradas impares. [Capacidad sellada de cuatro rachas](../../COLLATZ_ECO_20261125/TERRAS88_CIERRE.md) · [Constantes del reparto](RECIBO_SHORT_SPLIT.json)

## Separación física de \(N\) y \(M\)

Sea \(\beta=\ln g_K>0\) y \(\Lambda=k\ln2-d\ln3>0\). Para el tramo corto se usa la base unimodular \((1054,665),(485,306)\) y las diferencias positivas
\[
\delta=665\ln3-1054\ln2,\qquad \epsilon=485\ln2-306\ln3 .
\]
Cualquier reloj del tramo corto se expresa como \(a(1054,665)+b(485,306)\) con \(a,b\) enteros. Si \(b\ge1\), la cota de 2.706 entradas impares da \(a\le3\). Si el prefijo es el corto, \(\beta=a\delta-b\epsilon>0\), de modo que \(b\le0\) porque \(\epsilon>3\delta\). El número positivo de entradas impares \(665a+306b\) implica \(a\ge1\), por lo que \(\beta\ge\delta\). Si el sufijo es el corto, su déficit \(\beta+\Lambda=b\epsilon-a\delta>0\) exige \(b\ge1\). Así \(\beta\ge\epsilon-3\delta-\Lambda>0\).

En ambos casos, el primer bloque tiene al menos dos pasos impares consecutivos, lo que da \(C_A/3^D\ge1-(2/3)^2=5/9\). La identidad \(M=e^\beta(N+C_A/3^D)\) implica \(M-N>B\beta+5/9\). El contraste usa logaritmos encerrados por racionales y redondea al siguiente entero par. Las cotas necesarias son:

| Tramo corto | Cota inferior de \(M-N\) |
| --- | ---: |
| \(N\to M\) | 1.222.315.096.482.260 |
| \(M\to N+1\) | 24.955.750.404.019.234 |

Los dos intervalos restantes y la realización física de sus palabras siguen abiertos. El contraste de constantes y su refuerzo por capacidad prescinden de barridos orbitales, de enumerar relojes y de nuevos cálculos en H92 o H146. [Verificador](check_short_split.py) · [Recibo íntegro](RECIBO_SHORT_SPLIT.json)
