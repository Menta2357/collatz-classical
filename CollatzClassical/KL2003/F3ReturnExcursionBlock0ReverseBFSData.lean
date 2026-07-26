import CollatzClassical.KL2003.F3ReturnExcursionBlock0ReversePredecessor
import CollatzClassical.KL2003.F3ReturnExcursionBlock0OrderedFirstHit
import Mathlib.Data.Finset.Sort

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
# Untrusted reverse-BFS payload for the ordered Block0 first-hit gate

This module contains only executable data structures and a deterministic
generator.  The generator is not used as a proof oracle: the companion
verifier recomputes every local Collatz edge and, for a deficient row, every
bounded predecessor set.

The search starts at the semantic child.  It processes nodes in breadth-first
order and inserts the arithmetically ordered members of `preimagesWithin`.
It stops as soon as `demand` distinct nodes have been found.  If the queue is
exhausted first, it emits one exact predecessor row for every retained node.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0ReverseBFSData

open F3Block0ActiveCarrier
open F3Block0OrderedFirstHit

/-- Static row coordinates.  A verifier derives these from the active
occurrence and the independently certified mass demand. -/
structure ReverseBFSConfig where
  forbidden : Nat
  target : Nat
  window : Nat
  demand : Nat
deriving Repr, DecidableEq

def configOfOccurrence (p : Active0Occurrence) (demand : Nat) :
    ReverseBFSConfig where
  forbidden := parentRoot p
  target := semanticChildRoot p
  window := childWindow0 p
  demand := demand

/-- Compact parent-pointer node.  `parentIndex` is meaningful for every node
except node zero. -/
structure ReverseBFSNode where
  value : Nat
  depth : Nat
  parentIndex : Nat
deriving Repr, DecidableEq

/-- A deficient certificate records a complete predecessor row for every
node.  Values, rather than proof terms, are the frozen payload. -/
structure ReverseBFSClosureRow where
  value : Nat
  predecessors : List Nat
deriving Repr, DecidableEq

inductive ReverseBFSCertificateKind where
  | saturated
  | deficient
deriving Repr, DecidableEq

/-- Generated payload for one active occurrence. -/
structure ReverseBFSCertificate where
  claimedDemand : Nat
  kind : ReverseBFSCertificateKind
  nodes : List ReverseBFSNode
  closureRows : List ReverseBFSClosureRow
deriving Repr, DecidableEq

def nodeValues (nodes : List ReverseBFSNode) : List Nat :=
  nodes.map ReverseBFSNode.value

def containsValue (nodes : List ReverseBFSNode) (u : Nat) : Bool :=
  nodes.any (fun node => node.value == u)

theorem predecessorCandidates_card_le_two (v : Nat) :
    (predecessorCandidates v).card ≤ 2 := by
  unfold predecessorCandidates
  split
  · exact (Finset.card_insert_le _ _).trans (by simp)
  · simp

theorem preimagesWithin_card_le_two (a x v : Nat) :
    (preimagesWithin a x v).card ≤ 2 := by
  unfold preimagesWithin
  exact (Finset.card_filter_le _ _).trans
    (predecessorCandidates_card_le_two v)

private def insertCandidate
    (parentIndex parentDepth : Nat)
    (nodes : List ReverseBFSNode) (u : Nat) : List ReverseBFSNode :=
  if containsValue nodes u then nodes
  else nodes ++ [{ value := u, depth := parentDepth + 1,
                   parentIndex := parentIndex }]

/-- Expand one queue entry.  `Finset.sort` fixes increasing natural-number
order for the at-most-two exact predecessor candidates. -/
def expandAt (cfg : ReverseBFSConfig) (parentIndex : Nat)
    (nodes : List ReverseBFSNode) : List ReverseBFSNode :=
  match nodes[parentIndex]? with
  | none => nodes
  | some parent =>
      let candidates :=
        (preimagesWithin cfg.forbidden cfg.window parent.value).sort (· ≤ ·)
      candidates.foldl
        (insertCandidate parentIndex parent.depth) nodes

/-- Fuelled deterministic BFS.  Fuel is the demanded node count.  This is
enough either to reach demand or to process every node of a deficient queue,
because a deficient queue contains strictly fewer than `demand` nodes. -/
def reverseBFSLoop (cfg : ReverseBFSConfig) :
    Nat → Nat → List ReverseBFSNode → List ReverseBFSNode
  | 0, _cursor, nodes => nodes
  | fuel + 1, cursor, nodes =>
      if cfg.demand ≤ nodes.length then nodes
      else
        match nodes[cursor]? with
        | none => nodes
        | some _ =>
            reverseBFSLoop cfg fuel (cursor + 1)
              (expandAt cfg cursor nodes)

def generatedNodes (cfg : ReverseBFSConfig) : List ReverseBFSNode :=
  reverseBFSLoop cfg cfg.demand 0
    [{ value := cfg.target, depth := 0, parentIndex := 0 }]

def generatedClosureRows (cfg : ReverseBFSConfig)
    (nodes : List ReverseBFSNode) : List ReverseBFSClosureRow :=
  nodes.map fun node =>
    { value := node.value
      predecessors :=
        (preimagesWithin cfg.forbidden cfg.window node.value).sort (· ≤ ·) }

/-- Deterministic candidate payload.  Its output remains untrusted until the
separate kernel verifier accepts it. -/
def generateReverseBFSCertificate
    (cfg : ReverseBFSConfig) : ReverseBFSCertificate :=
  let nodes := generatedNodes cfg
  if cfg.demand ≤ nodes.length then
    { claimedDemand := cfg.demand
      kind := .saturated
      nodes := nodes.take cfg.demand
      closureRows := [] }
  else
    { claimedDemand := cfg.demand
      kind := .deficient
      nodes := nodes
      closureRows := generatedClosureRows cfg nodes }

/-!
No theorem in this module asserts that generated data are valid.  In
particular, no semantic first-hit, fibre cardinality, margin, exponent or
density claim is made here.
-/

end F3Block0ReverseBFSData
end KL2003
end CollatzClassical
