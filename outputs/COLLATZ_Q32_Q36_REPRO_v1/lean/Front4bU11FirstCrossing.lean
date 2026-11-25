import Front4bS29Landing
import Front4bBoundedProducer

namespace CollatzCharacterBridge.Front4bU11FirstCrossing

open A2U392 (seed)
open A2FirstCrossingFusion (Paid)
open Front4bBoundedProducer (BoundedAdmitted)
open Front4bT61S3 (index seed_affine)
open P5CompensationMeetings (Affine affine_admissible affine_edge)
open StagedCylinder (Segment compose)

private def start : Affine :=
  ⟨18179000879841628103411957641771,24417307166524533224233593523776⟩

private def first : Affine :=
  ⟨27268501319762442155117936462657,36625960749786799836350390285664⟩

private def second : Affine :=
  ⟨20451375989821831616338452346993,27469470562340099877262792714248⟩

private def third : Affine :=
  ⟨15338531992366373712253839260245,20602102921755074907947094535686⟩

theorem crosses_t65 (t : Nat) :
    let N := seed (index (29+32*(11+16*t)))
    let V := orbit N 62
    let Q := orbit N 65
    V<orbit N 63 ∧ V<orbit N 64 ∧ N<Q ∧ Q<V ∧
    Segment V Q 3 5 23 ∧ Segment N Q 65 103 72551301119972516370644828770691 ∧
    (Paid N ∨ ∃ x j S B, x<V ∧ BoundedAdmitted N V x j S B) := by
  let N := seed (index (29+32*(11+16*t)))
  have prefix62 := Front4bS29Landing.history62 (11+16*t)
  have coord62 : Front4bS29Landing.landing.at (11+16*t)=start.at t := by
    simp only [Front4bS29Landing.landing,start,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [coord62] at prefix62
  have edge63 : Segment (start.at t) (first.at t) 1 1 1 := affine_edge (by decide) t
  have edge64 : Segment (first.at t) (second.at t) 1 2 1 := affine_edge (by decide) t
  have edge65 : Segment (second.at t) (third.at t) 1 2 1 := affine_edge (by decide) t
  have tail : Segment (start.at t) (third.at t) 3 5 23 := compose (compose edge63 edge64) edge65
  have prefix63 := compose prefix62 edge63
  have prefix64 := compose prefix63 edge64
  have prefix65 : Segment N (third.at t) 65 103 72551301119972516370644828770691 :=
    compose prefix62 tail
  have order : 1<N ∧ N<third.at t ∧ third.at t<start.at t ∧
      start.at t<first.at t ∧ start.at t<second.at t ∧ third.at t<2*N+1 := by
    simp only [N,seed_affine,index,start,first,second,third,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  rcases order with ⟨big,above,below,rise1,rise2,window⟩
  have admissible := affine_admissible (f := third) (by decide) t
  have outcome : Paid N ∨ ∃ x j S B, x<start.at t ∧
      BoundedAdmitted N (start.at t) x j S B := by
    rcases A2CertifiedLanding.reduce_window_certified big prefix65 admissible.1 admissible.2
      window with h | h | h
    · exact Or.inl (Or.inl h)
    · exact Or.inl (Or.inr h)
    · have strict := A2BoundedReducer.remaining_strict h below
      obtain ⟨x,j,S,B,lower,_,state⟩ := Front4bBoundedProducer.next_bounded_rank
        (Nat.le_refl (start.at t)) strict
      exact Or.inr ⟨x,j,S,B,lower,state⟩
  change orbit N 62<orbit N 63 ∧ orbit N 62<orbit N 64 ∧ N<orbit N 65 ∧
    orbit N 65<orbit N 62 ∧ Segment (orbit N 62) (orbit N 65) 3 5 23 ∧
    Segment N (orbit N 65) 65 103 72551301119972516370644828770691 ∧ _
  rw [A2Header.physical_endpoint prefix62.physical,
    A2Header.physical_endpoint prefix63.physical,
    A2Header.physical_endpoint prefix64.physical,
    A2Header.physical_endpoint prefix65.physical]
  exact ⟨rise1,rise2,above,below,tail,prefix65,outcome⟩

end CollatzCharacterBridge.Front4bU11FirstCrossing
