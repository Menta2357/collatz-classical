import CollatzClassical.KL2003.KL2003GeneralKEliminationTree

namespace CollatzClassical
namespace KL2003

/-!
One-hole contexts for EL trees.  A hole is globally critical when its value
survives every minimum on the path to the root.  This is the contextual notion
needed by the source deletion rule; it is weaker than local nonminimality.
-/

namespace ELTree

inductive Context (k : Nat) where
  | hole : Context k
  | expanded : ELLabel k -> Context k -> Context k
  | addLeft : Context k -> ELTree k -> Context k
  | addRight : ELTree k -> Context k -> Context k
  | min2Left : Context k -> ELTree k -> Context k
  | min2Right : ELTree k -> Context k -> Context k
  | minFirst : Context k -> ELTree k -> ELTree k -> Context k
  | minSecond : ELTree k -> Context k -> ELTree k -> Context k
  | minThird : ELTree k -> ELTree k -> Context k -> Context k
deriving Repr

namespace Context

def plug {k : Nat} : Context k -> ELTree k -> ELTree k
  | .hole, tree => tree
  | .expanded label context, tree => .expanded label (context.plug tree)
  | .addLeft context right, tree => .add (context.plug tree) right
  | .addRight left context, tree => .add left (context.plug tree)
  | .min2Left context right, tree => .min2 (context.plug tree) right
  | .min2Right left context, tree => .min2 left (context.plug tree)
  | .minFirst context second third, tree =>
      .min3 (context.plug tree) second third
  | .minSecond first context third, tree =>
      .min3 first (context.plug tree) third
  | .minThird first second context, tree =>
      .min3 first second (context.plug tree)

def HoleCritical {k : Nat} (context : Context k) (tree : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real) : Prop :=
  match context with
  | .hole => True
  | .expanded _ subcontext => subcontext.HoleCritical tree Phi y
  | .addLeft subcontext _ => subcontext.HoleCritical tree Phi y
  | .addRight _ subcontext => subcontext.HoleCritical tree Phi y
  | .min2Left subcontext right =>
      subcontext.HoleCritical tree Phi y /\
        (subcontext.plug tree).normalExpr.eval Phi y <=
          right.normalExpr.eval Phi y
  | .min2Right left subcontext =>
      subcontext.HoleCritical tree Phi y /\
        (subcontext.plug tree).normalExpr.eval Phi y <=
          left.normalExpr.eval Phi y
  | .minFirst subcontext second third =>
      subcontext.HoleCritical tree Phi y /\
        Min3Retention.criticalFirst
          ((subcontext.plug tree).normalExpr.eval Phi y)
          (second.normalExpr.eval Phi y) (third.normalExpr.eval Phi y)
  | .minSecond first subcontext third =>
      subcontext.HoleCritical tree Phi y /\
        Min3Retention.criticalSecond
          (first.normalExpr.eval Phi y)
          ((subcontext.plug tree).normalExpr.eval Phi y)
          (third.normalExpr.eval Phi y)
  | .minThird first second subcontext =>
      subcontext.HoleCritical tree Phi y /\
        Min3Retention.criticalThird
          (first.normalExpr.eval Phi y) (second.normalExpr.eval Phi y)
          ((subcontext.plug tree).normalExpr.eval Phi y)

theorem plug_normalExpr_eval_mono {k : Nat} (context : Context k)
    (oldTree newTree : ELTree k) (Phi : TrackedMode k -> Real -> Real)
    (y : Real)
    (hle : oldTree.normalExpr.eval Phi y <= newTree.normalExpr.eval Phi y) :
    (context.plug oldTree).normalExpr.eval Phi y <=
      (context.plug newTree).normalExpr.eval Phi y := by
  induction context with
  | hole => exact hle
  | expanded label context ih => simpa [plug, normalExpr] using ih
  | addLeft context right ih =>
      simpa [plug, normalExpr, ELExpr.eval] using
        add_le_add_right ih (right.normalExpr.eval Phi y)
  | addRight left context ih =>
      simpa [plug, normalExpr, ELExpr.eval] using
        add_le_add_left ih (left.normalExpr.eval Phi y)
  | min2Left context right ih =>
      exact min_le_min ih (le_refl _)
  | min2Right left context ih =>
      exact min_le_min (le_refl _) (min_le_min ih ih)
  | minFirst context second third ih =>
      exact min_le_min ih (le_refl _)
  | minSecond first context third ih =>
      exact min_le_min (le_refl _) (min_le_min ih (le_refl _))
  | minThird first second context ih =>
      exact min_le_min (le_refl _) (min_le_min (le_refl _) ih)

theorem not_criticalFirst_of_mono {old new second third : Real}
    (hle : old <= new)
    (hnot : ¬ Min3Retention.criticalFirst old second third) :
    ¬ Min3Retention.criticalFirst new second third := by
  intro hnew
  exact hnot ⟨hle.trans hnew.1, hle.trans hnew.2⟩

theorem not_criticalSecond_of_mono {first old new third : Real}
    (hle : old <= new)
    (hnot : ¬ Min3Retention.criticalSecond first old third) :
    ¬ Min3Retention.criticalSecond first new third := by
  intro hnew
  exact hnot ⟨hle.trans hnew.1, hle.trans hnew.2⟩

theorem not_criticalThird_of_mono {first second old new : Real}
    (hle : old <= new)
    (hnot : ¬ Min3Retention.criticalThird first second old) :
    ¬ Min3Retention.criticalThird first second new := by
  intro hnew
  exact hnot ⟨hle.trans hnew.1, hle.trans hnew.2⟩

theorem plug_normalExpr_eval_eq_of_not_holeCritical {k : Nat}
    (context : Context k) (oldTree newTree : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hle : oldTree.normalExpr.eval Phi y <= newTree.normalExpr.eval Phi y)
    (hnot : ¬ context.HoleCritical oldTree Phi y) :
    (context.plug oldTree).normalExpr.eval Phi y =
      (context.plug newTree).normalExpr.eval Phi y := by
  induction context with
  | hole => exact False.elim (hnot trivial)
  | expanded label context ih =>
      simpa [plug, normalExpr, HoleCritical] using ih hnot
  | addLeft context right ih =>
      simp [plug, normalExpr, ELExpr.eval, ih hnot]
  | addRight left context ih =>
      simp [plug, normalExpr, ELExpr.eval, ih hnot]
  | min2Left context right ih =>
      by_cases hsub : context.HoleCritical oldTree Phi y
      · let oldValue := (context.plug oldTree).normalExpr.eval Phi y
        let newValue := (context.plug newTree).normalExpr.eval Phi y
        let rightValue := right.normalExpr.eval Phi y
        have hmono : oldValue <= newValue :=
          context.plug_normalExpr_eval_mono oldTree newTree Phi y hle
        have hlocal : ¬ oldValue <= rightValue := by
          intro hcritical
          exact hnot ⟨hsub, hcritical⟩
        have holdNot : ¬ Min3Retention.criticalFirst
            oldValue rightValue rightValue := by
          intro hcritical
          exact hlocal hcritical.1
        have hnewNot : ¬ Min3Retention.criticalFirst
            newValue rightValue rightValue :=
          not_criticalFirst_of_mono hmono holdNot
        have hold := (Min3Retention.keepSecondThird).reducedValue_eq_full holdNot
        have hnew := (Min3Retention.keepSecondThird).reducedValue_eq_full hnewNot
        simpa [plug, normalExpr, ELExpr.eval, Min3Retention.reducedValue,
          oldValue, newValue, rightValue] using hold.symm.trans hnew
      · simp [plug, normalExpr, ELExpr.eval, ih hsub]
  | min2Right left context ih =>
      by_cases hsub : context.HoleCritical oldTree Phi y
      · let leftValue := left.normalExpr.eval Phi y
        let oldValue := (context.plug oldTree).normalExpr.eval Phi y
        let newValue := (context.plug newTree).normalExpr.eval Phi y
        have hmono : oldValue <= newValue :=
          context.plug_normalExpr_eval_mono oldTree newTree Phi y hle
        have hlocal : ¬ oldValue <= leftValue := by
          intro hcritical
          exact hnot ⟨hsub, hcritical⟩
        have holdSecond : ¬ Min3Retention.criticalSecond
            leftValue oldValue oldValue := by
          intro hcritical
          exact hlocal hcritical.1
        have holdThird : ¬ Min3Retention.criticalThird
            leftValue oldValue oldValue := by
          intro hcritical
          exact hlocal hcritical.1
        have hnewSecond : ¬ Min3Retention.criticalSecond
            leftValue newValue newValue := by
          intro hcritical
          exact hlocal (hmono.trans hcritical.1)
        have hnewThird : ¬ Min3Retention.criticalThird
            leftValue newValue newValue := by
          intro hcritical
          exact hlocal (hmono.trans hcritical.1)
        have hold := (Min3Retention.keepFirst).reducedValue_eq_full
          ⟨holdSecond, holdThird⟩
        have hnew := (Min3Retention.keepFirst).reducedValue_eq_full
          ⟨hnewSecond, hnewThird⟩
        simpa [plug, normalExpr, ELExpr.eval, Min3Retention.reducedValue,
          leftValue, oldValue, newValue] using hold.symm.trans hnew
      · simp [plug, normalExpr, ELExpr.eval, ih hsub]
  | minFirst context second third ih =>
      by_cases hsub : context.HoleCritical oldTree Phi y
      · let oldValue := (context.plug oldTree).normalExpr.eval Phi y
        let newValue := (context.plug newTree).normalExpr.eval Phi y
        let secondValue := second.normalExpr.eval Phi y
        let thirdValue := third.normalExpr.eval Phi y
        have hmono : oldValue <= newValue :=
          context.plug_normalExpr_eval_mono oldTree newTree Phi y hle
        have holdNot : ¬ Min3Retention.criticalFirst
            oldValue secondValue thirdValue := by
          intro hcritical
          exact hnot ⟨hsub, hcritical⟩
        have hnewNot : ¬ Min3Retention.criticalFirst
            newValue secondValue thirdValue :=
          not_criticalFirst_of_mono hmono holdNot
        have hold := (Min3Retention.keepSecondThird).reducedValue_eq_full holdNot
        have hnew := (Min3Retention.keepSecondThird).reducedValue_eq_full hnewNot
        simpa [plug, normalExpr, ELExpr.eval, Min3Retention.reducedValue,
          oldValue, newValue, secondValue, thirdValue] using hold.symm.trans hnew
      · simp [plug, normalExpr, ELExpr.eval, ih hsub]
  | minSecond first context third ih =>
      by_cases hsub : context.HoleCritical oldTree Phi y
      · let firstValue := first.normalExpr.eval Phi y
        let oldValue := (context.plug oldTree).normalExpr.eval Phi y
        let newValue := (context.plug newTree).normalExpr.eval Phi y
        let thirdValue := third.normalExpr.eval Phi y
        have hmono : oldValue <= newValue :=
          context.plug_normalExpr_eval_mono oldTree newTree Phi y hle
        have holdNot : ¬ Min3Retention.criticalSecond
            firstValue oldValue thirdValue := by
          intro hcritical
          exact hnot ⟨hsub, hcritical⟩
        have hnewNot : ¬ Min3Retention.criticalSecond
            firstValue newValue thirdValue :=
          not_criticalSecond_of_mono hmono holdNot
        have hold := (Min3Retention.keepFirstThird).reducedValue_eq_full holdNot
        have hnew := (Min3Retention.keepFirstThird).reducedValue_eq_full hnewNot
        simpa [plug, normalExpr, ELExpr.eval, Min3Retention.reducedValue,
          firstValue, oldValue, newValue, thirdValue] using hold.symm.trans hnew
      · simp [plug, normalExpr, ELExpr.eval, ih hsub]
  | minThird first second context ih =>
      by_cases hsub : context.HoleCritical oldTree Phi y
      · let firstValue := first.normalExpr.eval Phi y
        let secondValue := second.normalExpr.eval Phi y
        let oldValue := (context.plug oldTree).normalExpr.eval Phi y
        let newValue := (context.plug newTree).normalExpr.eval Phi y
        have hmono : oldValue <= newValue :=
          context.plug_normalExpr_eval_mono oldTree newTree Phi y hle
        have holdNot : ¬ Min3Retention.criticalThird
            firstValue secondValue oldValue := by
          intro hcritical
          exact hnot ⟨hsub, hcritical⟩
        have hnewNot : ¬ Min3Retention.criticalThird
            firstValue secondValue newValue :=
          not_criticalThird_of_mono hmono holdNot
        have hold := (Min3Retention.keepFirstSecond).reducedValue_eq_full holdNot
        have hnew := (Min3Retention.keepFirstSecond).reducedValue_eq_full hnewNot
        simpa [plug, normalExpr, ELExpr.eval, Min3Retention.reducedValue,
          firstValue, secondValue, oldValue, newValue] using hold.symm.trans hnew
      · simp [plug, normalExpr, ELExpr.eval, ih hsub]

end Context

namespace Min3Retention

theorem min3_normalExpr_eval_le_reduce {k : Nat}
    (retention : Min3Retention) (first second third : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real) :
    (ELTree.min3 first second third).normalExpr.eval Phi y <=
      (retention.reduce first second third).normalExpr.eval Phi y := by
  cases retention <;> simp [reduce, normalExpr, ELExpr.eval]

end Min3Retention

namespace Min3Path

def target {k : Nat} {tree : ELTree k} (path : Min3Path tree) : ELTree k :=
  .min3 path.firstChild path.secondChild path.thirdChild

def context {k : Nat} {tree : ELTree k} :
    (path : Min3Path tree) -> ELTree.Context k
  | .here _ _ _ => .hole
  | .expanded label _ subpath => .expanded label subpath.context
  | .addLeft _ right subpath => .addLeft subpath.context right
  | .addRight left _ subpath => .addRight left subpath.context
  | .min2Left _ right subpath => .min2Left subpath.context right
  | .min2Right left _ subpath => .min2Right left subpath.context
  | .minFirst _ second third subpath =>
      .minFirst subpath.context second third
  | .minSecond first _ third subpath =>
      .minSecond first subpath.context third
  | .minThird first second _ subpath =>
      .minThird first second subpath.context

theorem context_plug_target {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) : path.context.plug path.target = tree := by
  induction path with
  | here => rfl
  | expanded label body path ih =>
      simpa [context, target, ELTree.Context.plug, firstChild, secondChild,
        thirdChild] using congrArg (ELTree.expanded label) ih
  | addLeft left right path ih =>
      simpa [context, target, ELTree.Context.plug, firstChild, secondChild,
        thirdChild] using congrArg (fun value => ELTree.add value right) ih
  | addRight left right path ih =>
      simpa [context, target, ELTree.Context.plug, firstChild, secondChild,
        thirdChild] using congrArg (ELTree.add left) ih
  | min2Left left right path ih =>
      simpa [context, target, ELTree.Context.plug, firstChild, secondChild,
        thirdChild] using congrArg (fun value => ELTree.min2 value right) ih
  | min2Right left right path ih =>
      simpa [context, target, ELTree.Context.plug, firstChild, secondChild,
        thirdChild] using congrArg (ELTree.min2 left) ih
  | minFirst first second third path ih =>
      simpa [context, target, ELTree.Context.plug, firstChild, secondChild,
        thirdChild] using
        congrArg (fun value => ELTree.min3 value second third) ih
  | minSecond first second third path ih =>
      simpa [context, target, ELTree.Context.plug, firstChild, secondChild,
        thirdChild] using
        congrArg (fun value => ELTree.min3 first value third) ih
  | minThird first second third path ih =>
      simpa [context, target, ELTree.Context.plug, firstChild, secondChild,
        thirdChild] using congrArg (ELTree.min3 first second) ih

theorem context_plug_reduce {k : Nat} {tree : ELTree k}
    (retention : Min3Retention) (path : Min3Path tree) :
    path.context.plug
        (retention.reduce path.firstChild path.secondChild path.thirdChild) =
      path.reduceAt retention := by
  induction path with
  | here => rfl
  | expanded label body path ih =>
      simpa [context, ELTree.Context.plug, firstChild, secondChild, thirdChild,
        reduceAt] using congrArg (ELTree.expanded label) ih
  | addLeft left right path ih =>
      simpa [context, ELTree.Context.plug, firstChild, secondChild, thirdChild,
        reduceAt] using congrArg (fun value => ELTree.add value right) ih
  | addRight left right path ih =>
      simpa [context, ELTree.Context.plug, firstChild, secondChild, thirdChild,
        reduceAt] using congrArg (ELTree.add left) ih
  | min2Left left right path ih =>
      simpa [context, ELTree.Context.plug, firstChild, secondChild, thirdChild,
        reduceAt] using congrArg (fun value => ELTree.min2 value right) ih
  | min2Right left right path ih =>
      simpa [context, ELTree.Context.plug, firstChild, secondChild, thirdChild,
        reduceAt] using congrArg (ELTree.min2 left) ih
  | minFirst first second third path ih =>
      simpa [context, ELTree.Context.plug, firstChild, secondChild, thirdChild,
        reduceAt] using
        congrArg (fun value => ELTree.min3 value second third) ih
  | minSecond first second third path ih =>
      simpa [context, ELTree.Context.plug, firstChild, secondChild, thirdChild,
        reduceAt] using
        congrArg (fun value => ELTree.min3 first value third) ih
  | minThird first second third path ih =>
      simpa [context, ELTree.Context.plug, firstChild, secondChild, thirdChild,
        reduceAt] using congrArg (ELTree.min3 first second) ih

def TotallyNoncritical {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (Phi : TrackedMode k -> Real -> Real)
    (y : Real) : Prop :=
  ¬ path.context.HoleCritical path.target Phi y

theorem reduceAt_normalExpr_eval_eq_of_totallyNoncritical {k : Nat}
    {tree : ELTree k} (retention : Min3Retention) (path : Min3Path tree)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hnot : path.TotallyNoncritical Phi y) :
    (path.reduceAt retention).normalExpr.eval Phi y =
      tree.normalExpr.eval Phi y := by
  have hlocal := retention.min3_normalExpr_eval_le_reduce
    path.firstChild path.secondChild path.thirdChild Phi y
  have hcontext := path.context.plug_normalExpr_eval_eq_of_not_holeCritical
    path.target
    (retention.reduce path.firstChild path.secondChild path.thirdChild)
    Phi y hlocal hnot
  rw [context_plug_target path, context_plug_reduce retention path] at hcontext
  exact hcontext.symm

end Min3Path
end ELTree

end KL2003
end CollatzClassical
