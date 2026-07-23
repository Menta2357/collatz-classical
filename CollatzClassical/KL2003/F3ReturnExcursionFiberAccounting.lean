import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Finset.Card
import Mathlib.Data.Finset.Union

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3FiberAccounting

noncomputable section

/-!
Abstract finite-fiber accounting for the renewal proof.  The theorem is
independent of the F3 matrix: a family of pairwise-disjoint member fibers,
each contained in a common root population, has total cardinality bounded by
that root population.  This is the exact combinatorial fact needed before a
leakage recurrence can be stated for stopped paths.
-/

theorem sum_fiber_card_le_root_card
    {ι α : Type*} [DecidableEq ι] [DecidableEq α]
    (I : Finset ι) (fiber : ι → Finset α) (root : Finset α)
    (hdisj : (I : Set ι).PairwiseDisjoint fiber)
    (hsub : ∀ i ∈ I, fiber i ⊆ root) :
    (∑ i ∈ I, (fiber i).card) ≤ root.card := by
  calc
    (∑ i ∈ I, (fiber i).card) = (I.biUnion fiber).card := by
      symm
      exact Finset.card_biUnion hdisj
    _ ≤ root.card := by
      apply Finset.card_le_card
      intro a ha
      rcases Finset.mem_biUnion.mp ha with ⟨i, hi, hai⟩
      exact hsub i hi hai

theorem sum_fiber_card_add_boundary_eq_root_card
    {ι α : Type*} [DecidableEq ι] [DecidableEq α]
    (I : Finset ι) (fiber : ι → Finset α) (root : Finset α)
    (hdisj : (I : Set ι).PairwiseDisjoint fiber)
    (hsub : ∀ i ∈ I, fiber i ⊆ root) :
    (∑ i ∈ I, (fiber i).card) +
        (root \ I.biUnion fiber).card = root.card := by
  have hunion : I.biUnion fiber ⊆ root := by
    intro a ha
    rcases Finset.mem_biUnion.mp ha with ⟨i, hi, hai⟩
    exact hsub i hi hai
  have hcard := Finset.card_sdiff_add_card_eq_card hunion
  rw [Finset.card_biUnion hdisj] at hcard
  simpa [Nat.add_comm] using hcard

theorem sum_fiber_card_le_root_card_of_injective
    {ι α : Type*} [DecidableEq ι] [DecidableEq α]
    (I : Finset ι) (domain : ι → Finset Nat) (root : Finset α)
    (embed : ι → Nat → α)
    (hinj : ∀ i ∈ I, Set.InjOn (embed i) (domain i : Set Nat))
    (hsub : ∀ i ∈ I, ((domain i).image (embed i)) ⊆ root)
    (hdisj : (I : Set ι).PairwiseDisjoint
      (fun i => domain i |>.image (embed i))) :
    (∑ i ∈ I, (domain i).card) ≤ root.card := by
  let fiber : ι → Finset α := fun i => (domain i).image (embed i)
  have hcard : ∀ i ∈ I, (fiber i).card = (domain i).card := by
    intro i hi
    exact Finset.card_image_of_injOn (hinj i hi)
  have hsub' : ∀ i ∈ I, fiber i ⊆ root := by
    intro i hi
    simpa [fiber] using hsub i hi
  have hsum := sum_fiber_card_le_root_card I fiber root hdisj hsub'
  calc
    (∑ i ∈ I, (domain i).card) =
        ∑ i ∈ I, (fiber i).card := by
      apply Finset.sum_congr rfl
      intro i hi
      exact (hcard i hi).symm
    _ ≤ root.card := hsum

end
end F3FiberAccounting
end KL2003
end CollatzClassical
