import CollatzClassical.KL2003.F3ReturnExcursionBlock0CarrierFiberCards

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
State-fibre cardinalities derived structurally from the three fine fibres.
No new finite certificate is evaluated in this module.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0CarrierStateCards

open F3Block0CarrierFibers
open F3Block0CarrierFiberCards
open scoped BigOperators

theorem stateFiber_card_eq_sum_fine (s : Fin 243) :
    (stateFiber s).card =
      ∑ ell : Fin 3, (stateFineFiber s ell).card := by
  simpa [stateFineFiber] using
    (Finset.card_eq_sum_card_fiberwise
      (s := stateFiber s) (t := (Finset.univ : Finset (Fin 3)))
      (f := rootFineLift) (by
        intro i hi
        exact Finset.mem_univ (rootFineLift i)))

theorem stateFiber_card (s : Fin 243) :
    (stateFiber s).card = if s.1 % 3 = 0 then 6 else 3 := by
  rw [stateFiber_card_eq_sum_fine]
  simp_rw [stateFineFiber_card]
  by_cases h : s.1 % 3 = 0 <;> simp [h]

end F3Block0CarrierStateCards
end KL2003
end CollatzClassical
