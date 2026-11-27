# Front4b. Exclusión de fuentes con hasta dos valoraciones altas mínimas

## Enunciado

En cualquiera de las dos filas E1, fije la semilla original \(N\) y su checkpoint \(J\). Suponga que la órbita sigue un prefijo físico de episodios \((1,1,2,b)\), \(b\in\{1,2\}\), en cualquier orden. Se permite parar en \(J\), antes de completar el último episodio o al terminarlo. En todo checkpoint impar de ese prefijo, una fuente física desde \(0<w<N\) debe usar **alguna valoración \(\ge5\)** o **al menos tres valoraciones \(\ge3\)**.

Equivale a excluir todas las fuentes con valoraciones en \(\{1,2,3,4\}\) y con a lo sumo dos valoraciones en \(\{3,4\}\). Las valoraciones 1 y 2 pueden aparecer en cualquier orden y en número arbitrario. El resultado es más restrictivo sobre la fuente que la [exclusión sellada de valoraciones sólo 1 y 2](../../COLLATZ_FRONT4B_APERIODIC_REPRO_v1/lean/Front4bSmallSource.lean) y tiene dominio original \(L=2\). La prueba es aritmética con frontera afín comprobable, sin compilación Lean nueva.

## Regla de inversión y frontera

En un entero impar positivo \(x\), una arista inversa de valoración \(a\) tiene como preimagen
\[
\phi_a(x)=(2^a x-1)/3.
\]
Su integridad exige \(2^a x\equiv1\bmod3\). Si \(3\mid x\), no hay preimagen. Si \(x\equiv2\), la elección baja es 1 y la alta admitida es 3. Si \(x\equiv1\), son 2 y 4. Ambas aristas, al existir, son inversas físicas porque el cociente original \(x\) es impar. Para ambas elecciones vale \(\phi_{a+2}(x)=4\phi_a(x)+1\).

Al invertir un checkpoint de la órbita original, cualquier prefijo inverso de sólo valoraciones bajas reconstruye la misma órbita, por unicidad de la inversa baja. Así se llega al primer cambio de valoración baja a alta, o hasta la frontera de los primeros dos episodios. Si se llega a la frontera, cualquier fuente que alcanzara el checkpoint tardío alcanzaría también uno temprano con hasta dos altas.

Se verificaron todos los 16 prefijos distintos de longitud hasta 8 desde \(J\) que se obtienen de \((1,1,2,b,1,1,2,d)\), \(b,d\in\{1,2\}\), en cada fila. Esto incluye los checkpoints inmediatamente antes y después de cada retorno, incluso si el segundo episodio aún no ha fijado su última valoración. En cada palabra finita la congruencia terminal impar determina la clase diádica exacta, usando \(J\equiv7\bmod8\) y su pendiente de ocho veces un impar. Se representa cada estado desconocido como su par afín (intercepto, pendiente) sobre el parámetro del cilindro. Para cada estado se verifica la positividad, la paridad, el margen estricto sobre \(N\) y que su pendiente es múltiplo de 3, lo que hace uniforme la decisión modular. Se sigue la inversa baja y, mientras el contador lo permite, también la inversa alta. Todas las hojas terminan en múltiplos de 3. En \(c=3\) se visitan 1.396 estados y la mayor profundidad observada es 27. En \(c=5\) son 1.505 y 28. Estas profundidades son resultado de la terminación de todos los árboles, no una hipótesis de profundidad máxima de la fuente.

## Primer cambio alto en el tramo tardío

Si la preimagen canónica \(y\) viene de una arista de valoración 1, entonces \(y\equiv2\bmod3\). Cambiar a la alta mínima da \(4y+1\equiv0\bmod3\), ya sin otra arista inversa. Como \(y>N\) en el original, el estado nuevo tampoco es una fuente pagada.

En un tramo \(1,1,2,b\), quedan sólo dos situaciones tardías donde \(y\) viene de una valoración 2.

1. **Después del último retorno del episodio**, es decir, después de \(b\). Si el inicio de sus dos unos es \(8Q-1\), hay \(2^{b+1}X=81Q-1\). La alta \(b+2\) desde \(X\) lleva a \(A=54Q-1\).
2. **Después del primer uno del episodio siguiente**, y sólo cuando la pareja anterior acabó en \(b=2\). Su terminal anterior es \(X=(81Q-1)/8\). La alta 3 desde el sucesor de \(X\) lleva a \(A=4X+1=(81Q+1)/2\).

Esto agota las posiciones: el segundo uno y el primer 2 siguen a un uno, y el primer uno que sigue a una pareja acabada en 1 también tiene preimagen canónica de tipo 1.

### Situación 1

Si el episodio previo acabó en 2, su cofactor \(q\) satisface \(64Q=81q+7\), de donde \(Q\equiv1\bmod3\). Si acabó en 1, se tiene \(32Q=81q+3\), de donde \(3\mid Q\) y \(Q/3\equiv2\bmod3\). Son las [ecuaciones exactas de las reentradas](../../COLLATZ_FRONT4B_APERIODIC_REPRO_v1/lean/Front4bTernarySwitch.lean) con la siguiente longitud fijada en dos.

Al invertir desde \(A\) sólo con bajas, las opciones son exclusivamente unos hasta morir. Después de \(r\le3\) de ellos, la coordenada \(B_r+1=2^{r+1}3^{3-r}Q\). En \(r=3\), \(B_r\) es múltiplo de 3 si \(Q\equiv1\bmod3\). En el otro caso permite un cuarto uno, hasta \(B_4=32(Q/3)-1\equiv0\bmod3\). Todos los puntos son mayores que \(8Q-1\), incluso el menor \(32(Q/3)-1>8Q-1\) en la segunda fase.

Si todavía se usa una segunda alta, la única admitida en esos puntos no bloqueados es 3. La tabla calcula el nuevo estado \(U=\phi_3(B_r)\).

| \(r\) bajas entre las altas | Caso | \(U\) | Continuación baja posible |
|---:|---|---|---|
| 0 | Ambos | \(144Q-3\) | Múltiplo de 3 |
| 1 | Ambos | \(96Q-3\) | Múltiplo de 3 |
| 2 | \(3\mid Q\) | \(64Q-3\) | Múltiplo de 3 |
| 2 | \(Q\equiv1\bmod3\) | \(64Q-3=81q+4\) | \(108q+5\), \(72q+3\), múltiplo de 3 |
| 3 | \(3\mid Q\) | \(128(Q/3)-3=108q+1\) | Tabla siguiente |

En \(r=3\) de la otra fase y en \(r=4\) no existe una segunda alta, por divisibilidad de \(B_r\) por 3. Los valores escritos en \(Q\) son mayores que \(8Q-1\). Los de la continuación en \(q\) son mayores que \(8q-1\), el inicio del episodio previo y un checkpoint original mayor que \(N\).

### Situación 2 y continuación común

En la situación 2 el único regreso bajo desde \(A=(81Q+1)/2\) es un uno que lleva a \(27Q\equiv0\bmod3\). Si se toma la segunda alta antes de él, es 3 y produce \(U=108Q+1\). Tanto \(A\) como \(27Q\) están sobre \(8Q-1\). Para estudiar la continuación común, llámese \(q\) al cofactor de \(U=108q+1\).

Las tres primeras inversas bajas son 2 y llevan a \(144q+1\), \(192q+1\) y \(256q+1\). En la zona tardía el cofactor \(q\) es de un episodio que ya tiene un episodio débil previo. Si \(p\) es el cofactor de éste, se obtiene la última parte por las ecuaciones de reentrada.

| Fase de \(q\) | Sustitución de \(256q+1\) | Inversas bajas restantes |
|---|---|---|
| \(32q=81p+3\) | \(648p+25\) | \(864p+33\equiv0\bmod3\) |
| \(64q=81p+7\) | \(324p+29\) | \(216p+19\), \(288p+25\), \(384p+33\equiv0\bmod3\) |

Son aristas exactas de valoración respectivamente \(2\) y \((1,2,2)\), con todos los estados sobre \(8p-1>N\). Antes de usar la sustitución, los estados en \(q\) están sobre \(8q-1>N\). Las posiciones tempranas en las que todavía falta una fase previa se incluyen en la frontera afín anterior. Una vez usadas las dos altas, la cadena posterior es por fuerza la única baja. Esto agota todas las fuentes de la clase.

## Relojes y parte pendiente

Una palabra fuente directa de \(h\) retornos, suma de valoraciones \(s\) y coste \(B\) cumple \(2^sX=3^h w+B\). Cada nodo de los árboles usa la inversión real de esa arista, sin reasignar el libro histórico del original. El prefijo de \(N\) se conserva por la composición \((j+h,S+s,3^hC+2^SB)\) cuando se prolonga con una cola de libro \((h,s,B)\). La prueba sólo compara cada preimagen con ese \(N\) o con un checkpoint anterior de la misma órbita por encima de \(N\).

El siguiente caso de fuentes que la tabla no decide es una valoración 5 o 6, o tres altas entre 3 y 4, con las mismas aristas bajas libres. Tampoco decide si una órbita fija debe abandonar el canal \(L=2\). Una captura fabricada escogiendo una subprogresión ternaria sigue siendo una elección de semillas.

Se aplicó De Bono cambiando el objetivo de buscar una palabra corta a clasificar la primera divergencia desde el reloj inverso original. La combinación de aritmética tardía y frontera finita excluye una clase de profundidad arbitraria. El [verificador exacto](check_multisource.py) reproduce ambas fronteras y las sustituciones tardías en modo normal y optimizado. Usa únicamente las definiciones afines del paquete de fila ya sellado. Puede localizarlo mediante la variable `FRONT4B_ROW_PAPER`.
