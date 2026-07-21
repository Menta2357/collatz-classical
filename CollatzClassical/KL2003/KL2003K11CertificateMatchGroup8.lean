import CollatzClassical.KL2003.KL2003K11CertificateMatchShard72
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard73
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard74
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard75
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard76
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard77
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard78
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard79
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard80

namespace CollatzClassical.KL2003.K11CertificateMatch

theorem k11_rows_group_8 (index : Nat)
    (hlo : 52488 <= index)
    (hhi : index < 59049) : K11RowValid index := by
  by_cases h0 : index < 53217
  · exact k11_rows_shard_72 index (hlo) h0
  by_cases h1 : index < 53946
  · exact k11_rows_shard_73 index (Nat.le_of_not_gt h0) h1
  by_cases h2 : index < 54675
  · exact k11_rows_shard_74 index (Nat.le_of_not_gt h1) h2
  by_cases h3 : index < 55404
  · exact k11_rows_shard_75 index (Nat.le_of_not_gt h2) h3
  by_cases h4 : index < 56133
  · exact k11_rows_shard_76 index (Nat.le_of_not_gt h3) h4
  by_cases h5 : index < 56862
  · exact k11_rows_shard_77 index (Nat.le_of_not_gt h4) h5
  by_cases h6 : index < 57591
  · exact k11_rows_shard_78 index (Nat.le_of_not_gt h5) h6
  by_cases h7 : index < 58320
  · exact k11_rows_shard_79 index (Nat.le_of_not_gt h6) h7
  exact k11_rows_shard_80 index (Nat.le_of_not_gt h7) hhi

theorem k11_auxiliary_group_8 (index : Nat)
    (hlo : 17496 <= index)
    (hhi : index < 19683) :
    K11AuxiliaryValid index := by
  by_cases ha0 : index < 17739
  · exact k11_auxiliary_shard_72 index (hlo) ha0
  by_cases ha1 : index < 17982
  · exact k11_auxiliary_shard_73 index (Nat.le_of_not_gt ha0) ha1
  by_cases ha2 : index < 18225
  · exact k11_auxiliary_shard_74 index (Nat.le_of_not_gt ha1) ha2
  by_cases ha3 : index < 18468
  · exact k11_auxiliary_shard_75 index (Nat.le_of_not_gt ha2) ha3
  by_cases ha4 : index < 18711
  · exact k11_auxiliary_shard_76 index (Nat.le_of_not_gt ha3) ha4
  by_cases ha5 : index < 18954
  · exact k11_auxiliary_shard_77 index (Nat.le_of_not_gt ha4) ha5
  by_cases ha6 : index < 19197
  · exact k11_auxiliary_shard_78 index (Nat.le_of_not_gt ha5) ha6
  by_cases ha7 : index < 19440
  · exact k11_auxiliary_shard_79 index (Nat.le_of_not_gt ha6) ha7
  exact k11_auxiliary_shard_80 index (Nat.le_of_not_gt ha7) hhi

end CollatzClassical.KL2003.K11CertificateMatch
