# Front4b. Primera salida 3 o 4 tras dos episodios débiles

## Dominio y libros

Se fija la semilla \(N\), la fila E1 \(p=3\) o \(5\), el punto inicial \(J\) y el pivote anterior \(V=T^{62}(N)\). Los parámetros base son \(u=18+32t\) para \(p=3\) y \(u=10+128t\) para \(p=5\). Desde \(J\) se suministra la palabra física
\[
(1,1,1,2,2,1,1,1,2,1,c)
\]
con \(c=3\) o \(4\) real. Su extremo es \(Y\) y su libro \((11,13+c,260843)\), como en [Front4bShortExit](../../COLLATZ_FRONT4B_RESIDUAL_REPRO_v1/lean/Front4bShortExit.lean). En particular,
\[
2^{13+c}Y=177147J+260843.
\]
La historia absoluta se conserva componiendo cada cola \((h,s,D)\) con \((j,S,B)\) mediante \((j+h,S+s,3^hB+2^SD)\). La fuente, cuando existe, tiene su propio libro.

## Guarda adaptativa para los doses siguientes

Sea \(\nu=\nu_2(Y-1)\) y \(r=\lfloor(\nu-1)/2\rfloor\). La racha máxima contiene exactamente \(r\) valoraciones 2 y lleva a
\[
U_r-1=(3/4)^r(Y-1).
\]
El libro de esta racha es \((r,2r,4^r-3^r)\). Si \(\nu\) es impar, su primera ruptura real es 1. Si es par, la primera ruptura real tiene valoración \(a\ge3\). Estas dos alternativas se siguen examinando el residuo final de \(U_r-1\) módulo 8.

Los siguientes umbrales son exactos dentro de cada cilindro afín por comparación de intercepto y pendiente. Las comparaciones se extienden a todo \(r\) mediante la monotonía de \((3/4)^r\).

| Fila \(p\) | Salida \(c\) | Primer \(r\) con \(U_r<4N+1\) | Primer \(r\) con \(U_r<2N+1\) | Primer \(r\) con \(U_r<N\) |
|---|---:|---:|---:|---:|
| 3 | 3 | 2 | 4 | 6 |
| 5 | 3 | 1 | 3 | 5 |
| 3 | 4 | 0 | 2 | 4 |
| 5 | 4 | 0 | 1 | 3 |

Cuando \(U_r<4N+1\) y su ruptura es \(a\ge3\), **atStrongInQuarterWindow** aplica el consumidor sellado **A2SecondOne.quarter_capture**. El impar \(w=(U_r-1)/4<N\) llega al mismo terminal en un retorno de valoración \(a-2\). Cuando \(U_r<2N+1\), su ruptura es 1 y al final de esos unos sale una valoración al menos 3, también se puede usar la [fuente mitad](../../COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1/lean/A2HalfAdaptive.lean). Las ventanas numéricas para las dos filas se prueban en papel y el consumidor genérico de la primera está compilado. En particular, para \(c=4\) se cubren todos los \(r\) con reserva par y todos los \(r\) desde el umbral de descenso.

Las reservas impares cortas que deja la primera regla son precisas y realizables. Para \(c=4\), están en \(r<4\) o \(r<3\) según la fila, con \(\nu=2r+1\). Los residuos exactos de \(t\), en orden creciente de \(r\), son los siguientes.

| Fila | \(t\) módulo su denominador |
|---|---|
| 3 | \(18360\bmod65536,\ 247736\bmod262144,\ 116664\bmod1048576,\ 3786680\bmod4194304\) |
| 5 | \(59168\bmod65536,\ 223008\bmod262144,\ 354080\bmod1048576\) |

Para \(c=3\) el verificador da análogamente los \(r<6\) o \(r<5\) de reserva impar. Las clases se obtienen imponiendo \(Y-1\equiv2^{2r+1}\pmod{2^{2r+2}}\) al parámetro de \(Y\), cuya pendiente es dos veces un impar.

En \(c=4\), el último paso anterior al umbral de descenso cruza ya el pivote antiguo \(V\). En la fila \(p=3\), una racha de **al menos tres** doses posteriores a \(Y\) da \(N<U_3<V\) en \(t\equiv1689528\bmod2097152\), con libro desde \(V\) \((17,27,281155211)\). En \(p=5\) bastan **al menos dos** doses y se obtiene \(N<U_2<V\) en \(t\equiv354080\bmod524288\), con libro \((17,27,325351403)\). Los dos relojes absolutos son \((79,125)\). Los pasos posteriores a esos doses quedan libres. El verificador encuentra todos los checkpoints anteriores sobre \(V\). Los teoremas **bandThreeExitFourCrossing** y **bandFiveExitFourCrossing** componen la historia sellada y consumen el cruce en A2, obteniendo captura o descenso o una readmisión por debajo de \(V\). Para \(c=4\) quedan como primeras salidas sin un pago certificado por estos lemas ni ese cruce las reservas impares con \(r\le2\) en \(p=3\) y \(r\le1\) en \(p=5\).

## Una fuente de varias aristas tras la ruptura 3

El cuarto puede quedar impagado en \(U_r\ge4N+1\) para \(c=3\). Esas son las ventanas \((p,r)=(3,0),(3,1),(5,0)\). En ellas se tiene \(U_r<8N+5\). Supóngase que el 3 es la ruptura física desde \(U_r\), con terminal \(Z\), y que desde \(Z\) hay \(h\ge0\) unos seguidos de una valoración real \(a\ge3\).

Ponga \(A=(U_r-1)/4\). La identidad \(3A+1=2Z\) hace que \(A\) sea un predecesor auxiliar de valoración 1. Además \(A<2N+1\). Desde \(A\), el tramo empieza por \(h+1\) unos y pasa por la misma ruptura \(a\) que el original. El consumidor de mitad **A2HalfAdaptive.local_capture** produce entonces
\[
w=(A-1)/2=(U_r-5)/8<N.
\]
El original desde \(U_r\) recorre \((3,1^h,a)\) y la fuente recorre \((1^h,2,a-2)\). Sus libros locales respectivos son
\[
(h+2,\ h+a+3,\ 3^{h+3}-2^{h+4}),\qquad
(h+2,\ h+a,\ 3^{h+2}-2^{h+1}).
\]
El teorema **afterThreeThenOnes** compone el libro real del original desde \(N\) y transporta el libro auxiliar al mismo terminal. \(A\) tiene una historia ajena al original. En las tres ventanas impagadas por cuarto se pueden realizar estas continuaciones para cada \(h\ge0\) y \(a\ge3\), fijando la congruencia diádica de la palabra completa. La condición de ruptura fuerte sigue siendo necesaria para esta prueba, y \(h=0\) también queda cubierto.

En las dos ventanas \((p,r)=(3,1),(5,0)\), una primera ruptura \(\ge4\) ya desciende bajo \(N\). En \((3,0)\) desciende si la ruptura es al menos 5. En este último caso, la ruptura exacta 4 da otra salida certificada. Desde \(J\) se obtiene el libro \((12,20,848065)\) y desde \(V\), \((15,24,23666419)\). Para toda la progresión \(t\equiv10168\bmod262144\) de \(p=3\), el nuevo terminal cumple \(N<X<V\) y todos los estados originales entre \(V\) y ese cruce están sobre \(V\). Los relojes absolutos son \((77,122)\) con coste \(42183254940993637080692255414025358675\). **bandThreeExit34Crossing** consume el cruce mediante el primer cruce certificado de A2. Obtiene pago o readmisión por debajo de \(V\), que exige un productor en su propio dominio.

## Obstrucción independiente en los primeros terminales

Se auditaron doce cilindros afines completos: \(p=3,5\), \(c=3,4\), y el terminal \(Y\) con cero o un retorno bajo adicional de valoración 1 o 2. En cada uno:

- Ninguna fuente positiva menor que \(N\) llega al terminal en hasta 42 retornos impares, con valoraciones arbitrarias.
- Ninguna fuente de cualquier longitud con todas las valoraciones en \(\{1,2,3,4\}\) y a lo sumo dos de ellas en \(\{3,4\}\) llega al terminal por debajo de \(N\). Se agotan todos sus árboles inversos en múltiplos de 3. La profundidad observada es de 19 a 21.

Para el primer enunciado, después de cada arista se usa el presupuesto \(w+1\ge(2/3)^k(x+1)\) con los \(k\) retornos inversos aún disponibles. Una nueva valoración se descarta únicamente cuando **ambos** coeficientes afines prueban impago para todo parámetro no negativo. La cota es monótona en la valoración, así que se agota el conjunto finito de exponentes posibles. Para ambas comprobaciones el residuo de cada inversa es uniforme en todo su cilindro, por la potencia de 3 que contiene la pendiente del terminal. La auditoría se reproduce en modo normal y optimizado.

Tras la primera ruptura 1 de los doses, quedan las ventanas sin precio de mitad y las reentradas con ruptura 2 que esa fuente no cubre. Tras un 3 en las ventanas altas también queda la siguiente ruptura débil 2. El cierre para cada semilla fija sigue pendiente.

Se aplicó De Bono cambiando la altura de entrada y el terminal de pago. La inversión directa no encontró una fuente corta. El predecesor auxiliar \(A\) permite consumir una racha posterior completa y financiar un encuentro que la fuente de cuarto inmediata deja abierto.

[Fuente Lean](../lean/Front4bLowExit.lean) · [Recibo Lean](../provenance/source_receipts.json) · [Verificador exacto](check_low_exit.py)

La clasificación de la racha maximal tras la salida 4 y su disyunción de pago o resto corto también quedaron certificadas por separado. [Lean](../lean/Front4bExitFour.lean)
