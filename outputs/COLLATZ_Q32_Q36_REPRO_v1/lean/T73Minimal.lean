import A2TwoOnesMinimal
import T73Family

namespace CollatzCharacterBridge.T73Minimal

open StagedCylinder (Segment)

/-- The explicit source is optimal among all positive odd sources below
the same N, regardless of the proposed valuation word. -/
theorem minimum_two_returns_t73 (t : Nat) :
    let N := A2U392.seed (365634215903753+288230376151711744*t)
    let Y := orbit N 73
    ∃ z, 0<z ∧ z%2=1 ∧ z<N ∧ N<Y ∧
      Segment N Y 73 115 411443494169899340644307646523772515 ∧
      Segment z Y 2 2 5 ∧
      ∀ w d : Nat, 0<w → w%2=1 → w<N → d≤2 → orbit w d=Y →
        d=2 ∧ w=z := by
  let N := A2U392.seed (365634215903753+288230376151711744*t)
  let Y := orbit N 73
  obtain ⟨w,z,_,_,_,_,zp,zo,paid,height,above,original,_,_,aux,_⟩ := T73Family.paid_t73 t
  let X := step z
  have physical : orbit z 2=Y := A2Header.physical_endpoint aux.physical
  have yo : Y%2=1 := by rw [←physical]; exact orbit_odd z zo 2
  have book := aux.book
  change 4*Y=9*z+5 at book
  have z_phase : z%4=3 := by omega
  have first : 3*z+1=2*X := by
    have factor := step_mul_two z_phase
    change X*2=3*z+1 at factor
    omega
  have second : 3*X+1=2*Y := by omega
  have xo : X%2=1 := step_odd z
  have unique := (A2TwoOnesMinimal.two_ones_unique zp zo xo yo height first second).2
  exact ⟨z,zp,zo,paid,above,original,aux,unique⟩

end CollatzCharacterBridge.T73Minimal
