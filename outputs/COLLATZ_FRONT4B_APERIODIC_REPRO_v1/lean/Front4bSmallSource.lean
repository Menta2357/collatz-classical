import Front4bGuardRun
import Front4bSwitchedRows
import Front4bWeakReentry

namespace CollatzCharacterBridge.Front4bSmallSource

open StagedCylinder (Segment compose)
open Front4bRowEven (originalSeed originalSeedFormula)
open P5CompensationMeetings (Affine)

set_option maxRecDepth 16000
set_option maxHeartbeats 1200000

/-- Source histories whose exact valuations are all 1 or 2. -/
inductive SmallBook (w : Nat) : Nat → Nat → Nat → Nat → Prop where
  | nil : SmallBook w w 0 0 0
  | append {x y h s C a : Nat} (start : SmallBook w x h s C) (small : a=1 ∨ a=2)
      (edge : Segment x y 1 a 1) :
      SmallBook w y (h+1) (s+a) (3*C+2^s)

theorem toSegment {w x h s C : Nat} (path : SmallBook w x h s C) :
    Segment w x h s C := by
  induction path with
  | nil => exact ⟨A2Header.Physical.refl w,by simp⟩
  | append start small edge ih => simpa using compose ih edge

def Excluded (N z : Nat) : Prop :=
  ∀ w h s C, SmallBook w z h s C → N≤w

private theorem predecessorUnique {x y z a b : Nat} (left : a=1 ∨ a=2) (right : b=1 ∨ b=2)
    (fromX : 3*x+1=2^a*z) (fromY : 3*y+1=2^b*z) : x=y := by
  rcases left with rfl | rfl <;> rcases right with rfl | rfl <;>
    simp only [show (2:Nat)^1=2 by decide,show (2:Nat)^2=4 by decide] at fromX fromY <;> omega

theorem blocked {N z : Nat} (above : N≤z) (divisible : z%3=0) : Excluded N z := by
  intro w h s C path
  cases path with
  | nil => exact above
  | append start small edge =>
    have e := edge.book
    rcases small with rfl | rfl <;> simp only [show (2:Nat)^1=2 by decide,show (2:Nat)^2=4 by decide] at e <;> omega

theorem preserve {N x y a : Nat} (earlier : Excluded N x) (above : N≤y)
    (small : a=1 ∨ a=2) (factor : 3*x+1=2^a*y) : Excluded N y := by
  intro w h s C path
  cases path with
  | nil => exact above
  | append start stepSize edge =>
    have same := predecessorUnique stepSize small edge.book.symm factor
    rw [same] at start
    exact earlier _ _ _ _ start

private def aboveAffine (N x : Affine) : Prop := N.offset≤x.offset ∧ N.slope≤x.slope

private theorem aboveAt {N x : Affine} (h : aboveAffine N x) (t : Nat) : N.at t≤x.at t := by
  exact Nat.add_le_add h.1 (Nat.mul_le_mul_right t h.2)

private def verify (N x : Affine) : List (Nat × Affine) → Bool
  | [] => decide (N.offset≤x.offset ∧ N.slope≤x.slope ∧ x.offset%3=0 ∧ x.slope%3=0)
  | (a,y)::rest => decide (N.offset≤x.offset ∧ N.slope≤x.slope ∧ (a=1 ∨ a=2) ∧
      3*y.offset+1=2^a*x.offset ∧ 3*y.slope=2^a*x.slope) && verify N y rest

private theorem verified (N x : Affine) (rev : List (Nat × Affine))
    (h : verify N x rev=true) (t : Nat) : Excluded (N.at t) (x.at t) := by
  induction rev generalizing x with
  | nil =>
    simp only [verify,decide_eq_true_eq] at h
    exact blocked (aboveAt ⟨h.1,h.2.1⟩ t)
      (by simp [Affine.at,Nat.add_mod,Nat.mul_mod,h.2.2.1,h.2.2.2])
  | cons p rest ih =>
    obtain ⟨a,y⟩ := p
    simp only [verify,Bool.and_eq_true_iff,decide_eq_true_eq] at h
    obtain ⟨⟨hi,hs,small,first,second⟩,restOk⟩ := h
    have factor : 3*y.at t+1=2^a*x.at t := by
      simp only [Affine.at,Nat.mul_add,←Nat.mul_assoc]
      rw [second,←first]
      omega
    exact preserve (ih y restOk) (aboveAt ⟨hi,hs⟩ t) small factor

private def seed3 : Affine := ⟨23974070385281809610720083954815,40564819207303340847894502572032⟩
private def ancestors3 : List (Nat × Affine) :=
  [(2,⟨64938538721691250625281848318953,109877882249360399509051170856992⟩),
   (1,⟨43292359147794167083521232212635,73251921499573599672700780571328⟩),
   (1,⟨28861572765196111389014154808423,48834614333049066448467187047552⟩),
   (2,⟨38482097020261481852018873077897,65112819110732088597956249396736⟩),
   (2,⟨51309462693681975802691830770529,86817092147642784797274999195648⟩),
   (2,⟨68412616924909301070255774360705,115756122863523713063033332260864⟩)]

theorem band3 (t : Nat) : Excluded (originalSeed (18+32*t)) (Front4bGuardRun.entry3.at t) := by
  have eq : seed3.at t=originalSeed (18+32*t) := by
    simp only [seed3,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [←eq]
  exact verified seed3 Front4bGuardRun.entry3 ancestors3 (by decide) t

private def seed5 : Affine := ⟨13832865583455974398746458311807,162259276829213363391578010288128⟩
private def ancestors5 : List (Nat × Affine) :=
  [(2,⟨28101801119513363061014291703529,329633646748081198527153512570976⟩),
   (2,⟨37469068159351150748019055604705,439511528997441598036204683427968⟩),
   (1,⟨24979378772900767165346037069803,293007685998294398690803122285312⟩),
   (1,⟨16652919181933844776897358046535,195338457332196265793868748190208⟩),
   (2,⟨22203892242578459702529810728713,260451276442928354391824997586944⟩),
   (2,⟨29605189656771279603373080971617,347268368590571139189099996782592⟩),
   (2,⟨39473586209028372804497441295489,463024491454094852252133329043456⟩)]

theorem band5 (t : Nat) : Excluded (originalSeed (10+128*t)) (Front4bE1.entry5.at t) := by
  have eq : seed5.at t=originalSeed (10+128*t) := by
    simp only [seed5,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [←eq]
  exact verified seed5 Front4bE1.entry5 ancestors5 (by decide) t

open Front4bSwitchedRealization (Trace Transition)
open Front4bWeakReentry (weakBookOfRank)
open Front4bWeakCofactor (readmissionEquation)
open FixedSourceRun (Ones)

private theorem throughOnes {N J L : Nat} (base : Excluded N J) (ones : Ones J L)
    (above : ∀ i≤L, N≤orbit J i) : ∀ i≤L, Excluded N (orbit J i) := by
  intro i hi
  induction i with
  | zero => exact base
  | succ i ih =>
    exact preserve (ih (by omega)) (above (i+1) hi) (a:=1) (.inl rfl) (ones i (by omega))

private theorem firstAndSecond {J L q b H Z v : Nat} (head : Transition J L q b H Z v) :
    (3*orbit J L+1=4*orbit J (L+1)) ∧
    (3*orbit J (L+1)+1=2^b*Z) := by
  have qPos : 0<q := by have := head.odd; omega
  have ⟨runEnd,_⟩ := FixedSourceRun.ones_prefix L q qPos
  have entry : J=2^(L+1)*q-1 := by have := head.entry; omega
  rw [←entry] at runEnd
  have term := readmissionEquation (weakBookOfRank head.path) head.entry (by rw [head.atNext]; exact head.nextEntry)
  have equivalent : 3^(L+2)*q=1+2^(b+1)*Z := by
    have f : 2^(H+b+2)*v=2^(b+1)*(Z+1) := by
      rw [head.nextEntry,show H+b+2=(b+1)+(H+1) by omega,Nat.pow_add 2 (b+1) (H+1)]
      ac_rfl
    rw [f,Nat.mul_add,Nat.mul_one] at term
    have positive : 0<2^(b+1) := Nat.pow_pos (by decide)
    omega
  let A := 3^(L+1)*q
  let F := (A-1)/2
  have qa := head.odd
  have h3 : ∀ n : Nat, 3^n%2=1 := by
    intro n; induction n with
    | zero => decide
    | succ n ih => rw [Nat.pow_succ,Nat.mul_mod,ih]
  have oddA : A%2=1 := by simp [A,Nat.mul_mod,h3,qa]
  have Af : A=2*F+1 := by dsimp only [F]; omega
  have scaled : 3*A=1+2*(2^b*Z) := by
    rw [show 3*A=3^(L+2)*q by
      change 3*(3^(L+1)*q)=3^((L+1)+1)*q
      rw [Nat.pow_succ 3 (L+1)]
      ac_rfl,equivalent,Nat.pow_succ]
    ac_rfl
  have edge2 : 3*F+1=2^b*Z := by omega
  have fo : F%2=1 := by
    have weak := head.weak
    rcases weak with one | two
    · simp only [one,show (2:Nat)^1=2 by decide] at edge2; omega
    · simp only [two,show (2:Nat)^2=4 by decide] at edge2; omega
  have edge1 : 3*orbit J L+1=4*F := by
    have tq : 0<2*3^L*q := Nat.mul_pos (Nat.mul_pos (by decide) (Nat.pow_pos (by decide))) qPos
    have expand : A=3*(3^L*q) := by unfold A; rw [Nat.pow_succ]; ac_rfl
    rw [runEnd,Nat.mul_assoc 2]
    omega
  have jo : J%2=1 := by
    have factor := head.entry
    rw [Nat.pow_succ,show (2:Nat)^L*2*q=2*(2^L*q) by ac_rfl] at factor
    omega
  have atF : orbit J (L+1)=F := by
    rw [orbit_add]
    apply A2Header.physical_endpoint (s:=2)
    exact A2Header.Physical.edge (orbit_pos J (by omega) _) (orbit_odd J jo _)
      (by omega) fo (by decide) edge1
  exact ⟨by rw [atF]; exact edge1,by rw [atF]; exact edge2⟩

private theorem throughEpisode {N J L q b H Z v : Nat} (base : Excluded N J)
    (head : Transition J L q b H Z v) (i : Nat) (hi : i≤L+2) : Excluded N (orbit J i) := by
  have top : N≤J := base _ _ _ _ SmallBook.nil
  have above : ∀ k≤L+2, N≤orbit J k := fun k hk => Nat.le_trans top (head.path.oddLower k hk)
  have qpos : 0<q := by have := head.odd; omega
  have start := (FixedSourceRun.ones_prefix L q qpos).2
  rw [show 2^(L+1)*q-1=J by have := head.entry; omega] at start
  have onRun := throughOnes base start (fun k hk => above k (by omega))
  by_cases early : i≤L
  · exact onRun i early
  obtain ⟨first,second⟩ := firstAndSecond head
  have one := preserve (onRun L (Nat.le_refl _)) (above (L+1) (by omega))
    (a:=2) (.inr rfl) first
  by_cases middle : i=L+1
  · rwa [middle]
  have last : i=L+2 := by omega
  rw [last,head.atNext]
  have remain : N≤Z := by rw [←head.atNext]; exact above (L+2) (Nat.le_refl _)
  exact preserve one remain head.weak second

private theorem traceExcludes {N J L q X m d B : Nat} {xs : List (Nat × Nat)}
    (trace : Trace J L q xs X m d B) (base : Excluded N J) :
    ∀ i≤m, Excluded N (orbit J i) := by
  induction trace with
  | stop =>
    intro i hi
    obtain rfl : i=0 := by omega
    exact base
  | @extend J L q b H Z v rest X m d C head tail ih =>
    intro i hi
    by_cases first : i≤L+2
    · exact throughEpisode base head i first
    · have atZ := throughEpisode base head (L+2) (Nat.le_refl _)
      rw [head.atNext] at atZ
      rw [show i=L+2+(i-(L+2)) by omega,orbit_add,head.atNext]
      exact ih atZ _ (by omega)

/-- Complete physical weak prefixes in either E1 band forbid any paid
source made solely of valuations 1 and 2, at every odd checkpoint. -/
theorem acrossTrace {N J j S C L q X m d B : Nat} {xs : List (Nat × Nat)}
    (history : Segment N J j S C) (base : Excluded N J)
    (trace : Trace J L q xs X m d B) :
    Segment N X (j+m) (S+d) (3^m*C+2^S*B) ∧
      ∀ i≤m, Excluded N (orbit N (j+i)) := by
  refine ⟨compose history (Front4bSwitchedRealization.physical trace).1,?_⟩
  intro i hi
  rw [orbit_add,A2Header.physical_endpoint history.physical]
  exact traceExcludes trace base i hi

theorem band3Trace {t L q X m d B : Nat} {xs : List (Nat × Nat)}
    (trace : Trace (Front4bGuardRun.entry3.at t) L q xs X m d B) :
    let N := originalSeed (18+32*t)
    Segment N X (65+m) (102+d) (3^m*Front4bRowEven.originalCost 3 19+2^102*B) ∧
    ∀ i≤m, Excluded N (orbit N (65+i)) :=
  acrossTrace (Front4bGuardRun.entry3History t).1 (band3 t) trace

theorem band5Trace {t L q X m d B : Nat} {xs : List (Nat × Nat)}
    (trace : Trace (Front4bE1.entry5.at t) L q xs X m d B) :
    let N := originalSeed (10+128*t)
    Segment N X (66+m) (104+d) (3^m*Front4bRowEven.originalCost 4 73+2^104*B) ∧
    ∀ i≤m, Excluded N (orbit N (66+i)) :=
  acrossTrace (Front4bE1.entry5History t).1 (band5 t) trace

end CollatzCharacterBridge.Front4bSmallSource

#print axioms CollatzCharacterBridge.Front4bSmallSource.toSegment
#print axioms CollatzCharacterBridge.Front4bSmallSource.preserve
#print axioms CollatzCharacterBridge.Front4bSmallSource.band3
#print axioms CollatzCharacterBridge.Front4bSmallSource.band5

#print axioms CollatzCharacterBridge.Front4bSmallSource.acrossTrace
#print axioms CollatzCharacterBridge.Front4bSmallSource.band3Trace
#print axioms CollatzCharacterBridge.Front4bSmallSource.band5Trace
