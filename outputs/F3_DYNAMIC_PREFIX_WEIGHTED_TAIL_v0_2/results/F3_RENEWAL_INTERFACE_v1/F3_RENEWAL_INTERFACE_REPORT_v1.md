# F3 renewal interface — informe v1

Estado: `REAL_RENEWAL_CONVERSION_INTERFACE_PASS_PATH_LEAKAGE_OPEN`.

`F3ReturnExcursionRenewalInterface.lean` empaqueta el contrato que debe
producir la futura descomposición de caminos detenidos:

```text
LeakageCertificate(q, L):
  stopped(0) >= 0
  (1-q) L q^n <= stopped(n+1) - stopped(n)
  0 <= q < 1
```

Desde ese contrato se prueban en `Real` la cota
`L(1-q^n) <= stopped(n)` y el límite hacia `L`. También queda una
especialización para `qStar = 24100/24543`.

## Alcance y límite

Esto formaliza la conversión renewal una vez entregada la desigualdad de
fuga; no demuestra todavía que los caminos F3, sus fibras disjuntas y la
frontera produzcan `LeakageCertificate`. Esa es la siguiente obligación
analítica y permanece explícitamente abierta.

No se declara certificado de `rho`, teorema de densidad, claim “almost all” ni
resultado global de Collatz.
