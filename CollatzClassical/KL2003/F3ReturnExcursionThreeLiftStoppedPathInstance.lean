import CollatzClassical.KL2003.F3ReturnExcursionStoppedPathPiStarBridge
import CollatzClassical.KL2003.F3ReturnExcursionFirstHitFibers

open scoped BigOperators

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3ThreeLiftStoppedPathInstance

open F3AdvancedDisjointness
open F3FirstHitFibers
open F3PathLeakageContract

inductive LayerChannel where
  | retarded
  | advancedDirect
  | parityLift
  deriving DecidableEq, Fintype, Repr

def firstHitFiltered (source : Finset Nat) (a predecessor : Nat) : Finset Nat :=
  by
    classical
    exact source.filter (fun n => decide (FirstHitThrough a predecessor n))

def retardedSource (a xRet : Nat) : Finset Nat :=
  firstHitFiltered (piStarFinset (4 * a) xRet) a (2 * a)

def layerIndex : Finset LayerChannel := Finset.univ

def layerFiber (a c xRet xAdv : Nat) : LayerChannel → Finset Nat
  | .retarded => retardedSource a xRet
  | .advancedDirect =>
      if c % 3 = 2 then firstHitSource .direct a c xAdv else ∅
  | .parityLift =>
      if c % 3 = 1 then firstHitSource .parityLift a c xAdv else ∅

theorem firstHitFiltered_disjoint
    {source₁ source₂ : Finset Nat} {a p₁ p₂ : Nat}
    (hp : p₁ ≠ p₂)
    (h₁ : ∀ n, n ∈ firstHitFiltered source₁ a p₁ →
      FirstHitThrough a p₁ n)
    (h₂ : ∀ n, n ∈ firstHitFiltered source₂ a p₂ →
      FirstHitThrough a p₂ n) :
    Disjoint (firstHitFiltered source₁ a p₁)
      (firstHitFiltered source₂ a p₂) := by
  rw [Finset.disjoint_left]
  intro n hn₁ hn₂
  rcases h₁ n hn₁ with ⟨k₁, hfirst₁, hchild₁⟩
  rcases h₂ n hn₂ with ⟨k₂, hfirst₂, hchild₂⟩
  have hk : k₁ = k₂ := by
    by_contra hne
    rcases lt_or_gt_of_ne hne with hlt | hgt
    · exact (hfirst₂.2 (k₁ + 1) (by omega)) hfirst₁.1
    · exact (hfirst₁.2 (k₂ + 1) (by omega)) hfirst₂.1
  apply hp
  calc
    p₁ = T^[k₁] n := hchild₁.symm
    _ = T^[k₂] n := by rw [hk]
    _ = p₂ := hchild₂

theorem firstHitFiltered_mem_predicate
    {source : Finset Nat} {a p n : Nat}
    (hn : n ∈ firstHitFiltered source a p) :
    FirstHitThrough a p n := by
  simpa [firstHitFiltered] using (Finset.mem_filter.mp hn).2

def three_lift_stopped_path_data
    {a c x xRet xAdv : Nat}
    (ha_pos : 1 ≤ a)
    (hc : 3 * c + 1 = 2 * a)
    (hchildren : 2 * a ≠ c)
    (hax : a ≤ x)
    (hxRet : xRet ≤ x)
    (hxAdv : xAdv ≤ x) :
    StoppedPathData LayerChannel Nat where
  root := fun _ => piStarFinset a x
  index := fun _ => layerIndex
  fiber := fun _ => layerFiber a c xRet xAdv
  boundary := fun n =>
    piStarFinset a x \
      layerIndex.biUnion (layerFiber a c xRet xAdv)
  fibers_disjoint := by
    intro n i hi j hj hij
    cases i with
    | retarded =>
        cases j with
        | retarded => exact (hij rfl).elim
        | advancedDirect =>
            change Disjoint (layerFiber a c xRet xAdv .retarded)
              (layerFiber a c xRet xAdv .advancedDirect)
            simp only [layerFiber]
            by_cases hc2 : c % 3 = 2
            · simp only [if_pos hc2]
              change Disjoint (retardedSource a xRet)
                (firstHitSource .direct a c xAdv)
              unfold retardedSource
              apply firstHitFiltered_disjoint hchildren
              · intro m hm
                exact firstHitFiltered_mem_predicate hm
              · intro m hm
                exact (mem_firstHitSource_iff.mp hm).2
            · simp only [if_neg hc2]
              change Disjoint (retardedSource a xRet) ∅
              simp
        | parityLift =>
            change Disjoint (layerFiber a c xRet xAdv .retarded)
              (layerFiber a c xRet xAdv .parityLift)
            simp only [layerFiber]
            by_cases hc1 : c % 3 = 1
            · simp only [if_pos hc1]
              change Disjoint (retardedSource a xRet)
                (firstHitSource .parityLift a c xAdv)
              unfold retardedSource
              apply firstHitFiltered_disjoint hchildren
              · intro m hm
                exact firstHitFiltered_mem_predicate hm
              · intro m hm
                exact (mem_firstHitSource_iff.mp hm).2
            · simp only [if_neg hc1]
              change Disjoint (retardedSource a xRet) ∅
              simp
    | advancedDirect =>
        cases j with
        | retarded =>
            change Disjoint (layerFiber a c xRet xAdv .advancedDirect)
              (layerFiber a c xRet xAdv .retarded)
            simp only [layerFiber]
            by_cases hc2 : c % 3 = 2
            · simp only [if_pos hc2]
              change Disjoint (firstHitSource .direct a c xAdv)
                (retardedSource a xRet)
              unfold retardedSource
              apply firstHitFiltered_disjoint hchildren.symm
              · intro m hm
                exact (mem_firstHitSource_iff.mp hm).2
              · intro m hm
                exact firstHitFiltered_mem_predicate hm
            · simp only [if_neg hc2]
              change Disjoint ∅ (retardedSource a xRet)
              simp
        | advancedDirect => exact (hij rfl).elim
        | parityLift =>
            change Disjoint (layerFiber a c xRet xAdv .advancedDirect)
              (layerFiber a c xRet xAdv .parityLift)
            simp only [layerFiber]
            by_cases hc2 : c % 3 = 2
            · have hc1 : c % 3 ≠ 1 := by omega
              simp only [if_pos hc2, if_neg hc1]
              change Disjoint (firstHitSource .direct a c xAdv) ∅
              simp
            · simp only [if_neg hc2]
              change Disjoint ∅ (if c % 3 = 1 then
                firstHitSource .parityLift a c xAdv else ∅)
              simp [hc2]
    | parityLift =>
        cases j with
        | retarded =>
            change Disjoint (layerFiber a c xRet xAdv .parityLift)
              (layerFiber a c xRet xAdv .retarded)
            simp only [layerFiber]
            by_cases hc1 : c % 3 = 1
            · simp only [if_pos hc1]
              change Disjoint (firstHitSource .parityLift a c xAdv)
                (retardedSource a xRet)
              unfold retardedSource
              apply firstHitFiltered_disjoint hchildren.symm
              · intro m hm
                exact (mem_firstHitSource_iff.mp hm).2
              · intro m hm
                exact firstHitFiltered_mem_predicate hm
            · simp only [if_neg hc1]
              change Disjoint ∅ (retardedSource a xRet)
              simp
        | advancedDirect =>
            change Disjoint (layerFiber a c xRet xAdv .parityLift)
              (layerFiber a c xRet xAdv .advancedDirect)
            simp only [layerFiber]
            by_cases hc1 : c % 3 = 1
            · have hc2 : c % 3 ≠ 2 := by omega
              simp only [if_pos hc1, if_neg hc2]
              change Disjoint (firstHitSource .parityLift a c xAdv) ∅
              simp
            · simp only [if_neg hc1]
              change Disjoint ∅ (if c % 3 = 2 then
                firstHitSource .direct a c xAdv else ∅)
              simp [hc1]
        | parityLift => exact (hij rfl).elim
  fibers_subset_root := by
    intro n i hi
    cases i with
    | retarded =>
        intro m hm
        have hm' : m ∈ retardedSource a xRet := by
          simpa [layerFiber] using hm
        unfold retardedSource at hm'
        have hraw : m ∈ piStarFinset (4 * a) xRet :=
          (Finset.mem_filter.mp hm').1
        exact two_branch_retarded_injection
          (a := a) (x := x) (xRet := xRet) (n := m) hxRet hraw
    | advancedDirect =>
        by_cases hc2 : c % 3 = 2
        · intro m hm
          have hm' : m ∈ firstHitSource .direct a c xAdv := by
            simpa [layerFiber, hc2] using hm
          exact firstHitSource_subset_parent hc hax hxAdv hm'
        · intro m hm
          have : False := by simpa [layerFiber, hc2] using hm
          exact this.elim
    | parityLift =>
        by_cases hc1 : c % 3 = 1
        · intro m hm
          have hm' : m ∈ firstHitSource .parityLift a c xAdv := by
            simpa [layerFiber, hc1] using hm
          exact firstHitSource_subset_parent hc hax hxAdv hm'
        · intro m hm
          have : False := by simpa [layerFiber, hc1] using hm
          exact this.elim
  boundary_is_remainder := by
    intro n
    rfl

theorem three_lift_retained_plus_boundary
    {a c x xRet xAdv : Nat}
    (ha_pos : 1 ≤ a)
    (hc : 3 * c + 1 = 2 * a)
    (hchildren : 2 * a ≠ c)
    (hax : a ≤ x)
    (hxRet : xRet ≤ x)
    (hxAdv : xAdv ≤ x) :
    retainedMass
        (three_lift_stopped_path_data ha_pos hc hchildren hax hxRet hxAdv) 0 +
        boundaryMass
        (three_lift_stopped_path_data ha_pos hc hchildren hax hxRet hxAdv) 0 =
      rootMass
        (three_lift_stopped_path_data ha_pos hc hchildren hax hxRet hxAdv) 0 := by
  exact retained_plus_boundary_eq_root
    (three_lift_stopped_path_data ha_pos hc hchildren hax hxRet hxAdv) 0

end F3ThreeLiftStoppedPathInstance
end KL2003
end CollatzClassical
