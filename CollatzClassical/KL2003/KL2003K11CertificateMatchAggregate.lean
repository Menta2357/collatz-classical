import CollatzClassical.KL2003.KL2003K11CertificateMatchGroup0
import CollatzClassical.KL2003.KL2003K11CertificateMatchGroup1
import CollatzClassical.KL2003.KL2003K11CertificateMatchGroup2
import CollatzClassical.KL2003.KL2003K11CertificateMatchGroup3
import CollatzClassical.KL2003.KL2003K11CertificateMatchGroup4
import CollatzClassical.KL2003.KL2003K11CertificateMatchGroup5
import CollatzClassical.KL2003.KL2003K11CertificateMatchGroup6
import CollatzClassical.KL2003.KL2003K11CertificateMatchGroup7
import CollatzClassical.KL2003.KL2003K11CertificateMatchGroup8

namespace CollatzClassical.KL2003.K11CertificateMatch

theorem k11_all_rows_valid (index : Nat) (hindex : index < 59049) :
    K11RowValid index := by
  by_cases h0 : index < 6561
  · exact k11_rows_group_0 index (Nat.zero_le index) h0
  by_cases h1 : index < 13122
  · exact k11_rows_group_1 index (Nat.le_of_not_gt h0) h1
  by_cases h2 : index < 19683
  · exact k11_rows_group_2 index (Nat.le_of_not_gt h1) h2
  by_cases h3 : index < 26244
  · exact k11_rows_group_3 index (Nat.le_of_not_gt h2) h3
  by_cases h4 : index < 32805
  · exact k11_rows_group_4 index (Nat.le_of_not_gt h3) h4
  by_cases h5 : index < 39366
  · exact k11_rows_group_5 index (Nat.le_of_not_gt h4) h5
  by_cases h6 : index < 45927
  · exact k11_rows_group_6 index (Nat.le_of_not_gt h5) h6
  by_cases h7 : index < 52488
  · exact k11_rows_group_7 index (Nat.le_of_not_gt h6) h7
  exact k11_rows_group_8 index (Nat.le_of_not_gt h7) hindex

theorem k11_all_auxiliary_valid (index : Nat)
    (hindex : index < 19683) : K11AuxiliaryValid index := by
  by_cases ha0 : index < 2187
  · exact k11_auxiliary_group_0 index (Nat.zero_le index) ha0
  by_cases ha1 : index < 4374
  · exact k11_auxiliary_group_1 index (Nat.le_of_not_gt ha0) ha1
  by_cases ha2 : index < 6561
  · exact k11_auxiliary_group_2 index (Nat.le_of_not_gt ha1) ha2
  by_cases ha3 : index < 8748
  · exact k11_auxiliary_group_3 index (Nat.le_of_not_gt ha2) ha3
  by_cases ha4 : index < 10935
  · exact k11_auxiliary_group_4 index (Nat.le_of_not_gt ha3) ha4
  by_cases ha5 : index < 13122
  · exact k11_auxiliary_group_5 index (Nat.le_of_not_gt ha4) ha5
  by_cases ha6 : index < 15309
  · exact k11_auxiliary_group_6 index (Nat.le_of_not_gt ha5) ha6
  by_cases ha7 : index < 17496
  · exact k11_auxiliary_group_7 index (Nat.le_of_not_gt ha6) ha7
  exact k11_auxiliary_group_8 index (Nat.le_of_not_gt ha7) hindex

end CollatzClassical.KL2003.K11CertificateMatch
