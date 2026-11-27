import Front4bWeakTwo

namespace CollatzCharacterBridge.Front4bWeakTwo

open Front4bRowEven (originalSeed originalCost)

private def base : Nat := 101146623620375911257962522224411
private def slope : Nat := 185418926295795674171523850821174

private theorem mod8 (t : Nat) : terminal3 t%8=(3+(6*(t%8))%8)%8 := by
  change (base+slope*t)%8=_
  rw [Nat.add_mod base (slope*t) 8,Nat.mul_mod slope t 8]
  rfl

private theorem mod32 (t : Nat) : terminal3 t%32=(27+(22*(t%32))%32)%32 := by
  change (base+slope*t)%32=_
  rw [Nat.add_mod base (slope*t) 32,Nat.mul_mod slope t 32]
  rfl

private theorem twoOnesResidue {Z Y U : Nat} (first : 3*Z+1=2*Y)
    (second : 3*Y+1=2*U) (odd : U%2=1) : Z%8=7 := by omega

private theorem oneTwoOneResidue {Z Y U X : Nat} (first : 3*Z+1=2*Y)
    (second : 3*Y+1=4*U) (third : 3*U+1=2*X) (odd : X%2=1) : Z%32=27 := by omega

private theorem twoOnesTable :
    ∀ r : Fin 8, (3+(6*r.val)%8)%8=7 → r.val%4=2 := by decide

private theorem oneTwoOneTable :
    ∀ r : Fin 32, (27+(22*r.val)%32)%32=27 → r.val%16=0 := by decide

/-- The physical weak prefixes leave just two explicit u-residues. -/
theorem weak3Residues (t : Nat)
    (weak : Weak3 (originalSeed (parameter3 t)) (terminal3 t) (originalCost 5 251)) :
    t%4=2 ∨ t%16=0 := by
  obtain ⟨first,tail⟩ := weak
  have f : 3*terminal3 t+1=2*step (terminal3 t) := first
  rcases tail with ⟨second,_⟩ | ⟨second,third,_⟩
  · have s : 3*step (terminal3 t)+1=2*step (step (terminal3 t)) := second
    have z := twoOnesResidue f s (step_odd (step (terminal3 t)))
    rw [mod8] at z
    have row := twoOnesTable ⟨t%8,Nat.mod_lt _ (by decide)⟩ z
    have h : (t%8)%4=t%4 := Nat.mod_mod_of_dvd t (by decide : 4∣8)
    exact Or.inl (h.symm.trans row)
  · have s : 3*step (terminal3 t)+1=4*step (step (terminal3 t)) := second
    have th : 3*step (step (terminal3 t))+1=2*step (step (step (terminal3 t))) := third
    have z := oneTwoOneResidue f s th (step_odd (step (step (terminal3 t))))
    rw [mod32] at z
    have row := oneTwoOneTable ⟨t%32,Nat.mod_lt _ (by decide)⟩ z
    have h : (t%32)%16=t%16 := Nat.mod_mod_of_dvd t (by decide : 16∣32)
    exact Or.inr (h.symm.trans row)

end CollatzCharacterBridge.Front4bWeakTwo

#print axioms CollatzCharacterBridge.Front4bWeakTwo.weak3Residues
