# F3 uniform semantic hook — audit and repair map v2

Status: `TWO_P1_STOPS — REPAIR_PORTFOLIO_OPEN`

Date: 2026-07-24.

Base: `d7a587eb7ec1a1b5383e775a081e7ba07cbe12a0`, the terminal
FullCoreIdentity v2 PASS.

This audit was performed without executing the frozen full `Block0`.  It
separates the valid generic Lean infrastructure from the missing F3
instances, records two defects that stop the historical gate, and fixes the
order in which repairs must be attempted.

## 1. Terminal STOPs before the historical gate

### 1.1 `STOP_ORIENTATION_BEFORE_EXECUTION`

`FormulaEdge` is directed from the arithmetic parent state to the arithmetic
child state.  Consequently `fullFormulaMatrix s t` is the forward semantic
matrix and the path expansion identity has the form

```text
weightedMass w (push fullFormulaMatrix mu)
  = sum_e mu(formulaSource e) * channelWeight(e) * w(formulaTarget e).
```

The frozen vector was instead fitted to the left action.  The existing bridge
defines

```text
coreTransition s t = coreMatrix t s
```

and obtains growth for the transposed matrix.  That expression sums incoming
formula edges and is not realized by the outgoing first-hit fibres.

The mismatch is not only conceptual.  For the forward source row `s=3`, the
formula matrix has the retarded edge `3 -> 20`.  With the frozen entries
`w(3)=5581/10^6`, `w(20)=3664/10^6` and
`channelWeight(0)=25/81`, the required forward row inequality would imply

```text
45,658,161 <= 9,160,000,
```

which is false.  The historical numeric audit found 135 failed forward rows.
Therefore the current vector and the current first-hit semantics cannot
belong to one operator witness.

### 1.2 `STOP_BAD_DENOMINATOR`

The exact identities

```text
epsilon = 2/243
q       = (1-epsilon)/(1+1/100) = 24100/24543
eta     = epsilon/(1-q) = 202/443
```

are correctly proved as abstract Real arithmetic.  Their F3 premise is not.

The generating audit obtains `per_lift_counts=243` by aggregating one
representative from each of 243 different states.  The same output records
only three representatives for an individual state.  It then divides a
boundary count of at most two roots *per state* by the cross-state count 243.
This mixes carriers.  The companion uniform-Q script also ignores the
parity/bucket part of a state while reporting a per-core-state bound.

Thus no current theorem or audit proves

```text
boundaryMass <= (2/243) * rootMass
```

on the same F3 population.  The historical factor `241/443` cannot be used
as the result of Route II.

## 2. Eight obligations and their exact state

| # | Obligation | Reusable kernel-clean brick | Missing F3 instance |
|---|---|---|---|
| 1 | Exact path fibre | `FirstHitThrough`, `firstHitSource`, `mem_firstHitSource_iff` | No composable path type, accumulated shift, fine-cylinder tag, first omission or link to `iteratePush`; the current existential filter is not executable. |
| 2 | Realization with multiplicity | channel inclusions and generic fibre accounting | No member-wise realization of `FormulaEdge`; no proof that matrix contribution is bounded by the corresponding fibre cardinality. |
| 3 | Global disjointness | local sibling disjointness and conditional cumulative accounting | The current cumulative first-hit theorem requires terminal children to be distinct, while its arithmetic equation fixes the same unique child for one parent; a nontrivial multi-path instance cannot satisfy both. |
| 4 | `live/stopped/Q` first-omission partition | `StoppedPathData` gives a static fibre/complement identity | No stopping time, live carrier, first omission or theorem preventing the same loss from being charged at more than one depth. |
| 5 | Boundary on the same carrier | generic `retained_mass_of_boundary_fraction` | No F3 `boundary.card <= 2`, no matching row cardinality, and the claimed `2/243` mixes carriers. |
| 6 | Debt telescoping | `eta_row_real`, `qStar_factorization`, geometric and renewal lemmas | `boundary_budget`, `root_bound` and `retained_le_stopped_increment` remain hypotheses; `202/443` is not instantiated for F3. |
| 7 | Chernoff extinction of live mass | tilted comparison, iterate upper bound and abstract first-passage lemmas | No concrete live path family identified simultaneously with the tilted operator and the stopped ledger. |
| 8 | Stopped fibres to `piStar` | per-layer subset/disjointness and generic cumulative cardinality | No global F3 instance; the existing accumulated advanced-family condition collapses to at most one entry. |

Additional interface defects must be repaired at the same boundary:

- matrix states and path occurrences need different index types;
- windows must depend on both depth and root;
- retarded and advanced channels need one uniform path type;
- advanced `/3` multiplicity must be charged exactly once;
- `Finset` keys must not erase two different path occurrences;
- the formula-generated 729-edge core still needs a clean semantic-rule
  realization, not only equality with the historical literal.

## 3. What remains valid

FullCoreIdentity v2 remains unchanged and fully valid.  It proves the exact
243-source/729-edge formula identity and matrix equality.  The generic Lean
lemmas for finite disjoint families, Real operator algebra, renewal
telescoping and Chernoff consequences also remain valid.  The STOPs concern
the missing and, in two places, inconsistent F3 instantiation of those
interfaces.

In particular, none of these findings retracts a compiled theorem.  They
retract the proposed route from those theorems to an F3 exponent.

## 4. Repair portfolio and gates

The successor architecture must pass these gates in order.

### R1 — forward operator

Use `formulaForward s t := fullFormulaMatrix s t`.  Produce a new positive
right vector and prove, with exact channel bounds,

```text
(1+delta) * w(s) <= sum_t formulaForward(s,t) * w(t)
```

for every state.  A transposed certificate is not accepted.  Failure to find
positive margin at `rho=9/5` is an operator-level STOP for this exponent.

### R2 — one carrier and a legitimate boundary fraction

Define one tagged carrier on which root, complete rows, fine lifts and
boundary are all subsets or weighted measures of the same object.  Derive a
new `epsilon` from that carrier.  The block scale may grow only under a new,
predeclared architecture; the historical `2/243` is not inherited.

### R3 — tagged path realization

Define composable `FormulaEdge` paths with occurrence tags.  Prove the
matrix/path mass identity before defining fibres.  Then define residue/fine
cylinders and prove disjointness by the first differing edge, plus first
omission exactly once.  A terminal-child-only filter is insufficient.

### R4 — uniform assembly

Only after R1--R3 may the existing telescoping and Chernoff bricks be
instantiated.  `eta` must be derived after the local boundary inequality and
must be charged once.  The final theorem must audit the complete dependency
cone and may not use the historical finite gate as a semantic hypothesis.

## 5. Current claims

```text
FULL_CORE_IDENTITY_V2_PASS
HISTORICAL_N1_GATE_WITHDRAWN_BEFORE_EXECUTION
FORWARD_VECTOR_REPAIR_OPEN
COMMON_CARRIER_BOUNDARY_REPAIR_OPEN
TAGGED_PATH_REALIZATION_OPEN

NO_OPERATOR_TO_FIBRES
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
