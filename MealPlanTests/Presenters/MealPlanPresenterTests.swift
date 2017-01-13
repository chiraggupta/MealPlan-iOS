// MealPlan by Chirag Gupta

import XCTest

@testable import MealPlan

class MockMealPlanView: MealPlanViewType {
    private(set) fileprivate var setCalled = false
    private(set) fileprivate var setArguments = [MealPlanViewData]()

    func set(mealPlanViewData: [MealPlanViewData]) {
        setCalled = true
        setArguments = mealPlanViewData
    }
}

class MealPlanPresenterTests: XCTestCase {
    private var presenter: MealPlanPresenter!
    private let view = MockMealPlanView()
    private var model: WeeklyMealPlanProvider!

    override func setUp() {
        super.setUp()

        model = WeeklyMealPlanModel(userDefaults: MockUserDefaults())
        model.select(meal: Meal(title: "foo_meal"), day: .monday)
        model.select(meal: Meal(title: "bar_meal"), day: .wednesday)
        model.select(meal: Meal(title: "baz_meal"), day: .saturday)

        presenter = MealPlanPresenter(view: view, model: model)
    }

    func testUpdateMealPlanSetsMealPlanViewData() {
        let expectedViewData = [
            MealPlanViewData(day: "Monday", title: "foo_meal"),
            MealPlanViewData(day: "Tuesday", title: ""),
            MealPlanViewData(day: "Wednesday", title: "bar_meal"),
            MealPlanViewData(day: "Thursday", title: ""),
            MealPlanViewData(day: "Friday", title: ""),
            MealPlanViewData(day: "Saturday", title: "baz_meal"),
            MealPlanViewData(day: "Sunday", title: "")
        ]

        presenter.updateMealPlan()

        XCTAssertTrue(view.setCalled, "view meals were not set")
        XCTAssertEqual(expectedViewData, view.setArguments, "incorrect meals were set")
    }
}
