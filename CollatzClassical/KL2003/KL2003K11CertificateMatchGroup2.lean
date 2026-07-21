import CollatzClassical.KL2003.KL2003K11CertificateMatchShard18
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard19
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard20
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard21
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard22
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard23
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard24
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard25
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard26

namespace CollatzClassical.KL2003.K11CertificateMatch

theorem k11_rows_group_2 (index : Nat)
    (hlo : 13122 <= index)
    (hhi : index < 19683) : K11RowValid index := by
  by_cases h0 : index < 13851
  · exact k11_rows_shard_18 index (hlo) h0
  by_cases h1 : index < 14580
  · exact k11_rows_shard_19 index (Nat.le_of_not_gt h0) h1
  by_cases h2 : index < 15309
  · exact k11_rows_shard_20 index (Nat.le_of_not_gt h1) h2
  by_cases h3 : index < 16038
  · exact k11_rows_shard_21 index (Nat.le_of_not_gt h2) h3
  by_cases h4 : index < 16767
  · exact k11_rows_shard_22 index (Nat.le_of_not_gt h3) h4
  by_cases h5 : index < 17496
  · exact k11_rows_shard_23 index (Nat.le_of_not_gt h4) h5
  by_cases h6 : index < 18225
  · exact k11_rows_shard_24 index (Nat.le_of_not_gt h5) h6
  by_cases h7 : index < 18954
  · exact k11_rows_shard_25 index (Nat.le_of_not_gt h6) h7
  exact k11_rows_shard_26 index (Nat.le_of_not_gt h7) hhi

theorem k11_auxiliary_group_2 (index : Nat)
    (hlo : 4374 <= index)
    (hhi : index < 6561) :
    K11AuxiliaryValid index := by
  by_cases ha0 : index < 4617
  · exact k11_auxiliary_shard_18 index (hlo) ha0
  by_cases ha1 : index < 4860
  · exact k11_auxiliary_shard_19 index (Nat.le_of_not_gt ha0) ha1
  by_cases ha2 : index < 5103
  · exact k11_auxiliary_shard_20 index (Nat.le_of_not_gt ha1) ha2
  by_cases ha3 : index < 5346
  · exact k11_auxiliary_shard_21 index (Nat.le_of_not_gt ha2) ha3
  by_cases ha4 : index < 5589
  · exact k11_auxiliary_shard_22 index (Nat.le_of_not_gt ha3) ha4
  by_cases ha5 : index < 5832
  · exact k11_auxiliary_shard_23 index (Nat.le_of_not_gt ha4) ha5
  by_cases ha6 : index < 6075
  · exact k11_auxiliary_shard_24 index (Nat.le_of_not_gt ha5) ha6
  by_cases ha7 : index < 6318
  · exact k11_auxiliary_shard_25 index (Nat.le_of_not_gt ha6) ha7
  exact k11_auxiliary_shard_26 index (Nat.le_of_not_gt ha7) hhi

end CollatzClassical.KL2003.K11CertificateMatch
