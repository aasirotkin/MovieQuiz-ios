//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Александр Сироткин on 02.01.2023.
//

import XCTest

@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }

    func testYesButtonClicked() {
        buttonClickedTest(buttonName: UINamesHelper.buttonYes.rawValue)
    }

    func testNoButtonClicked() {
        buttonClickedTest(buttonName: UINamesHelper.buttonNo.rawValue)
    }

    func testResultedAlertAppeared() {
        for _ in 0..<MovieQuizConstants.questionsAmount {
            app.buttons[UINamesHelper.buttonYes.rawValue].tap()
            sleep(2)
        }
        sleep(3)
        let alert = app.alerts[UINamesHelper.resultedAlert.rawValue]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(
            alert.label == UINamesHelper.resultedAlertFinalTitleText.rawValue)
        XCTAssertTrue(
            alert.buttons.firstMatch.label ==
            UINamesHelper.resultedAlertFinalButtonText.rawValue)
    }

    func testStartNewQuiz() {
        for _ in 0..<MovieQuizConstants.questionsAmount {
            app.buttons[UINamesHelper.buttonYes.rawValue].tap()
            sleep(2)
        }
        sleep(3)
        let alertBefore = app.alerts[UINamesHelper.resultedAlert.rawValue]
        XCTAssertTrue(alertBefore.exists)
        alertBefore.buttons.firstMatch.tap()
        let alertAfter = app.alerts[UINamesHelper.resultedAlert.rawValue]
        XCTAssertFalse(alertAfter.exists)
        let indexLabel = app.staticTexts[UINamesHelper.indexLabel.rawValue]
        let labelText = UINamesHelper.indexLabelInitialText.rawValue
        XCTAssertTrue(indexLabel.label == labelText)
    }

    private func buttonClickedTest(buttonName: String) {
        let posterBefore = app.images[UINamesHelper.previewImage.rawValue]
        app.buttons[buttonName].tap()
        let posterAfter = app.images[UINamesHelper.previewImage.rawValue]
        let indexLabel = app.staticTexts[UINamesHelper.indexLabel.rawValue]
        sleep(3)
        XCTAssertFalse(posterBefore == posterAfter)
        let labelText = UINamesHelper.indexLabelTextAfterFirstAnswer.rawValue
        XCTAssertTrue(indexLabel.label == labelText)
    }

}
