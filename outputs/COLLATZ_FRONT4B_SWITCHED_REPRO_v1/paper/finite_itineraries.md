# Itinerarios finitos de colas débiles con cambios de longitud

Una entrada \(J\) con racha inicial de longitud \(L\ge2\) tiene la forma \(J+1=2^{L+1}q\), con \(q\) impar. Una transición \((b,H)\) realiza la palabra física \((1^L,2,b)\), con \(b\in\{1,2\}\). Su extremo \(Z\) satisface \(Z+1=2^{H+1}v\), con \(H\ge2\) y \(v\) impar. El libro entre cofactores es

\[
2^{H+b+2}v=3^{L+2}q+2^{b+1}-1 .
\]

Cada lista finita de esas transiciones se realiza en una progresión completa de cofactores iniciales \(q_0+2^K t\), con \(q_0\) impar y \(K\ge1\). Se construye de atrás hacia delante. Si la cola admite la progresión de cofactores \(v_0+2^K u\), basta levantar \(3^{L+2}q\) al residuo \(1+2^{b+1}(2^{H+1}v_0-1)\) módulo \(2^{H+b+2+K}\). La pendiente impar \(3^{L+2}\) permite ese levantamiento. La comprobación del par físico reconstruye dos pasos con extremos impares y los exponentes exactos.

## Crecimiento y relojes

Si \(2^{H+b+2}<3^{L+2}\), el cofactor posterior \(v\) supera estrictamente a \(q\). Cualquier lista finita de longitudes en \(\{2,3\}\) cumple esa condición con \(b=1\) para \(2\to3\) y \(b=2\) para las otras transiciones. Por ejemplo, \(n\) copias del par \((1,3),(2,2)\) producen \(2n\) cambios de longitud y alternan las dos colas débiles. El cofactor final es al menos el inicial más el número de transiciones.

El certificado conserva en cada transición los dos relojes \(L+2\) y \(L+2+b\), el término aditivo local y el orden real de los extremos. Al componer una lista de \(r\) transiciones se obtienen relojes exactos \(m,d\) con \(4r\le m\le d\). Todos los estados de ambos relojes desde la entrada están por encima o al nivel de \(J\). En las filas Front4b E1 \(c=3\) y \(c=5\), el certificado se adjunta a la historia original, que satisface \(N<V<J\). El libro final desde el mismo \(N\) es \((j+m,S+d,3^mC+2^SB)\), donde \((j,S,C)\) es el libro previo y \(B\) el término aditivo del itinerario.

El resultado descarta un horizonte uniforme, común a todas las semillas de una fila, que garantice un descenso bajo el pivote anterior o bajo el cofactor inicial en itinerarios que cambian de longitud. Cada prefijo tiene su propio testigo entero. La realización cuantificada es finita.

## Verificación

- El primer módulo certifica el levantamiento y el tramo físico para toda lista permitida. [Front4bSwitchedRealization.lean](../lean/Front4bSwitchedRealization.lean) · [Recibo](../provenance/source_receipts.json)
- El segundo aplica el resultado a las filas originales, verifica las guardas de crecimiento y da una familia de cambios sucesivos. [Front4bSwitchedRows.lean](../lean/Front4bSwitchedRows.lean) · [Recibo](../provenance/source_receipts.json)
