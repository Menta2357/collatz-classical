# Q51 · Física para diferencia uno en el primer cruce

Sea $N\ge3$. Si el coeficiente del mapa abreviado tiene su primera contracción en el reloj $k$ y el terminal es $T^k(N)=N+1$, Lean demuestra que $N$ es impar, que $N\equiv3$ o $7\pmod{12}$ y que el siguiente paso es el primer descenso:

\[
T^{k+1}(N)=(N+1)/2<N .
\]

La exclusión de un origen par usa la contracción del primer paso. Si $N\equiv1\pmod4$, los primeros dos pasos son impar y par, y el coeficiente ya se contrae en el reloj dos. El terminal hipotético $N+1$ es incompatible con ambos casos. La primera salida impar produce un estado no divisible por tres y cada paso siguiente conserva esa propiedad, de modo que $N+1$ tampoco es múltiplo de tres.

También se demuestra que todos los estados entre los relojes cero y $k$ son distintos. Cualquier igualdad de dos estados transportaría el descenso de $k+1$ a un reloj anterior, donde el núcleo certifica que la órbita permanece a la altura de $N$ o por encima.

Las premisas de primer cruce y diferencia uno permanecen explícitas. La unidad sólo usa el núcleo del reloj, con su mismo $N$ y libro afín.

[Código Lean](TerrasDeltaOne.lean) · [Auditoría](AUDIT.log) · [Recibo](RECIBO.json)
