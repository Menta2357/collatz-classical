import CollatzClassical.KL2003.F3ReturnExcursionM0BRealPilot

open Filter Topology

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3RenewalInterface

/-!
An explicit contract for the stopped-path part of the Real renewal argument.
The future F3 path construction must provide one `LeakageCertificate`; this
module then supplies the conversion to a stopped-mass lower bound.  Keeping
the leakage hypotheses in a structure prevents a numerical q from being
silently substituted for the missing path proof.
-/

structure LeakageCertificate (q L : ℝ) where
  stopped : Nat → ℝ
  q_nonneg : 0 ≤ q
  q_lt_one : q < 1
  stopped_zero_nonneg : 0 ≤ stopped 0
  leakage : ∀ n : Nat,
    (1 - q) * L * q ^ n ≤ stopped (n + 1) - stopped n

theorem LeakageCertificate.lower_bound
    {q L : ℝ} (certificate : LeakageCertificate q L) (n : Nat) :
    L * (1 - q ^ n) ≤ certificate.stopped n := by
  exact F3ReturnExcursionM0BReal.renewal_conversion_lower_bound_of_leakage
    certificate.stopped certificate.stopped_zero_nonneg certificate.leakage n

theorem LeakageCertificate.limit_lower_bound
    {q L : ℝ} (certificate : LeakageCertificate q L) :
    Tendsto (fun n : Nat => L * (1 - q ^ n)) atTop (𝓝 L) := by
  exact F3ReturnExcursionM0BReal.renewal_conversion_limit
    certificate.q_nonneg certificate.q_lt_one

theorem qStar_leakage_certificate_lower_bound
    {L : ℝ} {stopped : Nat → ℝ}
    (hzero : 0 ≤ stopped 0)
    (hleak : ∀ n : Nat,
      (1 - F3ReturnExcursionM0BReal.qStar) * L *
          F3ReturnExcursionM0BReal.qStar ^ n ≤
        stopped (n + 1) - stopped n) :
    ∀ n : Nat,
      L * (1 - F3ReturnExcursionM0BReal.qStar ^ n) ≤ stopped n := by
  intro n
  exact LeakageCertificate.lower_bound
    { stopped := stopped
      q_nonneg := F3ReturnExcursionM0BReal.qStar_nonneg
      q_lt_one := F3ReturnExcursionM0BReal.qStar_lt_one
      stopped_zero_nonneg := hzero
      leakage := hleak } n

end F3RenewalInterface
end KL2003
end CollatzClassical
