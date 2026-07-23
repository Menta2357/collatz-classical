# F3 frozen-row ledger bridge v1

Status: `FROZEN_RULE_TO_PISTAR_LEDGER_PASS_OPERATOR_CONTRIBUTION_OPEN`.

The rule constructors now determine explicit child fibres and parent windows.
Lean proves that every retarded, advanced-direct, and parity-lift rule fibre is
a subset of its parent `piStar` population under the corresponding arithmetic
hypotheses.  A generic ledger theorem transports an operator-to-contribution
inequality through these rule fibres, provided the declared index fibres are
pairwise disjoint and the row windows match.

This is the semantic rule → frozen row → `piStar` bridge.  It does not assert
that every frozen numerical row has a realized rule witness, nor does it prove
the operator-to-contribution inequality or any density/rho/global-Collatz
claim.  Those remain the explicit F3 gates.
