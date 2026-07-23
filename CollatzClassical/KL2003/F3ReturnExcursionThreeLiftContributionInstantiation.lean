import CollatzClassical.KL2003.F3ReturnExcursionOperatorContributionHook
import CollatzClassical.KL2003.F3ReturnExcursionThreeLiftStoppedPathInstance

/-!
Concrete one-layer instantiation of the row-contribution hook.

This is the smallest end-to-end semantic object for F3: the three declared
channels are supplied as actual stopped fibres inside one parent `piStar`
population.  The theorem leaves only the operator-to-contribution inequality
open; it does not pretend that a one-layer instance proves the composed
renewal statement.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3ThreeLiftContributionInstantiation

open F3OperatorContributionHook
open F3PathLeakageContract
open F3ThreeLiftStoppedPathInstance

def oneLayerIndex : Finset LayerChannel := Finset.univ

theorem one_layer_operator_mass_le_piStar
    {a c x xRet xAdv : Nat}
    (ha_pos : 1 ≤ a)
    (hc : 3 * c + 1 = 2 * a)
    (hchildren : 2 * a ≠ c)
    (hax : a ≤ x)
    (hxRet : xRet ≤ x)
    (hxAdv : xAdv ≤ x)
    (operatorMass : ℝ)
    (contribution : Nat → LayerChannel → ℝ)
    (hoperator : operatorMass ≤
      ∑ i ∈ oneLayerIndex, contribution a i)
    (hrow : ∀ i, i ∈ oneLayerIndex →
      contribution a i ≤
        (layerFiber a c xRet xAdv i).card) :
    operatorMass ≤ (piStarFinset a x).card := by
  let data := three_lift_stopped_path_data
    ha_pos hc hchildren hax hxRet hxAdv
  let contribution' : Nat → LayerChannel → ℝ :=
    fun a' i => if a' = a then contribution a i else 0
  let fiber' : Nat → LayerChannel → Finset Nat :=
    fun a' i => if a' = a then layerFiber a c xRet xAdv i else ∅
  have hdisj : ∀ a' : Nat,
      ((fun _ : Nat => oneLayerIndex) a' : Set LayerChannel).PairwiseDisjoint
        (fiber' a') := by
    intro a'
    by_cases h : a' = a
    · subst a'
      simp only [fiber', if_pos rfl]
      change (↑oneLayerIndex : Set LayerChannel).PairwiseDisjoint
        (fun i => layerFiber a c xRet xAdv i)
      have hdata := data.fibers_disjoint 0
      change (↑oneLayerIndex : Set LayerChannel).PairwiseDisjoint
        (fun i => layerFiber a c xRet xAdv i) at hdata
      exact hdata
    · intro i _ j _ hij
      simp [fiber', h]
  have hsub : ∀ a' i, i ∈ (fun _ : Nat => oneLayerIndex) a' →
      fiber' a' i ⊆ piStarFinset a' x := by
    intro a' i hi
    by_cases h : a' = a
    · subst a'
      have hi' : i ∈ oneLayerIndex := hi
      have hlocal := data.fibers_subset_root 0 i hi'
      simpa [fiber', data] using hlocal
    · simp [fiber', h]
  have hcontribution : ∀ a' i,
      i ∈ (fun _ : Nat => oneLayerIndex) a' →
        contribution' a' i ≤ (fiber' a' i).card := by
    intro a' i hi
    by_cases h : a' = a
    · subst a'
      simpa [contribution', fiber'] using hrow i hi
    · simp [contribution', fiber', h]
  apply operator_mass_le_piStar_of_row_contribution
    operatorMass ({a} : Finset Nat) x
    (fun _ : Nat => oneLayerIndex)
    contribution'
    fiber'
  · simpa [oneLayerIndex, contribution'] using hoperator
  · exact hcontribution
  · exact hdisj
  · exact hsub

end F3ThreeLiftContributionInstantiation
end KL2003
end CollatzClassical
