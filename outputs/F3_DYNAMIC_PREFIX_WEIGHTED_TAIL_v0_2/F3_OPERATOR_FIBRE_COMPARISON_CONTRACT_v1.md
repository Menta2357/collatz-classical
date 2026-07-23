# F3_OPERATOR_FIBRE_COMPARISON_CONTRACT_v1

Status: `CONTRACT_COMPILES_COMPARISON_HYPOTHESES_OPEN`

This contract is the concrete boundary between the frozen operator and Lema
A.  It packages the matrix, initial mass, weights, and expansion ledger, then
requires two obligations:

1. `mass_identification`: the weighted `iteratePush` mass at depth `n` is the
   ledger layer mass at `n`;
2. `preservation`: the layer fibre bound is preserved by one expansion.

With those obligations supplied, the Lean theorem transfers cumulative
operator mass to the root fibre cardinality using the already proved global
disjointness accounting.  The contract does not prove either obligation for
the F3 frozen matrix.  In particular, it is not a `piStar` theorem and does
not turn the empirical finite diagnostic into a formal lower bound.
