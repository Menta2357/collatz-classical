import CollatzClassical.KL2003.KL2003K11CertificateMatchShard00
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard01
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard02
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard03
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard04
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard05
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard06
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard07
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard08

namespace CollatzClassical.KL2003.K11CertificateMatch

theorem k11_rows_group_0 (index : Nat)
    (hlo : 0 <= index)
    (hhi : index < 6561) : K11RowValid index := by
  by_cases h0 : index < 729
  · exact k11_rows_shard_0 index (hlo) h0
  by_cases h1 : index < 1458
  · exact k11_rows_shard_1 index (Nat.le_of_not_gt h0) h1
  by_cases h2 : index < 2187
  · exact k11_rows_shard_2 index (Nat.le_of_not_gt h1) h2
  by_cases h3 : index < 2916
  · exact k11_rows_shard_3 index (Nat.le_of_not_gt h2) h3
  by_cases h4 : index < 3645
  · exact k11_rows_shard_4 index (Nat.le_of_not_gt h3) h4
  by_cases h5 : index < 4374
  · exact k11_rows_shard_5 index (Nat.le_of_not_gt h4) h5
  by_cases h6 : index < 5103
  · exact k11_rows_shard_6 index (Nat.le_of_not_gt h5) h6
  by_cases h7 : index < 5832
  · exact k11_rows_shard_7 index (Nat.le_of_not_gt h6) h7
  exact k11_rows_shard_8 index (Nat.le_of_not_gt h7) hhi

theorem k11_auxiliary_group_0 (index : Nat)
    (hlo : 0 <= index)
    (hhi : index < 2187) :
    K11AuxiliaryValid index := by
  by_cases ha0 : index < 243
  · exact k11_auxiliary_shard_0 index (hlo) ha0
  by_cases ha1 : index < 486
  · exact k11_auxiliary_shard_1 index (Nat.le_of_not_gt ha0) ha1
  by_cases ha2 : index < 729
  · exact k11_auxiliary_shard_2 index (Nat.le_of_not_gt ha1) ha2
  by_cases ha3 : index < 972
  · exact k11_auxiliary_shard_3 index (Nat.le_of_not_gt ha2) ha3
  by_cases ha4 : index < 1215
  · exact k11_auxiliary_shard_4 index (Nat.le_of_not_gt ha3) ha4
  by_cases ha5 : index < 1458
  · exact k11_auxiliary_shard_5 index (Nat.le_of_not_gt ha4) ha5
  by_cases ha6 : index < 1701
  · exact k11_auxiliary_shard_6 index (Nat.le_of_not_gt ha5) ha6
  by_cases ha7 : index < 1944
  · exact k11_auxiliary_shard_7 index (Nat.le_of_not_gt ha6) ha7
  exact k11_auxiliary_shard_8 index (Nat.le_of_not_gt ha7) hhi

end CollatzClassical.KL2003.K11CertificateMatch
