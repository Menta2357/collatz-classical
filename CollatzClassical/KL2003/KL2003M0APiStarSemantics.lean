import Mathlib.Data.Finset.Card
import Mathlib.Data.List.Basic
import Mathlib.Tactic.NormNum

namespace CollatzClassical
namespace KL2003

def T (n : Nat) : Nat :=
  if n % 2 = 0 then
    n / 2
  else
    (3 * n + 1) / 2

def orbitWithFuel : Nat -> Nat -> List Nat
| 0, n => [n]
| fuel + 1, n => n :: orbitWithFuel fuel (T n)

def boundedReachesWithFuel : Nat -> Nat -> Nat -> Nat -> Bool
| 0, a, x, n =>
    decide (n <= x) && decide (n = a)
| fuel + 1, a, x, n =>
    decide (n <= x) &&
      (decide (n = a) || boundedReachesWithFuel fuel a x (T n))

def boundedReaches (a x n : Nat) : Bool :=
  boundedReachesWithFuel (x + 1) a x n

def piStarMember (a x n : Nat) : Bool :=
  decide (1 <= n) && boundedReaches a x n

def piStarFinset (a x : Nat) : Finset Nat :=
  (Finset.range (x + 1)).filter
    (fun n => 1 <= n ∧ boundedReaches a x n = true)

def piStarList (a x : Nat) : List Nat :=
  (List.range (x + 1)).filter (fun n => piStarMember a x n)

def piStar (a x : Nat) : Nat :=
  (piStarFinset a x).card

@[simp] theorem T_zero : T 0 = 0 := by
  norm_num [T]

@[simp] theorem orbitWithFuel_zero (n : Nat) :
    orbitWithFuel 0 n = [n] := by
  rfl

theorem mem_piStarFinset_iff {a x n : Nat} :
    n ∈ piStarFinset a x ↔
      n <= x ∧ 1 <= n ∧ boundedReaches a x n = true := by
  simp [piStarFinset, Nat.lt_succ_iff]

theorem mem_piStarList_iff {a x n : Nat} :
    n ∈ piStarList a x ↔
      n <= x ∧ 1 <= n ∧ boundedReaches a x n = true := by
  simp [piStarList, piStarMember, Nat.lt_succ_iff]

theorem zero_not_mem_piStarFinset (a x : Nat) :
    0 ∉ piStarFinset a x := by
  intro h
  have hz := (mem_piStarFinset_iff (a := a) (x := x) (n := 0)).1 h
  exact Nat.not_succ_le_zero 0 hz.2.1

theorem piStar_zero_x (a : Nat) :
    piStar a 0 = 0 := by
  unfold piStar piStarFinset
  rw [Finset.card_eq_zero, Finset.filter_eq_empty_iff]
  intro n hn hp
  have hn0 : n = 0 := by
    simpa using hn
  rw [hn0] at hp
  exact Nat.not_succ_le_zero 0 hp.1

end KL2003
end CollatzClassical
