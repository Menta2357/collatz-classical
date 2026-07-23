import CollatzClassical.KL2003.F3ReturnExcursionAdvancedDisjointness

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3FirstHitFibers

open F3AdvancedDisjointness

/-!
Cycle-safe source fibres.  Raw inverse-child populations can overlap when an
orbit has already visited the parent and later returns.  Filtering by the
first visit to the parent removes that ambiguity without assuming
`NotInCycle a`.  The discarded raw population is intentionally left for the
leakage budget.
-/

def FirstHitThrough (a c n : Nat) : Prop :=
  ∃ k, FirstHitsAt a n (k + 1) ∧ T^[k] n = c

def firstHitSource
    (kind : AdvancedSourceKind) (a c xChild : Nat) : Finset Nat :=
  by
    classical
    exact (sourceFinset kind c xChild).filter
      (fun n => decide (FirstHitThrough a c n))

theorem mem_firstHitSource_iff
    {kind : AdvancedSourceKind} {a c xChild n : Nat} :
    n ∈ firstHitSource kind a c xChild ↔
      n ∈ sourceFinset kind c xChild ∧ FirstHitThrough a c n := by
  simp [firstHitSource, FirstHitThrough]

theorem firstHitSource_disjoint
    {kind₁ kind₂ : AdvancedSourceKind}
    {a c₁ c₂ x₁ x₂ : Nat}
    (hne : c₁ ≠ c₂) :
    Disjoint (firstHitSource kind₁ a c₁ x₁)
      (firstHitSource kind₂ a c₂ x₂) := by
  rw [Finset.disjoint_left]
  intro n h₁ h₂
  have h₁' := (mem_firstHitSource_iff.mp h₁).2
  have h₂' := (mem_firstHitSource_iff.mp h₂).2
  rcases h₁' with ⟨k₁, hfirst₁, hchild₁⟩
  rcases h₂' with ⟨k₂, hfirst₂, hchild₂⟩
  have hk : k₁ = k₂ := by
    by_contra hne_k
    rcases lt_or_gt_of_ne hne_k with hlt | hgt
    · have hno := hfirst₂.2 (k₁ + 1) (by omega)
      exact hno hfirst₁.1
    · have hno := hfirst₁.2 (k₂ + 1) (by omega)
      exact hno hfirst₂.1
  apply hne
  calc
    c₁ = T^[k₁] n := hchild₁.symm
    _ = T^[k₂] n := by rw [hk]
    _ = c₂ := hchild₂

theorem firstHitSource_subset_parent
    {kind : AdvancedSourceKind} {a c x xChild : Nat}
    (hcarith : 3 * c + 1 = 2 * a)
    (hax : a ≤ x) (hxChild : xChild ≤ x) :
    firstHitSource kind a c xChild ⊆ piStarFinset a x := by
  intro n hn
  have hsource : n ∈ sourceFinset kind c xChild :=
    (mem_firstHitSource_iff.mp hn).1
  exact source_preserves_parent hcarith hax hxChild hsource

theorem firstHitSource_pairwise_disjoint
    {ι : Type*} [DecidableEq ι]
    {kind : ι → AdvancedSourceKind}
    {c xChild : ι → Nat}
    {a : Nat} (I : Finset ι)
    (hdistinct : ∀ i ∈ I, ∀ j ∈ I, i ≠ j → c i ≠ c j) :
    (I : Set ι).PairwiseDisjoint
      (fun i => firstHitSource (kind i) a (c i) (xChild i)) := by
  intro i hi j hj hij
  change Disjoint
    (firstHitSource (kind i) a (c i) (xChild i))
    (firstHitSource (kind j) a (c j) (xChild j))
  exact firstHitSource_disjoint (hdistinct i hi j hj hij)

end F3FirstHitFibers
end KL2003
end CollatzClassical
