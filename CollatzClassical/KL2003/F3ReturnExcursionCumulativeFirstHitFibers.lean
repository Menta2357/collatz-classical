import CollatzClassical.KL2003.F3ReturnExcursionCumulativeStoppedAccounting
import CollatzClassical.KL2003.F3ReturnExcursionFirstHitFibers

/-!
Finite multi-level first-hit accounting.

This is the path-composition interface needed by the renewal conversion.  It
does not choose the composed F3 paths.  Given a finite list of layers whose
terminal inverse children are distinct, first-hit filtering proves global
pairwise disjointness across levels, and the resulting population is bounded
by one parent `piStar` population.
-/

open scoped BigOperators

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3CumulativeFirstHitFibers

open F3AdvancedDisjointness
open F3FirstHitFibers
open F3CumulativeStoppedAccounting

def cumulativeAdvancedFiber
    {ι : Type*} [DecidableEq ι]
    (a : Nat) (kind : Nat → ι → AdvancedSourceKind)
    (child xChild : Nat → ι → Nat)
    (p : Sigma (fun _ : Nat => ι)) : Finset Nat :=
  firstHitSource (kind p.1 p.2) a (child p.1 p.2) (xChild p.1 p.2)

theorem cumulative_advanced_fibers_pairwise_disjoint
    {ι : Type*} [DecidableEq ι]
    (N : Nat) (index : Nat → Finset ι) (a : Nat)
    (kind : Nat → ι → AdvancedSourceKind)
    (child xChild : Nat → ι → Nat)
    (hdistinct : ∀ n i, i ∈ index n → ∀ m j, j ∈ index m →
      (⟨n, i⟩ : Sigma (fun _ : Nat => ι)) ≠ ⟨m, j⟩ →
        child n i ≠ child m j) :
    ((cumulativeIndex N index : Finset (Sigma (fun _ : Nat => ι))) :
      Set (Sigma (fun _ : Nat => ι))).PairwiseDisjoint
        (cumulativeAdvancedFiber a kind child xChild) := by
  intro p hp q hq hpq
  rcases p with ⟨n, i⟩
  rcases q with ⟨m, j⟩
  have hni : i ∈ index n := (Finset.mem_sigma.mp hp).2
  have hmj : j ∈ index m := (Finset.mem_sigma.mp hq).2
  change Disjoint
    (firstHitSource (kind n i) a (child n i) (xChild n i))
    (firstHitSource (kind m j) a (child m j) (xChild m j))
  exact firstHitSource_disjoint
    (hdistinct n i hni m j hmj hpq)

theorem cumulative_advanced_fibers_subset_parent
    {ι : Type*} [DecidableEq ι]
    (N : Nat) (index : Nat → Finset ι) (a x : Nat)
    (kind : Nat → ι → AdvancedSourceKind)
    (child xChild : Nat → ι → Nat)
    (hax : a ≤ x)
    (hcarith : ∀ n i, i ∈ index n →
      3 * child n i + 1 = 2 * a)
    (hxChild : ∀ n i, i ∈ index n → xChild n i ≤ x) :
    ∀ p ∈ cumulativeIndex N index,
      cumulativeAdvancedFiber a kind child xChild p ⊆ piStarFinset a x := by
  intro p hp
  rcases p with ⟨n, i⟩
  have hni : i ∈ index n := (Finset.mem_sigma.mp hp).2
  change firstHitSource (kind n i) a (child n i) (xChild n i) ⊆
    piStarFinset a x
  exact firstHitSource_subset_parent
    (hcarith n i hni) hax (hxChild n i hni)

theorem cumulative_advanced_card_le_parent
    {ι : Type*} [DecidableEq ι]
    (N : Nat) (index : Nat → Finset ι) (a x : Nat)
    (kind : Nat → ι → AdvancedSourceKind)
    (child xChild : Nat → ι → Nat)
    (hax : a ≤ x)
    (hcarith : ∀ n i, i ∈ index n →
      3 * child n i + 1 = 2 * a)
    (hxChild : ∀ n i, i ∈ index n → xChild n i ≤ x)
    (hdistinct : ∀ n i, i ∈ index n → ∀ m j, j ∈ index m →
      (⟨n, i⟩ : Sigma (fun _ : Nat => ι)) ≠ ⟨m, j⟩ →
        child n i ≠ child m j) :
    (∑ n ∈ Finset.range N, ∑ i ∈ index n,
      (firstHitSource (kind n i) a (child n i) (xChild n i)).card) ≤
      (piStarFinset a x).card := by
  exact cumulative_fibre_card_le_root_card
    N index
    (fun n i => firstHitSource (kind n i) a (child n i) (xChild n i))
    (piStarFinset a x)
    (fun n i hni m j hmj hne =>
      firstHitSource_disjoint
        (hdistinct n i hni m j hmj hne))
    (fun n i hni =>
      firstHitSource_subset_parent
        (hcarith n i hni) hax (hxChild n i hni))

end F3CumulativeFirstHitFibers
end KL2003
end CollatzClassical
