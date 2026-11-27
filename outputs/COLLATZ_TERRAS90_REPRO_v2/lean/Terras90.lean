import Terras89

set_option exponentiation.threshold 512

namespace Terras90

open TerrasClock
open Terras88 (RankCut physical_window q0Clock q0Price verifiedHeight)

def RunBound (runs height bound : Nat) : Prop :=
  ∀ N k, 0 < N → N % 2 = 1 → N < 2^height →
    oddRuns N k = runs → oddCount N k ≤ bound

def SixRunCapacity (height : Nat) : Prop :=
  ∀ N k, 0 < N → N % 2 = 1 → N + 1 < 2^height →
    oddRuns N k = 6 → 2^(oddCount N k) ≤ 6^height

/-- The bound on the first valley uses the complete even gap. -/
theorem firstValley_lt_229 {a b u y : Nat} (short : a ≤ 123) (gap : 1 ≤ b)
    (source : 2^a * u < 2^146) (book : 2^b * y + 1 = 3^a * u) :
    y < 2^229 := by
  have split : a + (123-a) = 123 := by omega
  have powerBound : 3^a * 2^(123-a) ≤ 3^123 := by
    calc
      _ ≤ 3^a * 3^(123-a) :=
        Nat.mul_le_mul_left _ (Nat.pow_le_pow_left (by decide) _)
      _ = _ := by rw [← Nat.pow_add, split]
  have nextNumerator : 3^a * u < 2^230 := by
    have factor : (2:Nat)^123 = 2^a * 2^(123-a) := by rw [← Nat.pow_add, split]
    apply Nat.lt_of_mul_lt_mul_left (a := 2^123)
    calc
      2^123 * (3^a * u) = (3^a * 2^(123-a)) * (2^a * u) := by
        rw [factor]
        ac_rfl
      _ < (3^a * 2^(123-a)) * 2^146 :=
        Nat.mul_lt_mul_of_pos_left source
          (Nat.mul_pos (Nat.pow_pos (show (0 : Nat) < 3 by decide))
            (Nat.pow_pos (show (0 : Nat) < 2 by decide)))
      _ ≤ 3^123 * 2^146 := Nat.mul_le_mul_right _ powerBound
      _ < 2^123 * 2^230 := by decide
  have denominator : 2 ≤ (2:Nat)^b := by
    change (2:Nat)^1 ≤ (2:Nat)^b
    exact Nat.pow_le_pow_right (by decide : (0:Nat) < 2) gap
  have peak : 2^b*y < 2^230 := by
    calc
      2^b*y < 2^b*y+1 := Nat.lt_succ_self _
      _ = 3^a*u := book
      _ < 2^230 := nextNumerator
  have scaled : 2*y < 2^230 :=
    Nat.lt_of_le_of_lt (Nat.mul_le_mul_right y denominator) peak
  rw [show (2:Nat)^230 = 2*2^229 by decide] at scaled
  exact Nat.lt_of_mul_lt_mul_left scaled

/-- Transfer the universal five-run table to the same physical history. -/
theorem shortFirstRunCapacity (external : Terras89.FiveRunBound 229 254)
    {N p k a b u : Nat} (short : a ≤ 123) (gap : 1 ≤ b)
    (source : 2^a*u < 2^146)
    (book : 2^b*orbit N p+1 = 3^a*u)
    (odd : orbit N p % 2 = 1) (count : oddCount N p = a)
    (tail : oddRuns (orbit N p) k = 5) :
    2^(oddCount N (p+k)) ≤ 6^146 := by
  have height := firstValley_lt_229 short gap source book
  have tailBound := external (orbit N p) k (by omega) odd height tail
  have total : oddCount N (p+k) ≤ 377 := by rw [oddCount_add, count]; omega
  exact Nat.le_trans (Nat.pow_le_pow_right (by decide) total) (by decide)

/-- A physically extended prefix keeps every odd entry in the shorter one. -/
theorem capacity92OfExtension (external : RunBound 7 100 156)
    {N k additional : Nat} (pos : 0 < N) (odd : N % 2 = 1)
    (source : N + 1 < 2^92) (extend : oddRuns N (k+additional) = 7) :
    2^(oddCount N k) ≤ 6^92 := by
  have outer : N < 2^100 := by omega
  have bound := external N (k+additional) pos odd outer extend
  rw [oddCount_add] at bound
  exact Nat.le_trans (Nat.pow_le_pow_right (by decide) (show oddCount N k ≤ 156 by omega))
    (by decide)

/-- Combine the two certified score bounds with the exact integer thresholds. -/
theorem capacitiesOfBounds (at92 : RunBound 6 92 156) (at146 : RunBound 6 146 377) :
    SixRunCapacity 92 ∧ SixRunCapacity 146 := by
  constructor
  · intro N k pos odd small runs
    have bound := at92 N k pos odd (by omega) runs
    exact Nat.le_trans (Nat.pow_le_pow_right (by decide) bound) (by decide)
  · intro N k pos odd small runs
    have bound := at146 N k pos odd (by omega) runs
    exact Nat.le_trans (Nat.pow_le_pow_right (by decide) bound) (by decide)

structure DeltaOneQ0 (N k : Nat) : Prop where
  base : verifiedHeight < N
  first : FirstContraction N k
  runs : oddRuns N k = 90
  clock : (k, oddCount N k) = q0Clock
  delta : orbit N k = N + 1

/-- Inputs from the arithmetic sieve and the ranked price conversion. -/
structure Inputs90 : Prop where
  reducedToQ0 : ∀ N k, 2 ≤ N → FirstContraction N k → oddRuns N k = 90 →
    N ≤ orbit N k → DeltaOneQ0 N k
  q0Ranks : SixRunCapacity 92 → SixRunCapacity 146 → ∀ N k, DeltaOneQ0 N k →
    Nonempty (RankCut N k q0Price (2^146-1) 5)

theorem firstDescent (prev88 : Terras88.Inputs) (prev89 : Terras89.Inputs89)
    (five92 : Terras89.FiveRunCapacity 92) (five146 : Terras89.FiveRunCapacity 146)
    (current : Inputs90) (six92 : SixRunCapacity 92) (six146 : SixRunCapacity 146)
    {N k : Nat} (large : 2 ≤ N) (first : FirstContraction N k) (runs : oddRuns N k ≤ 90) :
    orbit N k < N ∧ ∀ j, j < k → N ≤ orbit N j := by
  refine ⟨?_, fun _ earlier => prior_no_descent first earlier⟩
  by_cases fewer : oddRuns N k ≤ 89
  · exact (Terras89.first_descent89_from_capacities prev88 prev89 five92 five146
      large first fewer).1
  · by_cases descends : orbit N k < N
    · exact descends
    · have residual := current.reducedToQ0 N k large first (by omega) (by omega)
      obtain ⟨cut⟩ := current.q0Ranks six92 six146 N k residual
      exact (prev88.noWeaverQ0 N k
        (physical_window residual.base first (by decide) cut)).elim

end Terras90
