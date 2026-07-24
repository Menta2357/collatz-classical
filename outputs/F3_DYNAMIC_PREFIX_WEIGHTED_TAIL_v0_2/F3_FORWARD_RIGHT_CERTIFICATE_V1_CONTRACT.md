# F3 forward right certificate v1 — execution contract

Status: `PRE_RUN_FROZEN — IMPLEMENTATION_AND_ONE_BUILD_AUTHORIZED`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v1`.

Declared base:

```text
semantic-gate reconciliation commit:
5a33c4ce9a58ce1b9526e12c16ab4a8e09b89470

FullCoreIdentity v2 terminal commit:
d7a587eb7ec1a1b5383e775a081e7ba07cbe12a0

FullCoreIdentity v2 terminal report sha256:
24998975be4123b07e8fa7c4100c057a6e9d15da20d6208dda6de6c50773aad3
```

This contract repairs only the operator-orientation P1.  It authorizes no
`Block0` computation and makes no first-hit, boundary, exponent or density
claim.

## 1. Frozen inputs

```text
CoreArithmeticCodecFullCoreIdentity.lean
6bfd513abedf81c980e818b20efff46fc720dafabb710031c0e5aba1d5abffad

CoreArithmeticCodecPilotRepair.lean
e5683405008b438d8a7c00747e4e81384962d95ced0d759d42c18f05ff62219c

ExactCoreMatrixChannelBounds.lean
30f1bed5a415b6b725476997c44ef853d05d9cefce26e9965c7c0eaaa19f0e04

RealOperatorBridge.lean
77685f002ed26b73d6028d1d77b345f5e0460a90a2bc94cfc6e045ad3fad6c3c

core_edge_identity.csv
45a4297196e3f1ea767b0f4cfef8ebbbcf70f31547469fe22768cda9d971e35a
```

The candidate vector was obtained from the already public 729-edge matrix,
not from semantic `Block0` or holdout data.  Its frozen 81 entries are:

```text
136,81,131,80,50,129,270,26,195,99,40,47,147,48,132,142,25,85,
166,78,76,105,30,212,129,31,166,94,62,93,86,73,127,207,30,411,
87,49,53,100,41,190,132,44,141,244,39,92,71,26,412,190,21,404,
159,122,72,100,41,156,408,24,275,81,43,68,83,28,269,164,30,122,
137,57,72,90,24,270,260,27,484
```

The state weight is `v(3*k+b)=u(k)` for `b=0,1,2`.  Canonical CSV hashes,
with no terminal newline, are:

```text
81-entry vector:
3e72754815937816ad6465022f2fe90fee605f261ef8e3bd785902836e840ac1

expanded 243-entry vector:
4d063bbb1b2bbfca70f1e1a149ceec3668334788913e3b7ad62c1a3d8b7483a4
```

Control values are fixed as `min=21`, `max=484`, and expanded sum `30123`.

## 2. Exact certificate

The already proved lower channel coefficients are placed over denominator
`81000`:

```text
channel 0: 25000/81000 = 25/81
channel 1: 37989/81000 = 469/1000
channel 2: 21060/81000 = 13/50
```

The finite Nat certificate is exactly

```text
for every source state s,
  82500 * v(s)
    <= sum over formula edges e with source(e)=s of
         lowerCoeff(channel(e)) * v(target(e)).
```

Since `82500/81000=55/54`, the required terminal theorem is

```lean
theorem forwardFormula_row_certificate (s : Fin 243) :
  (55 / 54 : Real) * forwardRightWeight s <=
    Finset.sum Finset.univ (fun t =>
      formulaForwardMatrix s t * forwardRightWeight t)
```

where `formulaForwardMatrix` uses `fullFormulaMatrix s t`, never its
transpose.  The implementation must also prove the edge-sum/matrix identity
and expose the compatible weighted-mass step for the generic forward push.

## 3. Implementation guard

The new source is limited to:

```text
CollatzClassical/KL2003/F3ReturnExcursionForwardFormulaRightCertificate.lean
CollatzClassical/KL2003/F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.lean
```

plus one result directory containing the frozen pre-run report and terminal
logs.  It may add a formula-edge presentation of the forward matrix, but it
may not alter the frozen edge decoder, historical matrix, channel bounds,
first-hit files, paper gate or any `Block0` artifact.

Required implementation properties:

1. the 81-entry vector is literal and its expansion uses `s.val / 3`;
2. the row check uses kernel `decide`, never `native_decide`;
3. transfer to Real uses the three existing exact channel theorems;
4. parallel edges and the three advanced `ell` occurrences remain distinct;
5. `/3` occurs only inside `channelWeight 1` and `channelWeight 2`;
6. no decimal is promoted to a theorem;
7. no theorem imports `Lean.ofReduceBool` or `sorryAx`.

The module options are frozen at:

```text
set_option maxHeartbeats 2000000
set_option maxRecDepth 100000
```

## 4. Single-run phases

After this contract and its pre-run report are publicly custodied, execute
once and sequentially:

```text
R0  frozen hashes/vector/static guard                         60 s
C0  lake env lean ForwardFormulaRightCertificate.lean       900 s
A1  lake env lean ...AxiomAudit.lean                        600 s
K1  total declaration inventory and forbidden-axiom scan    120 s
```

There is one attempt per phase, no retry and no resource increase after a
failure.  A compile, timeout, hash-drift or audit failure yields

```text
F3_FORWARD_RIGHT_CERTIFICATE_V1_EXECUTION_STOP
```

and the STOP custody is pushed.  A mathematical failure of the literal Nat
certificate yields

```text
F3_FORWARD_RIGHT_CERTIFICATE_V1_COUNTEREXAMPLE_STOP
```

with the first failing source row.

PASS requires the Nat check, the Real row certificate, the forward matrix
identity, the weighted-mass step, a complete declaration inventory, and an
axiom profile contained in

```text
[propext, Classical.choice, Quot.sound].
```

## 5. Scope

Even a terminal PASS repairs only R1 of the semantic repair map.  It supplies
a forward growth certificate compatible with outgoing formula edges.  It
does not construct path fibres, prove a boundary fraction, instantiate
`operator_to_fibres`, or establish the F3 exponent.

```text
NO_BLOCK0_EXECUTION
NO_FIRST_HIT_GATE
NO_OPERATOR_TO_FIBRES
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
