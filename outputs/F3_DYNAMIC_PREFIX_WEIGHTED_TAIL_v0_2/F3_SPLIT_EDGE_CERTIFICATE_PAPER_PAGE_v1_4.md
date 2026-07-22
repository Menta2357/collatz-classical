# F3 split-edge certificate — paper page v1.4 (combined ledger)

Date: 2026-07-22.

Status:

```text
PAPER_GATE_COMPLETE_PENDING_ADVERSARIAL_REVIEW
CANDIDATE_CERTIFICATE_EMPIRICAL
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

The paper object now has all declared components:

```text
A  disjoint-fibre path composition                         PASS
B  Chernoff tilt, rho'=2.5, growth-adjusted Perron          PASS
C  finite base segment, 243 states                         PASS
Q  sterile and boundary all-y counting                     PASS
L  combined ledger eta                                      PASS
```

The combined ledger uses explicit denominators and gives

```text
eta = 2734375/9565938 = 0.2858449427541763 < 1
C_I = 10
w_min = 0.0031
(1-eta)*C_I*w_min = 0.02213880677462053
```

Thus the paper-level conclusion is

```text
V_y >= 0.02213880677462053 * (9/5)^(y-8)
```

under the declared normalization and the rational-envelope hypotheses.

## Adversarial review gate

Before this can be called a formal candidate theorem, the reviewer must check:

1. every `Q_norm` denominator is the same row-functional denominator used in
   the Chernoff ledger;
2. the rational scale and edge envelopes dominate the intended real operator;
3. the base witness mass is inserted once, with no duplicate `w_min` factor;
4. the all-`y` counting bounds are applied only where the corresponding
   interval hypotheses hold;
5. no empirical holdout result is used as a theorem hypothesis.

The adversarial review is the next gate.  Only after it passes may the program
write the Lean M0 budget.  All NO-CLAIMS remain active.

