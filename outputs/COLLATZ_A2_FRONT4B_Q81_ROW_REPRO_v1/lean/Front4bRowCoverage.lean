import Front4bRowC7
import Front4bRowOdd

namespace CollatzCharacterBridge.Front4bRowCoverage

open A2FirstCrossingFusion (Paid Admitted)
open Front4bRowEven (originalSeed pivot)

set_option maxRecDepth 16000
set_option maxHeartbeats 1200000

def Direct (u : Nat) : Prop :=
  (u%32=26 ∨ u%128=106 ∨ u%256=42) ∨
    u%128=2 ∨ u%256=74 ∨ u%1024=426 ∨ u%128=66

def Open (u : Nat) : Prop := u%32=18 ∨ u%64=34 ∨ u%128=10 ∨ u%256=202

private instance decidableDirect (u : Nat) : Decidable (Direct u) := by
  unfold Direct
  infer_instance

private instance decidableOpen (u : Nat) : Decidable (Open u) := by
  unfold Open
  infer_instance

theorem paidOfDirect {u : Nat} (guard : Direct u) : Paid (originalSeed u) := by
  rcases guard with even | h3 | h5 | h7 | capture
  · exact .inl (Front4bRowEven.evenAndHighDescend even)
  · have eq : u=2+128*(u/128) := by omega
    rw [eq]
    obtain ⟨e,Z,_,hp,ho,below,_,history⟩ := Front4bRowOdd.band3Strong (u/128)
    exact .inl ⟨Z,67,98+(5+e),_,hp,ho,below,history⟩
  · have eq : u=74+256*(u/256) := by omega
    rw [eq]
    obtain ⟨e,Z,_,hp,ho,below,_,history⟩ := Front4bRowOdd.band5Strong (u/256)
    exact .inl ⟨Z,68,98+(7+e),_,hp,ho,below,history⟩
  · have eq : u=426+1024*(u/1024) := by omega
    rw [eq]
    obtain ⟨e,Z,_,hp,ho,below,_,history⟩ := Front4bRowOdd.band7Strong (u/1024)
    exact .inl ⟨Z,69,98+(9+e),_,hp,ho,below,history⟩
  · have eq : u=66+128*(u/128) := by omega
    rw [eq]
    exact .inr (Front4bRowOdd.smallerSourceCapture (u/128))

private theorem finitePartition : (List.range 1024).all (fun u => decide
    (u%8=2 → Direct u ∨ u%256=170 ∨ Open u)) = true := by decide

theorem directCount : ((List.range 1024).filter (fun u => decide (u%8=2 ∧ Direct u))).length=65 :=
  by decide

theorem ambientOnlyCount : ((List.range 1024).filter (fun u => decide
    (u%8=2 ∧ ¬Direct u ∧ u%256=170))).length=3 := by decide

theorem openCount : ((List.range 1024).filter (fun u => decide (u%8=2 ∧ Open u))).length=60 :=
  by decide

/-- The four remaining guards are exposed explicitly. The middle outcome
is a certified reentry in the ambient A2 domain with lower rank. -/
theorem classify {u : Nat} (row : u%8=2) :
    Paid (originalSeed u) ∨
      (∃ x j s B, x-originalSeed u<pivot u-originalSeed u ∧ Admitted (originalSeed u) x j s B) ∨
      Open u := by
  have m8 := Nat.mod_mod_of_dvd u (by decide : 8∣1024)
  have m32 := Nat.mod_mod_of_dvd u (by decide : 32∣1024)
  have m64 := Nat.mod_mod_of_dvd u (by decide : 64∣1024)
  have m128 := Nat.mod_mod_of_dvd u (by decide : 128∣1024)
  have m256 := Nat.mod_mod_of_dvd u (by decide : 256∣1024)
  have m1024 := Nat.mod_mod u 1024
  have inside : u%1024∈List.range 1024 := List.mem_range.mpr (Nat.mod_lt _ (by decide))
  have target : Direct u ∨ u%256=170 ∨ Open u := by
    have small := of_decide_eq_true (List.all_eq_true.mp finitePartition (u%1024) inside)
    simpa only [Direct,Open,m8,m32,m64,m128,m256,m1024,row,true_implies] using small
  rcases target with direct | c7 | gap
  · exact .inl (paidOfDirect direct)
  · rcases Front4bRowC7.paidOrAmbientOfResidue c7 with paid | smaller
    · exact .inl paid
    · exact .inr (.inl smaller)
  · exact .inr (.inr gap)

end CollatzCharacterBridge.Front4bRowCoverage

#print axioms CollatzCharacterBridge.Front4bRowCoverage.paidOfDirect
#print axioms CollatzCharacterBridge.Front4bRowCoverage.directCount
#print axioms CollatzCharacterBridge.Front4bRowCoverage.ambientOnlyCount
#print axioms CollatzCharacterBridge.Front4bRowCoverage.openCount
#print axioms CollatzCharacterBridge.Front4bRowCoverage.classify
