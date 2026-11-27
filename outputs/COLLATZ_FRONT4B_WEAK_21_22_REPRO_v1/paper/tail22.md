# Front4b. Dos capturas después de la primera pareja de doses

## Dominio

Se usa el origen \(N\) de la [fila E1](../../COLLATZ_FRONT4B_GUARDS_REPRO_v1/paper/E1.md) y el checkpoint \(J\) anterior a los unos máximos. En \(c=3\), \(u\equiv18\bmod32\) y el libro absoluto de \(J\) tiene relojes \(65,102\). En \(c=5\), \(u\equiv10\bmod128\) y tiene relojes \(66,104\). En ambas clases \(N<J<4N+1\), \(J\equiv1\bmod3\) y el valor \(J+1\) se escribe \(2^{L+1}Q\) con \(L\ge2\) y \(Q>0\) impar.

Sea \(R=T^L(J)=2\cdot3^LQ-1\) y sea \(w=(J-3)/4=2^{L-1}Q-1\). Entonces \(w\) es impar y \(0<w<N\). Los \(L-2\) unos de la fuente llegan a \(U=2\cdot3^{L-2}Q-1\) y \(R=9U+8\). Esto distingue la entrada de la de `A2Mixed22Adaptive`, que necesita \(x=9U'+40\) tras una racha de parejas \((1,2)\). Las dos igualdades son incompatibles módulo 9.

## Dos guardas de captura certificadas en Lean

Cada fila empieza en \(R\) para el original y en \(U\) para la fuente. Los prefijos de la tabla llegan a \(Z\) y \(4Z+1\). Se agrega la valoración original real \(\gamma\) desde \(Z\), y la de la fuente es \(\gamma+2\). Ambas aristas terminan en el mismo impar por \(3(4Z+1)+1=4(3Z+1)\).

| Palabra original antes de \(\gamma\) | Palabra fuente antes de \(\gamma+2\) | Libros de los dos prefijos | Fase de \(M=3^LQ\) |
|---|---|---|---|
| \((2,2,10)\) | \((2,4,3,2,1)\) | \((3,14,37)\), \((5,12,4349)\) | \(7585\bmod16384\) |
| \((2,2,6,6)\) | \((2,4,3,1,3,1)\) | \((4,16,1135)\), \((6,14,18167)\) | \(56225\bmod65536\) |

Las fases salen de las identidades \(2^{14}Z=54M+10\) y \(2^{16}Z=162M+1054\), respectivamente, imponiendo \(Z\) impar. Las igualdades respectivas del otro libro son \(4096(4Z+1)=243U+4349\) y \(16384(4Z+1)=729U+18167\). El compilador sellado de palabras reconstruye todas las aristas físicas desde estos libros y la positividad y paridad de sus extremos.

Los libros compuestos, incluyendo la última arista, son

| Fase | Desde \(J\) | Desde \(w\) |
|---|---|---|
| Primera | \((L+4,L+14+\gamma,\ 3^{L+4}+16414\cdot2^L)\) | \((L+4,L+12+\gamma,\ 3^{L+4}+16414\cdot2^{L-2})\) |
| Segunda | \((L+5,L+16+\gamma,\ 3^{L+5}+68698\cdot2^L)\) | \((L+5,L+14+\gamma,\ 3^{L+5}+68698\cdot2^{L-2})\) |

Si el libro de \(J\) desde \(N\) es \((j,S,B)\), el libro original absoluto se obtiene como \((j+h,S+s,3^hB+2^SD)\) con la cola \((h,s,D)\) de la primera columna de libros. El libro de \(w\) empieza en \(w\). La consecuencia de llegada a 1 usa inducción sobre los impares positivos menores que \(N\).

Ambas fases son realizables en ambas clases E1 para cada \(L\ge2\). En cada clase el paso afín de \(J\) es 8 veces un impar. Fijar \(Q\bmod 2^n\) a partir de \(3^LQ\bmod 2^n\) equivale a fijar \(J+1\bmod 2^{L+1+n}\). Como \(J+1\) es siempre múltiplo de 8, la congruencia determina una única clase de su parámetro módulo \(2^{L+n-2}\). Los residuos de \(Q\) son impares, de manera que la longitud de unos es exacta. **paysTwoTwoTen** y **paysTwoTwoSixSix** certifican las capturas para la fase indicada y un segmento histórico dado. La instanciación de los residuos en ambas progresiones es aritmética.

## Obstrucción de profundidad en el segundo terminal

Sea \(Y\) el extremo físico de \((1^L,2,2)\) desde \(J\), y \(F\) el extremo del primer dos. Los dos doses son decrecientes y \(Y>J>N\), pues
\[
Y-1=(9/16)\big((3/2)^L(J+1)-2\big)\ge (81J+9)/64.
\]
La inversión canónica desde \(Y\) es \((2,2,1^L)\). Toda fuente que preserve este prefijo hasta \(T^2(J)\) y tenga profundidad \(L+2+k\) llegaría al anterior primer terminal E1 \(T^2(J)\) en \(k+2\) retornos. La [exclusión independiente](../../COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1/paper/INVERSAS.md) lo impide para \(k+2\le10\).

Para una inversión \(\phi_a(x)=(2^ax-1)/3\), la paridad de \(a\) queda fijada por \(x\bmod3\). Además \(\phi_{a+2}=4\phi_a+1\) y \(\phi_1(x)+1=(2/3)(x+1)\). En los pasos canónicos se usan las valoraciones mínimas 1 o 2 de la paridad requerida. El primer inverso es al menos \(F>J\). Toda inversión de longitud hasta \(L+2\) termina sobre \(N\): una primera desviación después de la primera arista multiplica el valor por al menos 4 y pierde como máximo un término aditivo durante los unos restantes. Si la desviación ocurre en la primera arista, el segundo paso es al menos \(\phi_1(4F+1)=2R+1\), y los unos restantes conservan el factor 2 en la coordenada \(x+1\).

Para \(1\le k\le6\), una desviación anterior a \(T^2(J)\) que preserve la primera arista y cambie una posterior debe subir la valoración en al menos 4. Subirla en 2 daría \(4y+1\equiv0\bmod3\), porque el correspondiente antecesor canónico \(y\) está después de al menos dos unos y es \(2\bmod3\). Un múltiplo de 3 carece de otra preimagen física. Así, después de \(L+2\) aristas, la coordenada \(x+1\) queda al menos en \(16(J+1)-10\).

Si se cambia la primera valoración de 2 a por lo menos 6, el segundo paso es al menos \(\phi_1(16F+5)\), cuya coordenada trasladada supera \(8(R+1)-2\). Si se la cambia a 4, el segundo paso mínimo llega a \(2R+1\). Las inversiones mínimas de valoración 1 posteriores llegarían a \(2J+1\equiv0\bmod3\) y ya no podrían prolongarse. Una desviación de al menos 2 en alguna de esas aristas hace que \(x+1\) sea al menos \(8(J+1)-2\) al cabo de \(L+2\) inversiones. En todos los casos divergentes, el factor mínimo \(2/3\) en las siguientes \(k\) aristas implica
\[
w+1\ge (2/3)^k\,\big(8(J+1)-2\big)>N+1.
\]
La última desigualdad se verifica por sus coeficientes afines para \(k=6\) en las dos clases y se conserva para \(k\le6\). Por tanto, en ambas clases **ninguna fuente menor que \(N\) alcanza este segundo terminal en hasta \(L+8\) retornos impares**. La demostración de esta exclusión es aritmética y usa la exclusión previa de \(T^2(J)\).

## Complemento

El doble dos se realiza para cualquier \(L\) tomando \(3^LQ\equiv1\bmod16\). Después de esos dos, la reserva de \(Y-1\) permite comprimir los doses restantes mediante \(T(x)-1=3(x-1)/4\). Esto da el criterio exacto
\[
3^r(R-1)<4^r(N-1)
\]
para que \(r\) doses físicos desde \(R\) desciendan. No hay una cota de \(r\) en términos de \(L\) que se desprenda sólo de su realizabilidad. En particular \(3^LQ\equiv17\bmod32\) realiza exactamente dos doses y luego un uno, para cualquier \(L\); esa salida sigue por encima de \(N\). Las dos capturas de la tabla necesitan terminales posteriores y fases específicas. Falta una guarda que cubra el complemento, especialmente la ruptura uno tras los doses y las salidas fuertes que no pagan la altura acumulada.

Se aplicó De Bono cambiando el terminal de encuentro. Igualar directamente mediante una identidad afín uniforme el primer terminal de \((2,2,a)\) con la fuente cuarto exigiría coste fuente 253 y cinco retornos. Al descomponer ese coste, \(253=81+4\cdot43\) y \(43=27+16\cdot1\), pero el siguiente coste parcial 1 queda por debajo de 9. Cambiar a \(4Z+1\) hace que la última arista dé el encuentro y abre las fases de la tabla.

El verificador exacto pasa en modo normal y optimizado. Lean verifica los dos teoremas de captura con sus 88 dependencias congeladas y axiomas estándar. [Recibo Lean](../provenance/source_receipts.json)
