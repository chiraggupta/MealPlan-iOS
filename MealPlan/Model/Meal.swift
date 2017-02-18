// MealPlan by Chirag Gupta

import Foundation

struct Meal: Equatable {
    let name: String
}

func == (lhs: Meal, rhs: Meal) -> Bool {
    return lhs.name == rhs.name
}
