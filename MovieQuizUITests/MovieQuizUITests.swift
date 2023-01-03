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

    func testYesButton() {
        testButtonsImpl(buttonName: UINamesHelper.ButtonYes.rawValue)
    }

    func testNoButton() {
        testButtonsImpl(buttonName: UINamesHelper.ButtonNo.rawValue)
    }

    func testResultedAlert() {
        for _ in 0..<MovieQuizConstants.questionsAmount {
            app.buttons[UINamesHelper.ButtonYes.rawValue].tap()
            sleep(2)
        }
        sleep(3)
        let alert = app.alerts[UINamesHelper.ResultedAlert.rawValue]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(
            alert.label == UINamesHelper.ResultedAlertFinalTitleText.rawValue)
        XCTAssertTrue(
            alert.buttons.firstMatch.label ==
            UINamesHelper.ResultedAlertFinalButtonText.rawValue)
    }

    func testButtonsImpl(buttonName: String) {
        let posterBefore = app.images[UINamesHelper.PreviewImage.rawValue]
        app.buttons[buttonName].tap()
        let posterAfter = app.images[UINamesHelper.PreviewImage.rawValue]
        let indexLabel = app.staticTexts[UINamesHelper.IndexLabel.rawValue]
        sleep(3)
        XCTAssertFalse(posterBefore == posterAfter)
        let labelText = UINamesHelper.IndexLabelTextAfterFirstAnswer.rawValue
        XCTAssertTrue(indexLabel.label == labelText)
    }

}
