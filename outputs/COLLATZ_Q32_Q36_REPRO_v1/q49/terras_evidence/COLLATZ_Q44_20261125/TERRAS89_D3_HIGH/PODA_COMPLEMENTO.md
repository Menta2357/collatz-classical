# Poda por tamaño antes de proyectar la cuarta racha

La desigualdad siguiente es una cota exacta en papel. Queda por comprobar su ahorro en el complemento \(a_1<75,\ D_3\le92<D_4\). El certificado de las 2.194 fuentes prescinde de esta poda.

Sea \(P\) el pico par al terminar la tercera racha, \(P_{\max}\) una cota de ese pico dada por la proyección anterior, \(c=D_3\) y \(b\ge1\) la longitud real del tercer hueco par. El cuarto valle impar \(y=P/2^b\) cumple
\[
y+1\le U:=\left\lfloor P_{\max}/2^b\right\rfloor+1.
\]
Si la cuarta racha tiene longitud \(a=\nu_2(y+1)\) y \(1\le a\le L:=\lfloor\log_2 U\rfloor\), su pico es \(3^a(y+1)/2^a-1\). El hueco par siguiente tiene al menos un paso. Así, para el quinto valle impar \(z\),
\[
z+1\le \left\lfloor\frac{3^a\lfloor U/2^a\rfloor+1}{2}\right\rfloor,
\qquad
D_5\le c+a+\left\lfloor\log_2 \left\lfloor\frac{3^a\lfloor U/2^a\rfloor+1}{2}\right\rfloor\right\rfloor.
\]
Para \(a<L\) se tiene \(j=\lfloor U/2^a\rfloor\ge2\) y \(3\lfloor j/2\rfloor\ge j\), por lo que la cota crece con \(a\). El máximo en \(a=L\) es
\[
c+L+\left\lfloor\log_2((3^L+1)/2)\right\rfloor.
\]
Si se busca un infractor de la capacidad \(2^{D_5}\le6^{92}\), el objetivo mínimo es \(D_5\ge238\). Sea \(L_{\min}(c)\) el menor entero \(L\ge1\) cuya cota alcanza 238. Entonces es necesario que
\[
P_{\max}\ge 2^b\bigl(2^{L_{\min}(c)}-1\bigr).
\]
Esto permite limitar \(b\) antes de recorrer sus valores. Para cada \(b\) retenido, la primera desigualdad también da un mínimo para la **longitud real** \(a\). Junto con \(a\ge93-c\), se puede usar ese mínimo en la congruencia de la cuarta racha. Si el prefijo ya fija el cofactor, se conserva el procedimiento de proyección y se comprueba físicamente su único candidato. Todos los cálculos pueden hacerse con potencias de enteros y longitudes binarias.

La propuesta operativa es cotejar en alturas pequeñas las fuentes infractoras con el piloto ya retenido y medir por separado el ahorro en proyecciones de la cuarta racha. [Proyección de referencia](../../COLLATZ_Q38_20261125/TERRAS89_D5_PILOTO/RESULTADO.md)
