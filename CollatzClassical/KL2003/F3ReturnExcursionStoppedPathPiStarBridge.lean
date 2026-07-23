import CollatzClassical.KL2003.F3ReturnExcursionPathLeakageContract
import CollatzClassical.KL2003.KL2003M0APiStarSemantics

open scoped BigOperators

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3StoppedPathPiStarBridge

open F3FiberAccounting
open F3PathLeakageContract

/-!
Semantic bridge for a stopped population layer.

The theorem is deliberately below the operator level: it says that retained
first-hit fibres of any `StoppedPathData` cannot exceed its root population,
and hence cannot exceed an enclosing `piStar` population.  No matrix,
empirical ratio, or asymptotic claim is used.  The still-open F3 obligation is
to prove that the frozen operator supplies enough retained stopped mass.
-/

theorem retainedMass_le_rootMass
    {ι α : Type*} [DecidableEq ι] [DecidableEq α]
    (data : StoppedPathData ι α) (n : Nat) :
    retainedMass data n ≤ rootMass data n := by
  have hnat := sum_fiber_card_le_root_card
    (data.index n) (data.fiber n) (data.root n)
    (data.fibers_disjoint n)
    (fun i hi => data.fibers_subset_root n i hi)
  change (((∑ i ∈ data.index n, (data.fiber n i).card) : Nat) : ℝ) ≤
    ((data.root n).card : ℝ)
  exact_mod_cast hnat

theorem retainedMass_le_piStar_rootMass
    {ι : Type*} [DecidableEq ι]
    (data : StoppedPathData ι Nat) (n : Nat)
    (root : Nat) (window : Nat)
    (hroot : data.root n ⊆ piStarFinset root window) :
    retainedMass data n ≤ (piStarFinset root window).card := by
  calc
    retainedMass data n ≤ rootMass data n :=
    retainedMass_le_rootMass data n
    _ = (data.root n).card := rfl
    _ ≤ (piStarFinset root window).card :=
      by exact_mod_cast Finset.card_le_card hroot

end F3StoppedPathPiStarBridge
end KL2003
end CollatzClassical
