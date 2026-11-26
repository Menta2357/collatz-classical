# Terras 89 · Cotejo del umbral de cuatro rachas

**Prueba en papel comprobada independientemente.** Sea \(N>0\)
impar, con \(N+1<2^{92}\). En el mapa abreviado, \(a_i\)
cuenta las entradas impares de la racha maximal \(i\) y
\(D_j=\sum_{i=1}^j a_i\). Se cumple

\[
3\le a_1\le89,\qquad D_4\le94
\quad\Longrightarrow\quad D_5\le237
\quad\Longrightarrow\quad 2^{D_5}\le6^{92}.
\]

En cada valle ponemos \(y=x+1=2^a u\) con \(u>0\) impar.
El siguiente valle físico viene tras un hueco de longitud \(b\ge1\):
\[
y' = 1+\frac{3^a u-1}{2^b}
\le \frac{3^a u+1}{2}
\le \frac{3^a+1}{2^{a+1}}y .
\]
Las cuatro comparaciones se componen sobre el mismo \(N\).
Como el quinto valle cumple \(2^{a_5}\le y_4\), resulta
\[
2^{D_5}<2^{88}\prod_{i=1}^{4}(3^{a_i}+1).
\]
El libro desplazado \(y_j=x_j+1\) pertenece a la misma historia;
el cambio de coordenada conserva su término aditivo.

Para \(p,q\ge1\) la diferencia entre
\(4(3^{p+q-1}+1)\) y \((3^p+1)(3^q+1)\) es
\(3(3^{p-1}-1)(3^{q-1}-1)\ge0\).
Se aplica dos veces a las longitudes \(a_2,a_3,a_4\).
Con \(A=a_1\) queda
\[
2^{D_5}<
 2^{92}(3^A+1)(3^{D_4-A-2}+1)
 \le2^{92}(3^A+1)(3^{92-A}+1).
\]
Los dos exponentes de la última expresión son al menos tres.
Por tanto el producto es como máximo
\((28/27)^2\,3^{92}<2^{146}\).
Esto da \(2^{D_5}<2^{238}\); la última implicación usa la
comparación entera \(2^{237}\le6^{92}\).

El residuo anterior de H92 incluía \(a_1\le70\) y
\(D_3\le92<D_4\). El corolario retira \(D_4=93,94\)
para \(3\le a_1\le70\). Quedan \(a_1\le2\) en el
residuo previo y \(3\le a_1\le70,\ D_4\ge95\).
El caso global Q0 y H146 siguen abiertos. La comprobación
sólo usa enteros, sin recorridos orbitales ni nueva unidad Lean.
[Derivación original](RESULTADO.md) · [Comprobador](check_corollary94.py)
· [Recibo propio del cotejo](RECIBO_COROLARIO94.json)
