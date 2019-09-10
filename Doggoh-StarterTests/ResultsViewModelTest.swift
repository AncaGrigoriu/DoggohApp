//
//  ResultsViewModelTest.swift
//  Doggoh-StarterTests
//
//  Created by Anca Grigoriu on 08/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import XCTest
@testable import Doggoh_Starter

class ResultsViewModelTest: XCTestCase {
    
    func testConstructor() {
        let expectedScoreString = "10"
        let expectedTotalScoreString = "/10"
        
        let sut = ResultsViewModel(score: 10, total: 10)
        XCTAssertEqual(sut.scoreString, expectedScoreString)
        XCTAssertEqual(sut.totalScoreString, expectedTotalScoreString)
    }

}
