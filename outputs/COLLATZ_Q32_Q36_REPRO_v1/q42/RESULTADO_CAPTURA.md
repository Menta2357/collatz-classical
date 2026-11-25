# Q42 · Dos capturas adaptativas tras una ruptura 2

**Demostración en papel.** Se conserva el origen impar \(N\) y el inicio físico \(P=T^p(N)\) de la racha, con libro \((p,S_P,B_P)\). Se exige \(N<P<2N+1\), guarda comprobada en las filas de media de Q41. No se extiende a las filas altas. Sea \(P+1=2^{R+1}v\), con \(R\ge2\) y \(v\) impar. Se supone la palabra original \((1^R,2)\) hasta V.

La fuente \(w=(P-1)/2\) es impar positiva y menor que N. Desde ella hay \(R-1\) unos y una ruptura real \(c=1+\nu_2(3^Rv-1)\ge3\), hasta \(Y=(3^Rv-1)/2^{c-1}\). La igualdad \(V=3\cdot2^{c-2}Y+1\) da \(3V+1=4+9\cdot2^{c-2}Y\). Sea \(d=\nu_2(3V+1)\) y \(U=T(V)\). El cambio de representación consiste en comparar el cofactor ternario en los dos libros y buscar un estado auxiliar \(B=4A+1\) frente a un estado original \(A\). Esa igualdad permite un encuentro en el retorno siguiente con una diferencia exacta de dos divisiones.

## Valoración 6 después de V

Si \(d=6\), necesariamente \(c=4\): con \(c=3\) la fórmula da \(d=1\) y con \(c\ge5\) da \(d=2\). Se obtiene \(U=(9Y+1)/16\) y \(Y\equiv7\pmod8\). Por tanto Y realiza dos unos y llega a

\[
B=(9Y+5)/4=4U+1.
\]

Para la valoración real \(e=\nu_2(3U+1)\ge1\), se tiene \(3B+1=4(3U+1)\). La valoración auxiliar es exactamente \(e+2\) y ambos llegan a \(K=T(U)\).

## Valoración 1 después de V y luego 6

Si \(d=1\), necesariamente \(c=3\) y \(U=9Y+2\). Supóngase que la arista siguiente de U tiene valoración 6. Su terminal es \(A=(27Y+7)/64\). La congruencia \(27Y+7\equiv64\pmod{128}\) fuerza \(Y\equiv27\pmod{32}\); en toda esa clase la palabra auxiliar \((1,2,1)\) es física. Su terminal es

\[
B=(27Y+23)/16=4A+1.
\]

Si \(e=\nu_2(3A+1)\) es la valoración real siguiente, la fuente sale de B con valoración exacta \(e+2\) y llega al mismo \(K=T(A)\).

## Libros independientes

En la tabla, los libros se escriben como retornos, divisiones y aditivo. El libro de la columna original parte de P; para obtener el libro absoluto desde N se usa \((p+m,S_P+S,3^mB_P+2^{S_P}C)\) si la fila local es \((m,S,C)\). El libro auxiliar parte de w.

| Salida original tras V | Palabra desde P | Libro local original | Palabra desde w | Libro auxiliar |
|---|---|---|---|---|
| \((6,e)\) | \((1^R,2,6,e)\) | \((R+3,R+8+e,3^{R+3}+125\cdot2^{R+1})\) | \((1^{R-1},4,1,1,e+2)\) | \((R+3,R+7+e,3^{R+3}+125\cdot2^R)\) |
| \((1,6,e)\) | \((1^R,2,1,6,e)\) | \((R+4,R+9+e,3^{R+4}+259\cdot2^{R+1})\) | \((1^{R-1},3,1,2,1,e+2)\) | \((R+4,R+8+e,3^{R+4}+259\cdot2^R)\) |

Los aditivos originales se obtienen añadiendo cada arista por \(C'=3C+2^S\), desde el aditivo \(3^{R+1}-2^{R+1}\) de \((1^R,2)\). La relación \(P=2w+1\) y el ahorro exacto de una división llevan al aditivo auxiliar de cada fila. Las palabras físicas ya verificadas autorizan esa comparación. Para deducir llegada a 1 se consume la hipótesis inductiva sobre w.

## Realización con R y e arbitrarios en las filas variables

En cada fila de media variable, Q41 da \((P+1)/2^{R_{\min}+1}=L_0+L_1t\) con \(L_1\) impar. En la primera familia, fijar \(R\ge R_{\min}\) y \(e\ge1\), y resolver para v

\[
3^{R+3}v\equiv-125+2^{e+7}\pmod{2^{e+8}}.
\]

La reducción módulo 256 fuerza \(3^{R+2}v\equiv129\pmod{256}\), que da ruptura 2 y \(d=6\). La congruencia original da la valoración exacta e, pues \(3U+1=(3^{R+3}v+125)/128\). En la segunda familia se resuelve

\[
3^{R+4}v\equiv-259+2^{e+8}\pmod{2^{e+9}}.
\]

Reducir módulo 512 da \(3^{R+3}v\equiv255\pmod{512}\). Esto fuerza ruptura 2, \(d=1\) y luego valoración 6. La congruencia completa da el e real, pues \(3A+1=(3^{R+4}v+259)/256\). En ambos casos el v obtenido es impar; la condición \(L_0+L_1t\equiv2^{R-R_{\min}}v\) en el módulo correspondiente aumentado en \(R-R_{\min}\) bits selecciona una progresión no vacía de parámetros t.

## Dos semillas dirigidas de A2 con \(R=10,e=1\)

Se usó la fila \(k=7177+8192t\), \(p=43\), con libro \((43,68,1753466362202633845243)\), y se verificaron directamente las valoraciones de las dos historias. En los dos casos todo el prefijo original anterior al encuentro permanece sobre N y se cumple \(w<N<K\).

| Salida tras V | \(t\) | N | \(w\) | K |
|---|---:|---:|---:|---:|
| \((6,1)\) | 11210 | 26470932876376435617942655 | 14720192821330483179308031 | 89526145856788940177474669 |
| \((1,6,1)\) | 10186 | 24053081237147177268530303 | 13375652282882459309347839 | 122023258636104647675270327 |

Para la primera semilla, los libros absolutos son \((56,87,3341710708341165458845706977)\) y \((13,18,1722323)\); para la segunda, \((57,88,9955014427485847884404162723)\) y \((14,19,5048185)\). Las dos sustituciones verifican la física y la desigualdad de precio. No se hizo una criba de órbitas ni se compiló Lean. Las salidas diferentes de esas dos guardas permanecen abiertas.
