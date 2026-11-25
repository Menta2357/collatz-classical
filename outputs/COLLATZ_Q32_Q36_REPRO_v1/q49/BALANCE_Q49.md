# Q49 · Front4b con valoración seis y siguiente banda de Terras 89

## Front4b

Se fija \(q=12+64s\), \(k=428769801+2^{31}q\) y
\(N=110482433359989887+2^{58}k\). Para todo \(s\ge0\), el
prefijo físico hasta \(F=T^{60}(N)\) tiene libro
\((60,94,253163701604367108480427299121)\) y el último retorno
tiene valoración seis. El estado satisface \(2N<F<13N/6\) por
dos comparaciones afines.

**De Bono.** El inverso inmediato de \(F\) falla por precio.
\(F\equiv1\pmod3\) exige exponente par, al menos dos, para esa
fuente. Se probaron dos cambios de enfoque, buscar en la historia
anterior y comparar el coste en un terminal posterior común a
varias palabras. El prefijo previo no dio una nueva fuente de una
o dos aristas para toda la fila. El segundo enfoque conduce a los
siguientes certificados físicos.

| Corte | Clases nuevas de \(s\) | Pago |
| --- | --- | --- |
| \(T^{61}\) | \(s\equiv3\pmod4\) | Descenso |
| \(T^{62}\) | \(s\equiv5\pmod{16}\) | Descenso |
| \(T^{62}\) | \(s\equiv6\pmod8\) | Descenso con valoración \(\ge4\), captura con valoración 3 |
| \(T^{63}\) | \(s\equiv2,8,13,25\pmod{32}\) | Descenso |
| \(T^{64}\) | \(s\equiv17,26,32\pmod{64}\) | Descenso con valoración \(\ge4\), captura con valoración 3 |

Cada clase de la tabla es disjunta de las anteriores. Son **18 de
32 clases** a más tardar en \(T^{63}\) y **39 de 64 clases** a más
tardar en \(T^{64}\), dentro de esta fila. En los casos con
valoración 3, el terminal \(Y\) tiene \(Y\equiv2\pmod3\) y
\(2Y<3N+1\); la fuente impar \(w=(2Y-1)/3<N\) tiene su propio
libro \((1,1,1)\). La valoración final se deja libre allí donde
sólo se usa una cota inferior. La comparación por sí sola no
fija el último reloj.

Las tres guardas de \(T^{64}\) proceden de las permutaciones
\((2,1,1),(1,2,1),(1,1,2)\) desde \(F\), con suma de
valoraciones cuatro y aditivos \(29,23,19\). Tras el siguiente
retorno, las tres satisfacen
\(2^{b+4}Y=81F+c\) con \(c\in\{103,85,73\}\), lo que
explica la misma cota de precio. Lean guarda el libro original
compuesto desde \(N\) al exhibir cada descenso o encuentro.
El adaptador de captura de Q48 se reutiliza directamente.

Quedan fuera de este corte **25 clases módulo 64**. El recibo
las enumera. Una captura permite concluir llegada a \(1\) con
la hipótesis de convergencia de la fuente menor. Estas clases
pagadas quedan excluidas como lugar del mínimo contraejemplo,
sin inferir convergencia de la fila completa ni de Collatz.

[Cálculo afín](verify_frontier.py) · [Libros y congruencias](RECIBO_FRONT4B.json)
· [Recibo Lean de T61](LEAN/RECIBO.json) · [Recibo Lean del corte](LEAN_CUT/RECIBO.json)

## Rupturas adaptativas y primer caso sin readmisión

Para \(s\equiv0\pmod4\), una racha física de \(r\) unos seguida
de la ruptura real \(b\ge\lceil2r/3\rceil+3\) da descenso
respecto al mismo \(N\), para cualquier longitud \(r\ge2\).
Una congruencia exacta realiza toda pareja \((r,b)\).
El testigo \(s=380+4096t\) desciende en T66, fuera del corte Lean
T64. Dos pliegues adicionales del hilo B también pagan guardas
fuera de ese corte. Son resultados en papel.

En el residual \(s\equiv29\pmod{32}\), las dos valoraciones
posteriores a T60 son exactamente \((2,2)\). Hay un cruce físico
bajo \(F\), pero los estados relevantes permanecen fuera de la
ventana \(11P<12N\). El consumidor de readmisión estrecha aún
requiere una entrada posterior válida o un pago físico distinto.
[Prueba de las rachas](RACHA_UNOS_PAPER.md)
· [Fallo preciso de readmisión](REGLA_COMUN_PAGO_TEMPRANO_RESIDUAL_THIN_PAPER.md)

## P5–R · Corrección de la cola de trabajo

Q32 ya dispone de `q29_capture33`, para **todo** parámetro \(t\)
de Q29. Identifica \(q=501072404818209+2^{51}t\) en la guarda
de captura. Incluye la mitad par que el balance anterior dejaba
abierta. El mismo \(N\) alcanza \(K=T^{33}(N)>N\) y una fuente
impar positiva \(w=(2K-1)/3<N\) alcanza \(K\) en un retorno.
Los libros son \((33,52,19619647838721539)\) y \((1,1,1)\).
El trabajo sobre P5–R debe restringirse ahora a un dominio
realmente exterior a Q29.
[Teorema Q32](../lean/P5J131EarlyCapture.lean)
· [Resultado Q32](../README.md)

## Terras 89

Se completó la banda de altura \(H=92\) con primera racha
\(a_1=71\), mediante dos fragmentos disjuntos por el primer hueco
par. Se cotejaron 20.712 proyecciones de congruencias y los libros
físicos de las 107 fuentes retenidas en \(D_3\le92<D_4\),
con máximo \(D_5=102\) en ese residual. Se aplica el certificado
previo al caso \(D_3>92\) y la recurrencia cuando \(D_4\le92\).
En \(H=92\) quedan \(a_1\le70\). La segunda altura 146 o su
sustituto y el caso global \(Q0,\Delta=1\) siguen abiertos.
[Resultado](terras_evidence/COLLATZ_Q49_20261125/TERRAS/A71_HIGH_GAPS/RESULTADO.md)
· [Recibo de unión](terras_evidence/COLLATZ_Q49_20261125/TERRAS/A71_HIGH_GAPS/RECIBO_UNION.json)

### Reducción posterior de H92

El corolario de cuatro rachas se cotejó en papel. Para \(3\le a_1\le89\) y \(D_4\le94\) se obtiene \(D_5\le237\). En el residual activo esto retira \(D_4=93,94\) para \(3\le a_1\le70\). Quedan \(a_1\le2\) en el residual previo y \(3\le a_1\le70,\ D_4\ge95\). [Cotejo del corolario](terras_evidence/COLLATZ_Q49_20261125/TERRAS_A70_ORDINAL_ENVELOPE/COTEJO_COROLARIO_94.md)
