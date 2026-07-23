import CollatzClassical.KL2003.F3ReturnExcursionBoundaryLeakage
import CollatzClassical.KL2003.F3ReturnExcursionFiberAccounting

open scoped BigOperators

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3PathLeakageContract

/-!
Concrete interface for the remaining F3 population argument.

The structure records the finite root populations, complete stopped fibres,
and the boundary remainder.  It deliberately does not manufacture any of
the hypotheses from the frozen matrix: those hypotheses are the outstanding
path construction.  Once they are supplied, the theorem below transports
the exact finite-fibre identity to the already audited Real renewal
interface.
-/

structure StoppedPathData (ι α : Type*) [DecidableEq ι] [DecidableEq α] where
  root : Nat → Finset α
  index : Nat → Finset ι
  fiber : Nat → ι → Finset α
  boundary : Nat → Finset α
  fibers_disjoint : ∀ n,
    ((index n : Set ι).PairwiseDisjoint (fiber n))
  fibers_subset_root : ∀ n i, i ∈ index n → fiber n i ⊆ root n
  boundary_is_remainder : ∀ n,
    boundary n = root n \ (index n).biUnion (fiber n)

def rootMass {ι α : Type*} [DecidableEq ι] [DecidableEq α]
    (data : StoppedPathData ι α) (n : Nat) : ℝ :=
  (data.root n).card

def retainedMass {ι α : Type*} [DecidableEq ι] [DecidableEq α]
    (data : StoppedPathData ι α) (n : Nat) : ℝ :=
  (((∑ i ∈ data.index n, (data.fiber n i).card) : Nat) : ℝ)

def boundaryMass {ι α : Type*} [DecidableEq ι] [DecidableEq α]
    (data : StoppedPathData ι α) (n : Nat) : ℝ :=
  (data.boundary n).card

theorem retained_plus_boundary_eq_root
    {ι α : Type*} [DecidableEq ι] [DecidableEq α]
    (data : StoppedPathData ι α) (n : Nat) :
    retainedMass data n + boundaryMass data n = rootMass data n := by
  have hcard := F3FiberAccounting.sum_fiber_card_add_boundary_eq_root_card
    (data.index n) (data.fiber n) (data.root n)
    (data.fibers_disjoint n)
    (fun i hi => data.fibers_subset_root n i hi)
  rw [← data.boundary_is_remainder n] at hcard
  simp only [retainedMass, boundaryMass, rootMass]
  exact_mod_cast hcard

/-!
Route II is now a single explicit contract.  `root_bound` is the normalized
row-wise inequality, while `retained_le_stopped_increment` is the first-hit
path statement.  Neither is inferred from empirical holdout data here.
-/

structure RouteIIContract {ι α : Type*}
    [DecidableEq ι] [DecidableEq α]
    (data : StoppedPathData ι α) (q L ε : ℝ) where
  stopped : Nat → ℝ
  stopped_zero_nonneg : 0 ≤ stopped 0
  boundary_budget : ∀ n,
    boundaryMass data n ≤ ε * rootMass data n
  root_bound : ∀ n,
    (1 - q) * L * q ^ n ≤ (1 - ε) * rootMass data n
  retained_le_stopped_increment : ∀ n,
    retainedMass data n ≤ stopped (n + 1) - stopped n

theorem RouteIIContract.leakage
    {ι α : Type*} [DecidableEq ι] [DecidableEq α]
    {data : StoppedPathData ι α} {q L ε : ℝ}
    (contract : RouteIIContract data q L ε) :
    ∀ n, (1 - q) * L * q ^ n ≤
      contract.stopped (n + 1) - contract.stopped n := by
  intro n
  have hleak := F3BoundaryLeakage.boundary_budget_to_leakage
    contract.boundary_budget
    (fun m => by
      linarith [retained_plus_boundary_eq_root data m])
    contract.root_bound
    contract.retained_le_stopped_increment
  exact hleak n

theorem RouteIIContract.renewal_lower_bound
    {ι α : Type*} [DecidableEq ι] [DecidableEq α]
    {data : StoppedPathData ι α} {L ε : ℝ}
    (contract : RouteIIContract data
      F3ReturnExcursionM0BReal.qStar L ε) :
    ∀ n, L * (1 - F3ReturnExcursionM0BReal.qStar ^ n) ≤
      contract.stopped n := by
  exact F3BoundaryLeakage.boundary_budget_to_qStar_certificate
    contract.stopped_zero_nonneg
    contract.boundary_budget
    (fun m => by
      have hretained : retainedMass data m =
          rootMass data m - boundaryMass data m := by
        linarith [retained_plus_boundary_eq_root data m]
      exact hretained)
    contract.root_bound
    contract.retained_le_stopped_increment

end F3PathLeakageContract
end KL2003
end CollatzClassical
