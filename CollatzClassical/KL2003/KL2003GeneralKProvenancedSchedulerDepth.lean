import CollatzClassical.KL2003.KL2003GeneralKProvenancedScheduler

namespace CollatzClassical
namespace KL2003

/-!
Unbounded genealogy depth for a nonterminating provenanced source scheduler.

For a fixed depth bound `B`, a terminal at depth `d <= B` receives the
remaining capacity of a quaternary tree of height `B - d`.  Expanding that
terminal creates at most four children at depth `d + 1`, so the total capacity
strictly decreases.  An infinite scheduler run therefore cannot keep every
selected source walk below one fixed depth.
-/

namespace GeneralKProvenancedSchedulerDepth

open GeneralKSourceGraph
open GeneralKSourceGenealogy
open GeneralKProvenancedScheduler
open GeneralKSourceGenealogy.ProvenancedTree
open GeneralKProvenancedScheduler.ProvenancedTree

/-- Number of future internal nodes in a full quaternary tree of this height,
including its root. -/
def branchCapacity : Nat -> Nat
  | 0 => 1
  | n + 1 => 1 + 4 * branchCapacity n

@[simp] theorem branchCapacity_zero : branchCapacity 0 = 1 := rfl

@[simp] theorem branchCapacity_succ (n : Nat) :
    branchCapacity (n + 1) = 1 + 4 * branchCapacity n := rfl

/-- Remaining bounded-depth expansion capacity carried by one terminal. -/
def terminalFuel {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (bound : Nat) (node : ProvenancedLabel hp root) : Nat :=
  if node.walk.length <= bound then
    branchCapacity (bound - node.walk.length)
  else 0

/-- Sum of the remaining expansion capacities of all current terminals. -/
def treeFuel {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (bound : Nat) : ProvenancedTree hp root -> Nat
  | .terminal node => terminalFuel bound node
  | .expanded _ body => treeFuel bound body
  | .add left right => treeFuel bound left + treeFuel bound right
  | .min2 left right => treeFuel bound left + treeFuel bound right
  | .min3 first second third =>
      treeFuel bound first + treeFuel bound second + treeFuel bound third

theorem four_mul_terminalFuel_child_lt {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (bound : Nat) (node : ProvenancedLabel hp root)
    (action : SourceAction node.label.mode) (hdepth : node.walk.length <= bound) :
    4 * terminalFuel bound (node.child action) < terminalFuel bound node := by
  unfold terminalFuel
  rw [ProvenancedLabel.child_walk_length, if_pos hdepth]
  by_cases heq : node.walk.length = bound
  · have hchild : ¬ (node.walk.length + 1 ≤ bound) := by
      simpa [heq]
    rw [if_neg hchild]
    simp [heq]
  · have hlt : node.walk.length < bound := lt_of_le_of_ne hdepth heq
    have hchild : node.walk.length + 1 <= bound := by omega
    rw [if_pos hchild]
    have hsub : bound - node.walk.length =
        (bound - (node.walk.length + 1)) + 1 := by omega
    rw [hsub, branchCapacity_succ]
    omega

theorem treeFuel_reduce_le_three_mul {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (bound : Nat)
    (retention : ELTree.Min3Retention)
    (first second third : ProvenancedTree hp root) :
    treeFuel bound (ProvenancedTree.reduce retention first second third) <=
      treeFuel bound first + treeFuel bound second + treeFuel bound third := by
  cases retention <;> simp [ProvenancedTree.reduce, treeFuel] <;> omega

theorem treeFuel_d1ReducedSourceSplit_lt {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (bound : Nat) (node : ProvenancedLabel hp root)
    (hm : node.label.mode.1.1 % 9 = 2)
    (retention : ELTree.Min3Retention)
    (hdepth : node.walk.length <= bound) :
    treeFuel bound (d1ReducedSourceSplit node hm retention) <
      terminalFuel bound node := by
  have hret := four_mul_terminalFuel_child_lt bound node
    (retardedAction node.label.mode) hdepth
  have hfirst := four_mul_terminalFuel_child_lt bound node
    (d1AdvancedAction node.label.mode hm 0) hdepth
  have hsecond := four_mul_terminalFuel_child_lt bound node
    (d1AdvancedAction node.label.mode hm 1) hdepth
  have hthird := four_mul_terminalFuel_child_lt bound node
    (d1AdvancedAction node.label.mode hm 2) hdepth
  cases retention <;>
    simp only [d1ReducedSourceSplit, ProvenancedTree.reduce, treeFuel] <;>
    omega

theorem treeFuel_d3ReducedSourceSplit_lt {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (bound : Nat) (node : ProvenancedLabel hp root)
    (hm : node.label.mode.1.1 % 9 = 8)
    (retention : ELTree.Min3Retention)
    (hdepth : node.walk.length <= bound) :
    treeFuel bound (d3ReducedSourceSplit node hm retention) <
      terminalFuel bound node := by
  have hret := four_mul_terminalFuel_child_lt bound node
    (retardedAction node.label.mode) hdepth
  have hfirst := four_mul_terminalFuel_child_lt bound node
    (d3AdvancedAction node.label.mode hm 0) hdepth
  have hsecond := four_mul_terminalFuel_child_lt bound node
    (d3AdvancedAction node.label.mode hm 1) hdepth
  have hthird := four_mul_terminalFuel_child_lt bound node
    (d3AdvancedAction node.label.mode hm 2) hdepth
  cases retention <;>
    simp only [d3ReducedSourceSplit, ProvenancedTree.reduce, treeFuel] <;>
    omega

theorem treeFuel_sourceSplit_lt_of_mod_five {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (bound : Nat) (node : ProvenancedLabel hp root)
    (hm : node.label.mode.1.1 % 9 = 5)
    (hdepth : node.walk.length <= bound) :
    treeFuel bound (ProvenancedTree.sourceSplit node) < terminalFuel bound node := by
  have hnot2 : node.label.mode.1.1 % 9 != 2 := by rw [hm]; decide
  have hchild := four_mul_terminalFuel_child_lt bound node
    (retardedAction node.label.mode) hdepth
  simp [ProvenancedTree.sourceSplit, hm, treeFuel]
  omega

theorem treeFuel_provenancedReplaceAt_lt {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (bound : Nat)
    {tree : ProvenancedTree hp root} {target : ProvenancedLabel hp root}
    (path : ProvenancedTree.TerminalPath tree target)
    (replacement : ProvenancedTree hp root)
    (hreplacement : treeFuel bound replacement < terminalFuel bound target) :
    treeFuel bound (provenancedReplaceAt path replacement) < treeFuel bound tree := by
  induction path with
  | here node => exact hreplacement
  | expanded node body target path ih => exact ih hreplacement
  | addLeft left right target path ih =>
      have hlocal := ih hreplacement
      simp only [provenancedReplaceAt, treeFuel]
      omega
  | addRight left right target path ih =>
      have hlocal := ih hreplacement
      simp only [provenancedReplaceAt, treeFuel]
      omega
  | min2Left left right target path ih =>
      have hlocal := ih hreplacement
      simp only [provenancedReplaceAt, treeFuel]
      omega
  | min2Right left right target path ih =>
      have hlocal := ih hreplacement
      simp only [provenancedReplaceAt, treeFuel]
      omega
  | minFirst first second third target path ih =>
      have hlocal := ih hreplacement
      simp only [provenancedReplaceAt, treeFuel]
      omega
  | minSecond first second third target path ih =>
      have hlocal := ih hreplacement
      simp only [provenancedReplaceAt, treeFuel]
      omega
  | minThird first second third target path ih =>
      have hlocal := ih hreplacement
      simp only [provenancedReplaceAt, treeFuel]
      omega

theorem provenancedReplaceAt_sourceSplit {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {tree : ProvenancedTree hp root}
    {target : ProvenancedLabel hp root}
    (path : ProvenancedTree.TerminalPath tree target) :
    provenancedReplaceAt path (ProvenancedTree.sourceSplit target) = path.splitAt := by
  induction path <;>
    simp [provenancedReplaceAt, ProvenancedTree.TerminalPath.splitAt, *]

theorem treeFuel_sourceStep_lt {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (bound : Nat)
    {tree : ProvenancedTree hp root} (occurrence : ExpandableOccurrence tree)
    (hdepth : occurrence.target.walk.length <= bound) :
    treeFuel bound occurrence.sourceStep < treeFuel bound tree := by
  rcases ELTree.trackedMode_mod_nine_cases occurrence.target.label.mode with
      hm2 | hm5 | hm8
  · rw [occurrence.sourceStep_eq_d1 hm2]
    dsimp only
    apply treeFuel_provenancedReplaceAt_lt
    exact treeFuel_d1ReducedSourceSplit_lt bound occurrence.target hm2 _ hdepth
  · rw [occurrence.sourceStep_eq_d2 hm5,
      <- provenancedReplaceAt_sourceSplit occurrence.path]
    apply treeFuel_provenancedReplaceAt_lt
    exact treeFuel_sourceSplit_lt_of_mod_five bound occurrence.target hm5 hdepth
  · rw [occurrence.sourceStep_eq_d3 hm8]
    dsimp only
    apply treeFuel_provenancedReplaceAt_lt
    exact treeFuel_d3ReducedSourceSplit_lt bound occurrence.target hm8 _ hdepth

theorem descendingFuel_add_index_le {fuel : Nat -> Nat}
    (hdesc : forall n, fuel (n + 1) < fuel n) :
    forall n, fuel n + n <= fuel 0 := by
  intro n
  induction n with
  | zero => simp
  | succ n ih =>
      have hstep := hdesc n
      omega

/-- A scheduler which can perform every finite step selects provenances of
arbitrarily large source-walk length. -/
theorem exists_selectedOccurrence_walk_length_gt {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : ProvenancedTree hp root}
    (hne : NeverStops initial) (bound : Nat) :
    exists n : Nat, bound < (selectedOccurrence hne n).target.walk.length := by
  by_contra hbounded
  push_neg at hbounded
  have hdesc : forall n,
      treeFuel bound (run initial (n + 1)) < treeFuel bound (run initial n) := by
    intro n
    rw [run_succ_eq_selectedOccurrence_sourceStep hne n]
    exact treeFuel_sourceStep_lt bound (selectedOccurrence hne n) (hbounded n)
  have hbudget := descendingFuel_add_index_le
    (fuel := fun n => treeFuel bound (run initial n)) hdesc
    (treeFuel bound initial + 1)
  have hbudget' :
      treeFuel bound (run initial (treeFuel bound initial + 1)) +
          (treeFuel bound initial + 1) <= treeFuel bound initial := by
    simpa using hbudget
  omega

end GeneralKProvenancedSchedulerDepth

end KL2003
end CollatzClassical
