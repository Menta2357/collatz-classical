import CollatzClassical.KL2003.KL2003M0APiStarSemantics
import Mathlib.Data.Nat.Find
import Mathlib.Logic.Function.Iterate
import Mathlib.Tactic.Linarith

namespace CollatzClassical
namespace KL2003

def ReachesWithin (a x n : Nat) : Prop :=
  ∃ k,
    (∀ j, j <= k -> T^[j] n <= x) ∧
    T^[k] n = a

def InverseChild (a c : Nat) : Prop :=
  T c = a

def NotInCycle (a : Nat) : Prop :=
  ∀ q, 0 < q -> T^[q] a ≠ a

def PathWithin (src dst x len : Nat) : Prop :=
  (∀ j, j <= len -> T^[j] src <= x) ∧
    T^[len] src = dst

-- Auxiliary Prop-view finset for M0B reasoning.  The primary validated
-- definition remains `piStarFinset` from M0A.
noncomputable def piStarPropFinset (a x : Nat) : Finset Nat := by
  classical
  exact
    (Finset.range (x + 1)).filter
      (fun n => 1 <= n ∧ ReachesWithin a x n)

theorem reachesWithin_self {a x : Nat} (hax : a <= x) :
    ReachesWithin a x a := by
  refine ⟨0, ?_, ?_⟩
  · intro j hj
    have hj0 : j = 0 := by omega
    simpa [hj0] using hax
  · rfl

theorem reachesWithin_window_mono {a x X n : Nat}
    (h : ReachesWithin a x n) (hx : x <= X) :
    ReachesWithin a X n := by
  rcases h with ⟨k, hwin, hend⟩
  exact ⟨k, fun j hj => le_trans (hwin j hj) hx, hend⟩

theorem reachesWithin_append_path {src dst x X n len : Nat}
    (h : ReachesWithin src x n)
    (hx : x <= X)
    (hp : PathWithin src dst X len) :
    ReachesWithin dst X n := by
  rcases h with ⟨k, hwin, hend⟩
  rcases hp with ⟨hpwin, hpend⟩
  refine ⟨k + len, ?_, ?_⟩
  · intro j hj
    by_cases hjk : j <= k
    · exact le_trans (hwin j hjk) hx
    · have hsplit : (j - k) + k = j := by omega
      have hlen : j - k <= len := by omega
      calc
        T^[j] n = T^[j - k] src := by
          calc
            T^[j] n = T^[(j - k) + k] n := by rw [hsplit]
            _ = T^[j - k] (T^[k] n) := by rw [Function.iterate_add_apply]
            _ = T^[j - k] src := by rw [hend]
        _ <= X := hpwin (j - k) hlen
  · calc
      T^[k + len] n = T^[len + k] n := by rw [Nat.add_comm]
      _ = T^[len] (T^[k] n) := by rw [Function.iterate_add_apply]
      _ = T^[len] src := by rw [hend]
      _ = dst := hpend

theorem mem_piStarPropFinset_iff {a x n : Nat} :
    n ∈ piStarPropFinset a x ↔
      n <= x ∧ 1 <= n ∧ ReachesWithin a x n := by
  classical
  simp [piStarPropFinset, Nat.lt_succ_iff]

theorem boundedReachesWithFuel_sound {fuel a x n : Nat}
    (h : boundedReachesWithFuel fuel a x n = true) :
    ReachesWithin a x n := by
  induction fuel generalizing n with
  | zero =>
      simp [boundedReachesWithFuel] at h
      refine ⟨0, ?_, ?_⟩
      · intro j hj
        have hj0 : j = 0 := by omega
        simpa [hj0] using h.1
      · exact h.2
  | succ fuel ih =>
      simp [boundedReachesWithFuel] at h
      rcases h with ⟨hnx, hhit | hrec⟩
      · refine ⟨0, ?_, ?_⟩
        · intro j hj
          have hj0 : j = 0 := by omega
          simpa [hj0] using hnx
        · exact hhit
      · rcases ih hrec with ⟨k, hwin, hend⟩
        refine ⟨k + 1, ?_, ?_⟩
        · intro j hj
          cases j with
          | zero =>
              exact hnx
          | succ j =>
              have hjle : j <= k := by omega
              simpa [Function.iterate_succ_apply] using hwin j hjle
        · simpa [Function.iterate_succ_apply] using hend

theorem boundedReaches_sound {a x n : Nat}
    (h : boundedReaches a x n = true) :
    ReachesWithin a x n := by
  exact boundedReachesWithFuel_sound h

theorem boundedReachesWithFuel_complete_of_witness {fuel a x n k : Nat}
    (hwin : ∀ j, j <= k -> T^[j] n <= x)
    (hhit : T^[k] n = a)
    (hk : k <= fuel) :
    boundedReachesWithFuel fuel a x n = true := by
  induction fuel generalizing n k with
  | zero =>
      have hk0 : k = 0 := by omega
      have hnle : n <= x := by simpa [hk0] using hwin 0 (by omega)
      have hna : n = a := by simpa [hk0] using hhit
      have hale : a <= x := by simpa [hna] using hnle
      simp [boundedReachesWithFuel, hnle, hna, hale]
  | succ fuel ih =>
      have hnle : n <= x := by simpa using hwin 0 (by omega)
      by_cases hk0 : k = 0
      · have hna : n = a := by simpa [hk0] using hhit
        have hale : a <= x := by simpa [hna] using hnle
        simp [boundedReachesWithFuel, hnle, hna, hale]
      · have hwin_tail : ∀ j, j <= k - 1 -> T^[j] (T n) <= x := by
          intro j hj
          have hjk : j + 1 <= k := by omega
          simpa [Function.iterate_succ_apply] using hwin (j + 1) hjk
        have hhit_tail : T^[k - 1] (T n) = a := by
          calc
            T^[k - 1] (T n) = T^[(k - 1).succ] n := by
              exact (Function.iterate_succ_apply T (k - 1) n).symm
            _ = T^[k] n := by rw [show (k - 1).succ = k by omega]
            _ = a := hhit
        have hk_tail : k - 1 <= fuel := by omega
        have hrec := ih hwin_tail hhit_tail hk_tail
        simp [boundedReachesWithFuel, hnle, hrec]

theorem boundedReaches_complete_of_witness {a x n k : Nat}
    (hwin : ∀ j, j <= k -> T^[j] n <= x)
    (hhit : T^[k] n = a)
    (hk : k <= x + 1) :
    boundedReaches a x n = true := by
  exact boundedReachesWithFuel_complete_of_witness hwin hhit hk

def ReachesWithinFuelSufficient (a x n : Nat) : Prop :=
  ∀ _h : ReachesWithin a x n,
    ∃ k,
      k <= x + 1 ∧
      (∀ j, j <= k -> T^[j] n <= x) ∧
      T^[k] n = a

theorem boundedReaches_complete_of_fuel_sufficient {a x n : Nat}
    (hsuff : ReachesWithinFuelSufficient a x n)
    (h : ReachesWithin a x n) :
    boundedReaches a x n = true := by
  rcases hsuff h with ⟨k, hk, hwin, hhit⟩
  exact boundedReaches_complete_of_witness hwin hhit hk

theorem boundedReaches_iff_of_fuel_sufficient {a x n : Nat}
    (hsuff : ReachesWithinFuelSufficient a x n) :
    boundedReaches a x n = true ↔ ReachesWithin a x n := by
  exact
    ⟨ fun h => boundedReachesWithFuel_sound h,
      boundedReaches_complete_of_fuel_sufficient hsuff ⟩

theorem mem_piStarFinset_reachesWithin_of_mem {a x n : Nat}
    (h : n ∈ piStarFinset a x) :
    n <= x ∧ 1 <= n ∧ ReachesWithin a x n := by
  have hm := (mem_piStarFinset_iff (a := a) (x := x) (n := n)).1 h
  exact ⟨hm.1, hm.2.1, boundedReachesWithFuel_sound hm.2.2⟩

theorem mem_piStarFinset_reachesWithin_iff_of_fuel_sufficient {a x n : Nat}
    (hsuff : ReachesWithinFuelSufficient a x n) :
    n ∈ piStarFinset a x ↔
      n <= x ∧ 1 <= n ∧ ReachesWithin a x n := by
  rw [mem_piStarFinset_iff]
  constructor
  · intro h
    exact ⟨h.1, h.2.1, boundedReachesWithFuel_sound h.2.2⟩
  · intro h
    exact ⟨h.1, h.2.1, boundedReaches_complete_of_fuel_sufficient hsuff h.2.2⟩

theorem piStarPropFinset_eq_piStarFinset_of_fuel_sufficient {a x : Nat}
    (hsuff : ∀ n, ReachesWithinFuelSufficient a x n) :
    piStarPropFinset a x = piStarFinset a x := by
  ext n
  rw [mem_piStarPropFinset_iff,
    mem_piStarFinset_reachesWithin_iff_of_fuel_sufficient (hsuff n)]

theorem iterate_repeat_propagates {n j p : Nat}
    (h : T^[j] n = T^[j + p] n) :
    ∀ i, T^[j + i] n = T^[j + i + p] n := by
  intro i
  calc
    T^[j + i] n = T^[i + j] n := by rw [Nat.add_comm]
    _ = T^[i] (T^[j] n) := by
      exact Function.iterate_add_apply T i j n
    _ = T^[i] (T^[j + p] n) := by rw [h]
    _ = T^[i + (j + p)] n := by
      exact (Function.iterate_add_apply T i (j + p) n).symm
    _ = T^[j + i + p] n := by
      have hidx : i + (j + p) = j + i + p := by omega
      rw [hidx]

theorem minimal_hit_distinct {a n k0 : Nat}
    (hhit : T^[k0] n = a)
    (hmin : ∀ j, j < k0 -> T^[j] n ≠ a) :
    ∀ i j, i <= k0 -> j <= k0 -> T^[i] n = T^[j] n -> i = j := by
  have no_repeat_lt :
      ∀ i j, i < j -> j <= k0 -> T^[i] n = T^[j] n -> False := by
    intro i j hij hjk heq
    let p := j - i
    let r := k0 - j
    have hpidx : i + p = j := by
      dsimp [p]
      omega
    have hbase : T^[i] n = T^[i + p] n := by
      rwa [hpidx]
    have hprop :
        T^[i + r] n = T^[i + r + p] n :=
      iterate_repeat_propagates (n := n) (j := i) (p := p) hbase r
    have hright : T^[i + r + p] n = a := by
      calc
        T^[i + r + p] n = T^[k0] n := by
          have hidx : i + r + p = k0 := by
            dsimp [r, p]
            omega
          rw [hidx]
        _ = a := hhit
    have hleft : T^[i + r] n = a := hprop.trans hright
    have hlt : i + r < k0 := by
      dsimp [r]
      omega
    exact hmin (i + r) hlt hleft
  intro i j hi hj heq
  by_contra hne
  rcases Nat.lt_or_gt_of_ne hne with hij | hji
  · exact no_repeat_lt i j hij hj heq
  · exact no_repeat_lt j i hji hi heq.symm

theorem pigeonhole_bound {x k0 n : Nat}
    (hwin : ∀ j, j <= k0 -> T^[j] n <= x)
    (hdistinct :
      ∀ i j, i <= k0 -> j <= k0 -> T^[i] n = T^[j] n -> i = j) :
    k0 <= x := by
  classical
  let s : Finset Nat := Finset.range (k0 + 1)
  let t : Finset Nat := Finset.range (x + 1)
  have hmap : ∀ i ∈ s, T^[i] n ∈ t := by
    intro i hi
    have hik : i <= k0 := by
      have hi' : i < k0 + 1 := Finset.mem_range.mp (by simpa [s] using hi)
      omega
    dsimp [t]
    exact Finset.mem_range.2 (Nat.lt_succ_iff.2 (hwin i hik))
  have hinj : Set.InjOn (fun i => T^[i] n) s := by
    intro i hi j hj hij
    have hik : i <= k0 := by
      have hi' : i < k0 + 1 := Finset.mem_range.mp (by simpa [s] using hi)
      omega
    have hjk : j <= k0 := by
      have hj' : j < k0 + 1 := Finset.mem_range.mp (by simpa [s] using hj)
      omega
    exact hdistinct i j hik hjk hij
  have hcard :
      s.card <= t.card :=
    Finset.card_le_card_of_injOn (s := s) (t := t)
      (f := fun i => T^[i] n) hmap hinj
  dsimp [s, t] at hcard
  simp [Finset.card_range] at hcard
  omega

theorem reachesWithin_has_bounded_min_hit {a x n : Nat}
    (h : ReachesWithin a x n) :
    ∃ k0,
      k0 <= x ∧
      T^[k0] n = a ∧
      ∀ j, j <= k0 -> T^[j] n <= x := by
  rcases h with ⟨k, hwin, hhit⟩
  let hp : ∃ m, T^[m] n = a := ⟨k, hhit⟩
  let k0 := Nat.find hp
  have hk0hit : T^[k0] n = a := by
    dsimp [k0]
    exact Nat.find_spec hp
  have hk0le : k0 <= k := by
    dsimp [k0]
    exact Nat.find_min' hp hhit
  have hwin0 : ∀ j, j <= k0 -> T^[j] n <= x := by
    intro j hj
    exact hwin j (le_trans hj hk0le)
  have hmin : ∀ j, j < k0 -> T^[j] n ≠ a := by
    intro j hj
    dsimp [k0] at hj
    exact Nat.find_min hp hj
  have hdistinct :
      ∀ i j, i <= k0 -> j <= k0 -> T^[i] n = T^[j] n -> i = j :=
    minimal_hit_distinct (a := a) (n := n) (k0 := k0) hk0hit hmin
  have hk0x : k0 <= x :=
    pigeonhole_bound (x := x) (k0 := k0) (n := n) hwin0 hdistinct
  exact ⟨k0, hk0x, hk0hit, hwin0⟩

theorem fuel_sufficient_of_reachesWithin {a x n : Nat}
    (_h : ReachesWithin a x n) :
    ReachesWithinFuelSufficient a x n := by
  intro h
  rcases reachesWithin_has_bounded_min_hit h with ⟨k0, hk0x, hhit, hwin⟩
  exact ⟨k0, by omega, hwin, hhit⟩

theorem boundedReaches_complete {a x n : Nat}
    (h : ReachesWithin a x n) :
    boundedReaches a x n = true := by
  exact boundedReaches_complete_of_fuel_sufficient
    (fuel_sufficient_of_reachesWithin h) h

theorem boundedReaches_iff {a x n : Nat} :
    boundedReaches a x n = true ↔ ReachesWithin a x n := by
  exact ⟨boundedReaches_sound, boundedReaches_complete⟩

theorem mem_piStarFinset_reachesWithin_iff {a x n : Nat} :
    n ∈ piStarFinset a x ↔
      n <= x ∧ 1 <= n ∧ ReachesWithin a x n := by
  rw [mem_piStarFinset_iff]
  constructor
  · intro h
    exact ⟨h.1, h.2.1, boundedReaches_sound h.2.2⟩
  · intro h
    exact ⟨h.1, h.2.1, boundedReaches_complete h.2.2⟩

theorem piStarPropFinset_eq_piStarFinset {a x : Nat} :
    piStarPropFinset a x = piStarFinset a x := by
  ext n
  rw [mem_piStarPropFinset_iff, mem_piStarFinset_reachesWithin_iff]

end KL2003
end CollatzClassical
