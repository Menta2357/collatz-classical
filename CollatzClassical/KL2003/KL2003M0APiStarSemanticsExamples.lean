import CollatzClassical.KL2003.KL2003M0APiStarSemantics

namespace CollatzClassical
namespace KL2003

#eval piStarList 1 20
#eval piStarList 2 20
#eval piStarList 5 50
#eval (List.range 30).map (fun i => let a := i + 1; (a, piStar a 100))

end KL2003
end CollatzClassical
