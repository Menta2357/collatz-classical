# Q50 · Descenso en T64 para todo u ≡ 1 mod 4

Sea $s=29+32u$ con $u=1+4t$, es decir, $s=61+128t$. El origen sigue siendo $N=110482433359989887+2^{58}k$, donde $k=428769801+2^{31}(12+64s)$.

Desde $F=T^{60}(N)$ se certifican las aristas afines $(2,2,1)$ hasta $X=T^{63}(N)$. El libro local es $(3,5,37)$ y el libro hasta $X$ desde $N$ es $(63,99,7568280446574857051711818616875)$.

La divisibilidad $8\mid3X+1$ deja libre la valoración final real $d\ge3$. El margen de descenso es

\[
8N-(3X+1)=6260253897778201510012208105032
+13095348644963240970631709857784t>0.
\]

Por tanto $T^{64}(N)<N$ en toda la progresión, con libro $(64,99+d,23338666639838685855883807453313)$. Lean certifica además que $2^{d+1}$ no divide $3X+1$. Esta unidad promueve la guarda conocida en papel de Q49, reutilizando su prefijo físico hasta T60. El resultado de T65 para $u\equiv6\pmod8$ cubre una progresión distinta.

[Fuente Lean](Front4bT64U1.lean) · [Auditoría](AUDIT.log) · [Recibo](RECIBO.json)
