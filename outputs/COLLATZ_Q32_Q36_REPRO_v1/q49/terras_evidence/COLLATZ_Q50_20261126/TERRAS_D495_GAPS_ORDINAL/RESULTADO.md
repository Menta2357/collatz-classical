# Q50 — cierre simbólico de D4=95 por huecos físicos

## Resultado

**PASS_PAPER_D4_EQ_95**, con dos revisiones independientes complementarias y un contraste de constantes enteras. **LEAN=NOT_RUN.**

Para toda fuente N>0 impar del mapa abreviado S, con

    N+1<2^92,   a1≥3,   D3≤92,   D4=95,

se cumple

    D5≤237,    y por tanto 2^D5≤6^92.

No se exige que un primer cruce haya ocurrido. No se ejecutó ningún lote A70, ninguna órbita ni proyección de congruencias. El mismo argumento cubre todas las bandas incluidas en el enunciado.

## Convenciones y dos libros de la misma órbita

S(n)=n/2 para n par y S(n)=(3n+1)/2 para n impar. No es el mapa acelerado impar.

x0=N. La racha i parte de x_(i−1), con

    ai=nu2(x_(i−1)+1)≥1,
    ui=(x_(i−1)+1)/2^ai, impar positivo,
    Pi=3^ai ui−1, par,
    bi=nu2(Pi)≥1,
    xi=Pi/2^bi, impar positivo.

Sean yi=xi+1, D_j=sum ai, B_j=sum bi y k_j=D_j+B_j. Cada xi es S^k_i(N). El dominio da 3≤A=a1≤90, porque D3≤92 y a2,a3≥1.

Libro original:

    2^k_j x_j=3^D_j N+C_j,
    C0=0,
    C_next=3^a C+2^k(3^a−2^a).

Libro desplazado, sin cambiar de fuente:

    2^k_j y_j=3^D_j(N+1)+E_j,
    E0=0,
    E_next=3^a E+2^(k+a)(2^b−1),
    E_j=C_j+2^k_j−3^D_j.

En particular,

    E4/3^D4
      =sum_(i=1..4) (2/3)^D_i · 2^B_(i−1)(2^bi−1).       (1)

No se construye una fuente menor ni se invoca inducción. Los dos libros pertenecen al mismo N.

## 1. Bloques y pérdida que antes se omitía

Definimos h(a)=(3^a+1)/2^(a+1). Para un bloque físico,

    y_next/y ≤ h(a).

El cociente respecto de esta cota es exactamente

    R(a,b,u)=2^(1−b)(3^a+(2^b−1)/u)/(3^a+1) ≤1.          (2)

Disminuye al crecer b o u, con los otros parámetros fijos. Al componer cuatro bloques desde N+1<2^92 y usar 2^a5≤y4:

    2^D5 < 2^88 product_(i=1..4)(3^ai+1) · product R_i.   (3)

Para p,q≥1:

    4(3^(p+q−1)+1)−(3^p+1)(3^q+1)
      =3(3^(p−1)−1)(3^(q−1)−1)≥0.                     (4)

Con D4=95, fusionar a2,a3,a4 da

    product_(i=1..4)(3^ai+1)
      ≤G:=16(3^A+1)(3^(93−A)+1).                        (5)

No se afirma que los extremos de estas cotas puedan realizarse simultáneamente.

## 2. Caso B4≥6: huecos largos

Hay dos posibilidades exhaustivas.

### Dos huecos de longitud al menos dos

Si a es impar y b≥2, la congruencia física 3^a u≡1 (mod 4) obliga a u≡3 (mod 4), luego u≥3. Por (2), R≤1/2.

Si a es par, a≥2 y, usando u≥1,

    R≤(3^a+3)/(2(3^a+1))≤3/5.

Así dos huecos fuertes proporcionan product R_i≤(3/5)^2=9/25. Con (5), producto corregido ≤(9/25)G.

### Sólo un hueco de longitud al menos dos

B4≥6 obliga a que ese hueco mida al menos tres.

- Si a=1, la congruencia módulo 8 exige u≡3 (mod 8), de modo que R≤1/3<9/25.
- Si a≥3, incluso ignorando la mejora del cofactor, R≤(3^a+7)/(4(3^a+1))≤17/56<9/25.
- Si a=2, R≤2/5. Este bloque no es el primero, porque A≥3. Fijar esa longitud antes de fusionar los otros dos bloques da una cota más estrecha:

      product(3^ai+1)≤40(3^A+1)(3^(92−A)+1).

  Su razón respecto de G es

      (5/2)(3^(92−A)+1)/(3^(93−A)+1)≤25/28,

  pues 93−A≥3. Tras multiplicar por 2/5, queda 5/14<9/25.

En todos los casos B4≥6:

    2^D5 < 2^92 (9/25)(3^A+1)(3^(93−A)+1).

Para 3≤A≤90, ambos exponentes A y 93−A son al menos tres. La identidad (3^(A−3)−1)(3^(90−A)−1)≥0 prueba

    (3^A+1)(3^(93−A)+1)≤28(3^90+1).

La comparación entera

    252(3^90+1)<25·2^146

da 2^D5<2^238, y por integridad D5≤237. El recibo conserva un margen positivo exacto de

    30627700694958782828939662436700860907596200.

Esta comparación también se puede comprobar en papel desde
7·3^15=100442349<100663296=6·2^24, elevando a seis y usando
100·117649−252·46656=7588.

## 3. Caso B4≤5: conservar el aditivo exacto

Cada bi es uno, salvo a lo sumo un valor dos. Para cada i,

    2^B_(i−1)(2^bi−1)≤3·2^(i−1).

Además D_i≥A+i−1. De (1):

    E4/3^95
      ≤3(2/3)^A sum_(j=0..3)(4/3)^j
      =(175/9)(2/3)^A
      <2^A,

porque A≥3 y 175<9·3^3=243.

N+1 es múltiplo de 2^A y estrictamente menor que 2^92. Por tanto

    N+1≤2^92−2^A.

El aditivo cabe en ese margen; no se elimina ni se supone cero. El libro desplazado da

    y4 < 3^95·2^92/2^(95+B4)=3^95/2^(B4+3).             (6)

La comparación 3^95<2^151 puede verificarse con
3^17<2^27 y 3^10<2^16, ya que 95=5·17+10.

### B4=5

Por (6), y4<2^143. Luego a5≤142 y D5=95+a5≤237.

### B4=4: exclusión física del extremo abstracto

Aquí b1=b2=b3=b4=1. Por (6), y4<2^144.

Supongamos D5≥238. Entonces a5≥143. Como y4 es múltiplo positivo de 2^a5, la única posibilidad es

    y4=2^143,   x4=2^143−1.

El cuarto bloque físico y b4=1 exigen

    3^a4 u4=2x4+1=2^144−1.

D3≤92 y D4=95 implican a4≥3. Pero

    2^144 mod81=55,

de modo que nu3(2^144−1)=3. Resulta forzosamente a4=3 y

    y3=8(2^144−1)/27.

Ahora b3=1 y a3≥1 exigen que 2x3+1 sea divisible por 3. Sin embargo,

    2x3+1=2y3−1=(2^148−43)/27,
    (2^148−43) mod81=27,

por lo que ese cociente vale 1 módulo 3. Contradicción.

No se construye una órbita con ese extremo: se demuestra que la negación del objetivo exigiría un tercer bloque físicamente imposible. Esta es precisamente la condición que faltaba al sobre abstracto anterior.

## 4. Exhaustividad y alcance del avance

B4 es un entero al menos cuatro. Los casos B4=4, B4=5 y B4≥6 cubren todo el dominio. En todos ellos D5≤237. El contraste 2^237≤6^92 completa la capacidad pedida.

Q49 había retirado D4=93,94 para 3≤a1≤70. Esta prueba retira D4=95 bajo D3≤92 de forma común, sin enumerar familias.

El informe del integrador Q50 ya registra la banda A70 completa por una vía separada. No se vuelve a contar ese cierre como nuevo aquí. Una vez incorporada esta entrega, el residual comunicado por el integrador se reduce a:

    a1≤2, D3≤92<D4;
    o 3≤a1≤69, D3≤92, D4≥96.

Ese enunciado de coordinación consume los certificados del integrador; no los recompila ni los reaudita. La ventana H146 permanece separada. No se extrapola la prueba a D4=96.

## Auditorías, ejecución y custodia

- /root/q50_d495_low_gap_review: revisión favorable del libro, margen aditivo, índices y contradicción modular de B4≤5.
- /root/q50_d495_high_gap_review: revisión favorable de B4≥6, excepción a=2, factor 9/25, fusión y contraste final.
- Una ejecución de check.py: exit_code=0; tiempo interno 0,000780 s.
- Fuentes físicas recorridas: 0; proyecciones: 0; barridos: 0.
- No se ejecutó el lote A70 ni Lean ni H146; no hubo reintentos ni cambios en fuentes anteriores.
- Verificador SHA256: fad5503f84390a747e27747a5caa6108fbc739cc5c1443d9e60f5f211c489995.
- Prerregistro SHA256: ad0b1df2ceb26e825e7a16fa0506d0a3a2c85ccd1fdf1e07c051d11e25285a02.
- RECIBO.json conserva el stdout original, sin reserializar enteros grandes.

De Bono breve cambió la representación de un producto sin huecos a pérdida física y aditivo conservado. La partición y la contradicción fueron demostradas, no asumidas como premisas. No se presenta un PASS completo del protocolo.

NO_CLAIMS: no PASS Lean, no cierre de H92 o H146, no Terras89 completo, no primer cruce universal, no Collatz global, densidad, almost-all, rho, prioridad bibliográfica ni porcentaje de cobertura. Siguiente paso: entregar para integración; no se abre otro lote.
