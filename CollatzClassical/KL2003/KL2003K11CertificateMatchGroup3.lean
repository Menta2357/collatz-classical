import CollatzClassical.KL2003.KL2003K11CertificateMatchShard27
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard28
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard29
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard30
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard31
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard32
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard33
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard34
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard35

namespace CollatzClassical.KL2003.K11CertificateMatch

theorem k11_rows_group_3 (index : Nat)
    (hlo : 19683 <= index)
    (hhi : index < 26244) : K11RowValid index := by
  by_cases h0 : index < 20412
  · exact k11_rows_shard_27 index (hlo) h0
  by_cases h1 : index < 21141
  · exact k11_rows_shard_28 index (Nat.le_of_not_gt h0) h1
  by_cases h2 : index < 21870
  · exact k11_rows_shard_29 index (Nat.le_of_not_gt h1) h2
  by_cases h3 : index < 22599
  · exact k11_rows_shard_30 index (Nat.le_of_not_gt h2) h3
  by_cases h4 : index < 23328
  · exact k11_rows_shard_31 index (Nat.le_of_not_gt h3) h4
  by_cases h5 : index < 24057
  · exact k11_rows_shard_32 index (Nat.le_of_not_gt h4) h5
  by_cases h6 : index < 24786
  · exact k11_rows_shard_33 index (Nat.le_of_not_gt h5) h6
  by_cases h7 : index < 25515
  · exact k11_rows_shard_34 index (Nat.le_of_not_gt h6) h7
  exact k11_rows_shard_35 index (Nat.le_of_not_gt h7) hhi

theorem k11_auxiliary_group_3 (index : Nat)
    (hlo : 6561 <= index)
    (hhi : index < 8748) :
    K11AuxiliaryValid index := by
  by_cases ha0 : index < 6804
  · exact k11_auxiliary_shard_27 index (hlo) ha0
  by_cases ha1 : index < 7047
  · exact k11_auxiliary_shard_28 index (Nat.le_of_not_gt ha0) ha1
  by_cases ha2 : index < 7290
  · exact k11_auxiliary_shard_29 index (Nat.le_of_not_gt ha1) ha2
  by_cases ha3 : index < 7533
  · exact k11_auxiliary_shard_30 index (Nat.le_of_not_gt ha2) ha3
  by_cases ha4 : index < 7776
  · exact k11_auxiliary_shard_31 index (Nat.le_of_not_gt ha3) ha4
  by_cases ha5 : index < 8019
  · exact k11_auxiliary_shard_32 index (Nat.le_of_not_gt ha4) ha5
  by_cases ha6 : index < 8262
  · exact k11_auxiliary_shard_33 index (Nat.le_of_not_gt ha5) ha6
  by_cases ha7 : index < 8505
  · exact k11_auxiliary_shard_34 index (Nat.le_of_not_gt ha6) ha7
  exact k11_auxiliary_shard_35 index (Nat.le_of_not_gt ha7) hhi

end CollatzClassical.KL2003.K11CertificateMatch
