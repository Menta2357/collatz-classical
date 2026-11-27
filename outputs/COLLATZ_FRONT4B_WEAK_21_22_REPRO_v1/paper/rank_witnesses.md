# Colas débiles de Front4b y rango de altura

En las dos entradas E1, sea \(J\) el último punto impar antes de la primera racha de unos. Sea \(V\) el pivote anterior de la semilla original \(N\). En ambas filas se cumple \(N<V<J\).

| Fila | Parámetro original \(u\) | Libro hasta \(J\) |
|---|---:|---|
| \(c=3\) | \(18+32t\) | \((65,102,\operatorname{originalCost}(3,19))\) |
| \(c=5\) | \(10+128t\) | \((66,104,\operatorname{originalCost}(4,73))\) |

Para cada \(L\ge 2\), \(b\in\{1,2\}\) y \(H\ge 0\), cada fila contiene una semilla con la palabra física \((1^L,2,b,1^H)\) al salir de \(J\). Las primeras \(L+2+H\) aplicaciones de Syracuse desde \(J\) y \(L+2+b+H\) iteraciones del mapa abreviado desde \(J\) permanecen en \([J,\infty)\). Los dos extremos impares del par débil están estrictamente por encima de \(J\). Por lo tanto, para ninguna de las dos colas existe una cota uniforme de tiempo para encontrar un pivote de altura menor que \(J\), \(V\) o \(N\) después de esa entrada. Las semillas que testifican el enunciado pueden depender de \(L,b,H\).

## Realización y libros

Escribimos \(J=8(A+at)-1\), con \(a\) impar en ambas filas. Las ecuaciones físicas con cofactores impares \(Q,Q'\) son

\[
J+1=2^{L+1}Q,\qquad
3^{L+2}Q=1+2^{b+1}Z,\qquad Z+1=2^{H+1}Q'.
\]

Se realiza la condición en \(Z\) escogiendo \(3^{L+2}Q\) congruente a \(1+2^{b+1}(2^{H+1}-1)\) módulo \(2^{b+H+3}\). La pendiente \(3^{L+2}\) es impar y alcanza ese residuo. La pendiente \(a\) permite después realizar \(J\) en su progresión. Los cofactores impares fuerzan que las dos longitudes de racha sean exactas. En particular, \(H=2\) es realizable en los dos casos y da \(Q'>Q\) por
\[
2^{H+b+2}Q'=3^{L+2}Q+2^{b+1}-1
\]
y \(2^{H+b+2}\le 64<81\le 3^{L+2}\).

El coste aditivo local tras el par débil es
\[
D=3\bigl(3(3^L-2^L)+2^L\bigr)+2^{L+2}.
\]
El tramo con los \(H\) unos tiene \(m=L+2+H\) pasos impares, reloj abreviado \(d=L+2+b+H\) y coste \(D_H=3^HD+2^{L+2+b}(3^H-2^H)\). A una historia original \((j,S,C)\) se le compone el libro \((j+m,S+d,3^mC+2^SD_H)\). Las comparaciones sobre la órbita original usan \(j+i\) en Syracuse y \(S+k\) en el mapa abreviado. El resultado trata el rango de altura hacia delante desde \(J\) durante el horizonte construido.

## Verificación

- Front4bWeakRank certifica las alturas a partir del par físico, la extensión por unos y su composición con el libro original. [Lean](../lean/Front4bWeakRank.lean) · [Recibo](../provenance/source_receipts.json)
- Front4bWeakRealization certifica la realización simultánea para cualquier progresión afín de pendiente impar con forma \(8(A+at)-1\). [Lean](../lean/Front4bWeakRealization.lean) · [Recibo](../provenance/source_receipts.json)
- Front4bWeakRows aplica la realización a las dos filas originales, con sus dos relojes y un solo \(N\) por testigo. [Lean](../lean/Front4bWeakRows.lean) · [Recibo](../provenance/source_receipts.json)
