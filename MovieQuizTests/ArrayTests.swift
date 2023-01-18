//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Александр Сироткин on 02.01.2023.
//

import XCTest

@testable import MovieQuiz

class TestArray : XCTestCase {

    func testGetValueInRange() {
        let arr = [1, 2, 3, 4, 5]
        for i in 0..<arr.count {
            let value = arr[safe: i]
            XCTAssertNotNil(value)
        }
    }

    func testGetValueOutOfRange() {
        let arr = [1, 2, 3, 4, 5]
        let value = arr[safe: arr.count]
        XCTAssertNil(value)
    }

}
