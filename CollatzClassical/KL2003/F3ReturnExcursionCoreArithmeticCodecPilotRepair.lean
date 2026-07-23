import CollatzClassical.KL2003.F3ReturnExcursionExactCoreMatrix

set_option maxHeartbeats 200000

/-!
Static repair candidate for the F3 arithmetic-codec pilot.

The executable data in this file are arithmetic formulae.  No auxiliary
edge catalogue or finite-state search structure is introduced.  The only
legacy object mentioned is `F3ExactCoreMatrix.coreEdges`, through its first
81 entries and the positional index `pilotFrozenPos`.

This is a new module: it does not overwrite the custodied failed pilot.  Its
only contact with the
historical literal is one explicitly audited definitional normalization; all public
comparison results pass through arithmetic generation and saturation.

Compilation is not authorized by this source.  The controlling execution
contract is `F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_CONTRACT_v1`.
-/

namespace CollatzClassical
namespace KL2003
namespace F3CoreArithmeticCodecPilotRepair

open F3ExactCoreMatrix

/-! ## Arithmetic codec -/

def encodeNat (i : Fin 243) : Nat :=
  9 * (i.1 / 3) + 6 + i.1 % 3

theorem encodeNat_lt_729 (i : Fin 243) : encodeNat i < 729 := by
  have hi := i.2
  have hr : i.1 % 3 < 3 := Nat.mod_lt _ (by omega)
  unfold encodeNat
  omega

theorem encodeNat_mod9 (i : Fin 243) :
    encodeNat i % 9 = 6 + i.1 % 3 := by
  have hr : i.1 % 3 < 3 := Nat.mod_lt _ (by omega)
  unfold encodeNat
  omega

def CoreCode :=
  {n : Fin 729 // n.1 % 9 = 6 ∨ n.1 % 9 = 7 ∨ n.1 % 9 = 8}

def encode (i : Fin 243) : CoreCode :=
  ⟨⟨encodeNat i, encodeNat_lt_729 i⟩, by
    have hm := encodeNat_mod9 i
    have hr : i.1 % 3 < 3 := Nat.mod_lt _ (by omega)
    have hcases : i.1 % 3 = 0 ∨ i.1 % 3 = 1 ∨ i.1 % 3 = 2 := by
      omega
    rcases hcases with h0 | h1 | h2
    · exact Or.inl (by omega)
    · exact Or.inr (Or.inl (by omega))
    · exact Or.inr (Or.inr (by omega))⟩

theorem encode_mem_coreCode (i : Fin 243) :
    (encode i).1.1 % 9 = 6 ∨
    (encode i).1.1 % 9 = 7 ∨
    (encode i).1.1 % 9 = 8 :=
  (encode i).2

def decodeNat (n : CoreCode) : Nat :=
  3 * (n.1.1 / 9) + (n.1.1 % 9 - 6)

theorem decodeNat_lt_243 (n : CoreCode) : decodeNat n < 243 := by
  have hn := n.1.2
  have hr : n.1.1 % 9 < 9 := Nat.mod_lt _ (by omega)
  have hsplit := Nat.div_add_mod n.1.1 9
  rcases n.2 with h6 | h7 | h8
  · unfold decodeNat
    omega
  · unfold decodeNat
    omega
  · unfold decodeNat
    omega

def decode (n : CoreCode) : Fin 243 :=
  ⟨decodeNat n, decodeNat_lt_243 n⟩

theorem decode_encode (i : Fin 243) : decode (encode i) = i := by
  apply Fin.ext
  have hsplit := Nat.div_add_mod i.1 3
  have hr : i.1 % 3 < 3 := Nat.mod_lt _ (by omega)
  change
    3 * ((9 * (i.1 / 3) + 6 + i.1 % 3) / 9) +
        ((9 * (i.1 / 3) + 6 + i.1 % 3) % 9 - 6) = i.1
  omega

theorem encode_decode (n : CoreCode) : encode (decode n) = n := by
  apply Subtype.ext
  apply Fin.ext
  have hn := n.1.2
  have hr : n.1.1 % 9 < 9 := Nat.mod_lt _ (by omega)
  have hsplit := Nat.div_add_mod n.1.1 9
  rcases n.2 with h6 | h7 | h8
  · change
      9 * ((3 * (n.1.1 / 9) + (n.1.1 % 9 - 6)) / 3) + 6 +
          (3 * (n.1.1 / 9) + (n.1.1 % 9 - 6)) % 3 = n.1.1
    omega
  · change
      9 * ((3 * (n.1.1 / 9) + (n.1.1 % 9 - 6)) / 3) + 6 +
          (3 * (n.1.1 / 9) + (n.1.1 % 9 - 6)) % 3 = n.1.1
    omega
  · change
      9 * ((3 * (n.1.1 / 9) + (n.1.1 % 9 - 6)) / 3) + 6 +
          (3 * (n.1.1 / 9) + (n.1.1 % 9 - 6)) % 3 = n.1.1
    omega

theorem encode_injective : Function.Injective encode := by
  intro i j hij
  have h := congrArg decode hij
  simpa only [decode_encode] using h

theorem decode_injective : Function.Injective decode := by
  intro n m hnm
  have h := congrArg encode hnm
  simpa only [encode_decode] using h

def coreCodeEquiv : Fin 243 ≃ CoreCode where
  toFun := encode
  invFun := decode
  left_inv := decode_encode
  right_inv := encode_decode

noncomputable instance coreCodeFintype : Fintype CoreCode :=
  Fintype.ofEquiv (Fin 243) coreCodeEquiv

theorem coreCode_card : Fintype.card CoreCode = 243 := by
  calc
    Fintype.card CoreCode = Fintype.card (Fin 243) :=
      Fintype.card_congr coreCodeEquiv.symm
    _ = 243 := by simp

/-! ## Arithmetic reconstruction of a frozen state -/

def bucketCode (x : Nat) : Nat :=
  if x % 2 = 1 then 0
  else if x % 4 = 2 then 1
  else 2

theorem bucketCode_lt_three (x : Nat) : bucketCode x < 3 := by
  by_cases h2 : x % 2 = 1
  · simp [bucketCode, h2]
  · by_cases h4 : x % 4 = 2
    · simp [bucketCode, h2, h4]
    · simp [bucketCode, h2, h4]

def stateCodeNat (x : Nat) : Nat :=
  3 * (x % 243) + bucketCode x

theorem stateCodeNat_lt_729 (x : Nat) : stateCodeNat x < 729 := by
  have hr := Nat.mod_lt x (by omega : 0 < 243)
  have hb := bucketCode_lt_three x
  unfold stateCodeNat
  omega

theorem stateCodeNat_mod9 (x : Nat) (hx : x % 3 = 2) :
    stateCodeNat x % 9 = 6 + bucketCode x := by
  have hr := Nat.mod_lt x (by omega : 0 < 243)
  have hb := bucketCode_lt_three x
  have hcompat : (x % 243) % 3 = 2 := by
    rw [Nat.mod_mod_of_dvd x (by norm_num : 3 ∣ 243)]
    exact hx
  have hsplit := Nat.div_add_mod (x % 243) 3
  unfold stateCodeNat
  omega

/-- `stateCode` is defined exactly on integers congruent to two modulo three. -/
def stateCode (x : Nat) (hx : x % 3 = 2) : CoreCode :=
  ⟨⟨stateCodeNat x, stateCodeNat_lt_729 x⟩, by
    have hm := stateCodeNat_mod9 x hx
    have hb := bucketCode_lt_three x
    change
      stateCodeNat x % 9 = 6 ∨
      stateCodeNat x % 9 = 7 ∨
      stateCodeNat x % 9 = 8
    omega⟩

theorem decode_stateCode_affine_val
    (x k b : Nat)
    (hx : x = 3 * k + 2)
    (hb : bucketCode x = b)
    (hb3 : b < 3)
    (hx3 : x % 3 = 2) :
    (decode (stateCode x hx3)).1 = 3 * (k % 81) + b := by
  change
    3 * ((3 * (x % 243) + bucketCode x) / 9) +
        ((3 * (x % 243) + bucketCode x) % 9 - 6) =
      3 * (k % 81) + b
  omega

def n0 (i : Fin 243) (ell : Fin 3) : Nat :=
  3 * (i.1 / 3) + 2 + 243 * ell.1

def adjust (b n : Nat) : Nat :=
  if b = 0 then
    (1 + 2 - n % 2) % 2
  else if b = 1 then
    (2 + 4 - n % 4) % 4
  else
    (4 - n % 4) % 4

def a (i : Fin 243) (ell : Fin 3) : Nat :=
  n0 i ell + 729 * adjust (i.1 % 3) (n0 i ell)

def c (i : Fin 243) (ell : Fin 3) : Nat :=
  (2 * a i ell - 1) / 3

@[simp] theorem adjust_zero_spec (n : Nat) :
    (n + 729 * adjust 0 n) % 2 = 1 := by
  simp [adjust]
  omega

@[simp] theorem adjust_one_spec (n : Nat) :
    (n + 729 * adjust 1 n) % 4 = 2 := by
  simp [adjust]
  omega

@[simp] theorem adjust_two_spec (n : Nat) :
    (n + 729 * adjust 2 n) % 4 = 0 := by
  simp [adjust]
  omega

theorem a_bucketCode (i : Fin 243) (ell : Fin 3) :
    bucketCode (a i ell) = i.1 % 3 := by
  have hr := Nat.mod_lt i.1 (by omega : 0 < 3)
  rcases (show i.1 % 3 = 0 ∨ i.1 % 3 = 1 ∨ i.1 % 3 = 2 by omega) with
      h₀ | h₁ | h₂
  · have ha : a i ell % 2 = 1 := by
      simpa [a, h₀] using adjust_zero_spec (n0 i ell)
    simp [bucketCode, ha, h₀]
  · have ha₄ : a i ell % 4 = 2 := by
      simpa [a, h₁] using adjust_one_spec (n0 i ell)
    have ha₂ : a i ell % 2 = 0 := by
      rw [← Nat.mod_mod_of_dvd (a i ell) (by norm_num : 2 ∣ 4), ha₄]
    simp [bucketCode, ha₂, ha₄, h₁]
  · have ha₄ : a i ell % 4 = 0 := by
      simpa [a, h₂] using adjust_two_spec (n0 i ell)
    have ha₂ : a i ell % 2 = 0 := by
      rw [← Nat.mod_mod_of_dvd (a i ell) (by norm_num : 2 ∣ 4), ha₄]
    simp [bucketCode, ha₂, ha₄, h₂]

theorem c_expanded (i : Fin 243) (ell : Fin 3) :
    c i ell =
      2 * (i.1 / 3) + 1 + 162 * ell.1 +
        486 * adjust (i.1 % 3) (n0 i ell) := by
  have hn : 2 ≤ n0 i ell := by
    unfold n0
    omega
  unfold c a n0
  omega

theorem c_mod2 (i : Fin 243) (ell : Fin 3) : c i ell % 2 = 1 := by
  rw [c_expanded]
  omega

/-! ## Typed eligible sources -/

abbrev DirectSource := {i : Fin 243 // (i.1 / 3) % 3 = 2}
abbrev LiftSource := {i : Fin 243 // (i.1 / 3) % 3 = 0}

theorem directSource_mod9 (i : DirectSource) :
    6 ≤ i.1.1 % 9 ∧ i.1.1 % 9 < 9 := by
  have hi := i.1.2
  have h3 := Nat.div_add_mod i.1.1 3
  have h9 := Nat.div_add_mod i.1.1 9
  have hr3 : i.1.1 % 3 < 3 := Nat.mod_lt _ (by omega)
  have hr9 : i.1.1 % 9 < 9 := Nat.mod_lt _ (by omega)
  omega

theorem liftSource_mod9 (i : LiftSource) :
    i.1.1 % 9 < 3 := by
  have hi := i.1.2
  have h3 := Nat.div_add_mod i.1.1 3
  have h9 := Nat.div_add_mod i.1.1 9
  have hr3 : i.1.1 % 3 < 3 := Nat.mod_lt _ (by omega)
  have hr9 : i.1.1 % 9 < 9 := Nat.mod_lt _ (by omega)
  omega

def directSourceRankNat (i : DirectSource) : Nat :=
  3 * (i.1.1 / 9) + (i.1.1 % 9 - 6)

theorem directSourceRankNat_lt_81 (i : DirectSource) :
    directSourceRankNat i < 81 := by
  have hi := i.1.2
  have hm := directSource_mod9 i
  have hsplit := Nat.div_add_mod i.1.1 9
  unfold directSourceRankNat
  omega

def directSourceRank (i : DirectSource) : Fin 81 :=
  ⟨directSourceRankNat i, directSourceRankNat_lt_81 i⟩

def directSourceUnrankNat (k : Fin 81) : Nat :=
  9 * (k.1 / 3) + 6 + k.1 % 3

theorem directSourceUnrankNat_lt_243 (k : Fin 81) :
    directSourceUnrankNat k < 243 := by
  have hk := k.2
  have hr : k.1 % 3 < 3 := Nat.mod_lt _ (by omega)
  unfold directSourceUnrankNat
  omega

theorem directSourceUnrank_eligible (k : Fin 81) :
    (directSourceUnrankNat k / 3) % 3 = 2 := by
  have hr : k.1 % 3 < 3 := Nat.mod_lt _ (by omega)
  unfold directSourceUnrankNat
  omega

def directSourceUnrank (k : Fin 81) : DirectSource :=
  ⟨⟨directSourceUnrankNat k, directSourceUnrankNat_lt_243 k⟩,
    directSourceUnrank_eligible k⟩

@[simp] theorem directSource_rank_unrank (k : Fin 81) :
    directSourceRank (directSourceUnrank k) = k := by
  apply Fin.ext
  have hk := k.2
  have hsplit := Nat.div_add_mod k.1 3
  have hr : k.1 % 3 < 3 := Nat.mod_lt _ (by omega)
  change
    3 * ((9 * (k.1 / 3) + 6 + k.1 % 3) / 9) +
        ((9 * (k.1 / 3) + 6 + k.1 % 3) % 9 - 6) = k.1
  omega

@[simp] theorem directSource_unrank_rank (i : DirectSource) :
    directSourceUnrank (directSourceRank i) = i := by
  apply Subtype.ext
  apply Fin.ext
  have hi := i.1.2
  have hm := directSource_mod9 i
  have hsplit := Nat.div_add_mod i.1.1 9
  change
    9 * ((3 * (i.1.1 / 9) + (i.1.1 % 9 - 6)) / 3) + 6 +
        (3 * (i.1.1 / 9) + (i.1.1 % 9 - 6)) % 3 = i.1.1
  omega

def directSourceEquiv : DirectSource ≃ Fin 81 where
  toFun := directSourceRank
  invFun := directSourceUnrank
  left_inv := directSource_unrank_rank
  right_inv := directSource_rank_unrank

theorem directSourceRank_injective : Function.Injective directSourceRank :=
  directSourceEquiv.injective

def liftSourceRankNat (i : LiftSource) : Nat :=
  3 * (i.1.1 / 9) + i.1.1 % 9

theorem liftSourceRankNat_lt_81 (i : LiftSource) :
    liftSourceRankNat i < 81 := by
  have hi := i.1.2
  have hm := liftSource_mod9 i
  have hsplit := Nat.div_add_mod i.1.1 9
  unfold liftSourceRankNat
  omega

def liftSourceRank (i : LiftSource) : Fin 81 :=
  ⟨liftSourceRankNat i, liftSourceRankNat_lt_81 i⟩

def liftSourceUnrankNat (k : Fin 81) : Nat :=
  9 * (k.1 / 3) + k.1 % 3

theorem liftSourceUnrankNat_lt_243 (k : Fin 81) :
    liftSourceUnrankNat k < 243 := by
  have hk := k.2
  have hr : k.1 % 3 < 3 := Nat.mod_lt _ (by omega)
  unfold liftSourceUnrankNat
  omega

theorem liftSourceUnrank_eligible (k : Fin 81) :
    (liftSourceUnrankNat k / 3) % 3 = 0 := by
  have hr : k.1 % 3 < 3 := Nat.mod_lt _ (by omega)
  unfold liftSourceUnrankNat
  omega

def liftSourceUnrank (k : Fin 81) : LiftSource :=
  ⟨⟨liftSourceUnrankNat k, liftSourceUnrankNat_lt_243 k⟩,
    liftSourceUnrank_eligible k⟩

@[simp] theorem liftSource_rank_unrank (k : Fin 81) :
    liftSourceRank (liftSourceUnrank k) = k := by
  apply Fin.ext
  have hk := k.2
  have hsplit := Nat.div_add_mod k.1 3
  have hr : k.1 % 3 < 3 := Nat.mod_lt _ (by omega)
  change
    3 * ((9 * (k.1 / 3) + k.1 % 3) / 9) +
        (9 * (k.1 / 3) + k.1 % 3) % 9 = k.1
  omega

@[simp] theorem liftSource_unrank_rank (i : LiftSource) :
    liftSourceUnrank (liftSourceRank i) = i := by
  apply Subtype.ext
  apply Fin.ext
  have hi := i.1.2
  have hm := liftSource_mod9 i
  have hsplit := Nat.div_add_mod i.1.1 9
  change
    9 * ((3 * (i.1.1 / 9) + i.1.1 % 9) / 3) +
        (3 * (i.1.1 / 9) + i.1.1 % 9) % 3 = i.1.1
  omega

def liftSourceEquiv : LiftSource ≃ Fin 81 where
  toFun := liftSourceRank
  invFun := liftSourceUnrank
  left_inv := liftSource_unrank_rank
  right_inv := liftSource_rank_unrank

theorem liftSourceRank_injective : Function.Injective liftSourceRank :=
  liftSourceEquiv.injective

/-! ## Formula-generated edges -/

inductive FormulaEdge where
  | retarded (source : Fin 243)
  | advancedDirect (source : DirectSource) (ell : Fin 3)
  | advancedParityLift (source : LiftSource) (ell : Fin 3)
  deriving DecidableEq, Repr, Fintype

def retardedTarget (i : Fin 243) : Fin 243 :=
  ⟨3 * ((4 * (i.1 / 3) + 2) % 81) + 2, by
    have h := Nat.mod_lt (4 * (i.1 / 3) + 2) (by omega : 0 < 81)
    omega⟩

def directOffset (i : DirectSource) : Nat :=
  (2 * (i.1.1 / 3) - 1) / 3

theorem direct_c_mod3 (i : DirectSource) (ell : Fin 3) :
    c i.1 ell % 3 = 2 := by
  have hq := i.2
  rw [c_expanded]
  omega

theorem lift_c_mod3 (i : LiftSource) (ell : Fin 3) :
    c i.1 ell % 3 = 1 := by
  have hq := i.2
  rw [c_expanded]
  omega

theorem lift_twice_c_mod3 (i : LiftSource) (ell : Fin 3) :
    (2 * c i.1 ell) % 3 = 2 := by
  have hc := lift_c_mod3 i ell
  omega

theorem direct_c_bucket (i : DirectSource) (ell : Fin 3) :
    bucketCode (c i.1 ell) = 0 := by
  have hc := c_mod2 i.1 ell
  simp [bucketCode, hc]

theorem lift_twice_c_bucket (i : LiftSource) (ell : Fin 3) :
    bucketCode (2 * c i.1 ell) = 1 := by
  have hc := c_mod2 i.1 ell
  have h₂ : (2 * c i.1 ell) % 2 = 0 := by omega
  have h₄ : (2 * c i.1 ell) % 4 = 2 := by omega
  simp [bucketCode, h₂, h₄]

def directStateCode (i : DirectSource) (ell : Fin 3) : CoreCode :=
  stateCode (c i.1 ell) (direct_c_mod3 i ell)

def liftStateCode (i : LiftSource) (ell : Fin 3) : CoreCode :=
  stateCode (2 * c i.1 ell) (lift_twice_c_mod3 i ell)

/-- The semantic direct target is obtained by reconstructing and decoding `c`. -/
def directTarget (i : DirectSource) (ell : Fin 3) : Fin 243 :=
  decode (directStateCode i ell)

/-- The parity-lift target is obtained by reconstructing and decoding `2*c`. -/
def liftTarget (i : LiftSource) (ell : Fin 3) : Fin 243 :=
  decode (liftStateCode i ell)

def directK (i : DirectSource) (ell : Fin 3) : Nat :=
  directOffset i + 54 * ell.1 +
    162 * adjust (i.1.1 % 3) (n0 i.1 ell)

theorem direct_c_affine (i : DirectSource) (ell : Fin 3) :
    c i.1 ell = 3 * directK i ell + 2 := by
  have hq := i.2
  have hsplit := Nat.div_add_mod (i.1.1 / 3) 3
  have hm := Nat.mod_lt (i.1.1 / 3) (by omega : 0 < 3)
  rw [c_expanded]
  unfold directK directOffset
  omega

def liftK (i : LiftSource) (ell : Fin 3) : Nat :=
  4 * ((i.1.1 / 3) / 3) + 108 * ell.1 +
    324 * adjust (i.1.1 % 3) (n0 i.1 ell)

theorem lift_twice_c_affine (i : LiftSource) (ell : Fin 3) :
    2 * c i.1 ell = 3 * liftK i ell + 2 := by
  have hq := i.2
  have hsplit := Nat.div_add_mod (i.1.1 / 3) 3
  have hm := Nat.mod_lt (i.1.1 / 3) (by omega : 0 < 3)
  rw [c_expanded]
  unfold liftK
  omega

def directTargetClosed (i : DirectSource) (ell : Fin 3) : Fin 243 :=
  ⟨3 * ((directOffset i + 54 * ell.1) % 81), by
    have h := Nat.mod_lt (directOffset i + 54 * ell.1) (by omega : 0 < 81)
    omega⟩

def liftTargetClosed (i : LiftSource) (ell : Fin 3) : Fin 243 :=
  ⟨3 * ((4 * ((i.1.1 / 3) / 3) + 27 * ell.1) % 81) + 1, by
    have h := Nat.mod_lt
      (4 * ((i.1.1 / 3) / 3) + 27 * ell.1) (by omega : 0 < 81)
    omega⟩

theorem directK_mod81 (i : DirectSource) (ell : Fin 3) :
    directK i ell % 81 =
      (directOffset i + 54 * ell.1) % 81 := by
  unfold directK
  omega

theorem liftK_mod81 (i : LiftSource) (ell : Fin 3) :
    liftK i ell % 81 =
      (4 * ((i.1.1 / 3) / 3) + 27 * ell.1) % 81 := by
  unfold liftK
  omega

theorem directTarget_closed_form (i : DirectSource) (ell : Fin 3) :
    directTarget i ell = directTargetClosed i ell := by
  apply Fin.ext
  have hv := decode_stateCode_affine_val
    (c i.1 ell) (directK i ell) 0
    (direct_c_affine i ell) (direct_c_bucket i ell)
    (by omega) (direct_c_mod3 i ell)
  change
    (decode (stateCode (c i.1 ell) (direct_c_mod3 i ell))).1 =
      3 * ((directOffset i + 54 * ell.1) % 81)
  calc
    _ = 3 * (directK i ell % 81) + 0 := hv
    _ = 3 * ((directOffset i + 54 * ell.1) % 81) := by
      rw [directK_mod81]
      omega

theorem liftTarget_closed_form (i : LiftSource) (ell : Fin 3) :
    liftTarget i ell = liftTargetClosed i ell := by
  apply Fin.ext
  have hv := decode_stateCode_affine_val
    (2 * c i.1 ell) (liftK i ell) 1
    (lift_twice_c_affine i ell) (lift_twice_c_bucket i ell)
    (by omega) (lift_twice_c_mod3 i ell)
  change
    (decode (stateCode (2 * c i.1 ell) (lift_twice_c_mod3 i ell))).1 =
      3 * ((4 * ((i.1.1 / 3) / 3) + 27 * ell.1) % 81) + 1
  calc
    _ = 3 * (liftK i ell % 81) + 1 := hv
    _ = 3 * ((4 * ((i.1.1 / 3) / 3) + 27 * ell.1) % 81) + 1 := by
      rw [liftK_mod81]

def formulaSource : FormulaEdge → Fin 243
  | .retarded i => i
  | .advancedDirect i _ => i.1
  | .advancedParityLift i _ => i.1

def formulaTarget : FormulaEdge → Fin 243
  | .retarded i => retardedTarget i
  | .advancedDirect i ell => directTarget i ell
  | .advancedParityLift i ell => liftTarget i ell

def formulaChannelNat : FormulaEdge → Nat
  | .retarded _ => 0
  | .advancedDirect _ _ => 1
  | .advancedParityLift _ _ => 2

def realize (e : FormulaEdge) : CoreEdge where
  source := formulaSource e
  target := formulaTarget e
  channel := formulaChannelNat e

theorem directTarget_ell_injective (i : DirectSource) :
    Function.Injective (directTarget i) := by
  intro ell₁ ell₂ h
  apply Fin.ext
  have hv := congrArg Fin.val h
  rw [directTarget_closed_form i ell₁,
      directTarget_closed_form i ell₂] at hv
  fin_cases ell₁ <;> fin_cases ell₂ <;>
    simp only [directTargetClosed, Fin.isValue] at hv ⊢ <;> omega

theorem liftTarget_ell_injective (i : LiftSource) :
    Function.Injective (liftTarget i) := by
  intro ell₁ ell₂ h
  apply Fin.ext
  have hv := congrArg Fin.val h
  rw [liftTarget_closed_form i ell₁,
      liftTarget_closed_form i ell₂] at hv
  fin_cases ell₁ <;> fin_cases ell₂ <;>
    simp only [liftTargetClosed, Fin.isValue] at hv ⊢ <;> omega

theorem realize_injective : Function.Injective realize := by
  intro e f h
  cases e with
  | retarded i =>
      cases f with
      | retarded j =>
          have hs : i = j := by
            simpa [realize, formulaSource] using congrArg CoreEdge.source h
          cases hs
          rfl
      | advancedDirect j ell =>
          have hc := congrArg CoreEdge.channel h
          norm_num [realize, formulaChannelNat] at hc
      | advancedParityLift j ell =>
          have hc := congrArg CoreEdge.channel h
          norm_num [realize, formulaChannelNat] at hc
  | advancedDirect i ell₁ =>
      cases f with
      | retarded j =>
          have hc := congrArg CoreEdge.channel h
          norm_num [realize, formulaChannelNat] at hc
      | advancedDirect j ell₂ =>
          have hs : i.1 = j.1 := by
            simpa [realize, formulaSource] using congrArg CoreEdge.source h
          have hij : i = j := Subtype.ext hs
          subst j
          have ht : directTarget i ell₁ = directTarget i ell₂ := by
            simpa [realize, formulaTarget] using congrArg CoreEdge.target h
          have hell := directTarget_ell_injective i ht
          subst ell₂
          rfl
      | advancedParityLift j ell₂ =>
          have hc := congrArg CoreEdge.channel h
          norm_num [realize, formulaChannelNat] at hc
  | advancedParityLift i ell₁ =>
      cases f with
      | retarded j =>
          have hc := congrArg CoreEdge.channel h
          norm_num [realize, formulaChannelNat] at hc
      | advancedDirect j ell₂ =>
          have hc := congrArg CoreEdge.channel h
          norm_num [realize, formulaChannelNat] at hc
      | advancedParityLift j ell₂ =>
          have hs : i.1 = j.1 := by
            simpa [realize, formulaSource] using congrArg CoreEdge.source h
          have hij : i = j := Subtype.ext hs
          subst j
          have ht : liftTarget i ell₁ = liftTarget i ell₂ := by
            simpa [realize, formulaTarget] using congrArg CoreEdge.target h
          have hell := liftTarget_ell_injective i ht
          subst ell₂
          rfl

/-! ## Constructive full rank/unrank -/

def formulaRank (e : FormulaEdge) : Fin 729 :=
  match e with
  | .retarded i => ⟨i.1, by omega⟩
  | .advancedDirect i ell =>
      ⟨243 + 3 * (directSourceRank i).1 + ell.1, by
        have hi := (directSourceRank i).2
        have he := ell.2
        omega⟩
  | .advancedParityLift i ell =>
      ⟨486 + 3 * (liftSourceRank i).1 + ell.1, by
        have hi := (liftSourceRank i).2
        have he := ell.2
        omega⟩

def formulaUnrank (j : Fin 729) : FormulaEdge :=
  if hret : j.1 < 243 then
    .retarded ⟨j.1, hret⟩
  else if hdir : j.1 < 486 then
    let z := j.1 - 243
    .advancedDirect
      (directSourceUnrank ⟨z / 3, by omega⟩)
      ⟨z % 3, Nat.mod_lt _ (by omega)⟩
  else
    let z := j.1 - 486
    .advancedParityLift
      (liftSourceUnrank ⟨z / 3, by omega⟩)
      ⟨z % 3, Nat.mod_lt _ (by omega)⟩

theorem formulaRank_unrank (j : Fin 729) :
    formulaRank (formulaUnrank j) = j := by
  apply Fin.ext
  by_cases hret : j.1 < 243
  · simp [formulaUnrank, hret, formulaRank]
  · by_cases hdir : j.1 < 486
    · have hz : j.1 - 243 < 243 := by omega
      have hsplit := Nat.div_add_mod (j.1 - 243) 3
      simp [formulaUnrank, hret, hdir, formulaRank]
      omega
    · have hz : j.1 - 486 < 243 := by omega
      have hsplit := Nat.div_add_mod (j.1 - 486) 3
      simp [formulaUnrank, hret, hdir, formulaRank]
      omega

theorem formulaRank_injective_raw : Function.Injective formulaRank := by
  intro e f h
  have hv := congrArg Fin.val h
  cases e with
  | retarded i =>
      cases f with
      | retarded j =>
          have hij : i = j := by
            apply Fin.ext
            simpa only [formulaRank] using hv
          cases hij
          rfl
      | advancedDirect j ell =>
          have hj := (directSourceRank j).2
          have he := ell.2
          simp only [formulaRank] at hv
          omega
      | advancedParityLift j ell =>
          have hj := (liftSourceRank j).2
          have he := ell.2
          simp only [formulaRank] at hv
          omega
  | advancedDirect i ell1 =>
      cases f with
      | retarded j =>
          have hi := (directSourceRank i).2
          have he := ell1.2
          simp only [formulaRank] at hv
          omega
      | advancedDirect j ell2 =>
          have he1 := ell1.2
          have he2 := ell2.2
          simp only [formulaRank] at hv
          have hrank : directSourceRank i = directSourceRank j := by
            apply Fin.ext
            omega
          have hsource : i = j := directSourceRank_injective hrank
          have hell : ell1 = ell2 := by
            apply Fin.ext
            omega
          cases hsource
          cases hell
          rfl
      | advancedParityLift j ell2 =>
          have hi := (directSourceRank i).2
          have hj := (liftSourceRank j).2
          have he1 := ell1.2
          have he2 := ell2.2
          simp only [formulaRank] at hv
          omega
  | advancedParityLift i ell1 =>
      cases f with
      | retarded j =>
          have hi := (liftSourceRank i).2
          have he := ell1.2
          simp only [formulaRank] at hv
          omega
      | advancedDirect j ell2 =>
          have hi := (liftSourceRank i).2
          have hj := (directSourceRank j).2
          have he1 := ell1.2
          have he2 := ell2.2
          simp only [formulaRank] at hv
          omega
      | advancedParityLift j ell2 =>
          have he1 := ell1.2
          have he2 := ell2.2
          simp only [formulaRank] at hv
          have hrank : liftSourceRank i = liftSourceRank j := by
            apply Fin.ext
            omega
          have hsource : i = j := liftSourceRank_injective hrank
          have hell : ell1 = ell2 := by
            apply Fin.ext
            omega
          cases hsource
          cases hell
          rfl

theorem formulaUnrank_rank (e : FormulaEdge) :
    formulaUnrank (formulaRank e) = e := by
  apply formulaRank_injective_raw
  exact formulaRank_unrank (formulaRank e)

def formulaEdgeEquivFin729 : FormulaEdge ≃ Fin 729 where
  toFun := formulaRank
  invFun := formulaUnrank
  left_inv := formulaUnrank_rank
  right_inv := formulaRank_unrank

theorem formulaRank_injective : Function.Injective formulaRank :=
  formulaRank_injective_raw

theorem formulaEdge_card : Fintype.card FormulaEdge = 729 := by
  calc
    Fintype.card FormulaEdge = Fintype.card (Fin 729) :=
      Fintype.card_congr formulaEdgeEquivFin729
    _ = 729 := by simp

def formulaCoreList : List CoreEdge :=
  List.ofFn (fun j : Fin 729 => realize (formulaUnrank j))

theorem formulaCoreList_length : formulaCoreList.length = 729 := by
  unfold formulaCoreList
  exact List.length_ofFn

theorem formulaCoreList_nodup : formulaCoreList.Nodup := by
  apply List.nodup_ofFn.mpr
  exact realize_injective.comp formulaEdgeEquivFin729.symm.injective

theorem formula_channel_cardinality : 243 + 81 * 3 + 81 * 3 = 729 := by
  norm_num

/-! ## The 27-source pilot -/

inductive PilotFormulaEdge where
  | retarded (source : Fin 27)
  | advancedDirect (sourceRank : Fin 9) (ell : Fin 3)
  | advancedParityLift (sourceRank : Fin 9) (ell : Fin 3)
  deriving DecidableEq, Repr, Fintype

def fin27To243 (i : Fin 27) : Fin 243 := ⟨i.1, by omega⟩
def fin9To81 (i : Fin 9) : Fin 81 := ⟨i.1, by omega⟩

def pilotEmbed : PilotFormulaEdge → FormulaEdge
  | .retarded i => .retarded (fin27To243 i)
  | .advancedDirect k ell =>
      .advancedDirect (directSourceUnrank (fin9To81 k)) ell
  | .advancedParityLift k ell =>
      .advancedParityLift (liftSourceUnrank (fin9To81 k)) ell

def pilotRank (e : PilotFormulaEdge) : Fin 81 :=
  match e with
  | .retarded i => ⟨i.1, by omega⟩
  | .advancedDirect k ell => ⟨27 + 3 * k.1 + ell.1, by omega⟩
  | .advancedParityLift k ell => ⟨54 + 3 * k.1 + ell.1, by omega⟩

def pilotUnrank (j : Fin 81) : PilotFormulaEdge :=
  if hret : j.1 < 27 then
    .retarded ⟨j.1, hret⟩
  else if hdir : j.1 < 54 then
    let z := j.1 - 27
    .advancedDirect
      ⟨z / 3, by omega⟩
      ⟨z % 3, Nat.mod_lt _ (by omega)⟩
  else
    let z := j.1 - 54
    .advancedParityLift
      ⟨z / 3, by omega⟩
      ⟨z % 3, Nat.mod_lt _ (by omega)⟩

theorem pilotRank_unrank (j : Fin 81) :
    pilotRank (pilotUnrank j) = j := by
  apply Fin.ext
  by_cases hret : j.1 < 27
  · simp [pilotUnrank, hret, pilotRank]
  · by_cases hdir : j.1 < 54
    · have hsplit := Nat.div_add_mod (j.1 - 27) 3
      simp [pilotUnrank, hret, hdir, pilotRank]
      omega
    · have hsplit := Nat.div_add_mod (j.1 - 54) 3
      simp [pilotUnrank, hret, hdir, pilotRank]
      omega

theorem pilotRank_injective_raw : Function.Injective pilotRank := by
  intro e f h
  have hv := congrArg Fin.val h
  cases e with
  | retarded i =>
      cases f with
      | retarded j =>
          have hij : i = j := by
            apply Fin.ext
            simpa only [pilotRank] using hv
          cases hij
          rfl
      | advancedDirect k ell =>
          have hk := k.2
          have he := ell.2
          simp only [pilotRank] at hv
          omega
      | advancedParityLift k ell =>
          have hk := k.2
          have he := ell.2
          simp only [pilotRank] at hv
          omega
  | advancedDirect k1 ell1 =>
      cases f with
      | retarded j =>
          have hk := k1.2
          have he := ell1.2
          simp only [pilotRank] at hv
          omega
      | advancedDirect k2 ell2 =>
          have he1 := ell1.2
          have he2 := ell2.2
          simp only [pilotRank] at hv
          have hk : k1 = k2 := by
            apply Fin.ext
            omega
          have he : ell1 = ell2 := by
            apply Fin.ext
            omega
          cases hk
          cases he
          rfl
      | advancedParityLift k2 ell2 =>
          have hk1 := k1.2
          have hk2 := k2.2
          have he1 := ell1.2
          have he2 := ell2.2
          simp only [pilotRank] at hv
          omega
  | advancedParityLift k1 ell1 =>
      cases f with
      | retarded j =>
          have hk := k1.2
          have he := ell1.2
          simp only [pilotRank] at hv
          omega
      | advancedDirect k2 ell2 =>
          have hk1 := k1.2
          have hk2 := k2.2
          have he1 := ell1.2
          have he2 := ell2.2
          simp only [pilotRank] at hv
          omega
      | advancedParityLift k2 ell2 =>
          have he1 := ell1.2
          have he2 := ell2.2
          simp only [pilotRank] at hv
          have hk : k1 = k2 := by
            apply Fin.ext
            omega
          have he : ell1 = ell2 := by
            apply Fin.ext
            omega
          cases hk
          cases he
          rfl

theorem pilotUnrank_rank (e : PilotFormulaEdge) :
    pilotUnrank (pilotRank e) = e := by
  apply pilotRank_injective_raw
  exact pilotRank_unrank (pilotRank e)

def pilotEdgeEquivFin81 : PilotFormulaEdge ≃ Fin 81 where
  toFun := pilotRank
  invFun := pilotUnrank
  left_inv := pilotUnrank_rank
  right_inv := pilotRank_unrank

theorem pilotRank_injective : Function.Injective pilotRank :=
  pilotRank_injective_raw

theorem pilotFormulaEdge_card : Fintype.card PilotFormulaEdge = 81 := by
  calc
    Fintype.card PilotFormulaEdge = Fintype.card (Fin 81) :=
      Fintype.card_congr pilotEdgeEquivFin81
    _ = 81 := by simp

theorem pilot_channel_cardinality : 27 + 9 * 3 + 9 * 3 = 81 := by
  norm_num

theorem pilotEmbed_injective : Function.Injective pilotEmbed := by
  intro e f h
  apply pilotRank_injective
  have hr := congrArg formulaRank h
  cases e <;> cases f <;>
    simp [pilotEmbed, formulaRank, pilotRank, fin27To243, fin9To81] at hr ⊢ <;>
    omega

def pilotRealize (e : PilotFormulaEdge) : CoreEdge :=
  realize (pilotEmbed e)

theorem pilotRealize_injective : Function.Injective pilotRealize :=
  realize_injective.comp pilotEmbed_injective

def pilotFormulaList : List CoreEdge :=
  List.ofFn (fun j : Fin 81 => pilotRealize (pilotUnrank j))

theorem pilotFormulaList_length : pilotFormulaList.length = 81 := by
  unfold pilotFormulaList
  exact List.length_ofFn

theorem pilotFormulaList_nodup : pilotFormulaList.Nodup := by
  apply List.nodup_ofFn.mpr
  exact pilotRealize_injective.comp pilotEdgeEquivFin81.symm.injective

/-! ## Arithmetic positions in the historical order -/

def rowStart (i : Fin 243) : Nat :=
  let q := i.1 / 3
  let b := i.1 % 3
  let k := q / 3
  if q % 3 = 0 then
    27 * k + 4 * b
  else if q % 3 = 1 then
    27 * k + 12 + b
  else
    27 * k + 15 + 4 * b

def frozenPosNat : FormulaEdge → Nat
  | .retarded i => rowStart i
  | .advancedDirect i ell => rowStart i.1 + 1 + ell.1
  | .advancedParityLift i ell => rowStart i.1 + 1 + ell.1

theorem frozenPosNat_lt_729 (e : FormulaEdge) : frozenPosNat e < 729 := by
  cases e with
  | retarded i =>
      have hi := i.2
      have hb : i.1 % 3 < 3 := Nat.mod_lt _ (by omega)
      have hq : (i.1 / 3) % 3 < 3 := Nat.mod_lt _ (by omega)
      simp only [frozenPosNat, rowStart]
      split_ifs <;> omega
  | advancedDirect i ell =>
      have hi := i.1.2
      have he := ell.2
      have hb : i.1.1 % 3 < 3 := Nat.mod_lt _ (by omega)
      have hq : (i.1.1 / 3) % 3 < 3 := Nat.mod_lt _ (by omega)
      simp only [frozenPosNat, rowStart]
      split_ifs <;> omega
  | advancedParityLift i ell =>
      have hi := i.1.2
      have he := ell.2
      have hb : i.1.1 % 3 < 3 := Nat.mod_lt _ (by omega)
      have hq : (i.1.1 / 3) % 3 < 3 := Nat.mod_lt _ (by omega)
      simp only [frozenPosNat, rowStart]
      split_ifs <;> omega

def frozenPos (e : FormulaEdge) : Fin 729 :=
  ⟨frozenPosNat e, frozenPosNat_lt_729 e⟩

theorem pilotFrozenPos_lt_81 (e : PilotFormulaEdge) :
    (frozenPos (pilotEmbed e)).1 < 81 := by
  cases e with
  | retarded i =>
      have hi := i.2
      have hb : i.1 % 3 < 3 := Nat.mod_lt _ (by omega)
      have hq : (i.1 / 3) % 3 < 3 := Nat.mod_lt _ (by omega)
      have h₃ := Nat.div_add_mod i.1 3
      have h₉ := Nat.div_add_mod (i.1 / 3) 3
      simp only [frozenPos, frozenPosNat, pilotEmbed, fin27To243, rowStart]
      split_ifs <;> omega
  | advancedDirect k ell =>
      have hk := k.2
      have he := ell.2
      have hr : k.1 % 3 < 3 := Nat.mod_lt _ (by omega)
      have h₃ := Nat.div_add_mod k.1 3
      simp only [frozenPos, frozenPosNat, pilotEmbed, fin9To81,
        directSourceUnrank, directSourceUnrankNat, rowStart]
      split_ifs <;> omega
  | advancedParityLift k ell =>
      have hk := k.2
      have he := ell.2
      have hr : k.1 % 3 < 3 := Nat.mod_lt _ (by omega)
      have h₃ := Nat.div_add_mod k.1 3
      simp only [frozenPos, frozenPosNat, pilotEmbed, fin9To81,
        liftSourceUnrank, liftSourceUnrankNat, rowStart]
      split_ifs <;> omega

def pilotFrozenPos : PilotFormulaEdge → Fin 81
  | .retarded i =>
      let q := i.1 / 3
      let b := i.1 % 3
      let k := q / 3
      if q % 3 = 0 then
        ⟨27 * k + 4 * b, by
          have hi := i.2
          have hb : b < 3 := Nat.mod_lt _ (by omega)
          omega⟩
      else if q % 3 = 1 then
        ⟨27 * k + 12 + b, by
          have hi := i.2
          have hb : b < 3 := Nat.mod_lt _ (by omega)
          omega⟩
      else
        ⟨27 * k + 15 + 4 * b, by
          have hi := i.2
          have hb : b < 3 := Nat.mod_lt _ (by omega)
          omega⟩
  | .advancedDirect k ell =>
      ⟨27 * (k.1 / 3) + 15 + 4 * (k.1 % 3) + 1 + ell.1, by
        have hk := k.2
        have he := ell.2
        have hb : k.1 % 3 < 3 := Nat.mod_lt _ (by omega)
        omega⟩
  | .advancedParityLift k ell =>
      ⟨27 * (k.1 / 3) + 4 * (k.1 % 3) + 1 + ell.1, by
        have hk := k.2
        have he := ell.2
        have hb : k.1 % 3 < 3 := Nat.mod_lt _ (by omega)
        omega⟩

theorem pilotFrozenPos_agrees (e : PilotFormulaEdge) :
    (pilotFrozenPos e).1 = (frozenPos (pilotEmbed e)).1 := by
  cases e with
  | retarded i =>
      have hi := i.2
      have hb : i.1 % 3 < 3 := Nat.mod_lt _ (by omega)
      have hq : (i.1 / 3) % 3 < 3 := Nat.mod_lt _ (by omega)
      have h₃ := Nat.div_add_mod i.1 3
      have h₉ := Nat.div_add_mod (i.1 / 3) 3
      simp only [pilotFrozenPos, frozenPos, frozenPosNat, pilotEmbed,
        fin27To243, rowStart]
      split_ifs <;> omega
  | advancedDirect k ell =>
      have hk := k.2
      have he := ell.2
      have hb : k.1 % 3 < 3 := Nat.mod_lt _ (by omega)
      have h₃ := Nat.div_add_mod k.1 3
      simp only [pilotFrozenPos, frozenPos, frozenPosNat, pilotEmbed,
        fin9To81, directSourceUnrank, directSourceUnrankNat, rowStart]
      split_ifs <;> omega
  | advancedParityLift k ell =>
      have hk := k.2
      have he := ell.2
      have hb : k.1 % 3 < 3 := Nat.mod_lt _ (by omega)
      have h₃ := Nat.div_add_mod k.1 3
      simp only [pilotFrozenPos, frozenPos, frozenPosNat, pilotEmbed,
        fin9To81, liftSourceUnrank, liftSourceUnrankNat, rowStart]
      split_ifs <;> omega

def pilotFrozen : List CoreEdge := coreEdges.take 81

/-! ## Formula decoder for the frozen positional order -/

/-- Convert historical position order to the canonical formula rank. -/
def pilotPositionToRank (j : Fin 81) : Fin 81 :=
  let k := j.1 / 27
  let u := j.1 % 27
  have hk : k < 3 := by
    dsimp [k]
    omega
  have hu : u < 27 := by
    dsimp [u]
    exact Nat.mod_lt _ (by omega)
  if hLift : u < 12 then
    let b := u / 4
    let slot := u % 4
    have hb : b < 3 := by
      dsimp [b]
      omega
    have hs : slot < 4 := by
      dsimp [slot]
      exact Nat.mod_lt _ (by omega)
    if hRet : slot = 0 then
      ⟨9 * k + b, by omega⟩
    else
      ⟨54 + 9 * k + 3 * b + (slot - 1), by omega⟩
  else if hSterile : u < 15 then
    ⟨9 * k + 3 + (u - 12), by omega⟩
  else
    let v := u - 15
    let b := v / 4
    let slot := v % 4
    have hv : v < 12 := by
      dsimp [v]
      omega
    have hb : b < 3 := by
      dsimp [b]
      omega
    have hs : slot < 4 := by
      dsimp [slot]
      exact Nat.mod_lt _ (by omega)
    if hRet : slot = 0 then
      ⟨9 * k + 6 + b, by omega⟩
    else
      ⟨27 + 9 * k + 3 * b + (slot - 1), by omega⟩

def pilotPositionUnrank (j : Fin 81) : PilotFormulaEdge :=
  pilotUnrank (pilotPositionToRank j)

theorem pilotPositionToRank_frozenPos (e : PilotFormulaEdge) :
    pilotPositionToRank (pilotFrozenPos e) = pilotRank e := by
  cases e with
  | retarded i =>
      fin_cases i <;> rfl
  | advancedDirect k ell =>
      fin_cases k <;> fin_cases ell <;> rfl
  | advancedParityLift k ell =>
      fin_cases k <;> fin_cases ell <;> rfl

theorem pilotPositionUnrank_frozenPos (e : PilotFormulaEdge) :
    pilotPositionUnrank (pilotFrozenPos e) = e := by
  unfold pilotPositionUnrank
  rw [pilotPositionToRank_frozenPos, pilotUnrank_rank]

theorem pilotFrozenPos_injective : Function.Injective pilotFrozenPos := by
  intro e f h
  rw [← pilotPositionUnrank_frozenPos e,
      ← pilotPositionUnrank_frozenPos f, h]

/-- Formula-generated edge at a historical prefix position. -/
def pilotPositionRealize (j : Fin 81) : CoreEdge :=
  pilotRealize (pilotPositionUnrank j)

/-
This is the sole reduction allowed to unfold the historical edge object.
The right side is generated arithmetically.
-/
theorem pilotFrozen_position_normalization :
    pilotFrozen = List.ofFn pilotPositionRealize := by
  rfl

theorem pilotFrozen_length : pilotFrozen.length = 81 := by
  rw [pilotFrozen_position_normalization]
  simp

theorem pilot_position_at_formula (e : PilotFormulaEdge) :
    pilotPositionRealize (pilotFrozenPos e) = pilotRealize e := by
  simp [pilotPositionRealize, pilotPositionUnrank_frozenPos]

theorem pilot_frozen_at_formula (e : PilotFormulaEdge) :
    ∃ j : Fin 81,
      j = pilotFrozenPos e ∧ pilotPositionRealize j = pilotRealize e := by
  exact ⟨pilotFrozenPos e, rfl, pilot_position_at_formula e⟩

theorem pilotRealize_mem_frozen (e : PilotFormulaEdge) :
    pilotRealize e ∈ pilotFrozen := by
  rw [pilotFrozen_position_normalization, List.mem_ofFn']
  exact ⟨pilotFrozenPos e, pilot_position_at_formula e⟩

theorem pilotFormulaList_subset_frozen : pilotFormulaList ⊆ pilotFrozen := by
  intro edge hedge
  rw [pilotFormulaList, List.mem_ofFn'] at hedge
  obtain ⟨j, rfl⟩ := hedge
  exact pilotRealize_mem_frozen (pilotUnrank j)

/-! ## Generic saturation -/

/-- Inclusion, distinctness and matching cardinality force a permutation. -/
theorem saturation_perm_of_subset_nodup_card
    {alpha : Type*} [DecidableEq alpha]
    {generated frozen : List alpha}
    (hGenerated : generated.Nodup)
    (hSubset : generated ⊆ frozen)
    (hCard : frozen.length ≤ generated.length) :
    generated.Perm frozen :=
  (List.subperm_of_subset hGenerated hSubset).perm_of_length_le hCard

theorem pilotFrozen_perm_formula : pilotFrozen.Perm pilotFormulaList := by
  have hCard : pilotFrozen.length ≤ pilotFormulaList.length := by
    rw [pilotFrozen_length, pilotFormulaList_length]
  have hp := saturation_perm_of_subset_nodup_card
    pilotFormulaList_nodup pilotFormulaList_subset_frozen hCard
  exact hp.symm

theorem pilotFrozen_nodup : pilotFrozen.Nodup :=
  pilotFrozen_perm_formula.nodup_iff.mpr pilotFormulaList_nodup

theorem pilotFrozen_toFinset_eq_formula :
    pilotFrozen.toFinset = pilotFormulaList.toFinset :=
  List.toFinset_eq_of_perm _ _ pilotFrozen_perm_formula

theorem pilotEmbed_source_lt_27 (e : PilotFormulaEdge) :
    (formulaSource (pilotEmbed e)).1 < 27 := by
  cases e with
  | retarded i =>
      exact i.2
  | advancedDirect k ell =>
      have hk := k.2
      have hr : k.1 % 3 < 3 := Nat.mod_lt _ (by omega)
      have hsplit := Nat.div_add_mod k.1 3
      simp only [pilotEmbed, formulaSource, fin9To81, directSourceUnrank,
        directSourceUnrankNat]
      omega
  | advancedParityLift k ell =>
      have hk := k.2
      have hr : k.1 % 3 < 3 := Nat.mod_lt _ (by omega)
      have hsplit := Nat.div_add_mod k.1 3
      simp only [pilotEmbed, formulaSource, fin9To81, liftSourceUnrank,
        liftSourceUnrankNat]
      omega

theorem pilot_frozen_scope (edge : CoreEdge) (h : edge ∈ pilotFrozen) :
    edge.source.1 < 27 := by
  have hm : edge ∈ pilotFormulaList :=
    pilotFrozen_perm_formula.mem_iff.mp h
  rw [pilotFormulaList, List.mem_ofFn'] at hm
  obtain ⟨j, rfl⟩ := hm
  simpa [pilotRealize, realize] using
    pilotEmbed_source_lt_27 (pilotUnrank j)

/-! ## Matrix equality from permutation and commutativity -/

def edgeMatches (s t : Fin 243) (e : CoreEdge) : Bool :=
  decide (e.source = s ∧ e.target = t)

noncomputable def matrixOf (edges : List CoreEdge) (s t : Fin 243) : ℝ :=
  (edges.filter (edgeMatches s t)).foldr
    (fun e acc => channelWeight e.channel + acc) 0

theorem matrixOf_eq_of_perm {left right : List CoreEdge}
    (h : left.Perm right) (s t : Fin 243) :
    matrixOf left s t = matrixOf right s t := by
  unfold matrixOf
  exact (h.filter (edgeMatches s t)).foldr_eq'
    (fun _ _ _ _ _ => by ac_rfl) 0

noncomputable def pilotFrozenMatrix (s t : Fin 243) : ℝ :=
  matrixOf pilotFrozen s t

noncomputable def pilotFormulaMatrix (s t : Fin 243) : ℝ :=
  matrixOf pilotFormulaList s t

theorem pilot_matrix_eq_formulaMatrix (s t : Fin 243) :
    pilotFrozenMatrix s t = pilotFormulaMatrix s t :=
  matrixOf_eq_of_perm pilotFrozen_perm_formula s t

/-!
Scope: this module proves only the finite pilot identity and its arithmetic
generation route.  It asserts no rho certificate, density theorem,
almost-everywhere statement, or global Collatz conclusion.
-/

end F3CoreArithmeticCodecPilotRepair
end KL2003
end CollatzClassical
