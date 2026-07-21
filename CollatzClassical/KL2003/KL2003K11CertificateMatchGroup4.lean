import CollatzClassical.KL2003.KL2003K11CertificateMatchShard36
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard37
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard38
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard39
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard40
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard41
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard42
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard43
import CollatzClassical.KL2003.KL2003K11CertificateMatchShard44

namespace CollatzClassical.KL2003.K11CertificateMatch

theorem k11_rows_group_4 (index : Nat)
    (hlo : 26244 <= index)
    (hhi : index < 32805) : K11RowValid index := by
  by_cases h0 : index < 26973
  · exact k11_rows_shard_36 index (hlo) h0
  by_cases h1 : index < 27702
  · exact k11_rows_shard_37 index (Nat.le_of_not_gt h0) h1
  by_cases h2 : index < 28431
  · exact k11_rows_shard_38 index (Nat.le_of_not_gt h1) h2
  by_cases h3 : index < 29160
  · exact k11_rows_shard_39 index (Nat.le_of_not_gt h2) h3
  by_cases h4 : index < 29889
  · exact k11_rows_shard_40 index (Nat.le_of_not_gt h3) h4
  by_cases h5 : index < 30618
  · exact k11_rows_shard_41 index (Nat.le_of_not_gt h4) h5
  by_cases h6 : index < 31347
  · exact k11_rows_shard_42 index (Nat.le_of_not_gt h5) h6
  by_cases h7 : index < 32076
  · exact k11_rows_shard_43 index (Nat.le_of_not_gt h6) h7
  exact k11_rows_shard_44 index (Nat.le_of_not_gt h7) hhi

theorem k11_auxiliary_group_4 (index : Nat)
    (hlo : 8748 <= index)
    (hhi : index < 10935) :
    K11AuxiliaryValid index := by
  by_cases ha0 : index < 8991
  · exact k11_auxiliary_shard_36 index (hlo) ha0
  by_cases ha1 : index < 9234
  · exact k11_auxiliary_shard_37 index (Nat.le_of_not_gt ha0) ha1
  by_cases ha2 : index < 9477
  · exact k11_auxiliary_shard_38 index (Nat.le_of_not_gt ha1) ha2
  by_cases ha3 : index < 9720
  · exact k11_auxiliary_shard_39 index (Nat.le_of_not_gt ha2) ha3
  by_cases ha4 : index < 9963
  · exact k11_auxiliary_shard_40 index (Nat.le_of_not_gt ha3) ha4
  by_cases ha5 : index < 10206
  · exact k11_auxiliary_shard_41 index (Nat.le_of_not_gt ha4) ha5
  by_cases ha6 : index < 10449
  · exact k11_auxiliary_shard_42 index (Nat.le_of_not_gt ha5) ha6
  by_cases ha7 : index < 10692
  · exact k11_auxiliary_shard_43 index (Nat.le_of_not_gt ha6) ha7
  exact k11_auxiliary_shard_44 index (Nat.le_of_not_gt ha7) hhi

end CollatzClassical.KL2003.K11CertificateMatch
