import CollatzClassical.KL2003.KL2003K3CertificateDataGenerated
import CollatzClassical.KL2003.KL2003K2AlphaBounds
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace CollatzClassical
namespace KL2003
namespace K3Verifier

open GeneratedK3

def L3NTPrincipalInBox : Prop :=
  1 <= c3_2 ∧ 1 <= c3_5 ∧ 1 <= c3_8 ∧
  1 <= c3_11 ∧ 1 <= c3_14 ∧ 1 <= c3_17 ∧
  1 <= c3_20 ∧ 1 <= c3_23 ∧ 1 <= c3_26

def L3NTAuxiliaryInBox : Prop :=
  1 <= c2_2 ∧ 1 <= c2_5 ∧ 1 <= c2_8 ∧
  c2_2 <= c3_2 ∧ c2_2 <= c3_11 ∧ c2_2 <= c3_20 ∧
  c2_5 <= c3_5 ∧ c2_5 <= c3_14 ∧ c2_5 <= c3_23 ∧
  c2_8 <= c3_8 ∧ c2_8 <= c3_17 ∧ c2_8 <= c3_26

def L3NTRowEquationsHold : Prop :=
  aCoeff * c3_8 + bLower * c2_2 - c3_2 = slack_m2 ∧
  aCoeff * c3_20 - c3_5 = slack_m5 ∧
  aCoeff * c3_5 + dLower * c2_5 - c3_8 = slack_m8 ∧
  aCoeff * c3_17 + bLower * c2_5 - c3_11 = slack_m11 ∧
  aCoeff * c3_2 - c3_14 = slack_m14 ∧
  aCoeff * c3_14 + dLower * c2_2 - c3_17 = slack_m17 ∧
  aCoeff * c3_26 + bLower * c2_8 - c3_20 = slack_m20 ∧
  aCoeff * c3_11 - c3_23 = slack_m23 ∧
  aCoeff * c3_23 + dLower * c2_8 - c3_26 = slack_m26

def L3NTRowSlacksPositive : Prop :=
  0 < slack_m2 ∧ 0 < slack_m5 ∧ 0 < slack_m8 ∧
  0 < slack_m11 ∧ 0 < slack_m14 ∧ 0 < slack_m17 ∧
  0 < slack_m20 ∧ 0 < slack_m23 ∧ 0 < slack_m26

def L3NTRationalCertificateValid : Prop :=
  aCoeff = 1 / lambda ^ 2 ∧
  dLower = lambda * bLower ∧
  L3NTPrincipalInBox ∧
  L3NTAuxiliaryInBox ∧
  L3NTRowEquationsHold ∧
  L3NTRowSlacksPositive

theorem l3nt_principal_in_box : L3NTPrincipalInBox := by
  norm_num [L3NTPrincipalInBox, c3_2, c3_5, c3_8, c3_11, c3_14,
    c3_17, c3_20, c3_23, c3_26]

theorem l3nt_auxiliary_in_box : L3NTAuxiliaryInBox := by
  norm_num [L3NTAuxiliaryInBox, c2_2, c2_5, c2_8, c3_2, c3_5, c3_8,
    c3_11, c3_14, c3_17, c3_20, c3_23, c3_26]

theorem l3nt_row_equations_hold : L3NTRowEquationsHold := by
  norm_num [L3NTRowEquationsHold, aCoeff, bLower, dLower,
    c3_2, c3_5, c3_8, c3_11, c3_14, c3_17, c3_20, c3_23, c3_26,
    c2_2, c2_5, c2_8, slack_m2, slack_m5, slack_m8, slack_m11,
    slack_m14, slack_m17, slack_m20, slack_m23, slack_m26]

theorem l3nt_row_slacks_positive : L3NTRowSlacksPositive := by
  norm_num [L3NTRowSlacksPositive, slack_m2, slack_m5, slack_m8,
    slack_m11, slack_m14, slack_m17, slack_m20, slack_m23, slack_m26]

theorem l3nt_rational_certificate_valid : L3NTRationalCertificateValid := by
  refine ⟨?_, ?_, l3nt_principal_in_box, l3nt_auxiliary_in_box,
    l3nt_row_equations_hold, l3nt_row_slacks_positive⟩
  · norm_num [aCoeff, lambda]
  · norm_num [dLower, lambda, bLower]

def intPositivePart (value : Int) : Nat := value.toNat

def shiftLt (a₁ b₁ a₂ b₂ : Int) : Bool :=
  let da := a₁ - a₂
  let db := b₁ - b₂
  3 ^ intPositivePart da * 2 ^ intPositivePart db <
    3 ^ intPositivePart (-da) * 2 ^ intPositivePart (-db)

def shiftEq (node : TreeNodeData) (alphaCoeff const : Int) : Bool :=
  node.alphaCoeff == alphaCoeff && node.const == const

def nodesForRoot (rootMode : Nat) : Array TreeNodeData :=
  if rootMode == 8 then treeNodes8
  else if rootMode == 17 then treeNodes17
  else if rootMode == 26 then treeNodes26
  else #[]

def findNode? (rootMode nodeIndex : Nat) : Option TreeNodeData :=
  (nodesForRoot rootMode)[nodeIndex]?

def children? (node : TreeNodeData) : Option (List TreeNodeData) :=
  node.childIndices.mapM fun childIndex => findNode? node.rootMode childIndex

def exactlyOne (items : List TreeNodeData) (predicate : TreeNodeData → Bool) : Bool :=
  (items.filter predicate).length == 1

def isAncestorAux : Nat → Nat → Nat → Nat → Bool
  | 0, _, _, _ => false
  | fuel + 1, rootMode, ancestorIndex, currentIndex =>
      match findNode? rootMode currentIndex with
      | none => false
      | some current =>
          if current.isRoot then false
          else if current.parentIndex == ancestorIndex then true
          else isAncestorAux fuel rootMode ancestorIndex current.parentIndex

def deletionWitnessValid (node : TreeNodeData) : Bool :=
  match findNode? node.rootMode node.deletionAncestorIndex with
  | none => false
  | some ancestor =>
      !ancestor.isMin && ancestor.mode == node.mode &&
      shiftLt ancestor.alphaCoeff ancestor.const node.alphaCoeff node.const &&
      isAncestorAux (nodesForRoot node.rootMode).size node.rootMode ancestor.nodeIndex node.nodeIndex

def adjacencyValid (node : TreeNodeData) : Bool :=
  decide node.childIndices.Nodup &&
  match children? node with
  | none => false
  | some cs =>
      let childDepth := if node.isMin then node.expansionDepth else node.expansionDepth + 1
      cs.all (fun child =>
        !child.isRoot && child.parentIndex == node.nodeIndex &&
          child.expansionDepth == childDepth) &&
      if node.isRoot then true
      else
        match findNode? node.rootMode node.parentIndex with
        | none => false
        | some parent => parent.childIndices.contains node.nodeIndex

def retardedChildValid (parent child : TreeNodeData) : Bool :=
  !child.isMin && child.mode == (4 * parent.mode) % 27 &&
  shiftEq child parent.alphaCoeff (parent.const - 2)

def expectedMinBase (parent : TreeNodeData) : Nat :=
  if parent.mode % 9 == 2 then ((4 * parent.mode - 2) / 3) % 9
  else ((2 * parent.mode - 1) / 3) % 9

def minChildValid (child : TreeNodeData) : Bool :=
  child.isMin && child.alphaCoeff == 0 && child.const == 0 &&
  child.status == 0 && child.mode == 0

def pExpansionValid (node : TreeNodeData) : Bool :=
  match children? node with
  | none => false
  | some cs =>
      let retarded := exactlyOne cs (retardedChildValid node)
      if node.mode % 9 == 5 then
        cs.length == 1 && retarded
      else
        cs.length == 2 && retarded && exactlyOne cs minChildValid

def minExpansionValid (node : TreeNodeData) : Bool :=
  match findNode? node.rootMode node.parentIndex with
  | none => false
  | some parent =>
      match children? node with
      | none => false
      | some cs =>
          let base := expectedMinBase parent
          let expectedModes := [base, (base + 9) % 27, (base + 18) % 27]
          let expectedAlpha := parent.alphaCoeff + 1
          let expectedConst := parent.const + (if parent.mode % 9 == 2 then -2 else -1)
          cs.length == 3 &&
          cs.all (fun child =>
            !child.isMin && expectedModes.contains child.mode &&
            shiftEq child expectedAlpha expectedConst) &&
          expectedModes.all (fun mode => exactlyOne cs fun child => child.mode == mode)

def nodeValid (node : TreeNodeData) : Bool :=
  adjacencyValid node &&
  if node.isRoot then
      !node.isMin && node.nodeIndex == 0 && node.parentIndex == 0 &&
      node.mode == node.rootMode && shiftEq node 0 0 && node.status == 0 &&
      (node.rootMode == 8 || node.rootMode == 17 || node.rootMode == 26) &&
      pExpansionValid node
    else if node.isMin then
      node.status == 0 && minExpansionValid node
    else if node.status == 0 then
      !shiftLt node.alphaCoeff node.const 0 0 && pExpansionValid node
    else if node.status == 1 then
      shiftLt node.alphaCoeff node.const 0 0 && node.childIndices.isEmpty
    else if node.status == 2 then
      !shiftLt node.alphaCoeff node.const 0 0 && node.childIndices.isEmpty &&
        deletionWitnessValid node
    else false

def terminalCount (nodes : Array TreeNodeData) : Nat :=
  (nodes.toList.filter fun node => node.status == 1).length

def deletionCount (nodes : Array TreeNodeData) : Nat :=
  (nodes.toList.filter fun node => node.status == 2).length

def maxExpansionDepth (nodes : Array TreeNodeData) : Nat :=
  nodes.toList.foldl
    (fun current node => max current node.expansionDepth) 0

def arrayIndexedValid (rootMode : Nat) (nodes : Array TreeNodeData) : Bool :=
  nodes.toList.zipIdx.all fun item =>
    item.1.rootMode == rootMode && item.1.nodeIndex == item.2

def recordedMetricsValid : Bool :=
  treeMetrics == [(8, 4, 0, 2), (17, 28, 3, 5), (26, 84, 7, 10)] &&
  terminalCount treeNodes8 == 4 && terminalCount treeNodes17 == 28 &&
  terminalCount treeNodes26 == 84 && deletionCount treeNodes8 == 0 &&
  deletionCount treeNodes17 == 3 && deletionCount treeNodes26 == 7 &&
  maxExpansionDepth treeNodes8 == 2 && maxExpansionDepth treeNodes17 == 5 &&
  maxExpansionDepth treeNodes26 == 10

def TreeDataValid : Bool :=
  treeNodes8.size == 9 && treeNodes17.size == 60 && treeNodes26.size == 178 &&
  arrayIndexedValid 8 treeNodes8 && arrayIndexedValid 17 treeNodes17 &&
  arrayIndexedValid 26 treeNodes26 && treeNodes8.toList.all nodeValid &&
  treeNodes17.toList.all nodeValid && treeNodes26.toList.all nodeValid &&
  recordedMetricsValid

set_option maxRecDepth 100000 in
set_option maxHeartbeats 5000000 in
theorem k3_tree_data_valid : TreeDataValid = true := by
  decide

noncomputable def lambdaR3 : Real := (lambda : Real)
noncomputable def bReal3 : Real := lambdaR3 ^ (alpha - 2)
noncomputable def dReal3 : Real := lambdaR3 ^ (alpha - 1)

theorem lambdaR3_pos : 0 < lambdaR3 := by
  norm_num [lambdaR3, lambda]

theorem lambdaR3_gt_one : 1 < lambdaR3 := by
  norm_num [lambdaR3, lambda]

theorem alpha_strong_lower_bound : (569 / 359 : Real) < alpha := by
  have key : Real.log ((2 : Real) ^ 569) < Real.log ((3 : Real) ^ 359) :=
    Real.log_lt_log (by positivity) (by norm_num)
  rw [Real.log_pow, Real.log_pow] at key
  have hscaled : (569 / 359 : Real) * Real.log (2 : Real) < Real.log (3 : Real) := by
    have hdiv : ((569 : Real) * Real.log (2 : Real)) / 359 < Real.log (3 : Real) :=
      (div_lt_iff₀ (by norm_num : (0 : Real) < 359)).2 (by
        simpa [mul_comm] using key)
    simpa [div_eq_mul_inv, mul_assoc, mul_left_comm, mul_comm] using hdiv
  unfold alpha
  rw [← Real.log_div_log]
  exact (lt_div_iff₀ log_two_pos).2 hscaled

theorem dLower_endpoint :
    ((dLower : Rat) : Real) <= lambdaR3 ^ (210 / 359 : Real) := by
  have hdNonneg : 0 <= ((dLower : Rat) : Real) := by
    norm_num [dLower]
  have hpowNat : (((dLower : Rat) : Real) ^ 359) <= lambdaR3 ^ 210 := by
    norm_num [dLower, lambdaR3, lambda]
  have hpow :
      (((dLower : Rat) : Real) ^ (359 : Real)) <=
        (lambdaR3 ^ (210 / 359 : Real)) ^ (359 : Real) := by
    calc
      (((dLower : Rat) : Real) ^ (359 : Real)) = (((dLower : Rat) : Real) ^ 359) := by
        norm_num
      _ <= lambdaR3 ^ 210 := hpowNat
      _ = lambdaR3 ^ ((210 / 359 : Real) * (359 : Real)) := by norm_num
      _ = (lambdaR3 ^ (210 / 359 : Real)) ^ (359 : Real) := by
        rw [Real.rpow_mul lambdaR3_pos.le]
  exact
    (Real.rpow_le_rpow_iff
      hdNonneg
      (Real.rpow_nonneg lambdaR3_pos.le _)
      (by norm_num : 0 < (359 : Real))).1 hpow

theorem dReal3_lower : ((dLower : Rat) : Real) <= dReal3 := by
  have hexp : (210 / 359 : Real) <= alpha - 1 := by
    linarith [alpha_strong_lower_bound]
  exact dLower_endpoint.trans
    (Real.rpow_le_rpow_of_exponent_le lambdaR3_gt_one.le hexp)

theorem bReal3_eq_dReal3_div_lambda : bReal3 = dReal3 / lambdaR3 := by
  dsimp [bReal3, dReal3]
  rw [show alpha - 2 = (alpha - 1) - 1 by ring]
  rw [Real.rpow_sub lambdaR3_pos, Real.rpow_one]

theorem bReal3_lower : ((bLower : Rat) : Real) <= bReal3 := by
  rw [bReal3_eq_dReal3_div_lambda]
  have hdiv := div_le_div_of_nonneg_right dReal3_lower lambdaR3_pos.le
  calc
    ((bLower : Rat) : Real) = ((dLower : Rat) : Real) / lambdaR3 := by
      norm_num [bLower, dLower, lambdaR3, lambda]
    _ <= dReal3 / lambdaR3 := hdiv

def K3PilotCertificateVerified : Prop :=
  L3NTRationalCertificateValid ∧
  TreeDataValid = true ∧
  ((bLower : Rat) : Real) <= bReal3

theorem k3_pilot_certificate_verified : K3PilotCertificateVerified := by
  exact ⟨l3nt_rational_certificate_valid, k3_tree_data_valid, bReal3_lower⟩

end K3Verifier
end KL2003
end CollatzClassical
