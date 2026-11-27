# Coste exacto de cambios entre dos bloques débiles

Sea \(J\) el punto impar al comienzo de un bloque y \(Y\) su extremo. Se usan dos bloques reales de Front4b. Cada pareja \((L,b)\) indica la palabra de valoraciones \((1^L,2,b)\).

| Bloque | Episodios \((L,b)\) | Libro \((r,d,C)\) | Recurso \(R(J)=(3^r-2^d)J+C\) |
|---|---|---|---|
| \(A\) | \((2,2)\) | \((4,6,73)\) | \(17J+73\) |
| \(B\) | \((2,1),(3,2)\) | \((9,12,25003)\) | \(15587J+25003\) |

Los libros físicos \(2^dY=3^rJ+C\) fuerzan \(J\equiv7\pmod{64}\) para \(A\) y \(J\equiv39\pmod{64}\) para \(B\). Ambas clases tienen \(\nu_2(J+1)=3\), por lo que los dos bloques comienzan con exactamente dos unos. Al pasar a cualquiera de los dos bloques, el recurso abandonado es \(32\bmod{64}\). Si una racha completada de \(n\) copias de un bloque \(a\) comienza en \(J_k\) y el siguiente bloque cambia, se cumple exactamente

\[
\nu_2 R_a(J_k)=d_a n+5.
\]

La prueba usa \(2^{d_a}R_a(Y)=3^{r_a}R_a(J)\) en cada copia física. El factor \(3^{r_a}\) es impar y el cambio observado fija la valoración del último recurso en cinco. Un recurso afín común \(sJ+c\), con \(s>0\), exigiría \(73s=17c\) y \(25003s=15587c\) para satisfacer las dos leyes homogéneas, que son incompatibles.

## Restricción en un itinerario arbitrario

Sea \(7\le J_0<2^H\). Los bloques \(A\) y \(B\) multiplican \(J\) como máximo por \(2\) y \(8\), respectivamente. Después de \(k\) bloques de cualquier orden, escribimos \(G_k=\#A+3\#B\) para el coste de crecimiento del prefijo. Entonces \(J_k\le 2^{G_k}J_0\), y \(R_a(J_k)\le2^{K_a}J_k\) con \(K_A=5\), \(K_B=15\). La condición necesaria para una racha completada es

\[
d_a n+5 < H+G_k+K_a .
\]

El libro adjunto conserva la misma semilla original \(N\), los relojes cronológicos y el coste aditivo exacto del prefijo y de la racha. La desigualdad excluye itinerarios infinitos en este alfabeto cuando \(d_a n-G_k\) es no acotado sobre sus rachas completadas. Como \(G_k\le3k\) y \(d_a\ge6\), basta que \(2n-k\) sea no acotado. Por ejemplo, alternar los bloques con longitudes de racha \(1,2,4,8,\ldots\) satisface ese criterio. El argumento admite un prefijo con cambios arbitrarios y deja abiertos los itinerarios cuyas rachas permanecen dentro del presupuesto.

[Lean](../lean/Front4bAperiodicAudit.lean) · [Recibo](../provenance/source_receipts.json)
