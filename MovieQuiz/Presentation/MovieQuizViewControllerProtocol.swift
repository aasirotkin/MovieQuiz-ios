//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 09.01.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {

    func show(quiz step: QuizStepViewModel)

    func show(quiz alertModel: AlertModel)

    func setEnabled(isEnable: Bool)

    func highlightResult(isCorrect: Bool)

}
