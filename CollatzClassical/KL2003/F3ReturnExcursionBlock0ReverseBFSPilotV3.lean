import CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotRowsV3
import CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotPayloadsV3
import CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSMassIntegration
import CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSCompleteness

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

/-!
# Branch-complete acceptance for the six frozen reverse-BFS rows

The generated payload remains untrusted.  Each public check below is proved by
ordinary kernel reduction of the typed checker.  A checker-accepted payload is
then classified exhaustively as saturated or deficient; deficiency is valid
mathematical evidence for the selected owner, not an elaboration failure and
not an F3-wide conclusion.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0ReverseBFSPilotV3

open F3Block0ActiveCarrier
open F3Block0MassAtoms
open F3Block0MassDemandProfile
open F3Block0OrderedFirstHit
open F3Block0ReverseBFSData
open F3Block0ReverseBFSVerifier
open F3Block0ReverseBFSMassIntegration
open F3Block0ReverseBFSCompleteness
open F3Block0ReverseBFSPilotRowsV3
open F3Block0ReverseBFSPilotPayloadsV3

/-- Exact branch-complete meaning of a checker-accepted typed certificate. -/
inductive VerifiedTypedReverseBFSOutcome
    (p : Active0Occurrence) (cert : ReverseBFSCertificate) : Prop
  | saturated
      (hkind : cert.kind = .saturated)
      (hcapacity :
        massDemand p ≤ (orderedFirstHitFiber0 p).card)
  | deficient
      (hkind : cert.kind = .deficient)
      (hfiber :
        orderedFirstHitFiber0 p =
          (nodeValues cert.nodes).toFinset)
      (hcard :
        (orderedFirstHitFiber0 p).card = cert.nodes.length)
      (hshort :
        (orderedFirstHitFiber0 p).card < massDemand p)

/-- The typed Boolean checker admits exactly the saturated and deficient
branches.  In the deficient branch the owner-indexed check is transported to
the generic checker before the three completeness consequences are consumed. -/
theorem verifiedTypedReverseBFSOutcome_of_check
    {p : Active0Occurrence} {cert : ReverseBFSCertificate}
    (hcheck : verifyTypedReverseBFSCertificate p cert = true) :
    VerifiedTypedReverseBFSOutcome p cert := by
  cases hkind : cert.kind with
  | saturated =>
      exact .saturated hkind
        (verified_typed_saturated_capacity hcheck hkind)
  | deficient =>
      have hgeneric :
          verifyReverseBFSCertificate p (massDemand p) cert = true := by
        simpa [verifyTypedReverseBFSCertificate, massDemand_eq_shadow] using
          hcheck
      exact .deficient hkind
        (verified_deficient_orderedFirstHitFiber0_eq hgeneric hkind)
        (verified_deficient_fiber_card_eq_nodes_length hgeneric hkind)
        (verified_deficient_fiber_card_lt_demand hgeneric hkind)

theorem fixedRow01_check :
    verifyTypedReverseBFSCertificate fixedRow01.occurrence
      fixedRow01Certificate = true := by
  decide

theorem fixedRow02_check :
    verifyTypedReverseBFSCertificate fixedRow02.occurrence
      fixedRow02Certificate = true := by
  decide

theorem fixedRow03_check :
    verifyTypedReverseBFSCertificate fixedRow03.occurrence
      fixedRow03Certificate = true := by
  decide

theorem fixedRow04_check :
    verifyTypedReverseBFSCertificate fixedRow04.occurrence
      fixedRow04Certificate = true := by
  decide

theorem fixedRow05_check :
    verifyTypedReverseBFSCertificate fixedRow05.occurrence
      fixedRow05Certificate = true := by
  decide

theorem fixedRow06_check :
    verifyTypedReverseBFSCertificate fixedRow06.occurrence
      fixedRow06Certificate = true := by
  decide

theorem fixedRow01_outcome :
    VerifiedTypedReverseBFSOutcome fixedRow01.occurrence
      fixedRow01Certificate := by
  exact verifiedTypedReverseBFSOutcome_of_check fixedRow01_check

theorem fixedRow02_outcome :
    VerifiedTypedReverseBFSOutcome fixedRow02.occurrence
      fixedRow02Certificate := by
  exact verifiedTypedReverseBFSOutcome_of_check fixedRow02_check

theorem fixedRow03_outcome :
    VerifiedTypedReverseBFSOutcome fixedRow03.occurrence
      fixedRow03Certificate := by
  exact verifiedTypedReverseBFSOutcome_of_check fixedRow03_check

theorem fixedRow04_outcome :
    VerifiedTypedReverseBFSOutcome fixedRow04.occurrence
      fixedRow04Certificate := by
  exact verifiedTypedReverseBFSOutcome_of_check fixedRow04_check

theorem fixedRow05_outcome :
    VerifiedTypedReverseBFSOutcome fixedRow05.occurrence
      fixedRow05Certificate := by
  exact verifiedTypedReverseBFSOutcome_of_check fixedRow05_check

theorem fixedRow06_outcome :
    VerifiedTypedReverseBFSOutcome fixedRow06.occurrence
      fixedRow06Certificate := by
  exact verifiedTypedReverseBFSOutcome_of_check fixedRow06_check

end F3Block0ReverseBFSPilotV3
end KL2003
end CollatzClassical
