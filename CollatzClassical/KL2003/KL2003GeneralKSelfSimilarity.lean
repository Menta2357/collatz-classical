import CollatzClassical.KL2003.KL2003GeneralKTerminationCore

namespace CollatzClassical
namespace KL2003

/-!
Translation equivariance for source general-`k` EL expansion traces.

This module formalizes the local algebra behind the self-similarity statement
used in KL2003 Theorem 3.1: changing the root argument by one symbolic shift
translates every descendant shift by the same amount, while preserving modes
and tree shape. It covers arbitrary finite traces of explicitly matched raw
source splits, fixed-retention deletion, and witness-retention deletion when
the relevant leaves remain nonnegative. It does not claim that the
sign-sensitive scheduler chooses the same occurrence after translation,
identify recurrent infinite subtrees, or prove termination/order independence.
-/

namespace SymbolicShift

theorem add_assoc (first second third : SymbolicShift) :
    first + second + third = first + (second + third) := by
  cases first with
  | mk firstAlpha firstConst =>
      cases second with
      | mk secondAlpha secondConst =>
          cases third with
          | mk thirdAlpha thirdConst =>
              change
                SymbolicShift.mk
                    ((firstAlpha + secondAlpha) + thirdAlpha)
                    ((firstConst + secondConst) + thirdConst) =
                  SymbolicShift.mk
                    (firstAlpha + (secondAlpha + thirdAlpha))
                    (firstConst + (secondConst + thirdConst))
              rw [Int.add_assoc, Int.add_assoc]

end SymbolicShift

namespace ELExpr

theorem shiftBy_shiftBy {k : Nat} (expr : ELExpr k)
    (first second : SymbolicShift) :
    (expr.shiftBy first).shiftBy second = expr.shiftBy (second + first) := by
  induction expr with
  | leaf label =>
      simp only [shiftBy]
      rw [SymbolicShift.add_assoc]
  | add left right ihLeft ihRight => simp [shiftBy, ihLeft, ihRight]
  | min3 firstExpr secondExpr thirdExpr ihFirst ihSecond ihThird =>
      simp [shiftBy, ihFirst, ihSecond, ihThird]

end ELExpr

namespace ELLabel

def translate {k : Nat} (delta : SymbolicShift) (label : ELLabel k) :
    ELLabel k :=
  ⟨label.mode, delta + label.shift⟩

@[simp] theorem translate_mode {k : Nat} (delta : SymbolicShift)
    (label : ELLabel k) :
    (label.translate delta).mode = label.mode := rfl

@[simp] theorem translate_shift {k : Nat} (delta : SymbolicShift)
    (label : ELLabel k) :
    (label.translate delta).shift = delta + label.shift := rfl

theorem translate_shift_eval {k : Nat} (delta : SymbolicShift)
    (label : ELLabel k) :
    (label.translate delta).shift.eval = delta.eval + label.shift.eval := by
  rw [translate_shift, SymbolicShift.eval_add]

theorem shift_nonnegative_of_translate_shift_nonnegative_of_delta_nonpos
    {k : Nat} (delta : SymbolicShift) (label : ELLabel k)
    (hdelta : delta.eval <= 0)
    (htranslated : 0 <= (label.translate delta).shift.eval) :
    0 <= label.shift.eval := by
  rw [translate_shift_eval] at htranslated
  linarith

end ELLabel

namespace ELTree

def translate {k : Nat} (delta : SymbolicShift) : ELTree k -> ELTree k
  | .terminal label => .terminal (label.translate delta)
  | .expanded label body => .expanded (label.translate delta) (body.translate delta)
  | .add left right => .add (left.translate delta) (right.translate delta)
  | .min2 left right => .min2 (left.translate delta) (right.translate delta)
  | .min3 first second third =>
      .min3 (first.translate delta) (second.translate delta)
        (third.translate delta)

namespace Context

def translate {k : Nat} (delta : SymbolicShift) : Context k -> Context k
  | .hole => .hole
  | .expanded label context =>
      .expanded (label.translate delta) (context.translate delta)
  | .addLeft context right =>
      .addLeft (context.translate delta) (right.translate delta)
  | .addRight left context =>
      .addRight (left.translate delta) (context.translate delta)
  | .min2Left context right =>
      .min2Left (context.translate delta) (right.translate delta)
  | .min2Right left context =>
      .min2Right (left.translate delta) (context.translate delta)
  | .minFirst context second third =>
      .minFirst (context.translate delta) (second.translate delta)
        (third.translate delta)
  | .minSecond first context third =>
      .minSecond (first.translate delta) (context.translate delta)
        (third.translate delta)
  | .minThird first second context =>
      .minThird (first.translate delta) (second.translate delta)
        (context.translate delta)

theorem plug_translate {k : Nat} (context : Context k) (tree : ELTree k)
    (delta : SymbolicShift) :
    (context.translate delta).plug (tree.translate delta) =
      (context.plug tree).translate delta := by
  induction context <;>
    simp [translate, plug, ELTree.translate, *]

theorem expandedLabels_translate {k : Nat} (context : Context k)
    (delta : SymbolicShift) :
    (context.translate delta).expandedLabels =
      context.expandedLabels.map (ELLabel.translate delta) := by
  induction context <;>
    simp [translate, expandedLabels, *]

theorem comp_translate {k : Nat} (outer inner : Context k)
    (delta : SymbolicShift) :
    (outer.comp inner).translate delta =
      (outer.translate delta).comp (inner.translate delta) := by
  induction outer <;>
    simp [translate, comp, *]

@[simp] theorem containsAdd_translate {k : Nat} (context : Context k)
    (delta : SymbolicShift) :
    (context.translate delta).ContainsAdd <-> context.ContainsAdd := by
  induction context <;>
    simp [translate, ContainsAdd, *]

@[simp] theorem addBelowEveryExpanded_translate {k : Nat}
    (context : Context k) (delta : SymbolicShift) :
    (context.translate delta).AddBelowEveryExpanded <->
      context.AddBelowEveryExpanded := by
  induction context <;>
    simp [translate, AddBelowEveryExpanded, *]

end Context

theorem frontierExpr_translate {k : Nat} (tree : ELTree k)
    (delta : SymbolicShift) :
    (tree.translate delta).frontierExpr = tree.frontierExpr.shiftBy delta := by
  induction tree with
  | terminal label => rfl
  | expanded label body ih => rfl
  | add left right ihLeft ihRight =>
      simp [translate, frontierExpr, ELExpr.shiftBy, ihLeft, ihRight]
  | min2 left right ihLeft ihRight =>
      simp [translate, frontierExpr, ELExpr.shiftBy, ihLeft, ihRight]
  | min3 first second third ihFirst ihSecond ihThird =>
      simp [translate, frontierExpr, ELExpr.shiftBy, ihFirst, ihSecond, ihThird]

theorem normalExpr_translate {k : Nat} (tree : ELTree k)
    (delta : SymbolicShift) :
    (tree.translate delta).normalExpr = tree.normalExpr.shiftBy delta := by
  induction tree with
  | terminal label => rfl
  | expanded label body ih => simpa [translate, normalExpr] using ih
  | add left right ihLeft ihRight =>
      simp [translate, normalExpr, ELExpr.shiftBy, ihLeft, ihRight]
  | min2 left right ihLeft ihRight =>
      simp [translate, normalExpr, ELExpr.shiftBy, ihLeft, ihRight]
  | min3 first second third ihFirst ihSecond ihThird =>
      simp [translate, normalExpr, ELExpr.shiftBy, ihFirst, ihSecond, ihThird]

theorem normalExpr_eval_translate {k : Nat} (tree : ELTree k)
    (delta : SymbolicShift) (Phi : TrackedMode k -> Real -> Real) (y : Real) :
    (tree.translate delta).normalExpr.eval Phi y =
      tree.normalExpr.eval Phi (y + delta.eval) := by
  rw [normalExpr_translate, ELExpr.shiftBy_eval]

theorem ofExpr_shiftBy {k : Nat} (expr : ELExpr k)
    (delta : SymbolicShift) :
    ofExpr (expr.shiftBy delta) = (ofExpr expr).translate delta := by
  induction expr with
  | leaf label => rfl
  | add left right ihLeft ihRight =>
      simp [ELExpr.shiftBy, ofExpr, translate, ihLeft, ihRight]
  | min3 first second third ihFirst ihSecond ihThird =>
      simp [ELExpr.shiftBy, ofExpr, translate, ihFirst, ihSecond, ihThird]

theorem splitTopExpr_translate {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (delta : SymbolicShift) :
    splitTopExpr hp (label.translate delta) =
      (splitTopExpr hp label).shiftBy delta := by
  by_cases h2 : label.mode.1.1 % 9 = 2
  · simp [splitTopExpr, h2, ELLabel.translate, ELExpr.shiftBy_shiftBy]
  · by_cases h5 : label.mode.1.1 % 9 = 5
    · simp [splitTopExpr, h2, h5, ELLabel.translate, ELExpr.shiftBy_shiftBy]
    · simp [splitTopExpr, h2, h5, ELLabel.translate, ELExpr.shiftBy_shiftBy]

theorem sourceSplitTree_translate {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (delta : SymbolicShift) :
    sourceSplitTree hp (label.translate delta) =
      (sourceSplitTree hp label).translate delta := by
  simp [sourceSplitTree, translate, splitTopExpr_translate, ofExpr_shiftBy]

theorem retardedSplitLabel_translate {p : Nat}
    (label : ELLabel (p + 1)) (delta : SymbolicShift) :
    retardedSplitLabel (label.translate delta) =
      (retardedSplitLabel label).translate delta := by
  simp [retardedSplitLabel, ELLabel.translate, SymbolicShift.add_assoc]

theorem d1AdvancedSplitLabel_translate {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 2)
    (delta : SymbolicShift) (j : Fin 3) :
    d1AdvancedSplitLabel hp (label.translate delta) (by simpa using hm) j =
      (d1AdvancedSplitLabel hp label hm j).translate delta := by
  simp [d1AdvancedSplitLabel, ELLabel.translate, SymbolicShift.add_assoc]

theorem d3AdvancedSplitLabel_translate {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 8)
    (delta : SymbolicShift) (j : Fin 3) :
    d3AdvancedSplitLabel hp (label.translate delta) (by simpa using hm) j =
      (d3AdvancedSplitLabel hp label hm j).translate delta := by
  simp [d3AdvancedSplitLabel, ELLabel.translate, SymbolicShift.add_assoc]

theorem advancedSplitTree_translate {k : Nat}
    (root retarded first second third : ELLabel k)
    (delta : SymbolicShift) :
    advancedSplitTree (root.translate delta) (retarded.translate delta)
        (first.translate delta) (second.translate delta)
        (third.translate delta) =
      (advancedSplitTree root retarded first second third).translate delta := by
  rfl

namespace Min3Retention

theorem reduce_translate {k : Nat} (retention : Min3Retention)
    (first second third : ELTree k) (delta : SymbolicShift) :
    retention.reduce (first.translate delta) (second.translate delta)
        (third.translate delta) =
      (retention.reduce first second third).translate delta := by
  cases retention <;> rfl

end Min3Retention

namespace Min3Path

@[simp] theorem firstChild_cast {k : Nat} {treeA treeB : ELTree k}
    (h : treeA = treeB) (path : Min3Path treeA) :
    (h ▸ path).firstChild = path.firstChild := by
  subst treeB
  rfl

@[simp] theorem secondChild_cast {k : Nat} {treeA treeB : ELTree k}
    (h : treeA = treeB) (path : Min3Path treeA) :
    (h ▸ path).secondChild = path.secondChild := by
  subst treeB
  rfl

@[simp] theorem thirdChild_cast {k : Nat} {treeA treeB : ELTree k}
    (h : treeA = treeB) (path : Min3Path treeA) :
    (h ▸ path).thirdChild = path.thirdChild := by
  subst treeB
  rfl

@[simp] theorem firstBranchContext_cast {k : Nat}
    {treeA treeB : ELTree k} (h : treeA = treeB)
    (path : Min3Path treeA) :
    (h ▸ path).firstBranchContext = path.firstBranchContext := by
  subst treeB
  rfl

@[simp] theorem secondBranchContext_cast {k : Nat}
    {treeA treeB : ELTree k} (h : treeA = treeB)
    (path : Min3Path treeA) :
    (h ▸ path).secondBranchContext = path.secondBranchContext := by
  subst treeB
  rfl

@[simp] theorem thirdBranchContext_cast {k : Nat}
    {treeA treeB : ELTree k} (h : treeA = treeB)
    (path : Min3Path treeA) :
    (h ▸ path).thirdBranchContext = path.thirdBranchContext := by
  subst treeB
  rfl

@[simp] theorem firstChild_cast_congrArg {k : Nat}
    {treeA treeB : ELTree k} (h : treeA = treeB)
    (path : Min3Path treeA) :
    (cast (congrArg Min3Path h) path).firstChild = path.firstChild := by
  subst treeB
  rfl

@[simp] theorem secondChild_cast_congrArg {k : Nat}
    {treeA treeB : ELTree k} (h : treeA = treeB)
    (path : Min3Path treeA) :
    (cast (congrArg Min3Path h) path).secondChild = path.secondChild := by
  subst treeB
  rfl

@[simp] theorem thirdChild_cast_congrArg {k : Nat}
    {treeA treeB : ELTree k} (h : treeA = treeB)
    (path : Min3Path treeA) :
    (cast (congrArg Min3Path h) path).thirdChild = path.thirdChild := by
  subst treeB
  rfl

@[simp] theorem firstBranchContext_cast_congrArg {k : Nat}
    {treeA treeB : ELTree k} (h : treeA = treeB)
    (path : Min3Path treeA) :
    (cast (congrArg Min3Path h) path).firstBranchContext =
      path.firstBranchContext := by
  subst treeB
  rfl

@[simp] theorem secondBranchContext_cast_congrArg {k : Nat}
    {treeA treeB : ELTree k} (h : treeA = treeB)
    (path : Min3Path treeA) :
    (cast (congrArg Min3Path h) path).secondBranchContext =
      path.secondBranchContext := by
  subst treeB
  rfl

@[simp] theorem thirdBranchContext_cast_congrArg {k : Nat}
    {treeA treeB : ELTree k} (h : treeA = treeB)
    (path : Min3Path treeA) :
    (cast (congrArg Min3Path h) path).thirdBranchContext =
      path.thirdBranchContext := by
  subst treeB
  rfl

def translate {k : Nat} {tree : ELTree k} (path : Min3Path tree)
    (delta : SymbolicShift) : Min3Path (tree.translate delta) :=
  match path with
  | .here first second third =>
      .here (first.translate delta) (second.translate delta)
        (third.translate delta)
  | .expanded label body subpath =>
      .expanded (label.translate delta) (body.translate delta)
        (subpath.translate delta)
  | .addLeft left right subpath =>
      .addLeft (left.translate delta) (right.translate delta)
        (subpath.translate delta)
  | .addRight left right subpath =>
      .addRight (left.translate delta) (right.translate delta)
        (subpath.translate delta)
  | .min2Left left right subpath =>
      .min2Left (left.translate delta) (right.translate delta)
        (subpath.translate delta)
  | .min2Right left right subpath =>
      .min2Right (left.translate delta) (right.translate delta)
        (subpath.translate delta)
  | .minFirst first second third subpath =>
      .minFirst (first.translate delta) (second.translate delta)
        (third.translate delta) (subpath.translate delta)
  | .minSecond first second third subpath =>
      .minSecond (first.translate delta) (second.translate delta)
        (third.translate delta) (subpath.translate delta)
  | .minThird first second third subpath =>
      .minThird (first.translate delta) (second.translate delta)
        (third.translate delta) (subpath.translate delta)

theorem translate_heq_of_heq {k : Nat} {treeA treeB : ELTree k}
    (pathA : Min3Path treeA) (pathB : Min3Path treeB)
    (htree : treeA = treeB) (hpath : HEq pathA pathB)
    (delta : SymbolicShift) :
    HEq (pathA.translate delta) (pathB.translate delta) := by
  subst treeB
  cases eq_of_heq hpath
  rfl

@[simp] theorem firstChild_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (delta : SymbolicShift) :
    (path.translate delta).firstChild = path.firstChild.translate delta := by
  induction path <;> simp [translate, firstChild, *]

@[simp] theorem secondChild_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (delta : SymbolicShift) :
    (path.translate delta).secondChild = path.secondChild.translate delta := by
  induction path <;> simp [translate, secondChild, *]

@[simp] theorem thirdChild_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (delta : SymbolicShift) :
    (path.translate delta).thirdChild = path.thirdChild.translate delta := by
  induction path <;> simp [translate, thirdChild, *]

theorem context_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (delta : SymbolicShift) :
    (path.translate delta).context = path.context.translate delta := by
  induction path <;>
    simp [translate, context, Context.translate, *]

theorem firstBranchContext_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (delta : SymbolicShift) :
    (path.translate delta).firstBranchContext =
      path.firstBranchContext.translate delta := by
  simp [firstBranchContext, context_translate, Context.comp_translate,
    Context.translate]

theorem secondBranchContext_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (delta : SymbolicShift) :
    (path.translate delta).secondBranchContext =
      path.secondBranchContext.translate delta := by
  simp [secondBranchContext, context_translate, Context.comp_translate,
    Context.translate]

theorem thirdBranchContext_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (delta : SymbolicShift) :
    (path.translate delta).thirdBranchContext =
      path.thirdBranchContext.translate delta := by
  simp [thirdBranchContext, context_translate, Context.comp_translate,
    Context.translate]

theorem reduceAt_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (retention : Min3Retention)
    (delta : SymbolicShift) :
    (path.translate delta).reduceAt retention =
      (path.reduceAt retention).translate delta := by
  induction path with
  | here first second third =>
      exact retention.reduce_translate first second third delta
  | expanded label body subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]
  | addLeft left right subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]
  | addRight left right subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]
  | min2Left left right subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]
  | min2Right left right subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]
  | minFirst first second third subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]
  | minSecond first second third subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]
  | minThird first second third subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]

end Min3Path

namespace TerminalPath

@[simp] theorem context_cast {k : Nat} {treeA treeB : ELTree k}
    {target : ELLabel k} (h : treeA = treeB)
    (path : TerminalPath treeA target) :
    (h ▸ path).context = path.context := by
  subst treeB
  rfl

@[simp] theorem context_cast_congrArg {k : Nat}
    {treeA treeB : ELTree k} {target : ELLabel k}
    (h : treeA = treeB) (path : TerminalPath treeA target) :
    (cast (congrArg (fun tree => TerminalPath tree target) h) path).context =
      path.context := by
  subst treeB
  rfl

def translate {k : Nat} {tree : ELTree k} {target : ELLabel k}
    (path : TerminalPath tree target) (delta : SymbolicShift) :
    TerminalPath (tree.translate delta) (target.translate delta) :=
  match path with
  | .here label => .here (label.translate delta)
  | .expanded label body target subpath =>
      .expanded (label.translate delta) (body.translate delta)
        (target.translate delta) (subpath.translate delta)
  | .addLeft left right target subpath =>
      .addLeft (left.translate delta) (right.translate delta)
        (target.translate delta) (subpath.translate delta)
  | .addRight left right target subpath =>
      .addRight (left.translate delta) (right.translate delta)
        (target.translate delta) (subpath.translate delta)
  | .min2Left left right target subpath =>
      .min2Left (left.translate delta) (right.translate delta)
        (target.translate delta) (subpath.translate delta)
  | .min2Right left right target subpath =>
      .min2Right (left.translate delta) (right.translate delta)
        (target.translate delta) (subpath.translate delta)
  | .minFirst first second third target subpath =>
      .minFirst (first.translate delta) (second.translate delta)
        (third.translate delta) (target.translate delta)
        (subpath.translate delta)
  | .minSecond first second third target subpath =>
      .minSecond (first.translate delta) (second.translate delta)
        (third.translate delta) (target.translate delta)
        (subpath.translate delta)
  | .minThird first second third target subpath =>
      .minThird (first.translate delta) (second.translate delta)
        (third.translate delta) (target.translate delta)
        (subpath.translate delta)

theorem context_translate {k : Nat} {tree : ELTree k}
    {target : ELLabel k} (path : TerminalPath tree target)
    (delta : SymbolicShift) :
    (path.translate delta).context = path.context.translate delta := by
  induction path <;>
    simp [TerminalPath.translate, TerminalPath.context, Context.translate, *]

theorem leafState_translate_ancestors {k : Nat} {tree : ELTree k}
    {target : ELLabel k} (path : TerminalPath tree target)
    (delta : SymbolicShift) :
    (path.translate delta).leafState.ancestors =
      path.leafState.ancestors.map (ELLabel.translate delta) := by
  simp [leafState, context_translate, Context.expandedLabels_translate]

theorem hasDeletionWitness_translate_iff_of_nonnegative
    {k : Nat} {tree : ELTree k} {target : ELLabel k}
    (path : TerminalPath tree target) (delta : SymbolicShift)
    (horiginal : 0 <= target.shift.eval)
    (htranslated : 0 <= (target.translate delta).shift.eval) :
    (path.translate delta).HasDeletionWitness <-> path.HasDeletionWitness := by
  constructor
  · intro hwitness
    rcases hwitness with ⟨_, ancestor, hmem, hmode, hshift⟩
    rw [leafState_translate_ancestors] at hmem
    rcases List.mem_map.mp hmem with ⟨sourceAncestor, hsourceMem, heq⟩
    subst ancestor
    refine ⟨horiginal, sourceAncestor, hsourceMem, ?_, ?_⟩
    · simpa using hmode
    · simp only [leafState, ELLabel.translate_shift_eval] at hshift ⊢
      linarith
  · intro hwitness
    rcases hwitness with ⟨_, ancestor, hmem, hmode, hshift⟩
    refine ⟨htranslated, ancestor.translate delta, ?_, ?_, ?_⟩
    · rw [leafState_translate_ancestors]
      exact List.mem_map.mpr ⟨ancestor, hmem, rfl⟩
    · simpa using hmode
    · simp only [leafState, ELLabel.translate_shift_eval] at hshift ⊢
      linarith

theorem hasDeletionWitness_translate_iff_of_sign_iff
    {k : Nat} {tree : ELTree k} {target : ELLabel k}
    (path : TerminalPath tree target) (delta : SymbolicShift)
    (hsign : 0 <= (target.translate delta).shift.eval <->
      0 <= target.shift.eval) :
    (path.translate delta).HasDeletionWitness <-> path.HasDeletionWitness := by
  by_cases horiginal : 0 <= target.shift.eval
  · exact path.hasDeletionWitness_translate_iff_of_nonnegative delta
      horiginal (hsign.mpr horiginal)
  · constructor
    · intro hwitness
      exact False.elim (horiginal (hsign.mp hwitness.1))
    · intro hwitness
      exact False.elim (horiginal hwitness.1)

theorem splitAt_translate {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (path : TerminalPath tree target) (delta : SymbolicShift) :
    (path.translate delta).splitAt hp = (path.splitAt hp).translate delta := by
  induction path with
  | here label => exact sourceSplitTree_translate hp label delta
  | expanded label body target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]
  | addLeft left right target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]
  | addRight left right target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]
  | min2Left left right target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]
  | min2Right left right target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]
  | minFirst first second third target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]
  | minSecond first second third target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]
  | minThird first second third target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]

def translateSourceSplitPath {p : Nat} (hp : 1 <= p)
    {target leaf : ELLabel (p + 1)}
    (inner : TerminalPath (sourceSplitTree hp target) leaf)
    (delta : SymbolicShift) :
    TerminalPath (sourceSplitTree hp (target.translate delta))
      (leaf.translate delta) :=
  cast (congrArg
      (fun tree => TerminalPath tree (leaf.translate delta))
      (sourceSplitTree_translate hp target delta).symm)
    (inner.translate delta)

def translateSourceSplitMin3Path {p : Nat} (hp : 1 <= p)
    {target : ELLabel (p + 1)}
    (inner : Min3Path (sourceSplitTree hp target))
    (delta : SymbolicShift) :
    Min3Path (sourceSplitTree hp (target.translate delta)) :=
  cast (congrArg Min3Path
      (sourceSplitTree_translate hp target delta).symm)
    (inner.translate delta)

@[simp] theorem translateSourceSplitPath_context {p : Nat} (hp : 1 <= p)
    {target leaf : ELLabel (p + 1)}
    (inner : TerminalPath (sourceSplitTree hp target) leaf)
    (delta : SymbolicShift) :
    (inner.translateSourceSplitPath hp delta).context =
      inner.context.translate delta := by
  unfold translateSourceSplitPath
  rw [TerminalPath.context_cast_congrArg, inner.context_translate]
  exact (sourceSplitTree_translate hp target delta).symm

@[simp] theorem translateSourceSplitMin3Path_firstChild {p : Nat}
    (hp : 1 <= p) {target : ELLabel (p + 1)}
    (inner : Min3Path (sourceSplitTree hp target))
    (delta : SymbolicShift) :
    (TerminalPath.translateSourceSplitMin3Path hp inner delta).firstChild =
      inner.firstChild.translate delta := by
  unfold translateSourceSplitMin3Path
  rw [Min3Path.firstChild_cast_congrArg, inner.firstChild_translate]
  exact (sourceSplitTree_translate hp target delta).symm

@[simp] theorem translateSourceSplitMin3Path_secondChild {p : Nat}
    (hp : 1 <= p) {target : ELLabel (p + 1)}
    (inner : Min3Path (sourceSplitTree hp target))
    (delta : SymbolicShift) :
    (TerminalPath.translateSourceSplitMin3Path hp inner delta).secondChild =
      inner.secondChild.translate delta := by
  unfold translateSourceSplitMin3Path
  rw [Min3Path.secondChild_cast_congrArg, inner.secondChild_translate]
  exact (sourceSplitTree_translate hp target delta).symm

@[simp] theorem translateSourceSplitMin3Path_thirdChild {p : Nat}
    (hp : 1 <= p) {target : ELLabel (p + 1)}
    (inner : Min3Path (sourceSplitTree hp target))
    (delta : SymbolicShift) :
    (TerminalPath.translateSourceSplitMin3Path hp inner delta).thirdChild =
      inner.thirdChild.translate delta := by
  unfold translateSourceSplitMin3Path
  rw [Min3Path.thirdChild_cast_congrArg, inner.thirdChild_translate]
  exact (sourceSplitTree_translate hp target delta).symm

@[simp] theorem translateSourceSplitMin3Path_firstBranchContext {p : Nat}
    (hp : 1 <= p) {target : ELLabel (p + 1)}
    (inner : Min3Path (sourceSplitTree hp target))
    (delta : SymbolicShift) :
    (TerminalPath.translateSourceSplitMin3Path hp inner delta).firstBranchContext =
      inner.firstBranchContext.translate delta := by
  unfold translateSourceSplitMin3Path
  rw [Min3Path.firstBranchContext_cast_congrArg,
    inner.firstBranchContext_translate]
  exact (sourceSplitTree_translate hp target delta).symm

@[simp] theorem translateSourceSplitMin3Path_secondBranchContext {p : Nat}
    (hp : 1 <= p) {target : ELLabel (p + 1)}
    (inner : Min3Path (sourceSplitTree hp target))
    (delta : SymbolicShift) :
    (TerminalPath.translateSourceSplitMin3Path hp inner delta).secondBranchContext =
      inner.secondBranchContext.translate delta := by
  unfold translateSourceSplitMin3Path
  rw [Min3Path.secondBranchContext_cast_congrArg,
    inner.secondBranchContext_translate]
  exact (sourceSplitTree_translate hp target delta).symm

@[simp] theorem translateSourceSplitMin3Path_thirdBranchContext {p : Nat}
    (hp : 1 <= p) {target : ELLabel (p + 1)}
    (inner : Min3Path (sourceSplitTree hp target))
    (delta : SymbolicShift) :
    (TerminalPath.translateSourceSplitMin3Path hp inner delta).thirdBranchContext =
      inner.thirdBranchContext.translate delta := by
  unfold translateSourceSplitMin3Path
  rw [Min3Path.thirdBranchContext_cast_congrArg,
    inner.thirdBranchContext_translate]
  exact (sourceSplitTree_translate hp target delta).symm

theorem descendSplit_translate_heq {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target leaf : ELLabel (p + 1)}
    (outer : TerminalPath tree target)
    (inner : TerminalPath (sourceSplitTree hp target) leaf)
    (delta : SymbolicShift) :
    HEq ((outer.descendSplit hp inner).translate delta)
      ((outer.translate delta).descendSplit hp
        (inner.translateSourceSplitPath hp delta)) := by
  induction outer <;>
    simp only [descendSplit, TerminalPath.translate]
  all_goals
    congr! 1 <;>
      simp_all [translateSourceSplitPath, sourceSplitTree_translate,
        splitAt_translate]

theorem descendSplitMin3_translate_heq {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (outer : TerminalPath tree target)
    (inner : Min3Path (sourceSplitTree hp target))
    (delta : SymbolicShift) :
    HEq ((outer.descendSplitMin3 hp inner).translate delta)
      ((outer.translate delta).descendSplitMin3 hp
        (TerminalPath.translateSourceSplitMin3Path hp inner delta)) := by
  induction outer <;>
    simp only [descendSplitMin3, Min3Path.translate, TerminalPath.translate]
  all_goals
    congr! 1 <;>
      simp_all [translateSourceSplitMin3Path, sourceSplitTree_translate,
        splitAt_translate]

end TerminalPath

namespace TerminalPath.AdvancedMinConfiguration

def translate {k : Nat} {tree : ELTree k}
    {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    (delta : SymbolicShift) :
    AdvancedMinConfiguration (tree.translate delta)
      (first.translate delta) (second.translate delta)
      (third.translate delta) where
  minPath := configuration.minPath.translate delta
  firstPath := configuration.firstPath.translate delta
  secondPath := configuration.secondPath.translate delta
  thirdPath := configuration.thirdPath.translate delta
  firstChild_eq := by
    rw [Min3Path.firstChild_translate, configuration.firstChild_eq]
    rfl
  secondChild_eq := by
    rw [Min3Path.secondChild_translate, configuration.secondChild_eq]
    rfl
  thirdChild_eq := by
    rw [Min3Path.thirdChild_translate, configuration.thirdChild_eq]
    rfl
  firstContext_eq := by
    rw [Min3Path.firstBranchContext_translate,
      configuration.firstContext_eq, TerminalPath.context_translate]
  secondContext_eq := by
    rw [Min3Path.secondBranchContext_translate,
      configuration.secondContext_eq, TerminalPath.context_translate]
  thirdContext_eq := by
    rw [Min3Path.thirdBranchContext_translate,
      configuration.thirdContext_eq, TerminalPath.context_translate]
  firstContainsAdd := by
    rw [TerminalPath.context_translate, Context.containsAdd_translate]
    exact configuration.firstContainsAdd
  secondContainsAdd := by
    rw [TerminalPath.context_translate, Context.containsAdd_translate]
    exact configuration.secondContainsAdd
  thirdContainsAdd := by
    rw [TerminalPath.context_translate, Context.containsAdd_translate]
    exact configuration.thirdContainsAdd
  firstAddBelow := by
    change (configuration.firstPath.translate delta).context.AddBelowEveryExpanded
    rw [TerminalPath.context_translate,
      Context.addBelowEveryExpanded_translate]
    exact configuration.firstAddBelow
  secondAddBelow := by
    change (configuration.secondPath.translate delta).context.AddBelowEveryExpanded
    rw [TerminalPath.context_translate,
      Context.addBelowEveryExpanded_translate]
    exact configuration.secondAddBelow
  thirdAddBelow := by
    change (configuration.thirdPath.translate delta).context.AddBelowEveryExpanded
    rw [TerminalPath.context_translate,
      Context.addBelowEveryExpanded_translate]
    exact configuration.thirdAddBelow

def translateSourceSplit {p : Nat} (hp : 1 <= p)
    {target first second third : ELLabel (p + 1)}
    (configuration : AdvancedMinConfiguration
      (sourceSplitTree hp target) first second third)
    (delta : SymbolicShift) :
    AdvancedMinConfiguration (sourceSplitTree hp (target.translate delta))
      (first.translate delta) (second.translate delta)
      (third.translate delta) where
  minPath := TerminalPath.translateSourceSplitMin3Path hp
    configuration.minPath delta
  firstPath := configuration.firstPath.translateSourceSplitPath hp delta
  secondPath := configuration.secondPath.translateSourceSplitPath hp delta
  thirdPath := configuration.thirdPath.translateSourceSplitPath hp delta
  firstChild_eq := by
    simp [configuration.firstChild_eq, ELTree.translate]
  secondChild_eq := by
    simp [configuration.secondChild_eq, ELTree.translate]
  thirdChild_eq := by
    simp [configuration.thirdChild_eq, ELTree.translate]
  firstContext_eq := by
    simp [configuration.firstContext_eq]
  secondContext_eq := by
    simp [configuration.secondContext_eq]
  thirdContext_eq := by
    simp [configuration.thirdContext_eq]
  firstContainsAdd := by
    simp [configuration.firstContainsAdd]
  secondContainsAdd := by
    simp [configuration.secondContainsAdd]
  thirdContainsAdd := by
    simp [configuration.thirdContainsAdd]
  firstAddBelow := by
    change (configuration.firstPath.translateSourceSplitPath hp delta).context
      |>.AddBelowEveryExpanded
    rw [TerminalPath.translateSourceSplitPath_context]
    exact (Context.addBelowEveryExpanded_translate
      configuration.firstPath.context delta).2 configuration.firstAddBelow
  secondAddBelow := by
    change (configuration.secondPath.translateSourceSplitPath hp delta).context
      |>.AddBelowEveryExpanded
    rw [TerminalPath.translateSourceSplitPath_context]
    exact (Context.addBelowEveryExpanded_translate
      configuration.secondPath.context delta).2 configuration.secondAddBelow
  thirdAddBelow := by
    change (configuration.thirdPath.translateSourceSplitPath hp delta).context
      |>.AddBelowEveryExpanded
    rw [TerminalPath.translateSourceSplitPath_context]
    exact (Context.addBelowEveryExpanded_translate
      configuration.thirdPath.context delta).2 configuration.thirdAddBelow

@[simp] theorem cast_minPath {k : Nat} {treeA treeB : ELTree k}
    {first second third : ELLabel k} (h : treeA = treeB)
    (configuration : AdvancedMinConfiguration treeA first second third) :
    (h ▸ configuration).minPath = h ▸ configuration.minPath := by
  subst treeB
  rfl

@[simp] theorem cast_firstPath {k : Nat} {treeA treeB : ELTree k}
    {first second third : ELLabel k} (h : treeA = treeB)
    (configuration : AdvancedMinConfiguration treeA first second third) :
    (h ▸ configuration).firstPath = h ▸ configuration.firstPath := by
  subst treeB
  rfl

@[simp] theorem cast_secondPath {k : Nat} {treeA treeB : ELTree k}
    {first second third : ELLabel k} (h : treeA = treeB)
    (configuration : AdvancedMinConfiguration treeA first second third) :
    (h ▸ configuration).secondPath = h ▸ configuration.secondPath := by
  subst treeB
  rfl

@[simp] theorem cast_thirdPath {k : Nat} {treeA treeB : ELTree k}
    {first second third : ELLabel k} (h : treeA = treeB)
    (configuration : AdvancedMinConfiguration treeA first second third) :
    (h ▸ configuration).thirdPath = h ▸ configuration.thirdPath := by
  subst treeB
  rfl

@[simp] theorem translateSourceSplit_minPath {p : Nat} (hp : 1 <= p)
    {target first second third : ELLabel (p + 1)}
    (configuration : AdvancedMinConfiguration
      (sourceSplitTree hp target) first second third)
    (delta : SymbolicShift) :
    (configuration.translateSourceSplit hp delta).minPath =
      TerminalPath.translateSourceSplitMin3Path hp configuration.minPath
        delta := by
  simp [translateSourceSplit, TerminalPath.translateSourceSplitMin3Path]

@[simp] theorem translateSourceSplit_firstPath {p : Nat} (hp : 1 <= p)
    {target first second third : ELLabel (p + 1)}
    (configuration : AdvancedMinConfiguration
      (sourceSplitTree hp target) first second third)
    (delta : SymbolicShift) :
    (configuration.translateSourceSplit hp delta).firstPath =
      configuration.firstPath.translateSourceSplitPath hp delta := by
  simp [translateSourceSplit, TerminalPath.translateSourceSplitPath]

@[simp] theorem translateSourceSplit_secondPath {p : Nat} (hp : 1 <= p)
    {target first second third : ELLabel (p + 1)}
    (configuration : AdvancedMinConfiguration
      (sourceSplitTree hp target) first second third)
    (delta : SymbolicShift) :
    (configuration.translateSourceSplit hp delta).secondPath =
      configuration.secondPath.translateSourceSplitPath hp delta := by
  simp [translateSourceSplit, TerminalPath.translateSourceSplitPath]

@[simp] theorem translateSourceSplit_thirdPath {p : Nat} (hp : 1 <= p)
    {target first second third : ELLabel (p + 1)}
    (configuration : AdvancedMinConfiguration
      (sourceSplitTree hp target) first second third)
    (delta : SymbolicShift) :
    (configuration.translateSourceSplit hp delta).thirdPath =
      configuration.thirdPath.translateSourceSplitPath hp delta := by
  simp [translateSourceSplit, TerminalPath.translateSourceSplitPath]

theorem descendSplit_translate_heq {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)}
    {target first second third : ELLabel (p + 1)}
    (configuration : AdvancedMinConfiguration
      (sourceSplitTree hp target) first second third)
    (outer : TerminalPath tree target) (delta : SymbolicShift) :
    HEq ((configuration.descendSplit hp outer).translate delta)
      ((configuration.translateSourceSplit hp delta).descendSplit hp
        (outer.translate delta)) := by
  cases configuration
  simp only [translate, TerminalPath.AdvancedMinConfiguration.descendSplit,
    translateSourceSplit_minPath, translateSourceSplit_firstPath,
    translateSourceSplit_secondPath, translateSourceSplit_thirdPath]
  congr! 1
  all_goals
    first
    | exact (outer.splitAt_translate hp delta).symm
    | exact outer.descendSplitMin3_translate_heq hp _ delta
    | exact outer.descendSplit_translate_heq hp _ delta

theorem advancedMinConfiguration_translate {k : Nat}
    (root retarded first second third : ELLabel k)
    (delta : SymbolicShift) :
    (TerminalPath.advancedMinConfiguration root retarded first second third).translate
        delta =
      TerminalPath.advancedMinConfiguration (root.translate delta)
        (retarded.translate delta) (first.translate delta)
        (second.translate delta) (third.translate delta) := by
  rfl

theorem advancedMinPath_translate {k : Nat}
    (root retarded first second third : ELLabel k)
    (delta : SymbolicShift) :
    (TerminalPath.advancedMinPath root retarded first second third).translate
        delta =
      TerminalPath.advancedMinPath (root.translate delta)
        (retarded.translate delta) (first.translate delta)
        (second.translate delta) (third.translate delta) := by
  rfl

theorem advancedFirstPath_translate {k : Nat}
    (root retarded first second third : ELLabel k)
    (delta : SymbolicShift) :
    (TerminalPath.advancedFirstPath root retarded first second third).translate
        delta =
      TerminalPath.advancedFirstPath (root.translate delta)
        (retarded.translate delta) (first.translate delta)
        (second.translate delta) (third.translate delta) := by
  rfl

theorem advancedSecondPath_translate {k : Nat}
    (root retarded first second third : ELLabel k)
    (delta : SymbolicShift) :
    (TerminalPath.advancedSecondPath root retarded first second third).translate
        delta =
      TerminalPath.advancedSecondPath (root.translate delta)
        (retarded.translate delta) (first.translate delta)
        (second.translate delta) (third.translate delta) := by
  rfl

theorem advancedThirdPath_translate {k : Nat}
    (root retarded first second third : ELLabel k)
    (delta : SymbolicShift) :
    (TerminalPath.advancedThirdPath root retarded first second third).translate
        delta =
      TerminalPath.advancedThirdPath (root.translate delta)
        (retarded.translate delta) (first.translate delta)
        (second.translate delta) (third.translate delta) := by
  rfl

theorem translateSourceSplit_heq_translate {p : Nat} (hp : 1 <= p)
    {target first second third : ELLabel (p + 1)}
    (configuration : AdvancedMinConfiguration
      (sourceSplitTree hp target) first second third)
    (delta : SymbolicShift) :
    HEq (configuration.translateSourceSplit hp delta)
      (configuration.translate delta) := by
  cases configuration
  unfold translateSourceSplit translate
  congr! 1
  all_goals
    first
    | exact sourceSplitTree_translate hp target delta
    | exact cast_heq _ _

theorem translate_heq_of_heq {k : Nat}
    {treeA treeB : ELTree k}
    {first second third : ELLabel k}
    (configurationA : AdvancedMinConfiguration treeA first second third)
    (configurationB : AdvancedMinConfiguration treeB first second third)
    (htree : treeA = treeB)
    (hconfiguration : HEq configurationA configurationB)
    (delta : SymbolicShift) :
    HEq (configurationA.translate delta) (configurationB.translate delta) := by
  subst treeB
  have heq : configurationA = configurationB := eq_of_heq hconfiguration
  subst configurationB
  rfl

theorem sourceD1AdvancedConfigurationData_heq_advanced {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 2) :
    HEq (TerminalPath.sourceD1AdvancedConfigurationData hp label hm)
      (TerminalPath.advancedMinConfiguration label
        (retardedSplitLabel label)
        (d1AdvancedSplitLabel hp label hm 0)
        (d1AdvancedSplitLabel hp label hm 1)
        (d1AdvancedSplitLabel hp label hm 2)) := by
  unfold TerminalPath.sourceD1AdvancedConfigurationData
  exact rec_heq_of_heq
    (C := fun tree => AdvancedMinConfiguration tree
      (d1AdvancedSplitLabel hp label hm 0)
      (d1AdvancedSplitLabel hp label hm 1)
      (d1AdvancedSplitLabel hp label hm 2))
    (sourceSplitTree_eq_advanced_d1 hp label hm).symm HEq.rfl

theorem sourceD3AdvancedConfigurationData_heq_advanced {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 8) :
    HEq (TerminalPath.sourceD3AdvancedConfigurationData hp label hm)
      (TerminalPath.advancedMinConfiguration label
        (retardedSplitLabel label)
        (d3AdvancedSplitLabel hp label hm 0)
        (d3AdvancedSplitLabel hp label hm 1)
        (d3AdvancedSplitLabel hp label hm 2)) := by
  unfold TerminalPath.sourceD3AdvancedConfigurationData
  exact rec_heq_of_heq
    (C := fun tree => AdvancedMinConfiguration tree
      (d3AdvancedSplitLabel hp label hm 0)
      (d3AdvancedSplitLabel hp label hm 1)
      (d3AdvancedSplitLabel hp label hm 2))
    (sourceSplitTree_eq_advanced_d3 hp label hm).symm HEq.rfl

theorem sourceD1AdvancedConfigurationData_translateSourceSplit_heq {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 2) (delta : SymbolicShift) :
    HEq ((TerminalPath.sourceD1AdvancedConfigurationData hp label hm)
        |>.translateSourceSplit hp delta)
      (TerminalPath.sourceD1AdvancedConfigurationData hp
        (label.translate delta) (by simpa using hm)) := by
  let source := TerminalPath.sourceD1AdvancedConfigurationData hp label hm
  let advanced := TerminalPath.advancedMinConfiguration label
    (retardedSplitLabel label)
    (d1AdvancedSplitLabel hp label hm 0)
    (d1AdvancedSplitLabel hp label hm 1)
    (d1AdvancedSplitLabel hp label hm 2)
  let translatedSource := TerminalPath.sourceD1AdvancedConfigurationData hp
    (label.translate delta) (by simpa using hm)
  let translatedAdvanced := TerminalPath.advancedMinConfiguration
    (label.translate delta) (retardedSplitLabel (label.translate delta))
    (d1AdvancedSplitLabel hp (label.translate delta) (by simpa using hm) 0)
    (d1AdvancedSplitLabel hp (label.translate delta) (by simpa using hm) 1)
    (d1AdvancedSplitLabel hp (label.translate delta) (by simpa using hm) 2)
  let translatedByParts := TerminalPath.advancedMinConfiguration
    (label.translate delta) ((retardedSplitLabel label).translate delta)
    ((d1AdvancedSplitLabel hp label hm 0).translate delta)
    ((d1AdvancedSplitLabel hp label hm 1).translate delta)
    ((d1AdvancedSplitLabel hp label hm 2).translate delta)
  have houter : HEq (source.translateSourceSplit hp delta)
      (source.translate delta) := by
    exact translateSourceSplit_heq_translate hp source delta
  have hsource : HEq source advanced := by
    exact sourceD1AdvancedConfigurationData_heq_advanced hp label hm
  have hsourceTranslated : HEq (source.translate delta)
      (advanced.translate delta) := by
    exact translate_heq_of_heq source advanced
      (sourceSplitTree_eq_advanced_d1 hp label hm) hsource delta
  have hparts : advanced.translate delta = translatedByParts := by
    simpa [advanced, translatedByParts] using
      advancedMinConfiguration_translate label (retardedSplitLabel label)
        (d1AdvancedSplitLabel hp label hm 0)
        (d1AdvancedSplitLabel hp label hm 1)
        (d1AdvancedSplitLabel hp label hm 2) delta
  have hcanonical : HEq translatedByParts translatedAdvanced := by
    dsimp [translatedByParts, translatedAdvanced]
    have hret := (retardedSplitLabel_translate label delta).symm
    have h0 := (d1AdvancedSplitLabel_translate hp label hm delta 0).symm
    have h1 := (d1AdvancedSplitLabel_translate hp label hm delta 1).symm
    have h2 := (d1AdvancedSplitLabel_translate hp label hm delta 2).symm
    rw [hret, h0, h1, h2]
  have htranslated : HEq translatedSource translatedAdvanced := by
    exact sourceD1AdvancedConfigurationData_heq_advanced hp
      (label.translate delta) (by simpa using hm)
  exact houter.trans (hsourceTranslated.trans ((heq_of_eq hparts).trans
    (hcanonical.trans htranslated.symm)))

theorem sourceD3AdvancedConfigurationData_translateSourceSplit_heq {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 8) (delta : SymbolicShift) :
    HEq ((TerminalPath.sourceD3AdvancedConfigurationData hp label hm)
        |>.translateSourceSplit hp delta)
      (TerminalPath.sourceD3AdvancedConfigurationData hp
        (label.translate delta) (by simpa using hm)) := by
  let source := TerminalPath.sourceD3AdvancedConfigurationData hp label hm
  let advanced := TerminalPath.advancedMinConfiguration label
    (retardedSplitLabel label)
    (d3AdvancedSplitLabel hp label hm 0)
    (d3AdvancedSplitLabel hp label hm 1)
    (d3AdvancedSplitLabel hp label hm 2)
  let translatedSource := TerminalPath.sourceD3AdvancedConfigurationData hp
    (label.translate delta) (by simpa using hm)
  let translatedAdvanced := TerminalPath.advancedMinConfiguration
    (label.translate delta) (retardedSplitLabel (label.translate delta))
    (d3AdvancedSplitLabel hp (label.translate delta) (by simpa using hm) 0)
    (d3AdvancedSplitLabel hp (label.translate delta) (by simpa using hm) 1)
    (d3AdvancedSplitLabel hp (label.translate delta) (by simpa using hm) 2)
  let translatedByParts := TerminalPath.advancedMinConfiguration
    (label.translate delta) ((retardedSplitLabel label).translate delta)
    ((d3AdvancedSplitLabel hp label hm 0).translate delta)
    ((d3AdvancedSplitLabel hp label hm 1).translate delta)
    ((d3AdvancedSplitLabel hp label hm 2).translate delta)
  have houter : HEq (source.translateSourceSplit hp delta)
      (source.translate delta) := by
    exact translateSourceSplit_heq_translate hp source delta
  have hsource : HEq source advanced := by
    exact sourceD3AdvancedConfigurationData_heq_advanced hp label hm
  have hsourceTranslated : HEq (source.translate delta)
      (advanced.translate delta) := by
    exact translate_heq_of_heq source advanced
      (sourceSplitTree_eq_advanced_d3 hp label hm) hsource delta
  have hparts : advanced.translate delta = translatedByParts := by
    simpa [advanced, translatedByParts] using
      advancedMinConfiguration_translate label (retardedSplitLabel label)
        (d3AdvancedSplitLabel hp label hm 0)
        (d3AdvancedSplitLabel hp label hm 1)
        (d3AdvancedSplitLabel hp label hm 2) delta
  have hcanonical : HEq translatedByParts translatedAdvanced := by
    dsimp [translatedByParts, translatedAdvanced]
    have hret := (retardedSplitLabel_translate label delta).symm
    have h0 := (d3AdvancedSplitLabel_translate hp label hm delta 0).symm
    have h1 := (d3AdvancedSplitLabel_translate hp label hm delta 1).symm
    have h2 := (d3AdvancedSplitLabel_translate hp label hm delta 2).symm
    rw [hret, h0, h1, h2]
  have htranslated : HEq translatedSource translatedAdvanced := by
    exact sourceD3AdvancedConfigurationData_heq_advanced hp
      (label.translate delta) (by simpa using hm)
  exact houter.trans (hsourceTranslated.trans ((heq_of_eq hparts).trans
    (hcanonical.trans htranslated.symm)))

theorem firstPath_heq_of_heq {k : Nat}
    {treeA treeB : ELTree k}
    {firstA secondA thirdA firstB secondB thirdB : ELLabel k}
    (configurationA : AdvancedMinConfiguration treeA firstA secondA thirdA)
    (configurationB : AdvancedMinConfiguration treeB firstB secondB thirdB)
    (htree : treeA = treeB) (hfirst : firstA = firstB)
    (hsecond : secondA = secondB) (hthird : thirdA = thirdB)
    (hconfiguration : HEq configurationA configurationB) :
    HEq configurationA.firstPath configurationB.firstPath := by
  subst treeB
  subst firstB
  subst secondB
  subst thirdB
  exact heq_of_eq (congrArg (fun configuration => configuration.firstPath)
    (eq_of_heq hconfiguration))

theorem secondPath_heq_of_heq {k : Nat}
    {treeA treeB : ELTree k}
    {firstA secondA thirdA firstB secondB thirdB : ELLabel k}
    (configurationA : AdvancedMinConfiguration treeA firstA secondA thirdA)
    (configurationB : AdvancedMinConfiguration treeB firstB secondB thirdB)
    (htree : treeA = treeB) (hfirst : firstA = firstB)
    (hsecond : secondA = secondB) (hthird : thirdA = thirdB)
    (hconfiguration : HEq configurationA configurationB) :
    HEq configurationA.secondPath configurationB.secondPath := by
  subst treeB
  subst firstB
  subst secondB
  subst thirdB
  exact heq_of_eq (congrArg (fun configuration => configuration.secondPath)
    (eq_of_heq hconfiguration))

theorem thirdPath_heq_of_heq {k : Nat}
    {treeA treeB : ELTree k}
    {firstA secondA thirdA firstB secondB thirdB : ELLabel k}
    (configurationA : AdvancedMinConfiguration treeA firstA secondA thirdA)
    (configurationB : AdvancedMinConfiguration treeB firstB secondB thirdB)
    (htree : treeA = treeB) (hfirst : firstA = firstB)
    (hsecond : secondA = secondB) (hthird : thirdA = thirdB)
    (hconfiguration : HEq configurationA configurationB) :
    HEq configurationA.thirdPath configurationB.thirdPath := by
  subst treeB
  subst firstB
  subst secondB
  subst thirdB
  exact heq_of_eq (congrArg (fun configuration => configuration.thirdPath)
    (eq_of_heq hconfiguration))

theorem descendSplit_heq_of_heq {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    {firstA secondA thirdA firstB secondB thirdB : ELLabel (p + 1)}
    (configurationA : AdvancedMinConfiguration
      (sourceSplitTree hp target) firstA secondA thirdA)
    (configurationB : AdvancedMinConfiguration
      (sourceSplitTree hp target) firstB secondB thirdB)
    (hfirst : firstA = firstB) (hsecond : secondA = secondB)
    (hthird : thirdA = thirdB)
    (hconfiguration : HEq configurationA configurationB)
    (outer : TerminalPath tree target) :
    HEq (configurationA.descendSplit hp outer)
      (configurationB.descendSplit hp outer) := by
  subst firstB
  subst secondB
  subst thirdB
  have heq : configurationA = configurationB := eq_of_heq hconfiguration
  subst configurationB
  rfl

theorem witnessRetention_eq_of_heq {k : Nat}
    {treeA treeB : ELTree k}
    {firstA secondA thirdA firstB secondB thirdB : ELLabel k}
    (configurationA : AdvancedMinConfiguration treeA firstA secondA thirdA)
    (configurationB : AdvancedMinConfiguration treeB firstB secondB thirdB)
    (htree : treeA = treeB) (hfirst : firstA = firstB)
    (hsecond : secondA = secondB) (hthird : thirdA = thirdB)
    (hconfiguration : HEq configurationA configurationB) :
    configurationA.witnessRetention = configurationB.witnessRetention := by
  subst treeB
  subst firstB
  subst secondB
  subst thirdB
  exact congrArg witnessRetention (eq_of_heq hconfiguration)

theorem reduceAt_witnessRetention_eq_of_heq {k : Nat}
    {treeA treeB : ELTree k}
    {firstA secondA thirdA firstB secondB thirdB : ELLabel k}
    (configurationA : AdvancedMinConfiguration treeA firstA secondA thirdA)
    (configurationB : AdvancedMinConfiguration treeB firstB secondB thirdB)
    (htree : treeA = treeB) (hfirst : firstA = firstB)
    (hsecond : secondA = secondB) (hthird : thirdA = thirdB)
    (hconfiguration : HEq configurationA configurationB) :
    configurationA.minPath.reduceAt configurationA.witnessRetention =
      configurationB.minPath.reduceAt configurationB.witnessRetention := by
  subst treeB
  subst firstB
  subst secondB
  subst thirdB
  have heq : configurationA = configurationB := eq_of_heq hconfiguration
  subst configurationB
  rfl

theorem sourceD1AdvancedConfigurationData_firstPath_translate_heq {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 2) (delta : SymbolicShift) :
    HEq (TerminalPath.translateSourceSplitPath hp
        (TerminalPath.sourceD1AdvancedConfigurationData hp label hm).firstPath
        delta)
      (TerminalPath.sourceD1AdvancedConfigurationData hp
        (label.translate delta) (by simpa using hm)).firstPath := by
  let source := TerminalPath.sourceD1AdvancedConfigurationData hp label hm
  let translatedSource := TerminalPath.sourceD1AdvancedConfigurationData hp
    (label.translate delta) (by simpa using hm)
  have hconfiguration : HEq (source.translateSourceSplit hp delta)
      translatedSource := by
    exact sourceD1AdvancedConfigurationData_translateSourceSplit_heq hp label
      hm delta
  have hpath := firstPath_heq_of_heq
    (source.translateSourceSplit hp delta) translatedSource rfl
    (d1AdvancedSplitLabel_translate hp label hm delta 0).symm
    (d1AdvancedSplitLabel_translate hp label hm delta 1).symm
    (d1AdvancedSplitLabel_translate hp label hm delta 2).symm hconfiguration
  simpa [source, translatedSource] using hpath

theorem sourceD1AdvancedConfigurationData_secondPath_translate_heq {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 2) (delta : SymbolicShift) :
    HEq (TerminalPath.translateSourceSplitPath hp
        (TerminalPath.sourceD1AdvancedConfigurationData hp label hm).secondPath
        delta)
      (TerminalPath.sourceD1AdvancedConfigurationData hp
        (label.translate delta) (by simpa using hm)).secondPath := by
  let source := TerminalPath.sourceD1AdvancedConfigurationData hp label hm
  let translatedSource := TerminalPath.sourceD1AdvancedConfigurationData hp
    (label.translate delta) (by simpa using hm)
  have hconfiguration : HEq (source.translateSourceSplit hp delta)
      translatedSource := by
    exact sourceD1AdvancedConfigurationData_translateSourceSplit_heq hp label
      hm delta
  have hpath := secondPath_heq_of_heq
    (source.translateSourceSplit hp delta) translatedSource rfl
    (d1AdvancedSplitLabel_translate hp label hm delta 0).symm
    (d1AdvancedSplitLabel_translate hp label hm delta 1).symm
    (d1AdvancedSplitLabel_translate hp label hm delta 2).symm hconfiguration
  simpa [source, translatedSource] using hpath

theorem sourceD1AdvancedConfigurationData_thirdPath_translate_heq {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 2) (delta : SymbolicShift) :
    HEq (TerminalPath.translateSourceSplitPath hp
        (TerminalPath.sourceD1AdvancedConfigurationData hp label hm).thirdPath
        delta)
      (TerminalPath.sourceD1AdvancedConfigurationData hp
        (label.translate delta) (by simpa using hm)).thirdPath := by
  let source := TerminalPath.sourceD1AdvancedConfigurationData hp label hm
  let translatedSource := TerminalPath.sourceD1AdvancedConfigurationData hp
    (label.translate delta) (by simpa using hm)
  have hconfiguration : HEq (source.translateSourceSplit hp delta)
      translatedSource := by
    exact sourceD1AdvancedConfigurationData_translateSourceSplit_heq hp label
      hm delta
  have hpath := thirdPath_heq_of_heq
    (source.translateSourceSplit hp delta) translatedSource rfl
    (d1AdvancedSplitLabel_translate hp label hm delta 0).symm
    (d1AdvancedSplitLabel_translate hp label hm delta 1).symm
    (d1AdvancedSplitLabel_translate hp label hm delta 2).symm hconfiguration
  simpa [source, translatedSource] using hpath

theorem sourceD3AdvancedConfigurationData_firstPath_translate_heq {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 8) (delta : SymbolicShift) :
    HEq (TerminalPath.translateSourceSplitPath hp
        (TerminalPath.sourceD3AdvancedConfigurationData hp label hm).firstPath
        delta)
      (TerminalPath.sourceD3AdvancedConfigurationData hp
        (label.translate delta) (by simpa using hm)).firstPath := by
  let source := TerminalPath.sourceD3AdvancedConfigurationData hp label hm
  let translatedSource := TerminalPath.sourceD3AdvancedConfigurationData hp
    (label.translate delta) (by simpa using hm)
  have hconfiguration : HEq (source.translateSourceSplit hp delta)
      translatedSource := by
    exact sourceD3AdvancedConfigurationData_translateSourceSplit_heq hp label
      hm delta
  have hpath := firstPath_heq_of_heq
    (source.translateSourceSplit hp delta) translatedSource rfl
    (d3AdvancedSplitLabel_translate hp label hm delta 0).symm
    (d3AdvancedSplitLabel_translate hp label hm delta 1).symm
    (d3AdvancedSplitLabel_translate hp label hm delta 2).symm hconfiguration
  simpa [source, translatedSource] using hpath

theorem sourceD3AdvancedConfigurationData_secondPath_translate_heq {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 8) (delta : SymbolicShift) :
    HEq (TerminalPath.translateSourceSplitPath hp
        (TerminalPath.sourceD3AdvancedConfigurationData hp label hm).secondPath
        delta)
      (TerminalPath.sourceD3AdvancedConfigurationData hp
        (label.translate delta) (by simpa using hm)).secondPath := by
  let source := TerminalPath.sourceD3AdvancedConfigurationData hp label hm
  let translatedSource := TerminalPath.sourceD3AdvancedConfigurationData hp
    (label.translate delta) (by simpa using hm)
  have hconfiguration : HEq (source.translateSourceSplit hp delta)
      translatedSource := by
    exact sourceD3AdvancedConfigurationData_translateSourceSplit_heq hp label
      hm delta
  have hpath := secondPath_heq_of_heq
    (source.translateSourceSplit hp delta) translatedSource rfl
    (d3AdvancedSplitLabel_translate hp label hm delta 0).symm
    (d3AdvancedSplitLabel_translate hp label hm delta 1).symm
    (d3AdvancedSplitLabel_translate hp label hm delta 2).symm hconfiguration
  simpa [source, translatedSource] using hpath

theorem sourceD3AdvancedConfigurationData_thirdPath_translate_heq {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 8) (delta : SymbolicShift) :
    HEq (TerminalPath.translateSourceSplitPath hp
        (TerminalPath.sourceD3AdvancedConfigurationData hp label hm).thirdPath
        delta)
      (TerminalPath.sourceD3AdvancedConfigurationData hp
        (label.translate delta) (by simpa using hm)).thirdPath := by
  let source := TerminalPath.sourceD3AdvancedConfigurationData hp label hm
  let translatedSource := TerminalPath.sourceD3AdvancedConfigurationData hp
    (label.translate delta) (by simpa using hm)
  have hconfiguration : HEq (source.translateSourceSplit hp delta)
      translatedSource := by
    exact sourceD3AdvancedConfigurationData_translateSourceSplit_heq hp label
      hm delta
  have hpath := thirdPath_heq_of_heq
    (source.translateSourceSplit hp delta) translatedSource rfl
    (d3AdvancedSplitLabel_translate hp label hm delta 0).symm
    (d3AdvancedSplitLabel_translate hp label hm delta 1).symm
    (d3AdvancedSplitLabel_translate hp label hm delta 2).symm hconfiguration
  simpa [source, translatedSource] using hpath

theorem sourceD1AdvancedConfigurationData_minPath_heq_advanced {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 2) :
    HEq (TerminalPath.sourceD1AdvancedConfigurationData hp label hm).minPath
      (TerminalPath.advancedMinConfiguration label
        (retardedSplitLabel label)
        (d1AdvancedSplitLabel hp label hm 0)
        (d1AdvancedSplitLabel hp label hm 1)
        (d1AdvancedSplitLabel hp label hm 2)).minPath := by
  unfold TerminalPath.sourceD1AdvancedConfigurationData
  congr! 1
  all_goals
    first
    | exact sourceSplitTree_eq_advanced_d1 hp label hm
    | exact rec_heq_of_heq
        (C := fun tree => AdvancedMinConfiguration tree
          (d1AdvancedSplitLabel hp label hm 0)
          (d1AdvancedSplitLabel hp label hm 1)
          (d1AdvancedSplitLabel hp label hm 2))
        (sourceSplitTree_eq_advanced_d1 hp label hm).symm HEq.rfl

theorem sourceD3AdvancedConfigurationData_minPath_heq_advanced {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 8) :
    HEq (TerminalPath.sourceD3AdvancedConfigurationData hp label hm).minPath
      (TerminalPath.advancedMinConfiguration label
        (retardedSplitLabel label)
        (d3AdvancedSplitLabel hp label hm 0)
        (d3AdvancedSplitLabel hp label hm 1)
        (d3AdvancedSplitLabel hp label hm 2)).minPath := by
  unfold TerminalPath.sourceD3AdvancedConfigurationData
  congr! 1
  all_goals
    first
    | exact sourceSplitTree_eq_advanced_d3 hp label hm
    | exact rec_heq_of_heq
        (C := fun tree => AdvancedMinConfiguration tree
          (d3AdvancedSplitLabel hp label hm 0)
          (d3AdvancedSplitLabel hp label hm 1)
          (d3AdvancedSplitLabel hp label hm 2))
        (sourceSplitTree_eq_advanced_d3 hp label hm).symm HEq.rfl

theorem sourceD1AdvancedConfigurationData_minPath_translate_heq {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 2) (delta : SymbolicShift) :
    HEq (TerminalPath.translateSourceSplitMin3Path hp
        (TerminalPath.sourceD1AdvancedConfigurationData hp label hm).minPath
        delta)
      (TerminalPath.sourceD1AdvancedConfigurationData hp
        (label.translate delta) (by simpa using hm)).minPath := by
  let source := TerminalPath.sourceD1AdvancedConfigurationData hp label hm
  let advanced := TerminalPath.advancedMinConfiguration label
    (retardedSplitLabel label)
    (d1AdvancedSplitLabel hp label hm 0)
    (d1AdvancedSplitLabel hp label hm 1)
    (d1AdvancedSplitLabel hp label hm 2)
  let translatedSource := TerminalPath.sourceD1AdvancedConfigurationData hp
    (label.translate delta) (by simpa using hm)
  let translatedAdvanced := TerminalPath.advancedMinConfiguration
    (label.translate delta) (retardedSplitLabel (label.translate delta))
    (d1AdvancedSplitLabel hp (label.translate delta) (by simpa using hm) 0)
    (d1AdvancedSplitLabel hp (label.translate delta) (by simpa using hm) 1)
    (d1AdvancedSplitLabel hp (label.translate delta) (by simpa using hm) 2)
  let translatedByParts := TerminalPath.advancedMinConfiguration
    (label.translate delta) ((retardedSplitLabel label).translate delta)
    ((d1AdvancedSplitLabel hp label hm 0).translate delta)
    ((d1AdvancedSplitLabel hp label hm 1).translate delta)
    ((d1AdvancedSplitLabel hp label hm 2).translate delta)
  have houter : HEq
      (TerminalPath.translateSourceSplitMin3Path hp source.minPath delta)
      (source.minPath.translate delta) := by
    unfold TerminalPath.translateSourceSplitMin3Path
    exact cast_heq _ _
  have hsource : HEq source.minPath advanced.minPath := by
    exact sourceD1AdvancedConfigurationData_minPath_heq_advanced hp label hm
  have hadvanced : HEq (advanced.minPath.translate delta)
      translatedAdvanced.minPath := by
    have hparts : advanced.minPath.translate delta =
        translatedByParts.minPath := by
      simpa [advanced, translatedByParts,
        TerminalPath.AdvancedMinConfiguration.translate] using
        congrArg (fun configuration => configuration.minPath)
        (advancedMinConfiguration_translate label (retardedSplitLabel label)
          (d1AdvancedSplitLabel hp label hm 0)
          (d1AdvancedSplitLabel hp label hm 1)
          (d1AdvancedSplitLabel hp label hm 2) delta)
    have hcanonical : HEq translatedByParts.minPath
        translatedAdvanced.minPath := by
      dsimp [translatedByParts, translatedAdvanced]
      have hret := (retardedSplitLabel_translate label delta).symm
      have h0 := (d1AdvancedSplitLabel_translate hp label hm delta 0).symm
      have h1 := (d1AdvancedSplitLabel_translate hp label hm delta 1).symm
      have h2 := (d1AdvancedSplitLabel_translate hp label hm delta 2).symm
      rw [hret, h0, h1, h2]
    exact (heq_of_eq hparts).trans hcanonical
  have htranslated : HEq translatedSource.minPath
      translatedAdvanced.minPath := by
    exact sourceD1AdvancedConfigurationData_minPath_heq_advanced hp
      (label.translate delta) (by simpa using hm)
  exact houter.trans ((Min3Path.translate_heq_of_heq _ _
    (sourceSplitTree_eq_advanced_d1 hp label hm) hsource delta).trans
    (hadvanced.trans htranslated.symm))

theorem sourceD3AdvancedConfigurationData_minPath_translate_heq {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 8) (delta : SymbolicShift) :
    HEq (TerminalPath.translateSourceSplitMin3Path hp
        (TerminalPath.sourceD3AdvancedConfigurationData hp label hm).minPath
        delta)
      (TerminalPath.sourceD3AdvancedConfigurationData hp
        (label.translate delta) (by simpa using hm)).minPath := by
  let source := TerminalPath.sourceD3AdvancedConfigurationData hp label hm
  let advanced := TerminalPath.advancedMinConfiguration label
    (retardedSplitLabel label)
    (d3AdvancedSplitLabel hp label hm 0)
    (d3AdvancedSplitLabel hp label hm 1)
    (d3AdvancedSplitLabel hp label hm 2)
  let translatedSource := TerminalPath.sourceD3AdvancedConfigurationData hp
    (label.translate delta) (by simpa using hm)
  let translatedAdvanced := TerminalPath.advancedMinConfiguration
    (label.translate delta) (retardedSplitLabel (label.translate delta))
    (d3AdvancedSplitLabel hp (label.translate delta) (by simpa using hm) 0)
    (d3AdvancedSplitLabel hp (label.translate delta) (by simpa using hm) 1)
    (d3AdvancedSplitLabel hp (label.translate delta) (by simpa using hm) 2)
  let translatedByParts := TerminalPath.advancedMinConfiguration
    (label.translate delta) ((retardedSplitLabel label).translate delta)
    ((d3AdvancedSplitLabel hp label hm 0).translate delta)
    ((d3AdvancedSplitLabel hp label hm 1).translate delta)
    ((d3AdvancedSplitLabel hp label hm 2).translate delta)
  have houter : HEq
      (TerminalPath.translateSourceSplitMin3Path hp source.minPath delta)
      (source.minPath.translate delta) := by
    unfold TerminalPath.translateSourceSplitMin3Path
    exact cast_heq _ _
  have hsource : HEq source.minPath advanced.minPath := by
    exact sourceD3AdvancedConfigurationData_minPath_heq_advanced hp label hm
  have hadvanced : HEq (advanced.minPath.translate delta)
      translatedAdvanced.minPath := by
    have hparts : advanced.minPath.translate delta =
        translatedByParts.minPath := by
      simpa [advanced, translatedByParts,
        TerminalPath.AdvancedMinConfiguration.translate] using
        congrArg (fun configuration => configuration.minPath)
        (advancedMinConfiguration_translate label (retardedSplitLabel label)
          (d3AdvancedSplitLabel hp label hm 0)
          (d3AdvancedSplitLabel hp label hm 1)
          (d3AdvancedSplitLabel hp label hm 2) delta)
    have hcanonical : HEq translatedByParts.minPath
        translatedAdvanced.minPath := by
      dsimp [translatedByParts, translatedAdvanced]
      have hret := (retardedSplitLabel_translate label delta).symm
      have h0 := (d3AdvancedSplitLabel_translate hp label hm delta 0).symm
      have h1 := (d3AdvancedSplitLabel_translate hp label hm delta 1).symm
      have h2 := (d3AdvancedSplitLabel_translate hp label hm delta 2).symm
      rw [hret, h0, h1, h2]
    exact (heq_of_eq hparts).trans hcanonical
  have htranslated : HEq translatedSource.minPath
      translatedAdvanced.minPath := by
    exact sourceD3AdvancedConfigurationData_minPath_heq_advanced hp
      (label.translate delta) (by simpa using hm)
  exact houter.trans ((Min3Path.translate_heq_of_heq _ _
    (sourceSplitTree_eq_advanced_d3 hp label hm) hsource delta).trans
    (hadvanced.trans htranslated.symm))

theorem witnessRetention_eq_of_witness_iff
    {k : Nat} {treeA treeB : ELTree k}
    {firstA secondA thirdA firstB secondB thirdB : ELLabel k}
    (configurationA : AdvancedMinConfiguration treeA firstA secondA thirdA)
    (configurationB : AdvancedMinConfiguration treeB firstB secondB thirdB)
    (hfirst : configurationA.firstPath.HasDeletionWitness <->
      configurationB.firstPath.HasDeletionWitness)
    (hsecond : configurationA.secondPath.HasDeletionWitness <->
      configurationB.secondPath.HasDeletionWitness)
    (hthird : configurationA.thirdPath.HasDeletionWitness <->
      configurationB.thirdPath.HasDeletionWitness) :
    configurationA.witnessRetention = configurationB.witnessRetention := by
  classical
  by_cases hfirstA : configurationA.firstPath.HasDeletionWitness <;>
    by_cases hfirstB : configurationB.firstPath.HasDeletionWitness <;>
    by_cases hsecondA : configurationA.secondPath.HasDeletionWitness <;>
      by_cases hsecondB : configurationB.secondPath.HasDeletionWitness <;>
      by_cases hthirdA : configurationA.thirdPath.HasDeletionWitness <;>
        by_cases hthirdB : configurationB.thirdPath.HasDeletionWitness <;>
          simp_all [witnessRetention]

theorem witnessRetention_translate_of_nonnegative
    {k : Nat} {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    (delta : SymbolicShift)
    (hfirst : 0 <= first.shift.eval)
    (hfirstTranslated : 0 <= (first.translate delta).shift.eval)
    (hsecond : 0 <= second.shift.eval)
    (hsecondTranslated : 0 <= (second.translate delta).shift.eval)
    (hthird : 0 <= third.shift.eval)
    (hthirdTranslated : 0 <= (third.translate delta).shift.eval) :
    (configuration.translate delta).witnessRetention =
      configuration.witnessRetention := by
  apply witnessRetention_eq_of_witness_iff
  · exact configuration.firstPath
      |>.hasDeletionWitness_translate_iff_of_nonnegative delta
        hfirst hfirstTranslated
  · exact configuration.secondPath
      |>.hasDeletionWitness_translate_iff_of_nonnegative delta
        hsecond hsecondTranslated
  · exact configuration.thirdPath
      |>.hasDeletionWitness_translate_iff_of_nonnegative delta
        hthird hthirdTranslated

theorem witnessRetention_translate_of_sign_iff
    {k : Nat} {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    (delta : SymbolicShift)
    (hfirst : 0 <= (first.translate delta).shift.eval <->
      0 <= first.shift.eval)
    (hsecond : 0 <= (second.translate delta).shift.eval <->
      0 <= second.shift.eval)
    (hthird : 0 <= (third.translate delta).shift.eval <->
      0 <= third.shift.eval) :
    (configuration.translate delta).witnessRetention =
      configuration.witnessRetention := by
  apply witnessRetention_eq_of_witness_iff
  · exact configuration.firstPath
      |>.hasDeletionWitness_translate_iff_of_sign_iff delta hfirst
  · exact configuration.secondPath
      |>.hasDeletionWitness_translate_iff_of_sign_iff delta hsecond
  · exact configuration.thirdPath
      |>.hasDeletionWitness_translate_iff_of_sign_iff delta hthird

theorem reduceAt_witnessRetention_translate_of_nonnegative
    {k : Nat} {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    (delta : SymbolicShift)
    (hfirst : 0 <= first.shift.eval)
    (hfirstTranslated : 0 <= (first.translate delta).shift.eval)
    (hsecond : 0 <= second.shift.eval)
    (hsecondTranslated : 0 <= (second.translate delta).shift.eval)
    (hthird : 0 <= third.shift.eval)
    (hthirdTranslated : 0 <= (third.translate delta).shift.eval) :
    (configuration.translate delta).minPath.reduceAt
        (configuration.translate delta).witnessRetention =
      (configuration.minPath.reduceAt configuration.witnessRetention).translate
        delta := by
  rw [configuration.witnessRetention_translate_of_nonnegative delta
    hfirst hfirstTranslated hsecond hsecondTranslated hthird hthirdTranslated]
  exact configuration.minPath.reduceAt_translate
    configuration.witnessRetention delta

theorem reduceAt_witnessRetention_translate_of_sign_iff
    {k : Nat} {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    (delta : SymbolicShift)
    (hfirst : 0 <= (first.translate delta).shift.eval <->
      0 <= first.shift.eval)
    (hsecond : 0 <= (second.translate delta).shift.eval <->
      0 <= second.shift.eval)
    (hthird : 0 <= (third.translate delta).shift.eval <->
      0 <= third.shift.eval) :
    (configuration.translate delta).minPath.reduceAt
        (configuration.translate delta).witnessRetention =
      (configuration.minPath.reduceAt configuration.witnessRetention).translate
        delta := by
  rw [configuration.witnessRetention_translate_of_sign_iff delta
    hfirst hsecond hthird]
  exact configuration.minPath.reduceAt_translate
    configuration.witnessRetention delta

end TerminalPath.AdvancedMinConfiguration

namespace ExpandableOccurrence

def translate {k : Nat} {tree : ELTree k}
    (occurrence : ExpandableOccurrence tree) (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval) :
    ExpandableOccurrence (tree.translate delta) :=
  ⟨occurrence.target.translate delta, occurrence.path.translate delta, hshift⟩

@[simp] theorem translate_target {k : Nat} {tree : ELTree k}
    (occurrence : ExpandableOccurrence tree) (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval) :
    (occurrence.translate delta hshift).target =
      occurrence.target.translate delta := rfl

theorem split_translate {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval) :
    (occurrence.translate delta hshift).split hp =
      (occurrence.split hp).translate delta := by
  exact occurrence.path.splitAt_translate hp delta

theorem d1Configuration_translate_heq {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval)
    (hm : occurrence.target.mode.1.1 % 9 = 2) :
    HEq ((occurrence.d1Configuration hp hm).translate delta)
      ((occurrence.translate delta hshift).d1Configuration hp
        (by simpa using hm)) := by
  let source := TerminalPath.sourceD1AdvancedConfigurationData hp
    occurrence.target hm
  let translatedSource := TerminalPath.sourceD1AdvancedConfigurationData hp
    (occurrence.target.translate delta) (by simpa using hm)
  have hdescent : HEq
      ((source.descendSplit hp occurrence.path).translate delta)
      ((source.translateSourceSplit hp delta).descendSplit hp
        (occurrence.path.translate delta)) := by
    exact source.descendSplit_translate_heq hp occurrence.path delta
  have hsource : HEq (source.translateSourceSplit hp delta)
      translatedSource := by
    exact TerminalPath.AdvancedMinConfiguration.sourceD1AdvancedConfigurationData_translateSourceSplit_heq
      hp occurrence.target hm delta
  have hcanonical : HEq
      ((source.translateSourceSplit hp delta).descendSplit hp
        (occurrence.path.translate delta))
      (translatedSource.descendSplit hp (occurrence.path.translate delta)) := by
    exact TerminalPath.AdvancedMinConfiguration.descendSplit_heq_of_heq hp
      (source.translateSourceSplit hp delta) translatedSource
      (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 0).symm
      (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 1).symm
      (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 2).symm
      hsource (occurrence.path.translate delta)
  simpa [source, translatedSource, d1Configuration,
    ExpandableOccurrence.translate] using hdescent.trans hcanonical

theorem d3Configuration_translate_heq {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval)
    (hm : occurrence.target.mode.1.1 % 9 = 8) :
    HEq ((occurrence.d3Configuration hp hm).translate delta)
      ((occurrence.translate delta hshift).d3Configuration hp
        (by simpa using hm)) := by
  let source := TerminalPath.sourceD3AdvancedConfigurationData hp
    occurrence.target hm
  let translatedSource := TerminalPath.sourceD3AdvancedConfigurationData hp
    (occurrence.target.translate delta) (by simpa using hm)
  have hdescent : HEq
      ((source.descendSplit hp occurrence.path).translate delta)
      ((source.translateSourceSplit hp delta).descendSplit hp
        (occurrence.path.translate delta)) := by
    exact source.descendSplit_translate_heq hp occurrence.path delta
  have hsource : HEq (source.translateSourceSplit hp delta)
      translatedSource := by
    exact TerminalPath.AdvancedMinConfiguration.sourceD3AdvancedConfigurationData_translateSourceSplit_heq
      hp occurrence.target hm delta
  have hcanonical : HEq
      ((source.translateSourceSplit hp delta).descendSplit hp
        (occurrence.path.translate delta))
      (translatedSource.descendSplit hp (occurrence.path.translate delta)) := by
    exact TerminalPath.AdvancedMinConfiguration.descendSplit_heq_of_heq hp
      (source.translateSourceSplit hp delta) translatedSource
      (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 0).symm
      (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 1).symm
      (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 2).symm
      hsource (occurrence.path.translate delta)
  simpa [source, translatedSource, d3Configuration,
    ExpandableOccurrence.translate] using hdescent.trans hcanonical

theorem d1Configuration_witnessRetention_translate {p : Nat}
    (hp : 1 <= p) {tree : ELTree (p + 1)}
    (occurrence : ExpandableOccurrence tree) (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval)
    (hm : occurrence.target.mode.1.1 % 9 = 2)
    (hfirst : 0 <= (d1AdvancedSplitLabel hp occurrence.target hm 0).shift.eval)
    (hfirstTranslated : 0 <= ((d1AdvancedSplitLabel hp occurrence.target hm 0)
      |>.translate delta).shift.eval)
    (hsecond : 0 <= (d1AdvancedSplitLabel hp occurrence.target hm 1).shift.eval)
    (hsecondTranslated : 0 <= ((d1AdvancedSplitLabel hp occurrence.target hm 1)
      |>.translate delta).shift.eval)
    (hthird : 0 <= (d1AdvancedSplitLabel hp occurrence.target hm 2).shift.eval)
    (hthirdTranslated : 0 <= ((d1AdvancedSplitLabel hp occurrence.target hm 2)
      |>.translate delta).shift.eval) :
    ((occurrence.translate delta hshift).d1Configuration hp
        (by simpa using hm)).witnessRetention =
      (occurrence.d1Configuration hp hm).witnessRetention := by
  let original := occurrence.d1Configuration hp hm
  let translated := (occurrence.translate delta hshift).d1Configuration hp
    (by simpa using hm)
  have hconfiguration : HEq (original.translate delta) translated := by
    exact occurrence.d1Configuration_translate_heq hp delta hshift hm
  have htree : (occurrence.split hp).translate delta =
      (occurrence.translate delta hshift).split hp := by
    exact (occurrence.split_translate hp delta hshift).symm
  have hretention : (original.translate delta).witnessRetention =
      translated.witnessRetention := by
    exact TerminalPath.AdvancedMinConfiguration.witnessRetention_eq_of_heq
      (original.translate delta) translated htree
      (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 0).symm
      (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 1).symm
      (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 2).symm
      hconfiguration
  have hinvariant : (original.translate delta).witnessRetention =
      original.witnessRetention := by
    exact original.witnessRetention_translate_of_nonnegative delta
      hfirst hfirstTranslated hsecond hsecondTranslated hthird hthirdTranslated
  exact hretention.symm.trans hinvariant

theorem d3Configuration_witnessRetention_translate {p : Nat}
    (hp : 1 <= p) {tree : ELTree (p + 1)}
    (occurrence : ExpandableOccurrence tree) (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval)
    (hm : occurrence.target.mode.1.1 % 9 = 8)
    (hfirst : 0 <= (d3AdvancedSplitLabel hp occurrence.target hm 0).shift.eval)
    (hfirstTranslated : 0 <= ((d3AdvancedSplitLabel hp occurrence.target hm 0)
      |>.translate delta).shift.eval)
    (hsecond : 0 <= (d3AdvancedSplitLabel hp occurrence.target hm 1).shift.eval)
    (hsecondTranslated : 0 <= ((d3AdvancedSplitLabel hp occurrence.target hm 1)
      |>.translate delta).shift.eval)
    (hthird : 0 <= (d3AdvancedSplitLabel hp occurrence.target hm 2).shift.eval)
    (hthirdTranslated : 0 <= ((d3AdvancedSplitLabel hp occurrence.target hm 2)
      |>.translate delta).shift.eval) :
    ((occurrence.translate delta hshift).d3Configuration hp
        (by simpa using hm)).witnessRetention =
      (occurrence.d3Configuration hp hm).witnessRetention := by
  let original := occurrence.d3Configuration hp hm
  let translated := (occurrence.translate delta hshift).d3Configuration hp
    (by simpa using hm)
  have hconfiguration : HEq (original.translate delta) translated := by
    exact occurrence.d3Configuration_translate_heq hp delta hshift hm
  have htree : (occurrence.split hp).translate delta =
      (occurrence.translate delta hshift).split hp := by
    exact (occurrence.split_translate hp delta hshift).symm
  have hretention : (original.translate delta).witnessRetention =
      translated.witnessRetention := by
    exact TerminalPath.AdvancedMinConfiguration.witnessRetention_eq_of_heq
      (original.translate delta) translated htree
      (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 0).symm
      (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 1).symm
      (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 2).symm
      hconfiguration
  have hinvariant : (original.translate delta).witnessRetention =
      original.witnessRetention := by
    exact original.witnessRetention_translate_of_nonnegative delta
      hfirst hfirstTranslated hsecond hsecondTranslated hthird hthirdTranslated
  exact hretention.symm.trans hinvariant

theorem d1Configuration_witnessRetention_translate_of_sign_iff {p : Nat}
    (hp : 1 <= p) {tree : ELTree (p + 1)}
    (occurrence : ExpandableOccurrence tree) (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval)
    (hm : occurrence.target.mode.1.1 % 9 = 2)
    (hfirst : 0 <= ((d1AdvancedSplitLabel hp occurrence.target hm 0)
        |>.translate delta).shift.eval <->
      0 <= (d1AdvancedSplitLabel hp occurrence.target hm 0).shift.eval)
    (hsecond : 0 <= ((d1AdvancedSplitLabel hp occurrence.target hm 1)
        |>.translate delta).shift.eval <->
      0 <= (d1AdvancedSplitLabel hp occurrence.target hm 1).shift.eval)
    (hthird : 0 <= ((d1AdvancedSplitLabel hp occurrence.target hm 2)
        |>.translate delta).shift.eval <->
      0 <= (d1AdvancedSplitLabel hp occurrence.target hm 2).shift.eval) :
    ((occurrence.translate delta hshift).d1Configuration hp
        (by simpa using hm)).witnessRetention =
      (occurrence.d1Configuration hp hm).witnessRetention := by
  let original := occurrence.d1Configuration hp hm
  let translated := (occurrence.translate delta hshift).d1Configuration hp
    (by simpa using hm)
  have hconfiguration : HEq (original.translate delta) translated := by
    exact occurrence.d1Configuration_translate_heq hp delta hshift hm
  have htree : (occurrence.split hp).translate delta =
      (occurrence.translate delta hshift).split hp := by
    exact (occurrence.split_translate hp delta hshift).symm
  have hretention : (original.translate delta).witnessRetention =
      translated.witnessRetention := by
    exact TerminalPath.AdvancedMinConfiguration.witnessRetention_eq_of_heq
      (original.translate delta) translated htree
      (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 0).symm
      (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 1).symm
      (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 2).symm
      hconfiguration
  have hinvariant : (original.translate delta).witnessRetention =
      original.witnessRetention := by
    exact original.witnessRetention_translate_of_sign_iff delta
      hfirst hsecond hthird
  exact hretention.symm.trans hinvariant

theorem d3Configuration_witnessRetention_translate_of_sign_iff {p : Nat}
    (hp : 1 <= p) {tree : ELTree (p + 1)}
    (occurrence : ExpandableOccurrence tree) (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval)
    (hm : occurrence.target.mode.1.1 % 9 = 8)
    (hfirst : 0 <= ((d3AdvancedSplitLabel hp occurrence.target hm 0)
        |>.translate delta).shift.eval <->
      0 <= (d3AdvancedSplitLabel hp occurrence.target hm 0).shift.eval)
    (hsecond : 0 <= ((d3AdvancedSplitLabel hp occurrence.target hm 1)
        |>.translate delta).shift.eval <->
      0 <= (d3AdvancedSplitLabel hp occurrence.target hm 1).shift.eval)
    (hthird : 0 <= ((d3AdvancedSplitLabel hp occurrence.target hm 2)
        |>.translate delta).shift.eval <->
      0 <= (d3AdvancedSplitLabel hp occurrence.target hm 2).shift.eval) :
    ((occurrence.translate delta hshift).d3Configuration hp
        (by simpa using hm)).witnessRetention =
      (occurrence.d3Configuration hp hm).witnessRetention := by
  let original := occurrence.d3Configuration hp hm
  let translated := (occurrence.translate delta hshift).d3Configuration hp
    (by simpa using hm)
  have hconfiguration : HEq (original.translate delta) translated := by
    exact occurrence.d3Configuration_translate_heq hp delta hshift hm
  have htree : (occurrence.split hp).translate delta =
      (occurrence.translate delta hshift).split hp := by
    exact (occurrence.split_translate hp delta hshift).symm
  have hretention : (original.translate delta).witnessRetention =
      translated.witnessRetention := by
    exact TerminalPath.AdvancedMinConfiguration.witnessRetention_eq_of_heq
      (original.translate delta) translated htree
      (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 0).symm
      (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 1).symm
      (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 2).symm
      hconfiguration
  have hinvariant : (original.translate delta).witnessRetention =
      original.witnessRetention := by
    exact original.witnessRetention_translate_of_sign_iff delta
      hfirst hsecond hthird
  exact hretention.symm.trans hinvariant

theorem sourceStep_translate_d1 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval)
    (hm : occurrence.target.mode.1.1 % 9 = 2)
    (hfirst : 0 <= (d1AdvancedSplitLabel hp occurrence.target hm 0).shift.eval)
    (hfirstTranslated : 0 <= ((d1AdvancedSplitLabel hp occurrence.target hm 0)
      |>.translate delta).shift.eval)
    (hsecond : 0 <= (d1AdvancedSplitLabel hp occurrence.target hm 1).shift.eval)
    (hsecondTranslated : 0 <= ((d1AdvancedSplitLabel hp occurrence.target hm 1)
      |>.translate delta).shift.eval)
    (hthird : 0 <= (d1AdvancedSplitLabel hp occurrence.target hm 2).shift.eval)
    (hthirdTranslated : 0 <= ((d1AdvancedSplitLabel hp occurrence.target hm 2)
      |>.translate delta).shift.eval) :
    (occurrence.translate delta hshift).sourceStep hp =
      (occurrence.sourceStep hp).translate delta := by
  rw [(occurrence.translate delta hshift).sourceStep_eq_d1 hp
      (by simpa using hm), occurrence.sourceStep_eq_d1 hp hm]
  let original := occurrence.d1Configuration hp hm
  let translated := (occurrence.translate delta hshift).d1Configuration hp
    (by simpa using hm)
  change translated.minPath.reduceAt translated.witnessRetention =
    (original.minPath.reduceAt original.witnessRetention).translate delta
  have hconfiguration : HEq (original.translate delta) translated := by
    exact occurrence.d1Configuration_translate_heq hp delta hshift hm
  have htree : (occurrence.split hp).translate delta =
      (occurrence.translate delta hshift).split hp := by
    exact (occurrence.split_translate hp delta hshift).symm
  have hreduce :
      (original.translate delta).minPath.reduceAt
          (original.translate delta).witnessRetention =
        translated.minPath.reduceAt translated.witnessRetention := by
    exact TerminalPath.AdvancedMinConfiguration.reduceAt_witnessRetention_eq_of_heq
      (original.translate delta) translated htree
        (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 0).symm
        (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 1).symm
        (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 2).symm
        hconfiguration
  have hinvariant :
      (original.translate delta).minPath.reduceAt
          (original.translate delta).witnessRetention =
        (original.minPath.reduceAt original.witnessRetention).translate delta := by
    exact original.reduceAt_witnessRetention_translate_of_nonnegative delta
      hfirst hfirstTranslated hsecond hsecondTranslated hthird hthirdTranslated
  exact hreduce.symm.trans hinvariant

theorem sourceStep_translate_d3 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval)
    (hm : occurrence.target.mode.1.1 % 9 = 8)
    (hfirst : 0 <= (d3AdvancedSplitLabel hp occurrence.target hm 0).shift.eval)
    (hfirstTranslated : 0 <= ((d3AdvancedSplitLabel hp occurrence.target hm 0)
      |>.translate delta).shift.eval)
    (hsecond : 0 <= (d3AdvancedSplitLabel hp occurrence.target hm 1).shift.eval)
    (hsecondTranslated : 0 <= ((d3AdvancedSplitLabel hp occurrence.target hm 1)
      |>.translate delta).shift.eval)
    (hthird : 0 <= (d3AdvancedSplitLabel hp occurrence.target hm 2).shift.eval)
    (hthirdTranslated : 0 <= ((d3AdvancedSplitLabel hp occurrence.target hm 2)
      |>.translate delta).shift.eval) :
    (occurrence.translate delta hshift).sourceStep hp =
      (occurrence.sourceStep hp).translate delta := by
  rw [(occurrence.translate delta hshift).sourceStep_eq_d3 hp
      (by simpa using hm), occurrence.sourceStep_eq_d3 hp hm]
  let original := occurrence.d3Configuration hp hm
  let translated := (occurrence.translate delta hshift).d3Configuration hp
    (by simpa using hm)
  change translated.minPath.reduceAt translated.witnessRetention =
    (original.minPath.reduceAt original.witnessRetention).translate delta
  have hconfiguration : HEq (original.translate delta) translated := by
    exact occurrence.d3Configuration_translate_heq hp delta hshift hm
  have htree : (occurrence.split hp).translate delta =
      (occurrence.translate delta hshift).split hp := by
    exact (occurrence.split_translate hp delta hshift).symm
  have hreduce :
      (original.translate delta).minPath.reduceAt
          (original.translate delta).witnessRetention =
        translated.minPath.reduceAt translated.witnessRetention := by
    exact TerminalPath.AdvancedMinConfiguration.reduceAt_witnessRetention_eq_of_heq
      (original.translate delta) translated htree
        (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 0).symm
        (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 1).symm
        (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 2).symm
        hconfiguration
  have hinvariant :
      (original.translate delta).minPath.reduceAt
          (original.translate delta).witnessRetention =
        (original.minPath.reduceAt original.witnessRetention).translate delta := by
    exact original.reduceAt_witnessRetention_translate_of_nonnegative delta
      hfirst hfirstTranslated hsecond hsecondTranslated hthird hthirdTranslated
  exact hreduce.symm.trans hinvariant

theorem sourceStep_translate_d1_of_sign_iff {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval)
    (hm : occurrence.target.mode.1.1 % 9 = 2)
    (hfirst : 0 <= ((d1AdvancedSplitLabel hp occurrence.target hm 0)
        |>.translate delta).shift.eval <->
      0 <= (d1AdvancedSplitLabel hp occurrence.target hm 0).shift.eval)
    (hsecond : 0 <= ((d1AdvancedSplitLabel hp occurrence.target hm 1)
        |>.translate delta).shift.eval <->
      0 <= (d1AdvancedSplitLabel hp occurrence.target hm 1).shift.eval)
    (hthird : 0 <= ((d1AdvancedSplitLabel hp occurrence.target hm 2)
        |>.translate delta).shift.eval <->
      0 <= (d1AdvancedSplitLabel hp occurrence.target hm 2).shift.eval) :
    (occurrence.translate delta hshift).sourceStep hp =
      (occurrence.sourceStep hp).translate delta := by
  rw [(occurrence.translate delta hshift).sourceStep_eq_d1 hp
      (by simpa using hm), occurrence.sourceStep_eq_d1 hp hm]
  let original := occurrence.d1Configuration hp hm
  let translated := (occurrence.translate delta hshift).d1Configuration hp
    (by simpa using hm)
  change translated.minPath.reduceAt translated.witnessRetention =
    (original.minPath.reduceAt original.witnessRetention).translate delta
  have hconfiguration : HEq (original.translate delta) translated := by
    exact occurrence.d1Configuration_translate_heq hp delta hshift hm
  have htree : (occurrence.split hp).translate delta =
      (occurrence.translate delta hshift).split hp := by
    exact (occurrence.split_translate hp delta hshift).symm
  have hreduce :
      (original.translate delta).minPath.reduceAt
          (original.translate delta).witnessRetention =
        translated.minPath.reduceAt translated.witnessRetention := by
    exact TerminalPath.AdvancedMinConfiguration.reduceAt_witnessRetention_eq_of_heq
      (original.translate delta) translated htree
        (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 0).symm
        (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 1).symm
        (d1AdvancedSplitLabel_translate hp occurrence.target hm delta 2).symm
        hconfiguration
  have hinvariant :
      (original.translate delta).minPath.reduceAt
          (original.translate delta).witnessRetention =
        (original.minPath.reduceAt original.witnessRetention).translate delta := by
    exact original.reduceAt_witnessRetention_translate_of_sign_iff delta
      hfirst hsecond hthird
  exact hreduce.symm.trans hinvariant

theorem sourceStep_translate_d3_of_sign_iff {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval)
    (hm : occurrence.target.mode.1.1 % 9 = 8)
    (hfirst : 0 <= ((d3AdvancedSplitLabel hp occurrence.target hm 0)
        |>.translate delta).shift.eval <->
      0 <= (d3AdvancedSplitLabel hp occurrence.target hm 0).shift.eval)
    (hsecond : 0 <= ((d3AdvancedSplitLabel hp occurrence.target hm 1)
        |>.translate delta).shift.eval <->
      0 <= (d3AdvancedSplitLabel hp occurrence.target hm 1).shift.eval)
    (hthird : 0 <= ((d3AdvancedSplitLabel hp occurrence.target hm 2)
        |>.translate delta).shift.eval <->
      0 <= (d3AdvancedSplitLabel hp occurrence.target hm 2).shift.eval) :
    (occurrence.translate delta hshift).sourceStep hp =
      (occurrence.sourceStep hp).translate delta := by
  rw [(occurrence.translate delta hshift).sourceStep_eq_d3 hp
      (by simpa using hm), occurrence.sourceStep_eq_d3 hp hm]
  let original := occurrence.d3Configuration hp hm
  let translated := (occurrence.translate delta hshift).d3Configuration hp
    (by simpa using hm)
  change translated.minPath.reduceAt translated.witnessRetention =
    (original.minPath.reduceAt original.witnessRetention).translate delta
  have hconfiguration : HEq (original.translate delta) translated := by
    exact occurrence.d3Configuration_translate_heq hp delta hshift hm
  have htree : (occurrence.split hp).translate delta =
      (occurrence.translate delta hshift).split hp := by
    exact (occurrence.split_translate hp delta hshift).symm
  have hreduce :
      (original.translate delta).minPath.reduceAt
          (original.translate delta).witnessRetention =
        translated.minPath.reduceAt translated.witnessRetention := by
    exact TerminalPath.AdvancedMinConfiguration.reduceAt_witnessRetention_eq_of_heq
      (original.translate delta) translated htree
        (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 0).symm
        (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 1).symm
        (d3AdvancedSplitLabel_translate hp occurrence.target hm delta 2).symm
        hconfiguration
  have hinvariant :
      (original.translate delta).minPath.reduceAt
          (original.translate delta).witnessRetention =
        (original.minPath.reduceAt original.witnessRetention).translate delta := by
    exact original.reduceAt_witnessRetention_translate_of_sign_iff delta
      hfirst hsecond hthird
  exact hreduce.symm.trans hinvariant

theorem sourceStep_translate_d2 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval)
    (hm : occurrence.target.mode.1.1 % 9 = 5) :
    (occurrence.translate delta hshift).sourceStep hp =
      (occurrence.sourceStep hp).translate delta := by
  rw [(occurrence.translate delta hshift).sourceStep_eq_d2 hp (by simpa using hm),
    occurrence.sourceStep_eq_d2 hp hm]
  exact occurrence.split_translate hp delta hshift

def SourceStepEligibilityEquivalent {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (delta : SymbolicShift) : Prop :=
  (forall (hm : occurrence.target.mode.1.1 % 9 = 2) (j : Fin 3),
    (0 <= ((d1AdvancedSplitLabel hp occurrence.target hm j).translate delta).shift.eval <->
      0 <= (d1AdvancedSplitLabel hp occurrence.target hm j).shift.eval)) /\
  (forall (hm : occurrence.target.mode.1.1 % 9 = 8) (j : Fin 3),
    (0 <= ((d3AdvancedSplitLabel hp occurrence.target hm j).translate delta).shift.eval <->
      0 <= (d3AdvancedSplitLabel hp occurrence.target hm j).shift.eval))

theorem sourceStep_translate_of_eligibility {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval)
    (heligibility : occurrence.SourceStepEligibilityEquivalent hp delta) :
    (occurrence.translate delta hshift).sourceStep hp =
      (occurrence.sourceStep hp).translate delta := by
  rcases trackedMode_mod_nine_cases occurrence.target.mode with hm2 | hm5 | hm8
  · exact occurrence.sourceStep_translate_d1_of_sign_iff hp delta hshift hm2
      (heligibility.1 hm2 0) (heligibility.1 hm2 1)
      (heligibility.1 hm2 2)
  · exact occurrence.sourceStep_translate_d2 hp delta hshift hm5
  · exact occurrence.sourceStep_translate_d3_of_sign_iff hp delta hshift hm8
      (heligibility.2 hm8 0) (heligibility.2 hm8 1)
      (heligibility.2 hm8 2)

end ExpandableOccurrence

def TerminalEligibilityEquivalent {k : Nat} (delta : SymbolicShift) :
    ELTree k -> Prop
  | .terminal label =>
      0 <= (label.translate delta).shift.eval <-> 0 <= label.shift.eval
  | .expanded _ body => body.TerminalEligibilityEquivalent delta
  | .add left right | .min2 left right =>
      left.TerminalEligibilityEquivalent delta /\
        right.TerminalEligibilityEquivalent delta
  | .min3 first second third =>
      first.TerminalEligibilityEquivalent delta /\
        second.TerminalEligibilityEquivalent delta /\
          third.TerminalEligibilityEquivalent delta

theorem terminalEligibilityEquivalent_terminal_zero_iff {k : Nat}
    (mode : TrackedMode k) (delta : SymbolicShift) :
    TerminalEligibilityEquivalent delta
        (ELTree.terminal (ELLabel.mk mode SymbolicShift.zero)) <->
      0 <= delta.eval := by
  simp [TerminalEligibilityEquivalent, ELLabel.translate_shift_eval,
    SymbolicShift.eval_add, SymbolicShift.eval_zero]

theorem not_terminalEligibilityEquivalent_terminal_zero_of_delta_neg
    {k : Nat} (mode : TrackedMode k) (delta : SymbolicShift)
    (hdelta : delta.eval < 0) :
    Not (TerminalEligibilityEquivalent delta
      (ELTree.terminal (ELLabel.mk mode SymbolicShift.zero))) := by
  rw [terminalEligibilityEquivalent_terminal_zero_iff]
  exact not_le_of_gt hdelta

theorem deletionWitness_depends_on_outer_context {k : Nat}
    (mode : TrackedMode k) :
    let leaf : ELLabel k := ELLabel.mk mode (SymbolicShift.mk 0 1)
    let ancestor : ELLabel k := ELLabel.mk mode SymbolicShift.zero
    let bare : TerminalPath (ELTree.terminal leaf) leaf :=
      TerminalPath.here leaf
    let nested : TerminalPath
        (ELTree.expanded ancestor (ELTree.terminal leaf)) leaf :=
      TerminalPath.expanded ancestor (ELTree.terminal leaf) leaf
        (TerminalPath.here leaf)
    Not bare.HasDeletionWitness /\ nested.HasDeletionWitness := by
  dsimp
  constructor
  · intro hwitness
    rcases hwitness.2 with ⟨ancestor, hmember, _⟩
    simp [TerminalPath.leafState, TerminalPath.context,
      ELTree.Context.expandedLabels] at hmember
  · constructor
    · norm_num [TerminalPath.leafState, SymbolicShift.eval]
    · refine ⟨ELLabel.mk mode SymbolicShift.zero, ?_, rfl, ?_⟩
      · simp [TerminalPath.leafState, TerminalPath.context,
          ELTree.Context.expandedLabels]
      · norm_num [TerminalPath.leafState, SymbolicShift.zero,
          SymbolicShift.eval]

theorem terminalShiftsNegative_translate_of_delta_nonpos {k : Nat}
    (tree : ELTree k) (delta : SymbolicShift) (hdelta : delta.eval <= 0)
    (hnegative : tree.TerminalShiftsNegative) :
    (tree.translate delta).TerminalShiftsNegative := by
  induction tree with
  | terminal label =>
      simp only [ELTree.translate, TerminalShiftsNegative]
      rw [ELLabel.translate_shift_eval]
      exact add_neg_of_nonpos_of_neg hdelta hnegative
  | expanded label body ih =>
      exact ih hnegative
  | add left right ihLeft ihRight =>
      exact ⟨ihLeft hnegative.1, ihRight hnegative.2⟩
  | min2 left right ihLeft ihRight =>
      exact ⟨ihLeft hnegative.1, ihRight hnegative.2⟩
  | min3 first second third ihFirst ihSecond ihThird =>
      exact ⟨ihFirst hnegative.1,
        ihSecond hnegative.2.1, ihThird hnegative.2.2⟩

theorem findExpandableOccurrence_translate_eq_none_of_delta_nonpos
    {k : Nat} (tree : ELTree k) (delta : SymbolicShift)
    (hdelta : delta.eval <= 0)
    (hfind : findExpandableOccurrence tree = none) :
    findExpandableOccurrence (tree.translate delta) = none := by
  apply (findExpandableOccurrence_eq_none_iff (tree.translate delta)).2
  exact tree.terminalShiftsNegative_translate_of_delta_nonpos delta hdelta
    ((findExpandableOccurrence_eq_none_iff tree).1 hfind)

private theorem negative_iff_of_nonnegative_iff {x y : Real}
    (h : 0 <= x <-> 0 <= y) : x < 0 <-> y < 0 := by
  constructor
  · intro hx
    have hnot : Not (0 <= x) := not_le_of_gt hx
    exact lt_of_not_ge (fun hy => hnot (h.mpr hy))
  · intro hy
    have hnot : Not (0 <= y) := not_le_of_gt hy
    exact lt_of_not_ge (fun hx => hnot (h.mp hx))

theorem terminalShiftsNegative_translate_iff {k : Nat}
    (tree : ELTree k) (delta : SymbolicShift)
    (hsign : tree.TerminalEligibilityEquivalent delta) :
    (tree.translate delta).TerminalShiftsNegative <->
      tree.TerminalShiftsNegative := by
  induction tree with
  | terminal label =>
      exact negative_iff_of_nonnegative_iff hsign
  | expanded label body ih =>
      exact ih hsign
  | add left right ihLeft ihRight =>
      exact and_congr (ihLeft hsign.1) (ihRight hsign.2)
  | min2 left right ihLeft ihRight =>
      exact and_congr (ihLeft hsign.1) (ihRight hsign.2)
  | min3 first second third ihFirst ihSecond ihThird =>
      exact and_congr (ihFirst hsign.1)
        (and_congr (ihSecond hsign.2.1) (ihThird hsign.2.2))

theorem findExpandableOccurrence_translate_eq_none_iff {k : Nat}
    (tree : ELTree k) (delta : SymbolicShift)
    (hsign : tree.TerminalEligibilityEquivalent delta) :
    findExpandableOccurrence (tree.translate delta) = none <->
      findExpandableOccurrence tree = none := by
  rw [findExpandableOccurrence_eq_none_iff,
    findExpandableOccurrence_eq_none_iff]
  exact tree.terminalShiftsNegative_translate_iff delta hsign

namespace TerminalPath

theorem target_nonnegative_translate_iff_of_terminalEligibilityEquivalent
    {k : Nat} {tree : ELTree k} {target : ELLabel k}
    (path : TerminalPath tree target) (delta : SymbolicShift)
    (hsign : tree.TerminalEligibilityEquivalent delta) :
    0 <= (target.translate delta).shift.eval <->
      0 <= target.shift.eval := by
  induction path with
  | here label => exact hsign
  | expanded label body target path ih => exact ih hsign
  | addLeft left right target path ih => exact ih hsign.1
  | addRight left right target path ih => exact ih hsign.2
  | min2Left left right target path ih => exact ih hsign.1
  | min2Right left right target path ih => exact ih hsign.2
  | minFirst first second third target path ih => exact ih hsign.1
  | minSecond first second third target path ih => exact ih hsign.2.1
  | minThird first second third target path ih => exact ih hsign.2.2

end TerminalPath

theorem findExpandableOccurrence_translate {k : Nat}
    (tree : ELTree k) (delta : SymbolicShift)
    (hsign : tree.TerminalEligibilityEquivalent delta) :
    findExpandableOccurrence (tree.translate delta) =
      (findExpandableOccurrence tree).map fun occurrence =>
        occurrence.translate delta
          ((occurrence.path
            |>.target_nonnegative_translate_iff_of_terminalEligibilityEquivalent
              delta hsign).mpr occurrence.shift_nonnegative) := by
  classical
  induction tree with
  | terminal label =>
      by_cases horiginal : 0 <= label.shift.eval
      · have htranslated : 0 <= (label.translate delta).shift.eval :=
          hsign.mpr horiginal
        have htranslated' : 0 <= delta.eval + label.shift.eval := by
          simpa [ELLabel.translate, SymbolicShift.eval_add] using htranslated
        simp [ELTree.translate, findExpandableOccurrence, horiginal,
          htranslated, htranslated', ExpandableOccurrence.translate,
          TerminalPath.translate,
          ELLabel.translate, SymbolicShift.eval_add]
      · have htranslated : Not (0 <= (label.translate delta).shift.eval) :=
          fun h => horiginal (hsign.mp h)
        have htranslated' : delta.eval + label.shift.eval < 0 := by
          have hlt := lt_of_not_ge htranslated
          simpa [ELLabel.translate, SymbolicShift.eval_add] using hlt
        simp [ELTree.translate, findExpandableOccurrence, horiginal,
          htranslated, htranslated', ELLabel.translate,
          SymbolicShift.eval_add]
  | expanded label body ih =>
      simp only [ELTree.translate, findExpandableOccurrence]
      rw [ih hsign]
      generalize hbody : findExpandableOccurrence body = result
      cases result <;>
        simp [hbody, ExpandableOccurrence.translate, TerminalPath.translate]
  | add left right ihLeft ihRight =>
      simp only [ELTree.translate, findExpandableOccurrence]
      rw [ihLeft hsign.1, ihRight hsign.2]
      generalize hleft : findExpandableOccurrence left = leftResult
      cases leftResult with
      | some occurrence =>
          simp [hleft, ExpandableOccurrence.translate, TerminalPath.translate]
      | none =>
          generalize hright : findExpandableOccurrence right = rightResult
          cases rightResult <;>
            simp [hleft, hright, ExpandableOccurrence.translate,
              TerminalPath.translate]
  | min2 left right ihLeft ihRight =>
      simp only [ELTree.translate, findExpandableOccurrence]
      rw [ihLeft hsign.1, ihRight hsign.2]
      generalize hleft : findExpandableOccurrence left = leftResult
      cases leftResult with
      | some occurrence =>
          simp [hleft, ExpandableOccurrence.translate, TerminalPath.translate]
      | none =>
          generalize hright : findExpandableOccurrence right = rightResult
          cases rightResult <;>
            simp [hleft, hright, ExpandableOccurrence.translate,
              TerminalPath.translate]
  | min3 first second third ihFirst ihSecond ihThird =>
      simp only [ELTree.translate, findExpandableOccurrence]
      rw [ihFirst hsign.1, ihSecond hsign.2.1, ihThird hsign.2.2]
      generalize hfirst : findExpandableOccurrence first = firstResult
      cases firstResult with
      | some occurrence =>
          simp [hfirst, ExpandableOccurrence.translate,
            TerminalPath.translate]
      | none =>
          generalize hsecond : findExpandableOccurrence second = secondResult
          cases secondResult with
          | some occurrence =>
              simp [hfirst, hsecond, ExpandableOccurrence.translate,
                TerminalPath.translate]
          | none =>
              generalize hthird : findExpandableOccurrence third = thirdResult
              cases thirdResult <;>
                simp [hfirst, hsecond, hthird, ExpandableOccurrence.translate,
                  TerminalPath.translate]

theorem sourceScheduledStep_translate {p : Nat} (hp : 1 <= p)
    (tree : ELTree (p + 1)) (delta : SymbolicShift)
    (hsign : tree.TerminalEligibilityEquivalent delta)
    (hstep : forall occurrence, findExpandableOccurrence tree = some occurrence ->
      occurrence.SourceStepEligibilityEquivalent hp delta) :
    sourceScheduledStep hp (tree.translate delta) =
      (sourceScheduledStep hp tree).translate delta := by
  classical
  have hfinder := tree.findExpandableOccurrence_translate delta hsign
  generalize hresult : findExpandableOccurrence tree = result
  cases result with
  | none =>
      have htranslated : findExpandableOccurrence (tree.translate delta) = none := by
        simpa [hresult] using hfinder
      simp [sourceScheduledStep, hresult, htranslated]
  | some occurrence =>
      have htarget := occurrence.path
        |>.target_nonnegative_translate_iff_of_terminalEligibilityEquivalent
          delta hsign
      have hshift : 0 <= (occurrence.target.translate delta).shift.eval :=
        htarget.mpr occurrence.shift_nonnegative
      have htranslated : findExpandableOccurrence (tree.translate delta) =
          some (occurrence.translate delta hshift) := by
        simpa [hresult] using hfinder
      simp only [sourceScheduledStep]
      rw [hresult, htranslated]
      exact occurrence.sourceStep_translate_of_eligibility hp delta hshift
        (hstep occurrence hresult)

inductive RawSourceSplitStep {p : Nat} (hp : 1 <= p) :
    ELTree (p + 1) -> ELTree (p + 1) -> Prop
  | split {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
      (path : TerminalPath tree target) :
      RawSourceSplitStep hp tree (path.splitAt hp)

namespace RawSourceSplitStep

theorem translate {p : Nat} {hp : 1 <= p}
    {tree next : ELTree (p + 1)}
    (step : RawSourceSplitStep hp tree next) (delta : SymbolicShift) :
    RawSourceSplitStep hp (tree.translate delta) (next.translate delta) := by
  cases step with
  | split path =>
      rw [← path.splitAt_translate hp delta]
      exact .split (path.translate delta)

end RawSourceSplitStep

theorem rawSourceSplitSteps_translate {p : Nat} {hp : 1 <= p}
    {tree next : ELTree (p + 1)}
    (steps : Relation.ReflTransGen (RawSourceSplitStep hp) tree next)
    (delta : SymbolicShift) :
    Relation.ReflTransGen (RawSourceSplitStep hp)
      (tree.translate delta) (next.translate delta) := by
  induction steps with
  | refl => exact .refl
  | tail hprefix hstep ih => exact ih.tail (hstep.translate delta)

end ELTree

end KL2003
end CollatzClassical
