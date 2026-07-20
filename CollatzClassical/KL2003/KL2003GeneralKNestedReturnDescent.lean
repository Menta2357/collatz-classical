import CollatzClassical.KL2003.KL2003AlphaIrrational
import Mathlib.Data.Set.Finite.Lemmas

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

@[simp] theorem sourceWalk_append_nil {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    walk.append (SourceWalk.nil target) = walk := by
  induction walk with
  | nil => rfl
  | cons action tail ih =>
      simp only [SourceWalk.append]
      rw [ih]

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
