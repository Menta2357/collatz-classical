# Q45 · Profundidad mínima tras la segunda renovación

## Certificado de T73

En toda la progresión \(k=365634215903753+288230376151711744t\),
Lean acredita la captura de \(E=T^{73}(N)>N\) por la fuente impar
\(z<N\) en dos retornos, ambos de valoración 1. Se conservan por separado
el libro original \((73,115,411443494169899340644307646523772515)\)
y el de la fuente corta \((2,2,5)\). La fuente \(w\) de tres retornos
certificada en papel en Q44 satisface \(T(w)=z\).

El cofactor de entrada \(A\) verifica \(A\equiv63\bmod64\).
Las fórmulas correctas son
\[
w=(A-3)/4,\qquad z=(3A-5)/8,\qquad
J=(9A-7)/16,\qquad E=(27A-5)/32 .
\]
La comprobación exacta da \(z<N<J\) y \(2N\le3z\) uniformemente.
El teorema de T73 acredita que cualquier fuente impar positiva menor
que el mismo \(N\) que llegue a \(E\) en como máximo dos retornos
debe ser \(z\) y usar dos retornos.
[Teorema Lean](../lean/T73Minimal.lean) · [Recibo de la familia](T73_FAMILY_LEAN.json)

La primera comunicación del hilo contenía el término local incorrecto
\(-7\) para \(8z\), corregido antes de la compilación. Los libros y las
fórmulas de este informe se cotejaron con enteros Python y Lean. El hilo
detectó además una pérdida de precisión en la serialización de un recibo
Q44 de la tarifa en T53. Ninguna prueba de este informe depende de sus
valores serializados.

## Frontera completa de profundidad hasta tres para la salida (1,7)

Se conserva la fila física de Q44 \(k=521+4096t\), el mismo original
\(N\ge150278508408401808511\), y \(V'=T^{53}(N)\) con libro
\((53,80,113817632854000981000472755)\). Si \(D'=3m+2\) y el conector
real tras consumir los \(m\) pares es \((1,7)\), el estado de entrada al
conector cumple \(X+5=24A=(9/8)^m(V'+5)\). Las cuatro fórmulas anteriores
describen la cadena física de tres unos hacia el mismo terminal para
cualquier \(m\) bajo esta guarda.

| Pares \(m\) del segundo banco | Resultado en \(E\) |
| --- | --- |
| 0–4 | \(E<N\), descenso directo |
| 5–8 | Profundidad mínima 1, fuente única \(J\) a esa profundidad |
| 9–11 | Profundidad mínima 2, fuente única \(z\) a esa profundidad |
| 12–15 | Profundidad mínima 3, fuente única \(w\) a esa profundidad |
| Desde 16 | Toda fuente impar positiva menor que \(N\) hacia ese terminal necesita al menos cuatro retornos |

Para cada estado \((pA-e)/d\), el signo de su diferencia con \(N\)
se fija por el entero afín
\[
p9^m(3^{53}N+B_{53}+5\cdot2^{80})
  -24\cdot8^m2^{80}(dN+e).
\]
En ambos lados de cada frontera se verifican el signo de la pendiente
y el del valor en el menor \(N\) de la fila. \(A\) crece con \(m\)
a \(N\) fijo. Esto cubre los intervalos completos. Para la minimalidad,
en toda arista física \(T(x)+1\le(3/2)(x+1)\), con igualdad para
valoración 1. Una arista de valoración al menos 2 satisface además
\(T(x)+1\le x+1\). Por ello, si el predecesor de profundidad \(d-1\)
de la cadena de unos es al menos \(N\), toda fuente menor con
profundidad \(d\) debe usar sólo unos: otra palabra tendría a lo sumo
el crecimiento máximo de \(d-1\) unos. La palabra de unos fija la
fuente por su identidad afín.

El original hasta \(E\) conserva
\[
(55+2m,\ 88+3m,\ 3^{2m+2}B_{53}+2^{80}(45\cdot9^m-40\cdot8^m)).
\]
La fuente de \(d\) unos tiene libro \((d,d,3^d-2^d)\). Para realizar
cada \(m\), sea \(u_0\) el cofactor de la primera reserva con
\(256u_0=B+Gt\), donde \(B=3384512724039106948104\) y \(G=3^{47}\).
Se elige \(c\equiv63(3\cdot9^m)^{-1}\bmod64\) y se resuelve
\(81(B+Gt)-256\equiv2^{D'+11}c\bmod2^{D'+17}\). La pendiente impar
permite resolverlo para todo \(m\) y mantiene el mismo origen de la fila.
El verificador comprueba los signos de las ocho fronteras y las palabras
afines de sus cilindros completos, sin usar redondeo de enteros.
[Verificador](check_phase_two_price.py) · [Recibo](FRONTERA_PRECIOS.json)

## Integración independiente de T66

Para \(k=3805769794057+2^{44}t\), después de la readmisión \(7\to1\)
de Q44, la guarda \(t\equiv2\bmod4\) queda cubierta. En \(t\equiv2\bmod8\),
la valoración real final es al menos 4 y hay descenso en T66.
En \(t\equiv6\bmod8\), la valoración es 3 y una fuente
\((T^{63}(N)-1)/2<N\) alcanza el terminal original, aún superior a \(N\),
por \((1,2,1)\). El libro de esa captura original es
\((66,104,216921042856660603989194204771465)\) y el auxiliar es \((3,4,23)\).
Se verificaron en papel ambas progresiones afines. Las salidas débiles
de valoración 1 y 2 permanecen abiertas.
[Recibo exacto](T66_CHECK.json)
