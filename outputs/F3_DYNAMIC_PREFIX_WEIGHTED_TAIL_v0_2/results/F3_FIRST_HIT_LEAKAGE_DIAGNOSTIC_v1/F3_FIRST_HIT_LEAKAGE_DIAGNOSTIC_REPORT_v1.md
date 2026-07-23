# F3 first-hit leakage diagnostic v1

Status: `DIAGNOSTIC_ONLY`.

This finite calibration compares the raw advanced source populations with the
cycle-safe first-hit fibres.  A member is retained only when the first visit
to the parent has immediate predecessor `c`, matching the Lean predicate
`FirstHitThrough`.  The discarded raw members are recorded as a possible
path-leakage term; they are not silently counted as retained mass.

The run is deliberately not a theorem and does not certify a uniform bound,
an operator-to-`piStar` growth theorem, a rho certificate, or density.

## Frozen diagnostic parameters

- roots: `3 <= a < 128`, restricted to `a > 2` and `2a-1` divisible by 3;
- window exponent: `y = 8`;
- direct source: `piStar(c, 2^y c)`;
- parity-lift source: `piStar(2c, 2^y c)`;
- first-hit rule: first entrance into `a` has predecessor `c`.

## Result

The run has 82 rows (two source kinds per admissible root), with
`raw_total = 45017`, `first_hit_total = 45017`, and `discarded_total = 0`.
Thus the observed discarded fraction is `0.0` on this finite calibration.
This is only a diagnostic observation: it neither proves `NotInCycle a` nor
supplies the uniform leakage estimate required by the renewal conversion.

The machine-readable outputs are `raw_vs_first_hit.csv` and `summary.json`;
their hashes are recorded in `summary.json`.  The script is
`scripts/f3_first_hit_leakage_diagnostic_v1.py`.

## Remaining obligation

The formal route remains the first-hit fibre theorem plus an explicit bound on
the discarded raw population (or a proof that the discarded term is absent in
the relevant root domain).  This diagnostic does not discharge that
obligation.
