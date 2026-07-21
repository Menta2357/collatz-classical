import CollatzClassical.KL2003.KL2003K11CertificateMatchShard09
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard10
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard11
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard12
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard13
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard14
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard15
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard16
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard17

namespace CollatzClassical.KL2003.K11CertificateMatch

theorem k11_rows_group_1 (index : Nat)
    (hlo : 6561 <= index)
    (hhi : index < 13122) : K11RowValid index := by
  by_cases h0 : index < 7290
  · exact k11_rows_shard_9 index (hlo) h0
  by_cases h1 : index < 8019
  · exact k11_rows_shard_10 index (Nat.le_of_not_gt h0) h1
  by_cases h2 : index < 8748
  · exact k11_rows_shard_11 index (Nat.le_of_not_gt h1) h2
  by_cases h3 : index < 9477
  · exact k11_rows_shard_12 index (Nat.le_of_not_gt h2) h3
  by_cases h4 : index < 10206
  · exact k11_rows_shard_13 index (Nat.le_of_not_gt h3) h4
  by_cases h5 : index < 10935
  · exact k11_rows_shard_14 index (Nat.le_of_not_gt h4) h5
  by_cases h6 : index < 11664
  · exact k11_rows_shard_15 index (Nat.le_of_not_gt h5) h6
  by_cases h7 : index < 12393
  · exact k11_rows_shard_16 index (Nat.le_of_not_gt h6) h7
  exact k11_rows_shard_17 index (Nat.le_of_not_gt h7) hhi

theorem k11_auxiliary_group_1 (index : Nat)
    (hlo : 2187 <= index)
    (hhi : index < 4374) :
    K11AuxiliaryValid index := by
  by_cases ha0 : index < 2430
  · exact k11_auxiliary_shard_9 index (hlo) ha0
  by_cases ha1 : index < 2673
  · exact k11_auxiliary_shard_10 index (Nat.le_of_not_gt ha0) ha1
  by_cases ha2 : index < 2916
  · exact k11_auxiliary_shard_11 index (Nat.le_of_not_gt ha1) ha2
  by_cases ha3 : index < 3159
  · exact k11_auxiliary_shard_12 index (Nat.le_of_not_gt ha2) ha3
  by_cases ha4 : index < 3402
  · exact k11_auxiliary_shard_13 index (Nat.le_of_not_gt ha3) ha4
  by_cases ha5 : index < 3645
  · exact k11_auxiliary_shard_14 index (Nat.le_of_not_gt ha4) ha5
  by_cases ha6 : index < 3888
  · exact k11_auxiliary_shard_15 index (Nat.le_of_not_gt ha5) ha6
  by_cases ha7 : index < 4131
  · exact k11_auxiliary_shard_16 index (Nat.le_of_not_gt ha6) ha7
  exact k11_auxiliary_shard_17 index (Nat.le_of_not_gt ha7) hhi

end CollatzClassical.KL2003.K11CertificateMatch
