import CollatzClassical.KL2003.F3ReturnExcursionM0ACertificate
import CollatzClassical.KL2003.KL2003M0BTwoBranchCore

/-!
Semantic bridge for F3 frozen rows.

The finite M0-a checker stores state IDs and channels.  This file introduces
the missing semantic interface: a frozen row must carry an arithmetic rule
witness, and that witness transports actual `piStarFinset` members.  The
three rule constructors are retarded, advanced-direct, and parity-lift.
The bridge does not assert that all 1215 frozen rows already have witnesses;
that coverage inventory is a separate obligation.
-/

namespace CollatzClassical
namespace KL2003
namespace F3SemanticBridge

open F3ReturnExcursionM0A

inductive FrozenRule where
  | retarded (a x xRet : Nat)
  | advancedDirect (a c x xAdv : Nat)
  | parityLift (a c x xLift : Nat)
  deriving DecidableEq, Repr

def FrozenRule.channel : FrozenRule → Nat
  | .retarded .. => 0
  | .advancedDirect .. => 1
  | .parityLift .. => 2

theorem two_branch_parity_lift_injection {a c x xLift n : Nat}
    (hc : T c = a)
    (hax : a ≤ x)
    (hxLift : xLift ≤ x)
    (hmem : n ∈ piStarFinset (2 * c) xLift) :
    n ∈ piStarFinset a x := by
  have hm :=
    (mem_piStarFinset_reachesWithin_iff
      (a := 2 * c) (x := xLift) (n := n)).1 hmem
  have h2cxLift : 2 * c ≤ xLift :=
    reachesWithin_root_le_window hm.2.2
  have h2cx : 2 * c ≤ x := le_trans h2cxLift hxLift
  have hcx : c ≤ x := by omega
  have hchild : ReachesWithin c x n :=
    reachesWithin_append_path hm.2.2 hxLift
      (two_branch_child_path_to_root (a := c) (x := x) h2cx hcx)
  have hreach : ReachesWithin a x n :=
    reachesWithin_append_path hchild le_rfl
      (two_branch_advanced_path_to_root (a := a) (c := c) (x := x)
        hc (by omega) hax)
  rw [mem_piStarFinset_reachesWithin_iff]
  exact ⟨le_trans hm.1 hxLift, hm.2.1, hreach⟩

theorem frozen_rule_preserves
    (rule : FrozenRule) (n : Nat) :
    match rule with
    | .retarded a x xRet =>
        xRet ≤ x → n ∈ piStarFinset (4 * a) xRet →
          n ∈ piStarFinset a x
    | .advancedDirect a c x xAdv =>
        T c = a → a ≤ x → xAdv ≤ x →
          n ∈ piStarFinset c xAdv → n ∈ piStarFinset a x
    | .parityLift a c x xLift =>
        T c = a → a ≤ x → xLift ≤ x →
          n ∈ piStarFinset (2 * c) xLift → n ∈ piStarFinset a x := by
  cases rule with
  | retarded a x xRet =>
      intro hxRet hmem
      exact two_branch_retarded_injection
        (a := a) (x := x) (xRet := xRet) (n := n) hxRet hmem
  | advancedDirect a c x xAdv =>
      intro hc hax hxAdv hmem
      exact two_branch_advanced_injection
        (a := a) (c := c) (x := x) (xAdv := xAdv) (n := n)
        hc hax hxAdv hmem
  | parityLift a c x xLift =>
      intro hc hax hxLift hmem
      exact two_branch_parity_lift_injection
        (a := a) (c := c) (x := x) (xLift := xLift) (n := n)
        hc hax hxLift hmem

/-!
The membership bridge is useful only after lifting it from individual members
to the finite populations used by `piStar`.  These two theorems make that
lift explicit.  They are still one-row statements: coverage of all frozen
rows and any weighted summation remain separate obligations.
-/

theorem frozen_rule_piStar_subset
    (rule : FrozenRule) :
    match rule with
    | .retarded a x xRet =>
        xRet ≤ x → piStarFinset (4 * a) xRet ⊆ piStarFinset a x
    | .advancedDirect a c x xAdv =>
        T c = a → a ≤ x → xAdv ≤ x →
          piStarFinset c xAdv ⊆ piStarFinset a x
    | .parityLift a c x xLift =>
        T c = a → a ≤ x → xLift ≤ x →
          piStarFinset (2 * c) xLift ⊆ piStarFinset a x := by
  cases rule with
  | retarded a x xRet =>
      intro hxRet n hn
      exact frozen_rule_preserves (.retarded a x xRet) n hxRet hn
  | advancedDirect a c x xAdv =>
      intro hc hax hxAdv n hn
      exact frozen_rule_preserves (.advancedDirect a c x xAdv) n
        hc hax hxAdv hn
  | parityLift a c x xLift =>
      intro hc hax hxLift n hn
      exact frozen_rule_preserves (.parityLift a c x xLift) n
        hc hax hxLift hn

theorem frozen_rule_piStar_card_le
    (rule : FrozenRule) :
    match rule with
    | .retarded a x xRet =>
        xRet ≤ x →
          (piStarFinset (4 * a) xRet).card ≤ (piStarFinset a x).card
    | .advancedDirect a c x xAdv =>
        T c = a → a ≤ x → xAdv ≤ x →
          (piStarFinset c xAdv).card ≤ (piStarFinset a x).card
    | .parityLift a c x xLift =>
        T c = a → a ≤ x → xLift ≤ x →
          (piStarFinset (2 * c) xLift).card ≤ (piStarFinset a x).card := by
  cases rule with
  | retarded a x xRet =>
      intro hxRet
      exact Finset.card_le_card
        (frozen_rule_piStar_subset (.retarded a x xRet) hxRet)
  | advancedDirect a c x xAdv =>
      intro hc hax hxAdv
      exact Finset.card_le_card
        (frozen_rule_piStar_subset (.advancedDirect a c x xAdv)
          hc hax hxAdv)
  | parityLift a c x xLift =>
      intro hc hax hxLift
      exact Finset.card_le_card
        (frozen_rule_piStar_subset (.parityLift a c x xLift)
          hc hax hxLift)

structure RealizedFrozenRow where
  edge : SplitEdge
  rule : FrozenRule
  channel_matches : edge.channel = rule.channel
  source_state_is_declared : edge.source < 729
  target_state_is_declared : edge.target < 729

theorem realized_row_channel_is_rule
    (row : RealizedFrozenRow) : row.edge.channel = row.rule.channel :=
  row.channel_matches

theorem realized_row_piStar_bridge
    (row : RealizedFrozenRow) (n : Nat) :
    match row.rule with
    | .retarded a x xRet =>
        xRet ≤ x → n ∈ piStarFinset (4 * a) xRet →
          n ∈ piStarFinset a x
    | .advancedDirect a c x xAdv =>
        T c = a → a ≤ x → xAdv ≤ x →
          n ∈ piStarFinset c xAdv → n ∈ piStarFinset a x
    | .parityLift a c x xLift =>
        T c = a → a ≤ x → xLift ≤ x →
          n ∈ piStarFinset (2 * c) xLift → n ∈ piStarFinset a x := by
  exact frozen_rule_preserves row.rule n

theorem realized_row_piStar_card_bridge
    (row : RealizedFrozenRow) :
    match row.rule with
    | .retarded a x xRet =>
        xRet ≤ x →
          (piStarFinset (4 * a) xRet).card ≤ (piStarFinset a x).card
    | .advancedDirect a c x xAdv =>
        T c = a → a ≤ x → xAdv ≤ x →
          (piStarFinset c xAdv).card ≤ (piStarFinset a x).card
    | .parityLift a c x xLift =>
        T c = a → a ≤ x → xLift ≤ x →
          (piStarFinset (2 * c) xLift).card ≤ (piStarFinset a x).card := by
  exact frozen_rule_piStar_card_le row.rule

def allFrozenRowsHaveWitness : Prop :=
  ∀ edge : SplitEdge, edge ∈ splitEdges → ∃ row : RealizedFrozenRow,
    row.edge = edge

end F3SemanticBridge
end KL2003
end CollatzClassical
