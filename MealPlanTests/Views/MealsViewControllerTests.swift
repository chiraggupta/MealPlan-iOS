// MealPlan by Chirag Gupta

import XCTest
@testable import MealPlan

class MealsViewControllerTests: XCTestCase {
    var subject: MealsViewController!
    var presenter: MockMealsPresenter!
    let initialMeals = [Meal(title: "foo_meal")]

    override func setUp() {
        super.setUp()

        subject = makeViewController(storyboard: "Main")
        presenter = MockMealsPresenter(view: subject, initialMeals: initialMeals)
        subject.presenter = presenter

        subject.display()
    }

    func testViewDidLoadCallsPresenterUpdateMeals() {
        XCTAssertTrue(presenter.updateMealsCalled)
    }

    func testCountOfMealsInList() {
        let count = subject.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(initialMeals.count, count, "meals count is incorrect")
    }

    func testMealsDisplayedInList() {
        for i in 0..<initialMeals.count {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = subject.tableView(subject.tableView, cellForRowAt: indexPath)

            XCTAssertEqual(initialMeals[i].title, cell.textLabel?.text, "meal \(i + 1) is incorrect")
        }
    }

    func testTappingAddShowsAddMealAlert() {
        subject.add(UIBarButtonItem())

        guard let alert = subject.presentedViewController as? UIAlertController else {
            XCTFail("alert not presented")
            return
        }

        XCTAssertEqual("Add Meal", alert.title, "alert title is incorrect")
    }

    func testSuccessfulAdd() {
        subject.addMealAlertCreator = MockAddMealAlertCreator(resultMealTitle: "bar_meal")
        subject.add(UIBarButtonItem())

        XCTAssertTrue(presenter.addMealCalled)
        XCTAssertEqual(Meal(title: "bar_meal"), presenter.addMealArgument)

        let newCount = subject.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(initialMeals.count + 1, newCount, "count should be one lesser")

        let secondRow = IndexPath(row: 1, section: 0)
        let newCell = subject.tableView(subject.tableView, cellForRowAt: secondRow)
        XCTAssertEqual("bar_meal", newCell.textLabel?.text, "should have the new meal")
    }

    func testAddSuccessHandlerTrimsMealText() {
        subject.addMealAlertCreator = MockAddMealAlertCreator(resultMealTitle: "  bar_meal  \t")
        subject.add(UIBarButtonItem())

        XCTAssertEqual(Meal(title: "bar_meal"), presenter.addMealArgument)
    }

    func testAddSuccessHandlerDoesNotAddMealsWithEmptyTitle() {
        subject.addMealAlertCreator = MockAddMealAlertCreator(resultMealTitle: "")
        subject.add(UIBarButtonItem())

        XCTAssertFalse(presenter.addMealCalled)
    }

    func testRemoveMeal() {
        let firstRow = IndexPath(row: 0, section: 0)
        subject.tableView(subject.tableView, commit: .delete, forRowAt: firstRow)

        XCTAssertTrue(presenter.removeMealCalled)

        let newCount = subject.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(initialMeals.count - 1, newCount, "count should be one lesser")
    }

    func testTappingDoneCallsPresenter() {
        subject.done(UIBarButtonItem())

        XCTAssertTrue(presenter.doneTappedCalled)
    }
}

// MARK: Test doubles
class MockMealsPresenter: MealsPresenting {
    fileprivate var updateMealsCalled = false
    fileprivate var addMealCalled = false
    fileprivate var addMealArgument: Meal?
    fileprivate var removeMealCalled = false
    fileprivate var doneTappedCalled = false

    let view: MealsViewType!
    var meals: [Meal]!

    init(view: MealsViewType, initialMeals: [Meal]) {
        self.view = view
        meals = initialMeals
    }

    func updateMeals() {
        updateMealsCalled = true
        view.set(meals: meals)
        view.reload()
    }

    func add(meal: Meal) {
        addMealCalled = true
        addMealArgument = meal
        meals.append(meal)
        updateMeals()
    }

    func remove(meal: Meal) {
        removeMealCalled = true
        if let mealToRemove = meals.index(of: meal) {
            meals.remove(at: mealToRemove)
        }
        view.set(meals: meals)
    }

    func doneTapped() {
        doneTappedCalled = true
    }
}

struct MockAddMealAlertCreator: AlertCreator {
    let resultMealTitle: String

    func create(successHandler: @escaping (String) -> Void) -> UIAlertController {
        successHandler(resultMealTitle)
        return UIAlertController()
    }
}
