# Q49 · Descenso en T61 para \(s\equiv3\pmod4\)

La fila usa $q=12+64s$, $k=428769801+2^{31}q$ y $N=110482433359989887+2^{58}k$. El módulo certifica para **todo** $s\ge0$ el prefijo físico hasta $F=T^{60}(N)$, con libro $(60,94,253163701604367108480427299121)$ y

\[
F(s)=16161180670369550395566597319+84782316550432407028588866402s.
\]

Para $s=3+4t$, $8\mid3F+1$ y se verifica el margen exacto

\[
8N-(3F+1)=199623356940951646062839639856
+250262801623040517153636808552t>0.
\]

Por tanto la valoración física $d$ del retorno siguiente satisface $d\ge3$ y $T^{61}(N)\le(3F+1)/8<N$. El certificado mantiene $d$ libre por encima de ese piso y acredita que $2^{d+1}$ no divide $3F+1$. El libro absoluto del descenso es $(61,94+d,779298145441667409839667884947)$.

Los teoremas `index_formula`, `seed_affine` y `history60` sirven a los demás consumidores de la fila con el mismo origen. La conclusión de descenso aquí se limita a $s\equiv3\pmod4$.

[Fuentes Lean](../../lean/Front4bT61S3.lean) · [Auditoría](AUDIT.log) · [Recibo](RECIBO.json)
