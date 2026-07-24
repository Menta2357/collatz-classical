# F3 forward-right certificate v3 — G0 report

Gate G0 records the two pre-compilation phases required by the frozen v3
contract.  No target or audit object was produced by either phase.

- Frozen branch HEAD before G0 custody: `898680bfb5aa3a20fb67b6c0a9d55c432eb8cfe1`.
- S0 staged one isolated CollatzClassical root containing 209 `.olean` files,
  zero `.ilean` files, and zero symbolic links.
- The staged-tree SHA-256 reported by S0 is
  `47f559f88e7b103fe0d775b1a7b5a5e3a3fd5e9327cd4619129dbc4c473707d8`.
- S0 completed in 12.51 seconds and reported wrapper exit status 0.
- D0 imported the staged root directly, checked the required matrix identity,
  channel-weight lower bound, and weighted-mass push lower bound, and reported
  a single Collatz root.
- D0 completed in 194.45 seconds and reported wrapper exit status 0.
- D0 confirmed that the target objects remained absent after the probe.

F3_FORWARD_V3_G0=PASS
F3_FORWARD_V3_S0_LOG_SHA256=0dadbb9651093c35d94e1ce62747470d5e9151658e54398340611977bb1ea11f
F3_FORWARD_V3_D0_LOG_SHA256=a6f52c1125cdc224372f2b35c17a87934ccaa7f8889406e00505029a22139c55
