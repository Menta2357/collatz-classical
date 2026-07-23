import CollatzClassical.KL2003.F3ReturnExcursionPathLeakageContract
import CollatzClassical.KL2003.KL2003M0BTwoBranchCore

namespace CollatzClassical
namespace KL2003
namespace F3TwoBranchPathInstance

open F3PathLeakageContract

def twoBranchIndex : Finset Bool := {false, true}

def twoBranchFiber (a c xRet xAdv : Nat) : Bool → Finset Nat
  | false => piStarFinset (4 * a) xRet
  | true => piStarFinset c xAdv

def twoBranchStoppedPathData (a c x xRet xAdv : Nat)
    (ha_pos : 1 ≤ a)
    (ha_cycle : NotInCycle a)
    (hc : T c = a)
    (hchildren : 2 * a ≠ c)
    (hax : a ≤ x)
    (hxRet : xRet ≤ x)
    (hxAdv : xAdv ≤ x) :
    StoppedPathData Bool Nat where
  root := fun _ => piStarFinset a x
  index := fun _ => twoBranchIndex
  fiber := fun _ => twoBranchFiber a c xRet xAdv
  boundary := fun n =>
    piStarFinset a x \
      (twoBranchIndex.biUnion (twoBranchFiber a c xRet xAdv))
  fibers_disjoint := by
    intro n i hi j hj hij
    change Disjoint
      (twoBranchFiber a c xRet xAdv i)
      (twoBranchFiber a c xRet xAdv j)
    rw [Finset.disjoint_left]
    cases i with
    | false =>
        cases j with
        | false => exact (hij rfl).elim
        | true =>
            intro m hmRet hmAdv
            exact (Finset.disjoint_left.mp
              (two_branch_sources_disjoint_in_target
                (a := a) (c := c) (x := x)
                (xRet := xRet) (xAdv := xAdv)
                ha_pos ha_cycle hc hchildren hax hxRet hxAdv)) hmRet hmAdv
    | true =>
        cases j with
        | false =>
            intro m hmAdv hmRet
            exact (Finset.disjoint_left.mp
              (two_branch_sources_disjoint_in_target
                (a := a) (c := c) (x := x)
                (xRet := xRet) (xAdv := xAdv)
                ha_pos ha_cycle hc hchildren hax hxRet hxAdv)) hmRet hmAdv
        | true => exact (hij rfl).elim
  fibers_subset_root := by
    intro n i hi
    cases i with
    | false =>
        intro m hm
        exact two_branch_retarded_injection
          (a := a) (x := x) (xRet := xRet) (n := m) hxRet hm
    | true =>
        intro m hm
        exact two_branch_advanced_injection
          (a := a) (c := c) (x := x) (xAdv := xAdv) (n := m)
          hc hax hxAdv hm
  boundary_is_remainder := by
    intro n
    rfl

theorem two_branch_stopped_path_card_identity
    {a c x xRet xAdv : Nat}
    (ha_pos : 1 ≤ a)
    (ha_cycle : NotInCycle a)
    (hc : T c = a)
    (hchildren : 2 * a ≠ c)
    (hax : a ≤ x)
    (hxRet : xRet ≤ x)
    (hxAdv : xAdv ≤ x) :
    retainedMass
        (twoBranchStoppedPathData a c x xRet xAdv ha_pos ha_cycle hc
          hchildren hax hxRet hxAdv) 0 +
        boundaryMass
        (twoBranchStoppedPathData a c x xRet xAdv ha_pos ha_cycle hc
          hchildren hax hxRet hxAdv) 0 =
      rootMass
        (twoBranchStoppedPathData a c x xRet xAdv ha_pos ha_cycle hc
          hchildren hax hxRet hxAdv) 0 := by
  exact retained_plus_boundary_eq_root
    (twoBranchStoppedPathData a c x xRet xAdv ha_pos ha_cycle hc
      hchildren hax hxRet hxAdv) 0

end F3TwoBranchPathInstance
end KL2003
end CollatzClassical
