import CollatzClassical.KL2003.F3ReturnExcursionCumulativeStoppedAccounting

open scoped BigOperators

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3LemmaAExpansionInvariant

open F3CumulativeStoppedAccounting

variable {ι : Type*} [DecidableEq ι]
variable {κ : Type*}

structure ExpansionLedger where
  index : Nat → Finset ι
  shift : Nat → ι → κ
  mass : Nat → ι → ℝ
  fiber : Nat → ι → Finset Nat

def LayerBound (L : ExpansionLedger (ι := ι) (κ := κ)) (n : Nat) : Prop :=
  ∀ i ∈ L.index n, L.mass n i ≤ (L.fiber n i).card

def layerMass (L : ExpansionLedger (ι := ι) (κ := κ)) (n : Nat) : ℝ :=
  ∑ i ∈ L.index n, L.mass n i

theorem layerBound_all_of_base_step
    (L : ExpansionLedger (ι := ι) (κ := κ))
    (hbase : LayerBound L 0)
    (hstep : ∀ n, LayerBound L n → LayerBound L (n + 1)) :
    ∀ n, LayerBound L n := by
  intro n
  induction n with
  | zero => exact hbase
  | succ n ih =>
      simpa [Nat.succ_eq_add_one] using hstep n ih

theorem cumulative_layer_mass_le_root_card
    (L : ExpansionLedger (ι := ι) (κ := κ))
    (N : Nat) (root : Finset Nat)
    (hbase : LayerBound L 0)
    (hstep : ∀ n, LayerBound L n → LayerBound L (n + 1))
    (hdisj : ∀ n i, i ∈ L.index n → ∀ m j, j ∈ L.index m →
      (⟨n, i⟩ : Sigma (fun _ : Nat => ι)) ≠ ⟨m, j⟩ →
        Disjoint (L.fiber n i) (L.fiber m j))
    (hsub : ∀ n i, i ∈ L.index n → L.fiber n i ⊆ root) :
    ∑ n ∈ Finset.range N, layerMass L n ≤ (root.card : ℝ) := by
  have hall : ∀ n, LayerBound L n := layerBound_all_of_base_step L hbase hstep
  have hlayer : ∀ n,
      layerMass L n ≤ ∑ i ∈ L.index n, ((L.fiber n i).card : ℝ) := by
    intro n
    unfold layerMass
    exact Finset.sum_le_sum (fun i hi =>
      Finset.sum_le_sum (fun _ _ => hall n i hi))
  have hsum :
      (∑ n ∈ Finset.range N, layerMass L n) ≤
        ∑ n ∈ Finset.range N, ∑ i ∈ L.index n, ((L.fiber n i).card : ℝ) := by
    exact Finset.sum_le_sum (fun n hn =>
      Finset.sum_le_sum (fun _ _ => hlayer n))
  have hroot := cumulative_retainedMass_le_rootMass
    N L.index L.fiber root hdisj hsub
  exact hsum.trans hroot

theorem operator_mass_le_root_of_layer_identification
    (L : ExpansionLedger (ι := ι) (κ := κ))
    (N : Nat) (root : Finset Nat)
    (operatorMass : Nat → ℝ)
    (hidentify : ∀ n, operatorMass n = layerMass L n)
    (hbase : LayerBound L 0)
    (hstep : ∀ n, LayerBound L n → LayerBound L (n + 1))
    (hdisj : ∀ n i, i ∈ L.index n → ∀ m j, j ∈ L.index m →
      (⟨n, i⟩ : Sigma (fun _ : Nat => ι)) ≠ ⟨m, j⟩ →
        Disjoint (L.fiber n i) (L.fiber m j))
    (hsub : ∀ n i, i ∈ L.index n → L.fiber n i ⊆ root) :
    ∑ n ∈ Finset.range N, operatorMass n ≤ (root.card : ℝ) := by
  simpa [hidentify] using cumulative_layer_mass_le_root_card
    L N root hbase hstep hdisj hsub

end F3LemmaAExpansionInvariant
end KL2003
end CollatzClassical
