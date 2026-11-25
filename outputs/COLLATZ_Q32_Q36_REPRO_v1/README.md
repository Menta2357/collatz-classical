# Capturas en Collatz y primer descenso con 88 rachas

Paquete de investigación reproducible de Collatz Classical. Reúne diez unidades de prueba en Lean 4.21.0 y un verificador aritmético independiente para el resultado condicionado de Terras–Weaver. [Repositorio Collatz Classical](https://github.com/Menta2357/collatz-classical)

## Qué acredita cada pieza

Para impares positivos, \(T(x)=(3x+1)/2^{\nu_2(3x+1)}\) es el retorno impar. Un libro `j/S/B` representa \(j\) retornos físicos, suma \(S\) de las valoraciones reales y término aditivo \(B\), conservando \(2^S y=3^j x+B\). Un certificado `Paid` entrega un descenso bajo la semilla original \(N\) o la coincidencia física de dos trayectorias en un mismo impar, con una fuente impar positiva \(w<N\). La conclusión de llegada a 1 en el consumidor correspondiente usa la hipótesis inductiva para las semillas impares menores.

| Pieza | Dominio y resultado |
| --- | --- |
| [Q32](lean/P5J131EarlyCapture.lean) | Para \(N=206466174079+2^{40}j\) y \(j\equiv131\pmod{4096}\), Lean certifica pago en el retorno 33. Es un descenso si \(j=131+256(32q)\) y una captura de fuente menor si \(j=131+256(16+32q)\). El caso de captura incluye toda la progresión Q29. |
| [Q33](lean/P5J131Residual.lean) | Para \(j=131+256u\), la primera ruptura después de \(r\ge3\) unos desde \(H=T^{28}(N)\) da captura cuando su valoración física cumple \(b\ge3\). Esto incluye toda la guarda \(u\equiv2\pmod4\). Lean acredita además el descenso en T34 para \(u\equiv24\) o \(60\pmod{64}\). |
| [Q34](lean/AB9T3Adapter.lean) | Para \(N=2^{64}(177+512t)-5\), el selector certifica una fuente menor que coincide en T3 cuando \(t\equiv1858\pmod{59049}\), \(9883\pmod{19683}\) o \(3007528\pmod{4782969}\). Los dos libros y la desigualdad estricta \(w<N\) se preservan en cada fila. |
| [Q35](lean/P5J131T35.lean) | En el mismo origen de Q33, Lean certifica \(T^{35}(N)<N\) para \(u\equiv92\) o \(120\pmod{256}\). La última arista conserva su valoración física \(c\ge3\), con libro \(35/(53+c)/188961729523762715\) o \(35/(53+c)/192339429244290587\), respectivamente. |
| [Q36](lean/P5U8Fold.lean) | Para el mismo origen de Q33, un lema de plegado de divisiones conserva las valoraciones reales y ambos libros. Las progresiones `u=40+128k` y `u=360+512k` dan captura pagada en T35 y T36. La progresión `u=904+1024k` da captura pagada y descenso estricto en T36. |
| [Q37](lean/A2U392.lean) | Para `u=392+1024k`, T36 es el primer cruce bajo el pivote T28 y conserva el libro `36/57/572514688105501265`. Para `k` par hay descenso bajo el mismo N en T37. Los lemas de continuación acreditan captura en una ruptura fuerte o readmisión a rango menor en una ruptura de valoración 2, bajo sus respectivas guardas físicas. La activación de otro cruce desde el nuevo pivote sigue abierta. |
| [Q38](lean/A2R1Descents.lean) | En el mismo origen de Q37, para `k≡1 (mod 8)` hay descenso en T39, T40 o T41 en las cuatro guardas `1 mod 16`, `57 mod 64`, `25 mod 128` y `73 mod 128`. El último exponente queda libre sobre su piso y el libro desde N conserva el aditivo exacto. Son 12 de las 16 clases de la rama módulo 128. |
| [Q39](lean/A2T42.lean) | Para el mismo origen de Q37, `k=265,89,331 mod 512` da descenso en T42. Para `k=41 mod 256` hay captura física con fuente menor que N y libro auxiliar. También hay descenso en esta fila si la valoración terminal es al menos 4. La rama de un solo 1 pasa a 52 de 64 clases módulo 512. La guarda 331 pertenece a la rama de cuatro unos. |
| [Q40](lean/A2T43.lean) | Para el mismo origen de Q37, `k=9,361,393,857,1193,1241 (mod 2048)` da descenso en T43. Las guardas `k=169,217,1417 (mod 2048)` dan captura física en T43 con una fuente impar menor que N y ambos libros. La unión certificada de la rama de un solo 1 cubre 217 de sus 256 clases módulo 2048. |
| [Q41](lean/A2T43Inverse.lean) | Para el mismo origen y pivote de Q37, `k=873,1385,1897 (mod 2048)` da una captura en T43. La fuente impar positiva `w=(27Z+7)/32<N` llega en cuatro retornos. Los dos libros se acreditan, y el terminal original aún es mayor que N. La unión certificada cubre 220 de las 256 clases de la rama de un solo 1. |
| [Terras–Weaver 88](terras88/README.md) | Prueba y verificaciones aritméticas. Si el primer cruce del coeficiente \(3^{d_k}<2^k\) es finito y contiene hasta 88 rachas impares máximas en el mapa abreviado, coincide con el primer descenso estricto bajo la semilla original. La aparición de ese cruce y el caso general de Collatz siguen abiertos. |

Las guardas explícitas reproducidas de Q32, Q33, Q35 y Q36 cubren 371 de las 1024 clases de `u` módulo 1024. Q36 aporta 11 clases disjuntas dentro de `u≡8 (mod 32)`, un subcanal de 32 clases. La guarda anterior Q22 `u=79 (mod 256)` añade otras cuatro clases al inventario del proyecto. Algunas clases restantes admiten la captura adaptable de Q33 cuando se demuestra su guarda física. El alcance de Q34 es la unión de sus tres guardas, en cada una de las cuales `N mod 9` vale, respectivamente, 0, 3 o 6. El recuento de novedad de Q34 depende de verificar la procedencia de la tabla anterior de 30 guardas en papel.

## Verificar desde una copia limpia

Requisitos para ejecutar ambos verificadores: Python 3.10 o posterior y Lean 4.21.0. El archivo [lean-toolchain](lean-toolchain) fija la versión que usa `elan`. La dependencia Lean externa es `Std`, que viene con ese toolchain. Desde la raíz de esta edición:

```sh
elan toolchain install leanprover/lean4:v4.21.0
python3 -B scripts/verify.py --lean "$(elan which lean)"
python3 -B terras88/verify.py
```

Con Lean 4.21.0 ya en `PATH`, basta ejecutar `python3 -B scripts/verify.py`. El script verifica los SHA-256, recorre la clausura de imports y reconstruye módulos y auditorías en un directorio temporal con un hilo por compilación. Usa un `LEAN_PATH` aislado de los objetos de otros proyectos. Las auditorías importan los módulos recién construidos y comparan la clausura de axiomas de cada declaración con el inventario fijado. Para verificar sólo las huellas y las fuentes incluidas, usa `python3 -B scripts/verify.py --hashes-only`. El modo rápido de Terras recalcula las cribas y desigualdades indicadas y comprueba los recibos de las búsquedas largas. [Alcance y opciones de Terras](terras88/README.md)

## Proveniencia

Las 100 fuentes Lean, incluidas las 33 auditorías de importación, se copiaron byte a byte desde las fuentes fijadas del proyecto. El [inventario](provenance/lean_sources.json) registra sus rutas relativas de procedencia y sus huellas, y [la tabla de axiomas](provenance/axioms_expected.json) fija las 102 declaraciones auditadas. Se mantienen separados los resultados Lean y aritméticos. Los objetos Lean se generan al verificar esta edición. El recibo de compilación aislada de Q36 identifica también sus objetos del entorno de investigación. [Recibo Q36](provenance/q36_frozen_build.json) · [Recibo Q37](provenance/q37_frozen_build.json) · [Recibo Q38](provenance/q38_frozen_build.json) · [Recibo Q39](provenance/q39_frozen_build.json) · [Recibo Q40](provenance/q40_frozen_build.json) · [Recibo Q41](provenance/q41_frozen_build.json) · [Recibo Q42](provenance/q42_frozen_build.json) · [Recibo Q43](provenance/q43_frozen_build.json) · [Recibo de reconstrucción completa hasta Q43](provenance/clean_build.json)

Las fuentes y los informes propios son una contribución al repositorio bajo sus condiciones de licencia. Terras 88 documenta las dependencias de la extensión y enlaza los suplementos externos. [Licencia Apache 2.0](../../LICENSE)

## Q42 · Ruptura 2 tras una racha de unos

Desde el mismo origen, con un pivote físico P y P < 2N+1, las continuaciones (6,e) y (1,6,e) después de la ruptura 2 permiten capturar con la fuente impar positiva (P−1)/2 < N. La longitud de la racha y la valoración terminal real e quedan libres. Los dos libros se componen por separado. Una tercera regla certifica descenso estricto para el primer retorno tras la ruptura cuando se verifica la guarda histórica de pago.

Dos familias realizadas en A2 caen en un mismo residuo pendiente de Q41. Una tercera progresión en papel, situada en otro residuo pendiente, usa el plegado de un retorno ya certificado en Lean. La rama completa sigue abierta. [Frontera de Q42](q42/FRONTERA_Q42.md) · [Prueba en papel y testigos](q42/RESULTADO_CAPTURA.md)

## Q43 · Tras agotar la reserva de la ruptura 2

Lean compone las dos trayectorias con cualquier reserva D y certifica tres guardas de captura posteriores. Dos usan la continuación (1,1,8,e) con cero o un par previo. La tercera usa una fuente alternativa de tres unos para la salida (1,7), con su condición de precio. La verificación afín acredita cinco progresiones de A2, entre ellas un pago tras catorce macros por el plegado existente. El cierre del complemento sigue abierto. [Informe y reproducción](q43/INFORME_Q43.md)

## Q44 · Dos certificados en A2 y la segunda renovación

La clase completa k=3049 módulo 16384 tiene una captura física en T46. Para k=428769801+2³¹(44+128t), Lean acredita T60<N y conserva la última valoración real b≥8. Se compilaron las dos extensiones con sus padres congelados y auditoría separada. El informe registra también una readmisión y una captura tras la segunda renovación comprobadas en papel, así como dos reducciones de Terras 89. [Informe Q44](q44/INFORME_Q44.md)

## Q45 · Fuente mínima en T73

Lean certifica una fuente menor que el mismo N que llega al terminal original T73 en dos retornos de valoración 1 y acredita su unicidad entre todas las fuentes menores de hasta dos retornos. Los módulos nuevos compilaron con padres congelados y auditoría separada. La frontera en papel para la salida (1,7) distingue descenso y profundidad mínima hasta tres a medida que se alarga el segundo banco. [Informe Q45](q45/INFORME_Q45.md) · [Recibo Lean](provenance/q45_frozen_build.json)

## Q46 · Capturas A2 y cambios de etiqueta

Lean certifica toda la clase k≡473 módulo 16384, las dos guardas de T66 y la variación exacta de la reserva centrada para etiquetas iguales y distintas. Las comprobaciones aritméticas reproducen los libros de B y C y la realización de varios calendarios finitos. La banda a₁=72 de Terras 89 queda cubierta a altura 92. [Balance Q46](q46/BALANCE_Q46.md) · [Recibo Lean](provenance/q46_frozen_build.json)

## Q47 · Transferencia de Mahler y profundidad de una fuente

Una progresión física de Front4b alcanza T103 desde N, siempre por encima de N, y la fuente menor (T60−5)/2 alcanza el mismo terminal en 43 retornos. Se reutiliza la regla de coalescencia de Mahler y se certifican las guardas y ambos libros mediante aritmética afín. Una segunda prueba da una profundidad necesaria creciente para renovaciones de etiqueta variable y excluye captura de hasta 14 retornos en T62 bajo la guarda 1→2. Son pruebas en papel con verificadores. [Transferencia](q47/TRANSFERENCIA_MAHLER_FRONT4B.md) · [Profundidad](q47/PRUEBA_PROFUNDIDAD.md)

## Q48 · Toda la fila Front4b paga en T60

Para q=108+128s y todo s natural, Lean certifica que la fuente impar positiva (2F−1)/3<N alcanza F=T60(N) en un retorno. Se conservan el exponente real 95 desde N, su aditivo y el libro independiente de la fuente. El encuentro paga antes de las rupturas. En Q44 la mitad q=44+128s ya desciende en T60. Q48 certifica también la preservación de la ventana estrecha y la disminución del rango de las readmisiones A2, bajo su productor físico. [Cierre Q48](q48/CIERRE_FRONT4B.md) · [Recibos Lean](provenance/q48_frozen_build.json)

## Q49 · Front4b con valoración seis

En la familia q=12+64s, Lean certifica el descenso o una captura pagada para 39 clases de s módulo 64 a más tardar en T64. Se conservan los libros físicos desde el mismo N y el adaptador de Q48. Q32 ya cubre toda Q29 desde T33. En Terras 89 se certifica la banda a₁=71 de H=92 mediante dos fragmentos que reúnen 20.712 proyecciones. [Balance Q49](q49/BALANCE_Q49.md) · [Recibos Lean](provenance/q49_frozen_build.json)

## Q50 · Entrada completa y rango acotado en Front4b

En la fila $q=12+64s$, el pago certificado cubre 636 clases de $s$ módulo 1024. En toda la rama $s=29+32u$, Lean verifica una entrada física común en $T^{62}$ que paga o readmite un pivote con historia. El consumidor certificado preserva el dominio y reduce el rango al cruzar bajo el pivote vigente. Para $u\equiv11\bmod16$ el primer cruce ya está certificado en $T^{65}$. Queda pendiente producir ese cruce o un pago en cada estado residual. Terras 89 incorpora la banda $a_1=70$ a altura 92 y la prueba simbólica de $D_4=95$ en su dominio. [Balance Q50](q50/BALANCE_Q50.md) · [Recibos Lean](provenance/q50_frozen_build.json)
