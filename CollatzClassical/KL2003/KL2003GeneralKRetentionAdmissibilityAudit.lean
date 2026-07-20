import CollatzClassical.KL2003.KL2003GeneralKProvenancedScheduler

namespace CollatzClassical
namespace KL2003

/-!
Audit the exact witness-freeness supplied by `witnessRetention`.

The policy is maximal among nonempty retained subsets.  Hence retained
branches are witness-free unless all three candidates have witnesses; in that
exceptional case the policy keeps the first branch to avoid an empty minimum.
-/

namespace GeneralKRetentionAdmissibilityAudit

open ELTree
open ELTree.TerminalPath

def AllThreeHaveWitness {k : Nat} {tree : ELTree k}
    {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third) : Prop :=
  configuration.firstPath.HasDeletionWitness /\
    configuration.secondPath.HasDeletionWitness /\
      configuration.thirdPath.HasDeletionWitness

def RetainedBranchesWitnessFree {k : Nat} {tree : ELTree k}
    {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third) :
    Min3Retention -> Prop
  | .keepAll =>
      Not configuration.firstPath.HasDeletionWitness /\
        Not configuration.secondPath.HasDeletionWitness /\
          Not configuration.thirdPath.HasDeletionWitness
  | .keepFirstSecond =>
      Not configuration.firstPath.HasDeletionWitness /\
        Not configuration.secondPath.HasDeletionWitness
  | .keepFirstThird =>
      Not configuration.firstPath.HasDeletionWitness /\
        Not configuration.thirdPath.HasDeletionWitness
  | .keepSecondThird =>
      Not configuration.secondPath.HasDeletionWitness /\
        Not configuration.thirdPath.HasDeletionWitness
  | .keepFirst => Not configuration.firstPath.HasDeletionWitness
  | .keepSecond => Not configuration.secondPath.HasDeletionWitness
  | .keepThird => Not configuration.thirdPath.HasDeletionWitness

theorem witnessRetention_eq_keepFirst_of_allThreeHaveWitness
    {k : Nat} {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    (hall : AllThreeHaveWitness configuration) :
    configuration.witnessRetention = .keepFirst := by
  classical
  simp [AdvancedMinConfiguration.witnessRetention, AllThreeHaveWitness,
    hall.1, hall.2.1, hall.2.2]

theorem witnessRetention_retainedBranchesWitnessFree_iff
    {k : Nat} {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third) :
    RetainedBranchesWitnessFree configuration
        configuration.witnessRetention <->
      Not (AllThreeHaveWitness configuration) := by
  classical
  by_cases hfirst : configuration.firstPath.HasDeletionWitness <;>
    by_cases hsecond : configuration.secondPath.HasDeletionWitness <;>
      by_cases hthird : configuration.thirdPath.HasDeletionWitness <;>
        simp [AdvancedMinConfiguration.witnessRetention,
          RetainedBranchesWitnessFree, AllThreeHaveWitness, hfirst, hsecond,
          hthird]

theorem allThreeHaveWitness_keeps_a_witnessed_branch
    {k : Nat} {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    (hall : AllThreeHaveWitness configuration) :
    Not (RetainedBranchesWitnessFree configuration
      configuration.witnessRetention) := by
  rw [witnessRetention_retainedBranchesWitnessFree_iff]
  exact not_not_intro hall

end GeneralKRetentionAdmissibilityAudit

end KL2003
end CollatzClassical
