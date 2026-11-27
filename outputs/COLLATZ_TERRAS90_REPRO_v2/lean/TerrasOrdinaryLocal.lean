import TerrasLocalProfiles
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

namespace TerrasOrdinaryRank

open TerrasClock

noncomputable def alpha : ℝ := 1585/1000
noncomputable def logHeight (x : Nat) : ℝ := Real.log ((x : ℝ)+1)/Real.log 2
noncomputable def geom : Nat → ℝ
  | 0 => 0
  | n+1 => 1+alpha*geom n

theorem log2_pos : 0<Real.log 2 := Real.log_pos (by norm_num)

private theorem logPowLe {a b m n : Nat} (positive : 0<a) (h : a^m≤b^n) :
    (m:ℝ)*Real.log a≤(n:ℝ)*Real.log b := by
  have cast : (a:ℝ)^m≤(b:ℝ)^n := by exact_mod_cast h
  have root : (0:ℝ)<a := by exact_mod_cast positive
  simpa only [Real.log_pow] using Real.log_le_log (pow_pos root m) cast

set_option exponentiation.threshold 600 in
theorem log3_le : Real.log 3≤alpha*Real.log 2 := by
  have h : (306:ℝ)*Real.log 3≤(485:ℝ)*Real.log 2 := by
    simpa only [Nat.cast_ofNat] using @logPowLe 3 2 306 485 (by decide) TerrasCuts.alpha_upper
  unfold alpha
  linarith only [h,log2_pos]

theorem geom_nonneg (n : Nat) : 0≤geom n := by
  induction n with
  | zero => simp [geom]
  | succ n ih =>
    simp only [geom]
    exact add_nonneg (by norm_num) (mul_nonneg (by norm_num [alpha]) ih)

theorem logHeight_nonneg (x : Nat) : 0≤logHeight x := by
  have nonneg : 0≤(x:ℝ) := by positivity
  exact div_nonneg (Real.log_nonneg (by linarith)) log2_pos.le

theorem logHeight_mono {x y : Nat} (le : x≤y) : logHeight x≤logHeight y := by
  unfold logHeight
  apply div_le_div_of_nonneg_right _ log2_pos.le
  apply Real.log_le_log (by positivity)
  exact add_le_add_right (by exact_mod_cast le : (x:ℝ)≤y) _

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

/-- The length of the final run is paid by the dyadic reserve at its
physical valley. Taking logarithms uses the full prefix of this root. -/
theorem localLogRecurrence {x t : Nat} (hasRun : 0<oddRuns x t) :
    ∃ v, v<t ∧ startsOddRun x v=true ∧ oddRuns x t=oddRuns x v+1 ∧
      (oddCount x t : ℝ) ≤ logHeight x+alpha*(oddCount x v : ℝ) := by
  obtain ⟨v,before,start,runs⟩ := lastValley hasRun
  have split : v+(t-v)=t := by omega
  have rsum := TerrasCuts.oddRunsAddAtValley start (t-v)
  rw [split,runs] at rsum
  have lastOne : oddRuns (orbit x v) (t-v)=1 := by omega
  have divides := TerrasLocalProfiles.singleRunDivides ((startsOddRun_iff _ _).mp start).1 lastOne
  have reserve := Nat.le_of_dvd (Nat.succ_pos _) divides
  have dsum := oddCount_add x v (t-v)
  rw [split] at dsum
  have comparison : 2^oddCount x t≤3^oddCount x v*(x+1) := by
    rw [dsum,Nat.pow_add]
    exact Nat.le_trans (Nat.mul_le_mul_left _ reserve) (TerrasLocalProfiles.shiftedGrowth x v)
  have cast : (2:ℝ)^oddCount x t≤3^oddCount x v*((x:ℝ)+1) := by exact_mod_cast comparison
  have logs := Real.log_le_log (by positivity) cast
  rw [Real.log_mul (by positivity) (by positivity),Real.log_pow,Real.log_pow] at logs
  refine ⟨v,before,start,runs,le_of_mul_le_mul_right ?_ log2_pos⟩
  calc
    _ ≤ (oddCount x v : ℝ)*Real.log 3+Real.log ((x:ℝ)+1) := logs
    _ ≤ (oddCount x v : ℝ)*(alpha*Real.log 2)+Real.log ((x:ℝ)+1) :=
      add_le_add_right (mul_le_mul_of_nonneg_left log3_le (by positivity)) _
    _ = (logHeight x+alpha*(oddCount x v : ℝ))*Real.log 2 := by
      unfold logHeight
      rw [add_mul,div_mul_cancel₀ _ log2_pos.ne']
      ring

private theorem runsPositive {x t : Nat} (odd : x%2=1) (positive : 0<t) : 0<oddRuns x t := by
  induction t with
  | zero => omega
  | succ t ih =>
    by_cases initial : t=0
    · subst t
      simp [oddRuns,startsOddRun,orbit,odd]
    · have previous := ih (by omega)
      rw [oddRuns_succ]
      omega

/-- The ordinary geometric envelope bounds the actual odd count of any
prefix from an odd root, including one cut inside its final even stretch. -/
theorem localLogCapacity {x t : Nat} (odd : x%2=1) :
    (oddCount x t : ℝ) ≤ geom (oddRuns x t)*logHeight x := by
  have bound : ∀ r u, oddRuns x u=r → (oddCount x u : ℝ) ≤ geom r*logHeight x := by
    intro r
    induction r using Nat.strongRecOn with
    | ind r ih =>
      intro u count
      by_cases zero : r=0
      · have empty : u=0 := by
          by_cases positive : 0<u
          · have contradiction := runsPositive odd positive
            omega
          · omega
        simp [empty,zero,geom,oddCount]
      obtain ⟨v,_,_,atValley,recurrence⟩ := localLogRecurrence (by omega : 0<oddRuns x u)
      have prior := ih (oddRuns x v) (by omega) v rfl
      have rEq : r=oddRuns x v+1 := count.symm.trans atValley
      rw [rEq,geom]
      calc
        _ ≤ logHeight x+alpha*(oddCount x v : ℝ) := recurrence
        _ ≤ logHeight x+alpha*(geom (oddRuns x v)*logHeight x) :=
          add_le_add_left (mul_le_mul_of_nonneg_left prior (by norm_num [alpha])) _
        _ = _ := by ring
  exact bound _ t rfl

theorem geom_append (l m : Nat) : geom (l+m)=geom l+alpha^l*geom m := by
  induction l with
  | zero => simp [geom]
  | succ l ih =>
    rw [Nat.succ_add,geom,ih,geom,pow_succ]
    ring

private theorem absorbPair {l s : Nat} (recv : 0<l) (donor : 0<s) :
    geom l+geom s≤geom (l+s-1)+1 := by
  cases s with
  | zero => omega
  | succ s =>
    rw [show l+(s+1)-1=l+s by omega,geom_append l s]
    change geom l+(1+alpha*geom s)≤geom l+alpha^l*geom s+1
    have powers : alpha≤alpha^l := by
      have h := pow_le_pow_right₀ (by norm_num [alpha] : 1≤alpha) (show 1≤l by omega)
      simpa only [pow_one] using h
    have contribution := mul_le_mul_of_nonneg_right powers (geom_nonneg s)
    linarith

private theorem absorbRemaining (ls : List Nat) {l : Nat} (recv : 0<l)
    (positive : ∀ a ∈ ls, 0<a) :
    geom l+(ls.map geom).sum≤geom (l+ls.sum-ls.length)+ls.length := by
  induction ls generalizing l with
  | nil => simp
  | cons s ls ih =>
    have donor := positive s List.mem_cons_self
    have first := absorbPair recv donor
    have rest := ih (l:=l+s-1) (by omega)
      (fun a mem => positive a (List.mem_cons_of_mem _ mem))
    have final : l+s-1+ls.sum-ls.length=l+(s::ls).sum-(s::ls).length := by
      simp only [List.sum_cons,List.length_cons]
      omega
    rw [final] at rest
    simp only [List.map_cons,List.sum_cons,List.length_cons,Nat.cast_succ] at rest ⊢
    linarith

private theorem length_le_total (ls : List Nat) (positive : ∀ a ∈ ls, 0<a) :
    ls.length≤ls.sum := by
  induction ls with
  | nil => simp
  | cons s ls ih =>
    have sPos := positive s List.mem_cons_self
    have rest := ih (fun a mem => positive a (List.mem_cons_of_mem _ mem))
    simp only [List.length_cons,List.sum_cons]
    omega

/-- Compare real geometric capacities with the same count of physical
segments. One receiver takes every run beyond one per donor. -/
theorem absorbGeometric (ls : List Nat) (positive : ∀ a ∈ ls, 0<a) :
    (ls.map geom).sum≤geom (ls.sum-ls.length+1)+(ls.length-1 : Nat) := by
  cases ls with
  | nil => simp [geom]
  | cons l ls =>
    have absorbed := absorbRemaining ls (positive l List.mem_cons_self)
      (fun a mem => positive a (List.mem_cons_of_mem _ mem))
    have tally := length_le_total ls (fun a mem => positive a (List.mem_cons_of_mem _ mem))
    have index : l+ls.sum-ls.length=(l::ls).sum-(l::ls).length+1 := by
      simp only [List.sum_cons,List.length_cons]
      have lPos := positive l List.mem_cons_self
      omega
    simpa only [index,List.map_cons,List.sum_cons,List.length_cons,Nat.add_sub_cancel] using absorbed

end TerrasOrdinaryRank
