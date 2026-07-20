import CollatzClassical.KL2003.KL2003AlphaIrrational

namespace CollatzClassical
namespace KL2003
namespace GeneralKFiniteCycleAudit

/-!
Counterexample to the naive simple-cycle decomposition step.

At `k = 2`, the source graph contains the closed route

```text
8 --D3--> 2 --D1--> 2 --D1--> 8.
```

The inner class-2 loop and the complete nested route have negative evaluated
weight. Removing the inner loop leaves the simple cycle `8 -> 2 -> 8`, whose
evaluated weight is positive. Therefore contextual nonpositivity of contiguous
repeated-mode segments does not transfer automatically to every simple cycle
produced by loop erasure.
-/

open GeneralKSourceGraph

def k2Mode2 : TrackedMode 2 := by
  refine ⟨⟨2, ?_⟩, ?_⟩ <;> norm_num [generalKModulus]

def k2Mode8 : TrackedMode 2 := by
  refine ⟨⟨8, ?_⟩, ?_⟩ <;> norm_num [generalKModulus]

def edge8to2 : SourceAction k2Mode8 :=
  d3AdvancedAction k2Mode8 (by norm_num [k2Mode8]) 0

def edge2loop : SourceAction k2Mode2 :=
  d1AdvancedAction k2Mode2 (by norm_num [k2Mode2]) 0

def edge2to8 : SourceAction k2Mode2 :=
  d1AdvancedAction k2Mode2 (by norm_num [k2Mode2]) 2

theorem edge8to2_target :
    edge8to2.target (by omega : 1 <= 1) = k2Mode2 := by
  apply Subtype.ext
  apply Fin.ext
  norm_num [edge8to2, SourceAction.target, d3AdvancedAction,
    d3LowerTrackedMode, d3RawLowerModeValue, liftTrackedMode,
    k2Mode8, k2Mode2, generalKModulus]

theorem edge2loop_target :
    edge2loop.target (by omega : 1 <= 1) = k2Mode2 := by
  apply Subtype.ext
  apply Fin.ext
  norm_num [edge2loop, SourceAction.target, d1AdvancedAction,
    d1LowerTrackedMode, d1RawLowerModeValue, liftTrackedMode,
    k2Mode2, generalKModulus]

theorem edge2to8_target :
    edge2to8.target (by omega : 1 <= 1) = k2Mode8 := by
  apply Subtype.ext
  apply Fin.ext
  norm_num [edge2to8, SourceAction.target, d1AdvancedAction,
    d1LowerTrackedMode, d1RawLowerModeValue, liftTrackedMode,
    k2Mode2, k2Mode8, generalKModulus]

def innerWeight : SymbolicShift := SymbolicShift.d1Advanced

def residualSimpleCycleWeight : SymbolicShift :=
  SymbolicShift.d3Advanced + SymbolicShift.d1Advanced

def nestedClosedWalkWeight : SymbolicShift :=
  SymbolicShift.d3Advanced +
    (SymbolicShift.d1Advanced + SymbolicShift.d1Advanced)

theorem innerWeight_eval_neg : innerWeight.eval < 0 := by
  rw [innerWeight, SymbolicShift.eval_d1Advanced]
  linarith [alpha_upper_bound]

theorem residualSimpleCycleWeight_eval_pos :
    0 < residualSimpleCycleWeight.eval := by
  rw [residualSimpleCycleWeight, SymbolicShift.eval_add,
    SymbolicShift.eval_d3Advanced,
    SymbolicShift.eval_d1Advanced]
  linarith [alpha_lower_bound]

theorem nestedClosedWalkWeight_eval_neg :
    nestedClosedWalkWeight.eval < 0 := by
  rw [nestedClosedWalkWeight, SymbolicShift.eval_add,
    SymbolicShift.eval_add,
    SymbolicShift.eval_d3Advanced,
    SymbolicShift.eval_d1Advanced]
  linarith [alpha_upper_bound]

theorem nested_weight_symbolic_decomposition :
    nestedClosedWalkWeight = residualSimpleCycleWeight + innerWeight := by
  exact (GeneralKSourceGraph.shift_add_assoc
    SymbolicShift.d3Advanced SymbolicShift.d1Advanced
    SymbolicShift.d1Advanced).symm

theorem nested_weight_decomposition :
    nestedClosedWalkWeight.eval =
      residualSimpleCycleWeight.eval + innerWeight.eval := by
  rw [nested_weight_symbolic_decomposition, SymbolicShift.eval_add]

end GeneralKFiniteCycleAudit
end KL2003
end CollatzClassical
