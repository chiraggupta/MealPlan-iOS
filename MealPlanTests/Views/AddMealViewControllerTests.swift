// MealPlan by Chirag Gupta

import Quick
import Nimble
@testable import MealPlan

class AddMealViewControllerTests: QuickSpec {
    override func spec() {
        let contextProvider = FakeContextProvider()
        var subject: AddMealViewController!
        var presenter: MockAddMealPresenting!

        beforeEach {
            subject = AddMealFactory(contextProvider: contextProvider).instantiate()
            presenter = MockAddMealPresenting()
            subject.presenter = presenter

            subject.setAsRootViewController()
        }

        describe("meal name field changes") {
            beforeEach {
                subject.mealNameField.text = "blah"
                subject.mealNameChanged()
            }
            it("updates the presenter with new meal name") {
                expect(presenter.newMealName).to(equal("blah"))
            }
        }

        describe("tap on save") {
            beforeEach {
                subject.saveTapped(UIBarButtonItem())
            }
            it("passes it on to the presenter") {
                expect(presenter.saveTappedCalled).to(beTrue())
            }
        }

        describe("tap on cancel") {
            beforeEach {
                subject.cancelTapped(UIBarButtonItem())
            }
            it("passes it on to the presenter") {
                expect(presenter.cancelTappedCalled).to(beTrue())
            }
        }

        describe("save button state") {
            context("set to enabled") {
                beforeEach {
                    subject.setSaveButtonState(enabled: true)
                }
                it("enables the button") {
                    expect(subject.saveButton.isEnabled).to(beTrue())
                }
            }
            context("set to disabled") {
                beforeEach {
                    subject.setSaveButtonState(enabled: false)
                }
                it("disables the button") {
                    expect(subject.saveButton.isEnabled).to(beFalse())
                }
            }
        }
    }
}

// MARK: Test doubles
extension AddMealViewControllerTests {
    class MockAddMealPresenting: AddMealPresenting {
        private(set) var newMealName: String?
        func mealNameChanged(to newMealName: String) {
            self.newMealName = newMealName
        }

        private(set) var saveTappedCalled = false
        func saveTapped() {
            self.saveTappedCalled = true
        }

        private(set) var cancelTappedCalled = false
        func cancelTapped() {
            self.cancelTappedCalled = true
        }
    }
}