import StagedCylinder

namespace CollatzCharacterBridge.A2PhysicalPrefix
open A2Header (Physical)
open StagedCylinder (Segment)
set_option maxRecDepth 16000
set_option maxHeartbeats 200000

/-- Every supplied physical word has its exact nonnegative additive book. -/
theorem segment_of_physical {x j s Z : Nat} (path : Physical x j s Z) :
    ∃ C, Segment x Z j s C := by
  induction path with
  | refl x =>
    refine ⟨0,Physical.refl x,?_⟩
    simp
  | @edge x a y hx hxo hy hyo ha hf =>
    exact ⟨1,Physical.edge hx hxo hy hyo ha hf,hf.symm⟩
  | @append x y z k s l t p q ihp ihq =>
    obtain ⟨C,pre⟩ := ihp
    obtain ⟨D,suf⟩ := ihq
    exact ⟨3^l*C+2^s*D,StagedCylinder.compose pre suf⟩

/-- Cut a physical word at its actual m-th odd-return checkpoint.
The two valuation sums add to the original sum, including m=0 and m=j. -/
theorem physical_split {x j s Z m : Nat} (path : Physical x j s Z) (hm : m≤j) :
    ∃ s1 s2, s1+s2=s ∧
      Physical x m s1 (orbit x m) ∧ Physical (orbit x m) (j-m) s2 Z := by
  induction path generalizing m with
  | refl x =>
    have zero : m=0 := by omega
    subst m
    exact ⟨0,0,rfl,Physical.refl x,Physical.refl x⟩
  | @edge x a y hx hxo hy hyo ha hf =>
    have single : Physical x 1 a y := Physical.edge hx hxo hy hyo ha hf
    by_cases zero : m=0
    · subst m
      exact ⟨0,a,by omega,Physical.refl x,single⟩
    · have one : m=1 := by omega
      subst m
      have endpoint : orbit x 1=y := A2Header.physical_endpoint single
      rw [endpoint]
      exact ⟨a,0,by omega,single,Physical.refl y⟩
  | @append x y z k s l t p q ihp ihq =>
    by_cases left : m≤k
    · obtain ⟨s1,s2,total,pre,suf⟩ := ihp left
      refine ⟨s1,s2+t,by omega,pre,?_⟩
      have combined := Physical.append suf q
      simpa only [show (k-m)+l=k+l-m by omega] using combined
    · have right : m-k≤l := by omega
      obtain ⟨t1,t2,total,pre,suf⟩ := ihq right
      have checkpoint : orbit x m=orbit y (m-k) := by
        calc
          orbit x m=orbit x (k+(m-k)) := by congr 1; omega
          _=orbit y (m-k) := by rw [orbit_add,A2Header.physical_endpoint p]
      refine ⟨s+t1,t2,by omega,?_,?_⟩
      · have combined := Physical.append p pre
        rw [show k+(m-k)=m by omega,←checkpoint] at combined
        exact combined
      · rw [checkpoint]
        simpa only [show l-(m-k)=k+l-m by omega] using suf

/-- Both extracted segments are physical and retain their own exact books.
No crossing, minimum, threshold or positivity guard is selected here. -/
theorem split {x j s Z m : Nat} (path : Physical x j s Z) (hm : m≤j) :
    ∃ s1 s2 Cpre Csuf, s1+s2=s ∧
      Segment x (orbit x m) m s1 Cpre ∧
      Segment (orbit x m) Z (j-m) s2 Csuf := by
  obtain ⟨s1,s2,total,pre,suf⟩ := physical_split path hm
  obtain ⟨Cpre,preBook⟩ := segment_of_physical pre
  obtain ⟨Csuf,sufBook⟩ := segment_of_physical suf
  exact ⟨s1,s2,Cpre,Csuf,total,preBook,sufBook⟩

/-- When the input also supplies its additive, the decomposition preserves
that same additive as the exact weighted composition of the two books. -/
theorem split_segment {x j s Z B m : Nat} (path : Segment x Z j s B) (hm : m≤j) :
    ∃ s1 s2 Cpre Csuf, s1+s2=s ∧
      Segment x (orbit x m) m s1 Cpre ∧
      Segment (orbit x m) Z (j-m) s2 Csuf ∧
      B=3^(j-m)*Cpre+2^s1*Csuf := by
  obtain ⟨s1,s2,Cpre,Csuf,total,pre,suf⟩ := split path.physical hm
  have whole := StagedCylinder.compose pre suf
  rw [show m+(j-m)=j by omega,total] at whole
  have originalBook := path.book
  have composedBook := whole.book
  exact ⟨s1,s2,Cpre,Csuf,total,pre,suf,by omega⟩

end CollatzCharacterBridge.A2PhysicalPrefix
