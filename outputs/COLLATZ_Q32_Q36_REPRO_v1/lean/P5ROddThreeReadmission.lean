import A2CertifiedLandingTrace

namespace CollatzCharacterBridge.P5ROddThreeReadmission

open A2Header (Physical)
open StagedCylinder (Segment compose)
open A2CertifiedLanding (Descended PaidMeeting)
open A2CertifiedLandingTrace (AssociatedRemaining reduce_window_with_trace)

set_option maxRecDepth 16000
set_option maxHeartbeats 1000000

/-- The s=3 branch has one exact edge on each side.  The source edge has
    valuation four; the original edge has the supplied actual valuation. -/
theorem s3_local {P Q a : Nat} (large : 1<P)
    (po : P%2=1) (qo : Q%2=1) (relation : Q+3=8*P)
    (valuation : a=2 ∨ a=3) (factor : 3*P+1=2^a*step P) :
    let H := step P
    let Q1 := (3*P-1)/2
    0<H ∧ H%2=1 ∧ H<P ∧ 0<Q1 ∧ Q1%2=1 ∧
      Segment P H 1 a 1 ∧ Segment Q Q1 1 4 1 ∧
      Q1+1=2^(a-1)*H := by
  have pp : 0<P := by omega
  have hp : 0<step P := step_pos _
  have ho : step P%2=1 := step_odd _
  have aa : 1≤a := by omega
  have main := P5R3S5.step_segment P a pp po aa factor
  have rank : step P<P := by
    rcases valuation with ha|ha
    · rw [ha] at factor
      change 3*P+1=4*step P at factor
      omega
    · rw [ha] at factor
      change 3*P+1=8*step P at factor
      omega
  have q1p : 0<(3*P-1)/2 := by omega
  have q1o : ((3*P-1)/2)%2=1 := by
    rcases valuation with ha|ha
    · rw [ha] at factor
      change 3*P+1=4*step P at factor
      omega
    · rw [ha] at factor
      change 3*P+1=8*step P at factor
      omega
  have sourceFactor : 3*Q+1=2^4*((3*P-1)/2) := by
    change 3*Q+1=16*((3*P-1)/2)
    omega
  have aux : Segment Q ((3*P-1)/2) 1 4 1 :=
    ⟨Physical.edge (by omega) qo q1p q1o (by decide) sourceFactor,
      sourceFactor.symm⟩
  have aligned : (3*P-1)/2+1=2^(a-1)*step P := by
    rcases valuation with ha|ha
    · rw [ha] at factor ⊢
      change 3*P+1=4*step P at factor
      change (3*P-1)/2+1=2*step P
      omega
    · rw [ha] at factor ⊢
      change 3*P+1=8*step P at factor
      change (3*P-1)/2+1=4*step P
      omega
  exact ⟨hp,ho,rank,q1p,q1o,main,aux,aligned⟩

/-- Each edge is appended to its own original history.  The paid source
    w and the seed N are unchanged, and the two clocks remain distinct. -/
theorem s3_histories {N w P Q a jN SN BN jw Sw Bw : Nat}
    (priced : 0<w ∧ w%2=1 ∧ w<N)
    (original : Segment N P jN SN BN) (source : Segment w Q jw Sw Bw)
    (large : 1<P) (po : P%2=1) (qo : Q%2=1) (relation : Q+3=8*P)
    (valuation : a=2 ∨ a=3) (factor : 3*P+1=2^a*step P) :
    let H := step P
    let Q1 := (3*P-1)/2
    0<H ∧ H%2=1 ∧ H<P ∧ 0<w ∧ w%2=1 ∧ w<N ∧
      Q1+1=2^(a-1)*H ∧
      Segment N H (jN+1) (SN+a) (3*BN+2^SN) ∧
      Segment w Q1 (jw+1) (Sw+4) (3*Bw+2^Sw) := by
  obtain ⟨hp,ho,rank,_,_,main,aux,aligned⟩ :=
    s3_local large po qo relation valuation factor
  have mainFull : Segment N (step P) (jN+1) (SN+a) (3*BN+2^SN) := by
    simpa only [Nat.pow_one,Nat.mul_one] using compose original main
  have sourceFull : Segment w ((3*P-1)/2) (jw+1) (Sw+4) (3*Bw+2^Sw) := by
    simpa only [Nat.pow_one,Nat.mul_one] using compose source aux
  exact ⟨hp,ho,rank,priced.1,priced.2.1,priced.2.2,aligned,mainFull,sourceFull⟩

/-- An A2 residual is explicitly associated with its entry at H.  Its
    pivot u is no larger than H, hence strictly smaller than the old P. -/
def RankedResidual (N P H j s B : Nat) : Prop :=
  ∃ u j' s' B' r m d D : Nat,
    N≤u ∧ u≤H ∧ u<P ∧ u-N<P-N ∧ u%2=1 ∧ u<2*N+1 ∧ 1≤r ∧
      Segment N u j' s' B' ∧ FixedSourceRun.Ones u r ∧
      3*orbit u r+1=4*orbit u (r+1) ∧
      Segment H u m d D ∧ j'=j+m ∧ s'=s+d ∧
      B'=3^m*B+2^s*D

theorem rank_associated {N P H j s B : Nat} (rank : H<P)
    (residual : AssociatedRemaining N H j s B) :
    RankedResidual N P H j s B := by
  obtain ⟨u,j',s',B',r,m,d,D,hN,hu,ho,hw,hr,hist,run,rupture,
    suffix,hj,hs,hB⟩ := residual
  exact ⟨u,j',s',B',r,m,d,D,hN,hu,by omega,by omega,ho,hw,hr,
    hist,run,rupture,suffix,hj,hs,hB⟩

/-- The window guard activates the sealed A2 producer.  The result is a
    real descent, a paid meeting, or a smaller, historically associated
    A2 residual.  No convergence IH or universal activation is assumed. -/
theorem s3_window_readmission {N w P Q a jN SN BN jw Sw Bw : Nat}
    (Nbig : 1<N) (priced : 0<w ∧ w%2=1 ∧ w<N)
    (original : Segment N P jN SN BN) (source : Segment w Q jw Sw Bw)
    (large : 1<P) (po : P%2=1) (qo : Q%2=1) (relation : Q+3=8*P)
    (valuation : a=2 ∨ a=3) (factor : 3*P+1=2^a*step P)
    (height : step P<2*N+1) :
    let H := step P
    let Q1 := (3*P-1)/2
    H<P ∧ 0<w ∧ w%2=1 ∧ w<N ∧ Q1+1=2^(a-1)*H ∧
      Segment N H (jN+1) (SN+a) (3*BN+2^SN) ∧
      Segment w Q1 (jw+1) (Sw+4) (3*Bw+2^Sw) ∧
      (Descended N ∨ PaidMeeting N ∨
        RankedResidual N P H (jN+1) (SN+a) (3*BN+2^SN)) := by
  obtain ⟨hp,ho,rank,wp,wo,wn,aligned,main,aux⟩ :=
    s3_histories priced original source large po qo relation valuation factor
  refine ⟨rank,wp,wo,wn,aligned,main,aux,?_⟩
  rcases reduce_window_with_trace Nbig main hp ho height with hd|hm|hr
  · exact Or.inl hd
  · exact Or.inr (Or.inl hm)
  · exact Or.inr (Or.inr (rank_associated rank hr))

#print axioms s3_local
#print axioms s3_histories
#print axioms RankedResidual
#print axioms rank_associated
#print axioms s3_window_readmission

end CollatzCharacterBridge.P5ROddThreeReadmission
