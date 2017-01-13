// MealPlan by Chirag Gupta

import Foundation

protocol SelectMealPresenterType {
    func loadMeals()
    func select(mealTitle: String)
}

class SelectMealPresenter: SelectMealPresenterType {
    let view: SelectMealViewType!
    let mealsProvider: MealsProvider!
    let mealPlanProvider: WeeklyMealPlanProvider!
    let day: DayOfWeek

    init(day: DayOfWeek,
         view: SelectMealViewType,
         mealPlanProvider: WeeklyMealPlanProvider = WeeklyMealPlanModel(),
         mealsProvider: MealsProvider = MealsModel()) {
        self.day = day
        self.view = view
        self.mealsProvider = mealsProvider
        self.mealPlanProvider = mealPlanProvider
    }

    func showTitle() {
        view.set(title: "Select meal for \(day.rawValue)")
    }

    func loadMeals() {
        let meals = mealsProvider.getMeals().map {$0.title}
        view.set(meals: meals)
    }

    func select(mealTitle: String) {
        let meal = Meal(title: mealTitle)
        if !mealsProvider.getMeals().contains(meal) {
            NSLog("ERROR: Invalid meal selected: \(mealTitle)")
            return
        }

        mealPlanProvider.select(meal: meal, day: day)
    }
}
