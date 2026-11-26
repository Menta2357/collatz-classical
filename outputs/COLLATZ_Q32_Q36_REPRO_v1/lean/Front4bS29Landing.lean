import Front4bT61S3
import A2FirstCrossingFusion

namespace CollatzCharacterBridge.Front4bS29Landing

open A2U392 (seed)
open A2FirstCrossingFusion (Admitted Paid)
open Front4bT61S3 (checkpoint60 history60 index seed_affine)
open P5CompensationMeetings (Affine affine_admissible affine_edge)
open StagedCylinder (Segment compose)

set_option maxRecDepth 16000
set_option maxHeartbeats 400000

private def initial : Affine :=
  ⟨1156359581173680383779426258047,1267650600228229401496703205376⟩

private def checkpoint : Affine :=
  ⟨2474848360632909354224643722977,2713034129613837024914843724864⟩

private def intermediate : Affine :=
  ⟨1856136270474682015668482792233,2034775597210377768686132793648⟩

def landing : Affine :=
  ⟨1392102202856011511751362094175,1526081697907783326514599595236⟩

private theorem original (u : Nat) : seed (index (29+32*u))=initial.at u := by
  simp only [seed_affine,index,initial,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem from60 (u : Nat) : checkpoint60.at (29+32*u)=checkpoint.at u := by
  simp only [checkpoint60,checkpoint,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

/-- The original takes exactly two returns of valuation two from T60 to T62. -/
theorem history62 (u : Nat) :
    Segment (seed (index (29+32*u))) (landing.at u) 62 98 2417122598839266567112547605177 := by
  have lead := history60 (29+32*u)
  rw [from60] at lead
  have first : Segment (checkpoint.at u) (intermediate.at u) 1 2 1 :=
    affine_edge (by decide) u
  have second : Segment (intermediate.at u) (landing.at u) 1 2 1 :=
    affine_edge (by decide) u
  exact compose (compose lead first) second

/-- Every parameter in the cylinder activates the certified window reducer.
A residual still needs a producer at its own pivot. -/
theorem activates_wide (u : Nat) :
    let N := seed (index (29+32*u))
    let F := orbit N 60
    let V := orbit N 62
    Segment N V 62 98 2417122598839266567112547605177 ∧ N<V ∧ 4*V<5*N ∧ V<F ∧
      (Paid N ∨ ∃ x j S B, Admitted N x j S B ∧ x≤V ∧ 4*x<5*N ∧ x-N<F-N) := by
  let N := seed (index (29+32*u))
  let V := landing.at u
  let F := checkpoint.at u
  have hN : N=initial.at u := original u
  have big : 1<N := by
    rw [hN]
    simp only [initial,Affine.at]
    omega
  have small : N<V ∧ 4*V<5*N ∧ V<F := by
    rw [hN]
    simp only [V,F,initial,landing,checkpoint,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have hist := history62 u
  have histF := history60 (29+32*u)
  rw [from60] at histF
  have orbitV : orbit N 62=V := A2Header.physical_endpoint hist.physical
  have orbitF : orbit N 60=F := A2Header.physical_endpoint histF.physical
  have posOdd := affine_admissible (f := landing) (by decide) u
  have outcome : Paid N ∨
      ∃ x j S B, Admitted N x j S B ∧ x≤V ∧ 4*x<5*N ∧ x-N<F-N := by
    rcases A2CertifiedLanding.reduce_window_certified big hist posOdd.1 posOdd.2
        (by omega : V<2*N+1) with desc | meet | rem
    · exact Or.inl (Or.inl desc)
    · exact Or.inl (Or.inr meet)
    · obtain ⟨x,j,S,B,r,nle,bound,odd,wide,hr,histx,run,factor⟩ := rem
      exact Or.inr ⟨x,j,S,B,⟨nle,odd,wide,histx,r,hr,run,factor⟩,bound,
        by omega,Nat.sub_lt_sub_right nle (by omega)⟩
  change Segment N (orbit N 62) 62 98 2417122598839266567112547605177 ∧
    N<orbit N 62 ∧ 4*orbit N 62<5*N ∧ orbit N 62<orbit N 60 ∧ _
  rw [orbitV,orbitF]
  exact ⟨hist,small.1,small.2.1,small.2.2,outcome⟩

end CollatzCharacterBridge.Front4bS29Landing
