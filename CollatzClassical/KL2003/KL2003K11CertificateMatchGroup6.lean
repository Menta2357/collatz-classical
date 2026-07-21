import CollatzClassical.KL2003.KL2003K11CertificateMatchShard54
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard55
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard56
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard57
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard58
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard59
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard60
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard61
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard62

namespace CollatzClassical.KL2003.K11CertificateMatch

theorem k11_rows_group_6 (index : Nat)
    (hlo : 39366 <= index)
    (hhi : index < 45927) : K11RowValid index := by
  by_cases h0 : index < 40095
  · exact k11_rows_shard_54 index (hlo) h0
  by_cases h1 : index < 40824
  · exact k11_rows_shard_55 index (Nat.le_of_not_gt h0) h1
  by_cases h2 : index < 41553
  · exact k11_rows_shard_56 index (Nat.le_of_not_gt h1) h2
  by_cases h3 : index < 42282
  · exact k11_rows_shard_57 index (Nat.le_of_not_gt h2) h3
  by_cases h4 : index < 43011
  · exact k11_rows_shard_58 index (Nat.le_of_not_gt h3) h4
  by_cases h5 : index < 43740
  · exact k11_rows_shard_59 index (Nat.le_of_not_gt h4) h5
  by_cases h6 : index < 44469
  · exact k11_rows_shard_60 index (Nat.le_of_not_gt h5) h6
  by_cases h7 : index < 45198
  · exact k11_rows_shard_61 index (Nat.le_of_not_gt h6) h7
  exact k11_rows_shard_62 index (Nat.le_of_not_gt h7) hhi

theorem k11_auxiliary_group_6 (index : Nat)
    (hlo : 13122 <= index)
    (hhi : index < 15309) :
    K11AuxiliaryValid index := by
  by_cases ha0 : index < 13365
  · exact k11_auxiliary_shard_54 index (hlo) ha0
  by_cases ha1 : index < 13608
  · exact k11_auxiliary_shard_55 index (Nat.le_of_not_gt ha0) ha1
  by_cases ha2 : index < 13851
  · exact k11_auxiliary_shard_56 index (Nat.le_of_not_gt ha1) ha2
  by_cases ha3 : index < 14094
  · exact k11_auxiliary_shard_57 index (Nat.le_of_not_gt ha2) ha3
  by_cases ha4 : index < 14337
  · exact k11_auxiliary_shard_58 index (Nat.le_of_not_gt ha3) ha4
  by_cases ha5 : index < 14580
  · exact k11_auxiliary_shard_59 index (Nat.le_of_not_gt ha4) ha5
  by_cases ha6 : index < 14823
  · exact k11_auxiliary_shard_60 index (Nat.le_of_not_gt ha5) ha6
  by_cases ha7 : index < 15066
  · exact k11_auxiliary_shard_61 index (Nat.le_of_not_gt ha6) ha7
  exact k11_auxiliary_shard_62 index (Nat.le_of_not_gt ha7) hhi

end CollatzClassical.KL2003.K11CertificateMatch
