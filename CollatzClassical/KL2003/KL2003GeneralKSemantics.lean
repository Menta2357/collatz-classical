import CollatzClassical.KL2003.KL2003GeneralKFloorWindow
import CollatzClassical.KL2003.KL2003M0BReachabilityAPI
import Mathlib.Order.ConditionallyCompleteLattice.Indexed

namespace CollatzClassical
namespace KL2003

/-!
Indexed source semantics for arbitrary `k`.  The current stage proves the
mode-independent envelope traffic (nonnegativity, member transfer, P1, and
P2).  Generic non-emptiness, P3, and D1/D2/D3 remain explicit consumers.
-/

def generalKModulus (k : Nat) : Nat := 3 ^ k

theorem generalKModulus_pos (k : Nat) :
    0 < generalKModulus k := by
  simp [generalKModulus]

abbrev TrackedMode (k : Nat) :=
  {m : Fin (generalKModulus k) // m.1 % 3 = 2}

abbrev ClassRootsK (k : Nat) (m : TrackedMode k) :=
  {a : Nat //
    a % generalKModulus k = m.1.1 /\ NotInCycle a /\ 1 <= a}

def GeneralKClassRootsNonempty (k : Nat) : Prop :=
  forall m : TrackedMode k, Nonempty (ClassRootsK k m)

theorem generalK_T_two_pow {n : Nat} (hn : 0 < n) :
    T (2 ^ n) = 2 ^ (n - 1) := by
  obtain ⟨r, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : n != 0)
  simp [T, pow_succ, Nat.add_sub_cancel]

theorem generalK_iterate_T_two_pow_of_le {n q : Nat}
    (hq : q <= n) :
    T^[q] (2 ^ n) = 2 ^ (n - q) := by
  induction q generalizing n with
  | zero => simp
  | succ q ih =>
      have hn : 0 < n := by omega
      rw [Function.iterate_succ_apply']
      rw [generalK_T_two_pow hn]
      have hq' : q <= n - 1 := by omega
      rw [ih hq']
      congr 1
      omega

theorem generalK_T_le_two_of_le_two {n : Nat} (hn : n <= 2) :
    T n <= 2 := by
  have hcases : n = 0 \/ n = 1 \/ n = 2 := by omega
  rcases hcases with rfl | rfl | rfl <;> norm_num [T]

theorem generalK_iterate_one_le_two (q : Nat) :
    T^[q] 1 <= 2 := by
  induction q with
  | zero => simp
  | succ q ih =>
      simpa [Function.iterate_succ_apply'] using
        generalK_T_le_two_of_le_two ih

theorem notInCycle_two_pow {n : Nat} (hn : 2 <= n) :
    NotInCycle (2 ^ n) := by
  intro q hq hcycle
  by_cases hqn : q <= n
  · have hformula := generalK_iterate_T_two_pow_of_le hqn
    have hsub : n - q < n := Nat.sub_lt (by omega) hq
    have hlt : 2 ^ (n - q) < 2 ^ n :=
      pow_lt_pow_right (by norm_num : 1 < (2 : Nat)) hsub
    rw [hcycle] at hformula
    exact (ne_of_lt hlt) hformula.symm
  · have hnq : n <= q := by omega
    have hsplit : (q - n) + n = q := by omega
    have hle : T^[q] (2 ^ n) <= 2 := by
      calc
        T^[q] (2 ^ n) = T^[(q - n) + n] (2 ^ n) := by rw [hsplit]
        _ = T^[q - n] (T^[n] (2 ^ n)) := by
          rw [Function.iterate_add_apply]
        _ = T^[q - n] 1 := by
          rw [generalK_iterate_T_two_pow_of_le (le_refl n)]
          simp
        _ <= 2 := generalK_iterate_one_le_two (q - n)
    have hpowGt : 2 < 2 ^ n := by
      have hpow : 2 ^ 1 < 2 ^ n :=
        pow_lt_pow_right (by norm_num : 1 < (2 : Nat)) (by omega)
      simpa using hpow
    rw [hcycle] at hle
    omega

theorem k3_classRoots_nonempty :
    GeneralKClassRootsNonempty 3 := by
  intro m
  have hmLt : m.1.1 < 27 := by
    simpa [generalKModulus] using m.1.2
  have hmMod : m.1.1 % 3 = 2 := m.2
  have hcases :
      m.1.1 = 2 \/ m.1.1 = 5 \/ m.1.1 = 8 \/
      m.1.1 = 11 \/ m.1.1 = 14 \/ m.1.1 = 17 \/
      m.1.1 = 20 \/ m.1.1 = 23 \/ m.1.1 = 26 := by
    omega
  rcases hcases with h | h | h | h | h | h | h | h | h
  · exact ⟨⟨2 ^ 19, by norm_num [generalKModulus, h],
      notInCycle_two_pow (by norm_num), by norm_num⟩⟩
  · exact ⟨⟨2 ^ 5, by norm_num [generalKModulus, h],
      notInCycle_two_pow (by norm_num), by norm_num⟩⟩
  · exact ⟨⟨2 ^ 3, by norm_num [generalKModulus, h],
      notInCycle_two_pow (by norm_num), by norm_num⟩⟩
  · exact ⟨⟨2 ^ 13, by norm_num [generalKModulus, h],
      notInCycle_two_pow (by norm_num), by norm_num⟩⟩
  · exact ⟨⟨2 ^ 17, by norm_num [generalKModulus, h],
      notInCycle_two_pow (by norm_num), by norm_num⟩⟩
  · exact ⟨⟨2 ^ 15, by norm_num [generalKModulus, h],
      notInCycle_two_pow (by norm_num), by norm_num⟩⟩
  · exact ⟨⟨2 ^ 7, by norm_num [generalKModulus, h],
      notInCycle_two_pow (by norm_num), by norm_num⟩⟩
  · exact ⟨⟨2 ^ 11, by norm_num [generalKModulus, h],
      notInCycle_two_pow (by norm_num), by norm_num⟩⟩
  · exact ⟨⟨2 ^ 9, by norm_num [generalKModulus, h],
      notInCycle_two_pow (by norm_num), by norm_num⟩⟩

noncomputable def sourcePhiK {k : Nat}
    (m : TrackedMode k) (y : Real) : Real := by
  classical
  exact
    if y < 0 then 0
    else iInf fun a : ClassRootsK k m =>
      (piStar a.1 (sourceWindow y a.1) : Real)

theorem sourcePhiK_range_bddBelow {k : Nat} {m : TrackedMode k}
    {y : Real} :
    BddBelow
      (Set.range fun a : ClassRootsK k m =>
        (piStar a.1 (sourceWindow y a.1) : Real)) := by
  refine ⟨0, ?_⟩
  rintro _ ⟨a, rfl⟩
  exact Nat.cast_nonneg _

theorem sourcePhiK_nonneg {k : Nat}
    (roots : GeneralKClassRootsNonempty k)
    {m : TrackedMode k} {y : Real} :
    0 <= sourcePhiK m y := by
  classical
  by_cases hy : y < 0
  · simp [sourcePhiK, hy]
  · letI : Nonempty (ClassRootsK k m) := roots m
    simp only [sourcePhiK, hy, ↓reduceIte]
    refine le_ciInf ?_
    intro a
    exact Nat.cast_nonneg _

theorem sourcePhiK_le_piStar {k : Nat}
    {m : TrackedMode k} {y : Real}
    (hy : 0 <= y) (a : ClassRootsK k m) :
    sourcePhiK m y <=
      (piStar a.1 (sourceWindow y a.1) : Real) := by
  classical
  simp only [sourcePhiK, not_lt_of_ge hy, ↓reduceIte]
  exact ciInf_le sourcePhiK_range_bddBelow a

theorem le_sourcePhiK_of_forall_mode {k : Nat}
    {m : TrackedMode k} {y bound : Real}
    [Nonempty (ClassRootsK k m)]
    (hy : 0 <= y)
    (hbound : forall a : ClassRootsK k m,
      bound <= (piStar a.1 (sourceWindow y a.1) : Real)) :
    bound <= sourcePhiK m y := by
  classical
  simpa [sourcePhiK, not_lt_of_ge hy] using le_ciInf hbound

theorem le_sourcePhiK_of_forall {k : Nat}
    (roots : GeneralKClassRootsNonempty k)
    {m : TrackedMode k} {y bound : Real}
    (hy : 0 <= y)
    (hbound : forall a : ClassRootsK k m,
      bound <= (piStar a.1 (sourceWindow y a.1) : Real)) :
    bound <= sourcePhiK m y := by
  letI : Nonempty (ClassRootsK k m) := roots m
  exact le_sourcePhiK_of_forall_mode hy hbound

theorem sourcePhiK_one_le {k : Nat}
    (roots : GeneralKClassRootsNonempty k)
    {m : TrackedMode k} {y : Real}
    (hy : 0 <= y) :
    1 <= sourcePhiK m y := by
  apply le_sourcePhiK_of_forall roots hy
  intro a
  have hroot : a.1 <= sourceWindow y a.1 := root_le_sourceWindow hy
  have hcount : 1 <= piStar a.1 (sourceWindow y a.1) :=
    one_le_piStar_of_one_le_a_le_x a.2.2.2 hroot
  exact_mod_cast hcount

theorem sourcePhiK_mono_y {k : Nat}
    (roots : GeneralKClassRootsNonempty k)
    {m : TrackedMode k} {y1 y2 : Real}
    (hy : y1 <= y2) :
    sourcePhiK m y1 <= sourcePhiK m y2 := by
  classical
  by_cases hy1neg : y1 < 0
  · have hleft : sourcePhiK m y1 = 0 := by
      simp [sourcePhiK, hy1neg]
    rw [hleft]
    exact sourcePhiK_nonneg roots
  · have hy10 : 0 <= y1 := le_of_not_gt hy1neg
    have hy20 : 0 <= y2 := hy10.trans hy
    letI : Nonempty (ClassRootsK k m) := roots m
    simp only [sourcePhiK, not_lt_of_ge hy10, not_lt_of_ge hy20,
      ↓reduceIte]
    refine le_ciInf ?_
    intro a
    have hwindow :
        sourceWindow y1 a.1 <= sourceWindow y2 a.1 :=
      sourceWindow_mono_y hy
    have hcount :
        (piStar a.1 (sourceWindow y1 a.1) : Real) <=
          (piStar a.1 (sourceWindow y2 a.1) : Real) := by
      exact_mod_cast piStar_window_mono (a := a.1) hwindow
    exact (ciInf_le sourcePhiK_range_bddBelow a).trans hcount

theorem sourcePhiK_three_one_le {m : TrackedMode 3} {y : Real}
    (hy : 0 <= y) :
    1 <= sourcePhiK m y :=
  sourcePhiK_one_le k3_classRoots_nonempty hy

theorem sourcePhiK_three_mono_y {m : TrackedMode 3} {y1 y2 : Real}
    (hy : y1 <= y2) :
    sourcePhiK m y1 <= sourcePhiK m y2 :=
  sourcePhiK_mono_y k3_classRoots_nonempty hy

def liftTrackedMode {k : Nat} (hk : 1 <= k)
    (m : TrackedMode k) (j : Fin 3) : TrackedMode (k + 1) := by
  refine ⟨⟨m.1.1 + j.1 * generalKModulus k, ?_⟩, ?_⟩
  · have hm := m.1.2
    have hj := j.2
    simp only [generalKModulus, pow_succ]
    interval_cases j.1 <;> omega
  · obtain ⟨r, rfl⟩ := Nat.exists_eq_add_of_le hk
    simpa [generalKModulus, pow_succ, Nat.add_mod] using m.2

theorem liftTrackedMode_value {k : Nat} (hk : 1 <= k)
    (m : TrackedMode k) (j : Fin 3) :
    (liftTrackedMode hk m j).1.1 =
      m.1.1 + j.1 * generalKModulus k := rfl

def classRootOfLift {k : Nat} (hk : 1 <= k)
    (m : TrackedMode k) (j : Fin 3)
    (a : ClassRootsK (k + 1) (liftTrackedMode hk m j)) :
    ClassRootsK k m := by
  refine ⟨a.1, ?_, a.2.2.1, a.2.2.2⟩
  have hchild := a.2.1
  have hdiv : generalKModulus k ∣ generalKModulus (k + 1) := by
    simp only [generalKModulus, pow_succ]
    exact dvd_mul_right _ _
  calc
    a.1 % generalKModulus k =
        (a.1 % generalKModulus (k + 1)) % generalKModulus k :=
      (Nat.mod_mod_of_dvd a.1 hdiv).symm
    _ = (m.1.1 + j.1 * generalKModulus k) % generalKModulus k := by
      rw [hchild, liftTrackedMode_value]
    _ = m.1.1 := by
      rw [Nat.add_mul_mod_self_left, Nat.mod_eq_of_lt m.1.2]

def classRootLiftIndex {k : Nat} (a : Nat) : Fin 3 :=
  ⟨(a / generalKModulus k) % 3, Nat.mod_lt _ (by norm_num)⟩

theorem classRootLiftIndex_value {k : Nat} (a : Nat) :
    (classRootLiftIndex (k := k) a).1 =
      (a / generalKModulus k) % 3 := rfl

theorem classRoot_parent_residue_at_lift {k : Nat}
    (m : TrackedMode k) (a : ClassRootsK k m) :
    a.1 % generalKModulus (k + 1) =
      m.1.1 +
        (classRootLiftIndex (k := k) a.1).1 * generalKModulus k := by
  let M := generalKModulus k
  let j := (a.1 / M) % 3
  let q := (a.1 / M) / 3
  have hM : 0 < M := generalKModulus_pos k
  have hm : m.1.1 < M := m.1.2
  have hj : j < 3 := Nat.mod_lt _ (by norm_num)
  have haDecomp : a.1 % M + M * (a.1 / M) = a.1 :=
    Nat.mod_add_div _ _
  have hqDecomp : j + 3 * q = a.1 / M := by
    simpa [j, q] using Nat.mod_add_div (a.1 / M) 3
  have ha : a.1 = (m.1.1 + j * M) + (M * 3) * q := by
    rw [← haDecomp, a.2.1, ← hqDecomp]
    ring
  have htarget : m.1.1 + j * M < M * 3 := by
    interval_cases j <;> omega
  simp only [generalKModulus, pow_succ]
  change a.1 % (M * 3) = m.1.1 + j * M
  rw [ha]
  simpa [Nat.mod_eq_of_lt htarget] using
    Nat.add_mul_mod_self_left (m.1.1 + j * M) q (M * 3)

def classRootAtLift {k : Nat} (hk : 1 <= k)
    (m : TrackedMode k) (a : ClassRootsK k m) :
    ClassRootsK (k + 1)
      (liftTrackedMode hk m (classRootLiftIndex (k := k) a.1)) := by
  refine ⟨a.1, ?_, a.2.2.1, a.2.2.2⟩
  rw [liftTrackedMode_value]
  exact classRoot_parent_residue_at_lift m a

def sourcePhiK_liftMin3 {k : Nat} (hk : 1 <= k)
    (m : TrackedMode k) (y : Real) : Real :=
  min (sourcePhiK (liftTrackedMode hk m 0) y)
    (min (sourcePhiK (liftTrackedMode hk m 1) y)
      (sourcePhiK (liftTrackedMode hk m 2) y))

theorem sourcePhiK_liftMin3_le_child {k : Nat} (hk : 1 <= k)
    (m : TrackedMode k) (y : Real) (j : Fin 3) :
    sourcePhiK_liftMin3 hk m y <=
      sourcePhiK (liftTrackedMode hk m j) y := by
  fin_cases j <;> simp [sourcePhiK_liftMin3]

theorem sourcePhiK_P3 {k : Nat} (hk : 1 <= k)
    (roots : GeneralKClassRootsNonempty (k + 1))
    (m : TrackedMode k) {y : Real} (hy : 0 <= y) :
    sourcePhiK m y = sourcePhiK_liftMin3 hk m y := by
  apply le_antisymm
  · refine le_min ?_ (le_min ?_ ?_)
    all_goals
      apply le_sourcePhiK_of_forall roots hy
      intro a
      simpa using sourcePhiK_le_piStar hy (classRootOfLift hk m _ a)
  · let child0 : TrackedMode (k + 1) := liftTrackedMode hk m 0
    letI : Nonempty (ClassRootsK k m) :=
      Nonempty.map (classRootOfLift hk m 0) (roots child0)
    apply le_sourcePhiK_of_forall_mode hy
    intro a
    let aChild := classRootAtLift hk m a
    exact (sourcePhiK_liftMin3_le_child hk m y
      (classRootLiftIndex (k := k) a.1)).trans
        (by simpa [aChild] using sourcePhiK_le_piStar hy aChild)

theorem sourcePhiK_P3_two_to_three (m : TrackedMode 2)
    {y : Real} (hy : 0 <= y) :
    sourcePhiK m y = sourcePhiK_liftMin3 (by norm_num) m y :=
  sourcePhiK_P3 (by norm_num) k3_classRoots_nonempty m hy

end KL2003
end CollatzClassical
