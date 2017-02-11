// MealPlan by Chirag Gupta

import Foundation
import CoreData

protocol MealsProvider {
    func getMeals() -> [Meal]
    func add(meal: Meal) -> Bool
    func remove(meal: Meal)
}

struct MealsModel: MealsProvider {
    let contextProvider: ContextProviding
    fileprivate var context: NSManagedObjectContext {
        return contextProvider.mainContext
    }

    init(contextProvider: ContextProviding = NSPersistentContainer.make()) {
        self.contextProvider = contextProvider
    }

    func getMeals() -> [Meal] {
        let meals = getStoredMeals()

        return meals
            .flatMap { $0.name }
            .map { Meal(name: $0) }
    }

    func add(meal: Meal) -> Bool {
        if getStoredMeal(name: meal.name) != nil {
            return false
        }

        let newMeal = MealEntity(context: context)
        newMeal.name = meal.name

        Storage.saveContext(context)
        return true
    }

    func remove(meal: Meal) {
        guard let mealEntity = getStoredMeal(name: meal.name) else {
            return
        }

        context.delete(mealEntity)
        Storage.saveContext(context)
    }
}

// MARK: Fetch request methods
extension MealsModel {
    fileprivate func getStoredMeals() -> [MealEntity] {
        return Storage.fetch(MealEntity.fetchRequest(), context: context)
    }

    fileprivate func getStoredMeal(name: String) -> MealEntity? {
        let request: NSFetchRequest<MealEntity> = MealEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1

        return Storage.fetch(request, context: context).first
    }
}
