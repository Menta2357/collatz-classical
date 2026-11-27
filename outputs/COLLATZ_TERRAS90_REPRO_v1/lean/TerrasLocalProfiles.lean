import TerrasCuts
import Terras90Extension

namespace TerrasLocalProfiles

open TerrasClock
open TerrasCuts (LocalSixProfile LocalSixProfilePadded capacitySixNum oddRunsAddAtValley)
open TerrasCapacityAbsorption (capacityNum geometricNum scaledWeight)

set_option maxHeartbeats 1000000
set_option maxRecDepth 20000
set_option exponentiation.threshold 1024

private theorem shiftedOddEdge {x : Nat} (odd : x%2=1) :
    2*(shortcut x+1)=3*(x+1) := by
  have edge := shortcut_odd odd
  omega

/-- Even shortcut steps can only decrease the shifted height. -/
theorem shiftedGrowth (x t : Nat) :
    2^(oddCount x t)*(orbit x t+1)≤3^(oddCount x t)*(x+1) := by
  induction t with
  | zero => simp [oddCount,orbit]
  | succ t ih =>
    rcases Nat.mod_two_eq_zero_or_one (orbit x t) with even | odd
    · have notOdd : ¬orbit x t%2=1 := by omega
      have edge := shortcut_even even
      have shorter : shortcut (orbit x t)+1≤orbit x t+1 := by omega
      simp only [oddCount,if_neg notOdd,Nat.add_zero,orbit_succ]
      exact Nat.le_trans (Nat.mul_le_mul_left _ shorter) ih
    · simp only [oddCount,if_pos odd,orbit_succ,Nat.pow_succ]
      calc
        _ = 2^oddCount x t*(2*(shortcut (orbit x t)+1)) := by ac_rfl
        _ = 3*(2^oddCount x t*(orbit x t+1)) := by rw [shiftedOddEdge odd]; ac_rfl
        _ ≤ 3*(3^oddCount x t*(x+1)) := Nat.mul_le_mul_left _ ih
        _ = _ := by ac_rfl

private theorem runsMono (x p i : Nat) : oddRuns x p≤oddRuns x (p+i) := by
  induction i with
  | zero => simp
  | succ i ih =>
    rw [Nat.add_succ,oddRuns_succ]
    exact Nat.le_trans ih (Nat.le_add_right _ _)

private theorem valleyBetween {x i j : Nat} (before : i≤j)
    (even : orbit x i%2=0) (odd : orbit x j%2=1) :
    ∃ v, i<v ∧ v≤j ∧ startsOddRun x v=true := by
  induction j with
  | zero =>
    have atZero : i=0 := by omega
    subst i
    omega
  | succ j ih =>
    have ne : i≠j+1 := fun h => by rw [h] at even; omega
    rcases Nat.mod_two_eq_zero_or_one (orbit x j) with prevEven | prevOdd
    · refine ⟨j+1,by omega,Nat.le_refl _,(startsOddRun_iff _ _).mpr ⟨odd,Or.inr ?_⟩⟩
      simpa using prevEven
    · obtain ⟨v,left,right,starts⟩ := ih (by omega) prevOdd
      exact ⟨v,left,by omega,starts⟩

private theorem runsAtLeastOne {x t : Nat} (odd : x%2=1) (positive : 0<t) : 1≤oddRuns x t := by
  have one : oddRuns x 1=1 := by simp [oddRuns,startsOddRun,orbit,odd]
  have bound := runsMono x 1 (t-1)
  rwa [show 1+(t-1)=t by omega,one] at bound

private theorem oddCountFull (x k : Nat) (odd : ∀ j, j<k → orbit x j%2=1) : oddCount x k=k := by
  induction k with
  | zero => rfl
  | succ k ih =>
    simp only [oddCount,odd k (by omega),if_true,ih (fun j hj => odd j (by omega))]

private theorem oddPrefixDivides (x k : Nat) (odd : ∀ j, j<k → orbit x j%2=1) : 2^k∣x+1 := by
  have book : 2^k*(orbit x k+1)=3^k*(x+1) := by
    induction k with
    | zero => simp [orbit]
    | succ k ih =>
      calc
        _ = 2^k*(2*(orbit x (k+1)+1)) := by rw [Nat.pow_succ,Nat.mul_assoc]
        _ = 3*(2^k*(orbit x k+1)) := by
          rw [orbit_succ,shiftedOddEdge (odd k (by omega))]
          ac_rfl
        _ = _ := by rw [ih (fun j hj => odd j (by omega)),Nat.pow_succ]; ac_rfl
  have gcdOne : Nat.gcd (2^k) (3^k)=1 :=
    Nat.pow_gcd_pow_of_gcd_eq_one (by decide : Nat.gcd 2 3=1)
  have div : 2^k∣(x+1)*3^k := ⟨orbit x k+1,by rw [Nat.mul_comm,book]⟩
  simpa only [gcdOne,Nat.mul_one] using (Nat.dvd_mul_gcd_iff_dvd_mul
    (k := 2^k) (n := x+1) (m := 3^k)).mpr div

/-- The odd count in a single-run prefix is bounded by its root reserve.
The prefix can finish before or after the first even step. -/
theorem singleRunDivides {x t : Nat} (odd : x%2=1) (single : oddRuns x t=1) :
    2^oddCount x t∣x+1 := by
  induction t with
  | zero => simp [oddCount]
  | succ t ih =>
    rcases Nat.mod_two_eq_zero_or_one (orbit x t) with even | lastOdd
    · have notOdd : ¬orbit x t%2=1 := by omega
      have prev : oddRuns x t=1 := by simpa only [oddRuns_succ,notOdd,false_and,if_false,Nat.add_zero] using single
      simpa only [oddCount,notOdd,if_false,Nat.add_zero] using ih prev
    · have all : ∀ i, i<t+1 → orbit x i%2=1 := by
        intro i hi
        rcases Nat.mod_two_eq_zero_or_one (orbit x i) with even | yes
        · obtain ⟨v,left,right,starts⟩ := valleyBetween (by omega) even lastOdd
          have upTo := runsMono x (v+1) (t-v)
          rw [show v+1+(t-v)=t+1 by omega,single] at upTo
          have grow : oddRuns x (v+1)=oddRuns x v+1 := by simp [oddRuns,starts]
          have old := runsAtLeastOne odd (by omega : 0<v)
          omega
        · exact yes
      rw [oddCountFull x (t+1) all]
      exact oddPrefixDivides x (t+1) all

private theorem lastValley {x t : Nat} (positive : 0<oddRuns x t) :
    ∃ v, v<t ∧ startsOddRun x v=true ∧ oddRuns x t=oddRuns x v+1 := by
  induction t with
  | zero => simp [oddRuns] at positive
  | succ t ih =>
    cases starts : startsOddRun x t with
    | true => exact ⟨t,Nat.lt_succ_self _,starts,by simp [oddRuns,starts]⟩
    | false =>
      have same : oddRuns x (t+1)=oddRuns x t := by simp [oddRuns,starts]
      obtain ⟨v,before,edge,count⟩ := ih (by omega)
      exact ⟨v,by omega,edge,same.trans count⟩

private theorem twoExponent_le {i j : Nat} (h : (2:Nat)^i≤2^j) : i≤j := by
  by_cases order : i≤j
  · exact order
  have strict : (2:Nat)^j<2^i := Nat.pow_lt_pow_right (by decide) (by omega)
  exact (Nat.not_lt_of_ge h strict).elim

/-- The last physical run is charged to its valley's reserve. The recurrence
uses only integer powers and the exact bound 3^306 ≤ 2^485. -/
theorem localRecurrence {x t H : Nat} (small : x+1<2^H) (hasRun : 0<oddRuns x t) :
    ∃ v, v<t ∧ startsOddRun x v=true ∧ oddRuns x t=oddRuns x v+1 ∧
      306*oddCount x t≤306*H+485*oddCount x v := by
  obtain ⟨v,before,start,runs⟩ := lastValley hasRun
  have split : v+(t-v)=t := by omega
  have rsum := oddRunsAddAtValley start (t-v)
  rw [split,runs] at rsum
  have lastOne : oddRuns (orbit x v) (t-v)=1 := by omega
  have divides := singleRunDivides ((startsOddRun_iff _ _).mp start).1 lastOne
  have reserve := Nat.le_of_dvd (Nat.succ_pos _) divides
  have dsum := oddCount_add x v (t-v)
  rw [split] at dsum
  have growth := shiftedGrowth x v
  have comparison : 2^oddCount x t≤3^oddCount x v*(x+1) := by
    rw [dsum,Nat.pow_add]
    exact Nat.le_trans (Nat.mul_le_mul_left _ reserve) growth
  have upper := Nat.le_trans comparison (Nat.mul_le_mul_left _ (Nat.le_of_lt small))
  have powered := Nat.pow_le_pow_left upper 306
  have alpha := Nat.pow_le_pow_left TerrasCuts.alpha_upper (oddCount x v)
  have transfer : (3^oddCount x v)^306≤(2:Nat)^(485*oddCount x v) := by
    rw [← Nat.pow_mul,Nat.mul_comm (oddCount x v) 306,Nat.pow_mul,Nat.pow_mul]
    exact alpha
  refine ⟨v,before,start,runs,twoExponent_le ?_⟩
  calc
    (2:Nat)^(306*oddCount x t) = (2^oddCount x t)^306 := by rw [← Nat.pow_mul,Nat.mul_comm]
    _ ≤ (3^oddCount x v*2^H)^306 := powered
    _ ≤ (2:Nat)^(485*oddCount x v)*(2^H)^306 := by
      rw [Nat.mul_pow]
      exact Nat.mul_le_mul_right _ transfer
    _ = (2:Nat)^(306*H+485*oddCount x v) := by
      rw [← Nat.pow_mul,← Nat.pow_add,Nat.add_comm,Nat.mul_comm H 306]

/-- The external two-run count used by the short capacity profile. -/
def TwoRunCapacity (H : Nat) : Prop :=
  ∀ x t, 0<x → x%2=1 → x+1<2^H → oddRuns x t=2 → 2*oddCount x t≤3*H

private theorem extendToSix {x t : Nat} (pos : 0<x) (short : oddRuns x t≤6) :
    ∃ u, t≤u ∧ oddRuns x u=6 := by
  have extend (n : Nat) : ∃ u, t≤u ∧ oddRuns x u=oddRuns x t+n := by
    induction n with
    | zero => exact ⟨t,Nat.le_refl _,by simp⟩
    | succ n ih =>
      obtain ⟨u,after,count⟩ := ih
      obtain ⟨extra,more⟩ := Terras90.extendOddRuns (k:=u) pos
      exact ⟨u+extra,by omega,by rw [more,count]; omega⟩
  obtain ⟨u,after,runs⟩ := extend (6-oddRuns x t)
  exact ⟨u,after,by omega⟩

private theorem sixPrefixBound {H x t : Nat} (bound : Terras90.SixRunCapacity H)
    (pos : 0<x) (odd : x%2=1) (small : x+1<2^H) (short : oddRuns x t≤6) :
    306*oddCount x t≤(306+485)*H := by
  obtain ⟨u,after,runs⟩ := extendToSix pos short
  have values := bound x u pos odd small runs
  have counts : oddCount x t≤oddCount x u := by
    rw [show u=t+(u-t) by omega,oddCount_add]
    exact Nat.le_add_right _ _
  have powers : 2^oddCount x t≤6^H :=
    Nat.le_trans (Nat.pow_le_pow_right (by decide) counts) values
  apply twoExponent_le
  calc
    (2:Nat)^(306*oddCount x t) = (2^oddCount x t)^306 := by rw [← Nat.pow_mul,Nat.mul_comm]
    _ ≤ (6^H)^306 := Nat.pow_le_pow_left powers _
    _ = (6^306)^H := by rw [← Nat.pow_mul,Nat.mul_comm H 306,Nat.pow_mul]
    _ ≤ ((2:Nat)^(306+485))^H := Nat.pow_le_pow_left (by decide) _
    _ = (2:Nat)^((306+485)*H) := by rw [Nat.pow_mul]

private def scale : Nat := 2*306^85
private def cap (r : Nat) : Nat := capacitySixNum 485 306 85 r

private theorem capMiddle {r : Nat} (lower : 3≤r) (upper : r≤6) :
    cap r=2*306^84*(306+485) := by
  have finite : r=3 ∨ r=4 ∨ r=5 ∨ r=6 := by omega
  rcases finite with rfl | rfl | rfl | rfl <;> decide

private theorem capLong {r : Nat} (big : 6≤r) : cap r=2*geometricNum 485 306 85 (r-4) := by
  have idx : r-1-3=r-4 := by omega
  simp [cap,capacitySixNum,big,capacityNum,show r-1≠0 by omega,show r-1≠1 by omega,
    show r-1≠2 by omega,show ¬r-1≤4 by omega,idx]

private theorem weightStep (i : Nat) :
    485*scaledWeight 485 306 85 i≤306*scaledWeight 485 306 85 (i+1) := by
  unfold scaledWeight
  have powers : (306:Nat)^(85-i)≤306^((85-(i+1))+1) :=
    Nat.pow_le_pow_right (by decide) (by omega)
  calc
    485*(485^i*306^(85-i)) ≤ 485*(485^i*306^((85-(i+1))+1)) :=
      Nat.mul_le_mul_left _ (Nat.mul_le_mul_left _ powers)
    _ = 306*(485^(i+1)*306^(85-(i+1))) := by rw [Nat.pow_succ,Nat.pow_succ]; ac_rfl

private theorem geometricStep (i : Nat) :
    306*306^85+485*geometricNum 485 306 85 i≤306*geometricNum 485 306 85 (i+1) := by
  induction i with
  | zero => simp [geometricNum,scaledWeight]
  | succ i ih =>
    simp only [geometricNum,Nat.mul_add]
    have weighted := Nat.add_le_add ih (weightStep i)
    simpa only [Nat.add_assoc,Nat.mul_add,geometricNum] using weighted

private theorem capStep {r : Nat} (big : 6≤r) : 306*scale+485*cap r≤306*cap (r+1) := by
  rw [capLong big,capLong (by omega : 6≤r+1),show r+1-4=(r-4)+1 by omega]
  have step := Nat.mul_le_mul_left 2 (geometricStep (r-4))
  calc
    306*scale+485*(2*geometricNum 485 306 85 (r-4)) =
        2*(306*306^85+485*geometricNum 485 306 85 (r-4)) := by
      simp only [scale,Nat.mul_add]; ac_rfl
    _ ≤ _ := by
      calc
        _ ≤ 2*(306*geometricNum 485 306 85 (r-4+1)) := step
        _ = _ := by ac_rfl

private theorem scaledMiddle {H x u : Nat} (six : Terras90.SixRunCapacity H)
    (pos : 0<x) (odd : x%2=1) (small : x+1<2^H) (short : oddRuns x u≤6) :
    scale*oddCount x u≤H*(2*306^84*(306+485)) := by
  have bound := sixPrefixBound six pos odd small short
  calc
    scale*oddCount x u = (2*306^84)*(306*oddCount x u) := by
      rw [scale,show (306:Nat)^85=306^84*306 by rfl]
      ac_rfl
    _ ≤ (2*306^84)*((306+485)*H) := Nat.mul_le_mul_left _ bound
    _ = _ := by ac_rfl

private theorem capOne : cap 1=scale := rfl

private theorem scaleRecurrence {H d u r : Nat} (big : 6≤r)
    (recurrence : 306*d≤306*H+485*u) (prior : scale*u≤H*cap r) :
    scale*d≤H*cap (r+1) := by
  apply Nat.le_of_mul_le_mul_left _ (by decide : 0<306)
  calc
    306*(scale*d) = scale*(306*d) := by ac_rfl
    _ ≤ scale*(306*H+485*u) := Nat.mul_le_mul_left _ recurrence
    _ = H*(306*scale)+485*(scale*u) := by simp only [Nat.mul_add]; ac_rfl
    _ ≤ H*(306*scale)+485*(H*cap r) := Nat.add_le_add_left (Nat.mul_le_mul_left _ prior) _
    _ = H*(306*scale+485*cap r) := by simp only [Nat.mul_add]; ac_rfl
    _ ≤ H*(306*cap (r+1)) := Nat.mul_le_mul_left _ (capStep big)
    _ = 306*(H*cap (r+1)) := by ac_rfl

private theorem localProfileReplacingTwo {H c2 : Nat} (six : Terras90.SixRunCapacity H)
    (two : ∀ x t, 0<x → x%2=1 → x+1<2^H → oddRuns x t=2 → scale*oddCount x t≤H*c2) :
    ∀ x t, 0<x → x%2=1 → x+1<2^H →
      scale*oddCount x t≤H*(if oddRuns x t=2 then c2 else cap (oddRuns x t)) := by
  intro x t pos odd small
  have prove : ∀ r u, oddRuns x u=r → scale*oddCount x u≤H*(if r=2 then c2 else cap r) := by
    intro r
    induction r using Nat.strongRecOn with
    | ind r ih =>
      intro u runs
      by_cases noRuns : r=0
      · have now : u=0 := by
          by_cases positive : 0<u
          · have first := runsAtLeastOne odd positive
            omega
          · omega
        subst u
        simp only [oddCount,Nat.mul_zero,Nat.zero_le]
      by_cases one : r=1
      · have divides := singleRunDivides odd (runs.trans one)
        have lower := Nat.le_of_dvd (Nat.succ_pos _) divides
        have degree := twoExponent_le (Nat.le_trans lower (Nat.le_of_lt small))
        rw [one,if_neg (by decide : (1:Nat)≠2),capOne]
        rw [Nat.mul_comm H scale]
        exact Nat.mul_le_mul_left _ degree
      by_cases second : r=2
      · rw [second]
        simpa only [if_pos rfl] using two x u pos odd small (runs.trans second)
      rw [if_neg second]
      by_cases short : r≤6
      · rw [capMiddle (by omega) short]
        exact scaledMiddle six pos odd small (by omega)
      obtain ⟨v,_,_,last,recurrence⟩ := localRecurrence small (by omega : 0<oddRuns x u)
      have count : oddRuns x v+1=r := last.symm.trans runs
      have less : oddRuns x v<r := by omega
      have big : 6≤oddRuns x v := by omega
      have notTwo : oddRuns x v≠2 := by omega
      have prior := ih (oddRuns x v) less v rfl
      rw [if_neg notTwo] at prior
      rw [← count]
      exact scaleRecurrence big recurrence prior
  exact prove (oddRuns x t) t rfl

/-- Convert the real two- and six-run certificates to every local scaled
capacity used in the Q0 rank proof. -/
theorem localSixProfileOfCaps {H : Nat} (two : TwoRunCapacity H) (six : Terras90.SixRunCapacity H) :
    LocalSixProfile H := by
  have twoScaled (x t : Nat) (pos : 0<x) (odd : x%2=1) (small : x+1<2^H) (runs : oddRuns x t=2) :
      scale*oddCount x t≤H*cap 2 := by
    have twice := two x t pos odd small runs
    change (2*306^85)*oddCount x t≤H*(3*306^85)
    calc
      _ = 306^85*(2*oddCount x t) := by ac_rfl
      _ ≤ 306^85*(3*H) := Nat.mul_le_mul_left _ twice
      _ = _ := by ac_rfl
  intro x t pos odd small
  have bound := localProfileReplacingTwo six twoScaled x t pos odd small
  change scale*oddCount x t≤H*cap (oddRuns x t)
  split at bound
  · rename_i eq
    rwa [eq]
  · exact bound

/-- The six-run certificate alone suffices for the padded profile. The
additional term is only used for a slice of two runs. -/
theorem localSixProfileOfSix {H : Nat} (six : Terras90.SixRunCapacity H) : LocalSixProfilePadded H := by
  have two (x t : Nat) (pos : 0<x) (odd : x%2=1) (small : x+1<2^H) (runs : oddRuns x t=2) :
      scale*oddCount x t≤H*(2*306^84*(306+485)) :=
    scaledMiddle six pos odd small (by omega)
  intro x t pos odd small
  have bound := localProfileReplacingTwo six two x t pos odd small
  change scale*oddCount x t≤H*(cap (oddRuns x t)+4*306^85)
  apply Nat.le_trans bound
  apply Nat.mul_le_mul_left H
  split
  · rename_i eq
    rw [eq]
    decide
  · exact Nat.le_add_right _ _

/-- Direct consumer of the numerical threshold certificates at H92 and H146. -/
theorem q0RankFloorsOfCaps {N k : Nat} (Q : Terras90.DeltaOneQ0 N k)
    (two92 : TwoRunCapacity 92) (two146 : TwoRunCapacity 146)
    (six92 : Terras90.SixRunCapacity 92) (six146 : Terras90.SixRunCapacity 146) :
    (Terras88.valleyTimes N k).countP (fun i => decide (orbit N i<2^92-1))<10 ∧
      (Terras88.valleyTimes N k).countP (fun i => decide (orbit N i<2^146-1))<11 :=
  TerrasCuts.q0RankFloors Q (localSixProfileOfCaps two92 six92) (localSixProfileOfCaps two146 six146)

/-- Transfer H92 and H146 without an additional two-run input. -/
theorem q0RankFloorsOfSix {N k : Nat} (Q : Terras90.DeltaOneQ0 N k)
    (six92 : Terras90.SixRunCapacity 92) (six146 : Terras90.SixRunCapacity 146) :
    (Terras88.valleyTimes N k).countP (fun i => decide (orbit N i<2^92-1))<10 ∧
      (Terras88.valleyTimes N k).countP (fun i => decide (orbit N i<2^146-1))<11 :=
  TerrasCuts.q0RankFloorsPadded Q (localSixProfileOfSix six92) (localSixProfileOfSix six146)

end TerrasLocalProfiles
