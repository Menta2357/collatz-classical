import CollatzClassical.KL2003.KL2003GeneralKRetentionAdmissibilityAudit

namespace CollatzClassical
namespace KL2003
namespace GeneralKCriticalTripleWitnessExclusion

open ELTree
open ELTree.TerminalPath
open GeneralKRetentionAdmissibilityAudit

/-!
Exclude three simultaneous syntactic deletion witnesses at an advanced
minimum that is globally critical for a positive monotone system satisfying
the source equation-(305) invariant.

This is the semantic hypothesis used by KL2003 and is strictly stronger than
source typing plus nonnegative genealogy shifts.
-/

theorem not_allThreeHaveWitness_of_targetCritical
    {k : Nat} {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    {Phi : TrackedMode k -> Real -> Real} {y : Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    (hbounds : tree.CriticalNodeBounds Phi y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y)
    (hcritical : configuration.minPath.context.HoleCritical
      configuration.minPath.target Phi y) :
    Not (AllThreeHaveWitness configuration) := by
  intro hall
  have hfirst :
      Not (configuration.minPath.firstBranchContext.HoleCritical
        configuration.minPath.firstChild Phi y) := by
    rw [configuration.firstContext_eq, configuration.firstChild_eq]
    simpa [ELTree.CriticalNodeBounds, ELTree.Context.comp] using
      configuration.firstPath
        |>.deletionWitness_implies_not_holeCritical_of_criticalNodeBounds
          .hole hpos hmono hbounds hargs configuration.firstAddBelow hall.1
  have hsecond :
      Not (configuration.minPath.secondBranchContext.HoleCritical
        configuration.minPath.secondChild Phi y) := by
    rw [configuration.secondContext_eq, configuration.secondChild_eq]
    simpa [ELTree.CriticalNodeBounds, ELTree.Context.comp] using
      configuration.secondPath
        |>.deletionWitness_implies_not_holeCritical_of_criticalNodeBounds
          .hole hpos hmono hbounds hargs configuration.secondAddBelow hall.2.1
  have hthird :
      Not (configuration.minPath.thirdBranchContext.HoleCritical
        configuration.minPath.thirdChild Phi y) := by
    rw [configuration.thirdContext_eq, configuration.thirdChild_eq]
    simpa [ELTree.CriticalNodeBounds, ELTree.Context.comp] using
      configuration.thirdPath
        |>.deletionWitness_implies_not_holeCritical_of_criticalNodeBounds
          .hole hpos hmono hbounds hargs configuration.thirdAddBelow hall.2.2
  rcases Min3Retention.one_branch_critical
      (configuration.minPath.firstChild.normalExpr.eval Phi y)
      (configuration.minPath.secondChild.normalExpr.eval Phi y)
      (configuration.minPath.thirdChild.normalExpr.eval Phi y) with
    hfirstCritical | hsecondCritical | hthirdCritical
  · exact hfirst ((configuration.minPath.firstBranch_holeCritical_iff Phi y).2
      ⟨hcritical, hfirstCritical⟩)
  · exact hsecond ((configuration.minPath.secondBranch_holeCritical_iff Phi y).2
      ⟨hcritical, hsecondCritical⟩)
  · exact hthird ((configuration.minPath.thirdBranch_holeCritical_iff Phi y).2
      ⟨hcritical, hthirdCritical⟩)

theorem witnessRetention_retainedBranchesWitnessFree_of_targetCritical
    {k : Nat} {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    {Phi : TrackedMode k -> Real -> Real} {y : Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    (hbounds : tree.CriticalNodeBounds Phi y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y)
    (hcritical : configuration.minPath.context.HoleCritical
      configuration.minPath.target Phi y) :
    RetainedBranchesWitnessFree configuration
      configuration.witnessRetention := by
  rw [witnessRetention_retainedBranchesWitnessFree_iff]
  exact not_allThreeHaveWitness_of_targetCritical configuration hpos hmono
    hbounds hargs hcritical

theorem criticalWitnessRetention_retainedBranchesWitnessFree_of_targetCritical
    {k : Nat} {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    {Phi : TrackedMode k -> Real -> Real} {y : Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    (hbounds : tree.CriticalNodeBounds Phi y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y)
    (hcritical : configuration.minPath.context.HoleCritical
      configuration.minPath.target Phi y) :
    RetainedBranchesWitnessFree configuration
      (configuration.criticalWitnessRetention Phi y) := by
  rw [AdvancedMinConfiguration.criticalWitnessRetention]
  simp only [hcritical, if_true]
  exact witnessRetention_retainedBranchesWitnessFree_of_targetCritical
    configuration hpos hmono hbounds hargs hcritical

end GeneralKCriticalTripleWitnessExclusion
end KL2003
end CollatzClassical
