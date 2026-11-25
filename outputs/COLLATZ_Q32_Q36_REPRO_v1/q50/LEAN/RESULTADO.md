# Q50 · Pago en T65 para todo u ≡ 6 mod 8

La fila conserva el original $N=110482433359989887+2^{58}k$, con $k=428769801+2^{31}(12+64s)$. Se fija $s=29+32u$ y $u=6+8t$, o equivalentemente $s=221+256t$, con $t\ge0$. Esta guarda es disjunta del descenso de T64 para $u\equiv1\pmod4$ de Q49.

Desde $F=T^{60}(N)$, el tramo físico $(2,2,1,1)$ llega a $X=T^{64}(N)$. Su libro local es $(4,6,143)$, y el original llega a $X$ con libro $(64,100,23338666639838685855883807453313)$.

Se verifica $8\mid3X+1$ y la valoración física $d$ del último retorno se mantiene exacta. Si $d\ge4$, el margen $16N-(3X+1)>0$ da $T^{65}(N)<N$. Si $d=3$, entonces $Y=T^{65}(N)\equiv2\pmod3$ y $2Y<3N+1$. El consumidor Q48 toma la fuente impar positiva $w=(2Y-1)/3<N$, que llega al mismo $Y$ en un retorno con su libro $(1,1,1)$. Se conserva el libro del original hasta $Y$ en ambos casos:

\[
(65,100+d,71283650519744286969148125565315).
\]

El caso $d=3$ es una captura genuina: la diferencia afín $3X+1-8N$ es positiva. La llegada a 1 en ese caso usa la convergencia inductiva de la fuente menor. El certificado cubre la subfamilia completa indicada y deja el resto de $s\equiv29\pmod{32}$ sujeto a sus propias guardas.

[Fuentes Lean](Front4bT65U6.lean) · [Auditoría](AUDIT.log) · [Recibo](RECIBO.json)
