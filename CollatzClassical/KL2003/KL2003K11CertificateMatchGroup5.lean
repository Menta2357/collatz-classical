import CollatzClassical.KL2003.KL2003K11CertificateMatchShard45
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard46
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard47
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard48
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard49
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard50
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard51
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard52
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard53

namespace CollatzClassical.KL2003.K11CertificateMatch

theorem k11_rows_group_5 (index : Nat)
    (hlo : 32805 <= index)
    (hhi : index < 39366) : K11RowValid index := by
  by_cases h0 : index < 33534
  · exact k11_rows_shard_45 index (hlo) h0
  by_cases h1 : index < 34263
  · exact k11_rows_shard_46 index (Nat.le_of_not_gt h0) h1
  by_cases h2 : index < 34992
  · exact k11_rows_shard_47 index (Nat.le_of_not_gt h1) h2
  by_cases h3 : index < 35721
  · exact k11_rows_shard_48 index (Nat.le_of_not_gt h2) h3
  by_cases h4 : index < 36450
  · exact k11_rows_shard_49 index (Nat.le_of_not_gt h3) h4
  by_cases h5 : index < 37179
  · exact k11_rows_shard_50 index (Nat.le_of_not_gt h4) h5
  by_cases h6 : index < 37908
  · exact k11_rows_shard_51 index (Nat.le_of_not_gt h5) h6
  by_cases h7 : index < 38637
  · exact k11_rows_shard_52 index (Nat.le_of_not_gt h6) h7
  exact k11_rows_shard_53 index (Nat.le_of_not_gt h7) hhi

theorem k11_auxiliary_group_5 (index : Nat)
    (hlo : 10935 <= index)
    (hhi : index < 13122) :
    K11AuxiliaryValid index := by
  by_cases ha0 : index < 11178
  · exact k11_auxiliary_shard_45 index (hlo) ha0
  by_cases ha1 : index < 11421
  · exact k11_auxiliary_shard_46 index (Nat.le_of_not_gt ha0) ha1
  by_cases ha2 : index < 11664
  · exact k11_auxiliary_shard_47 index (Nat.le_of_not_gt ha1) ha2
  by_cases ha3 : index < 11907
  · exact k11_auxiliary_shard_48 index (Nat.le_of_not_gt ha2) ha3
  by_cases ha4 : index < 12150
  · exact k11_auxiliary_shard_49 index (Nat.le_of_not_gt ha3) ha4
  by_cases ha5 : index < 12393
  · exact k11_auxiliary_shard_50 index (Nat.le_of_not_gt ha4) ha5
  by_cases ha6 : index < 12636
  · exact k11_auxiliary_shard_51 index (Nat.le_of_not_gt ha5) ha6
  by_cases ha7 : index < 12879
  · exact k11_auxiliary_shard_52 index (Nat.le_of_not_gt ha6) ha7
  exact k11_auxiliary_shard_53 index (Nat.le_of_not_gt ha7) hhi

end CollatzClassical.KL2003.K11CertificateMatch
