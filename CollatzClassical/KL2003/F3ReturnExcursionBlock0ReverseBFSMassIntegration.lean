import CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandProfileSharded
import CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSVerifier

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
# Typed mass-demand adapter for the Block0 reverse-BFS verifier

This narrow integration layer removes the free natural-number demand from
the gate-facing API.  Execution uses the two-valued natural
`massDemandShadow`; theorem statements transport it through the proved
identity with `massDemand p = ceil (qHi p)` for the same active occurrence.
The generic verifier remains reusable and unchanged.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0ReverseBFSMassIntegration

open F3Block0ActiveCarrier
open F3Block0CarrierFibers
open F3Block0MassAtoms
open F3Block0MassDemandProfile
open F3Block0OrderedFirstHit
open F3Block0ReverseBFSData
open F3Block0ReverseBFSVerifier

def typedReverseBFSConfig (p : Active0Occurrence) : ReverseBFSConfig :=
  configOfOccurrence p
    (massDemandShadow (occurrenceFormulaEdge p.1))

/-- Untrusted generation with the owner-indexed demand fixed by type-level
input `p`. -/
def generateTypedReverseBFSCertificate
    (p : Active0Occurrence) : ReverseBFSCertificate :=
  generateReverseBFSCertificate (typedReverseBFSConfig p)

/-- Gate-facing checker: there is no caller-supplied demand to mismatch with
the occurrence's atom population. -/
def verifyTypedReverseBFSCertificate
    (p : Active0Occurrence) (cert : ReverseBFSCertificate) : Bool :=
  verifyReverseBFSCertificate p
    (massDemandShadow (occurrenceFormulaEdge p.1)) cert

theorem verifyTypedReverseBFSCertificate_eq_true_iff
    (p : Active0Occurrence) (cert : ReverseBFSCertificate) :
    verifyTypedReverseBFSCertificate p cert = true ↔
      ReverseBFSCertificateValid p (massDemand p) cert := by
  simpa [verifyTypedReverseBFSCertificate, massDemand_eq_shadow] using
    verifyReverseBFSCertificate_eq_true_iff p
      (massDemandShadow (occurrenceFormulaEdge p.1)) cert

theorem verified_typed_node_mem_orderedFirstHitFiber0
    {p : Active0Occurrence} {cert : ReverseBFSCertificate}
    {node : ReverseBFSNode}
    (hcert : verifyTypedReverseBFSCertificate p cert = true)
    (hnode : node ∈ cert.nodes) :
    node.value ∈ orderedFirstHitFiber0 p := by
  exact verified_node_mem_orderedFirstHitFiber0 hcert hnode

theorem verified_typed_nodes_length_le_massDemand
    {p : Active0Occurrence} {cert : ReverseBFSCertificate}
    (hcert : verifyTypedReverseBFSCertificate p cert = true) :
    cert.nodes.length ≤ massDemand p := by
  simpa [verifyTypedReverseBFSCertificate, massDemand_eq_shadow] using
    verified_nodes_length_le_demand hcert

theorem verified_typed_saturated_capacity
    {p : Active0Occurrence} {cert : ReverseBFSCertificate}
    (hcert : verifyTypedReverseBFSCertificate p cert = true)
    (hkind : cert.kind = .saturated) :
    massDemand p ≤ (orderedFirstHitFiber0 p).card := by
  simpa [verifyTypedReverseBFSCertificate, massDemand_eq_shadow] using
    verified_saturated_capacity hcert hkind

/-!
No theorem here turns deficient closure into an exact fibre cardinality.
That requires a separate induction from predecessor closure to every ordered
first-hit trajectory and remains an explicit mathematical/interface gap.
-/

end F3Block0ReverseBFSMassIntegration
end KL2003
end CollatzClassical
