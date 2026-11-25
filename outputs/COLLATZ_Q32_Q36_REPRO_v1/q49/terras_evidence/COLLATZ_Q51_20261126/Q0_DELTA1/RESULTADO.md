# Terras 89 · Corte de dos valles en Q0, con desplazamiento uno

Supóngase un primer cruce finito con 89 rachas impares máximas, el par Q0 \((k,d)=(630118245525664765,397560349370386783)\) y \(T^k(N)=N+1\). Sea \(B=28\cdot10^{18}\) el límite previo y sean \(x_{[i]}\) los inicios de racha ordenados en esa misma trayectoria. Necesariamente,
\[
B<N<x_{[2]}<35\cdot10^{18},\qquad
\sum_{i=2}^{6}\frac1{x_{[i]}}>\frac4B.
\]
Además \(x_{[3]}<4B/3\), \(x_{[4]}<3B/2\) y \(x_{[5]}<2B\). El resultado reutiliza los suelos de cuatro rachas de Q37 y una exclusión ya reproducida de Weaver. [Reducción Q37](../../COLLATZ_Q37_20261125/TERRAS89_PAPER/RESULTADO.md) · [Recibo de Weaver](../../COLLATZ_TERRAS_87_RUNS_20261125/WEAVER_REPLAY_20261125/RECIBO.json)

## Libro y presupuesto desde \(N\)

Se usa el mapa abreviado. Los relojes \(k,d\) cuentan sus pasos y sus entradas impares. Si \(C\) es el término aditivo del prefijo, la igualdad física es \(2^k(N+1)=3^dN+C\), siempre desde el mismo \(N\). El aditivo no negativo y el primer cruce fuerzan \(T^i(N)\ge N\) para \(i<k\). La semilla es impar, pues una par descendería de inmediato. Entonces \(N+1\) es par y \(T^{k+1}(N)=(N+1)/2<N\). Un estado repetido entre los instantes \(0,\ldots,k\) haría periódico el futuro sin ningún estado bajo \(N\). Todos los inicios de racha son, por tanto, distintos y \(x_{[1]}=N<x_{[2]}\).

Con \(\Lambda=k\ln2-d\ln3\), la suma de términos \(\ln(1+1/(3T^i(N)))\) sobre las entradas impares se obtiene tomando el cociente del terminal exacto por \(N\). Vale \(\Lambda+\ln(1+1/N)\). Una racha que empieza en \(x\) aporta menos de \(1/x\), por la suma geométrica de recíprocos durante sus pasos impares. Usando \(\ln(1+1/N)>1/(N+1)\) queda
\[
\Lambda <\frac1{N(N+1)}+\sum_{i=2}^{89}\frac1{x_{[i]}}.
\]
Sean \(\lambda_-\le\Lambda\) el límite inferior racional de Q37 y \(H_i\) sus suelos de rango. Aquí \(H_{11}=92\) y \(H_{12}=146\). Para \(\ell=7,S=11,R=12\), se fija \(E=\sum_{i=11}^{89}(2^{H_i}-1)^{-1}\). Los rangos 7 a 10 aportan a lo sumo \(4/x_{[7]}\), por lo que
\[
\lambda_- < \frac1{N(N+1)}+
 \sum_{i=2}^{6}\frac1{x_{[i]}}+\frac4{x_{[7]}}+E.
\]

## Cierre del extremo superior

Sea \(U=453027402666008300866\) el tope estricto de fuente de Weaver. El cotejo aritmético verifica
\[
U\left(\lambda_--\frac1{B(B+1)}-\frac4B-E\right)>4.
\]
Si los cinco primeros recíprocos distintos del origen sumaran a lo sumo \(4/B\), el presupuesto anterior daría \(x_{[7]}<U\). Quitando los siete menores inicios, quedan a lo sumo siete cadenas cronológicas, ya que el primer inicio es \(N\) y se retiró. Una cadena tiene al menos cinco miembros. Entre sus primeros cinco aparece algún rango \(\ge12\), porque sólo cuatro rangos están estrictamente entre 7 y 12. El inicio \(z\) inmediatamente anterior a la cadena es uno de los siete retirados. Entonces \(B<z<U\) y los valles intermedios son mayores que \(z\). El extremo es al menos \(x_{[12]}\ge2^{146}-1\), alcanzado desde \(z\) en a lo sumo cinco bloques completos. Es una instancia física de la consulta Q0 ya excluida.

Así se fuerza la suma estricta \(>4/B\). Si \(x_{[r]}\ge (7-r)B/(6-r)\) para \(r=2,3,4,5\), los \(r-2\) recíprocos anteriores se acotan por \(1/B\) y los \(7-r\) restantes por \(1/x_{[r]}\), lo que vuelve a dar una suma \(\le4/B\). Esto prueba todos los cortes anunciados. La primera prueba prerregistrada, usando sólo \(x_{[i]}\ge N\) en estos cinco rangos, halló por 65 iteraciones racionales el primer piso que permite la exclusión por ese presupuesto, exactamente \(35\cdot10^{18}\). El cotejo de los cinco recíprocos lo mejora a un corte en el segundo valle. [Prerregistro](PREREGISTRO.md) · [Corte de origen](RECIBO.json) · [Cotejo de valles](RECIBO_Valles.json)

En particular, \(a_1(N)\le64\) porque \(N+1\le35\cdot10^{18}<2^{65}\). Se tiene también \(a_1(N)\ge2\): si \(N\equiv1\pmod4\), los dos primeros pasos ya dan el primer cruce con descenso. El terminal \(N+1\) no es múltiplo de tres porque hay una entrada impar y desde la última operación impar sólo quedan divisiones por dos. Estas dos condiciones dan \(N\equiv3,7\pmod{12}\).

No se han simulado órbitas, rehecho bandas de Q50 ni ejecutado consultas Weaver. En la vía de capacidades siguen pendientes \(H=146\) y, para \(H=92\), \(a_1\le2,\ D_3\le92<D_4\) o \(3\le a_1\le69,\ D_3\le92,\ D_4\ge96\). En la vía del corte, el siguiente problema es excluir el intervalo restante con dos valles físicos distintos en \((B,35\cdot10^{18})\) y el presupuesto reforzado, o demostrar una nueva exclusión para esos valles. [Q50 A70](../../COLLATZ_Q50_20261126/TERRAS/RESULTADO.md) · [Q50 D4=95](../../COLLATZ_Q50_20261126/TERRAS_D495_GAPS_ORDINAL/RESULTADO.md)
