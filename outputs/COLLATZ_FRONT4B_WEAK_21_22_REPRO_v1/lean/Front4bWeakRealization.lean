import Front4bWeakRank

namespace CollatzCharacterBridge.Front4bWeakRealization

open FixedSourceRun (Ones)
open Front4bWeakRank

set_option maxRecDepth 10000
set_option maxHeartbeats 800000

private theorem threeOdd (k : Nat) : 3^k%2=1 := by
  induction k with
  | zero => decide
  | succ k ih => rw [Nat.pow_succ,Nat.mul_mod,ih]

private theorem powerEven {k : Nat} (pos : 0<k) : 2^k%2=0 := by
  cases k with
  | zero => omega
  | succ k => rw [Nat.pow_succ,Nat.mul_mod]; simp

/-- A single affine identity with odd endpoint and odd entry cofactor
realizes both exact weak valuations after the run of ones. -/
theorem weakRankOfFactors {J L b Q Z : Nat}
    (many : 2≤L) (weak : b=1 ∨ b=2) (qo : Q%2=1) (zo : Z%2=1)
    (entry : J+1=2^(L+1)*Q) (terminal : 3^(L+2)*Q=1+2^(b+1)*Z) :
    WeakRank J L b ∧ orbit J (L+2)=Z := by
  have qp : 0<Q := by omega
  have zp : 0<Z := by omega
  have jp : 0<J := by
    have base : 2≤2^(L+1) := Nat.pow_le_pow_right (by decide : 0<(2:Nat))
      (show 1≤L+1 by omega)
    have prod := Nat.mul_le_mul_right (2^(L+1)) (show 1≤Q by omega)
    rw [Nat.one_mul,Nat.mul_comm Q] at prod
    omega
  have jo : J%2=1 := by
    have h := congrArg (fun x : Nat => x%2) entry
    simp only [Nat.mul_mod (2^(L+1)) Q, powerEven (by omega : 0<L+1),
      Nat.zero_mul,Nat.zero_mod] at h
    omega
  have entryExact : J=2^(L+1)*Q-1 := by omega
  have ⟨atL,run⟩ := FixedSourceRun.ones_prefix L Q qp
  rw [←entryExact] at atL run
  let Y := 3^(L+1)*Q
  let F := (Y-1)/2
  have yp : 0<Y := Nat.mul_pos (Nat.pow_pos (by decide : 0<(3:Nat))) qp
  have yo : Y%2=1 := by
    change (3^(L+1)*Q)%2=1
    rw [Nat.mul_mod,threeOdd,qo]
  have YF : Y=2*F+1 := by dsimp only [F]; omega
  have after : 3*Y=1+(2^b*Z)*2 := by
    calc
      3*Y=3^(L+2)*Q := by rw [Nat.pow_succ]; dsimp only [Y]; ac_rfl
      _=1+2^(b+1)*Z := terminal
      _=1+(2^b*Z)*2 := by rw [Nat.pow_succ]; ac_rfl
  have factor2 : 3*F+1=2^b*Z := by omega
  have factor2Even : (2^b*Z)%2=0 := by
    rw [Nat.mul_mod,powerEven (show 0<b by omega)]; simp
  have fo : F%2=1 := by
    have h := congrArg (fun x : Nat => x%2) factor2
    change (3*F+1)%2=(2^b*Z)%2 at h
    rw [factor2Even] at h
    omega
  have fp : 0<F := by omega
  have firstFactor : 3*orbit J L+1=4*F := by
    have yp' : 0<3^L*Q := Nat.mul_pos (Nat.pow_pos (by decide : 0<(3:Nat))) qp
    have scale : Y=3*(3^L*Q) := by dsimp only [Y]; rw [Nat.pow_succ]; ac_rfl
    rw [atL,Nat.mul_assoc 2]
    omega
  have firstEdge : A2Header.Physical (orbit J L) 1 2 F :=
    A2Header.Physical.edge (orbit_pos J jp _) (orbit_odd J jo _) fp fo (by decide : 0<(2:Nat)) firstFactor
  have secondEdge : A2Header.Physical F 1 b Z :=
    A2Header.Physical.edge fp fo zp zo (by omega) factor2
  have atF : orbit J (L+1)=F := by
    rw [orbit_add,A2Header.physical_endpoint firstEdge]
  have atZ : orbit J (L+2)=Z := by
    rw [show L+2=(L+1)+1 by omega,orbit_add,atF,A2Header.physical_endpoint secondEdge]
  rw [←atF] at firstFactor factor2
  rw [←atZ] at factor2
  exact ⟨weakRank jo many weak run firstFactor factor2,atZ⟩

/-- For any odd affine progression of cofactors, either weak pair can
be preceded by any L≥2 ones and followed by at least H ones. -/
theorem realizesOnesWeakOnes {A a : Nat} (oddSlope : a%2=1)
    {L b : Nat} (many : 2≤L) (weak : b=1 ∨ b=2) (H : Nat) :
    ∃ t, let J := 8*(A+a*t)-1
         WeakRank J L b ∧ Ones (orbit J (L+2)) H ∧
         ∃ Q Q', Q%2=1 ∧ Q'%2=1 ∧
           J+1=2^(L+1)*Q ∧ orbit J (L+2)+1=2^(H+1)*Q' := by
  let T := 1+2^(b+1)*(2^(H+1)-1)
  let M := (b+1)+(H+2)
  let C := 3^(L+2)
  have Codd : C%2=1 := threeOdd _
  have Tpar : T%2=1 := by
    dsimp only [T]
    rw [Nat.add_mod,Nat.mul_mod,powerEven (by omega : 0<b+1)]
    simp
  have Mpos : 0<M := by dsimp only [M]; omega
  obtain ⟨Q₀,R₀,base⟩ := oddAffineLift Codd 0 T M
  rw [Nat.zero_add] at base
  have Q₀odd : Q₀%2=1 := by
    have eq := congrArg (fun x : Nat => x%2) base
    change (C*Q₀)%2=(T+2^M*R₀)%2 at eq
    simpa [Nat.add_mod,Nat.mul_mod,Codd,Tpar,powerEven Mpos] using eq
  let K := L-2
  have length : L+1=3+K := by dsimp only [K]; omega
  obtain ⟨t,q,lift⟩ := oddAffineLift oddSlope A (2^K*Q₀) (K+M)
  let Q := Q₀+2^M*q
  let R := R₀+C*q
  have Aq : A+a*t=2^K*Q := by
    rw [lift,Nat.pow_add]
    simp only [Q,Nat.mul_add,Nat.mul_assoc]
  have qo : Q%2=1 := by
    simp [Q,Nat.add_mod,Nat.mul_mod,Q₀odd,powerEven Mpos]
  have Jfactor : (8*(A+a*t)-1)+1=2^(L+1)*Q := by
    rw [Aq,length,Nat.pow_add]
    have positive := Nat.mul_pos (Nat.pow_pos (by decide : 0<(2:Nat)) : 0<2^K)
      (show 0<Q by omega)
    have scaled := Nat.mul_pos (by decide : 0<(8:Nat)) positive
    simp only [show (2:Nat)^3=8 by decide,Nat.mul_assoc]
    omega
  have target : C*Q=T+2^M*R := by
    simp only [Q,R,Nat.mul_add,base]
    ac_rfl
  let Q' := 2*R+1
  let Z := 2^(H+1)*Q'-1
  have qp' : 0<Q' := by dsimp only [Q']; omega
  have zp : 0<2^(H+1)*Q' := Nat.mul_pos (Nat.pow_pos (by decide : 0<(2:Nat))) qp'
  have final : C*Q=1+2^(b+1)*Z := by
    have p : 0<2^(H+1) := Nat.pow_pos (by decide : 0<(2:Nat))
    have z : Z=(2^(H+1)-1)+2^(H+2)*R := by
      dsimp only [Z,Q']
      rw [Nat.mul_add,Nat.mul_one,show (2:Nat)^(H+2)=2^(H+1)*2 by exact Nat.pow_succ _ _,
        Nat.mul_assoc (2^(H+1))]
      omega
    rw [target,show (2:Nat)^M=2^(b+1)*2^(H+2) by exact Nat.pow_add _ _ _]
    simp only [z,T,Nat.mul_add,Nat.mul_assoc,Nat.add_assoc]
  have zo : Z%2=1 := by
    have even : (2^(H+1)*Q')%2=0 := by
      rw [Nat.mul_mod,powerEven (by omega : 0<H+1)]; simp
    dsimp only [Z]
    omega
  obtain ⟨phys,atZ⟩ := weakRankOfFactors many weak qo zo Jfactor final
  have more := (FixedSourceRun.ones_prefix H Q' qp').2
  refine ⟨t,phys,?_,Q,Q',qo,by dsimp only [Q']; omega,Jfactor,?_⟩
  · rw [atZ]
    exact more
  · rw [atZ]
    dsimp only [Z]
    omega

end CollatzCharacterBridge.Front4bWeakRealization

#print axioms CollatzCharacterBridge.Front4bWeakRealization.weakRankOfFactors
#print axioms CollatzCharacterBridge.Front4bWeakRealization.realizesOnesWeakOnes
