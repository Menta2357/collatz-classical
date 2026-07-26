import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveCarrier
import CollatzClassical.KL2003.F3ReturnExcursionFirstHitFibers
import CollatzClassical.KL2003.F3ReturnExcursionSemanticBridge

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Ordered one-layer first-entry semantics for the fixed Block0 active carrier.

The child hit, fixed channel suffix, and first entrance into the parent are
carried by one witness.  This removes the temporal ambiguity in intersecting
two unrelated existential reachability facts.  The finite fibre below is a
specification object only: no trajectory table, reverse BFS payload, margin,
exponent, or density theorem is introduced here.
-/

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3Block0OrderedFirstHit

open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0ActiveCarrier
open F3CoreArithmeticCodecPilotRepair
open F3FirstHitFibers
open F3SemanticBridge

def parentRoot (p : Active0Occurrence) : Nat :=
  rootValue (occurrenceRoot p.1)

/-! For `a = 5 + 3*i`, the unique positive inverse child is `3 + 2*i`. -/
def inverseChildRoot (p : Active0Occurrence) : Nat :=
  3 + 2 * (occurrenceRoot p.1).1

theorem inverseChildRoot_arithmetic (p : Active0Occurrence) :
    3 * inverseChildRoot p + 1 = 2 * parentRoot p := by
  simp only [inverseChildRoot, parentRoot, rootValue]
  omega

theorem inverseChildRoot_eq_div (p : Active0Occurrence) :
    inverseChildRoot p = (2 * parentRoot p - 1) / 3 := by
  have h := inverseChildRoot_arithmetic p
  omega

def semanticChildRoot (p : Active0Occurrence) : Nat :=
  match occurrenceFormulaEdge p.1 with
  | .retarded _ => 4 * parentRoot p
  | .advancedDirect _ _ => inverseChildRoot p
  | .advancedParityLift _ _ => 2 * inverseChildRoot p

def terminalPredecessor (p : Active0Occurrence) : Nat :=
  match occurrenceFormulaEdge p.1 with
  | .retarded _ => 2 * parentRoot p
  | .advancedDirect _ _ => inverseChildRoot p
  | .advancedParityLift _ _ => inverseChildRoot p

def suffixLength (p : Active0Occurrence) : Nat :=
  match occurrenceFormulaEdge p.1 with
  | .retarded _ => 2
  | .advancedDirect _ _ => 1
  | .advancedParityLift _ _ => 2

def parentWindow0 (p : Active0Occurrence) : Nat :=
  256 * parentRoot p

def childWindow0 (p : Active0Occurrence) : Nat :=
  match occurrenceFormulaEdge p.1 with
  | .retarded _ => parentWindow0 p
  | .advancedDirect _ _ => 384 * inverseChildRoot p
  | .advancedParityLift _ _ => 384 * inverseChildRoot p

def ChannelSuffix (p : Active0Occurrence) : Prop :=
  match occurrenceFormulaEdge p.1 with
  | .retarded _ =>
      T (semanticChildRoot p) = terminalPredecessor p ∧
      T (terminalPredecessor p) = parentRoot p
  | .advancedDirect _ _ =>
      semanticChildRoot p = terminalPredecessor p ∧
      T (terminalPredecessor p) = parentRoot p
  | .advancedParityLift _ _ =>
      T (semanticChildRoot p) = terminalPredecessor p ∧
      T (terminalPredecessor p) = parentRoot p

theorem channelSuffix_proved (p : Active0Occurrence) : ChannelSuffix p := by
  cases h : occurrenceFormulaEdge p.1 with
  | retarded s =>
      simp only [ChannelSuffix, h, semanticChildRoot, terminalPredecessor]
      exact
        ⟨two_branch_T_four_mul (parentRoot p),
          two_branch_T_two_mul (parentRoot p)⟩
  | advancedDirect s ell =>
      simp only [ChannelSuffix, h, semanticChildRoot, terminalPredecessor]
      exact
        ⟨trivial,
          two_branch_advanced_child_maps_to_root
            (inverseChildRoot_arithmetic p)⟩
  | advancedParityLift s ell =>
      simp only [ChannelSuffix, h, semanticChildRoot, terminalPredecessor]
      exact
        ⟨two_branch_T_two_mul (inverseChildRoot p),
          two_branch_advanced_child_maps_to_root
            (inverseChildRoot_arithmetic p)⟩

theorem childWindow0_le_parentWindow0 (p : Active0Occurrence) :
    childWindow0 p ≤ parentWindow0 p := by
  cases h : occurrenceFormulaEdge p.1 with
  | retarded s => simp [childWindow0, parentWindow0, h]
  | advancedDirect s ell =>
      simp only [childWindow0, parentWindow0, h]
      have hc := inverseChildRoot_arithmetic p
      omega
  | advancedParityLift s ell =>
      simp only [childWindow0, parentWindow0, h]
      have hc := inverseChildRoot_arithmetic p
      omega

def FirstHitViaChildAt
    (p : Active0Occurrence) (n h : Nat) : Prop :=
    T^[h] n = semanticChildRoot p ∧
    (∀ j, j ≤ h →
      1 ≤ T^[j] n ∧ T^[j] n ≤ childWindow0 p) ∧
    (∀ j, j ≤ h → T^[j] n ≠ parentRoot p) ∧
    ChannelSuffix p ∧
    FirstHitsAt (parentRoot p) n (h + suffixLength p)

def FirstHitViaChild (p : Active0Occurrence) (n : Nat) : Prop :=
  ∃ h, FirstHitViaChildAt p n h

def firstHitFiber0 (p : Active0Occurrence) : Finset Nat := by
  classical
  exact (piStarFinset (semanticChildRoot p) (childWindow0 p)).filter
    (fun n => FirstHitThrough
      (parentRoot p) (terminalPredecessor p) n)

def orderedFirstHitFiber0 (p : Active0Occurrence) : Finset Nat := by
  classical
  exact (Finset.range (childWindow0 p + 1)).filter
    (fun n => 1 ≤ n ∧ FirstHitViaChild p n)

theorem mem_firstHitFiber0_iff (p : Active0Occurrence) (n : Nat) :
    n ∈ firstHitFiber0 p ↔
      n ∈ piStarFinset (semanticChildRoot p) (childWindow0 p) ∧
      FirstHitThrough (parentRoot p) (terminalPredecessor p) n := by
  classical
  simp [firstHitFiber0]

theorem mem_orderedFirstHitFiber0_iff
    (p : Active0Occurrence) (n : Nat) :
    n ∈ orderedFirstHitFiber0 p ↔
      n ≤ childWindow0 p ∧ 1 ≤ n ∧ FirstHitViaChild p n := by
  classical
  simp [orderedFirstHitFiber0, Nat.lt_succ_iff]

theorem firstHitViaChild_source_mem
    {p : Active0Occurrence} {n : Nat}
    (hn : 1 ≤ n) (hvia : FirstHitViaChild p n) :
    n ∈ piStarFinset (semanticChildRoot p) (childWindow0 p) := by
  rcases hvia with ⟨h, hchild, hwindow, _havoid, _hsuffix, _hfirst⟩
  rw [mem_piStarFinset_reachesWithin_iff]
  refine ⟨?_, hn, ⟨h, ?_, hchild⟩⟩
  · simpa using (hwindow 0 (Nat.zero_le h)).2
  · intro j hj
    exact (hwindow j hj).2

theorem firstHitViaChild_firstHitThrough
    {p : Active0Occurrence} {n : Nat}
    (hvia : FirstHitViaChild p n) :
    FirstHitThrough (parentRoot p) (terminalPredecessor p) n := by
  rcases hvia with
    ⟨h, hchild, _hwindow, _havoid, _hsuffix, hfirst⟩
  cases hedge : occurrenceFormulaEdge p.1 with
  | retarded s =>
      refine ⟨h + 1, ?_, ?_⟩
      · simpa [suffixLength, hedge, Nat.add_assoc] using hfirst
      · calc
          T^[h + 1] n = T (T^[h] n) :=
            Function.iterate_succ_apply' T h n
          _ = T (4 * parentRoot p) := by
            rw [hchild]
            simp [semanticChildRoot, hedge]
          _ = 2 * parentRoot p :=
            two_branch_T_four_mul (parentRoot p)
          _ = terminalPredecessor p := by
            simp [terminalPredecessor, hedge]
  | advancedDirect s ell =>
      refine ⟨h, ?_, ?_⟩
      · simpa [suffixLength, hedge] using hfirst
      · simpa [semanticChildRoot, terminalPredecessor, hedge] using hchild
  | advancedParityLift s ell =>
      refine ⟨h + 1, ?_, ?_⟩
      · simpa [suffixLength, hedge, Nat.add_assoc] using hfirst
      · calc
          T^[h + 1] n = T (T^[h] n) :=
            Function.iterate_succ_apply' T h n
          _ = T (2 * inverseChildRoot p) := by
            rw [hchild]
            simp [semanticChildRoot, hedge]
          _ = inverseChildRoot p :=
            two_branch_T_two_mul (inverseChildRoot p)
          _ = terminalPredecessor p := by
            simp [terminalPredecessor, hedge]

theorem orderedFirstHitFiber0_subset_firstHitFiber0
    (p : Active0Occurrence) :
    orderedFirstHitFiber0 p ⊆ firstHitFiber0 p := by
  intro n hn
  have hm := (mem_orderedFirstHitFiber0_iff p n).mp hn
  rw [mem_firstHitFiber0_iff]
  exact
    ⟨firstHitViaChild_source_mem hm.2.1 hm.2.2,
      firstHitViaChild_firstHitThrough hm.2.2⟩

theorem orderedFirstHitFiber0_subset_parent
    (p : Active0Occurrence) :
    orderedFirstHitFiber0 p ⊆
      piStarFinset (parentRoot p) (parentWindow0 p) := by
  intro n hn
  have hm := (mem_orderedFirstHitFiber0_iff p n).mp hn
  have hchild :
      n ∈ piStarFinset (semanticChildRoot p) (childWindow0 p) :=
    firstHitViaChild_source_mem hm.2.1 hm.2.2
  have hparent : parentRoot p ≤ parentWindow0 p := by
    have hp : 1 ≤ parentRoot p := by
      exact le_trans (by omega : 1 ≤ 3)
        (rootValue_lower (occurrenceRoot p.1))
    simp only [parentWindow0]
    omega
  have hwindow := childWindow0_le_parentWindow0 p
  cases hedge : occurrenceFormulaEdge p.1 with
  | retarded s =>
      apply two_branch_retarded_injection
        (a := parentRoot p) (x := parentWindow0 p)
        (xRet := childWindow0 p) (n := n) hwindow
      simpa [semanticChildRoot, hedge] using hchild
  | advancedDirect s ell =>
      apply two_branch_advanced_injection
        (a := parentRoot p) (c := inverseChildRoot p)
        (x := parentWindow0 p) (xAdv := childWindow0 p) (n := n)
        (two_branch_advanced_child_maps_to_root
          (inverseChildRoot_arithmetic p)) hparent hwindow
      simpa [semanticChildRoot, hedge] using hchild
  | advancedParityLift s ell =>
      apply two_branch_parity_lift_injection
        (a := parentRoot p) (c := inverseChildRoot p)
        (x := parentWindow0 p) (xLift := childWindow0 p) (n := n)
        (two_branch_advanced_child_maps_to_root
          (inverseChildRoot_arithmetic p)) hparent hwindow
      simpa [semanticChildRoot, hedge] using hchild

/-!
Scope: one-layer ordered specification and subset theorems only.  No Boolean
certificate checker, reverse closure, capacity, boundary, exponent, or
density theorem is asserted.
-/

end F3Block0OrderedFirstHit
end KL2003
end CollatzClassical
