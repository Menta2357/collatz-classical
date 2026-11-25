# Q50: refutacion del borde d=14, exceso 7 en el propio F=T60

Estado: PAPER_INDEPENDENT_REVIEW_PASS y
PASS_D14_E7_REFUTED_BY_FIRST_HIT_CERTIFICATE. Sin Lean nuevo.

## Dominio y cambio de representacion

De Bono breve: AGO (refutar el unico borde d=14 dejado por Q49), CAF
(mismo N y libros separados), FIP (primer instante en que se consume
el exceso 7, seguido de una cadena forzada de unos).

Se conserva la fila Q49, con s natural:

    k=428769801+2^31*(12+64s),
    N=7551224716847488673038978175
       +39614081257132168796771975168*s,
    F=16161180670369550395566597319
       +84782316550432407028588866402*s,
    2^94*F=3^60*N+253163701604367108480427299121.

La subfila solicitada es s=29+32u, u>=0. No se sustituye el N original
por F, V o W. La produccion fisica del prefijo sigue siendo una premisa
suministrada; el sufijo (2,2,1) hacia T62/T63 no se necesita ni se usa.

El caso a refutar es un Segment(w,F,14,21,C), con w positivo impar.
El resultado sera mas fuerte que la version pagada: no existe dicho
segmento ni siquiera sin imponer w<N.

Primer contraste fijado: despues de consumir el exceso 7, para llegar
a profundidad 14 solo pueden quedar unos. En vez de ampliar un arbol
hasta 14, se verifica si alguna entrada al presupuesto 7 tiene reserva
ternaria suficiente para esa cola. Se cotejan solo las cinco entradas
deducidas del certificado sellado de Q49.

## El padre se consume, no se reconstruye

Q49 contiene un certificado cerrado de todas las inversas con exceso
<=6. Sus maximos son profundidad 3 para exceso <=5 y 5 para exceso <=6.
Se carga su recibo exacto por hash; no se vuelve a ejecutar su script.

En una palabra inversa, con estado Y, libro auxiliar (p,S,C) y e=S-p,
la nueva letra a cambia C a 2^a*C+3^p y el exceso a e+a-1. Para
alcanzar exactamente 7 desde un estado del padre, necesariamente

    a=8-e.

No hay eleccion que buscar: se comprueba esta unica letra contra el
residuo de Y modulo 3. Los residuos 0 no admiten inversa; residuo 1
exige a par y residuo 2 exige a impar. Resultan exactamente cinco
entradas, donde las palabras se leen desde F hacia atras:

| Entrada | Libro (p,S,C) | tau=v3(Y+1) | Unos requeridos para d=14 | Profundidad al agotarlos |
| --- | --- | ---: | ---: | ---: |
| (8) | (1,8,1) | 0 | 13 | 1 |
| (6,3) | (2,9,11) | 0 | 12 | 2 |
| (6,1,3) | (3,10,49) | 2 | 11 | 5 |
| (4,2,3,2) | (4,11,287) | 0 | 10 | 4 |
| (6,1,1,2,1,2) | (6,13,1391) | 1 | 8 | 7 |

Cada estado es Y=(2^S*F-C)/3^p. La pendiente de F es 2*3^60,
por lo que estas valoraciones ternarias exactas son uniformes en toda
la fila q=12+64s; no dependen de la restriccion s=29+32u.

## Cola forzada y contradiccion exacta

Supongamos un segmento de profundidad 14 y exceso 7. Sus valoraciones
son positivas, asi que sus excesos parciales son no decrecientes.
Existe un primer instante en que el exceso parcial alcanza 7. Antes
de el, la palabra pertenece al certificado Q49; en el instante de
cruce pertenece a una de las cinco entradas anteriores.

Despues no puede haber otra valoracion mayor que 1: aumentaria el
exceso por encima de 7. Tras j inversas de valoracion 1 desde Y,

    Y_j+1 = 2^j*(Y+1)/3^j.

Para que ese estado sea entero es necesario 3^j | Y+1. En las cinco
filas tau es estrictamente menor que 14-p. Por tanto ninguna admite
la cola exigida; queda refutado Segment(w,F,14,21,C).

Los libros al terminar las colas permitidas se conservan sin mezclarlos
con el original: (1,8,1), (2,9,11), (5,12,331), (4,11,287) y
(7,14,3511). El residuo de esos extremos modulo 3 es, respectivamente,
0,0,0,0,1. En el ultimo caso una nueva inversa requiere exponente par
>=2 y excederia el presupuesto; en los otros cuatro no hay inversa.

La formula de composicion de cada cola de j unos es

    p_final=p+j, S_final=S+j,
    C_final=2^j*C+3^p*(3^j-2^j).

Asi se conservan ambos libros y las valoraciones fisicas: los estados
son enteros positivos impares y 3Y_new+1=2^aY da valoracion exacta a.
La demostracion no cuenta la premisa fisica original como una prueba
nueva ni consulta otros terminales.

## Que corta y donde se detiene

**Resultado PAPER:** para toda s>=0 en la familia afin q12, y por tanto
para toda u>=0 en s=29+32u, no existe fuente positiva impar con libro
(14,21,C) hacia F. No se necesita la hipotesis de precio para refutarla.

Q49 ya excluia fuentes pagadas de profundidad <14 y demostraba que
en profundidad 14 debian tener exceso exactamente 7. Al combinar
ambos resultados, toda fuente pagada al mismo F exige p>=15.

Esto es solamente una cota necesaria. No se estudia p=15, no se abre
exceso 8 ni se construye captura. La entrega termina aqui, sin nueva
busqueda, Lean, comparaciones en T28/T36/T61 o analisis de V/W.

## Reproduccion

    python3 -B q50/FUSION/verify.py

El comprobador lee el certificado padre por hash, coteja las cinco
aristas de primer cruce y cinco valoraciones prefijadas, y comprueba
los libros. No ejecuta el comprobador padre ni simula orbitas. La
salida se guarda como texto JSON exacto sin conversion a JS Number.
Solo se crean archivos en este directorio. Revision independiente
PASS; ver REVIEW.md. El recibo conserva su estado de ejecucion previo
a la revision. Ninguna promocion automatica a Lean.
