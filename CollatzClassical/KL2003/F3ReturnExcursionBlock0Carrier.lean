import Mathlib.Data.Finset.Card
import Mathlib.Data.Finset.Interval

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Definition-first carrier for the fixed finite F3 block.

This module only identifies the roots in `[3, 2919)` congruent to two modulo
three and separates the prefix already inspected from its complement.  It
performs no transition computation and states no boundary fraction,
operator-to-fibres comparison, exponent, or density conclusion.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0Carrier

/-! ## The fixed root carrier -/

/-- The 972 roots are indexed in increasing order. -/
abbrev Block0Root := Fin 972

theorem block0Root_card : Fintype.card Block0Root = 972 := by
  simp

/-- The root with index `i` is `5 + 3*i`. -/
def rootValue (i : Block0Root) : Nat :=
  5 + 3 * i.1

theorem rootValue_lower (i : Block0Root) :
    3 ≤ rootValue i := by
  simp only [rootValue]
  omega

theorem rootValue_upper (i : Block0Root) :
    rootValue i < 2919 := by
  have hi := i.2
  simp only [rootValue]
  omega

theorem rootValue_mod3 (i : Block0Root) :
    rootValue i % 3 = 2 := by
  simp [rootValue]

theorem rootValue_eq_iff (i j : Block0Root) :
    rootValue i = rootValue j ↔ i = j := by
  constructor
  · intro hij
    apply Fin.ext
    simp only [rootValue] at hij
    omega
  · intro hij
    rw [hij]

/-- Literal membership predicate for the fixed root block. -/
def IsBlock0RootValue (n : Nat) : Prop :=
  3 ≤ n ∧ n < 2919 ∧ n % 3 = 2

theorem rootValue_isBlock0RootValue (i : Block0Root) :
    IsBlock0RootValue (rootValue i) := by
  exact ⟨rootValue_lower i, rootValue_upper i, rootValue_mod3 i⟩

theorem isBlock0RootValue_iff_existsUnique (n : Nat) :
    IsBlock0RootValue n ↔ ∃! i : Block0Root, rootValue i = n := by
  constructor
  · rintro ⟨hnlow, hnup, hnmod⟩
    have hsplit := Nat.div_add_mod n 3
    have hindex : n / 3 - 1 < 972 := by
      omega
    let i : Block0Root := ⟨n / 3 - 1, hindex⟩
    refine ⟨i, ?_, ?_⟩
    · simp only [rootValue, i]
      omega
    · intro j hj
      apply (rootValue_eq_iff j i).mp
      rw [hj]
      simp only [rootValue, i]
      omega
  · rintro ⟨i, hi, _⟩
    rw [← hi]
    exact rootValue_isBlock0RootValue i

/-! ## The previously inspected prefix and its complement -/

/-- Canonical indices for the 41 roots below `128`. -/
abbrev Block0SeenIndex := Fin 41

/-- Canonical indices for the other 931 roots. -/
abbrev Block0FreshIndex := Fin 931

theorem block0SeenIndex_card : Fintype.card Block0SeenIndex = 41 := by
  simp

theorem block0FreshIndex_card : Fintype.card Block0FreshIndex = 931 := by
  simp

def seenRoot (i : Block0SeenIndex) : Block0Root :=
  ⟨i.1, by have hi := i.2; omega⟩

def freshRoot (i : Block0FreshIndex) : Block0Root :=
  ⟨41 + i.1, by have hi := i.2; omega⟩

theorem seenRoot_value_lt (i : Block0SeenIndex) :
    rootValue (seenRoot i) < 128 := by
  have hi := i.2
  simp only [rootValue, seenRoot]
  omega

theorem freshRoot_value_ge (i : Block0FreshIndex) :
    128 ≤ rootValue (freshRoot i) := by
  simp only [rootValue, freshRoot]
  omega

theorem rootValue_lt_128_iff (i : Block0Root) :
    rootValue i < 128 ↔ i.1 < 41 := by
  simp only [rootValue]
  omega

/-- Every root belongs to exactly one of the canonical carriers of sizes
41 and 931. -/
def classifyRoot (i : Block0Root) : Block0SeenIndex ⊕ Block0FreshIndex :=
  if h : i.1 < 41 then
    Sum.inl ⟨i.1, h⟩
  else
    Sum.inr ⟨i.1 - 41, by have hi := i.2; omega⟩

def assembleRoot : Block0SeenIndex ⊕ Block0FreshIndex → Block0Root
  | Sum.inl i => seenRoot i
  | Sum.inr i => freshRoot i

theorem assembleRoot_classifyRoot (i : Block0Root) :
    assembleRoot (classifyRoot i) = i := by
  unfold classifyRoot
  split
  · simp [assembleRoot, seenRoot]
  · simp only [assembleRoot, freshRoot]
    apply Fin.ext
    simp
    omega

theorem classifyRoot_assembleRoot
    (i : Block0SeenIndex ⊕ Block0FreshIndex) :
    classifyRoot (assembleRoot i) = i := by
  cases i with
  | inl i =>
      simp [assembleRoot, classifyRoot, seenRoot, i.2]
  | inr i =>
      have hi := i.2
      simp [assembleRoot, classifyRoot, freshRoot]

/-!
The mutually inverse maps above certify, without enumeration, that the
972-element root carrier is the disjoint union of carriers with 41 and 931
elements.  Arithmetic-state fibres and the root-to-formula-occurrence
reindexing belong to the dependent extension module.  Nothing above defines
retained paths or a semantic boundary.
-/

end F3Block0Carrier
end KL2003
end CollatzClassical
