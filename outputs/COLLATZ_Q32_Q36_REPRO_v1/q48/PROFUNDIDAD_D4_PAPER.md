# Q48 Front4b · Poda inversa breve de la ruptura directa 4

## Dominio y primer contraste

Fijamos la única fila (k=428769801+2^{31}(108+128s)), (s\equiv7\pmod8), (s\ge7), y el **mismo original**
\[
N(s)=66972346602545741868196940927
 +79228162514264337593543950336s.
\]
Su pivote físico es (F=T^{60}(N)=F_0+F_1s), con
\(F_0=71667327748009080469224948461\) y
\(F_1=84782316550432407028588866402\). Su libro absoluto es
\((60,95,253163701604367108480427299121)\).

Supongamos que (F\) realiza (m\ge14\) pares físicos \((1,2)\), que \(X=T^{60+2m}(N)\) es su extremo y que la **ruptura directa** desde \(X\) tiene valoración exacta (d=4\). Sea \(E=T(X)\). Entonces
\[
X+5=\frac{9^m(F+5)}{8^m},\qquad
E=\frac{3\,9^m(F+5)-14\,8^m}{16\,8^m}.
\]
El primer contraste es \(E\) frente al original \(N\). Como \(F+5>0\), \(E_m\) crece con \(m\). Para \(m=14\), el numerador de \(16\,8^{14}(E_{14}-N)\) es exactamente
\[
205795823026227698095123458871258901109494
+243456079092485831877002084822394516865862s>0.
\]
Por tanto **\(E>N\)** en todo el dominio fijado. La rama no es vacía: la congruencia lineal da, por ejemplo, \(s=39632959925687\), para el cual \(\nu_2(F+5)=43\), se agotan exactamente 14 pares y la siguiente valoración es 4.

## Poda de fuentes inversas

La ruptura 4 obliga a \(\nu_2(X+5)=1\): si \(4\mid X+5\), entonces \(3X+1=3(X+5)-14\equiv2\pmod4\), contradiciendo \(d=4\). Si \(F+5=2^{3m+1}v\), con \(v\) impar, entonces
\[
8E+7=3^{2m+1}v,
\qquad E\equiv7\pmod9.
\]
Una inversa física de \(E\) tiene la forma \(y\mapsto(2^a y-1)/3\), con \(a\ge1\) y resultado impar positivo. Como \(E\equiv1\pmod3\), su primera valoración debe ser par. La opción \(a=2\) produce \((4E-1)/3\equiv0\pmod3\), así que **no puede prolongarse** a una segunda inversa. Toda cadena superviviente de longitud al menos dos empieza con \(a\ge4\).

Si empieza con \(a=4\) y después se eligen las valoraciones mínimas admisibles, el prefijo es \((4,2,1,2)\): los tres primeros estados son
\[
2\,3^{2m}v-5,\quad
8\,3^{2m-1}v-7,\quad
16\,3^{2m-2}v-5,
\]
y el cuarto exponente mínimo es 2. Si se aumenta antes el segundo o el tercer exponente, el exceso total ya es al menos 6. Si la primera valoración es \(a\ge6\), su propio exceso sobre 1 ya es al menos 5. Por tanto, para una cadena de profundidad \(r\), suma de valoraciones \(A\), se tiene \(A-r\ge4\) cuando \(2\le r\le3\), y \(A-r\ge5\) cuando \(4\le r\le8\).

El **libro de cualquier fuente hipotética** se mantiene aparte. Si su extremo es \(w\), su coste aditivo \(B\) y sus valoraciones inversas son \(a_1,\ldots,a_r\), entonces
\[
E=\frac{3^r w+B}{2^A},\qquad
\frac{B}{2^A}=\sum_{j=1}^r
 \frac{3^{j-1}}{2^{a_1+\cdots+a_j}}
\le\sum_{j=1}^r\frac{3^{j-1}}{2^j},
\]
de donde \(w\ge 2^A(E+1)/3^r-2^{A-r}\). Para \(r=1\), \(w\ge(4E-1)/3>N\). Para \(2\le r\le3\),
\[
w\ge16\left(\left(\frac23\right)^r(E+1)-1\right)
\ge16\left(\left(\frac23\right)^3(E+1)-1\right)>N.
\]
Para \(4\le r\le8\),
\[
w\ge32\left(\left(\frac23\right)^r(E+1)-1\right)
\ge\frac{8192}{6561}(E+1)-32>N,
\]
pues \(E>N\) y \(N>124\). **Ninguna fuente \(w<N\) llega a este mismo \(E\) en una a ocho aristas físicas.** La tarifa usada aquí deja de ser concluyente en profundidad 9; no se afirma que exista allí una fuente física pagada.

## Libros y alcance

El original conserva el libro local \(F\to X\), \((2m,3m,5(9^m-8^m))\), y la ruptura \(X\to E\), \((1,4,1)\). Su libro compuesto \(F\to E\) es
\((2m+1,3m+4,15\,9^m-14\,8^m)\); desde \(N\), es
\[
\left(61+2m,\ 99+3m,\
3^{2m+1}\cdot253163701604367108480427299121
+2^{95}(15\,9^m-14\,8^m)\right).
\]
Este libro no es el de una fuente inversa. La fuente anterior \((F-5)/2\) de la salida fuerte \(d\ge5\) tampoco se invoca: su última valoración propuesta sería \(d-4=0\) en esta rama.

**Prueba exacta:** poda de profundidades 1 a 8 respecto al mismo \(N\) y al terminal directo \(E\), para toda instancia física de \(m\ge14,d=4\) en la fila. **Sondeo:** ninguno; el testigo de no vacuidad se obtuvo por congruencia lineal. **Pendiente:** profundidad 9 y posteriores, o un terminal ulterior, sin exploración aquí. El giro breve de De Bono fue contrastar primero \(E\) con \(N\) y cobrar después la valoración de cada preimagen.
