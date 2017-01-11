// MealPlan by Chirag Gupta

import XCTest

@testable import MealPlan

class MealsModelTests: XCTestCase {
    var mealsModel: MealsModel!
    let defaults = MockUserDefaults()

    override func setUp() {
        super.setUp()

        mealsModel = MealsModel(userDefaults: defaults)
    }

    func testGetMealsWhenDefaultsAreNotSet() {
        XCTAssertEqual([], mealsModel.getMeals(), "meals should be empty")
    }

    func testGetMealsWhenDefaultsAreSet() {
        defaults.set(["foo", "bar"], forKey: "Meals")
        let expectedMeals = [Meal(title: "foo"), Meal(title: "bar")]

        XCTAssertEqual(expectedMeals, mealsModel.getMeals(), "meals should be foo and bar")
    }

    func testGetMealsWhenDefaultsAreSetToInvalidType() {
        defaults.set(["foo": "bar"], forKey: "Meals")

        XCTAssertEqual([], mealsModel.getMeals(), "meals should be empty")
    }

    func testAddFirstMeal() {
        let meal = Meal(title: "foo")
        mealsModel.add(meal: meal)

        let updatedMeals = mealsModel.getMeals()

        XCTAssertEqual(1, updatedMeals.count)
        XCTAssertTrue(updatedMeals.contains(meal), "foo was not added")
    }

    func testAddSecondMeal() {
        let meal1 = Meal(title: "foo")
        let meal2 = Meal(title: "bar")

        mealsModel.add(meal: meal1)
        mealsModel.add(meal: meal2)

        let updatedMeals = mealsModel.getMeals()

        XCTAssertEqual(2, updatedMeals.count)
        XCTAssertTrue(updatedMeals.contains(meal1), "foo was not added")
        XCTAssertTrue(updatedMeals.contains(meal2), "bar was not added")

    }
}
