import CollatzClassical.KL2003.KL2003K2CertificateData

namespace CollatzClassical
namespace KL2003

namespace RationalInterval

def Valid (I : RationalInterval) : Prop :=
  I.lo <= I.hi

end RationalInterval

namespace LPRowSlack

def Positive (s : LPRowSlack) : Prop :=
  0 < s.slack

end LPRowSlack

namespace K2InteriorVariables

def InBox (v : K2InteriorVariables) : Prop :=
  0 < v.c12 ∧
    v.c12 <= v.c22 ∧ v.c22 <= v.cmax ∧
    v.c12 <= v.c25 ∧ v.c25 <= v.cmax ∧
    v.c12 <= v.c28 ∧ v.c28 <= v.cmax ∧
    0 < v.cmax

end K2InteriorVariables

def lower_c22_row : LPRowSlack := { name := "lower_c22", slack := lower_c22_slack }
def upper_c22_row : LPRowSlack := { name := "upper_c22", slack := upper_c22_slack }
def lower_c25_row : LPRowSlack := { name := "lower_c25", slack := lower_c25_slack }
def upper_c25_row : LPRowSlack := { name := "upper_c25", slack := upper_c25_slack }
def lower_c28_row : LPRowSlack := { name := "lower_c28", slack := lower_c28_slack }
def upper_c28_row : LPRowSlack := { name := "upper_c28", slack := upper_c28_slack }
def L2NT_D1_row : LPRowSlack := { name := "L2NT_D1", slack := L2NT_D1_slack }
def L2NT_D2_row : LPRowSlack := { name := "L2NT_D2", slack := L2NT_D2_slack }
def L2NT_D3_row : LPRowSlack := { name := "L2NT_D3", slack := L2NT_D3_slack }
def aux_c12_le_c22_row : LPRowSlack :=
  { name := "aux_c12_le_c22", slack := aux_c12_le_c22_slack }
def aux_c12_le_c25_row : LPRowSlack :=
  { name := "aux_c12_le_c25", slack := aux_c12_le_c25_slack }
def aux_c12_le_c28_row : LPRowSlack :=
  { name := "aux_c12_le_c28", slack := aux_c12_le_c28_slack }
def domain_c12_positive_row : LPRowSlack :=
  { name := "domain_c12_positive", slack := domain_c12_positive_slack }

def DeclaredSlacksPositive : Prop :=
  LPRowSlack.Positive lower_c22_row ∧
    LPRowSlack.Positive upper_c22_row ∧
    LPRowSlack.Positive lower_c25_row ∧
    LPRowSlack.Positive upper_c25_row ∧
    LPRowSlack.Positive lower_c28_row ∧
    LPRowSlack.Positive upper_c28_row ∧
    LPRowSlack.Positive L2NT_D1_row ∧
    LPRowSlack.Positive L2NT_D2_row ∧
    LPRowSlack.Positive L2NT_D3_row ∧
    LPRowSlack.Positive aux_c12_le_c22_row ∧
    LPRowSlack.Positive aux_c12_le_c25_row ∧
    LPRowSlack.Positive aux_c12_le_c28_row ∧
    LPRowSlack.Positive domain_c12_positive_row

def L2NTRowEquationsHold : Prop :=
  (400 / 729 : Rat) * (69 / 40) + (119 / 135 : Rat) * 1 - (73 / 40)
      = 29 / 9720 ∧
    (400 / 729 : Rat) * (73 / 40) - (1001 / 1000)
      = 271 / 729000 ∧
    (400 / 729 : Rat) * (1001 / 1000) + (119 / 100 : Rat) * 1 - (69 / 40)
      = 2077 / 145800

def CoefficientIntervalsValid : Prop :=
  RationalInterval.Valid AInterval ∧
    RationalInterval.Valid BTargetInterval ∧
    RationalInterval.Valid BStrongInterval ∧
    RationalInterval.Valid DTargetInterval

namespace K2InteriorCertificateData

def ValidData (c : K2InteriorCertificateData) : Prop :=
  RationalInterval.Valid c.A ∧
    RationalInterval.Valid c.BTarget ∧
    RationalInterval.Valid c.BStrong ∧
    RationalInterval.Valid c.DTarget ∧
    K2InteriorVariables.InBox c.vars ∧
    DeclaredSlacksPositive ∧
    L2NTRowEquationsHold

end K2InteriorCertificateData

theorem AInterval_valid : RationalInterval.Valid AInterval := by
  dsimp [RationalInterval.Valid]
  exact k2_A_interval_ok

theorem BTargetInterval_valid : RationalInterval.Valid BTargetInterval := by
  dsimp [RationalInterval.Valid]
  exact k2_B_target_interval_ok

theorem BStrongInterval_valid : RationalInterval.Valid BStrongInterval := by
  dsimp [RationalInterval.Valid]
  exact k2_B_strong_interval_ok

theorem DTargetInterval_valid : RationalInterval.Valid DTargetInterval := by
  dsimp [RationalInterval.Valid]
  exact k2_D_target_interval_ok

theorem k2_coefficient_intervals_valid : CoefficientIntervalsValid := by
  exact ⟨AInterval_valid, BTargetInterval_valid, BStrongInterval_valid, DTargetInterval_valid⟩

theorem k2Vars_inBox : K2InteriorVariables.InBox k2Vars := by
  norm_num [K2InteriorVariables.InBox, k2Vars]

theorem lower_c22_row_positive : LPRowSlack.Positive lower_c22_row := by
  dsimp [LPRowSlack.Positive, lower_c22_row]
  exact lower_c22_slack_pos

theorem upper_c22_row_positive : LPRowSlack.Positive upper_c22_row := by
  dsimp [LPRowSlack.Positive, upper_c22_row]
  exact upper_c22_slack_pos

theorem lower_c25_row_positive : LPRowSlack.Positive lower_c25_row := by
  dsimp [LPRowSlack.Positive, lower_c25_row]
  exact lower_c25_slack_pos

theorem upper_c25_row_positive : LPRowSlack.Positive upper_c25_row := by
  dsimp [LPRowSlack.Positive, upper_c25_row]
  exact upper_c25_slack_pos

theorem lower_c28_row_positive : LPRowSlack.Positive lower_c28_row := by
  dsimp [LPRowSlack.Positive, lower_c28_row]
  exact lower_c28_slack_pos

theorem upper_c28_row_positive : LPRowSlack.Positive upper_c28_row := by
  dsimp [LPRowSlack.Positive, upper_c28_row]
  exact upper_c28_slack_pos

theorem L2NT_D1_row_positive : LPRowSlack.Positive L2NT_D1_row := by
  dsimp [LPRowSlack.Positive, L2NT_D1_row]
  exact L2NT_D1_slack_pos

theorem L2NT_D2_row_positive : LPRowSlack.Positive L2NT_D2_row := by
  dsimp [LPRowSlack.Positive, L2NT_D2_row]
  exact L2NT_D2_slack_pos

theorem L2NT_D3_row_positive : LPRowSlack.Positive L2NT_D3_row := by
  dsimp [LPRowSlack.Positive, L2NT_D3_row]
  exact L2NT_D3_slack_pos

theorem aux_c12_le_c22_row_positive : LPRowSlack.Positive aux_c12_le_c22_row := by
  dsimp [LPRowSlack.Positive, aux_c12_le_c22_row]
  exact aux_c12_le_c22_slack_pos

theorem aux_c12_le_c25_row_positive : LPRowSlack.Positive aux_c12_le_c25_row := by
  dsimp [LPRowSlack.Positive, aux_c12_le_c25_row]
  exact aux_c12_le_c25_slack_pos

theorem aux_c12_le_c28_row_positive : LPRowSlack.Positive aux_c12_le_c28_row := by
  dsimp [LPRowSlack.Positive, aux_c12_le_c28_row]
  exact aux_c12_le_c28_slack_pos

theorem domain_c12_positive_row_positive :
    LPRowSlack.Positive domain_c12_positive_row := by
  dsimp [LPRowSlack.Positive, domain_c12_positive_row]
  exact domain_c12_positive_slack_pos

theorem k2_declared_slacks_positive : DeclaredSlacksPositive := by
  exact
    ⟨ lower_c22_row_positive,
      upper_c22_row_positive,
      lower_c25_row_positive,
      upper_c25_row_positive,
      lower_c28_row_positive,
      upper_c28_row_positive,
      L2NT_D1_row_positive,
      L2NT_D2_row_positive,
      L2NT_D3_row_positive,
      aux_c12_le_c22_row_positive,
      aux_c12_le_c25_row_positive,
      aux_c12_le_c28_row_positive,
      domain_c12_positive_row_positive ⟩

theorem k2_L2NT_row_equations_hold : L2NTRowEquationsHold := by
  exact ⟨k2_L2NT_D1_slack_eq, k2_L2NT_D2_slack_eq, k2_L2NT_D3_slack_eq⟩

theorem k2CertificateData_valid :
    K2InteriorCertificateData.ValidData k2CertificateData := by
  dsimp [K2InteriorCertificateData.ValidData, k2CertificateData]
  exact
    ⟨ AInterval_valid,
      BTargetInterval_valid,
      BStrongInterval_valid,
      DTargetInterval_valid,
      k2Vars_inBox,
      k2_declared_slacks_positive,
      k2_L2NT_row_equations_hold ⟩

end KL2003
end CollatzClassical
