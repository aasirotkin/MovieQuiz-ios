//
//  QuestionFactoryImdb.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 13.12.2022.
//

import Foundation

class QuestionFactoryImdb : QuestionFactoryProtocol {

    private let moviesLoader: MoviesLoader
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []

    init(moviesLoader: MoviesLoader) {
        self.moviesLoader = moviesLoader
    }

    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let question = self.createQuestion()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(question: question)
            }
        }
    }

    func setDelegate(delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }

    func loadData() {
        if movies.isEmpty {
            loadDataFirstTime()
        }
        else {
            self.delegate?.didLoadDataFromServer()
        }
    }

    private func loadDataFirstTime() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }

    private enum CompareType : String, CaseIterable {
        case more = "больше чем"
        case less = "меньше чем"
        case equal = "равен"
        case notMore = "не больше"
        case notLess = "не меньше"
        case notEqual = "не равен"
    }

    private func createQuestion() -> QuizQuestion? {
        let index = (0..<self.movies.count).randomElement() ?? 0
        guard let movie = self.movies[safe: index] else { return nil }
        var imageData = Data()
        do {
            imageData = try Data(contentsOf: movie.resizedImageURL)
        } catch {
            print("Failed to load image")
        }
        let rating = Float(movie.rating) ?? 0
        let compareType = CompareType.allCases.randomElement()!
        let randomRating = Float((2...9).randomElement()!)
        let text = "Рейтинг этого фильма \(compareType.rawValue) \(randomRating)?"
        let correctAnswer = getCompareResult(
            compareType: compareType,
            rating: rating,
            randomRating: randomRating)
        return QuizQuestion(image: imageData,
                            text: text,
                            correctAnswer: correctAnswer)
    }

    private func getCompareResult(
        compareType: CompareType, rating: Float, randomRating: Float) -> Bool {
        switch(compareType) {
        case .more:
            return rating > randomRating
        case .less:
            return rating < randomRating
        case .equal:
            return rating == randomRating
        case .notMore:
            return rating <= randomRating
        case .notLess:
            return rating >= randomRating
        case .notEqual:
            return rating != randomRating
        }
    }

}
