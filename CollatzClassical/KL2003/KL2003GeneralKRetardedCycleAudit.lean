import CollatzClassical.KL2003.KL2003GeneralKNestedReturnDescent

namespace CollatzClassical
namespace KL2003
namespace GeneralKRetardedCycleAudit

/-!
Audit of the global context-admissibility contract at general `k`.

At `k = 5`, the source graph contains the simple closed route

```text
242 --D3--> 161 --D3--> 107 --D3--> 152 --D3--> 182 --retarded--> 242.
```

Its evaluated weight is `4 * alpha - 6`, which is positive.  Thus an
arbitrary source walk, and in particular a first traversal of this route,
need not satisfy `ContextAdmissible`.  The deletion rule still prevents an
infinite surviving branch from repeating the route: the next advanced arrival
at mode `161` would have the previous occurrence as a deletion witness.  The
termination consumer therefore has to use advanced-arrival recurrence rather
than assume negativity of every closed factor.
-/

open GeneralKSourceGraph
open GeneralKNestedReturnDescent

private theorem hp : 1 <= 4 := by omega

def mode242 : TrackedMode 5 := by
  refine ⟨⟨242, ?_⟩, ?_⟩ <;> norm_num [generalKModulus]

def mode161 : TrackedMode 5 := by
  refine ⟨⟨161, ?_⟩, ?_⟩ <;> norm_num [generalKModulus]

def mode107 : TrackedMode 5 := by
  refine ⟨⟨107, ?_⟩, ?_⟩ <;> norm_num [generalKModulus]

def mode152 : TrackedMode 5 := by
  refine ⟨⟨152, ?_⟩, ?_⟩ <;> norm_num [generalKModulus]

def mode182 : TrackedMode 5 := by
  refine ⟨⟨182, ?_⟩, ?_⟩ <;> norm_num [generalKModulus]

def edge242to161 : SourceAction mode242 :=
  d3AdvancedAction mode242 (by norm_num [mode242]) 1

def edge161to107 : SourceAction mode161 :=
  d3AdvancedAction mode161 (by norm_num [mode161]) 1

def edge107to152 : SourceAction mode107 :=
  d3AdvancedAction mode107 (by norm_num [mode107]) 1

def edge152to182 : SourceAction mode152 :=
  d3AdvancedAction mode152 (by norm_num [mode152]) 2

theorem edge242to161_target : edge242to161.target hp = mode161 := by
  apply Subtype.ext
  apply Fin.ext
  norm_num [edge242to161, SourceAction.target, d3AdvancedAction,
    d3LowerTrackedMode, d3RawLowerModeValue, liftTrackedMode,
    mode242, mode161, generalKModulus, hp]

theorem edge161to107_target : edge161to107.target hp = mode107 := by
  apply Subtype.ext
  apply Fin.ext
  norm_num [edge161to107, SourceAction.target, d3AdvancedAction,
    d3LowerTrackedMode, d3RawLowerModeValue, liftTrackedMode,
    mode161, mode107, generalKModulus, hp]

theorem edge107to152_target : edge107to152.target hp = mode152 := by
  apply Subtype.ext
  apply Fin.ext
  norm_num [edge107to152, SourceAction.target, d3AdvancedAction,
    d3LowerTrackedMode, d3RawLowerModeValue, liftTrackedMode,
    mode107, mode152, generalKModulus, hp]

theorem edge152to182_target : edge152to182.target hp = mode182 := by
  apply Subtype.ext
  apply Fin.ext
  norm_num [edge152to182, SourceAction.target, d3AdvancedAction,
    d3LowerTrackedMode, d3RawLowerModeValue, liftTrackedMode,
    mode152, mode182, generalKModulus, hp]

theorem retarded182to242_target :
    (retardedAction mode182).target hp = mode242 := by
  apply Subtype.ext
  apply Fin.ext
  norm_num [SourceAction.target, retardedAction, fourTrackedMode,
    mode182, mode242, generalKModulus, hp]

def positiveRetardedCycle : SourceWalk hp mode242 mode242 := by
  apply SourceWalk.cons edge242to161
  rw [edge242to161_target]
  apply SourceWalk.cons edge161to107
  rw [edge161to107_target]
  apply SourceWalk.cons edge107to152
  rw [edge107to152_target]
  apply SourceWalk.cons edge152to182
  rw [edge152to182_target]
  apply SourceWalk.cons (retardedAction mode182)
  rw [retarded182to242_target]
  exact SourceWalk.nil mode242

theorem positiveRetardedCycle_length : positiveRetardedCycle.length = 5 := by
  simp [positiveRetardedCycle, SourceWalk.length]

theorem positiveRetardedCycle_weight :
    positiveRetardedCycle.weight =
      SymbolicShift.d3Advanced +
        (SymbolicShift.d3Advanced +
          (SymbolicShift.d3Advanced +
            (SymbolicShift.d3Advanced + SymbolicShift.retardedTwo))) := by
  simp [positiveRetardedCycle, SourceWalk.weight, edge242to161,
    edge161to107, edge107to152, edge152to182, SourceAction.weight,
    d3AdvancedAction, retardedAction, GeneralKSourceGraph.shift_add_zero]

theorem positiveRetardedCycle_weight_eval :
    positiveRetardedCycle.weight.eval = 4 * alpha - 6 := by
  rw [positiveRetardedCycle_weight]
  simp only [SymbolicShift.eval_add, SymbolicShift.eval_d3Advanced,
    SymbolicShift.eval_retardedTwo]
  ring

theorem positiveRetardedCycle_weight_eval_pos :
    0 < positiveRetardedCycle.weight.eval := by
  rw [positiveRetardedCycle_weight_eval]
  linarith [alpha_lower_bound]

theorem positiveRetardedCycle_not_contextAdmissible :
    Not (ContextAdmissible positiveRetardedCycle) := by
  intro hadmissible
  have hneg := hadmissible.closed_weight_neg positiveRetardedCycle (by
    rw [positiveRetardedCycle_length]
    norm_num)
  linarith [positiveRetardedCycle_weight_eval_pos]

end GeneralKRetardedCycleAudit
end KL2003
end CollatzClassical
