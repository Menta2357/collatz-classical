# Q51 — D4=96 excluido por el precio del último hueco

## Enunciado y resultado

**PASS_PAPER_D4_EQ_96 / REVALIDATED**, con dos revisiones independientes complementarias y constantes verificadas con enteros exactos. **LEAN=NOT_RUN.**

Sea N>0 impar. Para el mapa abreviado de Collatz, bajo

    N+1<2^92,   3≤a1≤69,   D3≤92,   D4=96,

se tiene

    D5≤237,    por tanto 2^D5≤6^92.

Se conserva el mismo N y no se presupone primer cruce. No se recorrieron órbitas, bandas A70/A71 ni fuentes del caso a1≤2. H146 queda separado.

La prueba D4=95 es sólo el contraste heredado: allí se distinguían todos los huecos; aquí basta pagar el último y excluir tres clases residuales. No se deduce el resultado 96 por extrapolación de 95.

## 1. Historia física y libros

S(n)=n/2 si n es par, S(n)=(3n+1)/2 si n es impar. No es el mapa acelerado de retorno impar.

x0=N. Para cada bloque físico i:

    ai=nu2(x_(i−1)+1)≥1,
    ui=(x_(i−1)+1)/2^ai, entero impar positivo,
    Pi=3^ai ui−1,
    bi=nu2(Pi)≥1,
    xi=Pi/2^bi, entero impar positivo.

D_j=sum ai cuenta entradas impares; B_j=sum bi cuenta pasos pares; k_j=D_j+B_j es el reloj total. Así x_j=S^k_j(N).

Libro original:

    2^k_j x_j=3^D_j N+C_j,
    C0=0,
    C_next=3^a C+2^k(3^a−2^a).

Libro desplazado, con y_j=x_j+1:

    2^k_j y_j=3^D_j(N+1)+E_j,
    E0=0,
    E_next=3^a E+2^(k+a)(2^b−1),
    E_j=C_j+2^k_j−3^D_j.

No se cambia N por un valle posterior ni se crea una fuente auxiliar.

## 2. Cambio de representación: cuatro inyecciones propagadas

La transición desplazada exacta es

    y_i=q_i y_(i−1)+δ_i,
    q_i=3^ai/2^(ai+bi),
    δ_i=1−2^(−bi).

Al componer los cuatro bloques:

    y4 = 3^96(N+1)/2^(96+B4)+R4,
    R4 = sum_(i=1..4) δ_i product_(j=i+1..4) q_j
       = E4/2^k4.                                          (1)

Por a1≥3,

    0≤96−D_i≤93.

Cada producto propagador es

    (3/2)^(96−D_i) · 2^(−(B4−B_i))≤(3/2)^93<2^93.

Como 0<δ_i<1, se obtiene una cota uniforme que incluye todos los huecos, sin límite superior:

    0<R4<4·2^93=2^95.                                     (2)

No se elimina el aditivo; (2) es una cota de la suma exacta de (1).

Sea b=b4. Los tres huecos anteriores miden al menos uno, luego B4≥b+3. Usando N+1<2^92:

    y4 < 3^96/2^(B4+4)+2^95
       ≤ 3^96/2^(b+7)+2^95.                              (3)

## 3. Negación del objetivo: intervalos terminales exhaustivos

Si D5≥238, entonces a5=D5−96≥142. La valoración real del quinto valle obliga a

    y4=t·2^142,    t entero positivo.

No se exige que t sea impar: incluye también a5>142.

La comparación exacta 3^94<2^149, equivalente a 3^96<9·2^149, convierte (3) en

    t < 9/2^b + 2^(−47).                                 (4)

Como 2^(−47)<1/16:

| Último hueco físico b | Consecuencia necesaria de (4) |
| --- | --- |
| b=1 | 1≤t≤4 |
| b=2 | 1≤t≤2 |
| b=3 | t=1 |
| b≥4 | t<1: imposible |

Esta es una reducción demostrada de toda la cola b≥4, no un corte de búsqueda ni una enumeración de semillas.

## 4. Una arista inversa impide los tres casos restantes

La condición D3≤92 y D4=96 obliga a

    a4=96−D3≥4.

El cuarto bloque de la MISMA historia, con su último hueco b, cumple

    3^a4 u4 = 2^b x4+1
            = 2^b(t·2^142−1)+1.

Por tanto es necesario

    34·2^b·t ≡ 2^b−1 (mod 81),                           (5)

porque 2^142≡34 (mod 81) y 81 divide 3^a4 u4. No se supone que u4 sea coprimo con 3.

Las tres congruencias tienen soluciones únicas módulo 81:

| b | Congruencia física necesaria | Clase exigida de t | Cota de tamaño |
| --- | --- | --- | --- |
| 1 | 68t≡1 (mod 81) | t≡56 (mod 81) | t≤4 |
| 2 | 55t≡3 (mod 81) | t≡3 (mod 81) | t≤2 |
| 3 | 29t≡7 (mod 81) | t≡17 (mod 81) | t=1 |

Ninguna clase contiene un entero positivo dentro del intervalo correspondiente. Los inversos se comprueban con

    68·56=47·81+1,
    55·28=19·81+1,
    29·14=5·81+1.

La negación D5≥238 queda excluida en todos los casos. Luego D5≤237. Finalmente el contraste entero 2^237≤6^92 da la capacidad requerida.

No se ha construido un N nuevo ni presentado un terminal como órbita. Se prueban condiciones necesarias para una supuesta violación y se demuestra su incompatibilidad.

## 5. Constantes y comprobación única

El contraste verificó

    3^94 =
      706965049015104706497203195837614914543357369
    < 713623846352979940529142984724747568191373312
    = 2^149,

con margen positivo

    6658797337875234031939788887132653648015943.

También verificó 2^142 mod81=34, los tres inversos, las tres clases y las cotas racionales de (4).

- Una ejecución de check.py, exit_code=0.
- Tiempo interno: 0,009279 s.
- La llamada inicial devolvió sesión 38197; se recogió su salida, sin reiniciar ni repetir el programa.
- Fuentes físicas recorridas: 0. Proyecciones sobre semillas: 0. Barridos: 0.
- A70/A71, a1≤2, H146 y Lean: NOT_RUN.
- Verificador SHA256: 3df923e5ad648c6f49292c5dfcd1c5cf7b32c308fe58df00d7eb70bcf4933dfd.
- Prerregistro SHA256: 17ffd671fc3e57c48359d6bc3ee2f6616b8820972c020e0def947f06548118a2.
- RECIBO.json conserva el stdout exacto, sin reserializar enteros grandes.

## 6. Revisiones, alcance y siguiente estado

La revisión Q51 de /root/q50_d495_low_gap_review validó (1)–(4), los libros y la cobertura de huecos arbitrariamente grandes. La revisión Q51 de /root/q50_d495_high_gap_review validó (5), las tres clases y que no se añadieron hipótesis de paridad de t ni de coprimalidad del cofactor. Son revisiones complementarias del mismo candidato.

Al integrar este resultado con los cierres anteriores, la parte pendiente del dominio 3≤a1≤69,D3≤92 pasa de D4≥96 a D4≥97. El caso a1≤2 conserva su estado anterior. La banda A70 ya resuelta por el principal no se cuenta de nuevo.

De Bono breve cambió de una clasificación de huecos a su coste sobre el último valle, manteniendo explícito el aditivo. El avance procede de demostrar la desigualdad uniforme y una contradicción física; ni la representación ni sus premisas se contaron como prueba.

NO_CLAIMS: no formalización Lean, cierre completo de H92, H146, Q0 Δ=1 o Terras89; tampoco existencia universal de primer cruce, Collatz global, densidad, almost-all, rho, prioridad bibliográfica ni porcentaje de cobertura. No se abre D4=97 en este encargo. Siguiente acción: entregar al principal para integración.
