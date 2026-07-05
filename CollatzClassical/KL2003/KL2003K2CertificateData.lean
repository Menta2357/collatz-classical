import Mathlib.Data.Rat.Basic
import Mathlib.Tactic.NormNum

namespace CollatzClassical
namespace KL2003

structure RationalInterval where
  lo : Rat
  hi : Rat
deriving Repr, DecidableEq

structure LPRowSlack where
  name : String
  slack : Rat
deriving Repr, DecidableEq

structure K2InteriorVariables where
  c22 : Rat
  c25 : Rat
  c28 : Rat
  c12 : Rat
  cmax : Rat
deriving Repr, DecidableEq

structure BaseSegmentPlaceholder where
  name : String
  status : String
deriving Repr, DecidableEq

structure K2InteriorCertificateData where
  lambda : Rat
  A : RationalInterval
  BTarget : RationalInterval
  BStrong : RationalInterval
  DTarget : RationalInterval
  vars : K2InteriorVariables
  rowSlacks : List LPRowSlack
  baseSegment : BaseSegmentPlaceholder
deriving Repr, DecidableEq

def lambdaQ : Rat := 27 / 20

def AInterval : RationalInterval := { lo := 400 / 729, hi := 400 / 729 }

def BTargetInterval : RationalInterval := { lo := 22 / 25, hi := 89 / 100 }

def BStrongInterval : RationalInterval := { lo := 119 / 135, hi := 8 / 9 }

def DTargetInterval : RationalInterval := { lo := 119 / 100, hi := 6 / 5 }

def k2Vars : K2InteriorVariables :=
  { c22 := 73 / 40
    c25 := 1001 / 1000
    c28 := 69 / 40
    c12 := 1
    cmax := 2 }

def lower_c22_slack : Rat := 33 / 40
def upper_c22_slack : Rat := 7 / 40
def lower_c25_slack : Rat := 1 / 1000
def upper_c25_slack : Rat := 999 / 1000
def lower_c28_slack : Rat := 29 / 40
def upper_c28_slack : Rat := 11 / 40
def L2NT_D1_slack : Rat := 73 / 48600
def L2NT_D2_slack : Rat := 271 / 729000
def L2NT_D3_slack : Rat := 2077 / 145800
def aux_c12_le_c22_slack : Rat := 33 / 40
def aux_c12_le_c25_slack : Rat := 1 / 1000
def aux_c12_le_c28_slack : Rat := 29 / 40
def domain_c12_positive_slack : Rat := 1

def k2RowSlacks : List LPRowSlack :=
  [ { name := "lower_c22", slack := lower_c22_slack },
    { name := "upper_c22", slack := upper_c22_slack },
    { name := "lower_c25", slack := lower_c25_slack },
    { name := "upper_c25", slack := upper_c25_slack },
    { name := "lower_c28", slack := lower_c28_slack },
    { name := "upper_c28", slack := upper_c28_slack },
    { name := "L2NT_D1", slack := L2NT_D1_slack },
    { name := "L2NT_D2", slack := L2NT_D2_slack },
    { name := "L2NT_D3", slack := L2NT_D3_slack },
    { name := "aux_c12_le_c22", slack := aux_c12_le_c22_slack },
    { name := "aux_c12_le_c25", slack := aux_c12_le_c25_slack },
    { name := "aux_c12_le_c28", slack := aux_c12_le_c28_slack },
    { name := "domain_c12_positive", slack := domain_c12_positive_slack } ]

def baseSegmentPlaceholder : BaseSegmentPlaceholder :=
  { name := "BaseSegmentLowerBoundY0"
    status := "SPEC_PLACEHOLDER_PRESENT_NOT_PROVED" }

def k2CertificateData : K2InteriorCertificateData :=
  { lambda := lambdaQ
    A := AInterval
    BTarget := BTargetInterval
    BStrong := BStrongInterval
    DTarget := DTargetInterval
    vars := k2Vars
    rowSlacks := k2RowSlacks
    baseSegment := baseSegmentPlaceholder }

theorem k2_two_pow_19_lt_three_pow_12 : 2 ^ 19 < 3 ^ 12 := by
  norm_num

theorem k2_three_pow_5_lt_two_pow_8 : 3 ^ 5 < 2 ^ 8 := by
  norm_num

theorem k2_gamma_gt_three_sevenths_int : 8 * 20 ^ 7 < 27 ^ 7 := by
  norm_num

theorem k2_B_lower_rational_reduction :
    ((119 / 135 : Rat) ^ 12) * ((27 / 20 : Rat) ^ 5) <= 1 := by
  norm_num

theorem k2_B_upper_rational_reduction :
    1 <= ((8 / 9 : Rat) ^ 5) * ((27 / 20 : Rat) ^ 2) := by
  norm_num

theorem k2_B_lower_implies_target : (22 / 25 : Rat) <= 119 / 135 := by
  norm_num

theorem k2_B_upper_implies_target : (8 / 9 : Rat) <= 89 / 100 := by
  norm_num

theorem k2_D_lower_endpoint : (27 / 20 : Rat) * (119 / 135) = 119 / 100 := by
  norm_num

theorem k2_D_upper_endpoint : (27 / 20 : Rat) * (8 / 9) = 6 / 5 := by
  norm_num

theorem k2_A_interval_ok : AInterval.lo <= AInterval.hi := by
  norm_num [AInterval]

theorem k2_B_target_interval_ok : BTargetInterval.lo <= BTargetInterval.hi := by
  norm_num [BTargetInterval]

theorem k2_B_strong_interval_ok : BStrongInterval.lo <= BStrongInterval.hi := by
  norm_num [BStrongInterval]

theorem k2_D_target_interval_ok : DTargetInterval.lo <= DTargetInterval.hi := by
  norm_num [DTargetInterval]

theorem lower_c22_slack_pos : 0 < lower_c22_slack := by
  norm_num [lower_c22_slack]

theorem upper_c22_slack_pos : 0 < upper_c22_slack := by
  norm_num [upper_c22_slack]

theorem lower_c25_slack_pos : 0 < lower_c25_slack := by
  norm_num [lower_c25_slack]

theorem upper_c25_slack_pos : 0 < upper_c25_slack := by
  norm_num [upper_c25_slack]

theorem lower_c28_slack_pos : 0 < lower_c28_slack := by
  norm_num [lower_c28_slack]

theorem upper_c28_slack_pos : 0 < upper_c28_slack := by
  norm_num [upper_c28_slack]

theorem L2NT_D1_slack_pos : 0 < L2NT_D1_slack := by
  norm_num [L2NT_D1_slack]

theorem L2NT_D2_slack_pos : 0 < L2NT_D2_slack := by
  norm_num [L2NT_D2_slack]

theorem L2NT_D3_slack_pos : 0 < L2NT_D3_slack := by
  norm_num [L2NT_D3_slack]

theorem aux_c12_le_c22_slack_pos : 0 < aux_c12_le_c22_slack := by
  norm_num [aux_c12_le_c22_slack]

theorem aux_c12_le_c25_slack_pos : 0 < aux_c12_le_c25_slack := by
  norm_num [aux_c12_le_c25_slack]

theorem aux_c12_le_c28_slack_pos : 0 < aux_c12_le_c28_slack := by
  norm_num [aux_c12_le_c28_slack]

theorem domain_c12_positive_slack_pos : 0 < domain_c12_positive_slack := by
  norm_num [domain_c12_positive_slack]

theorem k2_L2NT_D1_slack_eq :
    (400 / 729 : Rat) * (69 / 40) + (22 / 25 : Rat) * 1 - (73 / 40)
      = 73 / 48600 := by
  norm_num

theorem k2_L2NT_D2_slack_eq :
    (400 / 729 : Rat) * (73 / 40) - (1001 / 1000)
      = 271 / 729000 := by
  norm_num

theorem k2_L2NT_D3_slack_eq :
    (400 / 729 : Rat) * (1001 / 1000) + (119 / 100 : Rat) * 1 - (69 / 40)
      = 2077 / 145800 := by
  norm_num

end KL2003
end CollatzClassical
