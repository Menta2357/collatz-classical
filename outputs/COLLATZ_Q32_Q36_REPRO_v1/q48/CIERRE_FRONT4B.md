# Front4b Q48 · La fila paga antes de sus rupturas

## Resultado

Para todo \(s\ge0\), sean \(q=108+128s\),
\(k=428769801+2^{31}q\) y \(N=110482433359989887+2^{58}k\).
En **toda esa fila**, incluido \(s\equiv7\pmod8\), hay una
captura pagada en \(F=T^{60}(N)>N\). La fuente alcanza \(F\) en
un retorno impar. Lean certifica ambos caminos y la igualdad de todas
sus continuaciones desde el encuentro. Con la hipótesis de convergencia
para los impares positivos menores que \(N\), toda semilla de la fila
llega a \(1\). En particular la fila queda excluida como ubicación
del mínimo contraejemplo global.

No hace falta activar una readmisión para cerrar esta fila. Cualquier
ruptura investigada está después de un encuentro que ya paga. La
llegada incondicional a \(1\) de cada fuente de la fila es una
obligación distinta.

## Demostración desde el mismo origen

El prefijo físico de 36 retornos se reutiliza de A2. El sufijo físico
hasta \(F\) tiene 24 retornos y 38 divisiones. La última valoración
es exactamente 7. El exponente acumulado en \(F\) es 95 y el aditivo
es 253163701604367108480427299121.

\[
\begin{aligned}
N(s)&=66972346602545741868196940927+
                79228162514264337593543950336s,\\
F(s)&=71667327748009080469224948461+
                84782316550432407028588866402s.
\end{aligned}
\]

La forma más corta usa que \(F\equiv2\pmod3\) e impar. Luego
\(w=(2F-1)/3\) es un impar positivo y su siguiente valoración es
exactamente 1, pues \(3w+1=2F\). El precio es estrictamente favorable
para todo el parámetro:
\[
N-w=19194128103873021555380308620+
          22706618147309399574484706068s>0.
\]

| Libro | Retornos | Divisiones | Aditivo |
| --- | ---: | ---: | ---: |
| \(N\to F\) | 60 | 95 | 253163701604367108480427299121 |
| \(w\to F\) | 1 | 1 | 1 |

La auditoría independiente reconstruyó cada uno de los 60 retornos
con intercepto y pendiente y comprobó la valoración uniforme y el precio.
El hilo **Instanciar fusión Mazur/F3** encontró el encuentro al probar
el pivote antes del terminal tardío. El argumento consume una
preimagen física explícita.

La otra mitad \(q=44+128s\), ya certificada en Lean en Q44, desciende en
T60 con la valoración real \(b\ge8\). En la fila base de \(q\), la
valoración en T60 satisface \(b\ge7\) exactamente para
\(q\equiv44\pmod{64}\). Por tanto la unión de ambas progresiones
queda pagada a más tardar en T60.
[Lean Q44](../lean/Front4bT60.lean)
· [Código del encuentro](../lean/Front4bEarlyMeeting.lean)
· [Recibo del encuentro](LEAN_PAID_EARLY/RECIBO.json)
· [Comprobación entera](RECIBO_FRONTIER.json)

## Qué se conserva para otras filas

Antes de encontrar el pago en \(F\), De Bono separó el coste del
terminal tardío, el desplazamiento de la fuente y el dominio de
readmisión. Produjo resultados reutilizables.

- En la primera ruptura tras los pares, el último \(m\) con descenso
  bajo \(N\) es \(1,7,13\) en las rupturas directas \(2,3,4\).
  En una ruptura parcial \((1,b)\), para \(b=3,4,5,6\) los umbrales
  son \(4,10,16,21\). Los umbrales de cruce bajo el pivote son
  \(2,8,14\) y \(4,10,16,22\), respectivamente. El verificador
  comprueba los dos márgenes afines de la frontera y, en los casos
  intermedios, prefijo físico y salida en dos subprogresiones.
- Hay capturas tardías reutilizables para la ruptura directa 2 seguida
  de \((3,e)\), \(e\ge3\), y para la salida parcial \((1,b)\) con
  \(b\ge7\). En la segunda, la fuente \(w=(F-15)/4<N\) repite \(m\)
  pares y usa \((5,b-6)\) cuando el original usa \((1,b)\). Se obtienen
  libros independientes. Estas guardas quedan subsumidas por el pago
  anterior dentro de la fila presente.
- Medir sólo \(P-N\) y exigir a la vez que se repita la misma palabra
  \((1,2)\) falla. Por ejemplo, para \(s=3959+4096t\) hay un primer
  cruce real \(N<T^{65}(N)<F\), pero el nuevo pivote empieza con
  \((1,1,2)\). Conserva las condiciones de A2, donde la racha inicial
  admite más de un uno.
- El adaptador Lean de ventana estrecha conserva el **estado admitido
  completo**, su libro desde el mismo \(N\) y la guarda \(11P<12N\).
  Si el consumidor devuelve un residual \(u\), verifica
  \(N\le u<P\), \(11u<12N\) y \(u-N<P-N\). La inducción requiere
  un productor total sobre ese dominio para extender la estrategia
  a otras filas; la fila de este informe se paga directamente.

[Descenso directo en Lean](LEAN/RESULTADO.md)
· [Adaptador Lean](LEAN_THIN/RESULTADO.md)
· [Guarda \(d=2\)](LEGACY/RESULTADO_D2.md)
· [Comprobador y libros de los testigos](check_frontier.py)
