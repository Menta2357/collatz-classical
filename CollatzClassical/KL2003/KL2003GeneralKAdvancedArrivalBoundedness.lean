import CollatzClassical.KL2003.KL2003GeneralKCriticalAdvancedDominance

namespace CollatzClassical
namespace KL2003
namespace GeneralKAdvancedArrivalBoundedness

/-!
Uniform bounded recurrence and termination of the critical general-k
scheduler.

The source proof of Theorem 3.1 asserts that recurrent fully grown subtrees
have a fixed negative shift increment.  That exact self-similarity is not
available for the repository's critical scheduler: expansion eligibility is
absolute and deletion depends on the outer history.  This module proves the
needed conclusion by a scheduler-independent finite argument instead.

Nonnegative shifts and retained advanced-arrival dominance first bound every
advanced arrival by the first arrival to its finite target mode.  Hence
advanced actions occur with a uniform bounded gap.  Pigeonhole applied to
blocks of `card(modes) + 1` advanced arrivals yields bounded same-target
return segments.  There are only finitely many typed source walks of that
bounded length, so their strictly negative weights admit one uniform epsilon.
Disjoint blocks and finite-mode recurrence then accumulate that epsilon and
contradict global nonnegativity.

The final theorems specialize this contradiction to the extracted critical
branch, prove that the critical scheduler cannot run forever, and return a
finite state whose critical terminal shifts are all negative.  The semantic
stop-to-`SatisfiesEL` bridge remains outside this module.
-/

open GeneralKSourceGraph
open GeneralKInfiniteBranchDescent
open GeneralKAdvancedRecurrence
open GeneralKCriticalScheduler
open GeneralKCriticalTerminalFinder
open GeneralKCriticalInfiniteBranchExtraction
open GeneralKCriticalAdvancedDominance
open GeneralKSourceGenealogy
open GeneralKSourceGenealogy.ProvenancedTree
open GeneralKNestedReturnDescent
open GeneralKTermination

def IsAdvancedArrivalTo {p : Nat} {hp : 1 <= p}
    (branch : InfiniteSourceWalk hp) (mode : TrackedMode (p + 1))
    (arrival : Nat) : Prop :=
  IsAdvancedAction (branch.actions arrival) /\
    branch.modes (arrival + 1) = mode

noncomputable def firstAdvancedArrival?
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (mode : TrackedMode (p + 1)) : Option Nat := by
  classical
  exact if h : exists arrival, IsAdvancedArrivalTo branch mode arrival then
    some (Nat.find h)
  else
    none

theorem firstAdvancedArrival?_eq_some_iff
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (mode : TrackedMode (p + 1)) (arrival : Nat) :
    firstAdvancedArrival? branch mode = some arrival <->
      IsAdvancedArrivalTo branch mode arrival /\
        forall earlier, IsAdvancedArrivalTo branch mode earlier ->
          arrival <= earlier := by
  classical
  constructor
  · intro hsome
    unfold firstAdvancedArrival? at hsome
    split at hsome
    next h =>
      simp only [Option.some.injEq] at hsome
      subst arrival
      exact ⟨Nat.find_spec h, fun earlier hearlier => Nat.find_min' h hearlier⟩
    next h => simp at hsome
  · rintro ⟨harrival, hminimal⟩
    unfold firstAdvancedArrival?
    split
    next h =>
      have hle := Nat.find_min' h harrival
      have hge := hminimal (Nat.find h) (Nat.find_spec h)
      simp [Nat.le_antisymm hle hge]
    next h => exact False.elim (h ⟨arrival, harrival⟩)

noncomputable def advancedArrivalModeBound
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (mode : TrackedMode (p + 1)) : Real :=
  match firstAdvancedArrival? branch mode with
  | none => initial
  | some arrival => branch.beta initial (arrival + 1)

theorem advancedArrival_le_modeBound
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real)
    (hretained : AdvancedArrivalsNonincreasing branch initial)
    {mode : TrackedMode (p + 1)} {arrival : Nat}
    (harrival : IsAdvancedArrivalTo branch mode arrival) :
    branch.beta initial (arrival + 1) <=
      advancedArrivalModeBound branch initial mode := by
  classical
  obtain ⟨first, hfirst⟩ : exists first,
      firstAdvancedArrival? branch mode = some first := by
    unfold firstAdvancedArrival?
    split
    next h => exact ⟨Nat.find h, rfl⟩
    next h => exact False.elim (h ⟨arrival, harrival⟩)
  rw [advancedArrivalModeBound, hfirst]
  have hfirstFacts :=
    (firstAdvancedArrival?_eq_some_iff branch mode first).mp hfirst
  rcases eq_or_lt_of_le (hfirstFacts.2 arrival harrival) with heq | hlt
  · subst arrival
    exact le_rfl
  · exact hretained arrival harrival.1 (first + 1) (by omega)
      (by rw [hfirstFacts.1.2, harrival.2])

noncomputable def advancedArrivalGlobalBound
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) : Real :=
  |initial| + Finset.univ.sum fun mode : TrackedMode (p + 1) =>
    |advancedArrivalModeBound branch initial mode|

theorem modeBound_le_globalBound
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (mode : TrackedMode (p + 1)) :
    advancedArrivalModeBound branch initial mode <=
      advancedArrivalGlobalBound branch initial := by
  have habs : advancedArrivalModeBound branch initial mode <=
      |advancedArrivalModeBound branch initial mode| := le_abs_self _
  have hsum : |advancedArrivalModeBound branch initial mode| <=
      Finset.univ.sum fun current : TrackedMode (p + 1) =>
        |advancedArrivalModeBound branch initial current| := by
    exact Finset.single_le_sum (s := Finset.univ)
      (f := fun current : TrackedMode (p + 1) =>
        |advancedArrivalModeBound branch initial current|)
      (fun current _ => abs_nonneg _) (by simp)
  exact habs.trans (hsum.trans (by
    dsimp only [advancedArrivalGlobalBound]
    linarith [abs_nonneg initial]))

theorem beta_succ
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (n : Nat) :
    branch.beta initial (n + 1) =
      branch.beta initial n + (branch.actions n).weight.eval := by
  have hadd := branch.beta_add initial n 1
  simpa [InfiniteSourceWalk.segment, SourceWalk.weight,
    GeneralKSourceGraph.shift_add_zero] using hadd

theorem beta_le_advancedArrivalGlobalBound
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real)
    (hretained : AdvancedArrivalsNonincreasing branch initial) :
    forall n, branch.beta initial n <=
      advancedArrivalGlobalBound branch initial := by
  intro n
  induction n with
  | zero =>
      rw [InfiniteSourceWalk.beta]
      simp only [InfiniteSourceWalk.segmentWeightEval, add_zero]
      dsimp only [advancedArrivalGlobalBound]
      have hsum : 0 <= Finset.univ.sum fun mode : TrackedMode (p + 1) =>
          |advancedArrivalModeBound branch initial mode| :=
        Finset.sum_nonneg fun _ _ => abs_nonneg _
      exact (le_abs_self initial).trans (by linarith)
  | succ n ih =>
      by_cases hadvanced : IsAdvancedAction (branch.actions n)
      · let mode := branch.modes (n + 1)
        exact (advancedArrival_le_modeBound branch initial hretained
          (mode := mode) (arrival := n) ⟨hadvanced, rfl⟩).trans
            (modeBound_le_globalBound branch initial mode)
      · rw [beta_succ]
        rw [weight_eval_eq_neg_two_of_not_isAdvanced _ hadvanced]
        linarith

theorem exists_uniform_advanced_gap
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial)
    (hretained : AdvancedArrivalsNonincreasing branch initial) :
    exists gap : Nat, 0 < gap /\ forall start : Nat,
      exists offset : Nat, offset < gap /\
        IsAdvancedAction (branch.actions (start + offset)) := by
  let upper := advancedArrivalGlobalBound branch initial
  have hupper : forall n, branch.beta initial n <= upper :=
    beta_le_advancedArrivalGlobalBound branch initial hretained
  obtain ⟨gap, hgap⟩ := exists_nat_gt (upper / 2)
  have hgapPos : 0 < gap := by
    by_contra hnot
    have hzero : gap = 0 := by omega
    subst gap
    have hupperNonnegative : 0 <= upper :=
      (hnonnegative 0).trans (hupper 0)
    norm_num at hgap
    linarith
  refine ⟨gap, hgapPos, ?_⟩
  intro start
  by_contra hnone
  have hretarded : forall offset : Nat, offset < gap ->
      Not (IsAdvancedAction (branch.actions (start + offset))) := by
    intro offset hoffset hadvanced
    exact hnone ⟨offset, hoffset, hadvanced⟩
  have hsegment : branch.segmentWeightEval start gap = -2 * (gap : Real) :=
    segmentWeightEval_eq_neg_two_mul_of_no_advanced branch start gap hretarded
  have hend := branch.beta_add initial start gap
  rw [branch.segment_weight_eval, hsegment] at hend
  have hmul : upper < 2 * (gap : Real) := by
    have htwo : (0 : Real) < 2 := by norm_num
    simpa [mul_comm] using (div_lt_iff₀ htwo).mp hgap
  have hnegative : branch.beta initial (start + gap) < 0 := by
    rw [hend]
    linarith [hupper start]
  exact (not_lt_of_ge (hnonnegative (start + gap))) hnegative

theorem extractedCriticalBranch_exists_uniform_advanced_gap
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {y : Real} (hy : 2 <= y)
    (hbounds : (ProvenancedTree.initial hp root).forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : (ProvenancedTree.initial hp root).forget.normalExpr
      |>.ArgumentsNonnegative y)
    (hne : NeverStops (ProvenancedTree.initial hp root) y) :
    exists gap : Nat, 0 < gap /\ forall start : Nat,
      exists offset : Nat, offset < gap /\
        IsAdvancedAction
          ((extractedInfiniteSourceWalk hne).actions (start + offset)) := by
  exact exists_uniform_advanced_gap
    (extractedInfiniteSourceWalk hne) root.shift.eval
    (extractedInfiniteSourceWalk_shiftsNonnegative hne)
    (extractedCriticalBranch_advancedArrivalsNonincreasing
      roots hy hbounds hargs hne)

noncomputable def advancedPosition
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (index : Nat) : Nat :=
  Nat.nth (fun n => IsAdvancedAction (branch.actions n)) index

theorem advancedPosition_strictMono
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial) :
    StrictMono (advancedPosition branch) := by
  exact Nat.nth_strictMono
    (advancedIndices_infinite branch initial hnonnegative)

theorem advancedPosition_isAdvanced
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial)
    (index : Nat) :
    IsAdvancedAction (branch.actions (advancedPosition branch index)) := by
  exact Nat.nth_mem_of_infinite
    (advancedIndices_infinite branch initial hnonnegative) index

theorem advancedPosition_succ_le_of_uniform_gap
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial)
    {gap : Nat}
    (hgap : forall start : Nat, exists offset : Nat, offset < gap /\
      IsAdvancedAction (branch.actions (start + offset)))
    (index : Nat) :
    advancedPosition branch (index + 1) <=
      advancedPosition branch index + gap := by
  let predicate : Nat -> Prop :=
    fun n => IsAdvancedAction (branch.actions n)
  let current := advancedPosition branch index
  obtain ⟨offset, hoffset, hadvanced⟩ := hgap (current + 1)
  let candidate := current + 1 + offset
  have hcandidate : predicate candidate := by
    simpa only [predicate, candidate, current] using hadvanced
  obtain ⟨candidateIndex, hcandidateIndex⟩ :=
    Nat.subset_range_nth
      (show candidate ∈ {n : Nat | predicate n} from hcandidate)
  have hinfinite : {n : Nat | predicate n}.Infinite := by
    simpa only [predicate] using
      advancedIndices_infinite branch initial hnonnegative
  have hcurrentLt : advancedPosition branch index < candidate := by
    dsimp only [candidate, current]
    omega
  have hindexLt : index < candidateIndex := by
    rw [← (Nat.nth_lt_nth hinfinite)]
    simpa only [advancedPosition, predicate, hcandidateIndex] using hcurrentLt
  have hnextLe : advancedPosition branch (index + 1) <= candidate := by
    have := (Nat.nth_monotone hinfinite) (show index + 1 <= candidateIndex by omega)
    simpa only [advancedPosition, predicate, hcandidateIndex] using this
  dsimp only [candidate, current] at hnextLe
  omega

theorem advancedPosition_add_le_of_uniform_gap
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial)
    {gap : Nat}
    (hgap : forall start : Nat, exists offset : Nat, offset < gap /\
      IsAdvancedAction (branch.actions (start + offset)))
    (base count : Nat) :
    advancedPosition branch (base + count) <=
      advancedPosition branch base + count * gap := by
  induction count with
  | zero => simp
  | succ count ih =>
      have hstep := advancedPosition_succ_le_of_uniform_gap
        branch initial hnonnegative hgap (base + count)
      have hindex : base + count + 1 = base + (count + 1) := by omega
      rw [hindex] at hstep
      calc
        advancedPosition branch (base + (count + 1))
            <= advancedPosition branch (base + count) + gap := hstep
        _ <= advancedPosition branch base + count * gap + gap :=
          Nat.add_le_add_right ih gap
        _ = advancedPosition branch base + (count + 1) * gap := by ring

structure BoundedAdvancedPair
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (base gap : Nat) where
  first : Nat
  second : Nat
  first_lt_second : first < second
  first_advanced : IsAdvancedAction (branch.actions first)
  second_advanced : IsAdvancedAction (branch.actions second)
  same_target : branch.modes (first + 1) = branch.modes (second + 1)
  lower_bound : advancedPosition branch base <= first
  upper_position : second <= advancedPosition branch
    (base + Fintype.card (TrackedMode (p + 1)))
  upper_bound : second <=
    advancedPosition branch base +
      Fintype.card (TrackedMode (p + 1)) * gap

theorem exists_boundedAdvancedPair
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial)
    {gap : Nat}
    (hgap : forall start : Nat, exists offset : Nat, offset < gap /\
      IsAdvancedAction (branch.actions (start + offset)))
    (base : Nat) :
    Nonempty (BoundedAdvancedPair branch base gap) := by
  let modeCount := Fintype.card (TrackedMode (p + 1))
  let target : Fin (modeCount + 1) -> TrackedMode (p + 1) :=
    fun index => branch.modes
      (advancedPosition branch (base + index.1) + 1)
  have hcard : Fintype.card (TrackedMode (p + 1)) <
      Fintype.card (Fin (modeCount + 1)) := by
    simp only [Fintype.card_fin, modeCount]
    omega
  obtain ⟨left, right, hne, htarget⟩ :=
    Fintype.exists_ne_map_eq_of_card_lt target hcard
  have horient : left.1 < right.1 \/ right.1 < left.1 := by
    exact lt_or_gt_of_ne (fun heq => hne (Fin.ext heq))
  rcases horient with hlt | hlt
  · let first := advancedPosition branch (base + left.1)
    let second := advancedPosition branch (base + right.1)
    refine ⟨⟨first, second, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩⟩
    · exact (advancedPosition_strictMono branch initial hnonnegative)
        (by omega)
    · exact advancedPosition_isAdvanced branch initial hnonnegative _
    · exact advancedPosition_isAdvanced branch initial hnonnegative _
    · simpa only [target, first, second] using htarget
    · dsimp only [first]
      exact (advancedPosition_strictMono branch initial hnonnegative).monotone
        (by omega)
    · dsimp only [second, modeCount]
      exact (advancedPosition_strictMono branch initial hnonnegative).monotone
        (by omega)
    · dsimp only [second, modeCount]
      calc
        advancedPosition branch (base + right.1)
            <= advancedPosition branch base + right.1 * gap :=
          advancedPosition_add_le_of_uniform_gap
            branch initial hnonnegative hgap base right.1
        _ <= advancedPosition branch base +
              Fintype.card (TrackedMode (p + 1)) * gap := by
          apply Nat.add_le_add_left
          exact Nat.mul_le_mul_right gap (Nat.le_of_lt_succ right.2)
  · let first := advancedPosition branch (base + right.1)
    let second := advancedPosition branch (base + left.1)
    refine ⟨⟨first, second, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩⟩
    · exact (advancedPosition_strictMono branch initial hnonnegative)
        (by omega)
    · exact advancedPosition_isAdvanced branch initial hnonnegative _
    · exact advancedPosition_isAdvanced branch initial hnonnegative _
    · simpa only [target, first, second] using htarget.symm
    · dsimp only [first]
      exact (advancedPosition_strictMono branch initial hnonnegative).monotone
        (by omega)
    · dsimp only [second, modeCount]
      exact (advancedPosition_strictMono branch initial hnonnegative).monotone
        (by omega)
    · dsimp only [second, modeCount]
      calc
        advancedPosition branch (base + left.1)
            <= advancedPosition branch base + left.1 * gap :=
          advancedPosition_add_le_of_uniform_gap
            branch initial hnonnegative hgap base left.1
        _ <= advancedPosition branch base +
              Fintype.card (TrackedMode (p + 1)) * gap := by
          apply Nat.add_le_add_left
          exact Nat.mul_le_mul_right gap (Nat.le_of_lt_succ left.2)

theorem BoundedAdvancedPair.span_le
    {p : Nat} {hp : 1 <= p} {branch : InfiniteSourceWalk hp}
    {base gap : Nat} (pair : BoundedAdvancedPair branch base gap) :
    pair.second - pair.first <=
      Fintype.card (TrackedMode (p + 1)) * gap := by
  have hlower := pair.lower_bound
  have hupper := pair.upper_bound
  omega

theorem BoundedAdvancedPair.beta_second_lt_first
    {p : Nat} {hp : 1 <= p} {branch : InfiniteSourceWalk hp}
    {initial : Real} (hretained : AdvancedArrivalsNonincreasing branch initial)
    {base gap : Nat} (pair : BoundedAdvancedPair branch base gap) :
    branch.beta initial (pair.second + 1) <
      branch.beta initial (pair.first + 1) := by
  have hposition : pair.first + 1 < pair.second + 1 :=
    Nat.add_lt_add_right pair.first_lt_second 1
  have hle := hretained pair.second pair.second_advanced
    (pair.first + 1) hposition pair.same_target
  exact lt_of_le_of_ne hle (beta_ne_of_lt branch initial hposition)

def boundedSourceWeightValues {p : Nat} (hp : 1 <= p)
    (bound : Nat) : Set Real :=
  Set.range fun packed : BoundedPackedSourceWalk hp bound =>
    packed.2.2.1.weight.eval

theorem boundedSourceWeightValues_finite
    {p : Nat} (hp : 1 <= p) (bound : Nat) :
    (boundedSourceWeightValues hp bound).Finite := by
  exact Set.finite_range _

def boundedNegativeSourceWeightValues {p : Nat} (hp : 1 <= p)
    (bound : Nat) : Set Real :=
  boundedSourceWeightValues hp bound ∩ Set.Iio 0

theorem boundedNegativeSourceWeightValues_finite
    {p : Nat} (hp : 1 <= p) (bound : Nat) :
    (boundedNegativeSourceWeightValues hp bound).Finite := by
  exact (boundedSourceWeightValues_finite hp bound).inter_of_left _

theorem exists_uniform_boundedNegativeSourceWeight_gap
    {p : Nat} (hp : 1 <= p) (bound : Nat) :
    exists epsilon : Real, 0 < epsilon /\
      forall weight, weight ∈ boundedNegativeSourceWeightValues hp bound ->
        weight <= -epsilon := by
  apply GeneralKNestedReturnDescent.exists_uniform_negative_gap_of_finite_near_zero
  · intro weight hweight
    exact hweight.2
  · exact (boundedNegativeSourceWeightValues_finite hp bound).inter_of_left _

theorem BoundedAdvancedPair.segment_weight_mem
    {p : Nat} {hp : 1 <= p} {branch : InfiniteSourceWalk hp}
    {initial : Real} (hretained : AdvancedArrivalsNonincreasing branch initial)
    {base gap : Nat} (pair : BoundedAdvancedPair branch base gap) :
    (branch.segment (pair.first + 1) (pair.second - pair.first)).weight.eval ∈
      boundedNegativeSourceWeightValues hp
        (Fintype.card (TrackedMode (p + 1)) * gap) := by
  refine ⟨?_, ?_⟩
  · let walk := branch.segment (pair.first + 1) (pair.second - pair.first)
    let packed : BoundedPackedSourceWalk hp
        (Fintype.card (TrackedMode (p + 1)) * gap) :=
      ⟨branch.modes (pair.first + 1),
        branch.modes (pair.first + 1 + (pair.second - pair.first)),
        ⟨walk, by
          dsimp only [walk]
          rw [branch.segment_length]
          exact pair.span_le⟩⟩
    exact ⟨packed, rfl⟩
  · have hbeta := branch.beta_add initial
      (pair.first + 1) (pair.second - pair.first)
    have hfirstLe : pair.first <= pair.second := pair.first_lt_second.le
    have hindex : pair.first + 1 + (pair.second - pair.first) =
        pair.second + 1 := by omega
    have hbeta' : branch.beta initial (pair.second + 1) =
        branch.beta initial (pair.first + 1) +
          (branch.segment (pair.first + 1)
            (pair.second - pair.first)).weight.eval := by
      simpa only [hindex] using hbeta
    have hlt : branch.beta initial (pair.second + 1) <
        branch.beta initial (pair.first + 1) :=
      pair.beta_second_lt_first hretained
    rw [hbeta'] at hlt
    have hlt' : branch.beta initial (pair.first + 1) +
          (branch.segment (pair.first + 1)
            (pair.second - pair.first)).weight.eval <
        branch.beta initial (pair.first + 1) + 0 := by
      simpa only [add_zero] using hlt
    exact (add_lt_add_iff_left
      (branch.beta initial (pair.first + 1))).mp hlt'

theorem exists_uniform_boundedAdvancedPair_drop
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial)
    (hretained : AdvancedArrivalsNonincreasing branch initial)
    {gap : Nat}
    (hgap : forall start : Nat, exists offset : Nat, offset < gap /\
      IsAdvancedAction (branch.actions (start + offset))) :
    exists epsilon : Real, 0 < epsilon /\
      forall base : Nat, exists pair : BoundedAdvancedPair branch base gap,
        (branch.segment (pair.first + 1)
          (pair.second - pair.first)).weight.eval <= -epsilon := by
  obtain ⟨epsilon, hepsilon, hdrop⟩ :=
    exists_uniform_boundedNegativeSourceWeight_gap hp
      (Fintype.card (TrackedMode (p + 1)) * gap)
  refine ⟨epsilon, hepsilon, ?_⟩
  intro base
  let pair := Classical.choice
    (exists_boundedAdvancedPair branch initial hnonnegative hgap base)
  exact ⟨pair, hdrop _ (pair.segment_weight_mem hretained)⟩

def advancedBlockSize (p : Nat) : Nat :=
  Fintype.card (TrackedMode (p + 1)) + 1

noncomputable def chosenBoundedAdvancedPair
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial)
    {gap : Nat}
    (hgap : forall start : Nat, exists offset : Nat, offset < gap /\
      IsAdvancedAction (branch.actions (start + offset)))
    (block : Nat) :
    BoundedAdvancedPair branch (block * advancedBlockSize p) gap :=
  Classical.choice
    (exists_boundedAdvancedPair branch initial hnonnegative hgap
      (block * advancedBlockSize p))

noncomputable def chosenBoundedAdvancedPairMode
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial)
    {gap : Nat}
    (hgap : forall start : Nat, exists offset : Nat, offset < gap /\
      IsAdvancedAction (branch.actions (start + offset)))
    (block : Nat) : TrackedMode (p + 1) :=
  branch.modes
    ((chosenBoundedAdvancedPair branch initial hnonnegative hgap block).first + 1)

theorem chosenBoundedAdvancedPair_ordered
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial)
    {gap : Nat}
    (hgap : forall start : Nat, exists offset : Nat, offset < gap /\
      IsAdvancedAction (branch.actions (start + offset)))
    {earlier later : Nat} (hlt : earlier < later) :
    (chosenBoundedAdvancedPair branch initial hnonnegative hgap earlier).second <
      (chosenBoundedAdvancedPair branch initial hnonnegative hgap later).first := by
  let modeCount := Fintype.card (TrackedMode (p + 1))
  let blockSize := advancedBlockSize p
  let firstPair :=
    chosenBoundedAdvancedPair branch initial hnonnegative hgap earlier
  let secondPair :=
    chosenBoundedAdvancedPair branch initial hnonnegative hgap later
  have hblockPos : 0 < blockSize := by
    dsimp only [blockSize, advancedBlockSize]
    omega
  have hindex : earlier * blockSize + modeCount < later * blockSize := by
    calc
      earlier * blockSize + modeCount < earlier * blockSize + blockSize := by
        apply Nat.add_lt_add_left
        dsimp only [blockSize, advancedBlockSize, modeCount]
        omega
      _ = (earlier + 1) * blockSize := by ring
      _ <= later * blockSize := by
        exact Nat.mul_le_mul_right blockSize (by omega)
  have hposition :=
    (advancedPosition_strictMono branch initial hnonnegative) hindex
  exact firstPair.upper_position.trans_lt
    (hposition.trans_le secondPair.lower_bound)

theorem exists_recurrent_chosenPairMode_subsequence
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial)
    {gap : Nat}
    (hgap : forall start : Nat, exists offset : Nat, offset < gap /\
      IsAdvancedAction (branch.actions (start + offset))) :
    exists mode : TrackedMode (p + 1), exists blocks : Nat -> Nat,
      StrictMono blocks /\
        forall j : Nat,
          chosenBoundedAdvancedPairMode
            branch initial hnonnegative hgap (blocks j) = mode := by
  exact exists_recurrent_mode_subsequence
    (chosenBoundedAdvancedPairMode branch initial hnonnegative hgap)

theorem BoundedAdvancedPair.beta_second_le_sub
    {p : Nat} {hp : 1 <= p} {branch : InfiniteSourceWalk hp}
    {initial epsilon : Real} {base gap : Nat}
    (pair : BoundedAdvancedPair branch base gap)
    (hdrop : (branch.segment (pair.first + 1)
      (pair.second - pair.first)).weight.eval <= -epsilon) :
    branch.beta initial (pair.second + 1) <=
      branch.beta initial (pair.first + 1) - epsilon := by
  have hfirstLe : pair.first <= pair.second := pair.first_lt_second.le
  have hindex : pair.first + 1 + (pair.second - pair.first) =
      pair.second + 1 := by omega
  have hbeta := branch.beta_add initial
    (pair.first + 1) (pair.second - pair.first)
  have hbeta' : branch.beta initial (pair.second + 1) =
      branch.beta initial (pair.first + 1) +
        (branch.segment (pair.first + 1)
          (pair.second - pair.first)).weight.eval := by
    simpa only [hindex] using hbeta
  rw [hbeta']
  linarith

theorem nonnegative_branch_impossible_of_advancedArrivalsNonincreasing
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial)
    (hretained : AdvancedArrivalsNonincreasing branch initial) : False := by
  obtain ⟨gap, _hgapPos, hgap⟩ :=
    exists_uniform_advanced_gap branch initial hnonnegative hretained
  obtain ⟨epsilon, hepsilon, hweightDrop⟩ :=
    exists_uniform_boundedNegativeSourceWeight_gap hp
      (Fintype.card (TrackedMode (p + 1)) * gap)
  obtain ⟨mode, blocks, hblocks, hmodes⟩ :=
    exists_recurrent_chosenPairMode_subsequence
      branch initial hnonnegative hgap
  let pair : Nat -> Sigma fun block : Nat =>
      BoundedAdvancedPair branch (block * advancedBlockSize p) gap :=
    fun j => ⟨blocks j,
      chosenBoundedAdvancedPair branch initial hnonnegative hgap (blocks j)⟩
  let endpoint : Nat -> Real := fun j =>
    branch.beta initial ((pair j).2.second + 1)
  have hpairDrop : forall j : Nat,
      branch.beta initial ((pair j).2.second + 1) <=
        branch.beta initial ((pair j).2.first + 1) - epsilon := by
    intro j
    apply (pair j).2.beta_second_le_sub
    apply hweightDrop
    exact (pair j).2.segment_weight_mem hretained
  have hcross : forall j : Nat,
      branch.beta initial ((pair (j + 1)).2.first + 1) <=
        branch.beta initial ((pair j).2.second + 1) := by
    intro j
    have hblockLt : blocks j < blocks (j + 1) :=
      hblocks (show j < j + 1 by omega)
    have hposition : (pair j).2.second + 1 <
        (pair (j + 1)).2.first + 1 := by
      apply Nat.add_lt_add_right
      exact chosenBoundedAdvancedPair_ordered
        branch initial hnonnegative hgap hblockLt
    apply hretained (pair (j + 1)).2.first
      (pair (j + 1)).2.first_advanced
      ((pair j).2.second + 1) hposition
    calc
      branch.modes ((pair j).2.second + 1)
          = branch.modes ((pair j).2.first + 1) := (pair j).2.same_target.symm
      _ = mode := hmodes j
      _ = branch.modes ((pair (j + 1)).2.first + 1) := (hmodes (j + 1)).symm
  have hendpointStep : forall j : Nat,
      endpoint (j + 1) <= endpoint j - epsilon := by
    intro j
    dsimp only [endpoint]
    exact (hpairDrop (j + 1)).trans
      (sub_le_sub_right (hcross j) epsilon)
  have hendpointBound : forall n : Nat,
      endpoint n <= endpoint 0 - (n : Real) * epsilon := by
    intro n
    induction n with
    | zero => simp
    | succ n ih =>
        calc
          endpoint (n + 1) <= endpoint n - epsilon := hendpointStep n
          _ <= (endpoint 0 - (n : Real) * epsilon) - epsilon :=
            sub_le_sub_right ih epsilon
          _ = endpoint 0 - ((n + 1 : Nat) : Real) * epsilon := by
            push_cast
            ring
  obtain ⟨n, hn⟩ := exists_nat_gt (endpoint 0 / epsilon)
  have htooLow : endpoint n < 0 := by
    have hmul : endpoint 0 < (n : Real) * epsilon := by
      exact (div_lt_iff₀ hepsilon).mp hn
    exact lt_of_le_of_lt (hendpointBound n) (by linarith)
  exact (not_lt_of_ge (hnonnegative ((pair n).2.second + 1))) htooLow

theorem extractedCriticalBranch_nontermination_impossible
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {y : Real} (hy : 2 <= y)
    (hbounds : (ProvenancedTree.initial hp root).forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : (ProvenancedTree.initial hp root).forget.normalExpr
      |>.ArgumentsNonnegative y)
    (hne : NeverStops (ProvenancedTree.initial hp root) y) : False := by
  exact nonnegative_branch_impossible_of_advancedArrivalsNonincreasing
    (extractedInfiniteSourceWalk hne) root.shift.eval
    (extractedInfiniteSourceWalk_shiftsNonnegative hne)
    (extractedCriticalBranch_advancedArrivalsNonincreasing
      roots hy hbounds hargs hne)

theorem criticalScheduler_not_neverStops
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {y : Real} (hy : 2 <= y)
    (hbounds : (ProvenancedTree.initial hp root).forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : (ProvenancedTree.initial hp root).forget.normalExpr
      |>.ArgumentsNonnegative y) :
    Not (NeverStops (ProvenancedTree.initial hp root) y) := by
  intro hne
  exact extractedCriticalBranch_nontermination_impossible
    roots hy hbounds hargs hne

theorem exists_criticalScheduler_stop
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {y : Real} (hy : 2 <= y)
    (hbounds : (ProvenancedTree.initial hp root).forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : (ProvenancedTree.initial hp root).forget.normalExpr
      |>.ArgumentsNonnegative y) :
    exists n : Nat,
      findCriticalExpandableOccurrence
        (run (ProvenancedTree.initial hp root) y n)
        (fun mode z => sourcePhiK mode z) y = none := by
  by_contra hnone
  push_neg at hnone
  exact criticalScheduler_not_neverStops roots hy hbounds hargs hnone

theorem exists_criticalTerminalShiftsNegative
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {y : Real} (hy : 2 <= y)
    (hbounds : (ProvenancedTree.initial hp root).forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : (ProvenancedTree.initial hp root).forget.normalExpr
      |>.ArgumentsNonnegative y) :
    exists n : Nat,
      CriticalTerminalShiftsNegative
        (run (ProvenancedTree.initial hp root) y n)
        (fun mode z => sourcePhiK mode z) y := by
  obtain ⟨n, hstop⟩ :=
    exists_criticalScheduler_stop roots hy hbounds hargs
  exact ⟨n, (stopped_iff_criticalTerminalShiftsNegative
    (ProvenancedTree.initial hp root) y n).mp hstop⟩

end GeneralKAdvancedArrivalBoundedness
end KL2003
end CollatzClassical
