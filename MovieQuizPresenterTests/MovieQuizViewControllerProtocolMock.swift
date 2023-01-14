//
//  MovieQuizViewControllerProtocolMock.swift
//  MovieQuizPresenterTests
//
//  Created by Александр Сироткин on 14.01.2023.
//

@testable import MovieQuiz

class MovieQuizViewControllerProtocolMock : MovieQuizViewControllerProtocol {

    func show(quiz step: MovieQuiz.QuizStepViewModel) {
    }

    func show(quiz result: MovieQuiz.QuizResultsViewModel) {
    }

    func showProgress(isShown: Bool) {
    }

    func showError(message: String) {
    }

    func setEnabled(isEnable: Bool) {
    }

    func highlightResult(isCorrect: Bool) {
    }

}
