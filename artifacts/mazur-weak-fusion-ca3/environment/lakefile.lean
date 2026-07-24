import Lake

open Lake DSL

package «weak-fixed-target-fusion»

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @
  "c5ea00351c28e24afc9f0f84379aa41082b1188f"

lean_lib FormalConjectures where
  roots := #[`FormalConjectures.Wikipedia.CollatzStep]

lean_lib Erdos1135 where
  globs := #[.submodules `Erdos1135]
  roots := #[`Erdos1135.ND.FusionParametric]
