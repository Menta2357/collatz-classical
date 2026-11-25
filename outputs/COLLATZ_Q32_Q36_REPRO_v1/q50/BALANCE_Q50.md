# Q50 · Entrada común de Front4b y dominio cerrado bajo el siguiente cruce

En $q=12+64s$, la cobertura por pago certificado sube de $624/1024$ a $636/1024$ clases de $s$. Son clases dentro de esta fila. Para las nuevas clases $s\equiv61\bmod128$ y $s\equiv221\bmod256$, Lean certifica respectivamente descenso en $T^{64}$ y pago en $T^{65}$. En la segunda, la valoración real 3 da una captura desde $w<N$ y toda valoración al menos 4 da descenso. Los módulos conservan los libros físicos originales y el de la fuente. [Descenso en T64](LEAN_T64_U1/RESULTADO.md) · [Pago en T65](LEAN/RESULTADO.md) · [Cotejo de clases](FRONT4B_CHECK/RECIBO.json)

## Dominio completo de entrada

Para todo $s=29+32u$, $u\ge0$, el mismo original llega a $F=T^{60}(N)$ y luego, por dos aristas exactas de valoración 2, a $V=T^{62}(N)$ con $N<V<5N/4$ y $V<F$. El reductor exhibe pago o un pivote admitido $x\in[N,V]$ con su libro absoluto. La salida residual puede devolver $x=V$. En particular, $u=2+8t$ activa la palabra $(1,1,2)$ desde $V$: los tres retornos quedan por encima de $V$ y su terminal excede $2N+1$. [Entrada Lean](LEAN_LANDING/RESULTADO.md) · [Contraste físico](REGLA_COMUN_DOMINIO_V_RANGO_PAPER.md)

El consumidor certificado necesita un productor sólo en el dominio admitido $N\le x\le V$, con $N,V$ fijos. Cada cruce físico bajo el pivote vigente devuelve un pago o readmite un pivote $u<x\le V$, conservando la historia. Para cerrar la progresión queda demostrar que **cada** pivote de ese dominio tiene pago o un cruce posterior bajo sí mismo. [Consumidor Lean](LEAN_BOUNDED_DOMAIN/RESULTADO.md)

Para toda la clase $u\equiv11\pmod{16}$, Lean certifica el primer cruce estricto a $T^{65}$ tras $(1,2,2)$ y aplica el reductor. El resultado exhibe un pago o un pivote admitido menor con su libro desde $N$. Esta primera transición ya está demostrada en todo ese dominio. La iteración en los pivotes posteriores sigue pendiente. [Certificado del primer cruce](LEAN_CROSS_U11/RESULTADO.md) · [Cotejo afín](FRONT4B_CHECK/CRUCE_U11.md)

## Puentes y pruebas de refutación

- Las guardas de reserva de A/B/C/D realizan las capturas de Q42 de valoración 6 en nuevas familias físicas. La reserva suficientemente grande paga por descenso tras una racha adaptativa de doses. La reserva 3 admite rachas de unos arbitrariamente largas en distintas semillas. [Pruebas y libros](APORTES_ABCD_PAPER.md)
- Reaplicar la regla de la mitad después de toda ruptura débil produce una fuente por encima de $N$. Cuando esa mitad es impar, es múltiplo de 3 y carece de predecesores en el mapa impar acelerado. El calendario conjunto permite excluir el encuentro de los dos terminales alineados bajo varias guardas, incluida la segunda ruptura débil. Quedan abiertos los encuentros con otros relojes y las renovaciones aperiódicas de una semilla fija. [Calendario conjunto](REENTRY/RESULTADO.md)
- Una fuente pagada que busque el propio $F$ necesita al menos 15 retornos al combinar Q49 con la exclusión de la profundidad 14 para exceso 7. Tras consumir ese exceso, sólo quedan inversas de valoración 1 y su reserva ternaria se agota. El resultado es una cota necesaria. [Prueba del exceso 7](FUSION/RESULTADO.md)
- El manuscrito de Weaver usa el reloj abreviado, que en un libro impar físico $(j,S,B)$ corresponde a $S$. Su exclusión finita condicionada puede consumir un checkpoint con coeficiente contractivo. La captura Q50 con valoración terminal 3 se produce con coeficiente todavía expansivo, $2^{103}<3^{65}$. Los dos criterios se complementan. [Comparación de relojes y premisas](WEAVER/RESULTADO.md)

## Terras 89

La banda $H=92,\ a_1=70$ queda cubierta usando el complemento exacto de Q49 y dos fragmentos que suman 26.736 proyecciones. Una prueba simbólica separada excluye el único extremo físico incompatible en $D_4=95$ para $a_1\ge3,\ D_3\le92$ a la misma altura. Tras unirlas, persisten las obligaciones $a_1\le2$ con $D_3\le92<D_4$, y $3\le a_1\le69$ con $D_3\le92,\ D_4\ge96$, además de $H=146$ y del caso global Q0. [Banda A70](../q49/terras_evidence/COLLATZ_Q50_20261126/TERRAS/RESULTADO.md) · [Prueba de D4=95](../q49/terras_evidence/COLLATZ_Q50_20261126/TERRAS_D495_GAPS_ORDINAL/RESULTADO.md)
