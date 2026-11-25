# Terras 89 · \(a_1=71\), primeros huecos hasta cuatro

Para todo impar positivo \(x\) con \(x+1<2^{92}\), primera racha impar \(a_1=71\) y primer hueco par \(1\le b_1\le4\), se cumple \(2^{D_5(x)}\le6^{92}\). La proyección nueva cubre \(D_3\le92<D_4\). Las otras dos ramas se cubren con la recurrencia para \(D_4\le92\) y el certificado de Q44 para \(D_3>92\). [Prerregistro](PREREGISTRO.md) · [Certificado de Q44](../../COLLATZ_Q44_20261125/TERRAS89_D3_HIGH/RESULTADO.md)

Se ejecutaron 14.297 congruencias en 0,064921 s. El proyector retuvo 103 fuentes del residual, con 55, 28, 17 y 3 para \(b_1=1,2,3,4\), respectivamente. Para cada fuente se verificaron paso a paso cinco rachas físicas y sus huecos máximos, así como el libro \(2^kT^k(x)=3^d x+C\) en cada paso desde el mismo \(x\). El máximo de la parte proyectada fue \(D_5=102\), alcanzado en dos fuentes. En \(x=2327401792799614599811825663\), las parejas racha impar y hueco par son \(((71,1),(6,1),(10,2),(11,2),(4,4))\), con \((D_3,D_4,D_5)=(87,98,102)\). El recibo conserva ambos máximos. [Verificador](check.py) · [Recibo](RECIBO.json)

    python3 -B q49/terras_evidence/COLLATZ_Q49_20261125/TERRAS/check.py

En \(H=92\), el complemento queda en \(D_3\le92<D_4\) con \(a_1=71,\ b_1\ge5\), o \(a_1\le70\). Para el primer residual se conoce un límite de 6.415 congruencias, incluida una proyección para la cola del primer hueco. \(H=146\) y Q0 con desplazamiento uno permanecen abiertos. [Coste de la partición](PREREGISTRO.md) · [Recibo de la reducción de Terras 89](../../COLLATZ_Q37_20261125/TERRAS89_PAPER/RECIBO.json)
