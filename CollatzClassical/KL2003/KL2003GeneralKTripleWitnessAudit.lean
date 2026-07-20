import CollatzClassical.KL2003.KL2003GeneralKProvenanceTrace

namespace CollatzClassical
namespace KL2003
namespace GeneralKTripleWitnessAudit

/-!
Audit the boundary of a purely syntactic triple-witness exclusion.

At `k = 5`, a typed source walk of length thirteen starts at mode `107`,
ends at mode `20`, and has nonnegative evaluated shift at every strict prefix.
Splitting the final D1 node creates the lifted modes `26`, `107`, and `188`
at common shift `13 * alpha - 19`.  Each child has an earlier same-mode
strict prefix with smaller shift, hence all three satisfy the repository's
syntactic `HasDeletionWitness` predicate.

This is not a scheduler-reachability theorem and does not refute KL2003's
semantic critical-assignment argument.  It proves that typed source validity
plus prefix nonnegativity alone cannot establish the source claim that all
three new leaves are never deleted.  A termination proof must consume the
stronger source semantic invariant or prove an equivalent scheduler invariant.
-/

open GeneralKSourceGraph
open GeneralKSourceGenealogy
open GeneralKNestedReturnDescent
open GeneralKProvenanceTrace

private theorem hp : 1 <= 4 := by omega

private def trackedMode (n : Nat) (hlt : n < 243) (hmod : n % 3 = 2) :
    TrackedMode 5 := by
  refine ⟨⟨n, ?_⟩, hmod⟩
  simpa [generalKModulus] using hlt

def mode20 : TrackedMode 5 := trackedMode 20 (by omega) (by norm_num)
def mode26 : TrackedMode 5 := trackedMode 26 (by omega) (by norm_num)
def mode38 : TrackedMode 5 := trackedMode 38 (by omega) (by norm_num)
def mode107 : TrackedMode 5 := trackedMode 107 (by omega) (by norm_num)
def mode137 : TrackedMode 5 := trackedMode 137 (by omega) (by norm_num)
def mode152 : TrackedMode 5 := trackedMode 152 (by omega) (by norm_num)
def mode161 : TrackedMode 5 := trackedMode 161 (by omega) (by norm_num)
def mode179 : TrackedMode 5 := trackedMode 179 (by omega) (by norm_num)
def mode182 : TrackedMode 5 := trackedMode 182 (by omega) (by norm_num)
def mode188 : TrackedMode 5 := trackedMode 188 (by omega) (by norm_num)
def mode206 : TrackedMode 5 := trackedMode 206 (by omega) (by norm_num)

private def d1 (mode : TrackedMode 5) (hm : mode.1.1 % 9 = 2)
    (index : Fin 3) : SourceAction mode :=
  d1AdvancedAction mode hm index

private def d3 (mode : TrackedMode 5) (hm : mode.1.1 % 9 = 8)
    (index : Fin 3) : SourceAction mode :=
  d3AdvancedAction mode hm index

def a107to152 : SourceAction mode107 := d3 mode107 (by norm_num [mode107, trackedMode]) 1
def a152to182 : SourceAction mode152 := d3 mode152 (by norm_num [mode152, trackedMode]) 2
def a182to161 : SourceAction mode182 := d1 mode182 (by norm_num [mode182, trackedMode]) 1
def a161to26 : SourceAction mode161 := d3 mode161 (by norm_num [mode161, trackedMode]) 0
def a26to179 : SourceAction mode26 := d3 mode26 (by norm_num [mode26, trackedMode]) 2
def a179to38 : SourceAction mode179 := d3 mode179 (by norm_num [mode179, trackedMode]) 0
def a152to182b : SourceAction mode152 := a152to182
def a182to161b : SourceAction mode182 := a182to161
def a161to188 : SourceAction mode161 := d3 mode161 (by norm_num [mode161, trackedMode]) 2
def a188to206 : SourceAction mode188 := d3 mode188 (by norm_num [mode188, trackedMode]) 2
def a206to137 : SourceAction mode206 := d3 mode206 (by norm_num [mode206, trackedMode]) 1
def a137to20 : SourceAction mode137 := d1 mode137 (by norm_num [mode137, trackedMode]) 0

theorem a107to152_target : a107to152.target hp = mode152 := by
  apply Subtype.ext; apply Fin.ext
  norm_num [a107to152, d3, SourceAction.target, d3AdvancedAction,
    d3LowerTrackedMode, d3RawLowerModeValue, liftTrackedMode,
    mode107, mode152, trackedMode, generalKModulus, hp]

theorem a152to182_target : a152to182.target hp = mode182 := by
  apply Subtype.ext; apply Fin.ext
  norm_num [a152to182, d3, SourceAction.target, d3AdvancedAction,
    d3LowerTrackedMode, d3RawLowerModeValue, liftTrackedMode,
    mode152, mode182, trackedMode, generalKModulus, hp]

theorem a182to161_target : a182to161.target hp = mode161 := by
  apply Subtype.ext; apply Fin.ext
  norm_num [a182to161, d1, SourceAction.target, d1AdvancedAction,
    d1LowerTrackedMode, d1RawLowerModeValue, liftTrackedMode,
    mode182, mode161, trackedMode, generalKModulus, hp]

theorem a161to26_target : a161to26.target hp = mode26 := by
  apply Subtype.ext; apply Fin.ext
  norm_num [a161to26, d3, SourceAction.target, d3AdvancedAction,
    d3LowerTrackedMode, d3RawLowerModeValue, liftTrackedMode,
    mode161, mode26, trackedMode, generalKModulus, hp]

theorem a26to179_target : a26to179.target hp = mode179 := by
  apply Subtype.ext; apply Fin.ext
  norm_num [a26to179, d3, SourceAction.target, d3AdvancedAction,
    d3LowerTrackedMode, d3RawLowerModeValue, liftTrackedMode,
    mode26, mode179, trackedMode, generalKModulus, hp]

theorem a179to38_target : a179to38.target hp = mode38 := by
  apply Subtype.ext; apply Fin.ext
  norm_num [a179to38, d3, SourceAction.target, d3AdvancedAction,
    d3LowerTrackedMode, d3RawLowerModeValue, liftTrackedMode,
    mode179, mode38, trackedMode, generalKModulus, hp]

theorem retarded38to152_target :
    (retardedAction mode38).target hp = mode152 := by
  apply Subtype.ext; apply Fin.ext
  norm_num [SourceAction.target, retardedAction, fourTrackedMode,
    mode38, mode152, trackedMode, generalKModulus, hp]

theorem a161to188_target : a161to188.target hp = mode188 := by
  apply Subtype.ext; apply Fin.ext
  norm_num [a161to188, d3, SourceAction.target, d3AdvancedAction,
    d3LowerTrackedMode, d3RawLowerModeValue, liftTrackedMode,
    mode161, mode188, trackedMode, generalKModulus, hp]

theorem a188to206_target : a188to206.target hp = mode206 := by
  apply Subtype.ext; apply Fin.ext
  norm_num [a188to206, d3, SourceAction.target, d3AdvancedAction,
    d3LowerTrackedMode, d3RawLowerModeValue, liftTrackedMode,
    mode188, mode206, trackedMode, generalKModulus, hp]

theorem a206to137_target : a206to137.target hp = mode137 := by
  apply Subtype.ext; apply Fin.ext
  norm_num [a206to137, d3, SourceAction.target, d3AdvancedAction,
    d3LowerTrackedMode, d3RawLowerModeValue, liftTrackedMode,
    mode206, mode137, trackedMode, generalKModulus, hp]

theorem a137to20_target : a137to20.target hp = mode20 := by
  apply Subtype.ext; apply Fin.ext
  norm_num [a137to20, d1, SourceAction.target, d1AdvancedAction,
    d1LowerTrackedMode, d1RawLowerModeValue, liftTrackedMode,
    mode137, mode20, trackedMode, generalKModulus, hp]

@[simp] theorem a107to152_weight : a107to152.weight = .d3Advanced := rfl
@[simp] theorem a152to182_weight : a152to182.weight = .d3Advanced := rfl
@[simp] theorem a182to161_weight : a182to161.weight = .d1Advanced := rfl
@[simp] theorem a161to26_weight : a161to26.weight = .d3Advanced := rfl
@[simp] theorem a26to179_weight : a26to179.weight = .d3Advanced := rfl
@[simp] theorem a179to38_weight : a179to38.weight = .d3Advanced := rfl
@[simp] theorem a161to188_weight : a161to188.weight = .d3Advanced := rfl
@[simp] theorem a188to206_weight : a188to206.weight = .d3Advanced := rfl
@[simp] theorem a206to137_weight : a206to137.weight = .d3Advanced := rfl
@[simp] theorem a137to20_weight : a137to20.weight = .d1Advanced := rfl

def candidateWalk : SourceWalk hp mode107 mode20 := by
  apply SourceWalk.cons a107to152; rw [a107to152_target]
  apply SourceWalk.cons a152to182; rw [a152to182_target]
  apply SourceWalk.cons a182to161; rw [a182to161_target]
  apply SourceWalk.cons a161to26; rw [a161to26_target]
  apply SourceWalk.cons a26to179; rw [a26to179_target]
  apply SourceWalk.cons a179to38; rw [a179to38_target]
  apply SourceWalk.cons (retardedAction mode38); rw [retarded38to152_target]
  apply SourceWalk.cons a152to182b
  change SourceWalk hp (a152to182.target hp) mode20
  rw [a152to182_target]
  apply SourceWalk.cons a182to161b
  change SourceWalk hp (a182to161.target hp) mode20
  rw [a182to161_target]
  apply SourceWalk.cons a161to188; rw [a161to188_target]
  apply SourceWalk.cons a188to206; rw [a188to206_target]
  apply SourceWalk.cons a206to137; rw [a206to137_target]
  apply SourceWalk.cons a137to20; rw [a137to20_target]
  exact SourceWalk.nil mode20

theorem candidateWalk_length : candidateWalk.length = 13 := by
  simp [candidateWalk, SourceWalk.length]

def rootLabel : ELLabel 5 := ⟨mode107, .zero⟩

def candidateFinalLabel : ELLabel 5 :=
  ⟨mode20, ⟨12, -17⟩⟩

theorem candidateWalk_finalLabel :
    SourceWalk.finalLabel rootLabel candidateWalk = candidateFinalLabel := by
  change ELLabel.mk mode20 _ = ELLabel.mk mode20 _
  congr 1

def candidateAncestors : List (ELLabel 5) :=
  packedPrefixLabels rootLabel.shift (sourceWalkActionList candidateWalk) ++
    [candidateFinalLabel]

def candidateAncestorsExpected : List (ELLabel 5) :=
  [ ⟨mode107, ⟨0, 0⟩⟩,
    ⟨mode152, ⟨1, -1⟩⟩,
    ⟨mode182, ⟨2, -2⟩⟩,
    ⟨mode161, ⟨3, -4⟩⟩,
    ⟨mode26, ⟨4, -5⟩⟩,
    ⟨mode179, ⟨5, -6⟩⟩,
    ⟨mode38, ⟨6, -7⟩⟩,
    ⟨mode152, ⟨6, -9⟩⟩,
    ⟨mode182, ⟨7, -10⟩⟩,
    ⟨mode161, ⟨8, -12⟩⟩,
    ⟨mode188, ⟨9, -13⟩⟩,
    ⟨mode206, ⟨10, -14⟩⟩,
    ⟨mode137, ⟨11, -15⟩⟩,
    ⟨mode20, ⟨12, -17⟩⟩ ]

theorem candidateAncestors_eq_expected :
    candidateAncestors = candidateAncestorsExpected := by
  simp [candidateAncestors, candidateAncestorsExpected, candidateWalk,
    packedPrefixLabels, sourceWalkActionList, rootLabel, candidateFinalLabel,
    a152to182b, a182to161b, a107to152_target, a152to182_target,
    a182to161_target, a161to26_target, a26to179_target, a179to38_target,
    retarded38to152_target, a161to188_target, a188to206_target,
    a206to137_target, a137to20_target, SymbolicShift.zero,
    SymbolicShift.d1Advanced, SymbolicShift.d3Advanced,
    SymbolicShift.retardedTwo, SymbolicShift.add,
    GeneralKSourceGraph.retardedAction_weight]
  repeat' apply And.intro
  all_goals rfl

theorem candidateAncestors_nonnegative
    (label : ELLabel 5) (hmem : label ∈ candidateAncestors) :
    0 <= label.shift.eval := by
  rw [candidateAncestors_eq_expected] at hmem
  simp only [candidateAncestorsExpected, List.mem_cons, List.mem_singleton,
    List.not_mem_nil, or_false] at hmem
  rcases hmem with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
    rfl | rfl | rfl | rfl | rfl | rfl
  all_goals simp [SymbolicShift.eval]
  all_goals linarith [alpha_lower_bound]

def childShift : SymbolicShift := ⟨13, -19⟩

def child20First : SourceAction mode20 :=
  d1 mode20 (by norm_num [mode20, trackedMode]) 0

def child20Second : SourceAction mode20 :=
  d1 mode20 (by norm_num [mode20, trackedMode]) 1

def child20Third : SourceAction mode20 :=
  d1 mode20 (by norm_num [mode20, trackedMode]) 2

theorem child20First_target : child20First.target hp = mode26 := by
  apply Subtype.ext; apply Fin.ext
  norm_num [child20First, d1, SourceAction.target, d1AdvancedAction,
    d1LowerTrackedMode, d1RawLowerModeValue, liftTrackedMode,
    mode20, mode26, trackedMode, generalKModulus, hp]

theorem child20Second_target : child20Second.target hp = mode107 := by
  apply Subtype.ext; apply Fin.ext
  norm_num [child20Second, d1, SourceAction.target, d1AdvancedAction,
    d1LowerTrackedMode, d1RawLowerModeValue, liftTrackedMode,
    mode20, mode107, trackedMode, generalKModulus, hp]

theorem child20Third_target : child20Third.target hp = mode188 := by
  apply Subtype.ext; apply Fin.ext
  norm_num [child20Third, d1, SourceAction.target, d1AdvancedAction,
    d1LowerTrackedMode, d1RawLowerModeValue, liftTrackedMode,
    mode20, mode188, trackedMode, generalKModulus, hp]

theorem child20First_label :
    child20First.childLabel hp candidateFinalLabel = ⟨mode26, childShift⟩ := by
  change ELLabel.mk (child20First.target hp) _ = ELLabel.mk mode26 childShift
  rw [child20First_target]
  congr 1

theorem child20Second_label :
    child20Second.childLabel hp candidateFinalLabel = ⟨mode107, childShift⟩ := by
  change ELLabel.mk (child20Second.target hp) _ = ELLabel.mk mode107 childShift
  rw [child20Second_target]
  congr 1

theorem child20Third_label :
    child20Third.childLabel hp candidateFinalLabel = ⟨mode188, childShift⟩ := by
  change ELLabel.mk (child20Third.target hp) _ = ELLabel.mk mode188 childShift
  rw [child20Third_target]
  congr 1

def child26 : ELLeafState 5 :=
  { label := ⟨mode26, childShift⟩
    ancestors := candidateAncestors
    status := .active }

def child107 : ELLeafState 5 :=
  { label := ⟨mode107, childShift⟩
    ancestors := candidateAncestors
    status := .active }

def child188 : ELLeafState 5 :=
  { label := ⟨mode188, childShift⟩
    ancestors := candidateAncestors
    status := .active }

theorem childShift_nonnegative : 0 <= childShift.eval := by
  simp [childShift, SymbolicShift.eval]
  linarith [alpha_lower_bound]

theorem child26_hasDeletionWitness : HasDeletionWitness child26 := by
  refine ⟨childShift_nonnegative, ?_⟩
  refine ⟨⟨mode26, ⟨4, -5⟩⟩, ?_, rfl, ?_⟩
  · change ⟨mode26, ⟨4, -5⟩⟩ ∈ candidateAncestors
    rw [candidateAncestors_eq_expected]
    simp [candidateAncestorsExpected]
  · simp [child26, childShift, SymbolicShift.eval]
    linarith [alpha_lower_bound]

theorem child107_hasDeletionWitness : HasDeletionWitness child107 := by
  refine ⟨childShift_nonnegative, ?_⟩
  refine ⟨⟨mode107, ⟨0, 0⟩⟩, ?_, rfl, ?_⟩
  · change ⟨mode107, ⟨0, 0⟩⟩ ∈ candidateAncestors
    rw [candidateAncestors_eq_expected]
    simp [candidateAncestorsExpected]
  · simp [child107, childShift, SymbolicShift.eval]
    linarith [alpha_lower_bound]

theorem child188_hasDeletionWitness : HasDeletionWitness child188 := by
  refine ⟨childShift_nonnegative, ?_⟩
  refine ⟨⟨mode188, ⟨9, -13⟩⟩, ?_, rfl, ?_⟩
  · change ⟨mode188, ⟨9, -13⟩⟩ ∈ candidateAncestors
    rw [candidateAncestors_eq_expected]
    simp [candidateAncestorsExpected]
  · simp [child188, childShift, SymbolicShift.eval]
    linarith [alpha_lower_bound]

theorem allThreeSourceChildrenHaveDeletionWitness :
    HasDeletionWitness child26 /\
      HasDeletionWitness child107 /\
        HasDeletionWitness child188 :=
  ⟨child26_hasDeletionWitness, child107_hasDeletionWitness,
    child188_hasDeletionWitness⟩

end GeneralKTripleWitnessAudit
end KL2003
end CollatzClassical
