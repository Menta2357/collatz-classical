import WeaverWindows90Base
import TerrasQ1Floors
import Terras90Q1Numeric
import Terras90ClockSieve
import TerrasDisplacementFloors

namespace WeaverWindows90

open TerrasClock
open Terras88 (verifiedHeight q0Price q1Clock twiceQ1Clock HasWindow)
open Terras90Q0Price (floor146)

private theorem commonRank {N k : Nat} (first : FirstContraction N k)
    (runs : oddRuns N k=90)
    (clock : (k,oddCount N k)=q1Clock ∨ (k,oddCount N k)=twiceQ1Clock)
    (capacity : Terras90.SixRunCapacity 146) :
    (Terras88.valleyTimes N k).countP (fun i => decide (orbit N i<floor146))≤6 :=
  Nat.le_of_lt_succ (TerrasQ1Floors.seventhFloor first runs clock capacity)

/-- Q1 uses the archived Q0 Weaver query with the original positive
displacement, and with the same two clocks and chronological prefix. -/
theorem q1Window {N k : Nat} (base : verifiedHeight<N)
    (first : FirstContraction N k) (runs : oddRuns N k=90)
    (clock : (k,oddCount N k)=q1Clock) (shift : N+1≤orbit N k)
    (capacity : Terras90.SixRunCapacity 146) :
    HasWindow N k q0Price floor146 5 := by
  have total : k=q1Clock.1 := congrArg Prod.fst clock
  have count : oddCount N k=q1Clock.2 := congrArg Prod.snd clock
  have kLong : 1<k := total ▸ (by decide : 1<q1Clock.1)
  refine windowFromProduct base first kLong shift runs
    (commonRank first runs (.inl clock) capacity) ?_
  have eqFloors : priceFloors=Terras90Q1Numeric.priceEnvelope q0Price := rfl
  rw [count,total,eqFloors]
  exact Terras90Q1Numeric.q1ProductStrict

/-- The same archived query suffices at twice Q1 with the same cap. -/
theorem twiceQ1Window {N k : Nat} (base : verifiedHeight<N)
    (first : FirstContraction N k) (runs : oddRuns N k=90)
    (clock : (k,oddCount N k)=twiceQ1Clock) (shift : N+1≤orbit N k)
    (capacity : Terras90.SixRunCapacity 146) :
    HasWindow N k q0Price floor146 5 := by
  have total : k=twiceQ1Clock.1 := congrArg Prod.fst clock
  have count : oddCount N k=twiceQ1Clock.2 := congrArg Prod.snd clock
  have kLong : 1<k := total ▸ (by decide : 1<twiceQ1Clock.1)
  refine windowFromProduct base first kLong shift runs
    (commonRank first runs (.inr clock) capacity) ?_
  have eqFloors : priceFloors=Terras90Q1Numeric.priceEnvelope q0Price := rfl
  rw [count,total,eqFloors]
  exact Terras90Q1Numeric.twiceQ1ProductStrict

theorem q1FirstDescent {N k : Nat} (noWeaver : ¬HasWindow N k q0Price floor146 5)
    (base : verifiedHeight<N) (first : FirstContraction N k) (runs : oddRuns N k=90)
    (clock : (k,oddCount N k)=q1Clock) (notEqual : orbit N k≠N)
    (capacity : Terras90.SixRunCapacity 146) :
    orbit N k<N ∧ ∀ i<k, N≤orbit N i := by
  refine ⟨?_,fun _ prior => prior_no_descent first prior⟩
  by_cases descends : orbit N k<N
  · exact descends
  exact (noWeaver (q1Window base first runs clock (by omega) capacity)).elim

theorem twiceQ1FirstDescent {N k : Nat} (noWeaver : ¬HasWindow N k q0Price floor146 5)
    (base : verifiedHeight<N) (first : FirstContraction N k) (runs : oddRuns N k=90)
    (clock : (k,oddCount N k)=twiceQ1Clock) (notEqual : orbit N k≠N)
    (capacity : Terras90.SixRunCapacity 146) :
    orbit N k<N ∧ ∀ i<k, N≤orbit N i := by
  refine ⟨?_,fun _ prior => prior_no_descent first prior⟩
  by_cases descends : orbit N k<N
  · exact descends
  exact (noWeaver (twiceQ1Window base first runs clock (by omega) capacity)).elim

def residualClocks : List (Nat × Nat) :=
  Terras90Lattice.survivors.filter
    (fun p => decide (p≠Terras88.q0Clock ∧ p≠q1Clock ∧ p≠twiceQ1Clock))

theorem residualCount : residualClocks.length=8 := by decide

/-- Compose the integer clock sieve with the three already consumed Weaver
rows. Each bound that still needs a physical derivation is an explicit input. -/
theorem residualOfScaledBounds {N k : Nat} (noWeaver : ¬HasWindow N k q0Price floor146 5)
    (base : verifiedHeight<N) (first : FirstContraction N k) (runs : oddRuns N k=90)
    (nondecreasing : N≤orbit N k) (notEqual : orbit N k≠N)
    (six92 : Terras90.SixRunCapacity 92) (six146 : Terras90.SixRunCapacity 146)
    (oddBound : oddCount N k<Terras90Lattice.maxOdds)
    (global : Terras90Lattice.lowGap k (oddCount N k)<Terras90Lattice.globalGap)
    (positive : 0<Terras90Lattice.highGap k (oddCount N k))
    (ordinary : Terras90Lattice.lowGap k (oddCount N k)<
      100000*(Terras90Lattice.ordinaryBudget (oddCount N k):Int)) :
    (k,oddCount N k)∈residualClocks := by
  have mem := Terras90Lattice.clocksOfScaledEnvelope oddBound global positive ordinary
  simp only [residualClocks,List.mem_filter,decide_eq_true_eq]
  refine ⟨mem,?_,?_,?_⟩
  · intro q0
    have pays := TerrasDisplacement.q0FirstDescentOfSix base first runs q0 notEqual six92 six146
      noWeaver
    exact (Nat.not_lt_of_ge nondecreasing) pays.1
  · intro q1
    exact (Nat.not_lt_of_ge nondecreasing) (q1FirstDescent noWeaver base first runs q1 notEqual six146).1
  · intro twice
    exact (Nat.not_lt_of_ge nondecreasing) (twiceQ1FirstDescent noWeaver base first runs twice notEqual six146).1

end WeaverWindows90
