import CollatzClassical.KL2003.F3ReturnExcursionExactCoreMatrix
import CollatzClassical.KL2003.F3ReturnExcursionChannelBounds

namespace CollatzClassical
namespace KL2003
namespace F3ExactCoreMatrix

noncomputable section

open F3ChannelBounds

theorem exact_channelWeight_zero_eq :
    channelWeight 0 = (25 / 81 : ℝ) := by
  simpa [channelWeight, rhoStar, alpha, channelWeightF3, rhoStarF3, alphaF3] using
    channelWeight_zero_eq

theorem exact_channelWeight_one_lower :
    (469 / 1000 : ℝ) ≤ channelWeight 1 := by
  simpa [channelWeight, rhoStar, alpha, channelWeightF3, rhoStarF3, alphaF3] using
    channelWeight_one_lower

theorem exact_channelWeight_two_lower :
    (13 / 50 : ℝ) ≤ channelWeight 2 := by
  simpa [channelWeight, rhoStar, alpha, channelWeightF3, rhoStarF3, alphaF3] using
    channelWeight_two_lower

end
end F3ExactCoreMatrix
end KL2003
end CollatzClassical
