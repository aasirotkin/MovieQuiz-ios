//
//  NetworkRouting.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 02.01.2023.
//

import Foundation

protocol NetworkRouting {

    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)

}
