import CRTWordSegment
import A2CertifiedLanding

namespace CollatzCharacterBridge.AB9T3Adapter

open A2CertifiedLanding (PaidMeeting)
open A2SecondSwitchWordCompiler (ValWord cost total)
open CRTWordSegment (crt_word_segment initial_terminal)
open StagedCylinder (Segment)

set_option maxRecDepth 32000

inductive Route where
  | r0 | r3 | r6
  deriving DecidableEq, Repr

structure Row where
  modulus : Nat
  residue : Nat
  multiplier : Nat
  subtract : Nat
  word : List Nat

def row : Route → Row
  | .r0 => ⟨59049, 1858, 32768, 42921, [1,1,1,1,1,1,1,2,1,4,1,1,3]⟩
  | .r3 => ⟨19683, 9883, 16384, 11235, [1,1,1,1,1,1,1,2,4,1,1,3]⟩
  | .r6 => ⟨4782969, 3007528, 4194304, 2669433, [1,1,1,1,1,1,1,1,1,1,1,1,1,8,1,1,3]⟩

def seed (t : Nat) : Nat := 2^64 * (177+512*t) - 5

def guard (route : Route) (t : Nat) : Prop :=
  t % (row route).modulus = (row route).residue

instance (route : Route) (t : Nat) : Decidable (guard route t) :=
  inferInstanceAs (Decidable (t % (row route).modulus = (row route).residue))

def select (t : Nat) : Option Route :=
  if guard .r0 t then some .r0
  else if guard .r3 t then some .r3
  else if guard .r6 t then some .r6
  else none

private theorem residue_mod9 (route : Route) {t : Nat} (active : guard route t) :
    t%9 = (row route).residue%9 := by
  have divides : 9 ∣ (row route).modulus := by cases route <;> decide
  rw [←Nat.mod_mod_of_dvd t divides, show t % (row route).modulus = _ from active]

private theorem unique_route {r s : Route} {t : Nat} (hr : guard r t) (hs : guard s t) : r=s := by
  have same := (residue_mod9 r hr).symm.trans (residue_mod9 s hs)
  cases r <;> cases s <;> first | rfl | contradiction

theorem select_iff_guard (route : Route) (t : Nat) :
    select t = some route ↔ guard route t := by
  unfold select
  split
  · rename_i hit
    exact ⟨fun same => (Option.some.inj same) ▸ hit, fun h => congrArg some (unique_route hit h)⟩
  · rename_i miss0
    split
    · rename_i hit
      exact ⟨fun same => (Option.some.inj same) ▸ hit, fun h => congrArg some (unique_route hit h)⟩
    · rename_i miss3
      split
      · rename_i hit
        exact ⟨fun same => (Option.some.inj same) ▸ hit, fun h => congrArg some (unique_route hit h)⟩
      · rename_i miss6
        exact ⟨by intro impossible; contradiction, fun hit => by cases route <;> contradiction⟩

private def originalWord : List Nat := [1,2,1]

private def sourceBase (r : Row) : Nat := (r.multiplier * seed r.residue - r.subtract) / r.modulus

private theorem valid_word {word : List Nat}
    (check : word.all (fun a => decide (1≤a))=true) : ValWord word := by
  intro a ha
  exact of_decide_eq_true ((List.all_eq_true.mp check) a ha)

private theorem seed_affine (t : Nat) : seed t=seed 0+2^73*t := by
  simp only [seed,Nat.mul_add,←Nat.mul_assoc,Nat.mul_zero,Nat.add_zero]
  omega

private theorem seed_shift (a d h : Nat) : seed (a+d*h)=seed a+2^73*d*h := by
  rw [seed_affine (a+d*h),seed_affine a]
  simp only [Nat.mul_add,←Nat.mul_assoc,Nat.add_assoc]

private theorem even_slope (a h : Nat) : (2^73*a*h)%2=0 := by
  have divides : 2 ∣ (2:Nat)^73 := by decide
  exact Nat.mod_eq_zero_of_dvd (Nat.dvd_mul_right_of_dvd (Nat.dvd_mul_right_of_dvd divides a) h)

private structure Checked (r : Row) : Prop where
  n_pos : 0<seed r.residue
  n_odd : seed r.residue % 2=1
  source_pos : 0<sourceBase r
  source_odd : sourceBase r%2=1
  price_base : sourceBase r<seed r.residue
  price_slope : r.multiplier≤r.modulus
  factor_base : r.modulus*sourceBase r+r.subtract=r.multiplier*seed r.residue
  valuations : r.word.all (fun a => decide (1≤a))=true
  n_crt : (3^originalWord.length*seed r.residue+cost originalWord)%2^(total originalWord+1)=2^total originalWord
  w_crt : (3^r.word.length*sourceBase r+cost r.word)%2^(total r.word+1)=2^total r.word
  terminal_base : initial_terminal originalWord (seed r.residue)=initial_terminal r.word (sourceBase r)
  source_slope : 2^(total r.word+1)*2^68=2^73*r.multiplier
  length_factor : 3^r.word.length=27*r.modulus

private theorem checked (route : Route) : Checked (row route) := by
  cases route <;> constructor <;> decide

/-- Both exact physical histories witness the meeting at the third odd return.
    The selected row keeps its original auxiliary valuation word and cost. -/
theorem guard_meeting (route : Route) (t : Nat) (active : guard route t) :
    ∃ w Y, 0<w ∧ w%2=1 ∧ w<seed t ∧
      (row route).modulus*w+(row route).subtract=(row route).multiplier*seed t ∧
      Segment (seed t) Y 3 4 23 ∧
      Segment w Y (row route).word.length (total (row route).word) (cost (row route).word) ∧
      orbit (seed t) 3 = orbit w (row route).word.length ∧ PaidMeeting (seed t) := by
  let r := row route
  let h := t/r.modulus
  have c : Checked r := checked route
  have t_eq : r.residue+r.modulus*h=t := by
    exact (show t%r.modulus=r.residue from active) ▸ Nat.mod_add_div t r.modulus
  have n_eq : seed t=seed r.residue+2^73*r.modulus*h := by
    rw [←t_eq,seed_shift]
  let w := sourceBase r+2^73*r.multiplier*h
  let Y := initial_terminal originalWord (seed r.residue)+54*(r.modulus*2^68*h)
  have original : Segment (seed t) Y 3 4 23 := by
    rw [n_eq]
    have seg := crt_word_segment originalWord c.n_pos c.n_odd (valid_word (by decide))
      c.n_crt (r.modulus*2^68*h)
    change Segment (seed r.residue+2^5*(r.modulus*2^68*h)) Y 3 4 23 at seg
    have scale : 2^5*(r.modulus*2^68*h)=2^73*r.modulus*h := calc
      _ = (2^5*2^68)*r.modulus*h := by ac_rfl
      _ = _ := rfl
    simpa only [scale] using seg
  have yw : Y=initial_terminal r.word (sourceBase r)+2*3^r.word.length*(2^68*h) := by
    change initial_terminal originalWord (seed r.residue)+54*(r.modulus*2^68*h)=_
    rw [c.terminal_base,c.length_factor]
    simp only [←Nat.mul_assoc]
  have source : Segment w Y r.word.length (total r.word) (cost r.word) := by
    have seg := crt_word_segment r.word c.source_pos c.source_odd (valid_word c.valuations)
      c.w_crt (2^68*h)
    rw [←yw,←Nat.mul_assoc,c.source_slope] at seg
    exact seg
  have posw : 0<w := Nat.lt_of_lt_of_le c.source_pos (Nat.le_add_right ..)
  have oddw : w%2=1 := by
    rw [show w=sourceBase r+2^73*r.multiplier*h from rfl,
      Nat.add_mod,c.source_odd,even_slope]
  have below : w<seed t := by
    rw [n_eq]
    exact Nat.add_lt_add_of_lt_of_le c.price_base
      (Nat.mul_le_mul_right h (Nat.mul_le_mul_left (2^73) c.price_slope))
  have factor : r.modulus*w+r.subtract=r.multiplier*seed t := by
    simp only [w,n_eq,Nat.mul_add]
    calc
      _ = (r.modulus*sourceBase r+r.subtract)+r.multiplier*(2^73*r.modulus*h) := by ac_rfl
      _ = _ := by rw [c.factor_base]
  have endN := A2Header.physical_endpoint original.physical
  have endW := A2Header.physical_endpoint source.physical
  have posN : 0<seed t := by rw [n_eq]; exact Nat.lt_of_lt_of_le c.n_pos (Nat.le_add_right ..)
  have oddN : seed t%2=1 := by
    rw [n_eq,Nat.add_mod,c.n_odd,even_slope]
  have posY : 0<Y := endN ▸ orbit_pos (seed t) posN 3
  have oddY : Y%2=1 := endN ▸ orbit_odd (seed t) oddN 3
  have paid : PaidMeeting (seed t) :=
    ⟨w,Y,3,4,23,r.word.length,total r.word,cost r.word,
      posw,oddw,below,posY,oddY,original,source⟩
  exact ⟨w,Y,posw,oddw,below,factor,original,source,endN.trans endW.symm,paid⟩

theorem union_paid (t : Nat) (active : guard .r0 t ∨ guard .r3 t ∨ guard .r6 t) :
    PaidMeeting (seed t) := by
  have pay : ∀ r, guard r t → PaidMeeting (seed t) := by
    intro r hit
    obtain ⟨_,_,_,_,_,_,_,_,_,paid⟩ := guard_meeting r t hit
    exact paid
  rcases active with h0|h3|h6
  · exact pay .r0 h0
  · exact pay .r3 h3
  · exact pay .r6 h6

end CollatzCharacterBridge.AB9T3Adapter
