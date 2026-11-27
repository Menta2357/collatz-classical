import Terras88

namespace Terras91Delay

open TerrasClock

def ordinary (x : Nat) : Nat := if x%2=1 then 3*x+1 else x/2

def ordinaryOrbit (N : Nat) : Nat → Nat
  | 0 => N
  | k+1 => ordinary (ordinaryOrbit N k)

theorem ordinary_add (N p q : Nat) :
    ordinaryOrbit N (p+q) = ordinaryOrbit (ordinaryOrbit N p) q := by
  induction q with
  | zero => rfl
  | succ q ih => rw [Nat.add_succ]; simp only [ordinaryOrbit,ih]

private theorem ordinaryTwo {N : Nat} (odd : N%2=1) :
    ordinaryOrbit N 2 = shortcut N := by
  have even : (3*N+1)%2=0 := by omega
  simp [ordinaryOrbit,ordinary,shortcut,odd,show ¬(3*N+1)%2=1 by omega]

private theorem ordinaryOne {N : Nat} (even : N%2≠1) :
    ordinaryOrbit N 1 = shortcut N := by
  simp [ordinaryOrbit,ordinary,shortcut,even]

/-- The exact ordinary time of the same shortcut prefix. -/
theorem ordinaryAtShortcut (N k : Nat) :
    ordinaryOrbit N (k+oddCount N k) = orbit N k := by
  induction k with
  | zero => rfl
  | succ k ih =>
    rw [orbit_succ]
    by_cases odd : orbit N k%2=1
    · have time : k+1+oddCount N (k+1)=(k+oddCount N k)+2 := by
        simp only [oddCount,odd,if_true]
        omega
      rw [time,ordinary_add,ih,ordinaryTwo odd]
    · have time : k+1+oddCount N (k+1)=(k+oddCount N k)+1 := by
        simp only [oddCount,odd,if_false,Nat.add_zero]
        omega
      rw [time,ordinary_add,ih,ordinaryOne odd]

/-- A hit at the odd state 1 survives compression, even when the ordinary
time is supplied independently of the shortcut clock. -/
theorem shortcutHitOne {N t : Nat} (hit : ordinaryOrbit N t=1) :
    ∃ k≤t, orbit N k=1 := by
  induction t using Nat.strongRecOn generalizing N with
  | ind t ih =>
    cases t with
    | zero => exact ⟨0,by decide,hit⟩
    | succ s =>
      by_cases odd : N%2=1
      · cases s with
        | zero =>
          have step : 3*N+1=1 := by simpa [ordinaryOrbit,ordinary,odd] using hit
          omega
        | succ u =>
          have after : ordinaryOrbit (shortcut N) u=1 := by
            rw [←ordinaryTwo odd,←ordinary_add,show 2+u=u+1+1 by omega]
            exact hit
          obtain ⟨q,upper,one⟩ := ih u (by omega) after
          refine ⟨1+q,by omega,?_⟩
          rw [orbit_add]
          exact one
      · have after : ordinaryOrbit (shortcut N) s=1 := by
          rw [←ordinaryOne odd,←ordinary_add,Nat.add_comm]
          exact hit
        obtain ⟨q,upper,one⟩ := ih s (by omega) after
        refine ⟨1+q,by omega,?_⟩
        rw [orbit_add]
        exact one

def recordSeed : Nat := 46645791847966786687

/-- The published confirmed strict total-delay record, including its own
endpoint. The coverage over the smaller seeds is a source premise. -/
def OrdinaryDelay2480 : Prop :=
  ∀ N, 2≤N → N≤recordSeed → ∃ t≤2480, ordinaryOrbit N t=1

theorem aboveRecordAtQ0 {N k : Nat} (record : OrdinaryDelay2480)
    (seed : 2≤N) (first : FirstContraction N k)
    (clock : (k,oddCount N k)=Terras88.q0Clock) : recordSeed<N := by
  by_cases small : N≤recordSeed
  · obtain ⟨t,ht,hit⟩ := record N seed small
    obtain ⟨j,hj,one⟩ := shortcutHitOne hit
    have time : k=Terras88.q0Clock.1 := congrArg Prod.fst clock
    have late : 2480<k := time ▸ (by decide : 2480<Terras88.q0Clock.1)
    have before := prior_no_descent first (show j<k by omega)
    omega
  · omega

end Terras91Delay

#print axioms Terras91Delay.ordinaryAtShortcut
#print axioms Terras91Delay.shortcutHitOne
#print axioms Terras91Delay.aboveRecordAtQ0
