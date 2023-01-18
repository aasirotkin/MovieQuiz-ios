//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Александр Сироткин on 02.01.2023.
//

import XCTest

@testable import MovieQuiz

class MoviesLoaderTests : XCTestCase {

    func testSuccessLoading() throws {
        let networkClient = StubNetworkClient(isSuccess: true)
        let movieLoader = MoviesLoader(networkClient: networkClient)
        let expectation = expectation(description: "Loading movies expectation")
        movieLoader.loadMovies() { result in
            switch result {
            case .success(let movies):
                XCTAssertFalse(movies.items.isEmpty)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }

    func testFailureLoading() throws {
        let networkClient = StubNetworkClient(isSuccess: false)
        let movieLoader = MoviesLoader(networkClient: networkClient)
        let expectation = expectation(description: "Loading movies expectation")
        movieLoader.loadMovies() { result in
            switch result {
            case .success(_):
                XCTFail("Unexpected success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
    }

}
