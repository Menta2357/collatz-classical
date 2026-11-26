# Front4b · Descenso en la ruptura directa tras un banco de pares

Lean certifica el descenso bajo el mismo impar original (N) desde un pivote impar (F) con (N≥64), (N<F) y (11F<12N). Si la historia física desde (F) recorre (m) pares ((1,2)) hasta (X), y la valoración física de (3X+1) es (d), basta cualquiera de las siguientes guardas.

| Pares completados | Valoración de la ruptura directa |
| ---: | ---: |
| (m≤1) | (d≥2) |
| (m≤7) | (d≥3) |
| (m≤13) | (d≥4) |

El centro afín conserva el término aditivo. Con (C_m=5(3^{2m}-2^{3m})), se cumple (8^m(X+5)=9^m(F+5)). Para (m≤M), se obtiene (8^M(X+5)≤9^M(F+5)). Los tres topes de la tabla verifican (3·9^M(F+5)<8^M(2^DN+14)) para el piso (D) indicado. Así (3X+1<2^DN≤2^dN), que da el descenso físico.

Si la entrada tiene libro ((j,S,B)), el terminal (T(X)<N) tiene libro

[
left(j+2m+1, S+3m+d, 3(3^{2m}B+2^S C_m)+2^{S+3m}
ight).
]

El exponente (d) es el real, certificado por la divisibilidad por (2^d) y la no divisibilidad por (2^{d+1}). El consumidor `descent_of_numerator_bound` reutiliza la comparación directa (3X+1<2^dN) cuando se obtiene por un margen específico.

En la fila Q47 (k=428769801+2^{31}(108+128s)), la comparación exacta de los coeficientes afines da (12N-11F=15327554002449017256888858053+18132468116415573808049873610s>0). Se aplica el teorema cuando el libro físico y alguna de las guardas de ruptura de la tabla están acreditados. Las colas que empiezan por un uno sin completar el par y las rupturas débiles fuera de los topes requieren sus propios certificados. La captura Q47 en T103 corresponde a otro consumidor.

[Teoremas](../../lean/Front4bPairExit.lean) · [Auditoría](AUDIT.log) · [Recibo](RECIBO.json)
