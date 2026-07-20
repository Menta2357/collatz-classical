import CollatzClassical.KL2003.KL2003AlphaIrrational
import Mathlib.Data.Set.Finite.Lemmas
import Mathlib.Data.Set.Finite.List

namespace CollatzClassical
namespace KL2003

/-!
Finite extraction layer for the context-preserving nested-return descent.

The hard combinatorial input is local finiteness of admissible closed-walk
weights near zero.  This module does not assume that input as part of a data
bundle.  It isolates and proves the order-theoretic consumer: once the set of
strictly negative weights in `(-1, 0)` is finite, one positive epsilon works
for every weight, including those at most `-1`.

The local-finiteness theorem itself remains to be proved from first-return
decomposition on the finite source-mode graph.
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

/-- Evaluated weights of nonempty context-admissible closed source walks. -/
def admissibleClosedWeights {p : Nat} (hp : 1 <= p) : Set Real :=
  {weight | exists mode : TrackedMode (p + 1),
    exists walk : SourceWalk hp mode mode,
      0 < walk.length /\ ContextAdmissible walk /\
        weight = walk.weight.eval}

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

end GeneralKNestedReturnDescent

end KL2003
end CollatzClassical
