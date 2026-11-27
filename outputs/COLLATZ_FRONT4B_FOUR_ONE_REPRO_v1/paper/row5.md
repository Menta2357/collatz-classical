# Front4b. Salida cuatro en los dos cilindros cortos de E1 5

El padre congelado es PR #23, commit 98e511831a77015409ad8506f3818f721f67f60f. Desde la semilla \(N\) se conserva la entrada \(J\) de E1 \(5\), alcanzada en el retorno impar 66 y la división 104. El pivote anterior es \(V=T^{62}(N)\). Tras los bloques \((L,b)=(3,2),(3,1)\), la salida real \(4\) y exactamente \(r\in\{0,1\}\) dosis de valoración dos, el punto \(U\) tiene una valoración uno real. El libro local desde \(J\) es \((11,17,260843)\) para \(r=0\) y \((12,19,913601)\) para \(r=1\).

## Reentrada por cofactor

Sea \(J+1=16Q\) con \(Q\) impar. Se corta en \(U\), antes de la primera valoración uno. Si \(U+1=2^{H+1}q\) con \(q\) impar, \(H\) es la longitud maximal real de su racha de unos. Los libros dan
\[
2^{H+14}q=177147Q+13423 \quad(r=0),\qquad
2^{H+16}q=531441Q+56653 \quad(r=1).
\]
En ambos casos \(U>J\), pero \(q<Q\) exactamente cuando \(H\ge4\). Para \(1\le H\le3\), el cofactor aumenta. La guarda constituye una reentrada débil de rango menor si la racha maximal va realmente seguida de \((2,b)\), con \(b=1\) o \(2\). En esos casos se conserva también la historia del episodio nuevo con el mismo \(N\). El resultado compara los dos cortes indicados.

## Cruce del pivote y descenso después de un uno

| Cilindro corto | Sufijo desde \(U\) | Consecuencia | Retorno impar |
|---|---|---|---:|
| \(r=0\), \(t\equiv59168\bmod65536\) | \((1,3)\) | \(N<Z<V\), con primer cruce consumido por A2 | 79 |
| \(r=0\) | \((1,e)\), \(e\ge4\) real | \(Z<N\) | 79 |
| \(r=1\), \(t\equiv223008\bmod262144\) | \((1,e)\), \(e\ge3\) real | \(Z<N\) | 80 |

La valoración tres es suficiente para cruzar el pivote en el primer renglón y para descender en el tercero. El primer caso se realiza en todo \(t=452384+524288k\), con libro original \((79,125,409938669746458470781450280772615731179)\). El segundo cilindro admite \((1,3)\) en todo \(t=2058016+2097152k\), con libro \((80,127,1267034393121353056785657440005696841665)\). El consumidor A2 toma el primer cruce realmente ocurrido y devuelve pago o una readmisión estrictamente por debajo de \(V\). El criterio de cruce no fuerza la valoración tres para todo parámetro del cilindro corto.

El verificador independiente comprueba las valoraciones por transporte afín desde \(N\) y certifica por comparación de intercepto y pendiente que los puntos interiores precedentes de la clase de cruce están por encima de \(V\). También construye ocho clases testigo para los dos valores de \(r\) y ambos extremos \(b\). \(H=3\) produce aumento real y \(H=4\) descenso real del cofactor. El resto de las continuaciones requiere otra guarda o una reentrada adicional.

- Rango y reentrada débil. [Lean](../lean/Front4bFourShortRank.lean) · [Recibo](../provenance/source_receipts.json)
- Cruce, descenso y cilindros físicos. [Lean](../lean/Front4bFourShortCrossing.lean) · [Recibo](../provenance/source_receipts.json)
- Reproducción exacta con transporte afín. [Código](check_row5.py) · [Testigos](../provenance/row5_witnesses.json)
