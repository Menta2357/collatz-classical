import CollatzClassical.KL2003.F3ReturnExcursionBlock0OrderedFirstHit

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Executable, witness-indexed checker for the ordered Block0 first-entry
predicate.  A reverse certificate supplies `h`; this module checks that one
finite orbit prefix and proves an iff with the Prop-level specification.  It
does not search for `h` and does not execute the semantic gate.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0OrderedFirstHitBool

open F3Block0ActiveCarrier
open F3Block0OrderedFirstHit

instance channelSuffixDecidable (p : Active0Occurrence) :
    Decidable (ChannelSuffix p) := by
  unfold ChannelSuffix
  split <;> infer_instance

def prefixInsideBool (p : Active0Occurrence) (n h : Nat) : Bool :=
  decide (∀ j : Fin (h + 1),
    1 ≤ T^[j.1] n ∧ T^[j.1] n ≤ childWindow0 p)

def avoidsParentBool (p : Active0Occurrence) (n h : Nat) : Bool :=
  decide (∀ j : Fin (h + 1), T^[j.1] n ≠ parentRoot p)

def firstHitsAtBool (a n k : Nat) : Bool :=
  decide (T^[k] n = a ∧
    ∀ j : Fin k, T^[j.1] n ≠ a)

def firstHitViaChildAtBool
    (p : Active0Occurrence) (n h : Nat) : Bool :=
  decide (T^[h] n = semanticChildRoot p) &&
  prefixInsideBool p n h &&
  avoidsParentBool p n h &&
  decide (ChannelSuffix p) &&
  firstHitsAtBool (parentRoot p) n (h + suffixLength p)

theorem prefixInsideBool_eq_true_iff
    (p : Active0Occurrence) (n h : Nat) :
    prefixInsideBool p n h = true ↔
      ∀ j, j ≤ h →
        1 ≤ T^[j] n ∧ T^[j] n ≤ childWindow0 p := by
  rw [prefixInsideBool, decide_eq_true_eq]
  constructor
  · intro hall j hj
    exact hall ⟨j, by omega⟩
  · intro hall j
    exact hall j.1 (by omega)

theorem avoidsParentBool_eq_true_iff
    (p : Active0Occurrence) (n h : Nat) :
    avoidsParentBool p n h = true ↔
      ∀ j, j ≤ h → T^[j] n ≠ parentRoot p := by
  rw [avoidsParentBool, decide_eq_true_eq]
  constructor
  · intro hall j hj
    exact hall ⟨j, by omega⟩
  · intro hall j
    exact hall j.1 (by omega)

theorem firstHitsAtBool_eq_true_iff (a n k : Nat) :
    firstHitsAtBool a n k = true ↔ FirstHitsAt a n k := by
  rw [firstHitsAtBool, decide_eq_true_eq]
  constructor
  · rintro ⟨hhit, hall⟩
    exact ⟨hhit, fun j hj => hall ⟨j, hj⟩⟩
  · rintro ⟨hhit, hall⟩
    exact ⟨hhit, fun j => hall j.1 j.2⟩

theorem firstHitViaChildAtBool_eq_true_iff
    (p : Active0Occurrence) (n h : Nat) :
    firstHitViaChildAtBool p n h = true ↔
      FirstHitViaChildAt p n h := by
  simp only [firstHitViaChildAtBool, Bool.and_eq_true,
    decide_eq_true_eq, prefixInsideBool_eq_true_iff,
    avoidsParentBool_eq_true_iff, firstHitsAtBool_eq_true_iff,
    FirstHitViaChildAt]
  constructor
  · rintro ⟨⟨⟨⟨hchild, hinside⟩, havoid⟩, hsuffix⟩, hfirst⟩
    exact ⟨hchild, hinside, havoid, hsuffix, hfirst⟩
  · rintro ⟨hchild, hinside, havoid, hsuffix, hfirst⟩
    exact ⟨⟨⟨⟨hchild, hinside⟩, havoid⟩, hsuffix⟩, hfirst⟩

theorem firstHitViaChildAtBool_sound
    {p : Active0Occurrence} {n h : Nat}
    (hcheck : firstHitViaChildAtBool p n h = true) :
    FirstHitViaChild p n := by
  exact ⟨h, (firstHitViaChildAtBool_eq_true_iff p n h).mp hcheck⟩

theorem firstHitViaChildAtBool_complete
    {p : Active0Occurrence} {n h : Nat}
    (hvia : FirstHitViaChildAt p n h) :
    firstHitViaChildAtBool p n h = true := by
  exact (firstHitViaChildAtBool_eq_true_iff p n h).mpr hvia

/-!
Scope: finite Boolean/Proposition fidelity for a supplied witness only.  No
existential trajectory search, reverse BFS payload, capacity, boundary,
exponent, or density result is introduced.
-/

end F3Block0OrderedFirstHitBool
end KL2003
end CollatzClassical
