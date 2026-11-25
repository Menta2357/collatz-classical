# Q46 · La profundidad 16 tampoco paga

## Dominio y primera refutación

Fijamos únicamente \(q\ge0\), \(k=428769801+2^{31}q\), el mismo original
\[
N(q)=123584481135207023644232831+2^{89}q,
\]
y su terminal físico \(J(q)=T^{59}(N(q))=5642588099487446991065277197+2\cdot3^{59}q\). La primera profundidad que Q45 dejó sin decidir era 16. En ella, la **tarifa mínima** de cualquier inversa física ya supera \(N(q)\). Por tanto ninguna fuente menor que el original alcanza \(J(q)\) en exactamente 16 retornos acelerados.

El libro absoluto original hasta \(J(q)\) sigue siendo \((59,88,84284738864848587803900839355)\), con sufijo local \((9,12,31211)\) desde \(T^{50}(N)\). Las dos fuentes mitad siguen separadas: \(w_1(q)<N(q)\) tiene libro \((5,7,211)\) y después \((3,3,19)\), compuesto \((8,10,8129)\); \(w_2(q)>N(q)\) tiene libro \((2,4,5)\) y después \((6,6,665)\), compuesto \((8,10,14285)\). Ninguno de esos libros se atribuye a una nueva fuente hipotética.

## Certificado simbólico de profundidad 16

La congruencia de la segunda reserva es constante en la progresión:
\[
J(q)=3^7u(q)-10,
\qquad u(q)=2580058573153839502087461+2\cdot3^{52}q
\equiv15\pmod{27}.
\]
La prueba modular de Q45 implica que toda inversa física que sobreviva diez aristas desde \(J(q)\) acumula al menos cuatro unidades de valoración por encima de una unidad por arista. Así, si una inversa tiene 16 aristas y valoración total \(A\), necesariamente \(A\ge20\).

Sea \(w\) su extremo. Su libro inverso propio satisface
\[
w=\frac{2^A J(q)-B}{3^{16}},
\qquad
\frac{B}{2^A}
=\sum_{j=1}^{16}\frac{3^{j-1}}{2^{a_1+\cdots+a_j}}
\le\sum_{j=1}^{16}\frac{3^{j-1}}{2^j}.
\]
Como \(A\ge20\), resulta
\[
w\ge\frac{2^{20}(J(q)+1)}{3^{16}}-16.
\]
La guarda de precio exacta es
\[
G_{16}(q):=2^{20}(J(q)+1)-3^{16}(N(q)+16)
=596775779651129192049569479325361
+2^{21}3^{16}(3^{43}-2^{68})q.
\]
El intercepto es positivo y \(3^{43}-2^{68}=33109062215184251771>0\). Por tanto \(G_{16}(q)>0\) para **cada** \(q\ge0\), y \(w>N(q)\). En \(q=0\), incluso el suelo entero de la cota deja un margen de \(13863443388664358245766721\) sobre \(N(0)\).

## Alcance

**Prueba exacta:** Q45 excluyó profundidades 1 a 15 y esta desigualdad excluye exactamente la 16, de modo que un conector pagado en \(J(q)\) requiere al menos 17 retornos para toda la progresión. **Sondeo:** ninguno. **Pendiente:** no se ha examinado profundidad 17 ni un terminal ulterior. El cambio de atención de De Bono es el precio de la fuente inversa, conservando la historia y la contabilidad física del original.
