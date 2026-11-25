# Terras con hasta 88 rachas impares

**Teorema.** Para el mapa abreviado \(T(x)=x/2\) si \(x\) es par y \(T(x)=(3x+1)/2\) si es impar, sea \(d_k\) el número de entradas impares en los primeros \(k\) pasos desde \(N\ge2\). Si el primer paso \(\tau\) con \(3^{d_\tau}<2^\tau\) es finito y su prefijo tiene como máximo **88 rachas impares máximas**, entonces \(T^\tau(N)<N\). Es el primer descenso real. La fuente \(N\) carece de cota superior en el enunciado. Se reutilizan los insumos externos del teorema de 87 rachas, incluidas las dos exclusiones computacionales de Weaver que el proyecto reprodujo íntegramente. [Dossier de 87](../COLLATZ_TERRAS_87_RUNS_20261125/RESULTADO.md) · [Weaver](https://rstation.ai/problems/collatz/papers/143) · [Reproducción de las exclusiones](../COLLATZ_TERRAS_87_RUNS_20261125/WEAVER_REPLAY_20261125/RECIBO.json)

## Reducción y exclusión

La extensión estudia exactamente 88 rachas. Para una fuente par el primer paso ya desciende. Para una fuente impar, antes de \(\tau\) la identidad afín con coeficiente al menos uno y aditivo no negativo da estados mayores o iguales que \(N\). Si falla el descenso en \(\tau\), el caso de igualdad queda excluido por la cota externa de ciclos con pocos mínimos. El corolario 5.4 de Rozier–Terracol da \(N>B=28\cdot10^{18}\). Con \(d=d_\tau\), \(k=\tau\), \(\Lambda=k\log 2-d\log 3\) y \(\Delta=T^k(N)-N\ge1\), el presupuesto desde ese mismo \(N\) da \(N\Lambda<88\). La cota de Rhin permite restringir \(d<2^{70}\). La criba unimodular usa extremos logarítmicos racionales y deja cuatro pares \((k,d)\). [Reducción, insumos y verificador](TERRAS88_PAPER.md) · [Rozier–Terracol](https://arxiv.org/pdf/2502.00948v5)

| Par de la criba | Diferencia final | Exclusión |
| --- | --- | --- |
| Q0 | \(\Delta\ge2\) | El crédito del extremo real y las capacidades ya disponibles recuperan la consulta de cinco bloques de Weaver. |
| Q0 | \(\Delta=1\) | Las capacidades de cuatro rachas recuperan \(H_{10}=92\), \(H_{11}=146\) y el precio estricto de la misma consulta. |
| Q1 | \(\Delta\ge2\) | El crédito del extremo real y las capacidades ya disponibles recuperan la consulta de cuatro bloques de Weaver. |
| Q1 | \(\Delta=1\) | Las capacidades de cuatro rachas dan \(H_4=67,H_5=107,H_6=170\), y los rangos siguientes usan los techos ya certificados. |
| Doble de Q1 | \(\Delta\ge2\) | La capacidad a \(H=66\) con cuatro raíces contradice el número de entradas impares. |
| Doble de Q1 | \(\Delta=1\) | La capacidad a \(H=67\) con tres raíces contradice el número de entradas impares. |
| Nuevo par de 88 | \(\Delta\ge1\) | Los dos inicios más bajos y la capacidad de tres rachas a \(H=67\) ya dan contradicción. |

## Capacidad de cuatro rachas y paso a los rangos

Para cada \(H\in\{66,67,92,107,146,170\}\), se certifica que todo impar positivo \(x\) con \(x+1<2^H\) tiene \(2^{D_4(x)}<6^H\), donde \(D_i\) acumula las entradas impares de las primeras \(i\) rachas completas. Si \(D_3\le H\), se aplica la recurrencia \(D_{i+1}< H+\alpha D_i\), con \(\alpha=\log_2 3\). El resto se reduce a un único cofactor posible por congruencia para cada combinación de longitudes y huecos retenida. Se recalculan las cuatro rachas físicas de cada candidato. La comprobación usa enteros exactos. [Congruencias y cobertura](TERRAS88_four_runs_66_67.md) · [Proyecciones exactas](TERRAS88_four_runs_170_Q1.md)

Sea \(G_t=\sum_{i=0}^{t-1}\alpha^i\). Para un segmento de longitud \(t\) iniciado en la ventana, las capacidades disponibles son \(H\) para \(t=1\), \(3H/2\) para \(t=2\), \((1+\alpha)H\) para \(t=3\) y \(HG_{t-2}\) para \(t\ge4\). Si los \(r\) inicios de menor valor satisfacen \(x_{[r]}+1<2^H\) y \(88>3r\), la partición cronológica tiene algún segmento de longitud al menos cuatro. Se pueden transferir a ese segmento los aportes de los demás dejando una racha por raíz. Cada incremento del segmento receptor es por lo menos \(H\alpha^2\) y crece geométricamente. Domina los incrementos de longitud dos y tres de otro segmento y el incremento de longitud cuatro, que es cero. Desde la quinta racha domina por comparación de potencias de \(\alpha\). Por ello la capacidad total es a lo sumo \(H(G_{87-r}+r-1)\). Toda comparación estricta de \(d\) por encima de esta cantidad fuerza \(x_{[r]}\ge2^H-1\). La partición se hace sobre el prefijo de la misma fuente. El último tramo par puede quedar truncado en \(\tau\).

Para \(\Delta=1\), se retiene en el presupuesto el término de origen \(1/(B(B+1))\). Sea \(\lambda_-\) una cota racional inferior de \(\Lambda\) y sean \(H_r\) los suelos certificados. El término desde el rango \(S\) se acota por \(E=\sum_{r=S}^{88}1/\max(B,2^{H_r}-1)\). Entonces, con \(\eta=\lambda_--(\ell-2)/B-1/(B(B+1))-E\), se comprueba \(\eta>0\) y \(U\eta\ge S-\ell\). La desigualdad estricta del presupuesto da \(x_{[\ell]}<U\).

| Consulta | \((\ell,S,R)\) | Precio estricto \(U\) | Objetivo | Bloques completos |
| --- | --- | ---: | --- | ---: |
| Q0 | \((6,10,11)\) | 453027402666008300866 | \(2^{146}-1\) | \(\le5\) |
| Q1 | \((2,4,6)\) | 99048017070889459170 | \(2^{170}-1\) | \(\le4\) |

Al retirar los \(\ell\) inicios menores quedan a lo sumo \(\ell\) cadenas. Se verifica \(88>\ell(R-\ell)\), así que una de ellas contiene al menos \(R-\ell\) inicios. Entre sus primeros \(R-\ell\) hay uno de valor al menos \(x_{[R]}\). El inicio anterior a esa cadena es una fuente \(z\) con \(B<z<U\), y todos los valles intermedios están por encima de ella. La consulta de Weaver excluye el tramo entre esos inicios impares, formado por bloques completos de la misma órbita. Las dos exclusiones se reprodujeron sin testigos en las 1.759 particiones de los dos métodos publicados. [Dominios y recibo de reproducción](../COLLATZ_TERRAS_87_RUNS_20261125/WEAVER_REPLAY_20261125/RECIBO.json)

## Verificación y alcance

La capacidad completa a altura 92 se obtuvo con el enumerador de proyecciones, incluidos los 39 casos con \(D_2>92\) y los 2.155 demás casos con \(D_3>92\). El máximo en esas ramas fue \(D_4=107\). Front4b certificó con su propia implementación el subconjunto antes pendiente de esa ventana, con 2.133 fuentes y el mismo máximo. La capacidad a altura 146 se verificó con la enumeración directa de las cuádruplas acotadas. [Recibo integrado](TERRAS88_CIERRE_RECIBO.json) · [H146](TERRAS88_FOUR_RUNS_H146_RECEIPT.json) · [H107](TERRAS88_four_runs_107.md)

El resultado es una prueba matemática con verificaciones computacionales exactas. Queda pendiente la formalización integral en Lean y la evaluación externa del resultado de 88. Sigue abierta la existencia de un primer cruce para toda semilla fija. Las órbitas cuyo primer cruce tiene más de 88 rachas quedan fuera de este teorema.
