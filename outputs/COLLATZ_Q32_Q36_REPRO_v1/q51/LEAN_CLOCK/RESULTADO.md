# Q51 · Reloj físico para la formalización de Terras

`TerrasClock` usa Lean 4.21.0 y `Std`. El mapa abreviado aplica $x/2$ a un estado par y $(3x+1)/2$ a uno impar. La órbita parte del mismo $N$ en el índice cero. `oddCount N k` cuenta los estados fuente impares del prefijo de longitud $k$. `oddRuns N k` cuenta un inicio por racha impar máxima del prefijo, bien en el índice cero, bien en una transición de par a impar. El conteo conserva la racha si el prefijo acaba en ella.

`exact_book` prueba la identidad entera

\[
2^k T^k(N)=3^{\operatorname{oddCount}(N,k)}N+\operatorname{additive}(N,k).
\]

Al pasar un estado impar, el nuevo aditivo es $3C+2^k$. Al pasar uno par, se conserva $C$. La composición de los libros conserva los relojes de ambos tramos y el $N$ de origen.

`prior_no_descent` prueba $N\le T^k(N)$ para todo $k<\tau$ si $\tau$ es el primer reloj en que $3^{\operatorname{oddCount}(N,\tau)}<2^\tau$. `first_contraction_last_even` prueba que la última arista antes de ese reloj sale de un estado par. Existencia de $\tau$ y descenso en $\tau$ quedan como obligaciones separadas.

Desde esta carpeta, con Lean 4.21.0:

```sh
lean -j1 -DwarningAsError=true -o TerrasClock.olean TerrasClock.lean
LEAN_PATH="$PWD" lean -j1 -DwarningAsError=true AuditTerrasClock.lean
```

[Núcleo Lean](TerrasClock.lean) · [Auditoría](AUDIT.log) · [Recibo](RECIBO.json)
