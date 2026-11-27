# Front4b. Agotamiento de una palabra periódica de episodios débiles

Un episodio físico está etiquetado por \((L,b)\), con \(L\ge2\) y \(b\in\{1,2\}\). Su palabra es \((1^L,2,b)\) y su libro es \((L+2,L+2+b,3^{L+2}-2^{L+1})\). La misma lista no vacía de episodios, con orden y etiquetas fijos, se puede componer en un `Segment` con libro \((r,s,B)\). Aquí \(r,s\) suman los relojes de los episodios y \(B\) se compone como el término aditivo exacto de la palabra.

Escriba \(A=3^r\) y \(D=2^s\). Cada episodio contribuye un cociente superior a uno porque \(3^{L+2}>2^{L+2+b}\). Una palabra no vacía tiene \(A>D\), \(s>0\) y \(B>0\). En coordenada de altura se toma la reserva

\[
F(J)=(A-D)J+B.
\]

Si una copia física lleva \(J\) a \(J'\), se tiene \(DJ'=AJ+B\), luego \(DF(J')=AF(J)\). Después de \(n\) copias físicas exactas,

\[
D^nF(J_n)=A^nF(J_0),\qquad 2^{sn}\mid F(J_0),\qquad 2^{sn}\le F(J_0).
\]

Se cancela \(A^n\) en la divisibilidad porque es impar. Con la semilla y el checkpoint iniciales fijos, la cota obliga a que termine la repetición. El mismo argumento excluye una cola eventualmente periódica de esos episodios si el tramo anterior suministra el libro físico desde la semilla original. El teorema compone ese libro hasta \(J_n\), con relojes \(j+rn,S+sn\) y coste recurrente \(C_{i+1}=3^rC_i+2^{S+si}B\).

Por ejemplo, la palabra de episodios \(((2,1),(3,2))\) tiene libro \((9,12,25003)\) y reserva \(15587J+25003\). Desde \(J=5479\) se realiza una copia física. La reserva es \(85426176=2^{15}\cdot2607\), así que una segunda copia exigiría divisibilidad por \(2^{24}\) y queda excluida para ese checkpoint.

Lean certifica la composición, la divisibilidad y la exclusión de la repetición infinita. Pasaron cinco auditorías de axiomas estándar. Se comprobó por separado la aritmética de tres palabras mixtas con una, dos, diez y veinticinco copias físicamente realizadas a partir de checkpoints construidos para cada caso. La terminación de la repetición deja abierta la salida posterior y la conmutación aperiódica. El enunciado no atribuye descenso global ni captura por el mero agotamiento de la palabra.

[Prueba en Lean](../lean/Front4bPeriodicWeakRepeat.lean) · [Recibo](../provenance/source_receipts.json)
