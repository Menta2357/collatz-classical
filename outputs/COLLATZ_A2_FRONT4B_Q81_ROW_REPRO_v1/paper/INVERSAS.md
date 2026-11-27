# Fuentes cortas en los cuatro primeros terminales débiles

Se conservan la [fila y el libro físico](RESULTADO.md). Para cada una de
las cuatro clases pendientes se toma únicamente el terminal \(F\)
inmediatamente posterior a la palabra fijada. En la fila de \(c=5\)
el dos adicional es forzado antes de la fase común \(H\).

| Clase de \(u\) | \(c,e\) | Palabra desde \(V\) hasta \(F\) | Reloj histórico de retorno |
|---|---|---|---:|
| \(18\bmod32\) | \(3,1\) | \((1,1,2,1,1)\) | 67 |
| \(34\bmod64\) | \(3,2\) | \((1,1,2,1,2)\) | 67 |
| \(10\bmod128\) | \(5,1\) | \((1,1,2,2,1,1)\) | 68 |
| \(202\bmod256\) | \(5,2\) | \((1,1,2,2,1,2)\) | 68 |

Para todo parámetro de cada clase existe **cero** fuente impar
positiva \(w<N\) que alcance su mismo \(F\) en entre uno y diez
retornos impares. El resultado deja abiertas profundidades mayores
y los encuentros en terminales posteriores.

## Cota necesaria y enumeración exacta

Supóngase que una fuente alcanza \(F\) en \(h\) retornos con
valoraciones positivas de suma \(S\) y aditivo \(B\).
El libro independiente de la fuente satisface
\[
2^S F=3^h w+B,\qquad
B/2^S\ \le\ \sum_{i=1}^h 3^{i-1}/2^i=(3/2)^h-1.
\]
La primera desigualdad se sigue de que el sufijo de \(i\) valoraciones
suma al menos \(i\). Por ello \(w<N\) exige
\[
2^S\bigl(F+1-(3/2)^h\bigr)<3^hN.
\]
Se calcula el primer \(S_0\ge h\) para el que las dos comparaciones
afines con \(S=S_0\) contradicen la desigualdad anterior. Se comparan
intercepto y pendiente después de multiplicar por \(2^h\).
El lado izquierdo crece estrictamente con \(S\), de modo que basta
enumerar \(S\le S_0-1\).

| \(c,e\) | Topes de \(S\) para \(h=1,\ldots,10\) |
|---|---|
| \(3,1\) | \(0,1,2,4,5,7,8,10,12,13\) |
| \(3,2\) | \(0,1,3,5,6,8,9,11,13,14\) |
| \(5,1\) | \(0,1,2,4,6,7,9,10,12,14\) |
| \(5,2\) | \(0,2,3,5,7,8,10,11,13,15\) |

Desde un terminal impar \(y\), toda arista inversa física de
valoración \(a\ge1\) debe tomar la forma \(x=(2^a y-1)/3\).
Si el cociente es entero, es impar, positivo y realiza exactamente
esa valoración hacia \(y\). Se mantienen ambas componentes de la
forma afín. Las pendientes de los cuatro terminales son divisibles
por \(3^{10}\), así que en cada profundidad admisible la
divisibilidad inversa depende únicamente del intercepto, de forma
uniforme sobre todo el parámetro. Ninguna palabra de longitud
\(h\in\{1,\ldots,10\}\) sobrevive al corte y esas congruencias.

El contraste De Bono separa el precio de una fuente, decidido con
su propio aditivo, de la altura del terminal real. Poda
simultáneamente todos los \(S\) restantes y no necesita elegir
representantes de semillas ni ejecutar un barrido orbital. Los
comandos **python3 -B verificar_inversas.py** y
**python3 -BO verificar_inversas.py** comprueban 40 casos.
[Verificador](verificar_inversas.py)
