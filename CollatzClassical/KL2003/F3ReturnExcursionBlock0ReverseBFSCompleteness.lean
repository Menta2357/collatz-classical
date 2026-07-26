import CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSVerifier

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
# Completeness consequence for deficient Block0 reverse-BFS certificates

This module separates the negative-certificate argument from the generic
verifier.  A predicate containing the semantic child and closed under every
bounded, positive predecessor avoiding the parent contains every ordered
first-hit source.  Consequently, an accepted deficient certificate proves a
strict cardinality shortfall.

The saturated capacity theorem does not depend on this module.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0ReverseBFSCompleteness

open F3Block0ActiveCarrier
open F3Block0OrderedFirstHit
open F3Block0ReverseBFSData
open F3Block0ReverseBFSVerifier

/-- Descending along one ordered first-hit witness needs exactly the bounded
predecessor closure checked by a deficient certificate. -/
theorem firstHitViaChildAt_mem_of_reverse_closed
    {p : Active0Occurrence} {n h : Nat} {P : Nat → Prop}
    (htarget : P (semanticChildRoot p))
    (hclosed : ∀ {u v : Nat}, P v →
      u ∈ preimagesWithin (parentRoot p) (childWindow0 p) v → P u)
    (hvia : FirstHitViaChildAt p n h) :
    P n := by
  rcases hvia with
    ⟨hchild, hinside, havoid, _hsuffix, _hfirst⟩
  have hbase : P (T^[h] n) := by
    rw [hchild]
    exact htarget
  have hall : ∀ k, k ≤ h → P (T^[k] n) := by
    intro k hk
    refine Nat.decreasingInduction'
      (P := fun j => P (T^[j] n)) ?_ hk hbase
    intro j hjh _hkj hjSucc
    apply hclosed hjSucc
    rw [mem_preimagesWithin_iff]
    have hjle : j ≤ h := Nat.le_of_lt hjh
    exact
      ⟨(hinside j hjle).1,
        (hinside j hjle).2,
        havoid j hjle,
        by
          simpa [Nat.succ_eq_add_one] using
            (Function.iterate_succ_apply' T j n).symm⟩
  simpa using hall 0 (Nat.zero_le h)

/-- Every accepted certificate contains its independently derived semantic
child as the value of node zero. -/
theorem verified_target_mem_nodeValues
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true) :
    semanticChildRoot p ∈ nodeValues cert.nodes := by
  have hvalid :=
    (verifyReverseBFSCertificate_eq_true_iff
      p expectedDemand cert).mp hcert
  have hnonempty : cert.nodes ≠ [] := hvalid.2.2.1
  have hstruct := hvalid.2.2.2.2.1
  cases hnodes : cert.nodes with
  | nil =>
      exact (hnonempty hnodes).elim
  | cons head tail =>
      rw [hnodes] at hstruct
      have hheadBool :
          nodeStructurallyValidBool
            (configOfOccurrence p expectedDemand) (head :: tail)
            (0, head) = true :=
        hstruct (0, head) (by
          rw [List.mk_mem_enum_iff_getElem?]
          rfl)
      have hheadValid :
          NodeStructurallyValid
            (configOfOccurrence p expectedDemand) (head :: tail)
            (0, head) :=
        (nodeStructurallyValidBool_eq_true_iff
          (configOfOccurrence p expectedDemand) (head :: tail)
          (0, head)).mp hheadBool
      simp only [NodeStructurallyValid, if_pos rfl] at hheadValid
      have hvalue : head.value = semanticChildRoot p := by
        simpa [configOfOccurrence] using hheadValid.2.2.2.1
      simp [nodeValues, hvalue]

/-- Exact deficient closure contains every ordered first-hit source. -/
theorem verified_deficient_orderedFirstHitFiber0_subset
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true)
    (hkind : cert.kind = .deficient) :
    orderedFirstHitFiber0 p ⊆ (nodeValues cert.nodes).toFinset := by
  intro n hn
  have hmem := (mem_orderedFirstHitFiber0_iff p n).mp hn
  rcases hmem.2.2 with ⟨h, hvia⟩
  have hclosed :
      ∀ {u v : Nat}, v ∈ nodeValues cert.nodes →
        u ∈ preimagesWithin (parentRoot p) (childWindow0 p) v →
        u ∈ nodeValues cert.nodes := by
    intro u v hv hu
    exact verified_deficient_predecessor_closed hcert hkind hv hu
  have hnList : n ∈ nodeValues cert.nodes :=
    firstHitViaChildAt_mem_of_reverse_closed
      (P := fun u => u ∈ nodeValues cert.nodes)
      (verified_target_mem_nodeValues hcert) hclosed hvia
  simpa using hnList

/-- An accepted deficient certificate enumerates the whole ordered first-hit
fiber, not merely a subset of it. -/
theorem verified_deficient_orderedFirstHitFiber0_eq
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true)
    (hkind : cert.kind = .deficient) :
    orderedFirstHitFiber0 p = (nodeValues cert.nodes).toFinset := by
  apply Finset.Subset.antisymm
  · exact verified_deficient_orderedFirstHitFiber0_subset hcert hkind
  · exact verified_nodeValues_toFinset_subset hcert

/-- Exact deficient cardinal exposed for custody and boundary accounting. -/
theorem verified_deficient_fiber_card_eq_nodes_length
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true)
    (hkind : cert.kind = .deficient) :
    (orderedFirstHitFiber0 p).card = cert.nodes.length := by
  rw [verified_deficient_orderedFirstHitFiber0_eq hcert hkind]
  rw [List.toFinset_card_of_nodup (verified_nodeValues_nodup hcert)]
  simp [nodeValues]

/-- A verified deficient payload is a certified negative capacity result for
its supplied demand. -/
theorem verified_deficient_fiber_card_lt_demand
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true)
    (hkind : cert.kind = .deficient) :
    (orderedFirstHitFiber0 p).card < expectedDemand := by
  have hvalid :=
    (verifyReverseBFSCertificate_eq_true_iff
      p expectedDemand cert).mp hcert
  rw [ReverseBFSCertificateValid, hkind] at hvalid
  rw [verified_deficient_fiber_card_eq_nodes_length hcert hkind]
  exact hvalid.2.2.2.2.2.2.1

/-!
This is a one-row negative certificate only.  It does not run a frozen gate,
sum occurrence capacities, compare a mass margin, or prove an exponent or
density statement.
-/

end F3Block0ReverseBFSCompleteness
end KL2003
end CollatzClassical
