import A2C2Continuation

namespace CollatzCharacterBridge.A2MixedProgressCut

open A2Header (Physical)
open StagedCylinder (Segment)

set_option maxRecDepth 12000
set_option maxHeartbeats 800000

/-- A fixed threshold is respected at every checkpoint of this same
physical history. The threshold may be the original A2 pivot V. -/
def StaysAbove (x V j : Nat) : Prop :=
  ∀ m : Nat, m ≤ j → V ≤ orbit x m

/-- Product bound for any physical odd-return word, independent of its
valuations or how its runs are grouped. -/
theorem physical_product_bound {x y j s V : Nat}
    (path : Physical x j s y) (stay : StaysAbove x V j) :
    2^s * V^j * y ≤ x * (3*V+1)^j := by
  induction path with
  | refl x =>
      simp
  | @edge x a y hx hxo hy hyo ha hf =>
      have hVx : V ≤ x := stay 0 (by decide)
      have hfactor : V*(3*x+1) ≤ x*(3*V+1) := by
        calc
          V*(3*x+1) = 3*V*x+V := by
            rw [Nat.mul_add]
            simp only [Nat.mul_one]
            ac_rfl
          _ ≤ 3*V*x+x := Nat.add_le_add_left hVx _
          _ = x*(3*V+1) := by
            rw [Nat.mul_add]
            simp only [Nat.mul_one]
            ac_rfl
      calc
        2^a * V^1 * y = V*(2^a*y) := by simp only [Nat.pow_one]; ac_rfl
        _ = V*(3*x+1) := by rw [←hf]
        _ ≤ x*(3*V+1) := hfactor
        _ = x*(3*V+1)^1 := by simp
  | @append x y z k s l t p q ihp ihq =>
      have endpoint : orbit x k = y := A2Header.physical_endpoint p
      have leftStay : StaysAbove x V k := by
        intro m hm
        exact stay m (by omega)
      have rightStay : StaysAbove y V l := by
        intro m hm
        have h := stay (k+m) (by omega)
        rw [orbit_add, endpoint] at h
        exact h
      have left := ihp leftStay
      have right := ihq rightStay
      calc
        2^(s+t)*V^(k+l)*z =
            (2^s*V^k)*(2^t*V^l*z) := by
              rw [Nat.pow_add, Nat.pow_add]
              ac_rfl
        _ ≤ (2^s*V^k)*(y*(3*V+1)^l) :=
              Nat.mul_le_mul_left _ right
        _ = (2^s*V^k*y)*(3*V+1)^l := by ac_rfl
        _ ≤ (x*(3*V+1)^k)*(3*V+1)^l :=
              Nat.mul_le_mul_right _ left
        _ = x*(3*V+1)^(k+l) := by
              rw [Nat.pow_add]
              ac_rfl

/-- A strict cumulative valuation surplus forces a physical checkpoint
below V at or before j. It makes no claim that the surplus appears. -/
theorem surplus_forces_crossing {x y j s V : Nat}
    (path : Physical x j s y)
    (surplus : x*(3*V+1)^j < 2^s*V^(j+1)) :
    ∃ m : Nat, m ≤ j ∧ orbit x m < V := by
  by_cases crossing : ∃ m : Nat, m ≤ j ∧ orbit x m < V
  · exact crossing
  have stay : StaysAbove x V j := by
    intro m hm
    by_cases h : V ≤ orbit x m
    · exact h
    · exact False.elim (crossing ⟨m, hm, by omega⟩)
  have bound := physical_product_bound path stay
  have endpoint : orbit x j = y := A2Header.physical_endpoint path
  have hy : V ≤ y := by
    have h := stay j (Nat.le_refl j)
    rw [endpoint] at h
    exact h
  have lower : 2^s*V^(j+1) ≤ 2^s*V^j*y := by
    calc
      2^s*V^(j+1) = (2^s*V^j)*V := by rw [Nat.pow_succ]; ac_rfl
      _ ≤ (2^s*V^j)*y := Nat.mul_le_mul_left _ hy
      _ = 2^s*V^j*y := by ac_rfl
  omega

/-- Historical interface: a crossing witnessed along a supplied physical
tail from P is on the same original orbit N. -/
theorem same_seed_crossing {N P V Z j0 s0 B j s : Nat}
    (fromN : Segment N P j0 s0 B)
    (tail : Physical P j s Z)
    (surplus : P*(3*V+1)^j < 2^s*V^(j+1)) :
    ∃ m : Nat, m ≤ j ∧ orbit N (j0+m) < V := by
  obtain ⟨m, hm, small⟩ := surplus_forces_crossing tail surplus
  have endpoint : orbit N j0 = P := A2Header.physical_endpoint fromN.physical
  refine ⟨m, hm, ?_⟩
  rw [orbit_add, endpoint]
  exact small

end CollatzCharacterBridge.A2MixedProgressCut
