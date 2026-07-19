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

def AddBelowEveryExpanded {k : Nat} : Context k -> Prop
  | .hole => True
  | .expanded _ context =>
      context.ContainsAdd /\ context.AddBelowEveryExpanded
  | .addLeft context _ | .addRight _ context =>
      context.AddBelowEveryExpanded
  | .min2Left context _ | .min2Right _ context =>
      context.AddBelowEveryExpanded
  | .minFirst context _ _ | .minSecond _ context _ |
      .minThird _ _ context => context.AddBelowEveryExpanded

theorem containsAdd_comp_right {k : Nat} (outer inner : Context k)
    (hinner : inner.ContainsAdd) : (outer.comp inner).ContainsAdd := by
  induction outer <;> simp [comp, ContainsAdd, *, hinner]

theorem addBelowEveryExpanded_comp {k : Nat} (outer inner : Context k)
    (hcontains : inner.ContainsAdd) (hbelow : inner.AddBelowEveryExpanded) :
    (outer.comp inner).AddBelowEveryExpanded := by
  induction outer <;>
    simp [comp, AddBelowEveryExpanded, *, hcontains, hbelow,
      containsAdd_comp_right]

theorem plug_comp {k : Nat} (outer inner : Context k) (tree : ELTree k) :
    (outer.comp inner).plug tree = outer.plug (inner.plug tree) := by
  induction outer <;> simp [comp, plug, *]

theorem comp_assoc {k : Nat} (outer middle inner : Context k) :
    (outer.comp middle).comp inner = outer.comp (middle.comp inner) := by
  induction outer <;> simp [comp, *]

theorem comp_hole {k : Nat} (context : Context k) :
    context.comp .hole = context := by
  induction context <;> simp [comp, *]

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

def CriticalityEquivalentBelow {k : Nat} (oldContext newContext : Context k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real) : Prop :=
  forall inner tree,
    (oldContext.comp inner).HoleCritical tree Phi y <->
      (newContext.comp inner).HoleCritical tree Phi y

theorem holeCritical_comp_iff {k : Nat} (outer inner : Context k)
    (tree : ELTree k) (Phi : TrackedMode k -> Real -> Real) (y : Real) :
    (outer.comp inner).HoleCritical tree Phi y <->
      inner.HoleCritical tree Phi y /\
        outer.HoleCritical (inner.plug tree) Phi y := by
  induction outer <;>
    simp [comp, HoleCritical, plug, plug_comp, *, and_assoc, and_left_comm,
      and_comm]

def CriticalNodeBounds {k : Nat} (context : Context k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real) : ELTree k -> Prop
  | .terminal _ => True
  | .expanded label body =>
      (context.HoleCritical (.expanded label body) Phi y ->
        body.normalExpr.eval Phi y <=
          Phi label.mode (y + label.shift.eval)) /\
        CriticalNodeBounds (context.comp (.expanded label .hole)) Phi y body
  | .add left right =>
      CriticalNodeBounds (context.comp (.addLeft .hole right)) Phi y left /\
        CriticalNodeBounds (context.comp (.addRight left .hole)) Phi y right
  | .min2 left right =>
      CriticalNodeBounds (context.comp (.min2Left .hole right)) Phi y left /\
        CriticalNodeBounds (context.comp (.min2Right left .hole)) Phi y right
  | .min3 first second third =>
      CriticalNodeBounds
          (context.comp (.minFirst .hole second third)) Phi y first /\
        CriticalNodeBounds
          (context.comp (.minSecond first .hole third)) Phi y second /\
        CriticalNodeBounds
          (context.comp (.minThird first second .hole)) Phi y third

theorem criticalNodeBounds_congr {k : Nat} (oldContext newContext : Context k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (heq : oldContext.CriticalityEquivalentBelow newContext Phi y)
    (tree : ELTree k) (hbounds : oldContext.CriticalNodeBounds Phi y tree) :
    newContext.CriticalNodeBounds Phi y tree := by
  induction tree generalizing oldContext newContext with
  | terminal => trivial
  | expanded label body ih =>
      refine ⟨fun hcritical => hbounds.1 ?_, ?_⟩
      · have hiff := heq (.hole : Context k) (.expanded label body)
        rw [comp_hole, comp_hole] at hiff
        exact hiff.mpr hcritical
      · refine ih (oldContext.comp (.expanded label .hole))
          (newContext.comp (.expanded label .hole)) ?_ hbounds.2
        intro inner subtree
        simpa [comp_assoc] using
          heq (((.expanded label .hole) : Context k).comp inner) subtree
  | add left right ihLeft ihRight =>
      constructor
      · refine ihLeft (oldContext.comp (.addLeft .hole right))
          (newContext.comp (.addLeft .hole right)) ?_ hbounds.1
        intro inner subtree
        simpa [comp_assoc] using
          heq (((.addLeft .hole right) : Context k).comp inner) subtree
      · refine ihRight (oldContext.comp (.addRight left .hole))
          (newContext.comp (.addRight left .hole)) ?_ hbounds.2
        intro inner subtree
        simpa [comp_assoc] using
          heq (((.addRight left .hole) : Context k).comp inner) subtree
  | min2 left right ihLeft ihRight =>
      constructor
      · refine ihLeft (oldContext.comp (.min2Left .hole right))
          (newContext.comp (.min2Left .hole right)) ?_ hbounds.1
        intro inner subtree
        simpa [comp_assoc] using
          heq (((.min2Left .hole right) : Context k).comp inner) subtree
      · refine ihRight (oldContext.comp (.min2Right left .hole))
          (newContext.comp (.min2Right left .hole)) ?_ hbounds.2
        intro inner subtree
        simpa [comp_assoc] using
          heq (((.min2Right left .hole) : Context k).comp inner) subtree
  | min3 first second third ihFirst ihSecond ihThird =>
      refine ⟨?_, ?_, ?_⟩
      · refine ihFirst (oldContext.comp (.minFirst .hole second third))
          (newContext.comp (.minFirst .hole second third)) ?_ hbounds.1
        intro inner subtree
        simpa [comp_assoc] using
          heq (((.minFirst .hole second third) : Context k).comp inner) subtree
      · refine ihSecond (oldContext.comp (.minSecond first .hole third))
          (newContext.comp (.minSecond first .hole third)) ?_ hbounds.2.1
        intro inner subtree
        simpa [comp_assoc] using
          heq (((.minSecond first .hole third) : Context k).comp inner) subtree
      · refine ihThird (oldContext.comp (.minThird first second .hole))
          (newContext.comp (.minThird first second .hole)) ?_ hbounds.2.2
        intro inner subtree
        simpa [comp_assoc] using
          heq (((.minThird first second .hole) : Context k).comp inner) subtree

theorem criticalNodeBounds_of_nodeBounds {k : Nat} (context : Context k)
    (tree : ELTree k) (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hbounds : tree.NodeBounds Phi y) :
    context.CriticalNodeBounds Phi y tree := by
  induction tree generalizing context with
  | terminal => trivial
  | expanded label body ih =>
      exact ⟨fun _ => expandedNode_normalExpr_eval_le_label
        label body Phi y hbounds, ih _ hbounds.1⟩
  | add left right ihLeft ihRight =>
      exact ⟨ihLeft _ hbounds.1, ihRight _ hbounds.2⟩
  | min2 left right ihLeft ihRight =>
      exact ⟨ihLeft _ hbounds.1, ihRight _ hbounds.2⟩
  | min3 first second third ihFirst ihSecond ihThird =>
      exact ⟨ihFirst _ hbounds.1, ihSecond _ hbounds.2.1,
        ihThird _ hbounds.2.2⟩

theorem criticalAssignment_bound {k : Nat} (context : Context k)
    (label : ELLabel k) (body : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hbounds : context.CriticalNodeBounds Phi y (.expanded label body))
    (hcontext : context.HoleCritical (.expanded label body) Phi y)
    (assignment : ELExpr.CriticalAssignment body.normalExpr)
    (hcritical : assignment.IsCritical Phi y) :
    assignment.selectedExpr.eval Phi y <=
      Phi label.mode (y + label.shift.eval) := by
  rw [assignment.selectedExpr_eval_eq Phi y hcritical]
  exact hbounds.1 hcontext

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

theorem plug_normalExpr_eval_eq {k : Nat} (context : Context k)
    (oldTree newTree : ELTree k) (Phi : TrackedMode k -> Real -> Real)
    (y : Real)
    (heq : oldTree.normalExpr.eval Phi y = newTree.normalExpr.eval Phi y) :
    (context.plug oldTree).normalExpr.eval Phi y =
      (context.plug newTree).normalExpr.eval Phi y := by
  apply le_antisymm
  · exact context.plug_normalExpr_eval_mono oldTree newTree Phi y heq.le
  · exact context.plug_normalExpr_eval_mono newTree oldTree Phi y heq.ge

theorem holeCritical_congr {k : Nat} (context : Context k)
    (oldTree newTree : ELTree k) (Phi : TrackedMode k -> Real -> Real)
    (y : Real)
    (heq : oldTree.normalExpr.eval Phi y = newTree.normalExpr.eval Phi y) :
    context.HoleCritical oldTree Phi y <->
      context.HoleCritical newTree Phi y := by
  induction context with
  | hole => rfl
  | expanded label context ih => simpa [HoleCritical] using ih
  | addLeft context right ih => simpa [HoleCritical] using ih
  | addRight left context ih => simpa [HoleCritical] using ih
  | min2Left context right ih =>
      have hplug := context.plug_normalExpr_eval_eq oldTree newTree Phi y heq
      simp only [HoleCritical]
      rw [ih, hplug]
  | min2Right left context ih =>
      have hplug := context.plug_normalExpr_eval_eq oldTree newTree Phi y heq
      simp only [HoleCritical]
      rw [ih, hplug]
  | minFirst context second third ih =>
      have hplug := context.plug_normalExpr_eval_eq oldTree newTree Phi y heq
      simp only [HoleCritical, Min3Retention.criticalFirst]
      rw [ih, hplug]
  | minSecond first context third ih =>
      have hplug := context.plug_normalExpr_eval_eq oldTree newTree Phi y heq
      simp only [HoleCritical, Min3Retention.criticalSecond]
      rw [ih, hplug]
  | minThird first second context ih =>
      have hplug := context.plug_normalExpr_eval_eq oldTree newTree Phi y heq
      simp only [HoleCritical, Min3Retention.criticalThird]
      rw [ih, hplug]

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

def CriticalNodeBounds {k : Nat} (tree : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real) : Prop :=
  (Context.hole : Context k).CriticalNodeBounds Phi y tree

theorem criticalNodeBounds_of_nodeBounds {k : Nat} (tree : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hbounds : tree.NodeBounds Phi y) : tree.CriticalNodeBounds Phi y :=
  Context.criticalNodeBounds_of_nodeBounds .hole tree Phi y hbounds

theorem sourceSplitTree_criticalNodeBounds {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    (label : ELLabel (p + 1)) {y : Real}
    (hy : 2 <= y + label.shift.eval) :
    (sourceSplitTree hp label).CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y :=
  criticalNodeBounds_of_nodeBounds _ _ _
    (sourceSplitTree_nodeBounds hp roots label hy)

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

def advancedSplitTree {k : Nat}
    (root retarded first second third : ELLabel k) : ELTree k :=
  .expanded root
    (.add (.terminal retarded)
      (.min3 (.terminal first) (.terminal second) (.terminal third)))

def retardedSplitLabel {p : Nat} (label : ELLabel (p + 1)) :
    ELLabel (p + 1) :=
  ⟨fourTrackedMode (by omega) label.mode,
    label.shift + SymbolicShift.retardedTwo⟩

def d1AdvancedSplitLabel {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 2)
    (j : Fin 3) : ELLabel (p + 1) :=
  ⟨liftTrackedMode hp (d1LowerTrackedMode hp label.mode hm) j,
    label.shift + SymbolicShift.d1Advanced⟩

def d3AdvancedSplitLabel {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 8)
    (j : Fin 3) : ELLabel (p + 1) :=
  ⟨liftTrackedMode hp (d3LowerTrackedMode hp label.mode hm) j,
    label.shift + SymbolicShift.d3Advanced⟩

theorem sourceSplitTree_eq_advanced_d1 {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 2) :
    sourceSplitTree hp label =
      advancedSplitTree label (retardedSplitLabel label)
        (d1AdvancedSplitLabel hp label hm 0)
        (d1AdvancedSplitLabel hp label hm 1)
        (d1AdvancedSplitLabel hp label hm 2) := by
  simp [sourceSplitTree, splitTopExpr, hm, d1TopExpr, ELExpr.shiftBy,
    elLeaf, ofExpr, advancedSplitTree, retardedSplitLabel,
    d1AdvancedSplitLabel]

theorem sourceSplitTree_eq_advanced_d3 {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 8) :
    sourceSplitTree hp label =
      advancedSplitTree label (retardedSplitLabel label)
        (d3AdvancedSplitLabel hp label hm 0)
        (d3AdvancedSplitLabel hp label hm 1)
        (d3AdvancedSplitLabel hp label hm 2) := by
  have hnot2 : ¬ label.mode.1.1 % 9 = 2 := by omega
  have hnot5 : ¬ label.mode.1.1 % 9 = 5 := by omega
  simp [sourceSplitTree, splitTopExpr, hnot2, hnot5, d3TopExpr,
    ELExpr.shiftBy, elLeaf, ofExpr, advancedSplitTree, retardedSplitLabel,
    d3AdvancedSplitLabel]

namespace TerminalPath

def advancedMinPath {k : Nat}
    (root retarded first second third : ELLabel k) :
    Min3Path (advancedSplitTree root retarded first second third) :=
  .expanded root _
    (.addRight (.terminal retarded) _
      (.here (.terminal first) (.terminal second) (.terminal third)))

def advancedFirstPath {k : Nat}
    (root retarded first second third : ELLabel k) :
    TerminalPath (advancedSplitTree root retarded first second third) first :=
  .expanded root _ first
    (.addRight (.terminal retarded) _ first
      (.minFirst (.terminal first) (.terminal second) (.terminal third) first
        (.here first)))

def advancedSecondPath {k : Nat}
    (root retarded first second third : ELLabel k) :
    TerminalPath (advancedSplitTree root retarded first second third) second :=
  .expanded root _ second
    (.addRight (.terminal retarded) _ second
      (.minSecond (.terminal first) (.terminal second) (.terminal third) second
        (.here second)))

def advancedThirdPath {k : Nat}
    (root retarded first second third : ELLabel k) :
    TerminalPath (advancedSplitTree root retarded first second third) third :=
  .expanded root _ third
    (.addRight (.terminal retarded) _ third
      (.minThird (.terminal first) (.terminal second) (.terminal third) third
        (.here third)))

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

theorem advancedMinPath_firstBranchContext_eq {k : Nat}
    (root retarded first second third : ELLabel k) :
    (advancedMinPath root retarded first second third).firstBranchContext =
      (advancedFirstPath root retarded first second third).context := by
  rfl

theorem advancedMinPath_secondBranchContext_eq {k : Nat}
    (root retarded first second third : ELLabel k) :
    (advancedMinPath root retarded first second third).secondBranchContext =
      (advancedSecondPath root retarded first second third).context := by
  rfl

theorem advancedMinPath_thirdBranchContext_eq {k : Nat}
    (root retarded first second third : ELLabel k) :
    (advancedMinPath root retarded first second third).thirdBranchContext =
      (advancedThirdPath root retarded first second third).context := by
  rfl

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
  | path => path.context.AddBelowEveryExpanded

theorem advancedFirstPath_containsAdd {k : Nat}
    (root retarded first second third : ELLabel k) :
    (advancedFirstPath root retarded first second third).context.ContainsAdd := by
  simp [advancedFirstPath, context, ELTree.Context.ContainsAdd]

theorem advancedSecondPath_containsAdd {k : Nat}
    (root retarded first second third : ELLabel k) :
    (advancedSecondPath root retarded first second third).context.ContainsAdd := by
  simp [advancedSecondPath, context, ELTree.Context.ContainsAdd]

theorem advancedThirdPath_containsAdd {k : Nat}
    (root retarded first second third : ELLabel k) :
    (advancedThirdPath root retarded first second third).context.ContainsAdd := by
  simp [advancedThirdPath, context, ELTree.Context.ContainsAdd]

theorem advancedFirstPath_addBelowEveryExpanded {k : Nat}
    (root retarded first second third : ELLabel k) :
    (advancedFirstPath root retarded first second third).AddBelowEveryExpanded := by
  simp [AddBelowEveryExpanded, advancedFirstPath, context,
    ELTree.Context.AddBelowEveryExpanded, ELTree.Context.ContainsAdd]

theorem advancedSecondPath_addBelowEveryExpanded {k : Nat}
    (root retarded first second third : ELLabel k) :
    (advancedSecondPath root retarded first second third).AddBelowEveryExpanded := by
  simp [AddBelowEveryExpanded, advancedSecondPath, context,
    ELTree.Context.AddBelowEveryExpanded, ELTree.Context.ContainsAdd]

theorem advancedThirdPath_addBelowEveryExpanded {k : Nat}
    (root retarded first second third : ELLabel k) :
    (advancedThirdPath root retarded first second third).AddBelowEveryExpanded := by
  simp [AddBelowEveryExpanded, advancedThirdPath, context,
    ELTree.Context.AddBelowEveryExpanded, ELTree.Context.ContainsAdd]

structure AdvancedMinConfiguration {k : Nat} (tree : ELTree k)
    (first second third : ELLabel k) where
  minPath : Min3Path tree
  firstPath : TerminalPath tree first
  secondPath : TerminalPath tree second
  thirdPath : TerminalPath tree third
  firstChild_eq : minPath.firstChild = .terminal first
  secondChild_eq : minPath.secondChild = .terminal second
  thirdChild_eq : minPath.thirdChild = .terminal third
  firstContext_eq : minPath.firstBranchContext = firstPath.context
  secondContext_eq : minPath.secondBranchContext = secondPath.context
  thirdContext_eq : minPath.thirdBranchContext = thirdPath.context
  firstContainsAdd : firstPath.context.ContainsAdd
  secondContainsAdd : secondPath.context.ContainsAdd
  thirdContainsAdd : thirdPath.context.ContainsAdd
  firstAddBelow : firstPath.AddBelowEveryExpanded
  secondAddBelow : secondPath.AddBelowEveryExpanded
  thirdAddBelow : thirdPath.AddBelowEveryExpanded

def advancedMinConfiguration {k : Nat}
    (root retarded first second third : ELLabel k) :
    AdvancedMinConfiguration
      (advancedSplitTree root retarded first second third)
      first second third where
  minPath := advancedMinPath root retarded first second third
  firstPath := advancedFirstPath root retarded first second third
  secondPath := advancedSecondPath root retarded first second third
  thirdPath := advancedThirdPath root retarded first second third
  firstChild_eq := rfl
  secondChild_eq := rfl
  thirdChild_eq := rfl
  firstContext_eq := advancedMinPath_firstBranchContext_eq _ _ _ _ _
  secondContext_eq := advancedMinPath_secondBranchContext_eq _ _ _ _ _
  thirdContext_eq := advancedMinPath_thirdBranchContext_eq _ _ _ _ _
  firstContainsAdd := advancedFirstPath_containsAdd _ _ _ _ _
  secondContainsAdd := advancedSecondPath_containsAdd _ _ _ _ _
  thirdContainsAdd := advancedThirdPath_containsAdd _ _ _ _ _
  firstAddBelow := advancedFirstPath_addBelowEveryExpanded _ _ _ _ _
  secondAddBelow := advancedSecondPath_addBelowEveryExpanded _ _ _ _ _
  thirdAddBelow := advancedThirdPath_addBelowEveryExpanded _ _ _ _ _

theorem sourceD1AdvancedConfiguration {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 2) :
    Nonempty (AdvancedMinConfiguration (sourceSplitTree hp label)
      (d1AdvancedSplitLabel hp label hm 0)
      (d1AdvancedSplitLabel hp label hm 1)
      (d1AdvancedSplitLabel hp label hm 2)) := by
  rw [sourceSplitTree_eq_advanced_d1 hp label hm]
  exact ⟨advancedMinConfiguration _ _ _ _ _⟩

theorem sourceD3AdvancedConfiguration {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 8) :
    Nonempty (AdvancedMinConfiguration (sourceSplitTree hp label)
      (d3AdvancedSplitLabel hp label hm 0)
      (d3AdvancedSplitLabel hp label hm 1)
      (d3AdvancedSplitLabel hp label hm 2)) := by
  rw [sourceSplitTree_eq_advanced_d3 hp label hm]
  exact ⟨advancedMinConfiguration _ _ _ _ _⟩

theorem exists_sourceD1AdvancedPath {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 2)
    (j : Fin 3) :
    exists path : TerminalPath (sourceSplitTree hp label)
        (d1AdvancedSplitLabel hp label hm j),
      path.context.ContainsAdd /\ path.AddBelowEveryExpanded := by
  fin_cases j
  · rw [sourceSplitTree_eq_advanced_d1 hp label hm]
    exact ⟨advancedFirstPath _ _ _ _ _,
      advancedFirstPath_containsAdd _ _ _ _ _,
      advancedFirstPath_addBelowEveryExpanded _ _ _ _ _⟩
  · rw [sourceSplitTree_eq_advanced_d1 hp label hm]
    exact ⟨advancedSecondPath _ _ _ _ _,
      advancedSecondPath_containsAdd _ _ _ _ _,
      advancedSecondPath_addBelowEveryExpanded _ _ _ _ _⟩
  · rw [sourceSplitTree_eq_advanced_d1 hp label hm]
    exact ⟨advancedThirdPath _ _ _ _ _,
      advancedThirdPath_containsAdd _ _ _ _ _,
      advancedThirdPath_addBelowEveryExpanded _ _ _ _ _⟩

theorem exists_sourceD3AdvancedPath {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 8)
    (j : Fin 3) :
    exists path : TerminalPath (sourceSplitTree hp label)
        (d3AdvancedSplitLabel hp label hm j),
      path.context.ContainsAdd /\ path.AddBelowEveryExpanded := by
  fin_cases j
  · rw [sourceSplitTree_eq_advanced_d3 hp label hm]
    exact ⟨advancedFirstPath _ _ _ _ _,
      advancedFirstPath_containsAdd _ _ _ _ _,
      advancedFirstPath_addBelowEveryExpanded _ _ _ _ _⟩
  · rw [sourceSplitTree_eq_advanced_d3 hp label hm]
    exact ⟨advancedSecondPath _ _ _ _ _,
      advancedSecondPath_containsAdd _ _ _ _ _,
      advancedSecondPath_addBelowEveryExpanded _ _ _ _ _⟩
  · rw [sourceSplitTree_eq_advanced_d3 hp label hm]
    exact ⟨advancedThirdPath _ _ _ _ _,
      advancedThirdPath_containsAdd _ _ _ _ _,
      advancedThirdPath_addBelowEveryExpanded _ _ _ _ _⟩

def descendSplit {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target leaf : ELLabel (p + 1)}
    (outer : TerminalPath tree target)
    (inner : TerminalPath (sourceSplitTree hp target) leaf) :
    TerminalPath (outer.splitAt hp) leaf :=
  match outer with
  | .here _ => inner
  | .expanded label _ _ subpath =>
      .expanded label _ leaf (subpath.descendSplit hp inner)
  | .addLeft _ right _ subpath =>
      .addLeft _ right leaf (subpath.descendSplit hp inner)
  | .addRight left _ _ subpath =>
      .addRight left _ leaf (subpath.descendSplit hp inner)
  | .min2Left _ right _ subpath =>
      .min2Left _ right leaf (subpath.descendSplit hp inner)
  | .min2Right left _ _ subpath =>
      .min2Right left _ leaf (subpath.descendSplit hp inner)
  | .minFirst _ second third _ subpath =>
      .minFirst _ second third leaf (subpath.descendSplit hp inner)
  | .minSecond first _ third _ subpath =>
      .minSecond first _ third leaf (subpath.descendSplit hp inner)
  | .minThird first second _ _ subpath =>
      .minThird first second _ leaf (subpath.descendSplit hp inner)

def descendSplitMin3 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (outer : TerminalPath tree target)
    (inner : Min3Path (sourceSplitTree hp target)) :
    Min3Path (outer.splitAt hp) :=
  match outer with
  | .here _ => inner
  | .expanded label _ _ subpath =>
      .expanded label _ (subpath.descendSplitMin3 hp inner)
  | .addLeft _ right _ subpath =>
      .addLeft _ right (subpath.descendSplitMin3 hp inner)
  | .addRight left _ _ subpath =>
      .addRight left _ (subpath.descendSplitMin3 hp inner)
  | .min2Left _ right _ subpath =>
      .min2Left _ right (subpath.descendSplitMin3 hp inner)
  | .min2Right left _ _ subpath =>
      .min2Right left _ (subpath.descendSplitMin3 hp inner)
  | .minFirst _ second third _ subpath =>
      .minFirst _ second third (subpath.descendSplitMin3 hp inner)
  | .minSecond first _ third _ subpath =>
      .minSecond first _ third (subpath.descendSplitMin3 hp inner)
  | .minThird first second _ _ subpath =>
      .minThird first second _ (subpath.descendSplitMin3 hp inner)

theorem context_descendSplit {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target leaf : ELLabel (p + 1)}
    (outer : TerminalPath tree target)
    (inner : TerminalPath (sourceSplitTree hp target) leaf) :
    (outer.descendSplit hp inner).context = outer.context.comp inner.context := by
  induction outer <;>
    simp [descendSplit, context, ELTree.Context.comp, *]

theorem context_descendSplitMin3 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (outer : TerminalPath tree target)
    (inner : Min3Path (sourceSplitTree hp target)) :
    (outer.descendSplitMin3 hp inner).context =
      outer.context.comp inner.context := by
  induction outer <;>
    simp [descendSplitMin3, context, Min3Path.context,
      ELTree.Context.comp, *]

theorem firstChild_descendSplitMin3 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (outer : TerminalPath tree target)
    (inner : Min3Path (sourceSplitTree hp target)) :
    (outer.descendSplitMin3 hp inner).firstChild = inner.firstChild := by
  induction outer <;> simp [descendSplitMin3, Min3Path.firstChild, *]

theorem secondChild_descendSplitMin3 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (outer : TerminalPath tree target)
    (inner : Min3Path (sourceSplitTree hp target)) :
    (outer.descendSplitMin3 hp inner).secondChild = inner.secondChild := by
  induction outer <;> simp [descendSplitMin3, Min3Path.secondChild, *]

theorem thirdChild_descendSplitMin3 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (outer : TerminalPath tree target)
    (inner : Min3Path (sourceSplitTree hp target)) :
    (outer.descendSplitMin3 hp inner).thirdChild = inner.thirdChild := by
  induction outer <;> simp [descendSplitMin3, Min3Path.thirdChild, *]

theorem firstBranchContext_descendSplitMin3 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target leaf : ELLabel (p + 1)}
    (outer : TerminalPath tree target)
    (innerMin : Min3Path (sourceSplitTree hp target))
    (innerLeaf : TerminalPath (sourceSplitTree hp target) leaf)
    (heq : innerMin.firstBranchContext = innerLeaf.context) :
    (outer.descendSplitMin3 hp innerMin).firstBranchContext =
      (outer.descendSplit hp innerLeaf).context := by
  rw [Min3Path.firstBranchContext, context_descendSplitMin3,
    context_descendSplit, secondChild_descendSplitMin3,
    thirdChild_descendSplitMin3,
    ELTree.Context.comp_assoc]
  change outer.context.comp innerMin.firstBranchContext =
    outer.context.comp innerLeaf.context
  rw [heq]

theorem secondBranchContext_descendSplitMin3 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target leaf : ELLabel (p + 1)}
    (outer : TerminalPath tree target)
    (innerMin : Min3Path (sourceSplitTree hp target))
    (innerLeaf : TerminalPath (sourceSplitTree hp target) leaf)
    (heq : innerMin.secondBranchContext = innerLeaf.context) :
    (outer.descendSplitMin3 hp innerMin).secondBranchContext =
      (outer.descendSplit hp innerLeaf).context := by
  rw [Min3Path.secondBranchContext, context_descendSplitMin3,
    context_descendSplit, firstChild_descendSplitMin3,
    thirdChild_descendSplitMin3,
    ELTree.Context.comp_assoc]
  change outer.context.comp innerMin.secondBranchContext =
    outer.context.comp innerLeaf.context
  rw [heq]

theorem thirdBranchContext_descendSplitMin3 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target leaf : ELLabel (p + 1)}
    (outer : TerminalPath tree target)
    (innerMin : Min3Path (sourceSplitTree hp target))
    (innerLeaf : TerminalPath (sourceSplitTree hp target) leaf)
    (heq : innerMin.thirdBranchContext = innerLeaf.context) :
    (outer.descendSplitMin3 hp innerMin).thirdBranchContext =
      (outer.descendSplit hp innerLeaf).context := by
  rw [Min3Path.thirdBranchContext, context_descendSplitMin3,
    context_descendSplit, firstChild_descendSplitMin3,
    secondChild_descendSplitMin3,
    ELTree.Context.comp_assoc]
  change outer.context.comp innerMin.thirdBranchContext =
    outer.context.comp innerLeaf.context
  rw [heq]

theorem descendSplit_addBelowEveryExpanded {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target leaf : ELLabel (p + 1)}
    (outer : TerminalPath tree target)
    (inner : TerminalPath (sourceSplitTree hp target) leaf)
    (hcontains : inner.context.ContainsAdd)
    (hbelow : inner.AddBelowEveryExpanded) :
    (outer.descendSplit hp inner).AddBelowEveryExpanded := by
  change (outer.descendSplit hp inner).context.AddBelowEveryExpanded
  rw [context_descendSplit]
  exact outer.context.addBelowEveryExpanded_comp inner.context hcontains hbelow

def leafState {k : Nat} {tree : ELTree k} {target : ELLabel k}
    (path : TerminalPath tree target) : ELLeafState k where
  label := target
  ancestors := path.context.expandedLabels
  status := .active

def HasDeletionWitness {k : Nat} {tree : ELTree k} {target : ELLabel k}
    (path : TerminalPath tree target) : Prop :=
  KL2003.HasDeletionWitness path.leafState

namespace AdvancedMinConfiguration

def descendSplit {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target first second third : ELLabel (p + 1)}
    (configuration : AdvancedMinConfiguration
      (sourceSplitTree hp target) first second third)
    (outer : TerminalPath tree target) :
    AdvancedMinConfiguration (outer.splitAt hp) first second third where
  minPath := outer.descendSplitMin3 hp configuration.minPath
  firstPath := outer.descendSplit hp configuration.firstPath
  secondPath := outer.descendSplit hp configuration.secondPath
  thirdPath := outer.descendSplit hp configuration.thirdPath
  firstChild_eq := (firstChild_descendSplitMin3 hp outer _).trans
    configuration.firstChild_eq
  secondChild_eq := (secondChild_descendSplitMin3 hp outer _).trans
    configuration.secondChild_eq
  thirdChild_eq := (thirdChild_descendSplitMin3 hp outer _).trans
    configuration.thirdChild_eq
  firstContext_eq := firstBranchContext_descendSplitMin3 hp outer
    configuration.minPath configuration.firstPath configuration.firstContext_eq
  secondContext_eq := secondBranchContext_descendSplitMin3 hp outer
    configuration.minPath configuration.secondPath
      configuration.secondContext_eq
  thirdContext_eq := thirdBranchContext_descendSplitMin3 hp outer
    configuration.minPath configuration.thirdPath configuration.thirdContext_eq
  firstContainsAdd := by
    rw [context_descendSplit]
    exact outer.context.containsAdd_comp_right _ configuration.firstContainsAdd
  secondContainsAdd := by
    rw [context_descendSplit]
    exact outer.context.containsAdd_comp_right _ configuration.secondContainsAdd
  thirdContainsAdd := by
    rw [context_descendSplit]
    exact outer.context.containsAdd_comp_right _ configuration.thirdContainsAdd
  firstAddBelow := descendSplit_addBelowEveryExpanded hp outer
    configuration.firstPath configuration.firstContainsAdd
      configuration.firstAddBelow
  secondAddBelow := descendSplit_addBelowEveryExpanded hp outer
    configuration.secondPath configuration.secondContainsAdd
      configuration.secondAddBelow
  thirdAddBelow := descendSplit_addBelowEveryExpanded hp outer
    configuration.thirdPath configuration.thirdContainsAdd
      configuration.thirdAddBelow

def DeletedBranchesHaveWitness {k : Nat} {tree : ELTree k}
    {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    (retention : Min3Retention) : Prop :=
  match retention with
  | .keepAll => True
  | .keepFirstSecond => configuration.thirdPath.HasDeletionWitness
  | .keepFirstThird => configuration.secondPath.HasDeletionWitness
  | .keepSecondThird => configuration.firstPath.HasDeletionWitness
  | .keepFirst =>
      configuration.secondPath.HasDeletionWitness /\
        configuration.thirdPath.HasDeletionWitness
  | .keepSecond =>
      configuration.firstPath.HasDeletionWitness /\
        configuration.thirdPath.HasDeletionWitness
  | .keepThird =>
      configuration.firstPath.HasDeletionWitness /\
        configuration.secondPath.HasDeletionWitness

noncomputable def witnessCount {k : Nat} {tree : ELTree k}
    {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third) : Nat := by
  classical
  exact (if configuration.firstPath.HasDeletionWitness then 1 else 0) +
    (if configuration.secondPath.HasDeletionWitness then 1 else 0) +
      (if configuration.thirdPath.HasDeletionWitness then 1 else 0)

noncomputable def witnessRetention {k : Nat} {tree : ELTree k}
    {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third) :
    Min3Retention := by
  classical
  exact if configuration.firstPath.HasDeletionWitness then
    if configuration.secondPath.HasDeletionWitness then
      if configuration.thirdPath.HasDeletionWitness then
        .keepFirst
      else
        .keepThird
    else if configuration.thirdPath.HasDeletionWitness then
      .keepSecond
    else
      .keepSecondThird
  else if configuration.secondPath.HasDeletionWitness then
    if configuration.thirdPath.HasDeletionWitness then
      .keepFirst
    else
      .keepFirstThird
  else if configuration.thirdPath.HasDeletionWitness then
    .keepFirstSecond
  else
    .keepAll

theorem witnessRetention_deletedBranchesHaveWitness {k : Nat}
    {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third) :
    configuration.DeletedBranchesHaveWitness
      configuration.witnessRetention := by
  classical
  by_cases hfirst : configuration.firstPath.HasDeletionWitness <;>
    by_cases hsecond : configuration.secondPath.HasDeletionWitness <;>
      by_cases hthird : configuration.thirdPath.HasDeletionWitness <;>
        simp [witnessRetention, DeletedBranchesHaveWitness, hfirst, hsecond,
          hthird]

theorem witnessRetention_retainedCount {k : Nat} {tree : ELTree k}
    {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third) :
    configuration.witnessRetention.retainedCount =
      3 - Nat.min 2 configuration.witnessCount := by
  classical
  by_cases hfirst : configuration.firstPath.HasDeletionWitness <;>
    by_cases hsecond : configuration.secondPath.HasDeletionWitness <;>
      by_cases hthird : configuration.thirdPath.HasDeletionWitness <;>
        simp [witnessRetention, witnessCount, Min3Retention.retainedCount,
          hfirst, hsecond, hthird]

end AdvancedMinConfiguration

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
      change path.context.ContainsAdd /\ path.AddBelowEveryExpanded at hadd
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
      change path.AddBelowEveryExpanded at hadd
      exact ih hbounds.1 hargs.1 hadd hcritical htargetNonneg ancestor
        (by simpa [context, ELTree.Context.expandedLabels] using hmem)
        hmode hshift
  | addRight left right target path ih =>
      change path.AddBelowEveryExpanded at hadd
      exact ih hbounds.2 hargs.2 hadd hcritical htargetNonneg ancestor
        (by simpa [context, ELTree.Context.expandedLabels] using hmem)
        hmode hshift
  | min2Left left right target path ih =>
      change path.AddBelowEveryExpanded at hadd
      exact ih hbounds.1 hargs.1 hadd hcritical.1 htargetNonneg ancestor
        (by simpa [context, ELTree.Context.expandedLabels] using hmem)
        hmode hshift
  | min2Right left right target path ih =>
      change path.AddBelowEveryExpanded at hadd
      exact ih hbounds.2 hargs.2.1 hadd hcritical.1 htargetNonneg ancestor
        (by simpa [context, ELTree.Context.expandedLabels] using hmem)
        hmode hshift
  | minFirst first second third target path ih =>
      change path.AddBelowEveryExpanded at hadd
      exact ih hbounds.1 hargs.1 hadd hcritical.1 htargetNonneg ancestor
        (by simpa [context, ELTree.Context.expandedLabels] using hmem)
        hmode hshift
  | minSecond first second third target path ih =>
      change path.AddBelowEveryExpanded at hadd
      exact ih hbounds.2.1 hargs.2.1 hadd hcritical.1 htargetNonneg ancestor
        (by simpa [context, ELTree.Context.expandedLabels] using hmem)
        hmode hshift
  | minThird first second third target path ih =>
      change path.AddBelowEveryExpanded at hadd
      exact ih hbounds.2.2 hargs.2.2 hadd hcritical.1 htargetNonneg ancestor
        (by simpa [context, ELTree.Context.expandedLabels] using hmem)
        hmode hshift

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

namespace AdvancedMinConfiguration

theorem deletedBranchesTotallyNoncritical_of_witnesses {k : Nat}
    {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    (retention : Min3Retention)
    {Phi : TrackedMode k -> Real -> Real} {y : Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    (hbounds : tree.NodeBounds Phi y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y)
    (hwitness : configuration.DeletedBranchesHaveWitness retention) :
    configuration.minPath.DeletedBranchesTotallyNoncritical
      retention Phi y := by
  have hfirst (hw : configuration.firstPath.HasDeletionWitness) :
      ¬ configuration.minPath.firstBranchContext.HoleCritical
        configuration.minPath.firstChild Phi y := by
    rw [configuration.firstContext_eq, configuration.firstChild_eq]
    exact configuration.firstPath.deletionWitness_implies_not_holeCritical
      hpos hmono hbounds hargs configuration.firstAddBelow hw
  have hsecond (hw : configuration.secondPath.HasDeletionWitness) :
      ¬ configuration.minPath.secondBranchContext.HoleCritical
        configuration.minPath.secondChild Phi y := by
    rw [configuration.secondContext_eq, configuration.secondChild_eq]
    exact configuration.secondPath.deletionWitness_implies_not_holeCritical
      hpos hmono hbounds hargs configuration.secondAddBelow hw
  have hthird (hw : configuration.thirdPath.HasDeletionWitness) :
      ¬ configuration.minPath.thirdBranchContext.HoleCritical
        configuration.minPath.thirdChild Phi y := by
    rw [configuration.thirdContext_eq, configuration.thirdChild_eq]
    exact configuration.thirdPath.deletionWitness_implies_not_holeCritical
      hpos hmono hbounds hargs configuration.thirdAddBelow hw
  cases retention with
  | keepAll => trivial
  | keepFirstSecond => exact hthird hwitness
  | keepFirstThird => exact hsecond hwitness
  | keepSecondThird => exact hfirst hwitness
  | keepFirst => exact ⟨hsecond hwitness.1, hthird hwitness.2⟩
  | keepSecond => exact ⟨hfirst hwitness.1, hthird hwitness.2⟩
  | keepThird => exact ⟨hfirst hwitness.1, hsecond hwitness.2⟩

theorem reduceAt_normalExpr_eval_eq_of_witnesses {k : Nat}
    {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    (retention : Min3Retention)
    {Phi : TrackedMode k -> Real -> Real} {y : Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    (hbounds : tree.NodeBounds Phi y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y)
    (hwitness : configuration.DeletedBranchesHaveWitness retention) :
    (configuration.minPath.reduceAt retention).normalExpr.eval Phi y =
      tree.normalExpr.eval Phi y :=
  configuration.minPath
    |>.reduceAt_normalExpr_eval_eq_of_deletedBranchesTotallyNoncritical
      retention Phi y
        (configuration.deletedBranchesTotallyNoncritical_of_witnesses
          retention hpos hmono hbounds hargs hwitness)

theorem witnessRetention_reduceAt_normalExpr_eval_eq {k : Nat}
    {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    {Phi : TrackedMode k -> Real -> Real} {y : Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    (hbounds : tree.NodeBounds Phi y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y) :
    (configuration.minPath.reduceAt configuration.witnessRetention).normalExpr.eval
      Phi y = tree.normalExpr.eval Phi y :=
  configuration.reduceAt_normalExpr_eval_eq_of_witnesses
    configuration.witnessRetention hpos hmono hbounds hargs
      configuration.witnessRetention_deletedBranchesHaveWitness

end AdvancedMinConfiguration

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
