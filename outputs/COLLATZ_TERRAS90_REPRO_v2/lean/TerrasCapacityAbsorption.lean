import Std

namespace TerrasCapacityAbsorption

def scaledWeight (p q M i : Nat) : Nat :=
  p^i*q^(M-i)

def geometricNum (p q M : Nat) : Nat → Nat
  | 0 => 0
  | n+1 => geometricNum p q M n+scaledWeight p q M n

def capacityNum (p q M n : Nat) : Nat :=
  if n=0 then 0
  else if n=1 then 2*q^M
  else if n=2 then 3*q^M
  else if n≤4 then 2*(q^M+p*q^(M-1))
  else 2*geometricNum p q M (n-3)

/-- The cutoff makes the subtractions in the weights exact. -/
theorem scaledWeight_mono {p q M i j : Nat}
    (_hq : 0<q) (hpq : q≤p) (hij : i≤j) (hj : j≤M) :
    scaledWeight p q M i≤scaledWeight p q M j := by
  let d := j-i
  have left_exp : M-i=d+(M-j) := by dsimp only [d]; omega
  have right_exp : j=i+d := by dsimp only [d]; omega
  have order : q^d≤p^d := Nat.pow_le_pow_left hpq d
  have pSplit : p^j=p^i*p^d := by rw [right_exp,Nat.pow_add]
  unfold scaledWeight
  calc
    p^i*q^(M-i) = (p^i*q^d)*q^(M-j) := by rw [left_exp,Nat.pow_add,Nat.mul_assoc]
    _ ≤ (p^i*p^d)*q^(M-j) := Nat.mul_le_mul_right _ (Nat.mul_le_mul_left _ order)
    _ = p^j*q^(M-j) := by rw [pSplit]

private theorem geometricNum_mono {p q M a b : Nat} (h : a≤b) :
    geometricNum p q M a≤geometricNum p q M b := by
  induction b with
  | zero =>
    have e : a=0 := by omega
    rw [e]
    exact Nat.le_refl _
  | succ b ih =>
    by_cases early : a≤b
    · exact Nat.le_trans (ih early) (Nat.le_add_right _ _)
    · have e : a=b+1 := by omega
      rw [e]
      exact Nat.le_refl _

/-- Moving the second geometric sum to later indices cannot shrink it. -/
private theorem geometricNum_shift_lower {p q M l m : Nat}
    (hq : 0<q) (hpq : q≤p) (budget : l+m≤M+1) :
    geometricNum p q M l+geometricNum p q M m≤geometricNum p q M (l+m) := by
  induction m with
  | zero => simp [geometricNum]
  | succ m ih =>
    have earlier := ih (by omega)
    have weights := scaledWeight_mono (p := p) (q := q) (M := M)
      (i := m) (j := l+m) hq hpq (by omega) (by omega)
    change geometricNum p q M l+(geometricNum p q M m+scaledWeight p q M m) ≤
      geometricNum p q M (l+m)+scaledWeight p q M (l+m)
    omega

private theorem capacity_one (p q M : Nat) : capacityNum p q M 1=2*q^M := by
  simp [capacityNum]

private theorem capacity_two (p q M : Nat) : capacityNum p q M 2=3*q^M := by
  simp [capacityNum]

private theorem capacity_three_four {p q M n : Nat} (low : 3≤n) (high : n≤4) :
    capacityNum p q M n=2*geometricNum p q M 2 := by
  have n0 : n≠0 := by omega
  have n1 : n≠1 := by omega
  have n2 : n≠2 := by omega
  simp [capacityNum,n0,n1,n2,high,geometricNum,scaledWeight]

private theorem capacity_long {p q M n : Nat} (h : 5≤n) :
    capacityNum p q M n=2*geometricNum p q M (n-3) := by
  have n0 : n≠0 := by omega
  have n1 : n≠1 := by omega
  have n2 : n≠2 := by omega
  have high : ¬n≤4 := by omega
  simp only [capacityNum,if_neg n0,if_neg n1,if_neg n2,if_neg high]

private theorem absorb_geometric {p q M L s d : Nat}
    (hq : 0<q) (hpq : q≤p) (receiver : 5≤L) (donor : 1≤s)
    (budget : L+s≤M+5) (terms : d≤s-1)
    (form : capacityNum p q M s=2*geometricNum p q M d) :
    capacityNum p q M L+capacityNum p q M s≤
      capacityNum p q M (L+s-1)+capacityNum p q M 1 := by
  have shifted := geometricNum_shift_lower (p := p) (q := q) (M := M)
    (l := L-3) (m := d) hq hpq (by omega)
  have longer := geometricNum_mono (p := p) (q := q) (M := M)
    (a := (L-3)+d) (b := L+s-1-3) (by omega)
  have bound := Nat.le_trans shifted longer
  rw [capacity_long receiver,form,capacity_long (by omega : 5≤L+s-1),capacity_one]
  omega

/-- Absorb all but one run of the positive donor into a receiver of
    at least five. This avoids convexity assumptions at the small sizes. -/
theorem capacityNum_absorb_pair {p q M L s : Nat}
    (hq : 0<q) (hpq : q≤p) (_hM : 1≤M)
    (receiver : 5≤L) (donor : 1≤s) (budget : L+s≤M+5) :
    capacityNum p q M L+capacityNum p q M s≤
      capacityNum p q M (L+s-1)+capacityNum p q M 1 := by
  by_cases one : s=1
  · subst s
    simp
  by_cases two : s=2
  · subst s
    rw [capacity_long receiver,capacity_two,capacity_long (by omega : 5≤L+2-1),capacity_one]
    have term_count : L+2-1-3=(L-3)+1 := by omega
    rw [term_count]
    change 2*geometricNum p q M (L-3)+3*q^M≤
      2*(geometricNum p q M (L-3)+scaledWeight p q M (L-3))+2*q^M
    have first_weight : scaledWeight p q M 0=q^M := by simp [scaledWeight]
    have h := scaledWeight_mono (p := p) (q := q) (M := M)
      (i := 0) (j := L-3) hq hpq (by omega) (by omega)
    rw [first_weight] at h
    omega
  by_cases small : s≤4
  · exact absorb_geometric hq hpq receiver donor budget (by omega)
      (capacity_three_four (by omega) small)
  · exact absorb_geometric hq hpq receiver donor budget (by omega)
      (capacity_long (by omega))

private theorem sum_append (xs ys : List Nat) : (xs++ys).sum=xs.sum+ys.sum := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp [ih,Nat.add_assoc]

private theorem sum_le_four_mul_length (xs : List Nat)
    (all : ∀ n, n∈xs → n≤4) : xs.sum≤4*xs.length := by
  induction xs with
  | nil => simp
  | cons x xs ih =>
    have top := all x (List.mem_cons_self)
    have rest := ih (fun n hn => all n (List.mem_cons_of_mem x hn))
    simp only [List.sum_cons,List.length_cons]
    omega

private theorem absorb_remaining {p q M : Nat} (hq : 0<q) (hpq : q≤p) (hM : 1≤M)
    (xs : List Nat) {L : Nat} (receiver : 5≤L)
    (positive : ∀ n, n∈xs → 1≤n) (budget : L+xs.sum≤M+4) :
    capacityNum p q M L+(xs.map (capacityNum p q M)).sum≤
      capacityNum p q M (L+xs.sum-xs.length)+xs.length*capacityNum p q M 1 := by
  induction xs generalizing L with
  | nil => simp
  | cons s xs ih =>
    have donor := positive s List.mem_cons_self
    have pair := capacityNum_absorb_pair hq hpq hM receiver donor
      (by simp only [List.sum_cons] at budget; omega)
    have remaining := ih (L := L+s-1) (by omega)
      (fun n hn => positive n (List.mem_cons_of_mem s hn))
      (by simp only [List.sum_cons] at budget; omega)
    have final_size : L+s-1+xs.sum-xs.length=L+(s::xs).sum-(s::xs).length := by
      simp only [List.sum_cons,List.length_cons]
      omega
    rw [final_size] at remaining
    simp only [List.sum_cons,List.length_cons] at remaining
    simp only [List.map_cons,List.sum_cons,List.length_cons,Nat.succ_mul]
    omega

/-- The receiver exists by the strict average bound. Repeated segment
    lengths remain separate occurrences in the list and in its sum. -/
theorem capacityNum_absorption {p q M : Nat}
    (hq : 0<q) (hpq : q≤p) (hM : 1≤M) (sizes : List Nat)
    (positive : ∀ n, n∈sizes → 1≤n) (longEnough : 4*sizes.length<sizes.sum)
    (budget : sizes.sum≤M+4) :
    (sizes.map (capacityNum p q M)).sum≤
      capacityNum p q M (sizes.sum-sizes.length+1)+(sizes.length-1)*capacityNum p q M 1 := by
  have some_receiver : ∃ L, L∈sizes ∧ 5≤L := by
    by_cases found : ∃ L, L∈sizes ∧ 5≤L
    · exact found
    · have all : ∀ n, n∈sizes → n≤4 := by
        intro n hn
        by_cases small : n≤4
        · exact small
        · exact (found ⟨n,hn,by omega⟩).elim
      exact ((Nat.not_le_of_gt longEnough) (sum_le_four_mul_length sizes all)).elim
  obtain ⟨L,member,receiver⟩ := some_receiver
  obtain ⟨left,right,split,_⟩ := List.eq_append_cons_of_mem member
  let donors := left++right
  have tally : L+donors.sum=sizes.sum := by
    rw [split]
    simp only [donors,sum_append,List.sum_cons]
    omega
  have count : donors.length+1=sizes.length := by
    rw [split]
    simp only [donors,List.length_append,List.length_cons]
    omega
  have rest_pos : ∀ n, n∈donors → 1≤n := by
    intro n member
    apply positive n
    rw [split]
    rcases List.mem_append.mp member with on_left | on_right
    · exact List.mem_append_left _ on_left
    · exact List.mem_append_right _ (List.mem_cons_of_mem L on_right)
  have bound := absorb_remaining hq hpq hM donors receiver rest_pos (by rw [tally]; exact budget)
  have sums : capacityNum p q M L+(donors.map (capacityNum p q M)).sum=
      (sizes.map (capacityNum p q M)).sum := by
    rw [split]
    simp only [donors,List.map_append,List.map_cons,sum_append,List.sum_cons]
    omega
  have size_bnd : sizes.length≤sizes.sum := by omega
  have result_size : L+donors.sum-donors.length=sizes.sum-sizes.length+1 := by omega
  have result_count : donors.length=sizes.length-1 := by omega
  rwa [sums,result_size,result_count] at bound

end TerrasCapacityAbsorption
