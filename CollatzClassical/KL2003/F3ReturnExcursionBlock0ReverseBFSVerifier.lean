import CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSData
import CollatzClassical.KL2003.F3ReturnExcursionBlock0OrderedFirstHitBool

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
# Kernel verifier for Block0 reverse-BFS payloads

The verifier accepts arbitrary data, not merely output of the bundled
generator.  It checks range, duplicate freedom, earlier parent pointers,
every local `T` edge, the supplied ordered first-hit depth, and the
saturated-or-exactly-closed status.  Hence the untrusted generator is absent
from every soundness theorem statement.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0ReverseBFSVerifier

open F3Block0ActiveCarrier
open F3Block0OrderedFirstHit
open F3Block0OrderedFirstHitBool
open F3Block0ReverseBFSData

def NodeStructurallyValid
    (cfg : ReverseBFSConfig) (nodes : List ReverseBFSNode)
    (entry : Nat × ReverseBFSNode) : Prop :=
  1 ≤ entry.2.value ∧
  entry.2.value ≤ cfg.window ∧
  entry.2.value ≠ cfg.forbidden ∧
  if entry.1 = 0 then
    entry.2.value = cfg.target ∧
    entry.2.depth = 0 ∧
    entry.2.parentIndex = 0
  else
    entry.2.parentIndex < entry.1 ∧
    match nodes[entry.2.parentIndex]? with
    | none => False
    | some parent =>
        entry.2.depth = parent.depth + 1 ∧
        T entry.2.value = parent.value

def nodeStructurallyValidBool
    (cfg : ReverseBFSConfig) (nodes : List ReverseBFSNode)
    (entry : Nat × ReverseBFSNode) : Bool :=
  decide (1 ≤ entry.2.value) &&
  decide (entry.2.value ≤ cfg.window) &&
  decide (entry.2.value ≠ cfg.forbidden) &&
  if entry.1 = 0 then
    decide (entry.2.value = cfg.target) &&
    decide (entry.2.depth = 0) &&
    decide (entry.2.parentIndex = 0)
  else
    decide (entry.2.parentIndex < entry.1) &&
    match nodes[entry.2.parentIndex]? with
    | none => false
    | some parent =>
        decide (entry.2.depth = parent.depth + 1) &&
        decide (T entry.2.value = parent.value)

theorem nodeStructurallyValidBool_eq_true_iff
    (cfg : ReverseBFSConfig) (nodes : List ReverseBFSNode)
    (entry : Nat × ReverseBFSNode) :
    nodeStructurallyValidBool cfg nodes entry = true ↔
      NodeStructurallyValid cfg nodes entry := by
  unfold nodeStructurallyValidBool NodeStructurallyValid
  by_cases hzero : entry.1 = 0
  · simp [hzero, and_assoc]
  · simp [hzero, and_assoc]
    split <;> simp [and_assoc]

def ClosureRowValid
    (cfg : ReverseBFSConfig) (values : List Nat)
    (row : ReverseBFSClosureRow) : Prop :=
  row.predecessors.Nodup ∧
  row.predecessors.toFinset =
    preimagesWithin cfg.forbidden cfg.window row.value ∧
  row.predecessors.Forall (fun u => u ∈ values)

instance closureRowValidDecidable
    (cfg : ReverseBFSConfig) (values : List Nat)
    (row : ReverseBFSClosureRow) :
    Decidable (ClosureRowValid cfg values row) := by
  unfold ClosureRowValid
  infer_instance

def DeficientClosureValid
    (cfg : ReverseBFSConfig) (cert : ReverseBFSCertificate) : Prop :=
  cert.closureRows.map ReverseBFSClosureRow.value = nodeValues cert.nodes ∧
  cert.closureRows.Forall
    (ClosureRowValid cfg (nodeValues cert.nodes))

instance deficientClosureValidDecidable
    (cfg : ReverseBFSConfig) (cert : ReverseBFSCertificate) :
    Decidable (DeficientClosureValid cfg cert) := by
  unfold DeficientClosureValid
  infer_instance

/-- Full validity predicate.  The semantic checker is witness-indexed: the
certificate supplies `depth`, while Lean recomputes and checks that finite
orbit prefix. -/
def ReverseBFSCertificateValid
    (p : Active0Occurrence) (expectedDemand : Nat)
    (cert : ReverseBFSCertificate) : Prop :=
  let cfg := configOfOccurrence p expectedDemand
  cert.claimedDemand = expectedDemand ∧
  1 ≤ expectedDemand ∧
  cert.nodes ≠ [] ∧
  (nodeValues cert.nodes).Nodup ∧
  (∀ entry, entry ∈ cert.nodes.enum →
    nodeStructurallyValidBool cfg cert.nodes entry = true) ∧
  (∀ node, node ∈ cert.nodes →
    firstHitViaChildAtBool p node.value node.depth = true) ∧
  match cert.kind with
  | .saturated =>
      cert.nodes.length = expectedDemand ∧ cert.closureRows = []
  | .deficient =>
      cert.nodes.length < expectedDemand ∧
      DeficientClosureValid cfg cert

/-- Executable kernel checker.  It uses ordinary `decide`; no native or
compiler-trusting decision procedure occurs in this module. -/
def verifyReverseBFSCertificate
    (p : Active0Occurrence) (expectedDemand : Nat)
    (cert : ReverseBFSCertificate) : Bool :=
  let cfg := configOfOccurrence p expectedDemand
  decide (cert.claimedDemand = expectedDemand) &&
  decide (1 ≤ expectedDemand) &&
  decide (cert.nodes ≠ []) &&
  decide ((nodeValues cert.nodes).Nodup) &&
  cert.nodes.enum.all
    (nodeStructurallyValidBool cfg cert.nodes) &&
  cert.nodes.all (fun node =>
    firstHitViaChildAtBool p node.value node.depth) &&
  match cert.kind with
  | .saturated =>
      decide (cert.nodes.length = expectedDemand) &&
      decide (cert.closureRows = [])
  | .deficient =>
      decide (cert.nodes.length < expectedDemand) &&
      decide (DeficientClosureValid cfg cert)

theorem verifyReverseBFSCertificate_eq_true_iff
    (p : Active0Occurrence) (expectedDemand : Nat)
    (cert : ReverseBFSCertificate) :
    verifyReverseBFSCertificate p expectedDemand cert = true ↔
      ReverseBFSCertificateValid p expectedDemand cert := by
  unfold verifyReverseBFSCertificate ReverseBFSCertificateValid
  cases hkind : cert.kind <;>
    simp [hkind, and_assoc]

theorem verified_node_firstHitViaChildAt
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate} {node : ReverseBFSNode}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true)
    (hnode : node ∈ cert.nodes) :
    FirstHitViaChildAt p node.value node.depth := by
  have hvalid :=
    (verifyReverseBFSCertificate_eq_true_iff p expectedDemand cert).mp hcert
  have hbool := hvalid.2.2.2.2.2.1 node hnode
  exact (firstHitViaChildAtBool_eq_true_iff
    p node.value node.depth).mp hbool

theorem verified_node_firstHitViaChild
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate} {node : ReverseBFSNode}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true)
    (hnode : node ∈ cert.nodes) :
    FirstHitViaChild p node.value := by
  exact ⟨node.depth, verified_node_firstHitViaChildAt hcert hnode⟩

theorem verified_node_mem_orderedFirstHitFiber0
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate} {node : ReverseBFSNode}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true)
    (hnode : node ∈ cert.nodes) :
    node.value ∈ orderedFirstHitFiber0 p := by
  rw [mem_orderedFirstHitFiber0_iff]
  have hat := verified_node_firstHitViaChildAt hcert hnode
  have hatZero := hat.2.1 0 (Nat.zero_le node.depth)
  exact ⟨hatZero.2, hatZero.1,
    ⟨node.depth, hat⟩⟩

theorem verified_nodeValues_nodup
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true) :
    (nodeValues cert.nodes).Nodup := by
  have hvalid :=
    (verifyReverseBFSCertificate_eq_true_iff p expectedDemand cert).mp hcert
  exact hvalid.2.2.2.1

theorem verified_nodeValues_toFinset_subset
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true) :
    (nodeValues cert.nodes).toFinset ⊆ orderedFirstHitFiber0 p := by
  intro v hv
  have hvList : v ∈ nodeValues cert.nodes := by simpa using hv
  rcases List.mem_map.mp hvList with ⟨node, hnode, rfl⟩
  exact verified_node_mem_orderedFirstHitFiber0 hcert hnode

theorem verified_saturated_length
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true)
    (hkind : cert.kind = .saturated) :
    cert.nodes.length = expectedDemand := by
  have hvalid :=
    (verifyReverseBFSCertificate_eq_true_iff p expectedDemand cert).mp hcert
  rw [ReverseBFSCertificateValid, hkind] at hvalid
  exact hvalid.2.2.2.2.2.2.1

theorem verified_nodes_length_le_demand
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true) :
    cert.nodes.length ≤ expectedDemand := by
  have hvalid :=
    (verifyReverseBFSCertificate_eq_true_iff p expectedDemand cert).mp hcert
  cases hkind : cert.kind with
  | saturated =>
      exact (verified_saturated_length hcert hkind).le
  | deficient =>
      rw [ReverseBFSCertificateValid, hkind] at hvalid
      exact (hvalid.2.2.2.2.2.2.1).le

/-- A saturated payload supplies enough distinct, semantically checked
members for the independently supplied demand. -/
theorem verified_saturated_capacity
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true)
    (hkind : cert.kind = .saturated) :
    expectedDemand ≤ (orderedFirstHitFiber0 p).card := by
  have hlength := verified_saturated_length hcert hkind
  have hnodup := verified_nodeValues_nodup hcert
  have hsubset := verified_nodeValues_toFinset_subset hcert
  calc
    expectedDemand = cert.nodes.length := hlength.symm
    _ = (nodeValues cert.nodes).length := by simp [nodeValues]
    _ = (nodeValues cert.nodes).toFinset.card :=
      (List.toFinset_card_of_nodup hnodup).symm
    _ ≤ (orderedFirstHitFiber0 p).card := Finset.card_le_card hsubset

theorem verified_deficient_has_closure_row
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate} {v : Nat}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true)
    (hkind : cert.kind = .deficient)
    (hv : v ∈ nodeValues cert.nodes) :
    ∃ row ∈ cert.closureRows,
      row.value = v ∧
      ClosureRowValid (configOfOccurrence p expectedDemand)
        (nodeValues cert.nodes) row := by
  have hvalid :=
    (verifyReverseBFSCertificate_eq_true_iff p expectedDemand cert).mp hcert
  rw [ReverseBFSCertificateValid, hkind] at hvalid
  have hclosure := hvalid.2.2.2.2.2.2.2
  have hvRows : v ∈ cert.closureRows.map ReverseBFSClosureRow.value := by
    rw [hclosure.1]
    exact hv
  rcases List.mem_map.mp hvRows with ⟨row, hrow, hrval⟩
  exact ⟨row, hrow, hrval,
    (List.forall_iff_forall_mem.mp hclosure.2) row hrow⟩

/-- Exact closure consequence for a verified deficient certificate: every
bounded predecessor of every certified node is itself a certified value. -/
theorem verified_deficient_predecessor_closed
    {p : Active0Occurrence} {expectedDemand : Nat}
    {cert : ReverseBFSCertificate} {v u : Nat}
    (hcert : verifyReverseBFSCertificate p expectedDemand cert = true)
    (hkind : cert.kind = .deficient)
    (hv : v ∈ nodeValues cert.nodes)
    (hu : u ∈ preimagesWithin (parentRoot p) (childWindow0 p) v) :
    u ∈ nodeValues cert.nodes := by
  rcases verified_deficient_has_closure_row hcert hkind hv with
    ⟨row, hrow, hrval, hrowValid⟩
  have huRowFinset : u ∈ row.predecessors.toFinset := by
    rw [hrowValid.2.1]
    simpa [configOfOccurrence, hrval] using hu
  have huRow : u ∈ row.predecessors := by simpa using huRowFinset
  exact (List.forall_iff_forall_mem.mp hrowValid.2.2) u huRow

/-!
The verifier proves only finite certificate soundness and deficient closure.
It does not run the semantic gate, allocate mass atoms, compare the rational
margin, or assert an F3 exponent or density theorem.
-/

end F3Block0ReverseBFSVerifier
end KL2003
end CollatzClassical
