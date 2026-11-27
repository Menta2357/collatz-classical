# Front4b. Fuentes de cuarto después de la salida débil (2,1)

Se conserva una semilla \(N\), una historia física hasta \(J\), y el factor exacto \(J+1=2^{L+1}Q\) con \(L\ge2\) y \(Q\) impar. Si \(J<4N+3\), la fuente \(w=(J-3)/4\) es impar positiva y menor que \(N\). El original hace \(L\) unos y la fuente \(L-2\) unos. Sus terminales respectivos \(R,U\) satisfacen \(R=9U+8\). La salida \((2,1)\) obliga a \(U\equiv9\pmod{16}\).

## Cinco colas fijas con retorno final libre

| Cabeza original desde \(R\) | Cabeza auxiliar desde \(U\) | Fase exacta de \(U\) |
| --- | --- | --- |
| \((2,1,6)\) | \((2,1,1,2,1)\) | \(393\pmod{1024}\) |
| \((2,1,2,6)\) | \((2,1,1,1,3,1)\) | \(2665\pmod{4096}\) |
| \((2,1,3,6)\) | \((2,1,1,3,2,1)\) | \(1353\pmod{8192}\) |
| \((2,1,4,4)\) | \((2,1,1,2,2,1)\) | \(777\pmod{4096}\) |
| \((2,1,1,8)\) | \((2,1,2,1,3,1)\) | \(2297\pmod{8192}\) |

Los puntos después de las cabezas, \(Z\) en el original y \(W\) en la fuente, satisfacen \(W=4Z+1\). Si el retorno original siguiente tiene valoración \(\gamma\), el retorno real auxiliar tiene valoración \(\gamma+2\) y llega al mismo terminal impar. `paidFixed` compone ambos libros físicos y devuelve `PaidMeeting N`.

## Tres familias con otra racha de longitud arbitraria

| Cabeza original hasta \(P\) | Cabeza auxiliar hasta \(A\) | Fase exacta de \(U\) |
| --- | --- | --- |
| \((2,1,5)\) | \((2,1,1,2)\) | \(137\pmod{512}\) |
| \((2,1,4,3)\) | \((2,1,1,2,2)\) | \(1801\pmod{2048}\) |
| \((2,1,2,5)\) | \((2,1,1,1,3)\) | \(1641\pmod{2048}\) |

En las tres cabezas, \(3(A+1)=4(P+1)\). Si \(P+1=2^{r+1}q\) con \(q\) impar, entonces \(3\mid q\) y \(A+1=2^{r+3}(q/3)\). El original hace \(r\) unos y termina en \(C=2\cdot3^rq-1\). La fuente hace \(r+2\) unos y termina en \(D=3C+2\). Si la primera ruptura de esos unos originales es un dos, su terminal \(Z\) satisface \(4Z=3C+1\), luego \(D=4Z+1\). Los retornos siguientes repiten el mismo empalme de valoraciones \(\gamma\) y \(\gamma+2\).

`payAfterAdaptiveRun` certifica esta regla con un par arbitrario de historias aptas hasta \(P,A\), ambas con sus propios relojes y aditivos. `paidAdaptive` la aplica a las tres cabezas físicas anteriores. El libro de una racha de \(n\) unos es \((n,n,3^n-2^n)\). Cada composición desde \(N\) conserva \((j+h,S+s,3^hB+2^SD)\). El libro auxiliar arranca de \(w\) y se compone por separado. Para deducir llegada a 1 se consume la inducción sobre semillas impares positivas menores que \(N\).

## Realización y frontera

Las dos entradas originales \(c=3\) y \(c=5\) tienen \(J\equiv7\pmod 8\) y su pendiente es ocho veces un impar. Dividir \(J+1\) por ocho permite resolver cualquier fase dyádica de \(Q\) para un \(L\) prescrito. En cada cabeza adaptativa, la pendiente de \(P\) es el doble de un impar. Así se puede imponer cualquier \(r\ge0\) y la ruptura dos mediante una congruencia adicional módulo \(2^{r+2}\) sobre el parámetro de la cabeza. La comprobación independiente construye 84 semillas en ambas entradas y reproduce desde cada \(N\) su prefijo, sus valoraciones y su fuente efectiva menor. Las dos comprobaciones Python pasan en modo normal y optimizado.

La cobertura deja abiertas las otras cabezas de la salida \((2,1)\) y las rupturas \(\ge3\) después de las rachas adaptativas. El resultado cubre longitudes arbitrarias para las guardas enunciadas. La activación para una semilla fija requiere un argumento adicional.

[Prueba Lean](../lean/Front4bQuarter21.lean) · [Recibo](../provenance/source_receipts.json) · [Palabras afines](derive_heads.py) · [Testigos físicos](check_realization.py)
