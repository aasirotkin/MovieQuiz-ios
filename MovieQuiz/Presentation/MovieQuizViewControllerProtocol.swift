//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 09.01.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {

    func show(quiz step: QuizStepViewModel)

    func show(quiz result: QuizResultsViewModel)

    func showProgress(isShown: Bool)

    func showError(message: String)

    func setEnabled(isEnable: Bool)

    func highlightResult(isCorrect: Bool)

}
