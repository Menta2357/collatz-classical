# F3 operator contribution hook v1

Status: `ROW_CONTRIBUTION_TO_PISTAR_PASS_OPERATOR_HOOK_OPEN`.

The bridge now has the correct row-wise shape.  Given an explicit Real
contribution for each frozen `(root, edge)` row, Lean transports it through
three already separate obligations:

1. the row contribution is bounded by the cardinality of its retained fibre;
2. finite pairwise-disjoint fibres are normalized to their total cardinality;
3. the aggregate fibre cardinality is bounded by the corresponding `piStar`
   root populations.

The theorem has a weighted-iterate specialization for the frozen Real
operator.  Its only F3-specific premise is the displayed operator-to-row
contribution inequality; no empirical holdout, rho certificate, density
theorem, almost-all claim, or global Collatz claim is used.

This isolates the remaining semantic blocker at its narrowest form: define
the actual path contribution for every operator row and prove that inequality
member-wise, together with the cross-level terminal-distinctness condition
needed by the cumulative first-hit lemma.
