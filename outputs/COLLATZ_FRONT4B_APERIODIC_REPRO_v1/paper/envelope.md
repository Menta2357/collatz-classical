# Front4b. Cota conjunta para reentradas con cambios aperiódicos

Un episodio débil \((1^L,2,b)\), con \(L\ge2\) y \(b\in\{1,2\}\), satisface \(DJ'=AJ+B\), donde
\[
 A=3^{L+2},\qquad D=2^{L+2+b},\qquad B=A-2^{L+1}.
\]
La misma coordenada \(Y(J)=17J+73\) funciona para todos los episodios, incluso cuando las longitudes y las rupturas cambian libremente. La desigualdad que lo prueba es
\[
 17B+73D\le73A,
 \qquad DY(J')\le AY(J).
\]
Basta comparar \(b=2\). En \(L=2\) hay igualdad y para \(L>2\) el término proporcional a \(3^L\) crece más deprisa que los términos proporcionales a \(2^L\). El desplazamiento racional \(73/17\) es óptimo dentro de esta familia de cotas afines. Cualquier coordenada \(kJ+c\), con \(k>0\), tendría que satisfacer \(73k\le17c\) ya en \(L=2,b=2\). El menor desplazamiento entero para \(J+c\) es cinco.

Para un prefijo físico con episodios arbitrarios y libro \((r,d,B_{\rm débil})\), se obtiene \(2^dY(Z)\le3^rY(J)\) por composición. Si su siguiente reserva es \(Z+1=2^{H+1}v\), con \(v>0\), se conserva el origen \(N\) y su libro anterior \((j,S,C)\) mediante la cota estricta
\[
 17\,2^{S+d+H+1}v<3^r\bigl(17(3^jN+C)+73\,2^S\bigr).
\]
El mismo teorema devuelve el segmento físico desde \(N\) hasta \(Z\), con libro \((j+r,S+d,3^rC+2^S B_{\rm débil})\). La cota excluye cualquier continuación que exija más reserva diádica que el crecimiento permitido por los relojes reales anteriores. La versión de desplazamiento entero da un criterio simple. Si \(J+5\le2^K\), es imposible que el siguiente \(H\) cumpla \(2r+K\le d+H+1\).

Por ejemplo, \(J=5479\) realiza los episodios \((L,b)=(2,1),(3,2)\) y llega a \(Z=26335\), con \((r,d)=(9,12)\). Aun tomando \(v=1\), exigir \(H\ge14\) costaría al menos \(2281701376\) frente al presupuesto \(1834770528\).

## Dónde se regenera la divisibilidad en longitud dos

Para \(L=2,b=2\), la factura exacta es \(64Y(J')=81Y(J)\). Un paso así consume exactamente seis factores de dos de \(Y\). Para \(L=2,b=1\) es \(32Y(J')+2336=81Y(J)\). Si el siguiente estado vuelve a tener una racha de longitud dos, la segunda factura exige \(Y(J)\equiv32\pmod{64}\). Por tanto, ese mecanismo de recarga solo actúa desde la fase de valoración cinco. El término \(2336=32\cdot73\) permite volver a aumentar la divisibilidad al restar, y la cota de altura no impide que esto ocurra más de una vez.

Quedan certificadas una envolvente óptima para cambios arbitrarios y dos restricciones exactas sobre la recarga. Una prueba de terminación de toda la alternancia aperiódica debería excluir una sucesión infinita con reentradas dentro del presupuesto y fases de recarga admisibles, o construir en ella una captura o un descenso. Las longitudes pequeñas siguen dentro del presupuesto, de modo que la desigualdad sola no da esa exclusión.

[Lean, desplazamiento entero](../lean/Front4bSwitchedEnvelope.lean) · [Lean, desplazamiento óptimo y recarga](../lean/Front4bSwitchedOptimal.lean) · [Recibos](../provenance/source_receipts.json) · [Recibo óptimo](../provenance/source_receipts.json) · [Comprobación física](check_envelope.py)
