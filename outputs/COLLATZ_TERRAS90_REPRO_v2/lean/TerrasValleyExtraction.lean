import Std

namespace TerrasValleyExtraction

def StartsLow (small : Nat → Bool) : List Nat → Prop
  | [] => True
  | z :: _ => small z = true

/-- A low start and the next span starts, all outside the low set.
The list preserves chronological indices and multiplicities. -/
def HasChain (small : Nat → Bool) (span : Nat) (w : List Nat) : Prop :=
  ∃ pre z run post, w = pre ++ (z :: (run ++ post)) ∧
    small z = true ∧ run.length = span ∧ ∀ i ∈ run, small i = false

private theorem prepend {small : Nat → Bool} {span : Nat} {w : List Nat}
    (first : List Nat) (hw : HasChain small span w) : HasChain small span (first ++ w) := by
  obtain ⟨pre,z,run,post,hex,hz,hlen,hrun⟩ := hw
  exact ⟨first++pre,z,run,post,by rw [hex,List.append_assoc],hz,hlen,hrun⟩

private theorem split_at_low (small : Nat → Bool) (w : List Nat) :
    ∃ high low, w=high++low ∧ (∀ i ∈ high, small i=false) ∧ StartsLow small low := by
  induction w with
  | nil => exact ⟨[],[],rfl,by simp,trivial⟩
  | cons i rest ih =>
    by_cases hi : small i = true
    · exact ⟨[],i::rest,rfl,by simp,hi⟩
    · have hf : small i=false := by
        cases value : small i with
        | false => rfl
        | true => exact (hi value).elim
      obtain ⟨high,low,hh,all,hl⟩ := ih
      refine ⟨i::high,low,by rw [hh,List.cons_append],?_,hl⟩
      intro j hj
      rcases List.mem_cons.mp hj with rfl | hm
      · exact hf
      · exact all j hm

private theorem no_chain_bound (small : Nat → Bool) (span budget : Nat)
    (w : List Nat) (size : w.length ≤ budget) (starts : StartsLow small w)
    (blocked : ¬HasChain small span w) :
    w.length ≤ w.countP small * span := by
  induction budget generalizing w with
  | zero => omega
  | succ fuel ih =>
    cases w with
    | nil => simp
    | cons z rest =>
      have hz : small z=true := starts
      obtain ⟨high,low,split,hh,hl⟩ := split_at_low small rest
      have short : high.length < span := by
        by_cases h : span ≤ high.length
        · exfalso
          apply blocked
          refine ⟨[],z,high.take span,high.drop span++low,?_,hz,?_,?_⟩
          · rw [List.nil_append,←List.append_assoc,List.take_append_drop,←split]
          · rw [List.length_take,Nat.min_eq_left h]
          · intro i hi
            exact hh i (List.mem_of_mem_take hi)
        · omega
      have low_size : low.length≤fuel := by
        simp only [split,List.length_cons,List.length_append] at size
        omega
      have low_blocked : ¬HasChain small span low := by
        intro chain
        apply blocked
        rw [split,←List.cons_append]
        exact prepend (z::high) chain
      have upper := ih low low_size hl low_blocked
      have empty_high : high.countP small = 0 := by
        apply List.countP_eq_zero.mpr
        intro i hi
        simp [hh i hi]
      simp only [List.length_cons,List.countP_cons,hz,if_true,split,List.length_append,
        List.countP_append,empty_high,Nat.zero_add,Nat.add_one,Nat.succ_mul]
      omega

/-- A long enough chronology has a low start followed by span consecutive
high starts. -/
theorem find_chain (small : Nat → Bool) (span : Nat) (w : List Nat)
    (starts : StartsLow small w) (crowded : w.countP small * span < w.length) :
    HasChain small span w := by
  by_cases h : HasChain small span w
  · exact h
  · have bound := no_chain_bound small span w.length w (Nat.le_refl _) starts h
    omega

private theorem countP_mono {p q : Nat → Bool} (w : List Nat)
    (h : ∀ i, p i=true → q i=true) : w.countP p ≤ w.countP q := by
  induction w with
  | nil => simp
  | cons i rest ih =>
    by_cases hi : p i=true
    · simp [List.countP_cons,hi,h i hi,ih]
    · simp only [List.countP_cons,hi,if_false,Nat.add_zero]
      exact Nat.le_trans ih (Nat.le_add_right _ _)

private theorem full_count {p : Nat → Bool} (w : List Nat)
    (h : ∀ i ∈ w, p i=true) : w.countP p=w.length := by
  induction w with
  | nil => rfl
  | cons i rest ih =>
    have hrest : ∀ j ∈ rest, p j=true := fun j jmem => h j (List.mem_cons_of_mem i jmem)
    simp [List.countP_cons,h i (by simp),ih hrest]

/-- Some fixed number of lowest entries has been marked. The marked
entries must all be below price and no higher than any unmarked entry.
Positions carry the chronology separately from ranking by value. -/
theorem extract {x : Nat → Nat} {price height span : Nat} {w : List Nat}
    (p : Nat → Bool)
    (ordered_cuts : price ≤ height)
    (priced : ∀ i, p i=true → x i<price)
    (ranked : ∀ i ∈ w, ∀ j ∈ w, p i=true → p j=false → x i≤x j)
    (starts : StartsLow p w)
    (crowded : w.countP p * span < w.length)
    (upper : w.countP (fun i => decide (x i<height)) < w.countP p + span) :
    ∃ pre z run post i, w=pre++(z::(run++post)) ∧
      x z<price ∧ run.length=span ∧ (∀ j ∈ run, x z≤x j) ∧
      i ∈ run ∧ height≤x i := by
  let q : Nat → Bool := fun i => decide (x i<height)
  obtain ⟨pre,z,run,post,split,hz,hlen,hrun⟩ := find_chain p span w starts crowded
  have zprice : x z<price := priced z hz
  have mono : ∀ i, p i=true → q i=true := by
    intro i hi
    apply decide_eq_true
    have hi' := priced i hi
    omega
  have run_mem : ∀ j ∈ run, x z≤x j := by
    intro j hj
    have zm : z ∈ w := by rw [split]; simp
    have jm : j ∈ w := by rw [split]; simp [hj]
    exact ranked z zm j jm hz (hrun j hj)
  have high_in_run : ∃ i ∈ run, height ≤ x i := by
    by_cases hit : ∃ i ∈ run, height ≤ x i
    · exact hit
    · exfalso
      have under : ∀ i ∈ run, q i=true := by
        intro i hi
        apply decide_eq_true
        by_cases h : height≤x i
        · exact (hit ⟨i,hi,h⟩).elim
        · omega
      have full := full_count run under
      have none : run.countP p = 0 := by
        apply List.countP_eq_zero.mpr
        intro i hi
        simp [hrun i hi]
      have monoPre := countP_mono pre mono
      have monoPost := countP_mono post mono
      have zq := mono z hz
      change w.countP q < w.countP p+span at upper
      rw [split] at upper
      simp only [List.countP_cons,List.countP_append,full,none,hlen,hz,zq,if_true,
        Nat.zero_add] at upper
      omega
  obtain ⟨i,hi,high⟩ := high_in_run
  exact ⟨pre,z,run,post,i,split,zprice,hlen,run_mem,hi,high⟩

end TerrasValleyExtraction
