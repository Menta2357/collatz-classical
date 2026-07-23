import CollatzClassical.KL2003.F3ReturnExcursionRenewalInterface

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3BoundaryLeakage

/-!
Arithmetic interface between a root/boundary decomposition and the renewal
leakage contract.  The hypotheses deliberately expose the denominator and
the retained mass; no aggregate boundary estimate is hidden.
-/

theorem retained_mass_of_boundary_fraction
    {ε root boundary : ℝ}
    (hboundary : boundary ≤ ε * root) :
    (1 - ε) * root ≤ root - boundary := by
  linarith

theorem boundary_budget_to_leakage
    {q L ε : ℝ} {root boundary retained : Nat → ℝ}
    {stopped : Nat → ℝ}
    (hboundary : ∀ n, boundary n ≤ ε * root n)
    (hretained : ∀ n, retained n = root n - boundary n)
    (hroot : ∀ n, (1 - q) * L * q ^ n ≤ (1 - ε) * root n)
    (hincrement : ∀ n, retained n ≤ stopped (n + 1) - stopped n) :
    ∀ n, (1 - q) * L * q ^ n ≤ stopped (n + 1) - stopped n := by
  intro n
  have hretain : (1 - ε) * root n ≤ retained n := by
    rw [hretained n]
    exact retained_mass_of_boundary_fraction (hboundary n)
  linarith [hroot n, hincrement n]

theorem boundary_budget_to_qStar_certificate
    {L ε : ℝ} {root boundary retained : Nat → ℝ}
    {stopped : Nat → ℝ}
    (hzero : 0 ≤ stopped 0)
    (hboundary : ∀ n, boundary n ≤ ε * root n)
    (hretained : ∀ n, retained n = root n - boundary n)
    (hroot : ∀ n,
      (1 - F3ReturnExcursionM0BReal.qStar) * L *
          F3ReturnExcursionM0BReal.qStar ^ n ≤
        (1 - ε) * root n)
    (hincrement : ∀ n, retained n ≤ stopped (n + 1) - stopped n) :
    ∀ n,
      L * (1 - F3ReturnExcursionM0BReal.qStar ^ n) ≤
        stopped n := by
  apply F3RenewalInterface.qStar_leakage_certificate_lower_bound hzero
  exact boundary_budget_to_leakage hboundary hretained hroot hincrement

end F3BoundaryLeakage
end KL2003
end CollatzClassical
