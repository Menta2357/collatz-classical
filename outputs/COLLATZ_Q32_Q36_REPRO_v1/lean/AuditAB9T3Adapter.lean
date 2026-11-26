import AB9T3Adapter

open CollatzCharacterBridge.AB9T3Adapter

#print axioms select_iff_guard
#print axioms guard_meeting
#print axioms union_paid

example : select 1858 = some .r0 := by decide
example : select 9883 = some .r3 := by decide
example : select 3007528 = some .r6 := by decide
example : select 0 = none := by decide
