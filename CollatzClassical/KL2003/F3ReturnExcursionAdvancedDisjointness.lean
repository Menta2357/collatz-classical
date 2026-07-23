import CollatzClassical.KL2003.F3ReturnExcursionSemanticBridge

namespace CollatzClassical
namespace KL2003
namespace F3AdvancedDisjointness

open F3SemanticBridge

/-!
The split-edge inventory contains two kinds of advanced source population:
the direct source `c` and the parity-lift source `2*c`.  Both descend to the
same inverse child `c` before reaching the parent `a`.  This file proves the
missing pairwise-disjointness interface for those two kinds.

It is a member-wise statement.  It does not claim that the frozen aggregate
matrix already gives a density theorem; the finite population and first-hit
path hypotheses remain separate.
-/

inductive AdvancedSourceKind where
  | direct
  | parityLift
  deriving DecidableEq, Repr

def sourceFinset (kind : AdvancedSourceKind) (c xChild : Nat) :
    Finset Nat :=
  match kind with
  | .direct => piStarFinset c xChild
  | .parityLift => piStarFinset (2 * c) xChild

theorem source_reaches_inverse_child
    {kind : AdvancedSourceKind} {a c x xChild n : Nat}
    (hcarith : 3 * c + 1 = 2 * a)
    (hax : a ≤ x) (hxChild : xChild ≤ x)
    (hmem : n ∈ sourceFinset kind c xChild) :
    ReachesWithin c x n := by
  have hc : T c = a :=
    two_branch_advanced_child_maps_to_root hcarith
  cases kind with
  | direct =>
      exact two_branch_advanced_reaches_child
        (c := c) (x := x) (xAdv := xChild) (n := n) hxChild hmem
  | parityLift =>
      have hm :=
        (mem_piStarFinset_reachesWithin_iff
          (a := 2 * c) (x := xChild) (n := n)).1 hmem
      have h2cxChild : 2 * c ≤ xChild :=
        reachesWithin_root_le_window hm.2.2
      have h2cx : 2 * c ≤ x := le_trans h2cxChild hxChild
      have hcx : c ≤ x := by omega
      exact reachesWithin_append_path hm.2.2 hxChild
        (two_branch_child_path_to_root (a := c) (x := x) h2cx hcx)

theorem source_preserves_parent
    {kind : AdvancedSourceKind} {a c x xChild n : Nat}
    (hcarith : 3 * c + 1 = 2 * a)
    (hax : a ≤ x) (hxChild : xChild ≤ x)
    (hmem : n ∈ sourceFinset kind c xChild) :
    n ∈ piStarFinset a x := by
  have hc : T c = a :=
    two_branch_advanced_child_maps_to_root hcarith
  cases kind with
  | direct =>
      exact two_branch_advanced_injection
        (a := a) (c := c) (x := x) (xAdv := xChild) (n := n)
        hc hax hxChild hmem
  | parityLift =>
      exact two_branch_parity_lift_injection
        (a := a) (c := c) (x := x) (xLift := xChild) (n := n)
        hc hax hxChild hmem

theorem source_member_disjoint
    {kind₁ kind₂ : AdvancedSourceKind}
    {a c₁ c₂ x x₁ x₂ n : Nat}
    (ha : NotInCycle a)
    (hax : a ≤ x)
    (hcarith₁ : 3 * c₁ + 1 = 2 * a)
    (hcarith₂ : 3 * c₂ + 1 = 2 * a)
    (hne : c₁ ≠ c₂)
    (hx₁ : x₁ ≤ x) (hx₂ : x₂ ≤ x)
    (h₁ : n ∈ sourceFinset kind₁ c₁ x₁)
    (h₂ : n ∈ sourceFinset kind₂ c₂ x₂) :
    False := by
  have hc₁ : T c₁ = a :=
    two_branch_advanced_child_maps_to_root hcarith₁
  have hc₂ : T c₂ = a :=
    two_branch_advanced_child_maps_to_root hcarith₂
  have hchild₁ : ReachesWithin c₁ x n :=
    source_reaches_inverse_child hcarith₁ hax hx₁ h₁
  have hchild₂ : ReachesWithin c₂ x n :=
    source_reaches_inverse_child hcarith₂ hax hx₂ h₂
  have htarget : ReachesWithin a x n :=
    (mem_piStarFinset_reachesWithin_iff (a := a) (x := x) (n := n)).1
      (source_preserves_parent hcarith₁ hax hx₁ h₁) |>.2.2
  rcases exists_firstHitsAt_of_reachesWithin htarget with
    ⟨k₀, _hk₀x, hfirst, _hwin⟩
  have hk₀ : 0 < k₀ := by
    by_contra hnot
    have hk₀eq : k₀ = 0 := by omega
    have hn_eq_a : n = a := by
      simpa [FirstHitsAt, hk₀eq] using hfirst.1
    have h₁a : a ∈ sourceFinset kind₁ c₁ x₁ := by
      simpa [hn_eq_a] using h₁
    have hreach₁a : ReachesWithin c₁ x a :=
      source_reaches_inverse_child hcarith₁ hax hx₁ h₁a
    exact not_reaches_inverse_child_from_root
      (a := a) (c := c₁) ha hc₁
        (two_branch_advanced_child_ne_root hcarith₁) hreach₁a
  exact inverse_children_disjoint_descendants
    (a := a) (c1 := c₁) (c2 := c₂) (x := x) (n := n) (k0 := k₀)
    ha hne hc₁ hc₂ hchild₁ hchild₂ hax hfirst hk₀

theorem source_pairwise_disjoint
    {ι : Type*} [DecidableEq ι]
    {kind : ι → AdvancedSourceKind}
    {c xChild : ι → Nat}
    {a x : Nat} (I : Finset ι)
    (ha : NotInCycle a) (hax : a ≤ x)
    (hcarith : ∀ i ∈ I, 3 * c i + 1 = 2 * a)
    (hxChild : ∀ i ∈ I, xChild i ≤ x)
    (hdistinct : ∀ i ∈ I, ∀ j ∈ I, i ≠ j → c i ≠ c j) :
    (I : Set ι).PairwiseDisjoint
      (fun i => sourceFinset (kind i) (c i) (xChild i)) := by
  intro i hi j hj hij
  change Disjoint
    (sourceFinset (kind i) (c i) (xChild i))
    (sourceFinset (kind j) (c j) (xChild j))
  rw [Finset.disjoint_left]
  intro n hni hnj
  exact source_member_disjoint
    ha hax (hcarith i hi) (hcarith j hj)
    (hdistinct i hi j hj hij)
    (hxChild i hi) (hxChild j hj) hni hnj

end F3AdvancedDisjointness
end KL2003
end CollatzClassical
