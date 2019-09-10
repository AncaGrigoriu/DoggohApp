//
//  QuestionViewModelTest.swift
//  Doggoh-StarterTests
//
//  Created by Anca Grigoriu on 06/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import XCTest
@testable import Doggoh_Starter

class QuestionViewModelTest: XCTestCase {
    
    var expectedQuestion: Question!
    var expectedIndex = 8
    var expectedTotal = 17
    var sut: QuestionViewModel!
    
    override func setUp() {
        super.setUp()
        
        // Conditions
        expectedQuestion = QuestionsRepository.getQuestions()[0]
        //sut = system under test
        sut = QuestionViewModel(withQuestion: expectedQuestion, withIndex: expectedIndex, withTotal: expectedTotal)
    }
    
    func testContructor() {
        // Expectations
        XCTAssertEqual(sut.questionString, expectedQuestion.question, "Additional message")
        XCTAssertEqual(sut.counterString, "\(expectedIndex + 1)/\(expectedTotal)")
        XCTAssertEqual(sut.submitButtonString, "NEXT")
        XCTAssertEqual(sut.optionA, expectedQuestion.options[0])
        XCTAssertEqual(sut.optionB, expectedQuestion.options[1])
        XCTAssertEqual(sut.optionC, expectedQuestion.options[2])
        XCTAssertEqual(sut.optionD, expectedQuestion.options[3])
        XCTAssertEqual(sut.correctAnswer, expectedQuestion.answer)
    }
    
    func testConstructor_submitButtonFinish() {
        let expectedQuestion2 = QuestionsRepository.getQuestions()[0]
        let sut2 = QuestionViewModel(withQuestion: expectedQuestion2, withIndex: 16, withTotal: 17)
        
        XCTAssertEqual(sut2.submitButtonString, "FINISH")
    }

    func testIsCorrectAnswer() {
        XCTAssertTrue(sut.isCorrectAnswer(expectedQuestion.answer))
        XCTAssertFalse(sut.isCorrectAnswer("a" + expectedQuestion.answer + "b"))
        XCTAssertFalse(sut.isCorrectAnswer(expectedQuestion.answer.uppercased()))
    }

}
