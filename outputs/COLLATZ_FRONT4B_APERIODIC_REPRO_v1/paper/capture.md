# Front4b. Captura dentro de cualquier prefijo débil finito

## Alcance

Se fija una de las dos filas E1 y una lista finita realmente realizable de episodios \((1^{L_i},2,b_i)\), con \(L_i\ge2\) y \(b_i\in\{1,2\}\). Las parejas y longitudes pueden cambiar libremente. Para **cada** lista existe una subprogresión infinita de su cilindro físico en la que una fuente impar positiva menor que la semilla original \(N\) alcanza el último terminal débil \(X\). El encuentro ocurre antes de exigir otra ruptura al original. También se admite fijar cualquier refinamiento diádico adicional que mantenga el itinerario, incluida la longitud exacta de la siguiente racha.

La construcción emplea una fuente \((1^h,a)\), con \(a\ge2\) y reloj propio. El certificado general de progresión, precio, encuentro físico y libro quedó en Lean como **affinePaidSubprogression**. La identificación de los cilindros de las dos filas se hace abajo por aritmética exacta. La construcción selecciona una clase ternaria de semillas. Sigue pendiente una regla que fuerce el pago para cada semilla fija del cilindro amplio.

## Empalme ternario y precio

En la progresión física inicial, escribimos
\[
N(t)=N_0+nt,\qquad X(t)=X_0+2^e3^K t,\qquad n>0,\quad e,K\ge1.
\]
El terminal es positivo e impar y es una unidad módulo 3 por su última arista física. Se reutiliza **ternary_exponent_lift** para elegir \(a\ge2\) con \(3^K\mid 2^aX_0+2\). Si \(X_0\equiv1\bmod3\), se levanta \(X_0\) y se agrega uno al exponente. Si \(X_0\equiv2\bmod3\), se levanta \(2X_0\) y se agregan dos al exponente. El cociente resultante es natural y positivo.

Si \(c=(2^aX_0+2)/3^K\), imponer
\[
c+2^{a+e}t\equiv0\pmod{3^{h+1-K}}
\]
es posible porque la pendiente normalizada es unidad módulo 3. **affine_congruence_above** proporciona una progresión completa \(t=t_0+3^{h+1-K}u\) por encima de cualquier corte solicitado. En ella
\[
3^{h+1}\mid 2^aX+2,\qquad
w+1=\frac{2^h(2^aX+2)}{3^{h+1}}.
\]
El cociente \((2^aX+2)/3^{h+1}\) es par y positivo. Los \(h\) unos físicos desde \(w\) llegan a \(A=(2^aX-1)/3\), seguido de la división exacta \(a\) hacia \(X\). El libro auxiliar es
\[
(h+1,\ h+a,\ 3^{h+1}-2^{h+1}).
\]
El libro original hasta \(X\) se entrega intacto como **Segment** con origen \(N(t)\). Para consumir el encuentro hacia la llegada a 1 se usa la hipótesis inductiva sobre los impares positivos menores que ese \(N(t)\).

Para pagar, basta \(h=2(a+e+2K+1)\). Escribiendo \(r=a+e+2K+1\), se tiene \(2^a2^e3^K\le2^r\) y \(2^{h+r}=8^r\le9^r=3^h\). Eso deja un margen estricto de pendiente frente a \(3^{h+1}(N+1)\). El corte concreto de Lean \(t\ge2^h(2^aX_0+2)+1\) absorbe el intercepto. De ahí sale \(0<w<N\) para toda la progresión escogida. **oneBreakGuard** certifica el mismo libro físico y la comparación estricta a partir de la congruencia y el precio. Se reutilizan los lemas ternarios sellados de Q17. El cambio aquí es aplicarlos a un terminal todavía débil tras un itinerario arbitrario con una sola valoración distinta de uno en la fuente.

## Aplicación a ambas filas de Front4b

En las filas \(u\equiv18\bmod32\) y \(u\equiv10\bmod128\), el punto inicial \(J\) tiene pendiente \(8\cdot3^{65}\) o \(8\cdot3^{66}\), respectivamente. Para una palabra original de \(m\) retornos, \(S\) divisiones y coste \(B\), el terminal impar fija \(3^mJ+B\equiv2^S\bmod2^{S+1}\). Los dos unos iniciales imponen \(J\equiv7\bmod8\). La fase restante fija una clase del parámetro original módulo \(2^{S-2}\); en ella la pendiente de \(X\) es \(2\cdot3^{65+m}\) o \(2\cdot3^{66+m}\). Cualquier refinamiento diádico sólo añade una potencia de 2. La hipótesis de **affinePaidSubprogression** queda así verificada para toda historia original físicamente fijada. Los relojes absolutos y el aditivo se obtienen por composición con el historial E1 sellado, sin cambiar \(N\).

## Dos barreras para fuentes económicas

- **Sin ninguna valoración distinta de uno.** Después de una arista real de valoración 2, el sucesor \(U\) satisface \(3\nmid U+1\). Una fuente formada sólo por unos que alcance un terminal tras \(i\) unos originales desde ese \(U\) debe tener profundidad \(h\le i\) y coincide con uno de los estados entre \(U\) y el terminal. Si \(h>i\), la unicidad de la inversión de \(i\) unos obligaría a que \(U\) tuviera una preimagen de valoración 1, contradicción módulo 3. **noOnlyOnesAfterTwo** formaliza este corte. Cada checkpoint de la traza débil tiene tal descripción tomando el último dos, incluido el que precede a \(J\). Todos esos puntos quedan por encima de \(N\). En particular una fuente de sólo unos nunca paga en el canal débil, incluso con profundidad libre.
- **Cualquier fuente de profundidad fija.** Para \(k\) episodios físicos y un encuentro mediante \(h\) retornos desde \(0<w<N\), **sourceDepth** obliga a
  \[
  2^h81^k(J+1)\le3^h64^kN,\qquad 2^h81^k<3^h64^k.
  \]
  Se componen la cota de crecimiento débil ya sellada y la cota de altura física de la fuente de P5. En particular \(k<2h\), ya que \((81/64)^2>3/2\). El resultado deja fuera un catálogo de profundidad fija para terminales tardíos, sin restringir la forma de esas fuentes.

### Horizonte de una fuente con una sola ruptura para un N fijo

Esta consecuencia en papel combina el precio de profundidad de Lean con el prefijo auxiliar exacto. Sea \(A\) el último impar tras los \(h\) unos de una fuente \(w<N\). La identidad \(2^h(A+1)=3^h(w+1)\), con \(A\) impar, obliga a \(2^{h+1}\mid w+1\). Así \(2^{h+1}\le w+1\le N\). En un terminal situado después de \(k\) episodios débiles, **sourceDepth** da \(k<2(h+1)\) para la fuente completa de \(h+1\) retornos. Por tanto cualquier captura de este formato satisface \(k<2\lfloor\log_2 N\rfloor\) para el mismo \(N\). Después de ese horizonte, hace falta otro formato de fuente o un certificado distinto.

### Coste necesario de la única ruptura auxiliar

En papel se puede precisar qué volumen exige la construcción. Sea \(X\) el fin del último episodio, \(J_*\) el inicio de sus \(L\) unos y \(Q\) el cofactor de \(J_*+1=2^{L+1}Q\). En el canal, \(\eta=\nu_3(Q)\in\{0,1\}\), pues un último par débil fija \(\nu_3(X+1)=1\) si \(b=1\) y \(0\) si \(b=2\). La misma cota vale en la entrada E1.

Si una fuente \((1^h,a)\) paga, necesariamente \(h\ge a-1\). Para \(a\ge h+2\), el precio \(w+1=2^h(2^aX+2)/3^{h+1}\) supera \(X\), que es al menos \(N+1\). La paridad de \(a\) coincide con la del último \(b\). La opción \(a=b\) vuelve al punto físico anterior al último retorno, excluido por el reinicio tras el dos. Para \(a=b+2\), el máximo \(h\) es \(L+1+\eta\) y aun en ese máximo \(w+1=2(2/3)^\eta(J_*+1)>J_*+1\).

Para las opciones restantes ponga \(s=a-b-2\), par positivo. Entonces
\[
2^aX+2=2\big(2^s3^{L+2}Q-(2^s-1)\big).
\]
Como \(s\) es par, \(\nu_3(2^s-1)=1+\nu_3(s)\) por la factorización de la potencia de 4. Esta valoración es menor que \(h+1\) usando \(s<a\) y \(h\ge a-1\). Para que la congruencia de la fuente se cumpla, las dos hojas de la diferencia deben tener la misma valoración de 3. Por ello
\[
\nu_3(s)=L+1+\eta,\qquad a\ge b+2+2\cdot3^{L+1+\eta}.
\]
Esta barrera aritmética se refiere a la forma \((1^h,a)\). Explica por qué la existencia de capturas en todas las fases físicas finitas no proporciona un procedimiento corto ni una regla de aparición para cada semilla fija.

## Verificación

Lean verificó cuatro teoremas sobre 126 fuentes y objetos parentales fijados por huella, con axiomas estándar. El verificador normal y optimizado reconstruye doce itinerarios afines de ambas filas, con o sin refinamiento, y sus levantamientos modulares. En estos casos el exponente \(a\) puede ocupar más de cien bits en binario. La prueba exacta evita materializar \(2^a\) para esas filas. Un ensayo afín débil de tamaño menor materializa dos certificados completos con \(h=12684\) y \(a=6322\). No se recorren órbitas masivamente.

[Código Lean](../lean/Front4bAperiodicCapture.lean) · [Recibo Lean](../provenance/source_receipts.json) · [Verificador](check_capture.py)
