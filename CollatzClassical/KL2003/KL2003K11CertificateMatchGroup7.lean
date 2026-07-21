import CollatzClassical.KL2003.KL2003K11CertificateMatchShard63
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard64
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard65
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard66
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard67
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard68
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard69
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard70
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard71

namespace CollatzClassical.KL2003.K11CertificateMatch

theorem k11_rows_group_7 (index : Nat)
    (hlo : 45927 <= index)
    (hhi : index < 52488) : K11RowValid index := by
  by_cases h0 : index < 46656
  · exact k11_rows_shard_63 index (hlo) h0
  by_cases h1 : index < 47385
  · exact k11_rows_shard_64 index (Nat.le_of_not_gt h0) h1
  by_cases h2 : index < 48114
  · exact k11_rows_shard_65 index (Nat.le_of_not_gt h1) h2
  by_cases h3 : index < 48843
  · exact k11_rows_shard_66 index (Nat.le_of_not_gt h2) h3
  by_cases h4 : index < 49572
  · exact k11_rows_shard_67 index (Nat.le_of_not_gt h3) h4
  by_cases h5 : index < 50301
  · exact k11_rows_shard_68 index (Nat.le_of_not_gt h4) h5
  by_cases h6 : index < 51030
  · exact k11_rows_shard_69 index (Nat.le_of_not_gt h5) h6
  by_cases h7 : index < 51759
  · exact k11_rows_shard_70 index (Nat.le_of_not_gt h6) h7
  exact k11_rows_shard_71 index (Nat.le_of_not_gt h7) hhi

theorem k11_auxiliary_group_7 (index : Nat)
    (hlo : 15309 <= index)
    (hhi : index < 17496) :
    K11AuxiliaryValid index := by
  by_cases ha0 : index < 15552
  · exact k11_auxiliary_shard_63 index (hlo) ha0
  by_cases ha1 : index < 15795
  · exact k11_auxiliary_shard_64 index (Nat.le_of_not_gt ha0) ha1
  by_cases ha2 : index < 16038
  · exact k11_auxiliary_shard_65 index (Nat.le_of_not_gt ha1) ha2
  by_cases ha3 : index < 16281
  · exact k11_auxiliary_shard_66 index (Nat.le_of_not_gt ha2) ha3
  by_cases ha4 : index < 16524
  · exact k11_auxiliary_shard_67 index (Nat.le_of_not_gt ha3) ha4
  by_cases ha5 : index < 16767
  · exact k11_auxiliary_shard_68 index (Nat.le_of_not_gt ha4) ha5
  by_cases ha6 : index < 17010
  · exact k11_auxiliary_shard_69 index (Nat.le_of_not_gt ha5) ha6
  by_cases ha7 : index < 17253
  · exact k11_auxiliary_shard_70 index (Nat.le_of_not_gt ha6) ha7
  exact k11_auxiliary_shard_71 index (Nat.le_of_not_gt ha7) hhi

end CollatzClassical.KL2003.K11CertificateMatch
