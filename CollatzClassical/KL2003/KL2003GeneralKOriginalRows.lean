import CollatzClassical.KL2003.KL2003GeneralKSemantics
import CollatzClassical.KL2003.KL2003M0BD123CoreInstantiations

namespace CollatzClassical
namespace KL2003

/-!
Source-faithful original difference rows for arbitrary `k`.  This file keeps
all residue operators indexed by `TrackedMode`; no k=2 row is used as a source.
-/

theorem classRootK_mod_three {k : Nat} (hk : 1 <= k)
    (m : TrackedMode k) (a : ClassRootsK k m) :
    a.1 % 3 = 2 := by
  have hdiv : 3 ∣ generalKModulus k := by
    obtain ⟨r, rfl⟩ := Nat.exists_eq_add_of_le hk
    rw [generalKModulus, show 1 + r = r + 1 by omega, pow_succ]
    exact dvd_mul_left _ _
  calc
    a.1 % 3 = (a.1 % generalKModulus k) % 3 :=
      (Nat.mod_mod_of_dvd a.1 hdiv).symm
    _ = m.1.1 % 3 := by rw [a.2.1]
    _ = 2 := m.2

def sourceAdvancedChild (a : Nat) : Nat :=
  (2 * a - 1) / 3

theorem sourceAdvancedChild_arith {a : Nat} (ha : a % 3 = 2) :
    3 * sourceAdvancedChild a + 1 = 2 * a := by
  have hdecomp : a = 3 * (a / 3) + 2 := by
    have h := Nat.mod_add_div a 3
    omega
  simp only [sourceAdvancedChild]
  omega

theorem sourceAdvancedChild_pos {a : Nat} (ha : a % 3 = 2) :
    1 <= sourceAdvancedChild a := by
  have harith := sourceAdvancedChild_arith ha
  omega

theorem sourceAdvancedChild_maps_to_root {a : Nat} (ha : a % 3 = 2) :
    T (sourceAdvancedChild a) = a :=
  two_branch_advanced_child_maps_to_root (sourceAdvancedChild_arith ha)

def fourTrackedMode {k : Nat} (hk : 1 <= k)
    (m : TrackedMode k) : TrackedMode k := by
  refine ⟨⟨(4 * m.1.1) % generalKModulus k,
    Nat.mod_lt _ (generalKModulus_pos k)⟩, ?_⟩
  have hdiv : 3 ∣ generalKModulus k := by
    obtain ⟨r, rfl⟩ := Nat.exists_eq_add_of_le hk
    rw [generalKModulus, show 1 + r = r + 1 by omega, pow_succ]
    exact dvd_mul_left _ _
  calc
    ((4 * m.1.1) % generalKModulus k) % 3 =
        (4 * m.1.1) % 3 := Nat.mod_mod_of_dvd _ hdiv
    _ = 2 := by simp [Nat.mul_mod, m.2]

theorem fourTrackedMode_value {k : Nat} (hk : 1 <= k)
    (m : TrackedMode k) :
    (fourTrackedMode hk m).1.1 =
      (4 * m.1.1) % generalKModulus k := rfl

theorem T_two_steps_four_mul (a : Nat) :
    T^[2] (4 * a) = a :=
  two_branch_T_two_steps_four_mul a

def retardedClassRootK {k : Nat} (hk : 1 <= k)
    (m : TrackedMode k) (a : ClassRootsK k m) :
    ClassRootsK k (fourTrackedMode hk m) := by
  refine ⟨4 * a.1, ?_, ?_, by omega⟩
  · rw [fourTrackedMode_value]
    have hamod : a.1 ≡ m.1.1 [MOD generalKModulus k] := by
      change a.1 % generalKModulus k = m.1.1 % generalKModulus k
      rw [a.2.1, Nat.mod_eq_of_lt m.1.2]
    exact hamod.mul_left 4
  · exact notInCycle_of_iterate_maps_to_notInCycle
      a.2.2.1 (T_two_steps_four_mul a.1)

theorem trackedMode_mod_nine_cases {k : Nat}
    (m : TrackedMode k) :
    m.1.1 % 9 = 2 \/ m.1.1 % 9 = 5 \/ m.1.1 % 9 = 8 := by
  have hmod := m.2
  omega

def d1RawLowerModeValue (m : Nat) : Nat :=
  (4 * m - 2) / 3

def d3RawLowerModeValue (m : Nat) : Nat :=
  (2 * m - 1) / 3

theorem d1RawLowerModeValue_decomp {m : Nat} (hm : m % 9 = 2) :
    d1RawLowerModeValue m = 12 * (m / 9) + 2 := by
  have hdecomp : m = 9 * (m / 9) + 2 := by
    have h := Nat.mod_add_div m 9
    omega
  simp only [d1RawLowerModeValue]
  omega

theorem d3RawLowerModeValue_decomp {m : Nat} (hm : m % 9 = 8) :
    d3RawLowerModeValue m = 6 * (m / 9) + 5 := by
  have hdecomp : m = 9 * (m / 9) + 8 := by
    have h := Nat.mod_add_div m 9
    omega
  simp only [d3RawLowerModeValue]
  omega

theorem d1RawLowerModeValue_arith {m : Nat} (hm : m % 9 = 2) :
    3 * d1RawLowerModeValue m + 2 = 4 * m := by
  rw [d1RawLowerModeValue_decomp hm]
  have hdecomp : m = 9 * (m / 9) + 2 := by
    have h := Nat.mod_add_div m 9
    omega
  omega

theorem d3RawLowerModeValue_arith {m : Nat} (hm : m % 9 = 8) :
    3 * d3RawLowerModeValue m + 1 = 2 * m := by
  rw [d3RawLowerModeValue_decomp hm]
  have hdecomp : m = 9 * (m / 9) + 8 := by
    have h := Nat.mod_add_div m 9
    omega
  omega

def d1LowerTrackedMode {p : Nat} (hp : 1 <= p)
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 2) :
    TrackedMode p := by
  refine ⟨⟨d1RawLowerModeValue m.1.1 % generalKModulus p,
    Nat.mod_lt _ (generalKModulus_pos p)⟩, ?_⟩
  have hdiv : 3 ∣ generalKModulus p := by
    obtain ⟨r, rfl⟩ := Nat.exists_eq_add_of_le hp
    rw [generalKModulus, show 1 + r = r + 1 by omega, pow_succ]
    exact dvd_mul_left _ _
  rw [Nat.mod_mod_of_dvd _ hdiv, d1RawLowerModeValue_decomp hm]
  omega

def d3LowerTrackedMode {p : Nat} (hp : 1 <= p)
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 8) :
    TrackedMode p := by
  refine ⟨⟨d3RawLowerModeValue m.1.1 % generalKModulus p,
    Nat.mod_lt _ (generalKModulus_pos p)⟩, ?_⟩
  have hdiv : 3 ∣ generalKModulus p := by
    obtain ⟨r, rfl⟩ := Nat.exists_eq_add_of_le hp
    rw [generalKModulus, show 1 + r = r + 1 by omega, pow_succ]
    exact dvd_mul_left _ _
  rw [Nat.mod_mod_of_dvd _ hdiv, d3RawLowerModeValue_decomp hm]
  omega

theorem classRootK_modEq_mode {k : Nat} (m : TrackedMode k)
    (a : ClassRootsK k m) :
    a.1 ≡ m.1.1 [MOD generalKModulus k] := by
  change a.1 % generalKModulus k = m.1.1 % generalKModulus k
  rw [a.2.1, Nat.mod_eq_of_lt m.1.2]

theorem generalKModulus_succ (p : Nat) :
    generalKModulus (p + 1) = 3 * generalKModulus p := by
  simp [generalKModulus, pow_succ, Nat.mul_comm]

theorem d1_lifted_child_modEq_raw {p : Nat} (hp : 1 <= p)
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 2)
    (a : ClassRootsK (p + 1) m) :
    2 * sourceAdvancedChild a.1 ≡ d1RawLowerModeValue m.1.1
      [MOD generalKModulus p] := by
  have ha3 : a.1 % 3 = 2 := classRootK_mod_three (by omega) m a
  have hroot := sourceAdvancedChild_arith ha3
  have hmode := d1RawLowerModeValue_arith hm
  have hmul : 4 * a.1 ≡ 4 * m.1.1 [MOD generalKModulus (p + 1)] :=
    (classRootK_modEq_mode m a).mul_left 4
  have hadd :
      3 * (2 * sourceAdvancedChild a.1) + 2 ≡
        3 * d1RawLowerModeValue m.1.1 + 2
        [MOD generalKModulus (p + 1)] := by
    rw [show 3 * (2 * sourceAdvancedChild a.1) + 2 = 4 * a.1 by
      omega]
    rw [hmode]
    exact hmul
  have hthree :
      3 * (2 * sourceAdvancedChild a.1) ≡
        3 * d1RawLowerModeValue m.1.1
        [MOD generalKModulus (p + 1)] :=
    hadd.add_right_cancel' 2
  have hthree' :
      3 * (2 * sourceAdvancedChild a.1) ≡
        3 * d1RawLowerModeValue m.1.1
        [MOD 3 * generalKModulus p] := by
    simpa [generalKModulus_succ] using hthree
  exact hthree'.mul_left_cancel' (by norm_num)

theorem d3_child_modEq_raw {p : Nat} (hp : 1 <= p)
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 8)
    (a : ClassRootsK (p + 1) m) :
    sourceAdvancedChild a.1 ≡ d3RawLowerModeValue m.1.1
      [MOD generalKModulus p] := by
  have ha3 : a.1 % 3 = 2 := classRootK_mod_three (by omega) m a
  have hroot := sourceAdvancedChild_arith ha3
  have hmode := d3RawLowerModeValue_arith hm
  have hmul : 2 * a.1 ≡ 2 * m.1.1 [MOD generalKModulus (p + 1)] :=
    (classRootK_modEq_mode m a).mul_left 2
  have hadd :
      3 * sourceAdvancedChild a.1 + 1 ≡
        3 * d3RawLowerModeValue m.1.1 + 1
        [MOD generalKModulus (p + 1)] := by
    simpa [hroot, hmode] using hmul
  have hthree :
      3 * sourceAdvancedChild a.1 ≡
        3 * d3RawLowerModeValue m.1.1
        [MOD generalKModulus (p + 1)] :=
    hadd.add_right_cancel' 1
  have hthree' :
      3 * sourceAdvancedChild a.1 ≡
        3 * d3RawLowerModeValue m.1.1
        [MOD 3 * generalKModulus p] := by
    simpa [generalKModulus_succ] using hthree
  exact hthree'.mul_left_cancel' (by norm_num)

theorem sourceLiftedAdvancedChild_maps_to_root {a : Nat}
    (ha : a % 3 = 2) :
    T^[2] (2 * sourceAdvancedChild a) = a := by
  calc
    T^[2] (2 * sourceAdvancedChild a) =
        T (T (2 * sourceAdvancedChild a)) := by rfl
    _ = T (sourceAdvancedChild a) := by
      rw [two_branch_T_two_mul]
    _ = a := sourceAdvancedChild_maps_to_root ha

def d1LiftedClassRootK {p : Nat} (hp : 1 <= p)
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 2)
    (a : ClassRootsK (p + 1) m) :
    ClassRootsK p (d1LowerTrackedMode hp m hm) := by
  have ha3 : a.1 % 3 = 2 := classRootK_mod_three (by omega) m a
  refine ⟨2 * sourceAdvancedChild a.1, ?_, ?_, by
    have := sourceAdvancedChild_pos ha3
    omega⟩
  · exact d1_lifted_child_modEq_raw hp m hm a
  · exact notInCycle_of_iterate_maps_to_notInCycle a.2.2.1
      (sourceLiftedAdvancedChild_maps_to_root ha3)

def d3AdvancedClassRootK {p : Nat} (hp : 1 <= p)
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 8)
    (a : ClassRootsK (p + 1) m) :
    ClassRootsK p (d3LowerTrackedMode hp m hm) := by
  have ha3 : a.1 % 3 = 2 := classRootK_mod_three (by omega) m a
  refine ⟨sourceAdvancedChild a.1, ?_, ?_, sourceAdvancedChild_pos ha3⟩
  · exact d3_child_modEq_raw hp m hm a
  · exact notInCycle_of_iterate_maps_to_notInCycle (k := 1) a.2.2.1
      (by simpa [Function.iterate_one] using sourceAdvancedChild_maps_to_root ha3)

theorem sourcePhiK_D2 {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    (m : TrackedMode (p + 1)) (_hm : m.1.1 % 9 = 5)
    {y : Real} (hy : 2 <= y) :
    sourcePhiK (fourTrackedMode (by omega) m) (y - 2) <=
      sourcePhiK m y := by
  have hy0 : 0 <= y := by linarith
  have hyRet : 0 <= y - 2 := by linarith
  apply le_sourcePhiK_of_forall roots hy0
  intro a
  let ret := retardedClassRootK (by omega : 1 <= p + 1) m a
  have hret :
      sourcePhiK (fourTrackedMode (by omega) m) (y - 2) <=
        (piStar (4 * a.1) (sourceWindow (y - 2) (4 * a.1)) : Real) := by
    simpa [ret] using sourcePhiK_le_piStar hyRet ret
  have ha3 : a.1 % 3 = 2 := classRootK_mod_three (by omega) m a
  have hcore := d2_single_branch_core_instantiation
    (a := a.1) (c := sourceAdvancedChild a.1)
    (x := sourceWindow y a.1)
    (xRet := sourceWindow (y - 2) (4 * a.1))
    a.2.2.2 a.2.2.1 (sourceAdvancedChild_arith ha3)
    (root_le_sourceWindow hy0)
    (by rw [sourceWindow_retarded_four])
  have hcoreR :
      (piStar (4 * a.1) (sourceWindow (y - 2) (4 * a.1)) : Real) <=
        (piStar a.1 (sourceWindow y a.1) : Real) := by
    exact_mod_cast hcore
  exact hret.trans hcoreR

theorem sourcePhiK_D3 {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 8)
    {y : Real} (hy : 2 <= y) :
    sourcePhiK (fourTrackedMode (by omega) m) (y - 2) +
        sourcePhiK (d3LowerTrackedMode hp m hm) (y + alpha - 1) <=
      sourcePhiK m y := by
  have hy0 : 0 <= y := by linarith
  have hyRet : 0 <= y - 2 := by linarith
  have hyAdv : 0 <= y + alpha - 1 := by
    have halpha := alpha_lower_bound
    linarith
  apply le_sourcePhiK_of_forall roots hy0
  intro a
  let ret := retardedClassRootK (by omega : 1 <= p + 1) m a
  let adv := d3AdvancedClassRootK hp m hm a
  have hret :
      sourcePhiK (fourTrackedMode (by omega) m) (y - 2) <=
        (piStar (4 * a.1) (sourceWindow (y - 2) (4 * a.1)) : Real) := by
    simpa [ret] using sourcePhiK_le_piStar hyRet ret
  have hadv :
      sourcePhiK (d3LowerTrackedMode hp m hm) (y + alpha - 1) <=
        (piStar (sourceAdvancedChild a.1)
          (sourceWindow (y + alpha - 1) (sourceAdvancedChild a.1)) : Real) := by
    simpa [adv] using sourcePhiK_le_piStar hyAdv adv
  have ha3 : a.1 % 3 = 2 := classRootK_mod_three (by omega) m a
  have hchild := sourceAdvancedChild_arith ha3
  have hcore := d3_core_instantiation
    (a := a.1) (c := sourceAdvancedChild a.1)
    (x := sourceWindow y a.1)
    (xRet := sourceWindow (y - 2) (4 * a.1))
    (xAdv := sourceWindow (y + alpha - 1) (sourceAdvancedChild a.1))
    a.2.2.2 a.2.2.1 hchild
    (root_le_sourceWindow hy0)
    (by rw [sourceWindow_retarded_four])
    (sourceWindow_advanced_child_le_target hchild)
  have hcoreR :
      (piStar (4 * a.1) (sourceWindow (y - 2) (4 * a.1)) : Real) +
          (piStar (sourceAdvancedChild a.1)
            (sourceWindow (y + alpha - 1) (sourceAdvancedChild a.1)) : Real) <=
        (piStar a.1 (sourceWindow y a.1) : Real) := by
    exact_mod_cast hcore
  linarith

theorem sourcePhiK_D1 {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 2)
    {y : Real} (hy : 2 <= y) :
    sourcePhiK (fourTrackedMode (by omega) m) (y - 2) +
        sourcePhiK (d1LowerTrackedMode hp m hm) (y + alpha - 2) <=
      sourcePhiK m y := by
  have hy0 : 0 <= y := by linarith
  have hyRet : 0 <= y - 2 := by linarith
  have hyAdv : 0 <= y + alpha - 2 := by
    have halpha := alpha_lower_bound
    linarith
  apply le_sourcePhiK_of_forall roots hy0
  intro a
  let ret := retardedClassRootK (by omega : 1 <= p + 1) m a
  let adv := d1LiftedClassRootK hp m hm a
  have hret :
      sourcePhiK (fourTrackedMode (by omega) m) (y - 2) <=
        (piStar (4 * a.1) (sourceWindow (y - 2) (4 * a.1)) : Real) := by
    simpa [ret] using sourcePhiK_le_piStar hyRet ret
  have hadvLift :
      sourcePhiK (d1LowerTrackedMode hp m hm) (y + alpha - 2) <=
        (piStar (2 * sourceAdvancedChild a.1)
          (sourceWindow (y + alpha - 2)
            (2 * sourceAdvancedChild a.1)) : Real) := by
    simpa [adv] using sourcePhiK_le_piStar hyAdv adv
  have hparity :
      (piStar (2 * sourceAdvancedChild a.1)
          (sourceWindow (y + alpha - 2)
            (2 * sourceAdvancedChild a.1)) : Real) <=
        (piStar (sourceAdvancedChild a.1)
          (sourceWindow (y + alpha - 1) (sourceAdvancedChild a.1)) : Real) := by
    exact_mod_cast piStar_two_mul_root_transfer_nat
      (c := sourceAdvancedChild a.1)
      (xLift := sourceWindow (y + alpha - 2)
        (2 * sourceAdvancedChild a.1))
      (x := sourceWindow (y + alpha - 1) (sourceAdvancedChild a.1))
      (by
        rw [show y + alpha - 2 = (y + alpha - 1) - 1 by ring]
        rw [sourceWindow_parity_two])
  have hadv := hadvLift.trans hparity
  have ha3 : a.1 % 3 = 2 := classRootK_mod_three (by omega) m a
  have hchild := sourceAdvancedChild_arith ha3
  have hcore := d1_core_instantiation
    (a := a.1) (c := sourceAdvancedChild a.1)
    (x := sourceWindow y a.1)
    (xRet := sourceWindow (y - 2) (4 * a.1))
    (xAdv := sourceWindow (y + alpha - 1) (sourceAdvancedChild a.1))
    a.2.2.2 a.2.2.1 hchild
    (root_le_sourceWindow hy0)
    (by rw [sourceWindow_retarded_four])
    (sourceWindow_advanced_child_le_target hchild)
  have hcoreR :
      (piStar (4 * a.1) (sourceWindow (y - 2) (4 * a.1)) : Real) +
          (piStar (sourceAdvancedChild a.1)
            (sourceWindow (y + alpha - 1) (sourceAdvancedChild a.1)) : Real) <=
        (piStar a.1 (sourceWindow y a.1) : Real) := by
    exact_mod_cast hcore
  linarith

structure SatisfiesIk (p : Nat) (hp : 1 <= p)
    (phiTop : TrackedMode (p + 1) -> Real -> Real)
    (phiLower : TrackedMode p -> Real -> Real) : Prop where
  d1 : forall (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 2)
    (y : Real), 2 <= y ->
      phiTop (fourTrackedMode (by omega) m) (y - 2) +
          phiLower (d1LowerTrackedMode hp m hm)
            (y + alpha - 2) <=
        phiTop m y
  d2 : forall (m : TrackedMode (p + 1)) (_hm : m.1.1 % 9 = 5)
    (y : Real), 2 <= y ->
      phiTop (fourTrackedMode (by omega) m) (y - 2) <= phiTop m y
  d3 : forall (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 8)
    (y : Real), 2 <= y ->
      phiTop (fourTrackedMode (by omega) m) (y - 2) +
          phiLower (d3LowerTrackedMode hp m hm)
            (y + alpha - 1) <=
        phiTop m y

theorem sourcePhiK_satisfies_Ik {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1)) :
    SatisfiesIk p hp
      (fun m y => sourcePhiK m y)
      (fun m y => sourcePhiK m y) := by
  constructor
  · intro m hm y hy
    exact sourcePhiK_D1 hp roots m hm hy
  · intro m hm y hy
    exact sourcePhiK_D2 hp roots m hm hy
  · intro m hm y hy
    exact sourcePhiK_D3 hp roots m hm hy

theorem sourcePhiK_three_satisfies_Ik :
    SatisfiesIk 2 (by norm_num)
      (fun m y => sourcePhiK m y)
      (fun m y => sourcePhiK m y) :=
  sourcePhiK_satisfies_Ik (by norm_num) k3_classRoots_nonempty

end KL2003
end CollatzClassical
