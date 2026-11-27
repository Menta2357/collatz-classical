import TerrasClock
import TerrasValleyExtraction

namespace Terras88

open TerrasClock
open TerrasValleyExtraction (StartsLow)

def verifiedHeight : Nat := 28000000000000000000

def q0Clock : Nat × Nat := (630118245525664765,397560349370386783)
def q1Clock : Nat × Nat := (7354673373747273033,4640282259296926456)
def twiceQ1Clock : Nat × Nat := (14709346747494546066,9280564518593852912)
def lastClock : Nat × Nat := (43497921996957973433,27444133206411171953)

def q0Price : Nat := 453027402666008300866
def q1Price : Nat := 99048017070889459170

/-- Indices of real beginnings of odd runs, in increasing time order. -/
def valleyTimes (N k : Nat) : List Nat := (List.range k).filter (startsOddRun N)

theorem valleyTimes_length (N k : Nat) : (valleyTimes N k).length=oddRuns N k := by
  induction k with
  | zero => rfl
  | succ k ih =>
    simp only [valleyTimes,List.range_succ,List.filter_append,List.length_append]
    change ((List.range k).filter (startsOddRun N)).length +
      ([k].filter (startsOddRun N)).length = oddRuns N (k+1)
    rw [show ((List.range k).filter (startsOddRun N)).length=oddRuns N k from ih]
    by_cases h : startsOddRun N k=true
    · simp [oddRuns,h]
    · simp [oddRuns,h]

theorem valleyTimes_mem {N k i : Nat} (h : i ∈ valleyTimes N k) :
    i<k ∧ startsOddRun N i=true := by
  have both := List.mem_filter.mp h
  exact ⟨List.mem_range.mp both.1,both.2⟩

/-- Ranked price input. A chosen set of lowest chronological positions
is used, so ties need not be collapsed or selected by price alone. -/
structure RankCut (N k price height span : Nat) where
  low : Nat → Bool
  priced : ∀ i, low i=true → orbit N i<price
  ranked : ∀ i ∈ valleyTimes N k, ∀ j ∈ valleyTimes N k,
    low i=true → low j=false → orbit N i≤orbit N j
  starts : StartsLow low (valleyTimes N k)
  crowded : (valleyTimes N k).countP low * span < oddRuns N k
  upper : (valleyTimes N k).countP (fun i => decide (orbit N i<height)) <
    (valleyTimes N k).countP low + span

/-- A contiguous list of physical valley times. Its source satisfies the
strict Weaver price and the high endpoint occurs within span complete
blocks. The run at the end of the global prefix need not be completed. -/
def HasWindow (N k price height span : Nat) : Prop :=
  ∃ pre z run post i, valleyTimes N k=pre++(z::(run++post)) ∧
    verifiedHeight < orbit N z ∧ orbit N z < price ∧
    run.length=span ∧ (∀ j ∈ run, orbit N z≤orbit N j) ∧
    i ∈ run ∧ height≤orbit N i

theorem physical_window {N k price height span : Nat}
    (base : verifiedHeight<N) (first : FirstContraction N k) (ph : price≤height)
    (cut : RankCut N k price height span) : HasWindow N k price height span := by
  obtain ⟨pre,z,run,post,i,split,hprice,len,above,inside,tall⟩ :=
    TerrasValleyExtraction.extract cut.low ph cut.priced cut.ranked cut.starts
      (by rw [valleyTimes_length]; exact cut.crowded) cut.upper
  have zm : z ∈ valleyTimes N k := by rw [split]; simp
  have before := (valleyTimes_mem zm).1
  have source := Nat.lt_of_lt_of_le base (prior_no_descent first before)
  exact ⟨pre,z,run,post,i,split,source,hprice,len,above,inside,tall⟩

/-- Exact price identity under a nondecreasing crossing. The additive
term pays both the multiplicative deficit and the endpoint displacement. -/
theorem additive_at_crossing {N k : Nat} (first : FirstContraction N k)
    (grows : N≤orbit N k) :
    additive N k =
      (2^k - 3^(oddCount N k))*N+2^k*(orbit N k-N) := by
  have coeff : 3^(oddCount N k)≤2^k := Nat.le_of_lt first.1
  have e1 := congrArg (fun u : Nat => u*N) (Nat.sub_add_cancel coeff)
  have e2 := congrArg (fun u : Nat => 2^k*u) (Nat.sub_add_cancel grows)
  simp only [Nat.add_mul] at e1
  simp only [Nat.mul_add] at e2
  have ledger := exact_book N k
  omega

structure Candidate (N k : Nat) : Prop where
  base : verifiedHeight<N
  first : FirstContraction N k
  runs : oddRuns N k=88
  grows : N<orbit N k

/-- Proof inputs from the paper and the fixed computational evidence.
Every input remains a quantified proposition over physical histories. -/
structure Inputs : Prop where
  belowHeight : ∀ N k, 2≤N → N≤verifiedHeight → FirstContraction N k → orbit N k<N
  atMost87 : ∀ N k, 2≤N → FirstContraction N k → oddRuns N k≤87 → orbit N k<N
  noEqual : ∀ N k, verifiedHeight<N → FirstContraction N k →
    oddRuns N k=88 → orbit N k≠N
  fourClocks : ∀ N k, Candidate N k →
    (k,oddCount N k)=q0Clock ∨ (k,oddCount N k)=q1Clock ∨
    (k,oddCount N k)=twiceQ1Clock ∨ (k,oddCount N k)=lastClock
  q0Ranks : ∀ N k, Candidate N k → (k,oddCount N k)=q0Clock →
    Nonempty (RankCut N k q0Price (2^146-1) 5)
  q1Ranks : ∀ N k, Candidate N k → (k,oddCount N k)=q1Clock →
    Nonempty (RankCut N k q1Price (2^170-1) 4)
  twiceQ1Excluded : ∀ N k, Candidate N k → (k,oddCount N k)=twiceQ1Clock → False
  lastClockExcluded : ∀ N k, Candidate N k → (k,oddCount N k)=lastClock → False
  noWeaverQ0 : ∀ N k, ¬HasWindow N k q0Price (2^146-1) 5
  noWeaverQ1 : ∀ N k, ¬HasWindow N k q1Price (2^170-1) 4

/-- Assembly of the Terras 88 argument. The same physical clock and seed
are used for the four clock cases and for both extracted windows. -/
theorem descent88 (c : Inputs) {N k : Nat} (big : 2≤N)
    (first : FirstContraction N k) (runs : oddRuns N k≤88) : orbit N k<N := by
  by_cases h : orbit N k<N
  · exact h
  by_cases low : N≤verifiedHeight
  · exact (h (c.belowHeight N k big low first)).elim
  by_cases fewer : oddRuns N k≤87
  · exact (h (c.atMost87 N k big first fewer)).elim
  have large : verifiedHeight<N := by omega
  have exact88 : oddRuns N k=88 := by omega
  have notEqual := c.noEqual N k large first exact88
  have above : N<orbit N k := by omega
  have path : Candidate N k := ⟨large,first,exact88,above⟩
  rcases c.fourClocks N k path with q0 | q1 | twice | last
  · obtain ⟨cut⟩ := c.q0Ranks N k path q0
    exact (c.noWeaverQ0 N k (physical_window large first (by decide) cut)).elim
  · obtain ⟨cut⟩ := c.q1Ranks N k path q1
    exact (c.noWeaverQ1 N k (physical_window large first (by decide) cut)).elim
  · exact (c.twiceQ1Excluded N k path twice).elim
  · exact (c.lastClockExcluded N k path last).elim

theorem first_descent88 (c : Inputs) {N k : Nat} (big : 2≤N)
    (first : FirstContraction N k) (runs : oddRuns N k≤88) :
    orbit N k<N ∧ ∀ j, j<k → N≤orbit N j :=
  ⟨descent88 c big first runs,fun _ earlier => prior_no_descent first earlier⟩

end Terras88
