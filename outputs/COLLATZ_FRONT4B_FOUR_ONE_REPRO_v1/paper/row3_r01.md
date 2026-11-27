# Front4b. Dos reentradas y un primer cruce en \(r=0,1\)

## Dominio

En la fila E1 \(p=3\), el parámetro original es \(u=18+32t\) y \(N\) es la semilla de esa misma fila. Tras los dos episodios débiles \((L,b)=(3,2),(3,1)\), se observa la valoración 4 real. Su terminal es \(Y\). Si después de \(Y\) hay exactamente \(r=0\) o \(1\) doses seguidos de un uno, el punto antes de ese uno se llama \(U\). Las dos clases iniciales son \(t\equiv18360\bmod65536\) y \(t\equiv247736\bmod262144\). En ambas \(N<U\) y \(U+1\le3N\). Se usa \(V=T^{62}(N)\) sólo para el antiguo pivote. Todos los pasos mantienen la misma semilla y su libro.

## Regla para una racha de unos y su ruptura

Supónganse \(H\ge1\) valoraciones físicas 1 desde \(U\) y una ruptura real \(a\), con terminal \(X\). Su libro local es \((H+1,H+a,3^{H+1}-2^{H+1})\). Por tanto
\[
2^{H+a}X=3^{H+1}(U+1)-2^{H+1}.
\]
La guarda \(3\cdot3^{H+1}\le2\cdot2^{H+a}\) implica \(3X\le2(U+1)\). Con \(U+1\le3N\) y \(U>2\), esto da \(X\le2N\) y \(X<U\). El teorema Lean **guardedRunReduction** compone primero el libro exacto desde \(N\), y luego utiliza el reductor A2 para devolver descenso, captura o un punto admitido estrictamente menor que \(U\). Una readmisión mantiene su historial desde \(N\) y su guarda de una racha de unos con ruptura 2.

La guarda se cumple en particular para \(a\ge H+2\) y todo \(H\ge1\), o para \(a\ge H+1\) y \(H\ge3\). Basta comprobar los casos base \(H=1,a=3\) y \(H=3,a=4\). Aumentar simultáneamente \(H\) y el umbral de \(a\) reduce la razón \(3^{H+1}/2^{H+a}\) por \(3/4\). Así, toda ruptura fuerte tras exactamente un uno, en cualquiera de las dos clases, da pago o progreso con respecto a \(U\) sin hipótesis sobre la siguiente valoración. En la clase \(r=1\), para \(H=2\) también basta \(a\ge3\), por \(27U+19<32(2N+1)\) y \(27U+19<32U\). Esta mejora de precio específica se comprueba en papel.

## Tres familias con libro físico certificado

Cada continuación se escribe **desde \(Y\)**. En las dos primeras, la racha inicial de unos desde \(U\) tiene exactamente un retorno, su ruptura es 2, y siguen al menos dos doses si \(r=0\) o uno si \(r=1\). Tras los doses indicados se obtiene \(N<X<2N+1\) y \(X<U\). Las valoraciones posteriores quedan libres.

| \(r\) | Continuación desde \(Y\) | Fase de \(t\) | Libro absoluto hasta \(X\) |
|---:|---|---|---|
| 0 | \((1,2,2,2)\) | \(2901944\bmod4194304\) | \((80,126,1197101608222418270618232455065949759425)\) |
| 1 | \((2,1,2,2)\) | \(509880\bmod4194304\) | \((80,126,1209064660184482513474366718608472860609)\) |
| 0 | \((1,1,4)\) | \(477112\bmod2097152\) | \((79,125,389286197438383373804782899913260726251)\) |

Las dos primeras comparten cuatro retornos y siete divisiones desde \(Y\), con la misma pendiente terminal. **r0Readmission** y **r1Readmission** certifican sus aditivos distintos, los libros absolutos tanto de \(U\) como de \(X\), y el descenso o captura o la readmisión por debajo de \(U\). En la tercera, \(N<X<V\) y todos los checkpoints entre \(V\) y el cruce permanecen sobre \(V\). **r0TwoOnesCrossing** aplica el selector certificado de primer cruce de A2, con el libro \((17,27,243406475)\) desde \(V\). La palabra \((1,1,4)\) tiene los mismos relojes y pendiente que la palabra \((2,2,2)\) ya tratada, y un aditivo diferente.

En \(r=0,H=2\), un \(a\ge5\) da descenso directo puesto que \(27U+19<128N\). El \(a=4\) está en la tercera fila. Para \(a=3\), el pivote antes de ese 3 está debajo de \(8N+5\), por lo que el [puente de predecesor auxiliar](../../COLLATZ_FRONT4B_LOW_EXITS_REPRO_v1/paper/low_exit.md) paga si los unos posteriores rompen con valoración al menos 3.

## Siguiente frontera débil

Si \(H=1\) y su ruptura es 2, el primer terminal \(W=(9U+5)/8\) está por debajo de \(4N+1\). Todo su tramo máximo de doses paga por cuarto si rompe con \(a\ge3\). Si contiene al menos un dos, el primer checkpoint \((1,2,2)\) satisface \(32X=27U+23<32U\). Por tanto, si los doses siguientes rompen en 1, su última entrada \(E\) está estrictamente por debajo de \(U\). Cuando \(E\ge N\), cumple todavía \(E+1\le3N\) y vuelve a una entrada con un uno real. Esta readmisión amplia puede quedar fuera de la ventana A2 de \(2N+1\). La primera fila de la tabla entra a esa ventana tras dos doses, y la segunda tras uno.

Cuando después del primer \((1,2)\) aparece 1 de inmediato, el estado crece. Las clases exactas de esta primera obstrucción son \(18360\bmod524288\) y \(1558456\bmod2097152\), respectivamente. Puede repetirse el macro \((1,2)\) tantas veces como permita la reserva de \(U+5\) de la semilla admitida. Cada macro multiplica el punto trasladado por \(9/8\). El agotamiento de una racha homogénea deja por controlar su conector real. Quedan también las rupturas 2 para \(H\ge2\), las fuertes con financiación insuficiente y la activación de un productor sobre cada punto readmitido.

Se aplicó De Bono cambiando el terminal de comparación. La altura después del primer uno supera el precio de mitad, mientras que un tramo breve posterior o una ruptura fuerte puede entrar en el dominio de A2. Los tres certificados preservan los aditivos de cada palabra. Los verificadores normal y optimizado controlan las identidades físicas, los residuos, las desigualdades afines y los libros exactos.

[Código Lean](../lean/Front4bExitFourR01.lean) · [Recibo](../provenance/source_receipts.json) · [Verificador](check_row3_r01.py)
