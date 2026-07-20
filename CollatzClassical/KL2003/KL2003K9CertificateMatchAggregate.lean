import CollatzClassical.KL2003.KL2003K9CertificateMatchShard0
import CollatzClassical.KL2003.KL2003K9CertificateMatchShard1
import CollatzClassical.KL2003.KL2003K9CertificateMatchShard2
import CollatzClassical.KL2003.KL2003K9CertificateMatchShard3
import CollatzClassical.KL2003.KL2003K9CertificateMatchShard4
import CollatzClassical.KL2003.KL2003K9CertificateMatchShard5
import CollatzClassical.KL2003.KL2003K9CertificateMatchShard6
import CollatzClassical.KL2003.KL2003K9CertificateMatchShard7
import CollatzClassical.KL2003.KL2003K9CertificateMatchShard8

namespace CollatzClassical.KL2003.K9CertificateMatch

theorem k9_all_rows_valid (index : Nat) (hindex : index < 6561) :
    K9RowValid index := by
  by_cases h0 : index < 729
  · exact k9_rows_shard_0 index (by omega) h0
  by_cases h1 : index < 1458
  · exact k9_rows_shard_1 index (by omega) h1
  by_cases h2 : index < 2187
  · exact k9_rows_shard_2 index (by omega) h2
  by_cases h3 : index < 2916
  · exact k9_rows_shard_3 index (by omega) h3
  by_cases h4 : index < 3645
  · exact k9_rows_shard_4 index (by omega) h4
  by_cases h5 : index < 4374
  · exact k9_rows_shard_5 index (by omega) h5
  by_cases h6 : index < 5103
  · exact k9_rows_shard_6 index (by omega) h6
  by_cases h7 : index < 5832
  · exact k9_rows_shard_7 index (by omega) h7
  exact k9_rows_shard_8 index (by omega) hindex

theorem k9_all_auxiliary_valid (index : Nat) (hindex : index < 2187) :
    K9AuxiliaryValid index := by
  by_cases h0 : index < 243
  · exact k9_auxiliary_shard_0 index (by omega) h0
  by_cases h1 : index < 486
  · exact k9_auxiliary_shard_1 index (by omega) h1
  by_cases h2 : index < 729
  · exact k9_auxiliary_shard_2 index (by omega) h2
  by_cases h3 : index < 972
  · exact k9_auxiliary_shard_3 index (by omega) h3
  by_cases h4 : index < 1215
  · exact k9_auxiliary_shard_4 index (by omega) h4
  by_cases h5 : index < 1458
  · exact k9_auxiliary_shard_5 index (by omega) h5
  by_cases h6 : index < 1701
  · exact k9_auxiliary_shard_6 index (by omega) h6
  by_cases h7 : index < 1944
  · exact k9_auxiliary_shard_7 index (by omega) h7
  exact k9_auxiliary_shard_8 index (by omega) hindex

end CollatzClassical.KL2003.K9CertificateMatch
