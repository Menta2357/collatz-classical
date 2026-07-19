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

def comp {k : Nat} : Context k -> Context k -> Context k
  | .hole, inner => inner
  | .expanded label outer, inner => .expanded label (outer.comp inner)
  | .addLeft outer right, inner => .addLeft (outer.comp inner) right
  | .addRight left outer, inner => .addRight left (outer.comp inner)
  | .min2Left outer right, inner => .min2Left (outer.comp inner) right
  | .min2Right left outer, inner => .min2Right left (outer.comp inner)
  | .minFirst outer second third, inner =>
      .minFirst (outer.comp inner) second third
  | .minSecond first outer third, inner =>
      .minSecond first (outer.comp inner) third
  | .minThird first second outer, inner =>
      .minThird first second (outer.comp inner)

def expandedLabels {k : Nat} : Context k -> List (ELLabel k)
  | .hole => []
  | .expanded label context => label :: context.expandedLabels
  | .addLeft context _ | .addRight _ context => context.expandedLabels
  | .min2Left context _ | .min2Right _ context => context.expandedLabels
  | .minFirst context _ _ | .minSecond _ context _ |
      .minThird _ _ context => context.expandedLabels

def ContainsAdd {k : Nat} : Context k -> Prop
  | .hole => False
  | .expanded _ context => context.ContainsAdd
  | .addLeft _ _ | .addRight _ _ => True
  | .min2Left context _ | .min2Right _ context => context.ContainsAdd
  | .minFirst context _ _ | .minSecond _ context _ |
      .minThird _ _ context => context.ContainsAdd

theorem plug_comp {k : Nat} (outer inner : Context k) (tree : ELTree k) :
    (outer.comp inner).plug tree = outer.plug (inner.plug tree) := by
  induction outer <;> simp [comp, plug, *]

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

theorem holeCritical_comp_iff {k : Nat} (outer inner : Context k)
    (tree : ELTree k) (Phi : TrackedMode k -> Real -> Real) (y : Real) :
    (outer.comp inner).HoleCritical tree Phi y <->
      inner.HoleCritical tree Phi y /\
        outer.HoleCritical (inner.plug tree) Phi y := by
  induction outer <;>
    simp [comp, HoleCritical, plug, plug_comp, *, and_assoc, and_left_comm,
      and_comm]

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

theorem lift_criticalPath {k : Nat} (context : Context k)
    (tree : ELTree k) (target : ELLabel k)
    (assignment : ELExpr.CriticalAssignment tree.normalExpr)
    (path : ELExpr.CriticalAssignment.PathTo assignment target)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hassignment : assignment.IsCritical Phi y)
    (hcontext : context.HoleCritical tree Phi y) :
    exists globalAssignment : ELExpr.CriticalAssignment
        (context.plug tree).normalExpr,
      globalAssignment.IsCritical Phi y /\
        Nonempty (ELExpr.CriticalAssignment.PathTo globalAssignment target) := by
  induction context with
  | hole => exact ⟨assignment, hassignment, ⟨path⟩⟩
  | expanded label context ih =>
      simpa [plug, normalExpr] using ih hcontext
  | addLeft context right ih =>
      rcases ih hcontext with ⟨leftChoice, hleft, ⟨leftPath⟩⟩
      rcases ELExpr.CriticalAssignment.exists_isCritical
          right.normalExpr Phi y with ⟨rightChoice, hright⟩
      exact ⟨.add _ _ leftChoice rightChoice, ⟨hleft, hright⟩,
        ⟨.addLeft _ _ leftChoice rightChoice target leftPath⟩⟩
  | addRight left context ih =>
      rcases ih hcontext with ⟨rightChoice, hright, ⟨rightPath⟩⟩
      rcases ELExpr.CriticalAssignment.exists_isCritical
          left.normalExpr Phi y with ⟨leftChoice, hleft⟩
      exact ⟨.add _ _ leftChoice rightChoice, ⟨hleft, hright⟩,
        ⟨.addRight _ _ leftChoice rightChoice target rightPath⟩⟩
  | min2Left context right ih =>
      rcases ih hcontext.1 with ⟨choice, hchoice, ⟨subpath⟩⟩
      exact ⟨.minFirst _ _ _ choice,
        ⟨hchoice, hcontext.2, hcontext.2⟩,
        ⟨.minFirst _ _ _ choice target subpath⟩⟩
  | min2Right left context ih =>
      rcases ih hcontext.1 with ⟨choice, hchoice, ⟨subpath⟩⟩
      exact ⟨.minSecond _ _ _ choice,
        ⟨hchoice, hcontext.2, le_rfl⟩,
        ⟨.minSecond _ _ _ choice target subpath⟩⟩
  | minFirst context second third ih =>
      rcases ih hcontext.1 with ⟨choice, hchoice, ⟨subpath⟩⟩
      exact ⟨.minFirst _ _ _ choice,
        ⟨hchoice, hcontext.2⟩,
        ⟨.minFirst _ _ _ choice target subpath⟩⟩
  | minSecond first context third ih =>
      rcases ih hcontext.1 with ⟨choice, hchoice, ⟨subpath⟩⟩
      exact ⟨.minSecond _ _ _ choice,
        ⟨hchoice, hcontext.2⟩,
        ⟨.minSecond _ _ _ choice target subpath⟩⟩
  | minThird first second context ih =>
      rcases ih hcontext.1 with ⟨choice, hchoice, ⟨subpath⟩⟩
      exact ⟨.minThird _ _ _ choice,
        ⟨hchoice, hcontext.2⟩,
        ⟨.minThird _ _ _ choice target subpath⟩⟩

theorem lift_criticalPath_with_companion {k : Nat} (context : Context k)
    (tree : ELTree k) (target : ELLabel k)
    (assignment : ELExpr.CriticalAssignment tree.normalExpr)
    (path : ELExpr.CriticalAssignment.PathTo assignment target)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hassignment : assignment.IsCritical Phi y)
    (hcontext : context.HoleCritical tree Phi y)
    (hcompanion : path.companions ≠ [] \/ context.ContainsAdd) :
    exists globalAssignment : ELExpr.CriticalAssignment
        (context.plug tree).normalExpr,
      globalAssignment.IsCritical Phi y /\
        exists globalPath : ELExpr.CriticalAssignment.PathTo
            globalAssignment target,
          globalPath.companions ≠ [] := by
  induction context with
  | hole =>
      exact ⟨assignment, hassignment, path,
        hcompanion.resolve_right (by simp [ContainsAdd])⟩
  | expanded label context ih =>
      simpa [plug, normalExpr, ContainsAdd] using
        ih hcontext (by simpa [ContainsAdd] using hcompanion)
  | addLeft context right ih =>
      rcases context.lift_criticalPath tree target assignment path Phi y
          hassignment hcontext with ⟨leftChoice, hleft, ⟨leftPath⟩⟩
      rcases ELExpr.CriticalAssignment.exists_isCritical
          right.normalExpr Phi y with ⟨rightChoice, hright⟩
      refine ⟨.add _ _ leftChoice rightChoice, ⟨hleft, hright⟩,
        .addLeft _ _ leftChoice rightChoice target leftPath, ?_⟩
      simp [ELExpr.CriticalAssignment.PathTo.companions]
  | addRight left context ih =>
      rcases context.lift_criticalPath tree target assignment path Phi y
          hassignment hcontext with ⟨rightChoice, hright, ⟨rightPath⟩⟩
      rcases ELExpr.CriticalAssignment.exists_isCritical
          left.normalExpr Phi y with ⟨leftChoice, hleft⟩
      refine ⟨.add _ _ leftChoice rightChoice, ⟨hleft, hright⟩,
        .addRight _ _ leftChoice rightChoice target rightPath, ?_⟩
      simp [ELExpr.CriticalAssignment.PathTo.companions]
  | min2Left context right ih =>
      rcases ih hcontext.1 (by simpa [ContainsAdd] using hcompanion) with
        ⟨choice, hchoice, subpath, hnonempty⟩
      exact ⟨.minFirst _ _ _ choice,
        ⟨hchoice, hcontext.2, hcontext.2⟩,
        .minFirst _ _ _ choice target subpath, hnonempty⟩
  | min2Right left context ih =>
      rcases ih hcontext.1 (by simpa [ContainsAdd] using hcompanion) with
        ⟨choice, hchoice, subpath, hnonempty⟩
      exact ⟨.minSecond _ _ _ choice,
        ⟨hchoice, hcontext.2, le_rfl⟩,
        .minSecond _ _ _ choice target subpath, hnonempty⟩
  | minFirst context second third ih =>
      rcases ih hcontext.1 (by simpa [ContainsAdd] using hcompanion) with
        ⟨choice, hchoice, subpath, hnonempty⟩
      exact ⟨.minFirst _ _ _ choice, ⟨hchoice, hcontext.2⟩,
        .minFirst _ _ _ choice target subpath, hnonempty⟩
  | minSecond first context third ih =>
      rcases ih hcontext.1 (by simpa [ContainsAdd] using hcompanion) with
        ⟨choice, hchoice, subpath, hnonempty⟩
      exact ⟨.minSecond _ _ _ choice, ⟨hchoice, hcontext.2⟩,
        .minSecond _ _ _ choice target subpath, hnonempty⟩
  | minThird first second context ih =>
      rcases ih hcontext.1 (by simpa [ContainsAdd] using hcompanion) with
        ⟨choice, hchoice, subpath, hnonempty⟩
      exact ⟨.minThird _ _ _ choice, ⟨hchoice, hcontext.2⟩,
        .minThird _ _ _ choice target subpath, hnonempty⟩

def ExcludesCriticalLeaf {k : Nat} (context : Context k)
    (label : ELLabel k) (Phi : TrackedMode k -> Real -> Real)
    (y : Real) : Prop :=
  forall assignment : ELExpr.CriticalAssignment
      (context.plug (.terminal label)).normalExpr,
    assignment.IsCritical Phi y ->
      forall _path : ELExpr.CriticalAssignment.PathTo assignment label, False

theorem terminal_not_holeCritical_of_excludesCriticalLeaf {k : Nat}
    (context : Context k) (label : ELLabel k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hexcludes : context.ExcludesCriticalLeaf label Phi y) :
    ¬ context.HoleCritical (.terminal label) Phi y := by
  intro hcritical
  rcases context.lift_criticalPath (.terminal label) label (.leaf label)
      (.leaf label) Phi y trivial hcritical with
    ⟨assignment, hassignment, ⟨path⟩⟩
  exact hexcludes assignment hassignment path

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

def firstBranchContext {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) : ELTree.Context k :=
  path.context.comp (.minFirst .hole path.secondChild path.thirdChild)

def secondBranchContext {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) : ELTree.Context k :=
  path.context.comp (.minSecond path.firstChild .hole path.thirdChild)

def thirdBranchContext {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) : ELTree.Context k :=
  path.context.comp (.minThird path.firstChild path.secondChild .hole)

theorem firstBranch_holeCritical_iff {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (Phi : TrackedMode k -> Real -> Real) (y : Real) :
    path.firstBranchContext.HoleCritical path.firstChild Phi y <->
      path.context.HoleCritical path.target Phi y /\
        Min3Retention.criticalFirst
          (path.firstChild.normalExpr.eval Phi y)
          (path.secondChild.normalExpr.eval Phi y)
          (path.thirdChild.normalExpr.eval Phi y) := by
  simp [firstBranchContext, ELTree.Context.holeCritical_comp_iff,
    ELTree.Context.HoleCritical, ELTree.Context.plug, target, and_comm]

theorem secondBranch_holeCritical_iff {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (Phi : TrackedMode k -> Real -> Real) (y : Real) :
    path.secondBranchContext.HoleCritical path.secondChild Phi y <->
      path.context.HoleCritical path.target Phi y /\
        Min3Retention.criticalSecond
          (path.firstChild.normalExpr.eval Phi y)
          (path.secondChild.normalExpr.eval Phi y)
          (path.thirdChild.normalExpr.eval Phi y) := by
  simp [secondBranchContext, ELTree.Context.holeCritical_comp_iff,
    ELTree.Context.HoleCritical, ELTree.Context.plug, target, and_comm]

theorem thirdBranch_holeCritical_iff {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (Phi : TrackedMode k -> Real -> Real) (y : Real) :
    path.thirdBranchContext.HoleCritical path.thirdChild Phi y <->
      path.context.HoleCritical path.target Phi y /\
        Min3Retention.criticalThird
          (path.firstChild.normalExpr.eval Phi y)
          (path.secondChild.normalExpr.eval Phi y)
          (path.thirdChild.normalExpr.eval Phi y) := by
  simp [thirdBranchContext, ELTree.Context.holeCritical_comp_iff,
    ELTree.Context.HoleCritical, ELTree.Context.plug, target, and_comm]

def DeletedBranchesTotallyNoncritical {k : Nat} {tree : ELTree k}
    (retention : Min3Retention) (path : Min3Path tree)
    (Phi : TrackedMode k -> Real -> Real) (y : Real) : Prop :=
  match retention with
  | .keepAll => True
  | .keepFirstSecond =>
      ¬ path.thirdBranchContext.HoleCritical path.thirdChild Phi y
  | .keepFirstThird =>
      ¬ path.secondBranchContext.HoleCritical path.secondChild Phi y
  | .keepSecondThird =>
      ¬ path.firstBranchContext.HoleCritical path.firstChild Phi y
  | .keepFirst =>
      (¬ path.secondBranchContext.HoleCritical path.secondChild Phi y) /\
        (¬ path.thirdBranchContext.HoleCritical path.thirdChild Phi y)
  | .keepSecond =>
      (¬ path.firstBranchContext.HoleCritical path.firstChild Phi y) /\
        (¬ path.thirdBranchContext.HoleCritical path.thirdChild Phi y)
  | .keepThird =>
      (¬ path.firstBranchContext.HoleCritical path.firstChild Phi y) /\
        (¬ path.secondBranchContext.HoleCritical path.secondChild Phi y)

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

theorem reduceAt_normalExpr_eval_eq_of_deletedBranchesTotallyNoncritical
    {k : Nat} {tree : ELTree k} (retention : Min3Retention)
    (path : Min3Path tree) (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hsound : path.DeletedBranchesTotallyNoncritical retention Phi y) :
    (path.reduceAt retention).normalExpr.eval Phi y =
      tree.normalExpr.eval Phi y := by
  by_cases hparent : path.TotallyNoncritical Phi y
  · exact path.reduceAt_normalExpr_eval_eq_of_totallyNoncritical
      retention Phi y hparent
  · have hparentCritical : path.context.HoleCritical path.target Phi y :=
      Classical.not_not.mp hparent
    have hlocal : retention.DeletedBranchesNoncritical
        (path.firstChild.normalExpr.eval Phi y)
        (path.secondChild.normalExpr.eval Phi y)
        (path.thirdChild.normalExpr.eval Phi y) := by
      cases retention with
      | keepAll => trivial
      | keepFirstSecond =>
          intro hcritical
          exact hsound ((path.thirdBranch_holeCritical_iff Phi y).2
            ⟨hparentCritical, hcritical⟩)
      | keepFirstThird =>
          intro hcritical
          exact hsound ((path.secondBranch_holeCritical_iff Phi y).2
            ⟨hparentCritical, hcritical⟩)
      | keepSecondThird =>
          intro hcritical
          exact hsound ((path.firstBranch_holeCritical_iff Phi y).2
            ⟨hparentCritical, hcritical⟩)
      | keepFirst =>
          exact ⟨fun hcritical => hsound.1
              ((path.secondBranch_holeCritical_iff Phi y).2
                ⟨hparentCritical, hcritical⟩),
            fun hcritical => hsound.2
              ((path.thirdBranch_holeCritical_iff Phi y).2
                ⟨hparentCritical, hcritical⟩)⟩
      | keepSecond =>
          exact ⟨fun hcritical => hsound.1
              ((path.firstBranch_holeCritical_iff Phi y).2
                ⟨hparentCritical, hcritical⟩),
            fun hcritical => hsound.2
              ((path.thirdBranch_holeCritical_iff Phi y).2
                ⟨hparentCritical, hcritical⟩)⟩
      | keepThird =>
          exact ⟨fun hcritical => hsound.1
              ((path.firstBranch_holeCritical_iff Phi y).2
                ⟨hparentCritical, hcritical⟩),
            fun hcritical => hsound.2
              ((path.secondBranch_holeCritical_iff Phi y).2
                ⟨hparentCritical, hcritical⟩)⟩
    exact path.reduceAt_normalExpr_eval_eq retention Phi y hlocal

end Min3Path

namespace TerminalPath

def context {k : Nat} {tree : ELTree k} {target : ELLabel k} :
    (path : TerminalPath tree target) -> ELTree.Context k
  | .here _ => .hole
  | .expanded label _ _ subpath => .expanded label subpath.context
  | .addLeft _ right _ subpath => .addLeft subpath.context right
  | .addRight left _ _ subpath => .addRight left subpath.context
  | .min2Left _ right _ subpath => .min2Left subpath.context right
  | .min2Right left _ _ subpath => .min2Right left subpath.context
  | .minFirst _ second third _ subpath =>
      .minFirst subpath.context second third
  | .minSecond first _ third _ subpath =>
      .minSecond first subpath.context third
  | .minThird first second _ _ subpath =>
      .minThird first second subpath.context

theorem context_plug_target {k : Nat} {tree : ELTree k}
    {target : ELLabel k} (path : TerminalPath tree target) :
    path.context.plug (.terminal target) = tree := by
  induction path with
  | here => rfl
  | expanded label body target path ih =>
      simpa [context, ELTree.Context.plug] using
        congrArg (ELTree.expanded label) ih
  | addLeft left right target path ih =>
      simpa [context, ELTree.Context.plug] using
        congrArg (fun value => ELTree.add value right) ih
  | addRight left right target path ih =>
      simpa [context, ELTree.Context.plug] using
        congrArg (ELTree.add left) ih
  | min2Left left right target path ih =>
      simpa [context, ELTree.Context.plug] using
        congrArg (fun value => ELTree.min2 value right) ih
  | min2Right left right target path ih =>
      simpa [context, ELTree.Context.plug] using
        congrArg (ELTree.min2 left) ih
  | minFirst first second third target path ih =>
      simpa [context, ELTree.Context.plug] using
        congrArg (fun value => ELTree.min3 value second third) ih
  | minSecond first second third target path ih =>
      simpa [context, ELTree.Context.plug] using
        congrArg (fun value => ELTree.min3 first value third) ih
  | minThird first second third target path ih =>
      simpa [context, ELTree.Context.plug] using
        congrArg (ELTree.min3 first second) ih

def AddBelowEveryExpanded {k : Nat} {tree : ELTree k}
    {target : ELLabel k} : TerminalPath tree target -> Prop
  | .here _ => True
  | .expanded _ _ _ subpath =>
      subpath.context.ContainsAdd /\ subpath.AddBelowEveryExpanded
  | .addLeft _ _ _ subpath | .addRight _ _ _ subpath =>
      subpath.AddBelowEveryExpanded
  | .min2Left _ _ _ subpath | .min2Right _ _ _ subpath =>
      subpath.AddBelowEveryExpanded
  | .minFirst _ _ _ _ subpath | .minSecond _ _ _ _ subpath |
      .minThird _ _ _ _ subpath => subpath.AddBelowEveryExpanded

private theorem witness_ancestor_excludes_holeCritical {k : Nat}
    {tree : ELTree k} {target : ELLabel k}
    (path : TerminalPath tree target)
    {Phi : TrackedMode k -> Real -> Real} {y : Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    (hbounds : tree.NodeBounds Phi y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y)
    (hadd : path.AddBelowEveryExpanded)
    (hcritical : path.context.HoleCritical (.terminal target) Phi y)
    (htargetNonneg : 0 <= target.shift.eval)
    (ancestor : ELLabel k)
    (hmem : ancestor ∈ path.context.expandedLabels)
    (hmode : ancestor.mode = target.mode)
    (hshift : ancestor.shift.eval < target.shift.eval) : False := by
  induction path generalizing ancestor with
  | here label => simp [context, ELTree.Context.expandedLabels] at hmem
  | expanded label body target path ih =>
      simp only [context, ELTree.Context.expandedLabels, List.mem_cons] at hmem
      rcases hmem with heq | hmem
      · subst ancestor
        change path.context.HoleCritical (.terminal target) Phi y at hcritical
        rcases path.context.lift_criticalPath_with_companion
            (.terminal target) target (.leaf target) (.leaf target)
            Phi y trivial hcritical (Or.inr hadd.1) with
          ⟨assignment, hassignment, criticalPath, hnonempty⟩
        let leaf : ELLeafState k :=
          ⟨target, [label], .active⟩
        have hwitness : KL2003.HasDeletionWitness leaf := by
          refine ⟨htargetNonneg, label, ?_, hmode, hshift⟩
          simp [leaf]
        have hargs' : ELExpr.ArgumentsNonnegative y
            (path.context.plug (.terminal target)).normalExpr := by
          rw [path.context_plug_target]
          exact hargs
        apply deletionWitness_excludes_bounded_critical_path hpos hmono
          hwitness assignment hassignment criticalPath hargs' hnonempty
        intro candidate hcand _ _
        have hcandEq : candidate = label := by
          simpa [leaf] using hcand
        subst candidate
        have hbound :=
          expandedNode_normalExpr_eval_le_label label body Phi y hbounds
        rw [← path.context_plug_target] at hbound
        exact hbound
      · exact ih hbounds.1 hargs hadd.2 hcritical htargetNonneg
          ancestor hmem hmode hshift
  | addLeft left right target path ih =>
      exact ih hbounds.1 hargs.1 hadd hcritical htargetNonneg ancestor
        (by simpa [context, ELTree.Context.expandedLabels] using hmem)
        hmode hshift
  | addRight left right target path ih =>
      exact ih hbounds.2 hargs.2 hadd hcritical htargetNonneg ancestor
        (by simpa [context, ELTree.Context.expandedLabels] using hmem)
        hmode hshift
  | min2Left left right target path ih =>
      exact ih hbounds.1 hargs.1 hadd hcritical.1 htargetNonneg ancestor
        (by simpa [context, ELTree.Context.expandedLabels] using hmem)
        hmode hshift
  | min2Right left right target path ih =>
      exact ih hbounds.2 hargs.2.1 hadd hcritical.1 htargetNonneg ancestor
        (by simpa [context, ELTree.Context.expandedLabels] using hmem)
        hmode hshift
  | minFirst first second third target path ih =>
      exact ih hbounds.1 hargs.1 hadd hcritical.1 htargetNonneg ancestor
        (by simpa [context, ELTree.Context.expandedLabels] using hmem)
        hmode hshift
  | minSecond first second third target path ih =>
      exact ih hbounds.2.1 hargs.2.1 hadd hcritical.1 htargetNonneg ancestor
        (by simpa [context, ELTree.Context.expandedLabels] using hmem)
        hmode hshift
  | minThird first second third target path ih =>
      exact ih hbounds.2.2 hargs.2.2 hadd hcritical.1 htargetNonneg ancestor
        (by simpa [context, ELTree.Context.expandedLabels] using hmem)
        hmode hshift

def leafState {k : Nat} {tree : ELTree k} {target : ELLabel k}
    (path : TerminalPath tree target) : ELLeafState k where
  label := target
  ancestors := path.context.expandedLabels
  status := .active

def HasDeletionWitness {k : Nat} {tree : ELTree k} {target : ELLabel k}
    (path : TerminalPath tree target) : Prop :=
  KL2003.HasDeletionWitness path.leafState

theorem deletionWitness_implies_not_holeCritical {k : Nat}
    {tree : ELTree k} {target : ELLabel k}
    (path : TerminalPath tree target)
    {Phi : TrackedMode k -> Real -> Real} {y : Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    (hbounds : tree.NodeBounds Phi y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y)
    (hadd : path.AddBelowEveryExpanded)
    (hwitness : path.HasDeletionWitness) :
    ¬ path.context.HoleCritical (.terminal target) Phi y := by
  intro hcritical
  rcases hwitness.2 with ⟨ancestor, hmem, hmode, hshift⟩
  exact path.witness_ancestor_excludes_holeCritical hpos hmono hbounds
    hargs hadd hcritical hwitness.1 ancestor hmem hmode hshift

theorem not_holeCritical_of_excludesCriticalLeaf {k : Nat}
    {tree : ELTree k} {target : ELLabel k}
    (path : TerminalPath tree target)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hexcludes : path.context.ExcludesCriticalLeaf target Phi y) :
    ¬ path.context.HoleCritical (.terminal target) Phi y :=
  path.context.terminal_not_holeCritical_of_excludesCriticalLeaf
    target Phi y hexcludes

end TerminalPath
end ELTree

end KL2003
end CollatzClassical
