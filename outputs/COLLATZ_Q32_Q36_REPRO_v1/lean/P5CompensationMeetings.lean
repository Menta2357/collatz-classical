import P5R3S5

namespace CollatzCharacterBridge.P5CompensationMeetings

open A2Header (Physical)
open StagedCylinder (Segment)

set_option maxRecDepth 12000
set_option maxHeartbeats 1000000

/-- An affine progression in the common guard parameter. -/
structure Affine where
  offset : Nat
  slope : Nat

def Affine.at (f : Affine) (k : Nat) : Nat := f.offset + f.slope * k

def Affine.admissible (f : Affine) : Prop :=
  0 < f.offset ∧ f.offset % 2 = 1 ∧ f.slope % 2 = 0

instance (f : Affine) : Decidable f.admissible := by
  unfold Affine.admissible
  infer_instance

theorem affine_admissible {f : Affine} (hf : f.admissible) (k : Nat) :
    0 < f.at k ∧ f.at k % 2 = 1 := by
  rcases hf with ⟨hp, ho, hs⟩
  constructor
  · simp only [Affine.at]
    omega
  · simp only [Affine.at, Nat.add_mod, Nat.mul_mod, ho, hs, Nat.zero_mul,
      Nat.add_zero, Nat.mod_mod]

def EdgeCoefficients (x y : Affine) (a : Nat) : Prop :=
  x.admissible ∧ y.admissible ∧ 0 < a ∧
    3*x.offset+1 = 2^a*y.offset ∧ 3*x.slope = 2^a*y.slope

instance (x y : Affine) (a : Nat) : Decidable (EdgeCoefficients x y a) := by
  unfold EdgeCoefficients
  infer_instance

theorem affine_edge {x y : Affine} {a : Nat} (h : EdgeCoefficients x y a) (k : Nat) :
    Segment (x.at k) (y.at k) 1 a 1 := by
  rcases h with ⟨hx, hy, ha, h0, h1⟩
  have hfactor : 3*x.at k+1=2^a*y.at k := by
    calc
      _ = (3*x.offset+1)+(3*x.slope)*k := by
        simp only [Affine.at, Nat.mul_add, Nat.mul_assoc]
        ac_rfl
      _ = 2^a*y.offset+(2^a*y.slope)*k := by rw [h0, h1]
      _ = _ := by simp only [Affine.at, Nat.mul_add, Nat.mul_assoc]
  have hxk := affine_admissible hx k
  have hyk := affine_admissible hy k
  exact ⟨Physical.edge hxk.1 hxk.2 hyk.1 hyk.2 ha hfactor, hfactor.symm⟩

abbrev Word := List (Nat × Affine)

def endpoint (start : Affine) : Word → Affine
  | [] => start
  | (_, next) :: tail => endpoint next tail

def divisions : Word → Nat
  | [] => 0
  | (a, _) :: tail => a + divisions tail

def cost : Word → Nat
  | [] => 0
  | (a, _) :: tail => 3^tail.length + 2^a*cost tail

def checkWord (start : Affine) : Word → Bool
  | [] => decide start.admissible
  | (a, next) :: tail => decide (EdgeCoefficients start next a) && checkWord next tail

theorem word_segment (k : Nat) (start : Affine) (word : Word)
    (h : checkWord start word = true) :
    Segment (start.at k) ((endpoint start word).at k)
      word.length (divisions word) (cost word) := by
  induction word generalizing start with
  | nil =>
    exact ⟨Physical.refl _, by simp [endpoint, divisions, cost]⟩
  | cons move tail ih =>
    rcases move with ⟨a, next⟩
    change (decide (EdgeCoefficients start next a) && checkWord next tail) = true at h
    have bits := Bool.and_eq_true_iff.mp h
    have headCert := affine_edge (of_decide_eq_true bits.1) k
    have tailCert := ih next bits.2
    simpa only [endpoint, List.length_cons, divisions, cost, Nat.mul_one,
      Nat.add_comm 1 tail.length] using StagedCylinder.compose headCert tailCert

structure RowData where
  originalStart : Affine
  sourceStart : Affine
  originalWord : Word
  sourceWord : Word
  finalGap : Nat

inductive Row where
  | c1 | c2 | c3 | c4 | c5t2784 | c5t5765 | c5t554
  | d1h482 | d1h249 | d1h461 | d1h3845 | alpha4s7
  deriving DecidableEq

def data : Row → RowData
  | .c1 =>
    ⟨⟨87115, 559872⟩, ⟨174221, 1119744⟩,
      [(1, ⟨130673, 839808⟩), (2, ⟨98005, 629856⟩)],
      [(3, ⟨65333, 419904⟩), (5, ⟨6125, 39366⟩)], 4⟩
  | .c2 =>
    ⟨⟨3296629, 3359232⟩, ⟨6593251, 6718464⟩,
      [(5, ⟨309059, 314928⟩), (1, ⟨463589, 472392⟩)],
      [(1, ⟨9889877, 10077696⟩), (8, ⟨115897, 118098⟩)], 2⟩
  | .c3 =>
    ⟨⟨982373, 1679616⟩, ⟨3929485, 6718464⟩,
      [(4, ⟨184195, 314928⟩), (1, ⟨276293, 472392⟩)],
      [(3, ⟨1473557, 2519424⟩), (6, ⟨69073, 118098⟩)], 2⟩
  | .c4 =>
    ⟨⟨1754179, 3359232⟩, ⟨14033425, 26873856⟩,
      [(1, ⟨2631269, 5038848⟩), (4, ⟨493363, 944784⟩), (1, ⟨740045, 1417176⟩)],
      [(2, ⟨10525069, 20155392⟩), (3, ⟨3946901, 7558272⟩), (6, ⟨185011, 354294⟩)], 2⟩
  | .c5t2784 =>
    ⟨⟨36539405, 53747712⟩, ⟨657709283, 967458816⟩,
      [(3, ⟨13702277, 20155392⟩), (4, ⟨2569177, 3779136⟩), (2, ⟨1926883, 2834352⟩), (1, ⟨2890325, 4251528⟩)],
      [(1, ⟨986563925, 1451188224⟩), (12, ⟨722581, 1062882⟩)], 2⟩
  | .c5t5765 =>
    ⟨⟨75656087, 107495424⟩, ⟨1361809559, 1934917632⟩,
      [(1, ⟨113484131, 161243136⟩), (1, ⟨170226197, 241864704⟩), (6, ⟨7979353, 11337408⟩), (2, ⟨5984515, 8503056⟩), (1, ⟨8976773, 12754584⟩)],
      [(1, ⟨2042714339, 2902376448⟩), (1, ⟨3064071509, 4353564672⟩), (12, ⟨2244193, 3188646⟩)], 2⟩
  | .c5t554 =>
    ⟨⟨7277345, 53747712⟩, ⟨130992203, 967458816⟩,
      [(2, ⟨5458009, 40310784⟩), (2, ⟨4093507, 30233088⟩), (1, ⟨6140261, 45349632⟩), (4, ⟨1151299, 8503056⟩), (1, ⟨1726949, 12754584⟩)],
      [(1, ⟨196488305, 1451188224⟩), (2, ⟨147366229, 1088391168⟩), (10, ⟨431737, 3188646⟩)], 2⟩
  | .d1h482 =>
    ⟨⟨1024618555, 2176782336⟩, ⟨36886267973, 78364164096⟩,
      [(1, ⟨1536927833, 3265173504⟩), (2, ⟨1152695875, 2448880128⟩), (1, ⟨1729043813, 3673320192⟩), (4, ⟨324195715, 688747536⟩), (1, ⟨486293573, 1033121304⟩)],
      [(4, ⟨6916175245, 14693280768⟩), (3, ⟨2593565717, 5509980288⟩), (6, ⟨121573393, 258280326⟩)], 2⟩
  | .d1h249 =>
    ⟨⟨529315543, 544195584⟩, ⟨19055359541, 19591041024⟩,
      [(1, ⟨793973315, 816293376⟩), (1, ⟨1190959973, 1224440064⟩), (4, ⟨223304995, 229582512⟩), (1, ⟨334957493, 344373768⟩)],
      [(5, ⟨1786439957, 1836660096⟩), (6, ⟨83739373, 86093442⟩)], 2⟩
  | .d1h461 =>
    ⟨⟨979977511, 1088391168⟩, ⟨35279190389, 39182082048⟩,
      [(1, ⟨1469966267, 1632586752⟩), (1, ⟨2204949401, 2448880128⟩), (2, ⟨1653712051, 1836660096⟩), (1, ⟨2480568077, 2754990144⟩), (3, ⟨930213029, 1033121304⟩)],
      [(5, ⟨3307424099, 3673320192⟩), (1, ⟨4961136149, 5509980288⟩), (6, ⟨232553257, 258280326⟩)], 2⟩
  | .d1h3845 =>
    ⟨⟨8173562887, 8707129344⟩, ⟨294248263925, 313456656384⟩,
      [(1, ⟨12260344331, 13060694016⟩), (1, ⟨18390516497, 19591041024⟩),
        (2, ⟨13792887373, 14693280768⟩), (3, ⟨5172332765, 5509980288⟩),
        (3, ⟨1939624787, 2066242608⟩), (1, ⟨2909437181, 3099363912⟩)],
      [(5, ⟨27585774743, 29386561536⟩), (1, ⟨41378662115, 44079842304⟩),
        (1, ⟨62067993173, 66119763456⟩), (8, ⟨727359295, 774840978⟩)], 2⟩
  | .alpha4s7 =>
    ⟨⟨2149, 4096⟩, ⟨4835, 9216⟩,
      [(4, ⟨403, 768⟩), (1, ⟨605, 1152⟩), (3, ⟨227, 432⟩), (1, ⟨341, 648⟩)],
      [(1, ⟨7253, 13824⟩), (8, ⟨85, 162⟩)], 2⟩

/-- The residue parameter and the inherited endpoint relation for each row. -/
def Coordinates (row : Row) (k x y : Nat) : Prop :=
  match row with
  | .c1 => x = 4009 + 4374 * (19 + 128 * k) ∧ y + 9 = 2 * x
  | .c2 => 4 * x = 3 * (4009 + 4374 * (1004 + 1024 * k)) + 1 ∧ y + 7 = 2 * x
  | .c3 => 8 * x = 3 * (4009 + 4374 * (598 + 1024 * k)) + 1 ∧ y + 7 = 4 * x
  | .c4 => 16 * x = 3 * (4009 + 4374 * (2138 + 4096 * k)) + 1 ∧ y + 7 = 8 * x
  | .c5t2784 => x = 7757 + 13122 * (2784 + 4096 * k) ∧ y + 7 = 18 * x
  | .c5t5765 => x = 7757 + 13122 * (5765 + 8192 * k) ∧ y + 7 = 18 * x
  | .c5t554 => x = 7757 + 13122 * (554 + 4096 * k) ∧ y + 7 = 18 * x
  | .d1h482 => x = 307 + 2125764 * (482 + 1024 * k) ∧ y + 7 = 36 * x
  | .d1h249 => x = 307 + 2125764 * (249 + 256 * k) ∧ y + 7 = 36 * x
  | .d1h461 => x = 307 + 2125764 * (461 + 512 * k) ∧ y + 7 = 36 * x
  | .d1h3845 => x = 307 + 2125764 * (3845 + 4096 * k) ∧ y + 7 = 36 * x
  | .alpha4s7 => x = 2149 + 4096 * k ∧ 4 * y + 1 = 9 * x

theorem coordinates_iff (row : Row) (k x y : Nat) :
    Coordinates row k x y ↔
      x = (data row).originalStart.at k ∧ y = (data row).sourceStart.at k := by
  cases row <;> simp only [Coordinates, data, Affine.at] <;> omega

def originalEnd (row : Row) : Affine :=
  endpoint (data row).originalStart (data row).originalWord

def sourceEnd (row : Row) : Affine :=
  endpoint (data row).sourceStart (data row).sourceWord

def BridgeCoefficients (z w : Affine) (gap : Nat) : Prop :=
  3*z.offset+1=2^gap*(3*w.offset+1) ∧ z.slope=2^gap*w.slope

instance (z w : Affine) (gap : Nat) : Decidable (BridgeCoefficients z w gap) := by
  unfold BridgeCoefficients
  infer_instance

theorem bridge_factor {z w : Affine} {gap : Nat}
    (hc : BridgeCoefficients z w gap) (k : Nat) :
    3*z.at k+1=2^gap*(3*w.at k+1) := by
  rcases hc with ⟨h0, h1⟩
  calc
    _ = (3*z.offset+1)+3*z.slope*k := by
      simp only [Affine.at, Nat.mul_add, Nat.mul_assoc]
      ac_rfl
    _ = 2^gap*(3*w.offset+1)+3*(2^gap*w.slope)*k := by rw [h0, h1]
    _ = _ := by
      simp only [Affine.at, Nat.mul_add, Nat.mul_assoc]
      ac_rfl

/-- A finite coefficient check. It does not run orbits at sample seeds. -/
theorem certified_coefficients (row : Row) :
    checkWord (data row).originalStart (data row).originalWord = true ∧
    checkWord (data row).sourceStart (data row).sourceWord = true ∧
    (originalEnd row).admissible ∧ (sourceEnd row).admissible ∧
    BridgeCoefficients (originalEnd row) (sourceEnd row) (data row).finalGap := by
  cases row <;> decide

def originalReturns (row : Row) : Nat := (data row).originalWord.length+1
def sourceReturns (row : Row) : Nat := (data row).sourceWord.length+1
def originalDivisions (row : Row) (β : Nat) : Nat :=
  divisions (data row).originalWord+((data row).finalGap+β)
def sourceDivisions (row : Row) (β : Nat) : Nat := divisions (data row).sourceWord+β
def originalAdditive (row : Row) : Nat :=
  3*cost (data row).originalWord+2^(divisions (data row).originalWord)
def sourceAdditive (row : Row) : Nat :=
  3*cost (data row).sourceWord+2^(divisions (data row).sourceWord)

def terminal (row : Row) (k : Nat) : Nat := step ((sourceEnd row).at k)

structure LocalMeeting (row : Row) (k β : Nat) : Prop where
  valuation_pos : 0 < β
  original_factor :
    3*(originalEnd row).at k+1=2^((data row).finalGap+β)*terminal row k
  source_factor : 3*(sourceEnd row).at k+1=2^β*terminal row k
  original : Segment ((data row).originalStart.at k) (terminal row k)
    (originalReturns row) (originalDivisions row β) (originalAdditive row)
  source : Segment ((data row).sourceStart.at k) (terminal row k)
    (sourceReturns row) (sourceDivisions row β) (sourceAdditive row)

/-- Both words are physical throughout the guard class, with a shared
terminal and the actual last valuation from the source. -/
theorem local_meeting (row : Row) (k : Nat) : ∃ β, LocalMeeting row k β := by
  obtain ⟨hwN, hwW, hz, hw, hgap⟩ := certified_coefficients row
  have hzp := affine_admissible hz k
  have hwp := affine_admissible hw k
  obtain ⟨β, hβ, hsource⟩ := P5R3S5.actual_step_factor _ hwp.2
  change 3*(sourceEnd row).at k+1=2^β*terminal row k at hsource
  have horiginal : 3*(originalEnd row).at k+1=2^((data row).finalGap+β)*terminal row k := by
    rw [bridge_factor hgap k, hsource, Nat.pow_add, Nat.mul_assoc]
  have nLast : Segment ((originalEnd row).at k) (terminal row k) 1
      ((data row).finalGap+β) 1 := by
    exact ⟨Physical.edge hzp.1 hzp.2 (step_pos _) (step_odd _) (by omega) horiginal,
      horiginal.symm⟩
  have wLast := P5R3S5.step_segment _ β hwp.1 hwp.2 hβ hsource
  refine ⟨β, by omega, horiginal, hsource, ?_, ?_⟩
  · simpa only [originalReturns, originalDivisions, originalAdditive, Nat.pow_one,
      Nat.mul_one] using StagedCylinder.compose
        (word_segment k (data row).originalStart (data row).originalWord hwN) nLast
  · simpa only [sourceReturns, sourceDivisions, sourceAdditive, Nat.pow_one,
      Nat.mul_one] using StagedCylinder.compose
        (word_segment k (data row).sourceStart (data row).sourceWord hwW) wLast

theorem exact_terminal_valuations {row : Row} {k β : Nat}
    (h : LocalMeeting row k β) :
    (2^((data row).finalGap+β) ∣ 3*(originalEnd row).at k+1 ∧
      ¬2^((data row).finalGap+β+1) ∣ 3*(originalEnd row).at k+1) ∧
    (2^β ∣ 3*(sourceEnd row).at k+1 ∧ ¬2^(β+1) ∣ 3*(sourceEnd row).at k+1) := by
  have ho : (terminal row k)%2=1 := step_odd _
  exact ⟨P5R3S5.exact_reserve ho h.original_factor, P5R3S5.exact_reserve ho h.source_factor⟩

structure Capture (row : Row) (k N w jN SN BN jW SW BW β : Nat) : Prop where
  meeting : LocalMeeting row k β
  original : Segment N (terminal row k) (jN+originalReturns row)
    (SN+originalDivisions row β) (3^(originalReturns row)*BN+originalAdditive row*2^SN)
  source : Segment w (terminal row k) (jW+sourceReturns row)
    (SW+sourceDivisions row β) (3^(sourceReturns row)*BW+sourceAdditive row*2^SW)

/-- Historical segments and their separate books are supplied explicitly. -/
theorem capture {row : Row} {k N w jN SN BN jW SW BW : Nat}
    (original : Segment N ((data row).originalStart.at k) jN SN BN)
    (source : Segment w ((data row).sourceStart.at k) jW SW BW) :
    ∃ β, Capture row k N w jN SN BN jW SW BW β := by
  obtain ⟨β, h⟩ := local_meeting row k
  exact ⟨β, h, P5R3S5.transport original h.original, P5R3S5.transport source h.source⟩

theorem capture_from_coordinates {row : Row} {k N w x y jN SN BN jW SW BW : Nat}
    (phase : Coordinates row k x y)
    (original : Segment N x jN SN BN)
    (source : Segment w y jW SW BW) :
    ∃ β, Capture row k N w jN SN BN jW SW BW β := by
  obtain ⟨hx, hy⟩ := (coordinates_iff row k x y).mp phase
  exact capture (StagedCylinder.cast_segment original rfl hx)
    (StagedCylinder.cast_segment source rfl hy)

theorem orbit_meeting {row : Row} {k N w jN SN BN jW SW BW β : Nat}
    (h : Capture row k N w jN SN BN jW SW BW β) :
    orbit N (jN+originalReturns row)=orbit w (jW+sourceReturns row) :=
  (A2Header.physical_endpoint h.original.physical).trans
    (A2Header.physical_endpoint h.source.physical).symm

private theorem one_orbit (i : Nat) : orbit 1 i=1 := by
  induction i with
  | zero => rfl
  | succ i ih =>
    change step (orbit 1 i)=1
    rw [ih]
    change oddPart 4=1
    exact (oddPart_quadruple 1).trans (oddPart_of_odd (by decide))

/-- Only the initial source is required to be smaller than this N. -/
theorem closes_under_IH {row : Row} {k N w jN SN BN jW SW BW β : Nat}
    (h : Capture row k N w jN SN BN jW SW BW β)
    (hw0 : 0<w) (hwOdd : w%2=1) (hwN : w<N)
    (IH : ∀ x : Nat, 0<x → x%2=1 → x<N → ∃ i, orbit x i=1) :
    ∃ i, orbit N i=1 := by
  obtain ⟨i, hi⟩ := IH w hw0 hwOdd hwN
  let n := jN+originalReturns row
  let m := jW+sourceReturns row
  have hmeet : orbit N n=orbit w m := orbit_meeting h
  refine ⟨n+i, ?_⟩
  rw [orbit_add, hmeet, ←orbit_add, Nat.add_comm m i, orbit_add, hi, one_orbit]

#print axioms affine_admissible
#print axioms affine_edge
#print axioms word_segment
#print axioms coordinates_iff
#print axioms bridge_factor
#print axioms certified_coefficients
#print axioms local_meeting
#print axioms exact_terminal_valuations
#print axioms capture
#print axioms capture_from_coordinates
#print axioms orbit_meeting
#print axioms one_orbit
#print axioms closes_under_IH

end CollatzCharacterBridge.P5CompensationMeetings
