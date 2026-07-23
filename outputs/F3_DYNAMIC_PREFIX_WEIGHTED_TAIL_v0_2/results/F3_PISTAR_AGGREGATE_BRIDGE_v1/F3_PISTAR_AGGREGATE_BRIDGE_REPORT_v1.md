# F3 `piStar` aggregate bridge v1

Status: `PISTAR_AGGREGATE_CARD_BRIDGE_PASS_F3_RULE_PARTITION_OPEN`

Lean now proves the exact finite-block inequality

```text
sum over roots a and frozen fibres i of card(fiber(a,i))
  ≤ sum over roots a of card(piStarFinset a x).
```

The theorem requires, explicitly and separately:

1. pairwise disjoint fibres for each parent root;
2. inclusion of every fibre in that parent root's `piStar` population;
3. for the frozen-rule corollary, correct parent assignment and source-rule
   equality.

The semantic bridge supplies the inclusion component for retarded,
advanced-direct, and parity-lift rules.  The advanced disjointness module
supplies the member-wise predecessor argument needed for direct/lift pairs.
The remaining F3 obligation is to instantiate the parent partition and prove
its complete-block/first-hit disjointness uniformly in `y`.

The specialized `FrozenRule` corollary now exposes exactly the required
columns: `frozenRuleParent`, `frozenRuleWindow`, `frozenRuleSource`, rule
validity, parent assignment, window equality, and pairwise disjointness.  A
future generated table can therefore feed the theorem without an untyped
conversion layer.

The cycle-safe `aggregate_firstHit_piStar_card_bound` corollary additionally
accepts first-hit fibres.  It removes the global `NotInCycle` requirement from
the aggregate route; only the discarded raw members still need a uniform
leakage bound.

This is a semantic counting bridge, not an operator-to-growth theorem and not
a density result.

No claims: `NO_RHO_CERTIFICATE`, `NO_DENSITY_THEOREM`,
`NO_GLOBAL_COLLATZ_CLAIM`.
