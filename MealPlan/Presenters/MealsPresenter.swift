// MealPlan by Chirag Gupta

import Foundation

protocol MealsPresenting {
    func updateMeals()
    func add(meal: Meal)
    func remove(meal: Meal)
    func doneTapped()
}

class MealsPresenter: MealsPresenting {
    unowned let view: MealsViewType
    fileprivate let model: MealsProvider

    init(view: MealsViewType, model: MealsProvider = MealsModel()) {
        self.view = view
        self.model = model
    }

    func updateMeals() {
        view.set(meals: model.getMeals())
        view.reload()
    }

    func add(meal: Meal) {
        model.add(meal: meal)
        updateMeals()
    }

    func remove(meal: Meal) {
        model.remove(meal: meal)
        view.set(meals: model.getMeals())
    }

    func doneTapped() {
        view.hideModal()
    }
}
