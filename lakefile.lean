import Lake
open Lake DSL

package «collatz-classical» where
  -- Private draft project for classical Collatz formalisation experiments.

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.21.0"

lean_lib CollatzClassical where
  roots := #[`CollatzClassical]
