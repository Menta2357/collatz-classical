import CollatzClassical.KL2003.F3ReturnExcursionStoppedPathPiStarBridge
import Mathlib.Algebra.BigOperators.Group.Finset.Sigma

open scoped BigOperators

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3CumulativeStoppedAccounting

open F3FiberAccounting

/-!
Finite composition accounting for stopped paths.

All stopped atoms from finitely many levels are flattened into one sigma-index
set.  If the fibres are globally disjoint across levels (not merely
level-wise), their total cardinality is bounded by the single root
population.  This is the exact finite statement needed before a path-level
operator-to-stopped comparison can be attempted.
-/

def cumulativeIndex {ι : Type*}
    (N : Nat) (index : Nat → Finset ι) :
    Finset (Sigma (fun _ : Nat => ι)) :=
  (Finset.range N).sigma index

theorem cumulative_fibre_card_le_root_card
    {ι : Type*} [DecidableEq ι]
    (N : Nat) (index : Nat → Finset ι)
    (fiber : Nat → ι → Finset Nat) (root : Finset Nat)
    (hdisj : ∀ n i, i ∈ index n → ∀ m j, j ∈ index m →
      (⟨n, i⟩ : Sigma (fun _ : Nat => ι)) ≠ ⟨m, j⟩ →
        Disjoint (fiber n i) (fiber m j))
    (hsub : ∀ n i, i ∈ index n → fiber n i ⊆ root) :
    (∑ n ∈ Finset.range N, ∑ i ∈ index n, (fiber n i).card) ≤
      root.card := by
  let P := cumulativeIndex N index
  let flatFiber : Sigma (fun _ : Nat => ι) → Finset Nat :=
    fun p => fiber p.1 p.2
  have hdisj' : (P : Set (Sigma (fun _ : Nat => ι))).PairwiseDisjoint flatFiber := by
    intro p hp q hq hpq
    rcases p with ⟨n, i⟩
    rcases q with ⟨m, j⟩
    have hni : i ∈ index n := (Finset.mem_sigma.mp hp).2
    have hmj : j ∈ index m := (Finset.mem_sigma.mp hq).2
    exact hdisj n i hni m j hmj hpq
  have hsub' : ∀ p ∈ P, flatFiber p ⊆ root := by
    intro p hp
    rcases p with ⟨n, i⟩
    exact hsub n i (Finset.mem_sigma.mp hp).2
  have hflat := sum_fiber_card_le_root_card P flatFiber root hdisj' hsub'
  have hsum :
      (∑ p ∈ P, (flatFiber p).card) =
        ∑ n ∈ Finset.range N, ∑ i ∈ index n, (fiber n i).card := by
    simp only [P, flatFiber, cumulativeIndex]
    rw [Finset.sum_sigma]
  rw [hsum] at hflat
  exact hflat

theorem cumulative_retainedMass_le_rootMass
    {ι : Type*} [DecidableEq ι]
    (N : Nat) (index : Nat → Finset ι)
    (fiber : Nat → ι → Finset Nat) (root : Finset Nat)
    (hdisj : ∀ n i, i ∈ index n → ∀ m j, j ∈ index m →
      (⟨n, i⟩ : Sigma (fun _ : Nat => ι)) ≠ ⟨m, j⟩ →
        Disjoint (fiber n i) (fiber m j))
    (hsub : ∀ n i, i ∈ index n → fiber n i ⊆ root) :
    (((∑ n ∈ Finset.range N, ∑ i ∈ index n,
        (fiber n i).card) : Nat) : ℝ) ≤ (root.card : ℝ) := by
  exact_mod_cast cumulative_fibre_card_le_root_card
    N index fiber root hdisj hsub

end F3CumulativeStoppedAccounting
end KL2003
end CollatzClassical
