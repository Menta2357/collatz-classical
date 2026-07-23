import CollatzClassical.KL2003.F3ReturnExcursionLemmaAExpansionInvariant
import CollatzClassical.KL2003.F3ReturnExcursionRealIterateBridge

open scoped BigOperators

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3OperatorFibreComparisonContract

open F3LemmaAExpansionInvariant
open F3RealIterateBridge
open F3RealOperatorBridge

variable {ι : Type*} [DecidableEq ι] [Fintype ι]
variable {κ : Type*}

structure Contract where
  M : ι → ι → ℝ
  weight : ι → ℝ
  initial : ι → ℝ
  ledger : ExpansionLedger (ι := ι) (κ := κ)
  mass_identification :
    ∀ n, weightedMass weight (iteratePush M initial n) =
      layerMass ledger n
  base : LayerBound ledger 0
  preserve : ∀ n, LayerBound ledger n → LayerBound ledger (n + 1)

theorem cumulative_operator_mass_le_root_card
    (C : Contract (ι := ι) (κ := κ))
    (N : Nat) (root : Finset Nat)
    (hdisj : ∀ n i, i ∈ C.ledger.index n → ∀ m j, j ∈ C.ledger.index m →
      (⟨n, i⟩ : Sigma (fun _ : Nat => ι)) ≠ ⟨m, j⟩ →
        Disjoint (C.ledger.fiber n i) (C.ledger.fiber m j))
    (hsub : ∀ n i, i ∈ C.ledger.index n → C.ledger.fiber n i ⊆ root) :
    ∑ n ∈ Finset.range N,
        weightedMass C.weight (iteratePush C.M C.initial n) ≤
      (root.card : ℝ) := by
  exact operator_mass_le_root_of_layer_identification
    C.ledger N root
    (fun n => weightedMass C.weight (iteratePush C.M C.initial n))
    C.mass_identification C.base C.preserve hdisj hsub

end F3OperatorFibreComparisonContract
end KL2003
end CollatzClassical
