# F3 N_block member-wise lemma v1 — counting audit

Date: 2026-07-22.

This audit discharges the remaining route-selection gate using two independent
checks. It does not use holdout data and does not claim a formal rho theorem.

## 1. Arithmetic derivation

The frozen operator has `d0=5`, and the missing fine digit is the sixth
3-adic digit. A fixed fine fibre has density `1/3` in the depth-six period:

```text
P_3adic = 3^6 = 729,
fine-lift density = 1/3,
N_block = 3^6 * (1/3) = 3^5 = 243.
```

The same count factors through the frozen state description:

```text
admissible residues r mod 3^5: 3^4 = 81,
parity/nu2 reticle types per residue: 3,
81 * 3 = 243.
```

The full reticle period used to respect parity and the clipped `nu2` bucket is
`4*3^6=2916`; this does not change the fixed-fine-fibre count.

## 2. Exhaustive frozen-state enumeration

The script reads the frozen vector at hash
`580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40` and checks:

```text
frozen states = 243,
residue groups = 81,
each residue group has exactly 3 reticle states,
each of the three fine lifts has exactly 243 representatives,
all 729 representatives are distinct,
all representatives reproduce their requested state and fine lift,
zero mismatches.
```

This is an enumeration of the complete frozen state/reticle space, not an
estimate from a finite holdout interval. The arithmetic derivation and the
enumeration both return `N_block=243`.

## 3. Threshold and margin

The strict per-step condition is

```text
(1+delta)(1-epsilon) > 1
iff 2/N_block < 1/101
iff N_block >= 203.
```

At the audited value `N_block=243`:

```text
epsilon = 2/243,
(1+delta)(1-epsilon) = 24341/24300,
net gain = 41/24300 = 0.16872427983539096% per step.
```

Therefore the selected row-deficit route passes its counting gate. Its ledger
value remains `eta=202/443=0.45598194130925507`.

## 4. Omega fallback independence

The Omega route is recomputed without `N_block`:

```text
eta_Omega = [2/(9/5)^8] /
            (1-(1+delta)*Perron(2.5))
          = 0.5529656687661839.
```

The script evaluates this same value for unused candidate values
`N_block in {81,203,243,729}`. All four values are identical and remain below
one. Thus a failure of the row-count route would not alter the Omega fallback.

## 5. Verdict

```text
PASS_NBLOCK_MEMBERWISE_LEMMA_ROUTE_II_READY_FOR_FINAL_REVIEW
```

The next authorized step is to append this lemma and the exact margin to the
single consolidated paper and submit it to adversarial final review. Lean
budgeting remains closed until that review passes.

NO-CLAIMS remain active: no formal rho certificate, no density theorem, no
almost-all statement, no global Collatz claim, and no Lean operator.

