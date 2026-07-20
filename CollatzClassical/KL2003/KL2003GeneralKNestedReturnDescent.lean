import CollatzClassical.KL2003.KL2003AlphaIrrational
import Mathlib.Data.Set.Finite.Lemmas
import Mathlib.Data.Set.Finite.List

namespace CollatzClassical
namespace KL2003

/-!
Finite extraction layer for the context-preserving nested-return descent.

The module proves local finiteness of context-admissible source walks by
strong induction on their finite source support.  A walk is decomposed into a
list of nested first returns plus a terminal remainder; no loop is erased.
The resulting finite near-zero set supplies one positive epsilon which bounds
every nonempty admissible closed return away from zero.

The remaining termination work is external to this module: a nonterminating
EL scheduler must be converted into an infinite context-admissible source
walk whose recurrent-mode shifts realize these closed-return weights.
-/

namespace GeneralKNestedReturnDescent

open GeneralKSourceGraph

/-- A source action packed with its source mode. -/
abbrev PackedSourceAction (p : Nat) :=
  Sigma (fun mode : TrackedMode (p + 1) => SourceAction mode)

/-- Homogeneous serialization of a typed source walk. -/
def sourceWalkActionList {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)} :
    SourceWalk hp source target -> List (PackedSourceAction p)
  | .nil _ => []
  | .cons action tail => ⟨_, action⟩ :: sourceWalkActionList tail

@[simp] theorem sourceWalkActionList_nil {p : Nat} {hp : 1 <= p}
    (mode : TrackedMode (p + 1)) :
    sourceWalkActionList (SourceWalk.nil mode : SourceWalk hp mode mode) =
      [] := rfl

@[simp] theorem sourceWalkActionList_cons {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)} (action : SourceAction source)
    (tail : SourceWalk hp (action.target hp) target) :
    sourceWalkActionList (SourceWalk.cons action tail) =
      ⟨source, action⟩ :: sourceWalkActionList tail := rfl

theorem sourceWalkActionList_injective {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)} :
    Function.Injective
      (sourceWalkActionList :
        SourceWalk hp source target -> List (PackedSourceAction p)) := by
  intro first
  induction first with
  | nil =>
      intro second hcode
      cases second with
      | nil => rfl
      | cons action tail => simp at hcode
  | cons action tail ih =>
      intro second hcode
      cases second with
      | nil => simp at hcode
      | cons action' tail' =>
          simp only [sourceWalkActionList_cons, List.cons.injEq] at hcode
          have haction : action = action' := by
            exact eq_of_heq (Sigma.mk.inj_iff.mp hcode.1).2
          subst action'
          have htail : tail = tail' := ih hcode.2
          subst tail'
          rfl

theorem sourceWalkActionList_length {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    (sourceWalkActionList walk).length = walk.length := by
  induction walk with
  | nil => rfl
  | cons action tail ih => simp [ih, SourceWalk.length]

theorem finite_sourceWalk_length_le {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)} (bound : Nat) :
    {walk : SourceWalk hp source target | walk.length <= bound}.Finite := by
  apply Set.Finite.of_finite_image (f := sourceWalkActionList)
  · apply (List.finite_length_le (PackedSourceAction p) bound).subset
    rintro code ⟨walk, hlength, rfl⟩
    change walk.length <= bound at hlength
    change (sourceWalkActionList walk).length <= bound
    simpa only [sourceWalkActionList_length] using hlength
  · exact sourceWalkActionList_injective.injOn

instance finite_bounded_sourceWalk {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)} (bound : Nat) :
    Finite {walk : SourceWalk hp source target // walk.length <= bound} :=
  (finite_sourceWalk_length_le bound).to_subtype

/-- All typed source walks of length at most `bound`, with packed endpoints. -/
abbrev BoundedPackedSourceWalk {p : Nat} (hp : 1 <= p) (bound : Nat) :=
  Sigma fun source : TrackedMode (p + 1) =>
    Sigma fun target : TrackedMode (p + 1) =>
      {walk : SourceWalk hp source target // walk.length <= bound}

instance finite_boundedPackedSourceWalk {p : Nat} (hp : 1 <= p)
    (bound : Nat) : Finite (BoundedPackedSourceWalk hp bound) := by
  unfold BoundedPackedSourceWalk
  infer_instance

@[simp] theorem sourceWalk_append_nil {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    walk.append (SourceWalk.nil target) = walk := by
  induction walk with
  | nil => rfl
  | cons action tail ih =>
      simp only [SourceWalk.append]
      rw [ih]

theorem sourceWalk_append_assoc {p : Nat} {hp : 1 <= p}
    {firstMode secondMode thirdMode fourthMode : TrackedMode (p + 1)}
    (first : SourceWalk hp firstMode secondMode)
    (second : SourceWalk hp secondMode thirdMode)
    (third : SourceWalk hp thirdMode fourthMode) :
    (first.append second).append third =
      first.append (second.append third) := by
  induction first with
  | nil => rfl
  | cons action tail ih =>
      simp only [SourceWalk.append]
      rw [ih]

/-- Source mode followed by every successive target mode of a typed walk. -/
def sourceWalkVertexTrace {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)} :
    SourceWalk hp source target -> List (TrackedMode (p + 1))
  | .nil mode => [mode]
  | .cons _ tail => source :: sourceWalkVertexTrace tail

@[simp] theorem sourceWalkVertexTrace_nil {p : Nat} {hp : 1 <= p}
    (mode : TrackedMode (p + 1)) :
    sourceWalkVertexTrace (SourceWalk.nil mode : SourceWalk hp mode mode) =
      [mode] := rfl

@[simp] theorem sourceWalkVertexTrace_cons {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)} (action : SourceAction source)
    (tail : SourceWalk hp (action.target hp) target) :
    sourceWalkVertexTrace (SourceWalk.cons action tail) =
      source :: sourceWalkVertexTrace tail := rfl

theorem sourceWalkVertexTrace_length {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    (sourceWalkVertexTrace walk).length = walk.length + 1 := by
  induction walk with
  | nil => rfl
  | cons action tail ih => simp [ih, SourceWalk.length]

theorem source_mem_sourceWalkVertexTrace {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    source ∈ sourceWalkVertexTrace walk := by
  cases walk <;> simp

theorem target_mem_sourceWalkVertexTrace {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    target ∈ sourceWalkVertexTrace walk := by
  induction walk with
  | nil => simp
  | cons action tail ih => simp [ih]

theorem sourceWalkVertexTrace_ne_nil {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    sourceWalkVertexTrace walk ≠ [] := by
  intro hempty
  have hlength := congrArg List.length hempty
  rw [sourceWalkVertexTrace_length] at hlength
  simp at hlength

theorem sourceWalkVertexTrace_append {p : Nat} {hp : 1 <= p}
    {source middle target : TrackedMode (p + 1)}
    (first : SourceWalk hp source middle)
    (second : SourceWalk hp middle target) :
    sourceWalkVertexTrace (first.append second) =
      (sourceWalkVertexTrace first).dropLast ++
        sourceWalkVertexTrace second := by
  induction first with
  | nil => simp
  | cons action tail ih =>
      rw [SourceWalk.append, sourceWalkVertexTrace_cons,
        sourceWalkVertexTrace_cons,
        List.dropLast_cons_of_ne_nil (sourceWalkVertexTrace_ne_nil tail), ih]
      rfl

/-- The endpoint is the first occurrence of `pivot` on the walk. -/
def EndsAtFirstVisit {p : Nat} {hp : 1 <= p}
    (pivot : TrackedMode (p + 1))
    {source : TrackedMode (p + 1)}
    (walk : SourceWalk hp source pivot) : Prop :=
  pivot ∉ (sourceWalkVertexTrace walk).dropLast

theorem endsAtFirstVisit_nil {p : Nat} {hp : 1 <= p}
    (pivot : TrackedMode (p + 1)) :
    EndsAtFirstVisit pivot (SourceWalk.nil pivot : SourceWalk hp pivot pivot) := by
  simp [EndsAtFirstVisit]

theorem EndsAtFirstVisit.cons {p : Nat} {hp : 1 <= p}
    {source pivot : TrackedMode (p + 1)}
    (action : SourceAction source)
    (tail : SourceWalk hp (action.target hp) pivot)
    (hsource : source ≠ pivot) (hfirst : EndsAtFirstVisit pivot tail) :
    EndsAtFirstVisit pivot (SourceWalk.cons action tail) := by
  rw [EndsAtFirstVisit, sourceWalkVertexTrace_cons,
    List.dropLast_cons_of_ne_nil (sourceWalkVertexTrace_ne_nil tail)]
  simp only [List.mem_cons, not_or]
  constructor
  · exact fun h => hsource h.symm
  · exact hfirst

/-- Every mode visited by a source walk belongs to `support`. -/
def Supported {p : Nat} {hp : 1 <= p}
    (support : Finset (TrackedMode (p + 1)))
    {source target : TrackedMode (p + 1)} :
    SourceWalk hp source target -> Prop
  | .nil mode => mode ∈ support
  | .cons _ tail => source ∈ support /\ Supported support tail

/-- Every source of an edge in the walk belongs to `support`.

Unlike `Supported`, this deliberately excludes the final target.  That is the
right induction invariant for the tail of a first return: its final target is
the pivot, while every source before that target avoids the pivot. -/
def SourceSupported {p : Nat} {hp : 1 <= p}
    (support : Finset (TrackedMode (p + 1)))
    {source target : TrackedMode (p + 1)} :
    SourceWalk hp source target -> Prop
  | .nil _ => True
  | .cons _ tail => source ∈ support /\ SourceSupported support tail

@[simp] theorem sourceSupported_nil {p : Nat} {hp : 1 <= p}
    (support : Finset (TrackedMode (p + 1)))
    (mode : TrackedMode (p + 1)) :
    SourceSupported support (SourceWalk.nil mode : SourceWalk hp mode mode) :=
  trivial

@[simp] theorem sourceSupported_cons {p : Nat} {hp : 1 <= p}
    (support : Finset (TrackedMode (p + 1)))
    {source target : TrackedMode (p + 1)} (action : SourceAction source)
    (tail : SourceWalk hp (action.target hp) target) :
    SourceSupported support (SourceWalk.cons action tail) <->
      source ∈ support /\ SourceSupported support tail :=
  Iff.rfl

theorem Supported.sourceSupported {p : Nat} {hp : 1 <= p}
    {support : Finset (TrackedMode (p + 1))}
    {source target : TrackedMode (p + 1)}
    {walk : SourceWalk hp source target} (hsupported : Supported support walk) :
    SourceSupported support walk := by
  induction walk with
  | nil => trivial
  | cons action tail ih =>
      exact ⟨hsupported.1, ih hsupported.2⟩

theorem sourceSupported_univ {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    SourceSupported Finset.univ walk := by
  induction walk with
  | nil => trivial
  | cons action tail ih => exact ⟨Finset.mem_univ _, ih⟩

theorem sourceSupported_iff_forall_mem_dropLast_vertexTrace
    {p : Nat} {hp : 1 <= p}
    (support : Finset (TrackedMode (p + 1)))
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    SourceSupported support walk <->
      forall mode, mode ∈ (sourceWalkVertexTrace walk).dropLast ->
        mode ∈ support := by
  induction walk with
  | nil => simp [SourceSupported]
  | cons action tail ih =>
      rw [sourceWalkVertexTrace_cons,
        List.dropLast_cons_of_ne_nil (sourceWalkVertexTrace_ne_nil tail)]
      simp [SourceSupported, ih]

theorem supported_iff_forall_mem_vertexTrace {p : Nat} {hp : 1 <= p}
    (support : Finset (TrackedMode (p + 1)))
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    Supported support walk <->
      forall mode, mode ∈ sourceWalkVertexTrace walk -> mode ∈ support := by
  induction walk with
  | nil => simp [Supported]
  | cons action tail ih => simp [Supported, ih]

theorem Supported.source_mem {p : Nat} {hp : 1 <= p}
    {support : Finset (TrackedMode (p + 1))}
    {source target : TrackedMode (p + 1)}
    {walk : SourceWalk hp source target} (hsupported : Supported support walk) :
    source ∈ support := by
  cases walk with
  | nil => exact hsupported
  | cons action tail => exact hsupported.1

theorem Supported.target_mem {p : Nat} {hp : 1 <= p}
    {support : Finset (TrackedMode (p + 1))}
    {source target : TrackedMode (p + 1)}
    {walk : SourceWalk hp source target} (hsupported : Supported support walk) :
    target ∈ support := by
  induction walk with
  | nil => exact hsupported
  | cons action tail ih => exact ih hsupported.2

theorem SourceSupported.supported_of_target_mem {p : Nat} {hp : 1 <= p}
    {support : Finset (TrackedMode (p + 1))}
    {source target : TrackedMode (p + 1)}
    {walk : SourceWalk hp source target}
    (hsourceSupported : SourceSupported support walk)
    (htarget : target ∈ support) : Supported support walk := by
  induction walk with
  | nil => exact htarget
  | cons action tail ih =>
      exact ⟨hsourceSupported.1, ih hsourceSupported.2 htarget⟩

theorem exists_sourceWalk_factorization_at_of_mem_vertexTrace
    {p : Nat} {hp : 1 <= p}
    {source target pivot : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target)
    (hmem : pivot ∈ sourceWalkVertexTrace walk) :
    exists initial : SourceWalk hp source pivot,
      exists suffix : SourceWalk hp pivot target,
        walk = initial.append suffix := by
  induction walk with
  | nil mode =>
      simp only [sourceWalkVertexTrace_nil, List.mem_singleton] at hmem
      subst pivot
      exact ⟨SourceWalk.nil mode, SourceWalk.nil mode, rfl⟩
  | @cons source target action tail ih =>
      simp only [sourceWalkVertexTrace_cons, List.mem_cons] at hmem
      rcases hmem with hsource | htail
      · subst pivot
        exact ⟨SourceWalk.nil source, SourceWalk.cons action tail, rfl⟩
      · obtain ⟨initial, suffix, hfactor⟩ := ih htail
        refine ⟨SourceWalk.cons action initial, suffix, ?_⟩
        simp only [SourceWalk.append]
        rw [hfactor]

theorem exists_sourceWalk_factorization_at_of_mem_dropLast_vertexTrace
    {p : Nat} {hp : 1 <= p}
    {source target pivot : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target)
    (hmem : pivot ∈ (sourceWalkVertexTrace walk).dropLast) :
    exists initial : SourceWalk hp source pivot,
      exists suffix : SourceWalk hp pivot target,
        walk = initial.append suffix /\ 0 < suffix.length := by
  induction walk with
  | nil => simp at hmem
  | @cons source target action tail ih =>
      rw [sourceWalkVertexTrace_cons,
        List.dropLast_cons_of_ne_nil (sourceWalkVertexTrace_ne_nil tail)] at hmem
      simp only [List.mem_cons] at hmem
      rcases hmem with hsource | htail
      · subst pivot
        exact ⟨SourceWalk.nil source, SourceWalk.cons action tail, rfl, by simp⟩
      · obtain ⟨initial, suffix, hfactor, hsuffix⟩ := ih htail
        refine ⟨SourceWalk.cons action initial, suffix, ?_, hsuffix⟩
        simp only [SourceWalk.append]
        rw [hfactor]

theorem exists_first_sourceWalk_factorization_at_of_mem_vertexTrace
    {p : Nat} {hp : 1 <= p}
    {source target pivot : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target)
    (hmem : pivot ∈ sourceWalkVertexTrace walk) :
    exists initial : SourceWalk hp source pivot,
      exists suffix : SourceWalk hp pivot target,
        walk = initial.append suffix /\ EndsAtFirstVisit pivot initial := by
  induction walk with
  | nil mode =>
      simp only [sourceWalkVertexTrace_nil, List.mem_singleton] at hmem
      subst pivot
      exact ⟨SourceWalk.nil mode, SourceWalk.nil mode, rfl,
        endsAtFirstVisit_nil mode⟩
  | @cons source target action tail ih =>
      by_cases hsource : source = pivot
      · subst pivot
        exact ⟨SourceWalk.nil source, SourceWalk.cons action tail, rfl,
          endsAtFirstVisit_nil source⟩
      · have htail : pivot ∈ sourceWalkVertexTrace tail := by
          have hpivot : pivot ≠ source := Ne.symm hsource
          simpa only [sourceWalkVertexTrace_cons, List.mem_cons,
            hpivot, false_or] using hmem
        obtain ⟨initial, suffix, hfactor, hfirst⟩ := ih htail
        refine ⟨SourceWalk.cons action initial, suffix, ?_, ?_⟩
        · simp only [SourceWalk.append]
          rw [hfactor]
        · exact hfirst.cons action initial hsource

theorem mem_sourceWalkVertexTrace_of_factorization
    {p : Nat} {hp : 1 <= p}
    {source target pivot : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target)
    (initial : SourceWalk hp source pivot)
    (suffix : SourceWalk hp pivot target)
    (hfactor : walk = initial.append suffix) :
    pivot ∈ sourceWalkVertexTrace walk := by
  subst walk
  induction initial with
  | nil => exact source_mem_sourceWalkVertexTrace suffix
  | cons action tail ih =>
      simp only [SourceWalk.append, sourceWalkVertexTrace_cons, List.mem_cons]
      exact Or.inr (ih suffix)

theorem pivot_mem_dropLast_vertexTrace_of_factorization_of_suffix_length_pos
    {p : Nat} {hp : 1 <= p}
    {source target pivot : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target)
    (initial : SourceWalk hp source pivot)
    (suffix : SourceWalk hp pivot target)
    (hfactor : walk = initial.append suffix)
    (hsuffix : 0 < suffix.length) :
    pivot ∈ (sourceWalkVertexTrace walk).dropLast := by
  subst walk
  cases suffix with
  | nil => simp at hsuffix
  | cons action tail =>
      rw [sourceWalkVertexTrace_append, sourceWalkVertexTrace_cons,
        List.dropLast_append_cons,
        List.dropLast_cons_of_ne_nil (sourceWalkVertexTrace_ne_nil tail)]
      simp

/-- The pivot occurs strictly between the endpoints of the walk. -/
def HasInternalVisit {p : Nat} {hp : 1 <= p}
    (pivot : TrackedMode (p + 1))
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) : Prop :=
  exists initial : SourceWalk hp source pivot,
    exists suffix : SourceWalk hp pivot target,
      walk = initial.append suffix /\
        0 < initial.length /\ 0 < suffix.length

/-- A nonempty closed walk with no internal visit to its base mode. -/
def IsFirstReturn {p : Nat} {hp : 1 <= p}
    {mode : TrackedMode (p + 1)} (walk : SourceWalk hp mode mode) : Prop :=
  0 < walk.length /\ Not (HasInternalVisit mode walk)

/-- The first action and remaining tail of a nonempty closed source walk. -/
abbrev PackedFirstStepTail {p : Nat} (hp : 1 <= p)
    (source target : TrackedMode (p + 1)) :=
  Sigma fun action : SourceAction source =>
    SourceWalk hp (action.target hp) target

/-- Injective optional encoding which also handles the empty closed walk. -/
def firstStepTailCode {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)} :
    SourceWalk hp source target ->
      Option (PackedFirstStepTail hp source target)
  | .nil _ => none
  | .cons action tail => some ⟨action, tail⟩

theorem firstStepTailCode_injective {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)} :
    Function.Injective
      (firstStepTailCode :
        SourceWalk hp source target ->
          Option (PackedFirstStepTail hp source target)) := by
  intro first
  cases first with
  | nil =>
      intro second hcode
      cases second with
      | nil => rfl
      | cons action tail => simp [firstStepTailCode] at hcode
  | cons action tail =>
      intro second hcode
      cases second with
      | nil => simp [firstStepTailCode] at hcode
      | cons action' tail' =>
          simp only [firstStepTailCode, Option.some.injEq] at hcode
          have haction : action = action' := by
            exact congrArg Sigma.fst hcode
          subst action'
          have htail : tail = tail' := by
            exact eq_of_heq (Sigma.mk.inj_iff.mp hcode).2
          subst tail'
          rfl

theorem EndsAtFirstVisit.not_hasInternalVisit
    {p : Nat} {hp : 1 <= p}
    {source pivot : TrackedMode (p + 1)}
    {walk : SourceWalk hp source pivot}
    (hfirst : EndsAtFirstVisit pivot walk) :
    Not (HasInternalVisit pivot walk) := by
  rintro ⟨initial, suffix, hfactor, hinitial, hsuffix⟩
  exact hfirst
    (pivot_mem_dropLast_vertexTrace_of_factorization_of_suffix_length_pos
      walk initial suffix hfactor hsuffix)

theorem isFirstReturn_cons_of_tail_endsAtFirstVisit
    {p : Nat} {hp : 1 <= p}
    {mode : TrackedMode (p + 1)}
    (action : SourceAction mode)
    (initial : SourceWalk hp (action.target hp) mode)
    (hfirst : EndsAtFirstVisit mode initial) :
    IsFirstReturn (SourceWalk.cons action initial) := by
  constructor
  · simp [SourceWalk.length]
  · rintro ⟨before, suffix, hfactor, hbefore, hsuffix⟩
    cases before with
    | nil => simp at hbefore
    | cons action' beforeTail =>
        simp only [SourceWalk.append] at hfactor
        have hinj := SourceWalk.cons.inj hfactor
        have haction : action = action' := hinj.1
        subst action'
        have htail : initial = beforeTail.append suffix := eq_of_heq hinj.2
        exact hfirst
          (pivot_mem_dropLast_vertexTrace_of_factorization_of_suffix_length_pos
            initial beforeTail suffix htail hsuffix)

theorem IsFirstReturn.tail_endsAtFirstVisit
    {p : Nat} {hp : 1 <= p}
    {mode : TrackedMode (p + 1)}
    (action : SourceAction mode)
    (tail : SourceWalk hp (action.target hp) mode)
    (hfirst : IsFirstReturn (SourceWalk.cons action tail)) :
    EndsAtFirstVisit mode tail := by
  rw [EndsAtFirstVisit]
  intro hmem
  obtain ⟨initial, suffix, hfactor, hsuffix⟩ :=
    exists_sourceWalk_factorization_at_of_mem_dropLast_vertexTrace tail hmem
  apply hfirst.2
  refine ⟨SourceWalk.cons action initial, suffix, ?_, ?_, hsuffix⟩
  · simp only [SourceWalk.append]
    rw [hfactor]
  · simp

theorem EndsAtFirstVisit.sourceSupported_erase_of_supported
    {p : Nat} {hp : 1 <= p}
    {support : Finset (TrackedMode (p + 1))}
    {source pivot : TrackedMode (p + 1)}
    {walk : SourceWalk hp source pivot}
    (hfirst : EndsAtFirstVisit pivot walk)
    (hsupported : Supported support walk) :
    SourceSupported (support.erase pivot) walk := by
  rw [sourceSupported_iff_forall_mem_dropLast_vertexTrace]
  intro mode hmode
  apply Finset.mem_erase.mpr
  constructor
  · exact fun h => hfirst (h ▸ hmode)
  · rw [supported_iff_forall_mem_vertexTrace] at hsupported
    exact hsupported mode (List.mem_of_mem_dropLast hmode)

theorem exists_firstReturn_split_of_length_pos
    {p : Nat} {hp : 1 <= p}
    {mode : TrackedMode (p + 1)}
    (walk : SourceWalk hp mode mode) (hlength : 0 < walk.length) :
    exists firstReturn remainder : SourceWalk hp mode mode,
      walk = firstReturn.append remainder /\ IsFirstReturn firstReturn := by
  cases walk with
  | nil => simp at hlength
  | cons action tail =>
      have hmode : mode ∈ sourceWalkVertexTrace tail :=
        target_mem_sourceWalkVertexTrace tail
      obtain ⟨initial, remainder, hfactor, hfirst⟩ :=
        exists_first_sourceWalk_factorization_at_of_mem_vertexTrace tail hmode
      refine ⟨SourceWalk.cons action initial, remainder, ?_, ?_⟩
      · simp only [SourceWalk.append]
        rw [hfactor]
      · exact isFirstReturn_cons_of_tail_endsAtFirstVisit action initial hfirst

/-- Append a list of closed walks based at the same mode. -/
def appendClosedWalks {p : Nat} {hp : 1 <= p}
    (mode : TrackedMode (p + 1)) :
    List (SourceWalk hp mode mode) -> SourceWalk hp mode mode
  | [] => SourceWalk.nil mode
  | firstReturn :: returns => firstReturn.append (appendClosedWalks mode returns)

/-- A residual walk which never returns to its source after leaving it. -/
def IsTerminalRemainder {p : Nat} {hp : 1 <= p}
    {mode target : TrackedMode (p + 1)} :
    SourceWalk hp mode target -> Prop
  | .nil _ => True
  | .cons _ tail => mode ∉ sourceWalkVertexTrace tail

@[simp] theorem appendClosedWalks_nil {p : Nat} {hp : 1 <= p}
    (mode : TrackedMode (p + 1)) :
    appendClosedWalks (hp := hp) mode [] = SourceWalk.nil mode := rfl

@[simp] theorem appendClosedWalks_cons {p : Nat} {hp : 1 <= p}
    (mode : TrackedMode (p + 1)) (firstReturn : SourceWalk hp mode mode)
    (returns : List (SourceWalk hp mode mode)) :
    appendClosedWalks mode (firstReturn :: returns) =
      firstReturn.append (appendClosedWalks mode returns) := rfl

theorem appendClosedWalks_length {p : Nat} {hp : 1 <= p}
    (mode : TrackedMode (p + 1))
    (returns : List (SourceWalk hp mode mode)) :
    (appendClosedWalks mode returns).length =
      (returns.map SourceWalk.length).sum := by
  induction returns with
  | nil => rfl
  | cons firstReturn returns ih =>
      rw [appendClosedWalks_cons, SourceWalk.length_append, ih]
      simp

theorem appendClosedWalks_weight_eval {p : Nat} {hp : 1 <= p}
    (mode : TrackedMode (p + 1))
    (returns : List (SourceWalk hp mode mode)) :
    (appendClosedWalks mode returns).weight.eval =
      (returns.map (fun walk => walk.weight.eval)).sum := by
  induction returns with
  | nil => exact SymbolicShift.eval_zero
  | cons firstReturn returns ih =>
      rw [appendClosedWalks_cons, SourceWalk.weight_append,
        SymbolicShift.eval_add, ih]
      simp

theorem exists_firstReturnList_terminal_decomposition
    {p : Nat} {hp : 1 <= p}
    {mode target : TrackedMode (p + 1)}
    (walk : SourceWalk hp mode target) :
    exists returns : List (SourceWalk hp mode mode),
      exists terminal : SourceWalk hp mode target,
        walk = (appendClosedWalks mode returns).append terminal /\
          (forall firstReturn, firstReturn ∈ returns ->
            IsFirstReturn firstReturn) /\
          IsTerminalRemainder terminal := by
  generalize hlength : walk.length = length
  induction length using Nat.strong_induction_on generalizing walk with
  | h length ih =>
      cases walk with
      | nil =>
          exact ⟨[], SourceWalk.nil mode, rfl, by simp,
            by simp [IsTerminalRemainder]⟩
      | cons action tail =>
          let current : SourceWalk hp mode target := SourceWalk.cons action tail
          by_cases hreturn : mode ∈ sourceWalkVertexTrace tail
          · obtain ⟨initial, suffix, hfactor, hfirstVisit⟩ :=
              exists_first_sourceWalk_factorization_at_of_mem_vertexTrace
                tail hreturn
            let firstReturn : SourceWalk hp mode mode :=
              SourceWalk.cons action initial
            have hfirst : IsFirstReturn firstReturn :=
              isFirstReturn_cons_of_tail_endsAtFirstVisit
                action initial hfirstVisit
            have hsuffix_lt : suffix.length < length := by
              have hsum := SourceWalk.length_append firstReturn suffix
              have hfirstPos : 0 < firstReturn.length := hfirst.1
              have hcurrentFactor : current = firstReturn.append suffix := by
                simp only [current, firstReturn, SourceWalk.append]
                rw [hfactor]
              rw [← hcurrentFactor, hlength] at hsum
              omega
            obtain ⟨returns, terminal, hterminalFactor,
              hreturnsFirst, hterminal⟩ :=
              ih suffix.length hsuffix_lt suffix rfl
            refine ⟨firstReturn :: returns, terminal, ?_, ?_, hterminal⟩
            · change current =
                (appendClosedWalks mode (firstReturn :: returns)).append terminal
              calc
                current = firstReturn.append suffix := by
                  simp only [current, firstReturn, SourceWalk.append]
                  rw [hfactor]
                _ = firstReturn.append
                    ((appendClosedWalks mode returns).append terminal) := by
                  rw [hterminalFactor]
                _ = (firstReturn.append (appendClosedWalks mode returns)).append
                    terminal := by
                  rw [sourceWalk_append_assoc]
                _ = (appendClosedWalks mode (firstReturn :: returns)).append
                    terminal := rfl
            · intro candidate hcandidate
              simp only [List.mem_cons] at hcandidate
              rcases hcandidate with rfl | hmember
              · exact hfirst
              · exact hreturnsFirst candidate hmember
          · exact ⟨[], current, by simp [current], by simp,
              by simpa [current, IsTerminalRemainder] using hreturn⟩

theorem IsTerminalRemainder.tail_sourceSupported_erase
    {p : Nat} {hp : 1 <= p}
    {support : Finset (TrackedMode (p + 1))}
    {mode target : TrackedMode (p + 1)}
    (action : SourceAction mode)
    (tail : SourceWalk hp (action.target hp) target)
    (hterminal :
      @IsTerminalRemainder p hp mode target (SourceWalk.cons action tail))
    (hsupported :
      SourceSupported support (SourceWalk.cons action tail)) :
    SourceSupported (support.erase mode) tail := by
  rw [sourceSupported_iff_forall_mem_dropLast_vertexTrace]
  intro vertex hvertex
  apply Finset.mem_erase.mpr
  constructor
  · intro heq
    have hmem : vertex ∈ sourceWalkVertexTrace tail :=
      List.mem_of_mem_dropLast hvertex
    have hmodeMem : mode ∈ sourceWalkVertexTrace tail := heq ▸ hmem
    exact hterminal hmodeMem
  · rw [sourceSupported_iff_forall_mem_dropLast_vertexTrace] at hsupported
    exact hsupported vertex (by
      rw [sourceWalkVertexTrace_cons,
        List.dropLast_cons_of_ne_nil (sourceWalkVertexTrace_ne_nil tail)]
      exact List.mem_cons_of_mem mode hvertex)

theorem exists_appendClosedWalks_factorization_of_mem
    {p : Nat} {hp : 1 <= p}
    {mode : TrackedMode (p + 1)}
    {candidate : SourceWalk hp mode mode}
    {returns : List (SourceWalk hp mode mode)}
    (hmember : candidate ∈ returns) :
    exists initial suffix : SourceWalk hp mode mode,
      appendClosedWalks mode returns =
        initial.append (candidate.append suffix) := by
  induction returns with
  | nil => simp at hmember
  | cons firstReturn returns ih =>
      simp only [List.mem_cons] at hmember
      rcases hmember with rfl | htail
      · exact ⟨SourceWalk.nil mode, appendClosedWalks mode returns, rfl⟩
      · obtain ⟨initial, suffix, hfactor⟩ := ih htail
        refine ⟨firstReturn.append initial, suffix, ?_⟩
        rw [appendClosedWalks_cons, hfactor, sourceWalk_append_assoc]

theorem exists_terminal_decomposition_factorization_of_return
    {p : Nat} {hp : 1 <= p}
    {mode target : TrackedMode (p + 1)}
    {walk : SourceWalk hp mode target}
    {candidate : SourceWalk hp mode mode}
    {returns : List (SourceWalk hp mode mode)}
    (terminal : SourceWalk hp mode target)
    (hdecomposition :
      walk = (appendClosedWalks mode returns).append terminal)
    (hmember : candidate ∈ returns) :
    exists initial : SourceWalk hp mode mode,
      exists suffix : SourceWalk hp mode target,
        walk = initial.append (candidate.append suffix) := by
  obtain ⟨initial, innerSuffix, hfactor⟩ :=
    exists_appendClosedWalks_factorization_of_mem hmember
  refine ⟨initial, innerSuffix.append terminal, ?_⟩
  calc
    walk = (appendClosedWalks mode returns).append terminal := hdecomposition
    _ = (initial.append (candidate.append innerSuffix)).append terminal := by
      rw [hfactor]
    _ = initial.append (candidate.append (innerSuffix.append terminal)) := by
      rw [sourceWalk_append_assoc, sourceWalk_append_assoc]

theorem terminal_decomposition_weight_eval
    {p : Nat} {hp : 1 <= p}
    {mode target : TrackedMode (p + 1)}
    {walk : SourceWalk hp mode target}
    {returns : List (SourceWalk hp mode mode)}
    {terminal : SourceWalk hp mode target}
    (hdecomposition :
      walk = (appendClosedWalks mode returns).append terminal) :
    walk.weight.eval =
      (returns.map (fun candidate => candidate.weight.eval)).sum +
        terminal.weight.eval := by
  rw [hdecomposition, SourceWalk.weight_append, SymbolicShift.eval_add,
    appendClosedWalks_weight_eval]

theorem list_sum_map_nonpos_of_forall_mem
    {alpha : Type*} (values : List alpha) (weight : alpha -> Real)
    (hweight : forall value, value ∈ values -> weight value <= 0) :
    (values.map weight).sum <= 0 := by
  induction values with
  | nil => simp
  | cons head tail ih =>
      simp only [List.map_cons, List.sum_cons]
      have hhead : weight head <= 0 := hweight head (by simp)
      have htail : (tail.map weight).sum <= 0 := by
        apply ih
        intro value hvalue
        exact hweight value (by simp [hvalue])
      linarith

theorem list_sum_map_le_member_of_forall_nonpos
    {alpha : Type*} (values : List alpha) (weight : alpha -> Real)
    {candidate : alpha} (hmember : candidate ∈ values)
    (hweight : forall value, value ∈ values -> weight value <= 0) :
    (values.map weight).sum <= weight candidate := by
  induction values with
  | nil => simp at hmember
  | cons head tail ih =>
      simp only [List.mem_cons] at hmember
      simp only [List.map_cons, List.sum_cons]
      rcases hmember with rfl | htailMember
      · have htail : (tail.map weight).sum <= 0 := by
          apply list_sum_map_nonpos_of_forall_mem
          intro value hvalue
          exact hweight value (by simp [hvalue])
        linarith
      · have hhead : weight head <= 0 := hweight head (by simp)
        have htail := ih htailMember (fun value hvalue =>
          hweight value (by simp [hvalue]))
        linarith

theorem list_sum_map_le_neg_mul_length
    {alpha : Type*} (values : List alpha) (weight : alpha -> Real)
    (epsilon : Real)
    (hweight : forall value, value ∈ values -> weight value <= -epsilon) :
    (values.map weight).sum <= -(values.length : Real) * epsilon := by
  induction values with
  | nil => simp
  | cons head tail ih =>
      simp only [List.map_cons, List.sum_cons, List.length_cons]
      have hhead : weight head <= -epsilon := hweight head (by simp)
      have htail := ih (fun value hvalue =>
        hweight value (by simp [hvalue]))
      push_cast
      linarith

theorem list_sum_map_nat_le_length_mul
    {alpha : Type*} (values : List alpha) (size : alpha -> Nat)
    (bound : Nat)
    (hsize : forall value, value ∈ values -> size value <= bound) :
    (values.map size).sum <= values.length * bound := by
  induction values with
  | nil => simp
  | cons head tail ih =>
      simp only [List.map_cons, List.sum_cons, List.length_cons]
      have hhead : size head <= bound := hsize head (by simp)
      have htail := ih (fun value hvalue =>
        hsize value (by simp [hvalue]))
      rw [Nat.add_mul]
      omega

theorem exists_nat_upper_bound_on_finite_set
    {alpha : Type*} (values : Set alpha) (hfinite : values.Finite)
    (size : alpha -> Nat) :
    exists bound : Nat, forall value, value ∈ values -> size value <= bound := by
  by_cases hvalues : values.Nonempty
  · obtain ⟨largest, hlargest, hmax⟩ :=
      Set.exists_max_image values size hfinite hvalues
    exact ⟨size largest, hmax⟩
  · exact ⟨0, fun value hvalue => False.elim (hvalues ⟨value, hvalue⟩)⟩

theorem exists_real_upper_bound_on_finite_set
    {alpha : Type*} (values : Set alpha) (hfinite : values.Finite)
    (weight : alpha -> Real) :
    exists upper : Real,
      forall value, value ∈ values -> weight value <= upper := by
  by_cases hvalues : values.Nonempty
  · obtain ⟨largest, hlargest, hmax⟩ :=
      Set.exists_max_image values weight hfinite hvalues
    exact ⟨weight largest, hmax⟩
  · exact ⟨0, fun value hvalue => False.elim (hvalues ⟨value, hvalue⟩)⟩

theorem exists_firstReturnList_decomposition
    {p : Nat} {hp : 1 <= p}
    {mode : TrackedMode (p + 1)} (walk : SourceWalk hp mode mode) :
    exists returns : List (SourceWalk hp mode mode),
      walk = appendClosedWalks mode returns /\
        forall firstReturn, firstReturn ∈ returns -> IsFirstReturn firstReturn := by
  generalize hlength : walk.length = length
  induction length using Nat.strong_induction_on generalizing walk with
  | h length ih =>
      cases walk with
      | nil =>
          exact ⟨[], rfl, by simp⟩
      | cons action tail =>
          let current : SourceWalk hp mode mode := SourceWalk.cons action tail
          have hcurrentPos : 0 < current.length := by
            simp [current, SourceWalk.length]
          obtain ⟨firstReturn, remainder, hsplit, hfirst⟩ :=
            exists_firstReturn_split_of_length_pos current hcurrentPos
          have hremainder_lt : remainder.length < length := by
            have hsum := SourceWalk.length_append firstReturn remainder
            have hfirstPos : 0 < firstReturn.length := hfirst.1
            rw [← hsplit, hlength] at hsum
            omega
          obtain ⟨returns, hreturns, hall⟩ :=
            ih remainder.length hremainder_lt remainder rfl
          refine ⟨firstReturn :: returns, ?_, ?_⟩
          · change current = appendClosedWalks mode (firstReturn :: returns)
            calc
              current = firstReturn.append remainder := hsplit
              _ = firstReturn.append (appendClosedWalks mode returns) := by
                rw [hreturns]
              _ = appendClosedWalks mode (firstReturn :: returns) := rfl
          · intro candidate hcandidate
            simp only [List.mem_cons] at hcandidate
            rcases hcandidate with rfl | hmember
            · exact hfirst
            · exact hall candidate hmember

theorem supported_append_iff {p : Nat} {hp : 1 <= p}
    (support : Finset (TrackedMode (p + 1)))
    {source middle target : TrackedMode (p + 1)}
    (first : SourceWalk hp source middle)
    (second : SourceWalk hp middle target) :
    Supported support (first.append second) <->
      Supported support first /\ Supported support second := by
  induction first with
  | nil =>
      constructor
      · intro hsupported
        exact ⟨hsupported.source_mem, hsupported⟩
      · exact fun hsupported => hsupported.2
  | cons action tail ih =>
      simp only [SourceWalk.append, Supported]
      rw [ih]
      tauto

theorem sourceSupported_append_iff {p : Nat} {hp : 1 <= p}
    (support : Finset (TrackedMode (p + 1)))
    {source middle target : TrackedMode (p + 1)}
    (first : SourceWalk hp source middle)
    (second : SourceWalk hp middle target) :
    SourceSupported support (first.append second) <->
      SourceSupported support first /\ SourceSupported support second := by
  induction first with
  | nil => simp
  | cons action tail ih =>
      simp only [SourceWalk.append, SourceSupported]
      rw [ih]
      tauto

theorem Supported.factor {p : Nat} {hp : 1 <= p}
    {support : Finset (TrackedMode (p + 1))}
    {source factorSource factorTarget target : TrackedMode (p + 1)}
    {walk : SourceWalk hp source target}
    (hsupported : Supported support walk)
    (initial : SourceWalk hp source factorSource)
    (factorWalk : SourceWalk hp factorSource factorTarget)
    (suffix : SourceWalk hp factorTarget target)
    (hfactor : walk = initial.append (factorWalk.append suffix)) :
    Supported support factorWalk := by
  rw [hfactor, supported_append_iff, supported_append_iff] at hsupported
  exact hsupported.2.1

theorem SourceSupported.factor {p : Nat} {hp : 1 <= p}
    {support : Finset (TrackedMode (p + 1))}
    {source factorSource factorTarget target : TrackedMode (p + 1)}
    {walk : SourceWalk hp source target}
    (hsupported : SourceSupported support walk)
    (initial : SourceWalk hp source factorSource)
    (factorWalk : SourceWalk hp factorSource factorTarget)
    (suffix : SourceWalk hp factorTarget target)
    (hfactor : walk = initial.append (factorWalk.append suffix)) :
    SourceSupported support factorWalk := by
  rw [hfactor, sourceSupported_append_iff,
    sourceSupported_append_iff] at hsupported
  exact hsupported.2.1

/-- Every nonempty closed factor of the walk has strictly negative weight. -/
def ContextAdmissible {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) : Prop :=
  forall {mode : TrackedMode (p + 1)}
    (initial : SourceWalk hp source mode)
    (loop : SourceWalk hp mode mode)
    (suffix : SourceWalk hp mode target),
      walk = initial.append (loop.append suffix) ->
      0 < loop.length -> loop.weight.eval < 0

theorem ContextAdmissible.closed_weight_neg {p : Nat} {hp : 1 <= p}
    {mode : TrackedMode (p + 1)} (walk : SourceWalk hp mode mode)
    (hadmissible : ContextAdmissible walk) (hlength : 0 < walk.length) :
    walk.weight.eval < 0 := by
  apply hadmissible (SourceWalk.nil mode) walk (SourceWalk.nil mode)
  · simp
  · exact hlength

theorem IsFirstReturn.weight_neg_of_contextAdmissible
    {p : Nat} {hp : 1 <= p}
    {mode : TrackedMode (p + 1)} {walk : SourceWalk hp mode mode}
    (hfirst : IsFirstReturn walk) (hadmissible : ContextAdmissible walk) :
    walk.weight.eval < 0 :=
  hadmissible.closed_weight_neg walk hfirst.1

theorem ContextAdmissible.factor {p : Nat} {hp : 1 <= p}
    {source factorSource factorTarget target : TrackedMode (p + 1)}
    {walk : SourceWalk hp source target}
    (hadmissible : ContextAdmissible walk)
    (initial : SourceWalk hp source factorSource)
    (factorWalk : SourceWalk hp factorSource factorTarget)
    (suffix : SourceWalk hp factorTarget target)
    (hfactor : walk = initial.append (factorWalk.append suffix)) :
    ContextAdmissible factorWalk := by
  intro mode before loop after hloop hlength
  apply hadmissible (initial.append before) loop (after.append suffix)
  · rw [hfactor, hloop]
    simp only [sourceWalk_append_assoc]
  · exact hlength

theorem ContextAdmissible.tail_of_cons {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    {action : SourceAction source}
    {tail : SourceWalk hp (action.target hp) target}
    (hadmissible : ContextAdmissible (SourceWalk.cons action tail)) :
    ContextAdmissible tail := by
  apply hadmissible.factor
    (SourceWalk.cons action (SourceWalk.nil (action.target hp)))
    tail (SourceWalk.nil target)
  simp

/-- Local finiteness above every lower weight bound, with only edge sources
restricted to the supplied finite support. Endpoints remain explicit. -/
def LocallyFiniteAdmissibleSourceWalks {p : Nat} (hp : 1 <= p)
    (support : Finset (TrackedMode (p + 1))) : Prop :=
  forall (source target : TrackedMode (p + 1)) (lower : Real),
    {walk : SourceWalk hp source target |
      SourceSupported support walk /\ ContextAdmissible walk /\
        lower <= walk.weight.eval}.Finite

theorem finite_firstReturns_above_of_finite_sourceSupported_tails
    {p : Nat} {hp : 1 <= p}
    (support : Finset (TrackedMode (p + 1)))
    (mode : TrackedMode (p + 1)) (lower : Real)
    (htails : forall action : SourceAction mode,
      {tail : SourceWalk hp (action.target hp) mode |
        SourceSupported (support.erase mode) tail /\
          ContextAdmissible tail /\
          lower - action.weight.eval <= tail.weight.eval}.Finite) :
    {walk : SourceWalk hp mode mode |
      IsFirstReturn walk /\ Supported support walk /\
        ContextAdmissible walk /\ lower <= walk.weight.eval}.Finite := by
  let TailCandidate := fun action : SourceAction mode =>
    {tail : SourceWalk hp (action.target hp) mode //
      SourceSupported (support.erase mode) tail /\
        ContextAdmissible tail /\
        lower - action.weight.eval <= tail.weight.eval}
  let Candidate := Sigma TailCandidate
  let encodeCandidate : Candidate ->
      Option (PackedFirstStepTail hp mode mode) :=
    fun candidate => some ⟨candidate.1, candidate.2.1⟩
  haveI finiteTailCandidate (action : SourceAction mode) :
      Finite (TailCandidate action) := by
    exact (htails action).to_subtype
  haveI : Finite Candidate := by
    unfold Candidate
    infer_instance
  apply Set.Finite.of_finite_image (f := firstStepTailCode)
  · apply (Set.finite_range encodeCandidate).subset
    intro code hcode
    rcases hcode with ⟨walk, hwalk, rfl⟩
    rcases hwalk with ⟨hfirst, hsupported, hadmissible, hlower⟩
    cases walk with
    | nil => simp [IsFirstReturn] at hfirst
    | cons action tail =>
        have htailFirst : EndsAtFirstVisit mode tail :=
          hfirst.tail_endsAtFirstVisit action tail
        have htailSourceSupported :
            SourceSupported (support.erase mode) tail :=
          htailFirst.sourceSupported_erase_of_supported hsupported.2
        have htailAdmissible : ContextAdmissible tail :=
          hadmissible.tail_of_cons
        have hweight :=
          SourceWalk.weight_eval (SourceWalk.cons action tail)
        have htailLower :
            lower - action.weight.eval <= tail.weight.eval := by
          rw [hweight] at hlower
          linarith
        refine ⟨⟨action, ⟨tail, htailSourceSupported,
          htailAdmissible, htailLower⟩⟩, rfl⟩
  · exact firstStepTailCode_injective.injOn

theorem finite_firstReturns_above_of_localFiniteness_on_erased_support
    {p : Nat} {hp : 1 <= p}
    (support : Finset (TrackedMode (p + 1)))
    (mode : TrackedMode (p + 1)) (lower : Real)
    (hlocal : LocallyFiniteAdmissibleSourceWalks hp (support.erase mode)) :
    {walk : SourceWalk hp mode mode |
      IsFirstReturn walk /\ Supported support walk /\
        ContextAdmissible walk /\ lower <= walk.weight.eval}.Finite := by
  apply finite_firstReturns_above_of_finite_sourceSupported_tails
  intro action
  exact hlocal (action.target hp) mode
    (lower - action.weight.eval)

theorem finite_terminalRemainders_above_of_localFiniteness_on_erased_support
    {p : Nat} {hp : 1 <= p}
    (support : Finset (TrackedMode (p + 1)))
    (mode target : TrackedMode (p + 1)) (lower : Real)
    (hlocal : LocallyFiniteAdmissibleSourceWalks hp (support.erase mode)) :
    {walk : SourceWalk hp mode target |
      IsTerminalRemainder walk /\ SourceSupported support walk /\
        ContextAdmissible walk /\ lower <= walk.weight.eval}.Finite := by
  let TailCandidate := fun action : SourceAction mode =>
    {tail : SourceWalk hp (action.target hp) target //
      SourceSupported (support.erase mode) tail /\
        ContextAdmissible tail /\
        lower - action.weight.eval <= tail.weight.eval}
  let Candidate := Sigma TailCandidate
  let encodeCandidate : Candidate ->
      Option (PackedFirstStepTail hp mode target) :=
    fun candidate => some ⟨candidate.1, candidate.2.1⟩
  haveI finiteTailCandidate (action : SourceAction mode) :
      Finite (TailCandidate action) := by
    exact (hlocal (action.target hp) target
      (lower - action.weight.eval)).to_subtype
  haveI : Finite Candidate := by
    unfold Candidate
    infer_instance
  apply Set.Finite.of_finite_image (f := firstStepTailCode)
  · apply ((Set.finite_singleton none).union
      (Set.finite_range encodeCandidate)).subset
    intro code hcode
    rcases hcode with ⟨walk, hwalk, rfl⟩
    rcases hwalk with ⟨hterminal, hsupported, hadmissible, hlower⟩
    cases walk with
    | nil => simp [firstStepTailCode]
    | cons action tail =>
        have htailSourceSupported :
            SourceSupported (support.erase mode) tail :=
          hterminal.tail_sourceSupported_erase action tail hsupported
        have htailAdmissible : ContextAdmissible tail :=
          hadmissible.tail_of_cons
        have hweight :=
          SourceWalk.weight_eval (SourceWalk.cons action tail)
        have htailLower :
            lower - action.weight.eval <= tail.weight.eval := by
          rw [hweight] at hlower
          linarith
        apply Or.inr
        exact ⟨⟨action, ⟨tail, htailSourceSupported,
          htailAdmissible, htailLower⟩⟩, rfl⟩
  · exact firstStepTailCode_injective.injOn

theorem ContextAdmissible.appendClosedWalks_member
    {p : Nat} {hp : 1 <= p}
    {mode : TrackedMode (p + 1)}
    {walk candidate : SourceWalk hp mode mode}
    {returns : List (SourceWalk hp mode mode)}
    (hadmissible : ContextAdmissible walk)
    (hdecomposition : walk = appendClosedWalks mode returns)
    (hmember : candidate ∈ returns) :
    ContextAdmissible candidate := by
  obtain ⟨initial, suffix, hfactor⟩ :=
    exists_appendClosedWalks_factorization_of_mem hmember
  apply hadmissible.factor initial candidate suffix
  rw [hdecomposition, hfactor]

theorem ContextAdmissible.return_of_terminal_decomposition
    {p : Nat} {hp : 1 <= p}
    {mode target : TrackedMode (p + 1)}
    {walk : SourceWalk hp mode target}
    {candidate : SourceWalk hp mode mode}
    {returns : List (SourceWalk hp mode mode)}
    {terminal : SourceWalk hp mode target}
    (hadmissible : ContextAdmissible walk)
    (hdecomposition :
      walk = (appendClosedWalks mode returns).append terminal)
    (hmember : candidate ∈ returns) :
    ContextAdmissible candidate := by
  obtain ⟨initial, suffix, hfactor⟩ :=
    exists_terminal_decomposition_factorization_of_return
      terminal hdecomposition hmember
  exact hadmissible.factor initial candidate suffix hfactor

theorem ContextAdmissible.terminal_of_decomposition
    {p : Nat} {hp : 1 <= p}
    {mode target : TrackedMode (p + 1)}
    {walk : SourceWalk hp mode target}
    {returns : List (SourceWalk hp mode mode)}
    {terminal : SourceWalk hp mode target}
    (hadmissible : ContextAdmissible walk)
    (hdecomposition :
      walk = (appendClosedWalks mode returns).append terminal) :
    ContextAdmissible terminal := by
  apply hadmissible.factor (appendClosedWalks mode returns) terminal
    (SourceWalk.nil target)
  simpa using hdecomposition

theorem SourceSupported.return_of_terminal_decomposition
    {p : Nat} {hp : 1 <= p}
    {support : Finset (TrackedMode (p + 1))}
    {mode target : TrackedMode (p + 1)}
    {walk : SourceWalk hp mode target}
    {candidate : SourceWalk hp mode mode}
    {returns : List (SourceWalk hp mode mode)}
    {terminal : SourceWalk hp mode target}
    (hsupported : SourceSupported support walk)
    (hdecomposition :
      walk = (appendClosedWalks mode returns).append terminal)
    (hmember : candidate ∈ returns) :
    SourceSupported support candidate := by
  obtain ⟨initial, suffix, hfactor⟩ :=
    exists_terminal_decomposition_factorization_of_return
      terminal hdecomposition hmember
  exact hsupported.factor initial candidate suffix hfactor

theorem SourceSupported.terminal_of_decomposition
    {p : Nat} {hp : 1 <= p}
    {support : Finset (TrackedMode (p + 1))}
    {mode target : TrackedMode (p + 1)}
    {walk : SourceWalk hp mode target}
    {returns : List (SourceWalk hp mode mode)}
    {terminal : SourceWalk hp mode target}
    (hsupported : SourceSupported support walk)
    (hdecomposition :
      walk = (appendClosedWalks mode returns).append terminal) :
    SourceSupported support terminal := by
  apply hsupported.factor (appendClosedWalks mode returns) terminal
    (SourceWalk.nil target)
  simpa using hdecomposition

/-- Evaluated weights of nonempty context-admissible closed source walks. -/
def admissibleClosedWeights {p : Nat} (hp : 1 <= p) : Set Real :=
  {weight | exists mode : TrackedMode (p + 1),
    exists walk : SourceWalk hp mode mode,
      0 < walk.length /\ ContextAdmissible walk /\
        weight = walk.weight.eval}

/-- Weights of context-admissible first returns based at one mode and carried
by one finite support. -/
def firstReturnWeights {p : Nat} (hp : 1 <= p)
    (support : Finset (TrackedMode (p + 1)))
    (mode : TrackedMode (p + 1)) : Set Real :=
  {weight | exists walk : SourceWalk hp mode mode,
    IsFirstReturn walk /\ Supported support walk /\
      ContextAdmissible walk /\ weight = walk.weight.eval}

theorem firstReturnWeights_neg {p : Nat} {hp : 1 <= p}
    {support : Finset (TrackedMode (p + 1))}
    {mode : TrackedMode (p + 1)}
    {weight : Real}
    (hweight : weight ∈ firstReturnWeights hp support mode) :
    weight < 0 := by
  obtain ⟨walk, hfirst, _hsupported, hadmissible, rfl⟩ := hweight
  exact hfirst.weight_neg_of_contextAdmissible hadmissible

theorem admissibleClosedWeights_neg {p : Nat} {hp : 1 <= p}
    {weight : Real} (hweight : weight ∈ admissibleClosedWeights hp) :
    weight < 0 := by
  obtain ⟨mode, walk, hlength, hadmissible, rfl⟩ := hweight
  exact hadmissible.closed_weight_neg walk hlength

theorem exists_uniform_negative_gap_of_finite_near_zero
    (weights : Set Real)
    (hneg : forall weight, weight ∈ weights -> weight < 0)
    (hfinite : (weights ∩ Set.Ioo (-1) 0).Finite) :
    exists epsilon : Real, 0 < epsilon /\
      forall weight, weight ∈ weights -> weight <= -epsilon := by
  let nearZero : Set Real := weights ∩ Set.Ioo (-1) 0
  by_cases hnear : nearZero.Nonempty
  · obtain ⟨leastWeight, hleastWeight, hleast⟩ :=
      Set.exists_min_image nearZero (fun weight : Real => -weight)
        (by simpa [nearZero] using hfinite) hnear
    refine ⟨-leastWeight, ?_, ?_⟩
    · exact neg_pos.mpr (hneg leastWeight hleastWeight.1)
    · intro weight hweight
      by_cases hfar : weight <= -1
      · have hleastAbove : -1 < leastWeight := hleastWeight.2.1
        simpa using hfar.trans hleastAbove.le
      · have hweightNear : weight ∈ nearZero := by
          refine ⟨hweight, ?_, hneg weight hweight⟩
          exact lt_of_not_ge hfar
        have hminimum := hleast weight hweightNear
        linarith
  · refine ⟨1, by norm_num, ?_⟩
    intro weight hweight
    have hweightNeg := hneg weight hweight
    by_contra hnot
    have hweightAbove : -1 < weight := lt_of_not_ge hnot
    exact hnear ⟨weight, hweight, hweightAbove, hweightNeg⟩

theorem exists_uniform_admissible_return_drop_of_local_finiteness
    {p : Nat} {hp : 1 <= p}
    (hfinite :
      (admissibleClosedWeights hp ∩ Set.Ioo (-1) 0).Finite) :
    exists epsilon : Real, 0 < epsilon /\
      forall weight, weight ∈ admissibleClosedWeights hp ->
        weight <= -epsilon := by
  exact exists_uniform_negative_gap_of_finite_near_zero
    (admissibleClosedWeights hp)
    (fun weight hweight => admissibleClosedWeights_neg hweight) hfinite

theorem exists_uniform_firstReturn_drop_of_localFiniteness_on_erased_support
    {p : Nat} {hp : 1 <= p}
    (support : Finset (TrackedMode (p + 1)))
    (mode : TrackedMode (p + 1))
    (hlocal : LocallyFiniteAdmissibleSourceWalks hp (support.erase mode)) :
    exists epsilon : Real, 0 < epsilon /\
      forall walk : SourceWalk hp mode mode,
        IsFirstReturn walk -> Supported support walk ->
          ContextAdmissible walk -> walk.weight.eval <= -epsilon := by
  let returnCandidates : Set (SourceWalk hp mode mode) :=
    {walk | IsFirstReturn walk /\ Supported support walk /\
      ContextAdmissible walk /\ (-1 : Real) <= walk.weight.eval}
  have hreturnFinite : returnCandidates.Finite := by
    exact finite_firstReturns_above_of_localFiniteness_on_erased_support
      support mode (-1) hlocal
  have hnearFinite :
      (firstReturnWeights hp support mode ∩ Set.Ioo (-1) 0).Finite := by
    apply (hreturnFinite.image fun walk => walk.weight.eval).subset
    intro weight hweight
    rcases hweight.1 with
      ⟨walk, hfirst, hsupported, hadmissible, rfl⟩
    exact ⟨walk, ⟨hfirst, hsupported, hadmissible, hweight.2.1.le⟩, rfl⟩
  obtain ⟨epsilon, hepsilon, hdrop⟩ :=
    exists_uniform_negative_gap_of_finite_near_zero
      (firstReturnWeights hp support mode)
      (fun weight hweight => firstReturnWeights_neg hweight) hnearFinite
  refine ⟨epsilon, hepsilon, ?_⟩
  intro walk hfirst hsupported hadmissible
  exact hdrop walk.weight.eval
    ⟨walk, hfirst, hsupported, hadmissible, rfl⟩

theorem finite_admissible_sourceWalks_above
    {p : Nat} (hp : 1 <= p)
    (support : Finset (TrackedMode (p + 1))) :
    LocallyFiniteAdmissibleSourceWalks hp support := by
  exact Finset.strongInductionOn support (fun support ih => by
      intro source target lower
      by_cases hsource : source ∈ support
      · have herase : support.erase source ⊂ support :=
          Finset.erase_ssubset hsource
        have hlocal :
            LocallyFiniteAdmissibleSourceWalks hp (support.erase source) :=
          ih (support.erase source) herase
        have hterminalFinite :=
          finite_terminalRemainders_above_of_localFiniteness_on_erased_support
            support source target lower hlocal
        let terminals : Set (SourceWalk hp source target) :=
          {terminal | IsTerminalRemainder terminal /\
            SourceSupported support terminal /\
            ContextAdmissible terminal /\ lower <= terminal.weight.eval}
        have hterminalFinite' : terminals.Finite := hterminalFinite
        obtain ⟨terminalWeightUpper, hterminalWeightUpper⟩ :=
          exists_real_upper_bound_on_finite_set terminals hterminalFinite'
            (fun terminal => terminal.weight.eval)
        obtain ⟨terminalLengthBound, hterminalLengthBound⟩ :=
          exists_nat_upper_bound_on_finite_set terminals hterminalFinite'
            SourceWalk.length
        let returnLower : Real := lower - terminalWeightUpper
        have hreturnFinite :=
          finite_firstReturns_above_of_localFiniteness_on_erased_support
            support source returnLower hlocal
        let returnsAbove : Set (SourceWalk hp source source) :=
          {candidate | IsFirstReturn candidate /\ Supported support candidate /\
            ContextAdmissible candidate /\
              returnLower <= candidate.weight.eval}
        have hreturnFinite' : returnsAbove.Finite := hreturnFinite
        obtain ⟨returnLengthBound, hreturnLengthBound⟩ :=
          exists_nat_upper_bound_on_finite_set returnsAbove hreturnFinite'
            SourceWalk.length
        obtain ⟨epsilon, hepsilon, hreturnDrop⟩ :=
          exists_uniform_firstReturn_drop_of_localFiniteness_on_erased_support
            support source hlocal
        obtain ⟨returnCountBound, hreturnCountBound⟩ :=
          exists_nat_gt ((terminalWeightUpper - lower) / epsilon)
        let walkLengthBound : Nat :=
          returnCountBound * returnLengthBound + terminalLengthBound
        apply (finite_sourceWalk_length_le walkLengthBound).subset
        intro walk hwalk
        rcases hwalk with ⟨hwalkSupported, hwalkAdmissible, hwalkLower⟩
        obtain ⟨returns, terminal, hdecomposition,
          hreturnsFirst, hterminal⟩ :=
          exists_firstReturnList_terminal_decomposition walk
        have hterminalSupported : SourceSupported support terminal :=
          hwalkSupported.terminal_of_decomposition hdecomposition
        have hterminalAdmissible : ContextAdmissible terminal :=
          hwalkAdmissible.terminal_of_decomposition hdecomposition
        have hreturnSupported : forall candidate,
            candidate ∈ returns -> Supported support candidate := by
          intro candidate hcandidate
          have hcandidateSourceSupported : SourceSupported support candidate :=
            hwalkSupported.return_of_terminal_decomposition
              hdecomposition hcandidate
          exact hcandidateSourceSupported.supported_of_target_mem hsource
        have hreturnAdmissible : forall candidate,
            candidate ∈ returns -> ContextAdmissible candidate := by
          intro candidate hcandidate
          exact hwalkAdmissible.return_of_terminal_decomposition
            hdecomposition hcandidate
        have hreturnNonpos : forall candidate,
            candidate ∈ returns -> candidate.weight.eval <= 0 := by
          intro candidate hcandidate
          exact (hreturnsFirst candidate hcandidate).weight_neg_of_contextAdmissible
            (hreturnAdmissible candidate hcandidate) |>.le
        have hreturnSumNonpos :
            (returns.map (fun candidate => candidate.weight.eval)).sum <= 0 :=
          list_sum_map_nonpos_of_forall_mem returns
            (fun candidate => candidate.weight.eval) hreturnNonpos
        have hweightDecomposition :=
          terminal_decomposition_weight_eval hdecomposition
        have hterminalLower : lower <= terminal.weight.eval := by
          linarith
        have hterminalMember : terminal ∈ terminals :=
          ⟨hterminal, hterminalSupported, hterminalAdmissible, hterminalLower⟩
        have hterminalUpper : terminal.weight.eval <= terminalWeightUpper :=
          hterminalWeightUpper terminal hterminalMember
        have hterminalLength : terminal.length <= terminalLengthBound :=
          hterminalLengthBound terminal hterminalMember
        have hreturnSumLower : returnLower <=
            (returns.map (fun candidate => candidate.weight.eval)).sum := by
          dsimp only [returnLower]
          linarith
        have hreturnMember : forall candidate,
            candidate ∈ returns -> candidate ∈ returnsAbove := by
          intro candidate hcandidate
          have hsumLeCandidate :=
            list_sum_map_le_member_of_forall_nonpos returns
              (fun item => item.weight.eval) hcandidate hreturnNonpos
          exact ⟨hreturnsFirst candidate hcandidate,
            hreturnSupported candidate hcandidate,
            hreturnAdmissible candidate hcandidate,
            hreturnSumLower.trans hsumLeCandidate⟩
        have hreturnLength : forall candidate,
            candidate ∈ returns -> candidate.length <= returnLengthBound := by
          intro candidate hcandidate
          exact hreturnLengthBound candidate
            (hreturnMember candidate hcandidate)
        have hreturnLengthSum :
            (returns.map SourceWalk.length).sum <=
              returns.length * returnLengthBound :=
          list_sum_map_nat_le_length_mul returns SourceWalk.length
            returnLengthBound hreturnLength
        have hreturnDropAll : forall candidate,
            candidate ∈ returns -> candidate.weight.eval <= -epsilon := by
          intro candidate hcandidate
          exact hreturnDrop candidate
            (hreturnsFirst candidate hcandidate)
            (hreturnSupported candidate hcandidate)
            (hreturnAdmissible candidate hcandidate)
        have hreturnSumDrop :
            (returns.map (fun candidate => candidate.weight.eval)).sum <=
              -(returns.length : Real) * epsilon :=
          list_sum_map_le_neg_mul_length returns
            (fun candidate => candidate.weight.eval) epsilon hreturnDropAll
        have hlengthMul :
            (returns.length : Real) * epsilon <=
              terminalWeightUpper - lower := by
          linarith
        have hlengthRatio :
            (returns.length : Real) <=
              (terminalWeightUpper - lower) / epsilon := by
          exact (le_div_iff₀ hepsilon).2 hlengthMul
        have hreturnCountReal :
            (returns.length : Real) < returnCountBound :=
          hlengthRatio.trans_lt hreturnCountBound
        have hreturnCount : returns.length < returnCountBound := by
          exact_mod_cast hreturnCountReal
        have hwalkLength : walk.length =
            (returns.map SourceWalk.length).sum + terminal.length := by
          rw [hdecomposition, SourceWalk.length_append,
            appendClosedWalks_length]
        change walk.length <= walkLengthBound
        dsimp only [walkLengthBound]
        rw [hwalkLength]
        have hreturnMul :
            returns.length * returnLengthBound <=
              returnCountBound * returnLengthBound := by
          exact Nat.mul_le_mul_right returnLengthBound hreturnCount.le
        omega
      · apply (finite_sourceWalk_length_le 0).subset
        intro walk hwalk
        rcases hwalk with ⟨hsupported, _hadmissible, _hlower⟩
        cases walk with
        | nil => simp
        | cons action tail =>
            exact False.elim (hsource hsupported.1)
    )

theorem finite_admissible_walks_above
    {p : Nat} (hp : 1 <= p)
    (support : Finset (TrackedMode (p + 1))) :
    LocallyFiniteAdmissibleSourceWalks hp support :=
  finite_admissible_sourceWalks_above hp support

theorem finite_admissibleClosedWeights_near_zero
    {p : Nat} (hp : 1 <= p) :
    (admissibleClosedWeights hp ∩ Set.Ioo (-1) 0).Finite := by
  let WalkCandidate := fun mode : TrackedMode (p + 1) =>
    {walk : SourceWalk hp mode mode //
      SourceSupported Finset.univ walk /\ ContextAdmissible walk /\
        (-1 : Real) <= walk.weight.eval}
  let Candidate := Sigma WalkCandidate
  have hlocal := finite_admissible_sourceWalks_above hp Finset.univ
  haveI finiteWalkCandidate (mode : TrackedMode (p + 1)) :
      Finite (WalkCandidate mode) := by
    exact (hlocal mode mode (-1)).to_subtype
  haveI : Finite Candidate := by
    unfold Candidate
    infer_instance
  apply (Set.finite_range
    (fun candidate : Candidate => candidate.2.1.weight.eval)).subset
  intro weight hweight
  rcases hweight.1 with
    ⟨mode, walk, _hlength, hadmissible, rfl⟩
  refine ⟨⟨mode, ⟨walk, sourceSupported_univ walk,
    hadmissible, hweight.2.1.le⟩⟩, rfl⟩

theorem exists_uniform_admissible_return_drop
    {p : Nat} (hp : 1 <= p) :
    exists epsilon : Real, 0 < epsilon /\
      forall weight, weight ∈ admissibleClosedWeights hp ->
        weight <= -epsilon := by
  exact exists_uniform_admissible_return_drop_of_local_finiteness
    (finite_admissibleClosedWeights_near_zero hp)

end GeneralKNestedReturnDescent

end KL2003
end CollatzClassical
