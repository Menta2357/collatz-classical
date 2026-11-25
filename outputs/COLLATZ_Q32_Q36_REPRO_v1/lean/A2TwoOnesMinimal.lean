import P5R3S5

namespace CollatzCharacterBridge.A2TwoOnesMinimal

open StagedCylinder (Segment compose)

set_option maxHeartbeats 180000

private theorem lower_factor {w y a b : Nat} (hab : a≤b)
    (physical : 3*w+1=2^b*y) : 2^a*y≤3*w+1 := by
  rw [physical]
  exact Nat.mul_le_mul_right y (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) hab)

/-- If the two-one source is at least two thirds of the price cap,
every paid source of depth at most two must be that source at depth two. -/
theorem two_ones_unique {N z X Y : Nat}
    (zp : 0<z) (zo : z%2=1) (xo : X%2=1) (yo : Y%2=1)
    (height : 2*N≤3*z)
    (first : 3*z+1=2*X) (second : 3*X+1=2*Y) :
    Segment z Y 2 2 5 ∧
      ∀ w d : Nat, 0<w → w%2=1 → w<N → d≤2 → orbit w d=Y →
        d=2 ∧ w=z := by
  have xp : 0<X := by omega
  have yp : 0<Y := by omega
  have xlarge : N<X := by omega
  have ylarge : N<Y := by omega
  have p : Segment z X 1 1 1 :=
    ⟨A2Header.Physical.edge zp zo xp xo (by decide) (by simpa using first),
      by simpa using first.symm⟩
  have q : Segment X Y 1 1 1 :=
    ⟨A2Header.Physical.edge xp xo yp yo (by decide) (by simpa using second),
      by simpa using second.symm⟩
  refine ⟨compose p q, ?_⟩
  intro w d wp wo paid short hit
  have cases_d : d=0 ∨ d=1 ∨ d=2 := by omega
  rcases cases_d with rfl | rfl | rfl
  · change w=Y at hit
    omega
  · change step w=Y at hit
    obtain ⟨a,apos,aedge⟩ := P5R3S5.actual_step_factor w wo
    rw [hit] at aedge
    have lower : 2*Y≤3*w+1 := by simpa using lower_factor apos aedge
    omega
  · let M := step w
    change step M=Y at hit
    obtain ⟨b,bpos,bedge⟩ := P5R3S5.actual_step_factor M (step_odd w)
    obtain ⟨a,apos,aedge⟩ := P5R3S5.actual_step_factor w wo
    change 3*w+1=2^a*M at aedge
    rw [hit] at bedge
    have mlow : 2*M≤3*w+1 := by simpa using lower_factor apos aedge
    have bone : b=1 := by
      by_cases h : b=1
      · exact h
      · have lower : 4*Y≤3*M+1 := by
          simpa using lower_factor (by omega : 2≤b) bedge
        omega
    have mx : M=X := by
      rw [bone,Nat.pow_one] at bedge
      omega
    rw [mx] at aedge
    have aone : a=1 := by
      by_cases h : a=1
      · exact h
      · have lower : 4*X≤3*w+1 := by
          simpa using lower_factor (by omega : 2≤a) aedge
        omega
    rw [aone,Nat.pow_one] at aedge
    exact ⟨rfl,by omega⟩

end CollatzCharacterBridge.A2TwoOnesMinimal
