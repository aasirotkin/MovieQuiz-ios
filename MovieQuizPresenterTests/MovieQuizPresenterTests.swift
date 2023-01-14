//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Александр Сироткин on 14.01.2023.
//

@testable import MovieQuiz

import XCTest

final class MovieQuizPresenterTests: XCTestCase {

    func testPresenterConvertModel() throws {
        let controller = MovieQuizViewControllerProtocolMock()
        let presenter = MovieQuizPresenter(controller: controller)

        let emptyData = Data()
        let question = QuizQuestion(
            image: emptyData, text: "text", correctAnswer: true)

        let model = presenter.convert(model: question)

        XCTAssertNotNil(model.image)
        XCTAssertEqual(model.question, "text")
        XCTAssertEqual(model.questionNumber, "1/10")
    }

}
