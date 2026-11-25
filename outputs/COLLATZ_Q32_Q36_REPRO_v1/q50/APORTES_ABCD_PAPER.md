# Q50 · Continuaciones físicas de la ruptura débil

**Pruebas en papel.** La revisión integradora conservó el prefijo de Q49, $V=T^{62}(N)$ y su libro $(62,98,B_{62})$. Los conjuntos tratados son guardas suficientes, algunas realizables para cualquier longitud de racha. La cobertura simultánea de todos los $u$ sigue pendiente.

## A · Entrada a la ventana desde el siguiente pivote

Para $u\equiv3\pmod4$ se realizan $(1,2)$ desde $V$, con libro local $(2,3,5)$. El terminal $P=T^{64}(N)=(9V+5)/8$ cumple $P<2N+1$ porque $4V<5N$. Esto resuelve la condición de entrada al reductor que faltaba en la entrega de A. El reductor da un pago o un residual admitido $x\le P$. Como $N<V<P$, hace falta un cruce adicional para garantizar disminución respecto a $V$.

## B · Dos encuentros con la fuente histórica

Los conectores de valoración 6 coinciden con las reglas genéricas de Q42. Aquí se acredita su activación física dentro del residual de Front4b y se registra su relación exacta con la reserva de la fuente.

Para $u$ par, sea $r$ la longitud exacta de los unos desde $V$, con primera ruptura $b=2$. La fuente impar $w=(V-1)/2<N$ hace $(1^{r-1},c)$ hasta $A$, donde $Z$ es su último valor antes de $c=\nu_2(3Z+1)$. El original tras la ruptura vale $Y=3\cdot2^{c-2}A+1$.

| Guarda exacta | Recorrido desde $Y$ | Recorrido desde $A$ | Estados antes de encontrarse |
|---|---|---|---|
| $Z\equiv157\bmod1024$ | $(1,6,d)$ | $(1,2,1,d+2)$ | $B=(27A+7)/64$ y $4B+1$ |
| $Z\equiv293\bmod512$ | $(6,d)$ | $(1,1,d+2)$ | $B=(9A+1)/16$ y $4B+1$ |

La primera guarda implica $c=3$ y $A\equiv59\bmod128$. La segunda implica $c=4$ y $A\equiv23\bmod32$. Por sustitución, en la primera la fuente alcanza $(27A+23)/16=4B+1$, y en la segunda $(9A+5)/4=4B+1$. Los residuos certifican las valoraciones de las palabras hasta esos estados. La última arista es física en ambos lados, con $d=\nu_2(3B+1)$, porque $3(4B+1)+1=4(3B+1)$.

Los libros locales, respectivamente del original desde $V$ y de la fuente desde $w$, son

\[
\begin{array}{c|cc}
c&\text{original local}&\text{fuente}\\
3&(r+4,r+d+9,3^{r+4}+518\cdot2^r)&(r+4,r+d+8,3^{r+4}+259\cdot2^r)\\
4&(r+3,r+d+8,3^{r+3}+250\cdot2^r)&(r+3,r+d+7,3^{r+3}+125\cdot2^r)
\end{array}
\]

Para componer un libro original local $(j,S,B)$, el libro absoluto es $(62+j,98+S,3^j B_{62}+2^{98}B)$. Cada guarda se realiza para cualquier $r\ge2$: fijado $r$, la parte impar de $V+1=2^{r+1}v$ puede fijarse módulo 512 o 256 porque la pendiente de $(V+1)/4$ en $u$ es $3^{62}$. Para $r=2$ se obtienen $u\equiv514\bmod1024$ y $u\equiv410\bmod512$, respectivamente. Otros valores de la valoración posterior a $Y$ siguen pendientes.

## C · Descenso con reserva grande

Bajo la misma ruptura $b=2$, los primeros $h=\lfloor(c-3)/2\rfloor$ retornos desde $Y$, para $c\ge3$, tienen valoración exactamente 2. Esto sigue de $Y=1+3\cdot2^{c-2}A$: cada 2 resta dos a $\nu_2(Y-1)$, y aplica exactamente cuando esa valoración es al menos tres. Al cabo de $j\le h$ retornos, $Y_j-1=(3/4)^j(Y-1)$.

Sea $j(r)$ el menor $j$ con $3^{r+j}\le2^{r+2j}$. Existe porque $(3/4)^j\to0$. Si $c\ge2j(r)+3$, entonces $Y_{j(r)}<N$, pues $4N-3V-7>0$ coeficiente a coeficiente y

\[
Y_{j(r)}-1=(3/4)^{j(r)}\big((3/4)(3/2)^r(V+1)-3/2\big)<3(V+1)/4<N-1.
\]

El libro desde $V$ tiene palabra $(1^r,2,2^j)$ y coste $3^{r+j+1}+2^{r+2j+2}-2^{r+1}3^{j+1}$. El libro auxiliar de $w$ a $A$ es $(r,r+c-1,3^r-2^r)$. Este caso se paga por descenso, independientemente de si existe un encuentro.

## D · Reserva fija y rachas de longitud arbitraria

Escribiendo $V+1=4(K+3^{62}u)$, para cada $r\ge2$ basta escoger
$K+3^{62}u\equiv2^{r-1}5\cdot3^{-r}\pmod{2^{r+2}}$. Entonces el cofactor impar $v$ satisface $3^rv\equiv5\bmod8$, lo que da exactamente $b=2$ y $c=3$. Esto descarta una cota uniforme de $r$ deducida únicamente de $c=3$. Cada longitud se realiza eligiendo su propia progresión de semillas. Una órbita fija no se construye mediante esta elección.

Cuando $c=3$, el terminal auxiliar $A=(3^rv-1)/4$ es menor que $N$ exactamente para $2\le r\le4$ en esta fila. Se usa $6N/5<V$ y $V+1<5N/4$ en $A=(3/2)^r(V+1)/8-1/4$. La fuente inicial $w$ conserva su precio para cualquier $r$. El precio de $A$ tampoco prueba por sí solo un encuentro.
