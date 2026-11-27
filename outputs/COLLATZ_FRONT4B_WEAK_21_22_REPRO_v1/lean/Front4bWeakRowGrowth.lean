import Front4bWeakReentry
import Front4bWeakRows

namespace CollatzCharacterBridge.Front4bWeakRowGrowth

open Front4bWeakRows (Witness band3 band5)
open Front4bGuardRun (entry3)
open Front4bRowEven (originalSeed pivot originalCost)

def CofactorGrowth (J L : Nat) : Prop :=
  ∃ q v, q%2=1 ∧ v%2=1 ∧ J+1=2^(L+1)*q ∧ orbit J (L+2)+1=8*v ∧ q<v

private theorem growthOfWitness {N V J j S C L b : Nat}
    (many : 2≤L) (branch : b=1 ∨ b=2) (sample : Witness N V J j S C L b 2) :
    CofactorGrowth J L := by
  obtain ⟨q,v,qo,vo,initial,next⟩ := sample.factors
  exact ⟨q,v,qo,vo,initial,next,
    Front4bWeakReentry.growsAtTwo many branch (by omega) sample.weak initial next⟩

/-- Exact short readmissions with growing cofactors occur in both physical
Front4b bands, for either weak pair and every initial run length L≥2. -/
theorem bothBands {L b : Nat} (many : 2≤L) (branch : b=1 ∨ b=2) :
    (∃ t, Witness (originalSeed (18+32*t)) (pivot (18+32*t)) (entry3.at t)
        65 102 (originalCost 3 19) L b 2 ∧ CofactorGrowth (entry3.at t) L) ∧
    (∃ t, Witness (originalSeed (10+128*t)) (pivot (10+128*t)) (Front4bE1.entry5.at t)
        66 104 (originalCost 4 73) L b 2 ∧ CofactorGrowth (Front4bE1.entry5.at t) L) := by
  obtain ⟨t,original⟩ := band3 many branch 2
  obtain ⟨u,second⟩ := band5 many branch 2
  exact ⟨⟨t,original,growthOfWitness many branch original⟩,
    ⟨u,second,growthOfWitness many branch second⟩⟩

end CollatzCharacterBridge.Front4bWeakRowGrowth

#print axioms CollatzCharacterBridge.Front4bWeakRowGrowth.bothBands
