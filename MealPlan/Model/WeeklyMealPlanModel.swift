// MealPlan by Chirag Gupta

import Foundation

typealias WeeklyMealPlan = [DayOfWeek: Meal]

protocol WeeklyMealPlanProvider {
    init(mealsModel: MealsProvider)
    func getWeeklyMealPlan() -> WeeklyMealPlan
}

struct WeeklyMealPlanModel: WeeklyMealPlanProvider {
    private let mealsModel: MealsProvider

    init(mealsModel: MealsProvider) {
        self.mealsModel = mealsModel
    }

    func getWeeklyMealPlan() -> WeeklyMealPlan {
        var meals = mealsModel.getMeals()
        var mealPlan = WeeklyMealPlan()

        for day in DayOfWeek.all {
            guard let meal = meals.first else {
                break
            }
            mealPlan[day] = meal
            meals.removeFirst()
        }

        return mealPlan
    }
}