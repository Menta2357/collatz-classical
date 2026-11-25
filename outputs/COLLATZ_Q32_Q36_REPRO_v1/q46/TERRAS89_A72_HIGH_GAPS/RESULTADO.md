# Terras 89 · Banda \(a_1=72\) completa a altura 92

Para toda fuente impar positiva \(x\) con \(x+1<2^{92}\) y \(\nu_2(x+1)=72\), se cumple \(2^{D_5(x)}\le6^{92}\). En \(D_4\le92\) vale la recurrencia \(D_5<92+(\log_2 3)D_4\). En \(D_4>92\) se combinan los dos fragmentos disjuntos determinados por la longitud física \(b_1\ge1\) del primer hueco par. El nuevo fragmento cubre \(b_1\ge3\), incluyendo una sola proyección para toda la cola \(b_1\ge20\). [Recibo del primer fragmento](../TERRAS89_A72_LOW_GAPS/RECIBO.json) · [Recibo de la unión](RECIBO_UNION.json)

| Fragmento | Congruencias | Fuentes con \(D_3>92\) | Fuentes con \(D_3\le92<D_4\) | Máximo \(D_5\) con \(D_4>92\) |
| --- | ---: | ---: | ---: | ---: |
| \(b_1\in\{1,2\}\) | 7.004 | 6 | 68 | 104 |
| \(b_1\ge3\) | 8.826 | 2 | 28 | 101 |
| Unión | 15.830 | 8 | 96 | 104 |

La única ejecución del segundo fragmento tardó 0,023146 s. Para las 30 fuentes retenidas se verificaron por separado las cinco rachas físicas y el libro \(2^kT^k(x)=3^d x+C\) de cada prefijo desde el mismo \(x\). Una fuente que alcanza el máximo de este fragmento es \(1319736149135165399645552639\), con \((D_3,D_4,D_5)=(77,97,101)\) y parejas \(((72,3),(1,1),(4,2),(20,1),(4,2))\). El recibo registra también el segundo máximo y sus relojes. [Recibo](RECIBO.json)

Para cotejar la unión con los recibos sellados, sus verificadores originales y los prerregistros sin repetir proyecciones:

    python3 -B q46/TERRAS89_A72_HIGH_GAPS/check_union.py

En \(H=92\) quedan \(a_1\le71,\ D_3\le92<D_4\). \(H=146\) o una cota equivalente del rango 11 siguen pendientes. El caso global de Terras 89, Q0 con desplazamiento uno, permanece abierto.
