//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 05.01.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {

    let questionsAmount: Int = 10

    private weak var controller: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?

    private var currentQuestion: QuizQuestion? = nil
    private var currentQuestionIndex = 0
    private var correctAnswersPrivate = 0

    init (controller: MovieQuizViewController) {
        self.controller = controller
        questionFactory = QuestionFactoryImdb(
            moviesLoader: MoviesLoader(networkClient: NetworkClient()))
        questionFactory?.setDelegate(delegate: controller)
        statisticService = StatisticServiceUserDefaults()
    }

    var correctAnswers: Int {
        get {
            correctAnswersPrivate
        }
    }

    func startGame() {
        questionFactory?.loadData()
    }

    func restartGame() {
        currentQuestionIndex = 0
        correctAnswersPrivate = 0
    }

    func yesButtonClicked() {
        didAnswer(correctAnswer: true, currentQuestion: currentQuestion)
    }

    func noButtonClicked() {
        didAnswer(correctAnswer: false, currentQuestion: currentQuestion)
    }

    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.controller?.show(quiz: self.convert(model: self.currentQuestion!))
        }
    }

    func requestNextQuestion() {
        questionFactory?.requestNextQuestion()
    }

    func createErrorAlertModel(message: String) -> AlertModel {
        AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") {
            }
    }

    private func showAnswerResult(isCorrect: Bool) {
        controller?.setEnabled(isEnable: false)
        if isCorrect {
            correctAnswersPrivate += 1
            controller?.highlightResult(isCorrect: isCorrect)
        }
        else {
            controller?.highlightResult(isCorrect: isCorrect)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        controller?.setEnabled(isEnable: true)
        if currentQuestionIndex == (questionsAmount - 1) {
            saveStat()
            controller?.show(quiz: createFinalAlertModel(stat: statisticService))
        } else {
            currentQuestionIndex += 1
            requestNextQuestion()
        }
    }

    private func saveStat() {
        guard let stat = statisticService else { return }
        stat.store(
            correct: correctAnswers,
            total: questionsAmount)
    }

    private func didAnswer(
        correctAnswer: Bool,
        currentQuestion: QuizQuestion?) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == correctAnswer)
    }

    private func createFinalAlertModel(stat: StatisticServiceProtocol?) -> AlertModel {
        return convert(model: createResultModel(stat: stat))
    }

    private func createTextResult(stat: StatisticServiceProtocol?) -> String {
        let currentResult =
            "Ваш результат: \(correctAnswersPrivate) из \(questionsAmount)"
        guard let stat = stat else {
            return currentResult
        }
        let accuracy = "\(String(format: "%.2f", stat.totalAccuracy))"
        return """
        \(currentResult)
        Количество сыгранных квизов: \(stat.gamesCount)
        Рекорд: \(stat.bestGame.toString())
        Средняя точность: \(accuracy)%
        """
    }

    private func createResultModel(stat: StatisticServiceProtocol?) -> QuizResultsViewModel {
        return QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: createTextResult(stat: stat),
            buttonText: "Сыграть ещё раз")
    }

    private func convert(model: QuizResultsViewModel) -> AlertModel {
        return AlertModel(
            title: model.title,
            message: model.text,
            buttonText: model.buttonText) { [weak self] in
                self?.requestNextQuestion()
            }
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

}
