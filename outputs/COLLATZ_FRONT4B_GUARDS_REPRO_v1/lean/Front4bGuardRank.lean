import Front4bWeakTwo

namespace CollatzCharacterBridge.Front4bGuardRank

open Front4bRowEven (pivot)
open Front4bWeakTwo (parameter3 parameter5 terminal3 terminal5 trace3 trace5)

private theorem lessAtPivot {V Z X : Nat} {a b : Nat}
    (coefficient : 4*a<3*b) (pos : 0<V)
    (history : a*Z=b*V+X) (next : 3*Z+1=4*step Z) :
    V<step Z := by
  have balance : 4*a*step Z=3*b*V+3*X+a := by
    calc
      _ = a*(4*step Z) := by ac_rfl
      _ = 3*(a*Z)+a := by rw [←next,Nat.mul_add]; simp only [Nat.mul_one]; ac_rfl
      _ = _ := by rw [history,Nat.mul_add,Nat.mul_assoc 3 b V]
  have larger : 4*a*V<3*b*V := Nat.mul_lt_mul_of_pos_right coefficient pos
  exact Nat.lt_of_mul_lt_mul_left (a:=4*a) (by omega)

/-- A two after the initial weak-two terminal crosses below that terminal,
but its immediate endpoint still lies above the earlier pivot. -/
theorem afterTwoAbovePivot3 (t : Nat) (next : 3*terminal3 t+1=4*step (terminal3 t)) :
    pivot (parameter3 t)<step (terminal3 t) := by
  have segment := (trace3 t).1
  have history : 128*terminal3 t=243*pivot (parameter3 t)+251 := segment.2
  have positive : 0<pivot (parameter3 t) := by
    simp [pivot, Front4bS29Landing.landing, P5CompensationMeetings.Affine.at] <;> omega
  exact lessAtPivot (a:=128) (b:=243) (by decide) positive history next

theorem afterTwoAbovePivot5 (t : Nat) (next : 3*terminal5 t+1=4*step (terminal5 t)) :
    pivot (parameter5 t)<step (terminal5 t) := by
  have segment := (trace5 t).1
  have history : 512*terminal5 t=729*pivot (parameter5 t)+977 := segment.2
  have positive : 0<pivot (parameter5 t) := by
    simp [pivot, Front4bS29Landing.landing, P5CompensationMeetings.Affine.at] <;> omega
  exact lessAtPivot (a:=512) (b:=729) (by decide) positive history next

end CollatzCharacterBridge.Front4bGuardRank

#print axioms CollatzCharacterBridge.Front4bGuardRank.afterTwoAbovePivot3
#print axioms CollatzCharacterBridge.Front4bGuardRank.afterTwoAbovePivot5
